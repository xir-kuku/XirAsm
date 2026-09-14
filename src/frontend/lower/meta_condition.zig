const std = @import("std");

const expr = @import("../expr.zig");
const module_mod = @import("../module.zig");
const target = @import("../target.zig");
const contracts = @import("contracts.zig");
const context_mod = @import("context.zig");
const expression_bridge = @import("expression_bridge.zig");

const ActiveOutput = contracts.ActiveOutput;
const LowerContext = context_mod.LowerContext;
const LowerError = contracts.LowerError;
const Allocator = std.mem.Allocator;

pub const Callbacks = struct {
    eval_boolean_at_context: *const fn (*module_mod.Module, *LowerContext, ActiveOutput, *const expr.Node) LowerError!bool,
    eval_integer_at_context: *const fn (*module_mod.Module, *LowerContext, ActiveOutput, *const expr.Node) LowerError!u64,
};

pub fn evaluate(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    condition: []const u8,
    callbacks: Callbacks,
) LowerError!bool {
    const trimmed = std.mem.trim(u8, condition, " \t\r\n");
    if (trimmed.len == 0) return error.InvalidMetaIf;

    if (parseBoolLiteral(trimmed)) |value| return value;

    if (std.mem.startsWith(u8, trimmed, "defined(")) {
        const name = try parseNameCallArg(trimmed, "defined");
        return context_mod.lookupLocalValue(context, name) != null or
            module.symbols.lookup(name) != null or
            module.lookupTypeName(name) != null;
    }

    if (try evalTargetCondition(module, context, active, trimmed, callbacks)) |value| return value;

    const allocator = module.allocator;
    if (context.condition_cache.getPtr(trimmed)) |cached| {
        // The pointer is copied out of the map before evaluating: a nested insert
        // can rehash it, but it cannot move the tree the pointer names.
        const tree = cached.*;
        return evalConditionNode(module, context, active, callbacks, tree);
    }

    var condition_expr = expr.parseOwned(allocator, trimmed) catch |err| return mapMetaConditionParseError(err);
    const result = evalConditionNode(module, context, active, callbacks, &condition_expr) catch |err| {
        condition_expr.deinit(allocator);
        return err;
    };
    // Ownership of the tree moves into the cache at this call; it either stores
    // the tree or releases it, so nothing here may touch it afterwards.
    try storeCondition(allocator, context, trimmed, &condition_expr);
    return result;
}

/// Evaluates one parsed condition. The node is const: a cached tree is shared by
/// every execution of its statement, so nothing may write to it.
fn evalConditionNode(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    callbacks: Callbacks,
    node: *const expr.Node,
) LowerError!bool {
    return callbacks.eval_boolean_at_context(module, context, active, node) catch |err| switch (err) {
        error.InvalidExpression => error.InvalidMetaIf,
        else => |other| other,
    };
}

/// Moves a freshly parsed tree into the condition cache.
///
/// Ownership transfers at this call: on every path, including both allocation
/// failures, the tree is either stored or deinitialized exactly once, so the
/// caller must not use it afterwards. A tree already cached for the same text
/// wins — reachable when evaluating one condition re-enters this file with an
/// identical text — and the newer tree is then released rather than replacing
/// the first one, which would leak it.
fn storeCondition(
    allocator: Allocator,
    context: *LowerContext,
    text: []const u8,
    parsed: *expr.Node,
) error{OutOfMemory}!void {
    // The tree is moved into its own allocation before the map is touched, so a
    // failure at any later step cannot leave a stored key with no value behind.
    const stored = allocator.create(expr.Node) catch |err| {
        parsed.deinit(allocator);
        return err;
    };
    stored.* = parsed.*;

    const owned_key = allocator.dupe(u8, text) catch |err| {
        stored.deinit(allocator);
        allocator.destroy(stored);
        return err;
    };
    const entry = context.condition_cache.getOrPut(allocator, owned_key) catch |err| {
        allocator.free(owned_key);
        stored.deinit(allocator);
        allocator.destroy(stored);
        return err;
    };
    if (entry.found_existing) {
        allocator.free(owned_key);
        stored.deinit(allocator);
        allocator.destroy(stored);
        return;
    }
    entry.value_ptr.* = stored;
}

fn mapMetaConditionParseError(err: expr.ExpressionError) LowerError {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        error.ExpressionNestingTooDeep => error.ExpressionNestingTooDeep,
        error.NestingTooDeep => error.NestingTooDeep,
        error.InvalidToken,
        error.InvalidCharacter,
        error.InvalidNumber,
        error.UnexpectedEof,
        => error.UnknownMetaCondition,
        error.DivisionByZero,
        error.FragmentTooLarge,
        error.InvalidApiArgument,
        error.InvalidApiInteger,
        error.InvalidIntegerBits,
        error.InvalidArgument,
        error.InvalidType,
        error.FileNotAvailable,
        error.InvalidOperand,
        error.InvalidFragment,
        error.InvalidSection,
        error.MissingEvaluationContext,
        error.MissingStructFieldValue,
        error.OffsetOverflow,
        error.TypeMismatch,
        error.UndefinedSymbol,
        error.UnknownTypeName,
        error.UnknownField,
        => expression_bridge.mapExpressionError(err),
    };
}

fn parseBoolLiteral(text: []const u8) ?bool {
    if (std.mem.eql(u8, text, "true")) return true;
    if (std.mem.eql(u8, text, "false")) return false;
    return null;
}

fn parseNameCallArg(text: []const u8, name: []const u8) LowerError![]const u8 {
    if (!std.mem.startsWith(u8, text, name)) return error.InvalidMetaIf;
    var rest = std.mem.trim(u8, text[name.len..], " \t");
    if (rest.len < 2 or rest[0] != '(' or rest[rest.len - 1] != ')') return error.InvalidMetaIf;
    rest = std.mem.trim(u8, rest[1 .. rest.len - 1], " \t");
    if (rest.len == 0) return error.InvalidMetaIf;

    if (rest.len >= 2 and rest[0] == '"' and rest[rest.len - 1] == '"') {
        const unquoted = rest[1 .. rest.len - 1];
        if (!isMetaName(unquoted)) return error.InvalidMetaIf;
        return unquoted;
    }

    if (!isMetaName(rest)) return error.InvalidMetaIf;
    return rest;
}

fn evalTargetCondition(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    condition: []const u8,
    callbacks: Callbacks,
) LowerError!?bool {
    const comparison = splitComparison(condition) orelse return null;
    if (std.mem.eql(u8, comparison.left, "target.bits") or
        std.mem.eql(u8, comparison.left, "target.xlen"))
    {
        var expected_expression = expr.parseOwned(module.allocator, comparison.right) catch |err| return expression_bridge.mapExpressionError(err);
        defer expected_expression.deinit(module.allocator);
        const expected_bits = try callbacks.eval_integer_at_context(module, context, active, &expected_expression);
        const active_bits = active.target.bits() orelse return error.InvalidMetaIf;
        const is_equal = active_bits == expected_bits;
        return if (comparison.equal) is_equal else !is_equal;
    }

    if (std.mem.eql(u8, comparison.left, "target.isa")) {
        const expected_isa = try parseIsaLiteral(comparison.right);
        const is_equal = active.target.isa() == expected_isa;
        return if (comparison.equal) is_equal else !is_equal;
    }

    return null;
}

const Comparison = struct {
    left: []const u8,
    right: []const u8,
    equal: bool,
};

fn splitComparison(condition: []const u8) ?Comparison {
    if (std.mem.indexOf(u8, condition, "==")) |index| {
        return .{
            .left = std.mem.trim(u8, condition[0..index], " \t"),
            .right = std.mem.trim(u8, condition[index + 2 ..], " \t"),
            .equal = true,
        };
    }
    if (std.mem.indexOf(u8, condition, "!=")) |index| {
        return .{
            .left = std.mem.trim(u8, condition[0..index], " \t"),
            .right = std.mem.trim(u8, condition[index + 2 ..], " \t"),
            .equal = false,
        };
    }
    return null;
}

fn parseIsaLiteral(text: []const u8) LowerError!target.Isa {
    var trimmed = std.mem.trim(u8, text, " \t");
    if (trimmed.len >= 2 and trimmed[0] == '"' and trimmed[trimmed.len - 1] == '"') {
        trimmed = trimmed[1 .. trimmed.len - 1];
    } else if (trimmed.len >= 2 and trimmed[0] == '.') {
        trimmed = trimmed[1..];
    }

    if (std.mem.eql(u8, trimmed, "x86_64")) return .x86_64;
    if (std.mem.eql(u8, trimmed, "riscv64")) return .riscv64;
    if (std.mem.eql(u8, trimmed, "spirv")) return .spirv;
    return error.InvalidMetaIf;
}

fn isMetaName(text: []const u8) bool {
    if (text.len == 0) return false;
    if (!(std.ascii.isAlphabetic(text[0]) or text[0] == '_' or text[0] == '.')) return false;
    for (text[1..]) |byte| {
        if (!(std.ascii.isAlphanumeric(byte) or byte == '_' or byte == '.' or byte == '$')) return false;
    }
    return true;
}

/// Stores one condition into a fresh cache. A new context per call is what makes
/// this idempotent for `checkAllAllocationFailures`: the cache is state, and the
/// injector calls the function once per allocation index.
fn storeConditionOnce(allocator: Allocator, text: []const u8) !void {
    var context: LowerContext = .{};
    defer context.deinit(allocator);

    var parsed = try expr.parseOwned(allocator, text);
    // Ownership moves into the cache; it either stores the tree or releases it.
    try storeCondition(allocator, &context, text, &parsed);
    try std.testing.expectEqual(@as(usize, 1), context.condition_cache.count());
}

test "condition cache handles every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, storeConditionOnce, .{"count > 0"});
}

test "condition cache keeps the first tree for a repeated text" {
    const allocator = std.testing.allocator;
    var context: LowerContext = .{};
    defer context.deinit(allocator);

    var first = try expr.parseOwned(allocator, "index < limit");
    try storeCondition(allocator, &context, "index < limit", &first);
    const stored_first = context.condition_cache.get("index < limit") orelse return error.TestUnexpectedResult;

    var second = try expr.parseOwned(allocator, "index < limit");
    try storeCondition(allocator, &context, "index < limit", &second);

    // The new tree was released and the entry still holds the first one, so the
    // cache neither grew nor lost the tree a caller may be walking.
    try std.testing.expectEqual(@as(usize, 1), context.condition_cache.count());
    const stored_again = context.condition_cache.get("index < limit") orelse return error.TestUnexpectedResult;
    try std.testing.expectEqual(stored_first, stored_again);
}

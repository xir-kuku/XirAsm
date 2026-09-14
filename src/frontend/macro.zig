const std = @import("std");
const ast = @import("ast.zig");
const expr = @import("expr.zig");
const identifier = @import("identifier.zig");
const meta_function = @import("meta_function.zig");
const module_mod = @import("module.zig");
const source = @import("source.zig");
const value = @import("value.zig");
const context_mod = @import("lower/context.zig");
const contracts = @import("lower/contracts.zig");

const Allocator = std.mem.Allocator;
const Context = context_mod.LowerContext;
const Error = contracts.LowerError;
const ActiveOutput = contracts.ActiveOutput;
pub const max_expansions = 100_000;
pub const max_call_depth = 128;
const max_operands = 256;
const max_nesting = 64;

pub const Store = struct {
    items: std.ArrayList(ast.MacroStatement) = .empty,

    pub fn deinit(self: *Store, allocator: Allocator) void {
        for (self.items.items) |*item| item.deinit(allocator);
        self.items.deinit(allocator);
    }

    pub fn contains(self: *const Store, name: []const u8) bool {
        for (self.items.items) |item| {
            if (std.mem.eql(u8, item.definition.name, name)) return true;
        }
        return false;
    }

    pub fn define(self: *Store, allocator: Allocator, declaration: ast.MacroStatement) Error!void {
        for (self.items.items) |item| {
            if (!std.mem.eql(u8, item.definition.name, declaration.definition.name)) continue;
            if ((item.variadic and declaration.variadic) or
                (!item.variadic and !declaration.variadic and item.definition.params.len == declaration.definition.params.len)) return error.DuplicateMacro;
        }
        var cloned: ast.MacroStatement = .{
            .definition = try meta_function.clone(allocator, declaration.definition),
            .variadic = declaration.variadic,
        };
        errdefer cloned.deinit(allocator);
        try self.items.append(allocator, cloned);
    }

    fn select(self: *const Store, name: []const u8, argc: usize) Error!usize {
        var variadic: ?usize = null;
        for (self.items.items, 0..) |item, index| {
            if (!std.mem.eql(u8, item.definition.name, name)) continue;
            if (!item.variadic and item.definition.params.len == argc) return index;
            if (item.variadic and argc >= item.definition.params.len - 1) variadic = index;
        }
        return variadic orelse error.MacroArityMismatch;
    }
};

pub const Callbacks = struct {
    lower_statements: *const fn (Allocator, *module_mod.Module, *ActiveOutput, *std.ArrayList(ActiveOutput), []const ast.Statement, *Context) Error!void,
};

pub fn dispatch(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    instruction: ast.IsaInstructionStatement,
    context: *Context,
    callbacks: Callbacks,
) Error!bool {
    const name_end = mnemonicEnd(instruction.text);
    const name = instruction.text[0..name_end];
    if (!context.macros.contains(name)) return false;
    if (context.value_function_depth != 0) return error.SideEffectInValueFunction;
    if (context.call_depth >= max_call_depth) return error.MetaCallDepthExceeded;
    if (context.macro_expansions >= max_expansions) return error.MacroExpansionLimitExceeded;
    const raw_args = try splitOperands(allocator, instruction.text[name_end..]);
    defer allocator.free(raw_args);
    const index = context.macros.select(name, raw_args.len) catch |err| {
        const message = try std.fmt.allocPrint(allocator, "MacroArityMismatch: macro '{s}' does not accept {d} operands", .{ name, raw_args.len });
        defer allocator.free(message);
        try module.diagnostics.add(allocator, .err, instruction.span, message);
        return err;
    };
    // Definition bodies are immutable and nested declarations are rejected.
    const declaration = context.macros.items.items[index];
    const function = declaration.definition;
    const previous_expansion = module.diagnostics.active_expansion;
    module.diagnostics.active_expansion = try module.diagnostics.beginExpansion(allocator, instruction.span, function.span, .macro);
    defer module.diagnostics.active_expansion = previous_expansion;
    const environment = try context_mod.captureOperandEnvironment(context, allocator, module);
    defer environment.release(allocator);
    environment.active_target = active.target;
    environment.active_section = active.section_id;
    environment.active_offset = active.offset;
    environment.active_file_offset = active.file_offset;
    const arguments = try allocator.alloc(value.Value, function.params.len);
    var initialized: usize = 0;
    defer {
        for (arguments[0..initialized]) |*argument| argument.deinit(allocator);
        allocator.free(arguments);
    }
    for (function.params, 0..) |_, arg_index| {
        if (declaration.variadic and arg_index + 1 == function.params.len) {
            const items = try allocator.alloc(value.Value, raw_args.len - arg_index);
            var count: usize = 0;
            errdefer {
                for (items[0..count]) |*item| item.deinit(allocator);
                allocator.free(items);
            }
            for (raw_args[arg_index..], 0..) |text, item_index| {
                items[item_index] = .{ .operand = try capture(allocator, context, environment, text) };
                count += 1;
            }
            arguments[arg_index] = .{ .list = .{ .items = items } };
        } else {
            arguments[arg_index] = .{ .operand = try capture(allocator, context, environment, raw_args[arg_index]) };
        }
        initialized += 1;
    }
    context.call_depth += 1;
    defer context.call_depth -= 1;
    context.macro_expansions += 1;
    const previous_loop = context.in_meta_loop;
    context.in_meta_loop = false;
    defer context.in_meta_loop = previous_loop;
    try context.scopes.append(allocator, .{});
    defer context_mod.discardLastScope(context, allocator);
    for (function.params, 0..) |param, arg_index| {
        try context_mod.defineLocalValue(context, allocator, param.name, arguments[arg_index], .@"const");
        arguments[arg_index] = .void;
    }
    try callbacks.lower_statements(allocator, module, active, output_stack, function.body, context);
    return true;
}

fn mnemonicEnd(text: []const u8) usize {
    var index: usize = 0;
    while (index < text.len and !std.ascii.isWhitespace(text[index]) and text[index] != '(') : (index += 1) {}
    return index;
}

pub fn splitOperands(allocator: Allocator, text: []const u8) Error![][]const u8 {
    var result: std.ArrayList([]const u8) = .empty;
    errdefer result.deinit(allocator);
    const trimmed = std.mem.trim(u8, text, " \t");
    if (trimmed.len == 0) return result.toOwnedSlice(allocator);
    var brackets: [max_nesting]u8 = undefined;
    var depth: usize = 0;
    var start: usize = 0;
    var cursor: usize = 0;
    while (cursor < trimmed.len) : (cursor += 1) {
        const byte = trimmed[cursor];
        switch (byte) {
            '"', '\'' => cursor = (try quotedEnd(trimmed, cursor)) - 1,
            '(', '[', '{' => {
                if (depth == brackets.len) return error.InvalidMacroOperands;
                brackets[depth] = byte;
                depth += 1;
            },
            ')', ']', '}' => {
                if (depth == 0) return error.InvalidMacroOperands;
                const expected: u8 = switch (byte) {
                    ')' => '(',
                    ']' => '[',
                    else => '{',
                };
                if (brackets[depth - 1] != expected) return error.InvalidMacroOperands;
                depth -= 1;
            },
            ',' => if (depth == 0) {
                try appendOperand(allocator, &result, trimmed[start..cursor]);
                start = cursor + 1;
            },
            ';', '\n', '\r' => return error.InvalidMacroOperands,
            else => {},
        }
    }
    if (depth != 0) return error.InvalidMacroOperands;
    try appendOperand(allocator, &result, trimmed[start..]);
    return result.toOwnedSlice(allocator);
}

fn appendOperand(allocator: Allocator, result: *std.ArrayList([]const u8), raw: []const u8) Error!void {
    const text = std.mem.trim(u8, raw, " \t");
    if (text.len == 0 or result.items.len >= max_operands) return error.InvalidMacroOperands;
    try result.append(allocator, text);
}

fn quotedEnd(text: []const u8, start: usize) Error!usize {
    const delimiter = text[start];
    var cursor = start + 1;
    while (cursor < text.len) : (cursor += 1) {
        if (text[cursor] == '\\') {
            if (cursor + 1 >= text.len) return error.InvalidMacroOperands;
            cursor += 1;
        } else if (text[cursor] == delimiter) {
            if (cursor + 1 < text.len and text[cursor + 1] == delimiter) {
                cursor += 1;
            } else return cursor + 1;
        }
    }
    return error.InvalidMacroOperands;
}

fn appendPiece(allocator: Allocator, pieces: *std.ArrayList(value.OperandPiece), environment: *value.OperandEnvironment, text: []const u8) Allocator.Error!void {
    if (text.len == 0) return;
    const owned = try allocator.dupe(u8, text);
    errdefer allocator.free(owned);
    try environment.retain();
    errdefer environment.release(allocator);
    try pieces.append(allocator, .{ .text = owned, .environment = environment });
}

fn capture(allocator: Allocator, context: *Context, environment: *value.OperandEnvironment, text: []const u8) Error!value.OperandValue {
    var pieces: std.ArrayList(value.OperandPiece) = .empty;
    errdefer {
        for (pieces.items) |*piece| piece.deinit(allocator);
        pieces.deinit(allocator);
    }
    var start: usize = 0;
    var cursor: usize = 0;
    while (cursor < text.len) {
        if (text[cursor] == '"' or text[cursor] == '\'') {
            cursor = try quotedEnd(text, cursor);
            continue;
        }
        if (!identifier.isStart(text[cursor]) or (cursor != 0 and identifier.isContinue(text[cursor - 1]))) {
            cursor += 1;
            continue;
        }
        const token_start = cursor;
        cursor += 1;
        while (cursor < text.len and identifier.isContinue(text[cursor])) : (cursor += 1) {}
        if (std.mem.eql(u8, text[token_start..cursor], "b") and cursor < text.len and text[cursor] == '"') continue;
        const local = context_mod.lookupLocalValue(context, text[token_start..cursor]) orelse continue;
        if (local.* != .operand) continue;
        try appendPiece(allocator, &pieces, environment, text[start..token_start]);
        for (local.operand.pieces) |piece| {
            var cloned = try piece.clone(allocator);
            errdefer cloned.deinit(allocator);
            try pieces.append(allocator, cloned);
        }
        start = cursor;
    }
    try appendPiece(allocator, &pieces, environment, text[start..]);
    return .{ .pieces = try pieces.toOwnedSlice(allocator) };
}

pub fn forwardNative(allocator: Allocator, context: *Context, module: *module_mod.Module, active: ActiveOutput, text: []const u8, callbacks: @import("lower/expression_bridge.zig").Callbacks) Error!?[]u8 {
    if (context.call_depth == 0 or context.macros.items.items.len == 0) return null;
    const end = mnemonicEnd(text);
    var cursor = end;
    var has_operand = false;
    while (cursor < text.len) {
        if (text[cursor] == '"' or text[cursor] == '\'') {
            cursor = try quotedEnd(text, cursor);
            continue;
        }
        if (!identifier.isStart(text[cursor])) {
            cursor += 1;
            continue;
        }
        const start = cursor;
        cursor += 1;
        while (cursor < text.len and identifier.isContinue(text[cursor])) : (cursor += 1) {}
        if (context_mod.lookupLocalValue(context, text[start..cursor])) |local| {
            if (local.* == .operand) has_operand = true;
        }
    }
    if (!has_operand) return null;
    const environment = try context_mod.captureOperandEnvironment(context, allocator, module);
    defer environment.release(allocator);
    environment.active_target = active.target;
    environment.active_section = active.section_id;
    environment.active_offset = active.offset;
    environment.active_file_offset = active.file_offset;
    var captured = try capture(allocator, context, environment, text[end..]);
    defer captured.deinit(allocator);
    var result: std.ArrayList(u8) = .empty;
    errdefer result.deinit(allocator);
    try result.appendSlice(allocator, text[0..end]);
    const captured_text = try captured.text(allocator);
    defer allocator.free(captured_text);
    const bridge = @import("lower/expression_bridge.zig");
    var eval_ctx = bridge.evalContext(module, context, .{ .target = active.target, .section_id = active.section_id, .offset = active.offset, .file_offset = active.file_offset }, callbacks);
    cursor = 0;
    while (@import("lower/isa_text.zig").findBuiltinCall(captured_text, cursor)) |range| {
        var prefix = try sliceOperand(allocator, captured, cursor, range.start);
        defer prefix.deinit(allocator);
        try appendNativePieces(allocator, &result, active, prefix);
        var call = try sliceOperand(allocator, captured, range.start, range.end);
        defer call.deinit(allocator);
        var evaluated = evaluateOperand(context, allocator, call, &eval_ctx) catch |err| return bridge.mapExpressionError(err);
        defer evaluated.deinit(allocator);
        const integer = evaluated.expectInteger() catch return error.InvalidExpression;
        const rendered = try std.fmt.allocPrint(allocator, "{d}", .{integer});
        defer allocator.free(rendered);
        try result.appendSlice(allocator, rendered);
        cursor = range.end;
    }
    var tail = try sliceOperand(allocator, captured, cursor, captured_text.len);
    defer tail.deinit(allocator);
    try appendNativePieces(allocator, &result, active, tail);
    return try result.toOwnedSlice(allocator);
}

fn appendNativePieces(allocator: Allocator, result: *std.ArrayList(u8), active: ActiveOutput, operand: value.OperandValue) Error!void {
    for (operand.pieces) |piece| {
        const prefixed = try std.fmt.allocPrint(allocator, "instruction {s}", .{piece.text});
        defer allocator.free(prefixed);
        const lowered = try @import("lower/isa_text.zig").substituteIntegerSymbols(allocator, active.target, prefixed, CapturedIntegerResolver{ .environment = piece.environment });
        defer allocator.free(lowered);
        try result.appendSlice(allocator, lowered["instruction ".len..]);
    }
}

const CapturedIntegerResolver = struct {
    environment: *const value.OperandEnvironment,

    pub fn resolve(self: CapturedIntegerResolver, name: []const u8) ?u64 {
        const entry = self.environment.capturedEntry(name) orelse return null;
        return if (entry.value == .integer) entry.value.integer.value else null;
    }
};

pub fn isOperandBuiltin(name: []const u8) bool {
    return std.mem.eql(u8, name, "operand.text") or std.mem.eql(u8, name, "operand.slice") or std.mem.eql(u8, name, "operand.eval") or std.mem.eql(u8, name, "operand.split");
}

pub fn splitValue(allocator: Allocator, operand: value.OperandValue) Error!value.Value {
    const text = try operand.text(allocator);
    defer allocator.free(text);
    const slices = try splitOperands(allocator, text);
    defer allocator.free(slices);
    const items = try allocator.alloc(value.Value, slices.len);
    var count: usize = 0;
    errdefer {
        for (items[0..count]) |*item| item.deinit(allocator);
        allocator.free(items);
    }
    for (slices, 0..) |slice, index| {
        // splitOperands returns only subslices of this owned text buffer.
        const start = @intFromPtr(slice.ptr) - @intFromPtr(text.ptr);
        items[index] = .{ .operand = try sliceOperand(allocator, operand, start, start + slice.len) };
        count += 1;
    }
    return .{ .list = .{ .items = items } };
}

pub fn sliceOperand(allocator: Allocator, operand: value.OperandValue, start: u64, end: u64) Error!value.OperandValue {
    var pieces: std.ArrayList(value.OperandPiece) = .empty;
    errdefer {
        for (pieces.items) |*piece| piece.deinit(allocator);
        pieces.deinit(allocator);
    }
    if (end < start) return error.InvalidApiArgument;
    var offset: u64 = 0;
    for (operand.pieces) |piece| {
        const next = std.math.add(u64, offset, piece.text.len) catch return error.InvalidApiArgument;
        if (start < next and end > offset) {
            const local_start: usize = @intCast(@max(start, offset) - offset);
            const local_end: usize = @intCast(@min(end, next) - offset);
            try appendPiece(allocator, &pieces, piece.environment, piece.text[local_start..local_end]);
        }
        offset = next;
    }
    if (end > offset) return error.InvalidApiArgument;
    return .{ .pieces = try pieces.toOwnedSlice(allocator) };
}

pub fn evaluateOperand(raw_context: *anyopaque, allocator: Allocator, operand: value.OperandValue, eval_ctx: *expr.EvalContext) expr.ExpressionError!value.Value {
    const context: *Context = @ptrCast(@alignCast(raw_context));
    if (operand.pieces.len == 0) return error.InvalidOperand;
    const environment = operand.pieces[0].environment;
    var captured_ctx = eval_ctx.*;
    captured_ctx.active_target = environment.active_target;
    captured_ctx.active_section = environment.active_section;
    captured_ctx.active_offset = environment.active_offset;
    captured_ctx.active_file_offset = environment.active_file_offset;
    const previous_scopes = context.scopes;
    context.scopes = .empty;
    defer {
        while (context.scopes.items.len != 0) context_mod.discardLastScope(context, allocator);
        context.scopes.deinit(allocator);
        context.scopes = previous_scopes;
    }
    try context.scopes.append(allocator, .{});
    // Function bodies see the captured environment; parameters subsequently
    // create their ordinary inner scope, and mixed templates use aliases per
    // piece.
    //
    // A capture reads its own locals first and the module-level bindings it was
    // taken with second, so both are defined here as ordinary locals: the
    // module-level ones first, skipping any that a local of the same name already
    // shadows, which is the single merged map this used to inject. Defining them
    // is also what keeps a nested capture made during evaluation reading the
    // values this capture saw rather than the module as it stands now.
    //
    // They are defined as *borrowed* locals: the snapshot and the capture's own
    // bindings already own a copy taken when the capture was made, so cloning
    // each entry again here only duplicates that copy — for every entry, on every
    // `operand.eval`, including whole generated tables. The snapshot is
    // refcounted and held by the capture, and nothing can write through a
    // `.@"const"` local, so the storage stays valid and unchanged for as long as
    // this evaluation reads it.
    for (environment.module_snapshot.entries.entries) |entry| {
        if (environment.bindings.entryByKey(entry.key) != null) continue;
        context_mod.defineBorrowedLocalValue(context, allocator, entry.key, entry.value, .@"const") catch |err| return @import("lower/expression_bridge.zig").mapLowerErrorToExpression(err);
    }
    for (environment.bindings.entries) |entry| {
        context_mod.defineBorrowedLocalValue(context, allocator, entry.key, entry.value, .@"const") catch |err| return @import("lower/expression_bridge.zig").mapLowerErrorToExpression(err);
    }
    var aliases: value.MapValue = .{ .entries = try allocator.alloc(value.MapEntry, 0) };
    defer aliases.deinit(allocator);
    const text = try operand.text(allocator);
    defer allocator.free(text);
    var missing: std.ArrayList([]const u8) = .empty;
    defer {
        for (missing.items) |name| allocator.free(name);
        missing.deinit(allocator);
    }
    var mapper: CapturedSymbolMapper = .{ .operand = operand, .aliases = &aliases, .missing = &missing, .module = eval_ctx.module };
    var parsed = try expr.parseOwnedWithSymbols(allocator, text, .{ .context = &mapper, .map = CapturedSymbolMapper.map });
    defer parsed.deinit(allocator);
    captured_ctx.undefined_symbols = missing.items;
    try context.scopes.append(allocator, .{});
    // The alias map is owned by this frame and is not touched again once parsing
    // has finished, so these locals borrow from it just as the two loops above do.
    for (aliases.entries) |entry| {
        context_mod.defineBorrowedLocalValue(context, allocator, entry.key, entry.value, .@"const") catch |err| return @import("lower/expression_bridge.zig").mapLowerErrorToExpression(err);
    }
    return expr.evaluateValue(allocator, &parsed, &captured_ctx);
}

const CapturedSymbolMapper = struct {
    operand: value.OperandValue,
    aliases: *value.MapValue,
    missing: *std.ArrayList([]const u8),
    module: *module_mod.Module,

    fn map(raw: *anyopaque, allocator: Allocator, name: []const u8, start: usize, allow_unbound: bool) expr.ExpressionError![]u8 {
        const self: *CapturedSymbolMapper = @ptrCast(@alignCast(raw));
        var offset: usize = 0;
        for (self.operand.pieces, 0..) |piece, index| {
            const end = std.math.add(usize, offset, piece.text.len) catch return error.InvalidOperand;
            defer offset = end;
            if (start >= end) continue;
            const entry = piece.environment.capturedEntry(name) orelse {
                if (allow_unbound or std.mem.eql(u8, name, "target") or self.module.lookupTypeName(name) != null) return allocator.dupe(u8, name);
                // Defer missing-value errors until evaluation to preserve
                // ordinary boolean short-circuiting.
                const missing = try std.fmt.allocPrint(allocator, "\x00macro_missing_{d}_{d}", .{ index, start });
                errdefer allocator.free(missing);
                const mapped = try allocator.dupe(u8, missing);
                errdefer allocator.free(mapped);
                try self.missing.append(allocator, missing);
                return mapped;
            };
            // These are AST-only names, deliberately outside source identifier
            // syntax so helper functions cannot observe a colliding binding.
            const alias = try std.fmt.allocPrint(allocator, "\x00macro_operand_{d}_{d}", .{ index, start });
            errdefer allocator.free(alias);
            self.aliases.setCloned(allocator, alias, entry.value) catch |err| return switch (err) {
                error.OutOfMemory => error.OutOfMemory,
                error.CollectionTooLarge => error.InvalidOperand,
            };
            return alias;
        }
        return error.InvalidOperand;
    }
};

test "macro operands retain balanced groups and quoted commas" {
    const allocator = std.testing.allocator;
    const operands = try splitOperands(allocator, " x0, [x1, #8]!, {v0.4s, v1.4s}, \"a,b\", (1 + f(2, 3)) ");
    defer allocator.free(operands);
    try std.testing.expectEqual(@as(usize, 5), operands.len);
    try std.testing.expectEqualStrings("[x1, #8]!", operands[1]);
    try std.testing.expectEqualStrings("{v0.4s, v1.4s}", operands[2]);
    try std.testing.expectEqualStrings("\"a,b\"", operands[3]);
}

test "macro operands reject empty malformed and terminated input" {
    for ([_][]const u8{ ",x", "x,", "x,,y", "([)]", "[x", "x]", "\"open", "x;", "x\ny" }) |text| {
        try std.testing.expectError(error.InvalidMacroOperands, splitOperands(std.testing.allocator, text));
    }
}

fn exerciseCore(allocator: Allocator) !void {
    var module = try @import("lower.zig").lowerSource(allocator,
        \\macro byte(value) {
        \\    const LIMIT: u64 = 99
        \\    emit.u8(operand.eval(value))
        \\}
        \\macro twice(value) {
        \\    byte value
        \\    byte value
        \\}
        \\const LIMIT: u64 = 7
        \\twice LIMIT + 1
        \\for i in range(0, 3) {
        \\    byte i
        \\}
    , .{});
    defer module.deinit();
    var result = try @import("../assembly.zig").assembleFlat(allocator, &module, null);
    defer result.deinit(allocator);
    try std.testing.expectEqualSlices(u8, &.{ 8, 8, 0, 1, 2 }, result.bytes);
}

test "macro captures forwards evaluates and emits native instructions" {
    try exerciseCore(std.testing.allocator);
}

test "macro core cleans up allocation failures" {
    var no_resize = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
    try std.testing.checkAllAllocationFailures(no_resize.allocator(), exerciseCore, .{});
}

fn expectBytes(input: []const u8, expected: []const u8) !void {
    var module = try @import("lower.zig").lowerSource(std.testing.allocator, input, .{});
    defer module.deinit();
    var result = try @import("../assembly.zig").assembleFlat(std.testing.allocator, &module, null);
    defer result.deinit(std.testing.allocator);
    try std.testing.expectEqualSlices(u8, expected, result.bytes);
}

test "a macro capture keeps the module bindings it was taken with" {
    // `probe mode` captures `mode` while it is 0, and the macro body assigns 5
    // before evaluating the captured operand. The capture has to read 0, because
    // that is the value it was taken with: keeping that view is the whole reason
    // a capture holds one instead of resolving against the live module.
    try expectBytes(
        \\let mode: u64 = 0
        \\macro probe(x) {
        \\    mode = 5
        \\    emit.u8(operand.eval(x))
        \\}
        \\probe mode
    , &.{0});
}

test "a captured operand reads the caller's binding, not the macro body's" {
    // Chapter 5 of the language guide, "Statement Macros": the macro body
    // declares its own LIMIT of 100 and the captured text still reads the
    // caller's 7, so `operand.eval` resolves against the bindings the capture
    // was taken with. This is the behaviour fix C has to preserve.
    try expectBytes(
        \\macro shadowed(value) {
        \\    const LIMIT: u64 = 100
        \\    const n: u64 = operand.eval(value)
        \\    emit.u8(n)
        \\}
        \\const LIMIT: u64 = 7
        \\shadowed LIMIT + 1
    , &.{8});
}

test "a captured operand evaluates against the caller's bindings" {
    // Also chapter 5: `byte LIMIT + 1` gives 8 and `byte (LIMIT + 2)` gives 9.
    try expectBytes(
        \\macro byte(value) {
        \\    const n: u64 = operand.eval(value)
        \\    emit.u8(n)
        \\}
        \\const LIMIT: u64 = 7
        \\byte LIMIT + 1
        \\byte (LIMIT + 2)
    , &.{ 8, 9 });
}

test "a borrowed table argument reads the same as a copied one" {
    // A builtin borrows `table` when every argument is a bare name and copies it
    // when any argument is not, so the two spellings below take different paths
    // through the same builtin and must produce identical results.
    try expectBytes(
        \\let table: map = map.new()
        \\map.set_mut(table, "a", 1)
        \\map.set_mut(table, "b", 2)
        \\const key: string = "a"
        \\if map.has(table, key) {
        \\    emit.u8(1)
        \\}
        \\if map.has(table, "a") {
        \\    emit.u8(2)
        \\}
        \\emit.u8(map.get(table, key))
        \\emit.u8(map.get(table, "b"))
        \\emit.u8(len(table))
    , &.{ 1, 2, 1, 2, 2 });
}

test "a capture sees a module binding assigned a new value" {
    // `setValue` replaces a module-level binding, so a capture taken afterwards
    // has to see the new value. If the snapshot cache missed this path the
    // second `show` would still print 1.
    try expectBytes(
        \\let mode: u64 = 1
        \\macro show(x) {
        \\    emit.u8(operand.eval(x))
        \\}
        \\show mode
        \\mode = 5
        \\show mode
    , &.{ 1, 5 });
}

test "a capture sees a module binding declared after an earlier capture" {
    // `defineValue` adds a binding, so it has to invalidate the snapshot too: a
    // capture taken later must be able to name the new binding at all.
    try expectBytes(
        \\macro show(x) {
        \\    emit.u8(operand.eval(x))
        \\}
        \\const first: u64 = 3
        \\show first
        \\const second: u64 = 9
        \\show second
    , &.{ 3, 9 });
}

test "a capture sees a module binding written back through a let parameter" {
    // A `let` parameter is written back to the caller's binding, which for a
    // module-level argument goes through `module.setValue` as well.
    try expectBytes(
        \\fn fill(let target: map) {
        \\    map.set_mut(target, "k", 9)
        \\}
        \\let table: map = map.new()
        \\macro show(x) {
        \\    emit.u8(operand.eval(x))
        \\}
        \\show len(table)
        \\fill(table)
        \\show len(table)
    , &.{ 0, 1 });
}

test "a capture reads the nearest binding of a shadowed name" {
    // Chapter 6: lookup uses the nearest binding, so the loop body's `value`
    // wins over the module-level one of the same name. Resolving the capture
    // against the snapshot before the locals would print 7 instead of 9.
    try expectBytes(
        \\const value: u64 = 7
        \\macro show(x) {
        \\    emit.u8(operand.eval(x))
        \\}
        \\for i in range(0, 1) {
        \\    const value: u64 = 9
        \\    show value
        \\}
    , &.{9});
}

test "a captured operand sees a module container mutated in place" {
    // `map.set_mut` changes the container without adding or replacing a binding,
    // so a cache keyed only on binding changes would keep handing out the
    // contents from before the mutation and the second `show` would print 10.
    try expectBytes(
        \\let table: map = map.new()
        \\map.set_mut(table, "k", 10)
        \\macro show(x) {
        \\    emit.u8(operand.eval(x))
        \\}
        \\show map.get(table, "k")
        \\map.set_mut(table, "k", 20)
        \\show map.get(table, "k")
    , &.{ 10, 20 });
}

test "macro exact arity takes priority over variadic declaration" {
    try expectBytes(
        \\macro choose(...args) {
        \\    emit.u8(len(args))
        \\}
        \\macro choose(a) {
        \\    emit.u8(42)
        \\}
        \\choose
        \\choose x0
        \\choose x0, x1
    , &.{ 0, 42, 2 });
}

test "macro expressions retain values after mutation and helper shadowing" {
    try expectBytes(
        \\let count: u64 = 7
        \\fn read(x: operand) -> u64 {
        \\    const count: u64 = 90
        \\    return operand.eval(x)
        \\}
        \\macro save(x) {
        \\    count = 8
        \\    emit.u8(read(x))
        \\}
        \\save count
        \\emit.u8(count)
    , &.{ 7, 8 });
}

test "macro mixed templates preserve environments of each substituted operand" {
    try expectBytes(
        \\const number: u64 = 3
        \\macro sum(x) {
        \\    emit.u8(operand.eval(x))
        \\}
        \\macro wrapper(x) {
        \\    const number: u64 = 7
        \\    sum x + number
        \\}
        \\wrapper number
    , &.{10});
}

test "macro operand slice strips a prefix and retains the captured binding" {
    try expectBytes(
        \\const immediate: u64 = 41
        \\macro byte(x) {
        \\    const immediate: u64 = 0
        \\    const tail: operand = operand.slice(x, 1, len(operand.text(x)))
        \\    emit.u8(operand.eval(tail))
        \\}
        \\byte #immediate + 1
    , &.{42});
}

test "macro operands survive the invocation that captured them" {
    try expectBytes(
        \\let saved: list = list.new()
        \\macro capture(x) {
        \\    list.push_mut(saved, x)
        \\}
        \\for i in range(1, 4) {
        \\    capture i
        \\}
        \\for x in saved {
        \\    emit.u8(operand.eval(x))
        \\}
    , &.{ 1, 2, 3 });
}

test "macro body values retain strict Meta typing and declaration rules" {
    const Case = struct { text: []const u8, expected: Error };
    for ([_]Case{
        .{ .text = "macro test(x) {\n emit.u8(x)\n}\ntest 7\n", .expected = error.InvalidExpression },
        .{ .text = "macro test(x) {\n const n: bool = 7\n}\ntest 7\n", .expected = error.InvalidValueDeclaration },
        .{ .text = "macro test(x) {\n const x = 7\n}\ntest 7\n", .expected = error.DuplicateSymbol },
        .{ .text = "macro test(x) {\n x = 7\n}\ntest 7\n", .expected = error.InvalidValueDeclaration },
        .{ .text = "macro test() {\n return 7\n}\ntest\n", .expected = error.InvalidMetaFunction },
        .{ .text = "macro test() {\n break\n}\nfor i in range(0, 1) {\n test\n}\n", .expected = error.FrontendDiagnostics },
        .{ .text = "macro test() {\n continue\n}\nfor i in range(0, 1) {\n test\n}\n", .expected = error.FrontendDiagnostics },
        .{ .text = "macro test() {\n fn nested() {\n }\n}\ntest\n", .expected = error.InvalidMetaFunction },
        .{ .text = "macro test() {\n macro nested() {\n }\n}\ntest\n", .expected = error.InvalidMacro },
        .{ .text = "macro test() {\n emit.u8(0)\n}\nfn pure() -> u64 {\n test\n return 1\n}\nconst x = pure()\n", .expected = error.InvalidExpression },
    }) |case| {
        try std.testing.expectError(case.expected, @import("lower.zig").lowerSource(std.testing.allocator, case.text, .{}));
    }
}

test "macro definitions reject malformed signatures and unreachable names" {
    for ([_][]const u8{
        "macro x(a, a) {\n}\n",   "macro x(a,) {\n}\n",      "macro x(...a, b) {\n}\n",
        "macro x(a: u64) {\n}\n", "macro x() -> u64 {\n}\n", "macro db(a) {\n}\n",
        "macro let(a) {\n}\n",    "macro b..eq(a) {\n}\n",   "macro x() { emit.u8(0) }\n",
    }) |text| {
        try std.testing.expectError(error.InvalidMacro, @import("lower.zig").lowerSource(std.testing.allocator, text, .{}));
    }
}

test "macro rejects duplicate signatures and mismatching invocations" {
    const Case = struct { text: []const u8, expected: Error };
    for ([_]Case{
        .{ .text = "macro x() {\n}\nmacro x() {\n}\n", .expected = error.DuplicateMacro },
        .{ .text = "macro x(...a) {\n}\nmacro x(b, ...c) {\n}\n", .expected = error.DuplicateMacro },
        .{ .text = "macro nop(x) {\n}\nnop\n", .expected = error.MacroArityMismatch },
        .{ .text = "macro x(a) {\n}\nx a,\n", .expected = error.InvalidMacroOperands },
        .{ .text = "macro x(a) {\n}\nx [)]\n", .expected = error.InvalidMacroOperands },
        .{ .text = "macro x() {\n x\n}\nx\n", .expected = error.MetaCallDepthExceeded },
        .{ .text = "defer {\n macro x() {\n }\n}\n", .expected = error.FinalizerCannotChangeLayout },
        .{ .text = "macro x() {\n}\ndefer {\n x\n}\n", .expected = error.FinalizerCannotChangeLayout },
        // An operand that names an undeclared value now reports the unresolved
        // name rather than a generic expression failure.
        .{ .text = "macro x(a) {\n emit.u8(operand.eval(a))\n}\nx missing\n", .expected = error.UndefinedSymbol },
        .{ .text = "macro x(a) {\n const b = operand.slice(a, 0, 999)\n}\nx a\n", .expected = error.InvalidExpression },
    }) |case| {
        try std.testing.expectError(case.expected, @import("lower.zig").lowerSource(std.testing.allocator, case.text, .{}));
    }
}

test "macro native encoding and deferred errors retain expansion locations" {
    const allocator = std.testing.allocator;
    for ([_][]const u8{
        "macro broken() {\n invalid_instruction eax\n}\nbroken\n",
        "macro broken() {\n emit.u8(0)\n defer {\n assert(false, \"late failure\")\n }\n}\nbroken\n",
    }) |text| {
        var module = try @import("lower.zig").lowerSource(allocator, text, .{});
        defer module.deinit();
        try std.testing.expectError(error.FrontendDiagnostics, @import("../assembly.zig").assembleFlat(allocator, &module, null));
        try std.testing.expectEqual(@as(usize, 3), module.diagnostics.items.items.len);
        try std.testing.expectEqualStrings("macro invoked here", module.diagnostics.items.items[1].message);
        try std.testing.expectEqualStrings("macro defined here", module.diagnostics.items.items[2].message);
    }
}

test "macro bodies do not rerun during instruction encoding" {
    const allocator = std.testing.allocator;
    var module = try @import("lower.zig").lowerSource(allocator,
        \\let calls: u64 = 0
        \\macro jump(target) {
        \\    calls = calls + 1
        \\    jmp target
        \\}
        \\jump done
        \\for padding in range(0, 200) {
        \\    emit.u8(0)
        \\}
        \\done:
        \\assert(calls == 1)
    , .{});
    defer module.deinit();
    const count = module.fragments.items.items.len;
    const first = try @import("pass.zig").encodeInstructionFragments(allocator, &module);
    try std.testing.expectEqual(@as(usize, 1), first.encoded_count);
    // The second pass has nothing left to encode, because a fragment that
    // already carries bytes is not encoded again. It must certainly not run a
    // macro body a second time: the fragment count and the `calls` counter
    // below are the evidence for that.
    const second = try @import("pass.zig").encodeInstructionFragments(allocator, &module);
    try std.testing.expectEqual(@as(usize, 0), second.encoded_count);
    try std.testing.expectEqual(count, module.fragments.items.items.len);
    const id = module.symbols.lookup("calls") orelse return error.MissingSymbol;
    const symbol = try module.symbols.get(id);
    try std.testing.expectEqual(@as(u64, 1), try symbol.binding.value.value.expectInteger());
}

test "macro parenthesized first operands and expression forms" {
    try expectBytes(
        \\const n: u64 = 7
        \\const letters: string = "abc"
        \\fn double(x: u64) -> u64 {
        \\    return x * 2
        \\}
        \\macro byte(x) {
        \\    emit.u8(operand.eval(x))
        \\}
        \\macro pair(x, y) {
        \\    byte x
        \\    byte y
        \\}
        \\byte (n + 1)
        \\pair (n + 2), double(n)
        \\byte 0x20 + 0b10
        \\byte sizeof(u64)
        \\byte lengthof(letters)
        \\byte (-2) & 255
    , &.{ 8, 9, 14, 34, 8, 3, 254 });
}

test "macro forwarded native operands evaluate builtins at their capture site" {
    try expectBytes(
        \\macro load(dst, value) {
        \\    emit.u8(0)
        \\    mov dst, value
        \\    mov dst, sizeof(u64)
        \\}
        \\load eax, here()
    , &.{ 0, 0xb8, 0, 0, 0, 0, 0xb8, 8, 0, 0, 0 });
}

test "macro capture preserves boolean and aggregate field semantics" {
    try expectBytes(
        \\packed struct Pair {
        \\    first: u64
        \\    second: u64
        \\}
        \\const p: Pair = Pair { first: 7, second: 8 }
        \\macro check(x, condition) {
        \\    const p: u64 = 0
        \\    assert(operand.eval(condition))
        \\    emit.u8(operand.eval(x))
        \\}
        \\check p.first + p.second, true && !false
    , &.{15});
}

fn exerciseEscapedAndDeferred(allocator: Allocator) !void {
    var module = try @import("lower.zig").lowerSource(allocator,
        \\let saved: list = list.new()
        \\macro capture(...args) {
        \\    for arg in args {
        \\        const fields: list = operand.split(arg)
        \\        const field: operand = list.get(fields, 0)
        \\        list.push_mut(saved, operand.slice(field, 1, len(operand.text(field))))
        \\    }
        \\}
        \\const n: u64 = 4
        \\capture #n, #5
        \\for item in saved {
        \\    emit.u8(operand.eval(item))
        \\}
        \\macro finalize(target) {
        \\    const outer: u64 = 6
        \\    defer {
        \\        const outer: u64 = outer + 1
        \\        let target: u64 = outer
        \\        target = target + 1
        \\        if true {
        \\            const target: u64 = target + 1
        \\            assert(target == 9)
        \\        }
        \\        assert(target == 8)
        \\    }
        \\}
        \\finalize unknown
    , .{});
    defer module.deinit();
    var result = try @import("../assembly.zig").assembleFlat(allocator, &module, null);
    defer result.deinit(allocator);
    try std.testing.expectEqualSlices(u8, &.{ 4, 5 }, result.bytes);
}

test "macro escaped variadics slices and deferred shadowing clean up every allocation failure" {
    var no_resize = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
    try std.testing.checkAllAllocationFailures(no_resize.allocator(), exerciseEscapedAndDeferred, .{});
}

fn exerciseInvalidMacro(allocator: Allocator, text: []const u8) !void {
    if (@import("lower.zig").lowerSource(allocator, text, .{})) |result| {
        var module = result;
        module.deinit();
        return error.ExpectedFailure;
    } else |err| switch (err) {
        error.OutOfMemory => return err,
        // An unresolved name surfaces as its own error where the failure is not
        // tied to a declaration, and as a reported diagnostic where it is.
        error.InvalidMacro,
        error.InvalidExpression,
        error.InvalidMacroOperands,
        error.DuplicateMacro,
        error.UndefinedSymbol,
        error.FrontendDiagnostics,
        => {},
        else => return err,
    }
}

test "macro malformed declarations operands and evaluation clean up allocation failures" {
    var no_resize = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
    for ([_][]const u8{
        "macro bad(a, b, a) {\n}\n",
        "macro ok(a) {\n}\nmacro ok(a) {\n}\n",
        "macro bad(a) {\n}\nbad [a, b\n",
        "macro bad(a) {\n const x = operand.eval(a)\n}\nbad missing\n",
    }) |input| try std.testing.checkAllAllocationFailures(no_resize.allocator(), exerciseInvalidMacro, .{input});
}

test "macro static labels conflict and explicit unique labels remain reusable" {
    try expectBytes(
        \\macro mark() {
        \\    const name: string = sym.unique("local")
        \\    label.define(name)
        \\    emit.u8(1)
        \\}
        \\mark
        \\mark
    , &.{ 1, 1 });
    try std.testing.expectError(error.DuplicateSymbol, @import("lower.zig").lowerSource(std.testing.allocator, "macro mark() {\nstatic_label:\n}\nmark\nmark\n", .{}));
}

test "macro operand limits reject excessive nesting arity and slice bounds" {
    const allocator = std.testing.allocator;
    var nested: [130]u8 = undefined;
    @memset(nested[0..65], '(');
    @memset(nested[65..], ')');
    try std.testing.expectError(error.InvalidMacroOperands, splitOperands(allocator, &nested));
    var args: [513]u8 = undefined;
    for (&args, 0..) |*byte, index| byte.* = if (index % 2 == 0) 'x' else ',';
    try std.testing.expectError(error.InvalidMacroOperands, splitOperands(allocator, &args));
    for ([_][]const u8{ "macro x(true) {\n}\n", "macro x(false) {\n}\n", "macro x(a.b) {\n}\n" }) |input| {
        try std.testing.expectError(error.InvalidMacro, @import("lower.zig").lowerSource(allocator, input, .{}));
    }
    for ([_][]const u8{ "operand.slice(x, 2, 1)", "operand.slice(x, 0, -1)", "operand.eval(operand.slice(x, 0, 0))", "operand.eval(7)" }) |expression| {
        const input = try std.fmt.allocPrint(allocator, "macro check(x) {{\n const invalid = {s}\n}}\ncheck 1\n", .{expression});
        defer allocator.free(input);
        try std.testing.expectError(error.InvalidExpression, @import("lower.zig").lowerSource(allocator, input, .{}));
    }
}

fn emptyMacroBody(_: Allocator, _: *module_mod.Module, _: *ActiveOutput, _: *std.ArrayList(ActiveOutput), _: []const ast.Statement, _: *Context) Error!void {}

test "macro total expansion budget and shared call depth stop at the boundary" {
    const allocator = std.testing.allocator;
    var module = try module_mod.Module.init(allocator, .default);
    defer module.deinit();
    var context: Context = .{};
    defer context.deinit(allocator);
    // A macro name has to be an owned mutable slice. `@constCast` on the literal
    // would hand the store a pointer into read-only data, which the store would
    // then be entitled to free.
    const owned_name = try allocator.dupe(u8, "budget");
    defer allocator.free(owned_name);
    try context.macros.define(allocator, .{ .definition = .{ .name = owned_name, .params = &.{}, .body = &.{}, .span = source.unknown_span }, .variadic = false });
    var active: ActiveOutput = .{ .section_id = module.default_section, .offset = 0, .file_offset = 0, .target = .default };
    var stack: std.ArrayList(ActiveOutput) = .empty;
    defer stack.deinit(allocator);
    const instruction: ast.IsaInstructionStatement = .{ .text = owned_name, .span = source.unknown_span };
    context.macro_expansions = max_expansions - 1;
    try std.testing.expect(try dispatch(allocator, &module, &active, &stack, instruction, &context, .{ .lower_statements = emptyMacroBody }));
    try std.testing.expectError(error.MacroExpansionLimitExceeded, dispatch(allocator, &module, &active, &stack, instruction, &context, .{ .lower_statements = emptyMacroBody }));
    context.macro_expansions = 0;
    context.call_depth = max_call_depth;
    try std.testing.expectError(error.MetaCallDepthExceeded, dispatch(allocator, &module, &active, &stack, instruction, &context, .{ .lower_statements = emptyMacroBody }));
    try std.testing.expectEqual(@as(usize, 0), context.scopes.items.len);
}

fn exerciseLateDiagnostic(allocator: Allocator) !void {
    var module = try @import("lower.zig").lowerSource(allocator, "macro fail() {\n defer {\n const n: u64 = label_addr(\"missing\")\n }\n}\nfail\n", .{});
    defer module.deinit();
    if (@import("../assembly.zig").assembleFlat(allocator, &module, null)) |result| {
        var output = result;
        output.deinit(allocator);
        return error.ExpectedFailure;
    } else |err| switch (err) {
        error.OutOfMemory => return err,
        error.FrontendDiagnostics => {},
        else => return err,
    }
    try std.testing.expectEqual(@as(usize, 3), module.diagnostics.items.items.len);
    try std.testing.expectEqualStrings("macro invoked here", module.diagnostics.items.items[1].message);
}

test "macro late diagnostic origins survive teardown and allocation failures" {
    var no_resize = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
    try std.testing.checkAllAllocationFailures(no_resize.allocator(), exerciseLateDiagnostic, .{});
}

test "macro operand clones free captured bindings through their owning allocator" {
    var owner = std.testing.FailingAllocator.init(std.testing.allocator, .{});
    var destination = std.testing.FailingAllocator.init(std.testing.allocator, .{});
    const environment = try owner.allocator().create(value.OperandEnvironment);
    const snapshot = try owner.allocator().create(value.BindingSnapshot);
    snapshot.* = .{ .entries = .{ .entries = try owner.allocator().alloc(value.MapEntry, 0) } };
    environment.* = .{
        .allocator = owner.allocator(),
        .module_snapshot = snapshot,
        .bindings = .{ .entries = try owner.allocator().alloc(value.MapEntry, 0) },
    };
    var pieces: std.ArrayList(value.OperandPiece) = .empty;
    try appendPiece(owner.allocator(), &pieces, environment, "42");
    environment.release(owner.allocator());
    var original: value.OperandValue = .{ .pieces = try pieces.toOwnedSlice(owner.allocator()) };
    var cloned = try original.clone(destination.allocator());
    original.deinit(owner.allocator());
    cloned.deinit(destination.allocator());
    try std.testing.expectEqual(owner.allocated_bytes, owner.freed_bytes);
    try std.testing.expectEqual(destination.allocated_bytes, destination.freed_bytes);
}

test "macro captured byte strings and nested forwarding do not rescan names" {
    try expectBytes(
        \\macro raw(arg) {
        \\    emit.bytes(operand.eval(arg))
        \\}
        \\raw b"AB"
        \\macro inner(arg, other) {
        \\    assert(operand.text(arg) == "other")
        \\    assert(operand.text(other) == "eax")
        \\}
        \\macro outer(first, second) {
        \\    inner first, second
        \\}
        \\outer other, eax
    , "AB");
}

test "macro capture dependency depth fails before recursive teardown becomes unbounded" {
    try std.testing.expectError(error.MacroCaptureDepthExceeded, @import("lower.zig").lowerSource(std.testing.allocator,
        \\let saved: list = list.new()
        \\macro capture(arg) {
        \\    list.push_mut(saved, arg)
        \\}
        \\for i in range(0, 129) {
        \\    capture i
        \\}
    , .{}));
}

test "macro and procedure calls share recursion depth" {
    try std.testing.expectError(error.MetaCallDepthExceeded, @import("lower.zig").lowerSource(std.testing.allocator,
        \\fn recurse() {
        \\    again
        \\}
        \\macro again() {
        \\    recurse()
        \\}
        \\again
    , .{}));
}

test "macro expression parser preserves type names fields and aggregate literals" {
    try expectBytes(
        \\packed struct Pair {
        \\    first: u64
        \\    second: u64
        \\}
        \\const second: u64 = 99
        \\const n: u64 = 7
        \\macro byte(x) {
        \\    const n: u64 = 0
        \\    emit.u8(operand.eval(x))
        \\}
        \\byte offset_of(Pair, second)
        \\byte len(pack(Pair { first: n, second: n }))
        \\byte sizeof(u16)
    , &.{ 8, 16, 2 });
}

test "macro captured expressions preserve short circuit and reject future value capture" {
    try expectBytes(
        \\macro check(x) {
        \\    assert(operand.eval(x))
        \\}
        \\check true || missing
        \\check !(false && missing)
    , &.{});
    // Capturing a value that does not exist yet fails where the declaration
    // tries to use it, and the report names the expression that failed.
    try std.testing.expectError(error.FrontendDiagnostics, @import("lower.zig").lowerSource(std.testing.allocator,
        \\let saved: list = list.new()
        \\macro capture(x) {
        \\    list.push_mut(saved, x)
        \\}
        \\capture future
        \\const future: u64 = 7
        \\const result = operand.eval(list.get(saved, 0))
    , .{}));
}

test "macro internal capture names cannot shadow user bindings in helpers" {
    try expectBytes(
        \\const __macro_operand_0_7: u64 = 9
        \\const n: u64 = 2
        \\fn helper(x: u64) -> u64 {
        \\    return __macro_operand_0_7 + x
        \\}
        \\macro byte(x) {
        \\    emit.u8(operand.eval(x))
        \\}
        \\byte helper(n)
    , &.{11});
}

test "macro operand forwarding preserves byte literal prefixes" {
    try expectBytes(
        \\macro raw(x) {
        \\    emit.bytes(operand.eval(x))
        \\}
        \\macro wrapper(b) {
        \\    raw b"AB"
        \\}
        \\wrapper 7
    , "AB");
}

test "macro late layout rejects expansion and nesting" {
    for ([_][]const u8{
        "macro x() {\n}\nlate_layout {\n x\n}\n",
        "late_layout {\n macro x() {\n }\n}\n",
    }) |input| try std.testing.expectError(error.InvalidLateLayout, @import("lower.zig").lowerSource(std.testing.allocator, input, .{}));
}

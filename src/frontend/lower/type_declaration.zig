const std = @import("std");

const ast = @import("../ast.zig");
const expr = @import("../expr.zig");
const module_mod = @import("../module.zig");
const type_name = @import("../type_name.zig");
const types = @import("../types.zig");
const contracts = @import("contracts.zig");
const expression_bridge = @import("expression_bridge.zig");
const context_mod = @import("context.zig");
const value_mod = @import("../value.zig");

const Allocator = std.mem.Allocator;
const LowerError = contracts.LowerError;
const ActiveOutput = contracts.ActiveOutput;
const LowerContext = context_mod.LowerContext;

pub const Callbacks = struct {
    eval_integer_at_context: *const fn (*module_mod.Module, *LowerContext, ActiveOutput, *const expr.Node) LowerError!u64,
    eval_value_at_context: *const fn (Allocator, *module_mod.Module, *LowerContext, ActiveOutput, *const expr.Node) LowerError!value_mod.Value,
};

pub fn lower(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    declaration: ast.StructDeclarationStatement,
    callbacks: Callbacks,
) LowerError!void {
    const specs = try allocator.alloc(types.StructFieldSpec, declaration.fields.len);
    defer allocator.free(specs);

    for (declaration.fields, 0..) |field, index| {
        const field_type = (try type_name.resolveNamedOrScalar(module, field.type_name)) orelse return error.UnknownTypeName;
        const default_value = if (field.default_value) |default_text| default: {
            const stored_type = try module.types.get(field_type);
            break :default switch (stored_type.*) {
                .int => try lowerFieldDefault(allocator, module, context, active, default_text, callbacks),
                .float => |width| try lowerFloatFieldDefault(allocator, module, context, active, default_text, width, callbacks),
                .void, .array, .pointer, .@"struct", .@"union" => return error.InvalidStructField,
            };
        } else null;
        specs[index] = .{
            .name = field.name,
            .ty = field_type,
            .default_value = default_value,
        };
    }

    const layout_policy: types.StructLayoutPolicy = switch (declaration.policy) {
        .natural => .natural,
        .@"packed" => .@"packed",
    };
    const aggregate_ty = switch (declaration.kind) {
        .@"struct" => try module.addStructType(declaration.name, specs, layout_policy),
        .@"union" => try module.addUnionType(declaration.name, specs, layout_policy),
    };
    try module.registerTypeName(declaration.name, aggregate_ty);
}

fn lowerFieldDefault(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    default_value: []const u8,
    callbacks: Callbacks,
) LowerError!u64 {
    var expression = expr.parseOwned(allocator, default_value) catch |err| return expression_bridge.mapExpressionError(err);
    defer expression.deinit(allocator);
    return callbacks.eval_integer_at_context(module, context, active, &expression);
}

fn lowerFloatFieldDefault(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    default_value: []const u8,
    width: types.FloatWidth,
    callbacks: Callbacks,
) LowerError!u64 {
    var expression = expr.parseOwned(allocator, default_value) catch |err| return expression_bridge.mapExpressionError(err);
    defer expression.deinit(allocator);
    var value = try callbacks.eval_value_at_context(allocator, module, context, active, &expression);
    defer value.deinit(allocator);
    return switch (width) {
        .f32 => @as(u32, @bitCast(value.expectFloat32() catch return error.InvalidStructField)),
        .f64 => @as(u64, @bitCast(value.expectFloat64() catch return error.InvalidStructField)),
    };
}

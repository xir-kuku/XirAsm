const std = @import("std");

const ast = @import("../ast.zig");
const expr = @import("../expr.zig");
const module_mod = @import("../module.zig");
const types = @import("../types.zig");
const value_mod = @import("../value.zig");
const contracts = @import("contracts.zig");
const context_mod = @import("context.zig");

const Allocator = std.mem.Allocator;
const ActiveOutput = contracts.ActiveOutput;
const LowerContext = context_mod.LowerContext;
const LowerError = contracts.LowerError;

pub const Callbacks = struct {
    eval_integer_at_context: *const fn (*module_mod.Module, *LowerContext, ActiveOutput, *const expr.Node) LowerError!u64,
    eval_value_at_context: *const fn (Allocator, *module_mod.Module, *LowerContext, ActiveOutput, *const expr.Node) LowerError!value_mod.Value,
};

/// Why a literal did not become a value, in words. Callers report it against the
/// statement that wrote the literal, because the expression layer keeps only the
/// fact that an operand failed.
pub fn literalErrorDetail(err: anyerror) ?[]const u8 {
    return switch (err) {
        error.MissingStructFieldValue => "the aggregate literal leaves a field out",
        error.UnknownField => "the aggregate literal names a field the type does not declare",
        error.DuplicateFieldName => "the aggregate literal sets the same field twice",
        error.UnknownTypeName => "the aggregate literal names a type that is not declared",
        error.ExpectedStruct => "this name is not a struct or union type",
        error.InvalidValueDeclaration => "a field value does not match the field type",
        else => null,
    };
}

pub fn structValueFromLiteral(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    literal: ast.StructLiteralArgument,
    callbacks: Callbacks,
) LowerError!value_mod.StructValue {
    const type_id = module.lookupTypeName(literal.type_name) orelse return error.UnknownTypeName;
    const stored_type = try module.types.get(type_id);

    return switch (stored_type.*) {
        .@"struct" => |*struct_type| structValueFromStructLiteral(allocator, module, context, active, type_id, struct_type, literal, callbacks),
        .@"union" => |*union_type| structValueFromUnionLiteral(allocator, module, context, active, type_id, union_type, literal, callbacks),
        .void, .int, .float, .array, .pointer => error.ExpectedStruct,
    };
}

fn structValueFromStructLiteral(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    type_id: types.TypeId,
    struct_type: *const types.StructType,
    literal: ast.StructLiteralArgument,
    callbacks: Callbacks,
) LowerError!value_mod.StructValue {
    try validateStructLiteralFields(struct_type, literal);

    const fields = try allocator.alloc(value_mod.StructFieldValue, struct_type.fields.items.len);
    var fields_len: usize = 0;
    errdefer {
        for (fields[0..fields_len]) |*field| {
            field.deinit(allocator);
        }
        allocator.free(fields);
    }

    for (struct_type.fields.items, 0..) |field, index| {
        const owned_name = try allocator.dupe(u8, field.name);
        errdefer allocator.free(owned_name);

        var field_value = try valueFromLiteralField(
            allocator,
            module,
            context,
            active,
            field,
            lookupStructLiteralField(literal, field.name),
            callbacks,
        );
        errdefer field_value.deinit(allocator);
        fields[index] = .{
            .name = owned_name,
            .value = field_value,
        };
        field_value = .void;
        fields_len += 1;
    }

    return .{
        .type_id = type_id,
        .fields = fields,
    };
}

fn structValueFromUnionLiteral(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    type_id: types.TypeId,
    union_type: *const types.UnionType,
    literal: ast.StructLiteralArgument,
    callbacks: Callbacks,
) LowerError!value_mod.StructValue {
    try validateStructLiteralFields(union_type, literal);
    if (literal.fields.len != 1) return error.InvalidValueDeclaration;

    const literal_field = literal.fields[0];
    const field = union_type.fieldByName(literal_field.name) orelse return error.UnknownField;

    const fields = try allocator.alloc(value_mod.StructFieldValue, 1);
    errdefer allocator.free(fields);

    const owned_name = try allocator.dupe(u8, field.name);
    errdefer allocator.free(owned_name);

    var field_value = try valueFromLiteralField(allocator, module, context, active, field.*, &literal_field.value, callbacks);
    errdefer field_value.deinit(allocator);

    fields[0] = .{
        .name = owned_name,
        .value = field_value,
    };
    field_value = .void;

    return .{
        .type_id = type_id,
        .fields = fields,
    };
}

fn valueFromLiteralField(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    field: types.StructField,
    literal_value: ?*const ast.StructLiteralValue,
    callbacks: Callbacks,
) LowerError!value_mod.Value {
    const ty = try module.types.get(field.ty);
    return switch (ty.*) {
        .int => |int_type| blk: {
            const raw_value = if (literal_value) |value| switch (value.*) {
                .expression => try callbacks.eval_integer_at_context(module, context, active, &value.expression),
                .struct_literal => return error.InvalidValueDeclaration,
            } else field.default_value orelse return error.MissingStructFieldValue;
            try value_mod.validateIntegerForIntType(raw_value, int_type);
            break :blk value_mod.Value.typedInteger(raw_value, field.ty);
        },
        .float => |width| blk: {
            if (literal_value) |value| {
                var evaluated = switch (value.*) {
                    .expression => try callbacks.eval_value_at_context(allocator, module, context, active, &value.expression),
                    .struct_literal => return error.InvalidValueDeclaration,
                };
                defer evaluated.deinit(allocator);
                switch (width) {
                    .f32 => {
                        const stored = evaluated.expectFloat32() catch return error.InvalidValueDeclaration;
                        break :blk .{ .float32 = stored };
                    },
                    .f64 => {
                        const stored = evaluated.expectFloat64() catch return error.InvalidValueDeclaration;
                        break :blk .{ .float64 = stored };
                    },
                }
            }
            const bits = field.default_value orelse return error.MissingStructFieldValue;
            break :blk switch (width) {
                .f32 => if (bits <= std.math.maxInt(u32))
                    .{ .float32 = @bitCast(@as(u32, @intCast(bits))) }
                else
                    return error.InvalidValueDeclaration,
                .f64 => .{ .float64 = @bitCast(bits) },
            };
        },
        .@"struct", .@"union" => blk: {
            const value = literal_value orelse return error.MissingStructFieldValue;
            var aggregate_value = switch (value.*) {
                .struct_literal => value_mod.Value{ .@"struct" = try structValueFromLiteral(allocator, module, context, active, value.struct_literal, callbacks) },
                .expression => try callbacks.eval_value_at_context(allocator, module, context, active, &value.expression),
            };
            errdefer aggregate_value.deinit(allocator);
            const stored = switch (aggregate_value) {
                .@"struct" => |stored| stored,
                .operand, .void, .integer, .float32, .float64, .boolean, .string, .bytes, .type, .list, .map => return error.InvalidValueDeclaration,
            };
            if (stored.type_id.index != field.ty.index) return error.InvalidValueDeclaration;
            break :blk aggregate_value;
        },
        .void, .array, .pointer => error.InvalidType,
    };
}

fn validateStructLiteralFields(
    struct_type: *const types.StructType,
    literal: ast.StructLiteralArgument,
) LowerError!void {
    for (literal.fields, 0..) |literal_field, index| {
        if (lookupStructLiteralFieldAfter(literal, literal_field.name, index + 1) != null) {
            return error.DuplicateFieldName;
        }
        if (struct_type.fieldByName(literal_field.name) == null) {
            return error.UnknownField;
        }
    }
}

fn lookupStructLiteralField(literal: ast.StructLiteralArgument, name: []const u8) ?*const ast.StructLiteralValue {
    for (literal.fields) |*field| {
        if (std.mem.eql(u8, field.name, name)) return &field.value;
    }
    return null;
}

fn lookupStructLiteralFieldAfter(
    literal: ast.StructLiteralArgument,
    name: []const u8,
    start: usize,
) ?*const ast.StructLiteralValue {
    for (literal.fields[start..]) |*field| {
        if (std.mem.eql(u8, field.name, name)) return &field.value;
    }
    return null;
}

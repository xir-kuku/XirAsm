const std = @import("std");

const module_mod = @import("module.zig");
const type_name_mod = @import("type_name.zig");
const types = @import("types.zig");
const value_mod = @import("value.zig");

const Allocator = std.mem.Allocator;

pub const TypeCheckError = Allocator.Error || error{
    InvalidMetaFunction,
    InvalidValueDeclaration,
    InvalidIntegerBits,
    InvalidType,
    DuplicateTypeName,
    TooManyTypes,
    UnknownTypeName,
};

/// Source-level Meta annotations are either direct Meta value categories or a
/// temporary layout-int constraint over `Value.integer`. The layout-int branch
/// range-checks `IntegerValue.value` and then records the accepted type id on
/// the value.
pub const MetaTypeAnnotation = union(enum) {
    value: value_mod.ValueType,
    layout_integer: types.TypeId,
    layout_aggregate: types.TypeId,
};

pub fn annotationFromName(module: ?*module_mod.Module, type_name: ?[]const u8) TypeCheckError!?MetaTypeAnnotation {
    const name = type_name orelse return null;
    if (value_mod.valueTypeFromName(name)) |value_type| return .{ .value = value_type };

    // Layout type names may participate in Meta annotations only through
    // explicit bridges: integers become typed Meta integers, and structs accept
    // aggregate StructValue instances bound to the same layout TypeId.
    const active_module = module orelse return null;
    const id = lowerLayoutTypeName(active_module, name) catch |err| switch (err) {
        error.UnknownTypeName => return null,
        else => return err,
    };
    const stored_type = active_module.types.get(id) catch return error.InvalidValueDeclaration;
    return switch (stored_type.*) {
        .int => .{ .layout_integer = id },
        .float => |width| .{ .value = switch (width) {
            .f32 => .f32,
            .f64 => .f64,
        } },
        .@"struct", .@"union" => .{ .layout_aggregate = id },
        .void, .array, .pointer => null,
    };
}

pub fn coerceValueToAnnotation(module: *module_mod.Module, value: *value_mod.Value, annotation: ?MetaTypeAnnotation) TypeCheckError!void {
    const active = annotation orelse return;
    switch (active) {
        .value => |value_type| {
            if (value.valueType() != value_type) return error.InvalidValueDeclaration;
        },
        .layout_integer => |type_id| {
            var integer_value = switch (value.*) {
                .integer => |stored| stored,
                .operand, .void, .float32, .float64, .boolean, .string, .bytes, .type, .@"struct", .list, .map => return error.InvalidValueDeclaration,
            };
            const layout_type = module.types.get(type_id) catch return error.InvalidValueDeclaration;
            switch (layout_type.*) {
                .int => |int_type| try validateIntegerFitsType(integer_value.value, int_type),
                .void, .float, .array, .pointer, .@"struct", .@"union" => return error.InvalidValueDeclaration,
            }
            integer_value.type_id = type_id;
            value.* = .{ .integer = integer_value };
        },
        .layout_aggregate => |type_id| {
            const struct_value = switch (value.*) {
                .@"struct" => |stored| stored,
                .operand, .void, .integer, .float32, .float64, .boolean, .string, .bytes, .type, .list, .map => return error.InvalidValueDeclaration,
            };
            if (struct_value.type_id.index != type_id.index) return error.InvalidValueDeclaration;
        },
    }
}

fn lowerLayoutTypeName(module: *module_mod.Module, name: []const u8) TypeCheckError!types.TypeId {
    if (try type_name_mod.resolveNamedOrScalar(module, name)) |id| return id;
    if (std.mem.eql(u8, name, "usize")) return module.getOrAddIntType("usize", @bitSizeOf(usize), .unsigned);
    return error.UnknownTypeName;
}

fn validateIntegerFitsType(value: u64, int_type: types.IntType) TypeCheckError!void {
    if (!int_type.acceptsValue(value)) return error.InvalidValueDeclaration;
}

test "typecheck parses Meta value annotations" {
    const annotation = (try annotationFromName(null, "integer")) orelse return error.MissingAnnotation;
    try std.testing.expectEqual(value_mod.ValueType.integer, annotation.value);
    try std.testing.expectEqual(null, try annotationFromName(null, null));
}

test "typecheck keeps layout integer annotations out of ValueType" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    const annotation = (try annotationFromName(&module, "u8")) orelse return error.MissingAnnotation;
    switch (annotation) {
        .layout_integer => |id| {
            const ty = try module.types.get(id);
            switch (ty.*) {
                .int => |int_type| {
                    try std.testing.expectEqual(@as(u16, 8), int_type.bits);
                    try std.testing.expectEqual(types.IntSignedness.unsigned, int_type.signedness);
                },
                .void, .float, .array, .pointer, .@"struct", .@"union" => return error.UnexpectedType,
            }
        },
        .value, .layout_aggregate => return error.UnexpectedAnnotation,
    }

    try std.testing.expect(value_mod.valueTypeFromName("u8") == null);
}

test "typecheck prefers registered layout types over builtin usize" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    const custom = try module.addStructType("usize", &.{}, .@"packed");
    try module.registerTypeName("usize", custom);

    const annotation = (try annotationFromName(&module, "usize")) orelse return error.MissingAnnotation;
    switch (annotation) {
        .layout_aggregate => |id| try std.testing.expectEqual(custom.index, id.index),
        .value, .layout_integer => return error.UnexpectedAnnotation,
    }
}

test "typecheck validates unsigned layout integer ranges" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    const annotation = try annotationFromName(&module, "u8");
    var max_value = value_mod.Value.int(255);
    try coerceValueToAnnotation(&module, &max_value, annotation);
    const typed_integer = try max_value.expectIntegerValue();
    try std.testing.expectEqual(@as(u32, 0), typed_integer.type_id.?.index);

    var overflow_value = value_mod.Value.int(256);
    try std.testing.expectError(error.InvalidValueDeclaration, coerceValueToAnnotation(&module, &overflow_value, annotation));
}

test "typecheck validates signed layout integer ranges" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    const annotation = try annotationFromName(&module, "i8");
    var max_value = value_mod.Value.int(127);
    try coerceValueToAnnotation(&module, &max_value, annotation);

    var min_value = value_mod.Value.int(0 -% @as(u64, 128));
    try coerceValueToAnnotation(&module, &min_value, annotation);

    var overflow_value = value_mod.Value.int(128);
    try std.testing.expectError(error.InvalidValueDeclaration, coerceValueToAnnotation(&module, &overflow_value, annotation));

    var underflow_value = value_mod.Value.int(0 -% @as(u64, 129));
    try std.testing.expectError(error.InvalidValueDeclaration, coerceValueToAnnotation(&module, &underflow_value, annotation));
}

test "typecheck validates signed i64 range" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    const annotation = try annotationFromName(&module, "i64");
    var max_value = value_mod.Value.int(@as(u64, @intCast(std.math.maxInt(i64))));
    try coerceValueToAnnotation(&module, &max_value, annotation);

    var min_value = value_mod.Value.int(@as(u64, 1) << 63);
    try coerceValueToAnnotation(&module, &min_value, annotation);
}

test "typecheck rejects non-integer values for layout integer annotations" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    const annotation = try annotationFromName(&module, "u16");
    var value: value_mod.Value = .{ .boolean = true };
    try std.testing.expectError(error.InvalidValueDeclaration, coerceValueToAnnotation(&module, &value, annotation));
}

const std = @import("std");
const root = @import("root.zig");
const types = @import("../types.zig");
const values = @import("../value.zig");

const float_source =
    \\struct FloatPoint {
    \\    x: f32 = f32(1.5),
    \\    y: f64 = -2.0,
    \\}
    \\union FloatChoice {
    \\    narrow: f32,
    \\    wide: f64,
    \\    point: FloatPoint,
    \\}
    \\struct FloatEnvelope {
    \\    tag: u8 = 0x7f,
    \\    choice: FloatChoice,
    \\    tail: u8 = 0x55,
    \\}
    \\packed struct PackedFloats {
    \\    tag: u8 = 1,
    \\    narrow: f32 = f32(-0.0),
    \\    wide: f64 = -0.0,
    \\}
    \\assert(sizeof(f32) == 4);
    \\assert(sizeof(f64) == 8);
    \\assert(sizeof(FloatPoint) == 16);
    \\assert(offset_of(FloatPoint, y) == 8);
    \\assert(sizeof(FloatEnvelope) == 32);
    \\assert(offset_of(FloatEnvelope, choice.point.y) == 16);
    \\assert(offset_of(FloatEnvelope, tail) == 24);
    \\assert(sizeof(PackedFloats) == 13);
    \\const envelope: FloatEnvelope = FloatEnvelope {
    \\    choice: FloatChoice { point: FloatPoint { } }
    \\}
    \\assert(envelope.choice.point.x == f32(1.5));
    \\assert(envelope.choice.point.y == -2.0);
    \\emit.struct(envelope);
    \\emit.bytes(pack(PackedFloats { }));
    \\emit.struct(FloatChoice { narrow: f32(3.25) });
    \\emit.struct(FloatChoice { wide: 4.5 });
    \\emit.f32(envelope.choice.point.x);
    \\emit.f64(envelope.choice.point.y);
;

fn checkFloatFields(allocator: std.mem.Allocator) !void {
    var module = try root.lowerSource(allocator, float_source, .{});
    defer module.deinit();

    const expected = [_][]const u8{
        &.{ 0x7f, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xc0, 0x3f, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xc0, 0x55, 0, 0, 0, 0, 0, 0, 0 },
        &.{ 1, 0, 0, 0, 0x80, 0, 0, 0, 0, 0, 0, 0, 0x80 },
        &.{ 0, 0, 0x50, 0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        &.{ 0, 0, 0, 0, 0, 0, 0x12, 0x40, 0, 0, 0, 0, 0, 0, 0, 0 },
        &.{ 0, 0, 0xc0, 0x3f },
        &.{ 0, 0, 0, 0, 0, 0, 0, 0xc0 },
    };
    try std.testing.expectEqual(expected.len, module.fragments.items.items.len);
    for (expected, module.fragments.items.items) |bytes, fragment| {
        switch (fragment) {
            .bytes => |stored| try std.testing.expectEqualSlices(u8, bytes, stored.data),
            else => return error.UnexpectedFragment,
        }
    }
}

test "native float fields preserve widths defaults nested unions and IEEE bytes" {
    try checkFloatFields(std.testing.allocator);
}

test "native float field pipeline propagates every allocation failure" {
    var no_resize = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
    try std.testing.checkAllAllocationFailures(no_resize.allocator(), checkFloatFields, .{});
}

test "native float fields reject implicit conversions and mismatched defaults" {
    const cases = [_]struct { source: []const u8, expected: anyerror }{
        .{ .source = "struct P {\n    x: f32,\n}\nemit.struct(P { x: 1.5 });", .expected = error.InvalidValueDeclaration },
        .{ .source = "struct P {\n    x: f64,\n}\nemit.struct(P { x: f32(1.5) });", .expected = error.InvalidValueDeclaration },
        .{ .source = "struct P {\n    x: f32,\n}\nemit.struct(P { x: 1 });", .expected = error.InvalidValueDeclaration },
        .{ .source = "struct P {\n    x: f64,\n}\nemit.struct(P { x: 1 });", .expected = error.InvalidValueDeclaration },
        .{ .source = "struct P {\n    x: f32 = 1.5,\n}\n", .expected = error.InvalidStructField },
        .{ .source = "struct P {\n    x: f64 = f32(1.5),\n}\n", .expected = error.InvalidStructField },
        .{ .source = "struct P {\n    x: f32 = 0,\n}\n", .expected = error.InvalidStructField },
        .{ .source = "struct P {\n    x: f32,\n}\nemit.struct(P { });", .expected = error.MissingStructFieldValue },
        .{ .source = "union P {\n    x: f32 = f32(0.0),\n}\n", .expected = error.UnionFieldDefaultNotAllowed },
        .{ .source = "struct P {\n    x: f32,\n}\nemit.struct(P { x: f32(1e100) });", .expected = error.InvalidExpression },
        .{ .source = "struct P {\n    x: f64,\n}\nemit.struct(P { x: 1e999 });", .expected = error.InvalidExpression },
        .{ .source = "struct P {\n    x: f64 = 1e308 * 1e308,\n}\n", .expected = error.InvalidExpression },
    };
    for (cases) |case| {
        try std.testing.expectError(case.expected, root.lowerSource(std.testing.allocator, case.source, .{}));
    }
}

test "native float field validation frees owned values on mismatch" {
    try std.testing.expectError(error.InvalidValueDeclaration, root.lowerSource(std.testing.allocator,
        \\struct P {
        \\    x: f32,
        \\}
        \\emit.struct(P { x: "owned" });
    , .{}));
    try std.testing.expectError(error.InvalidStructField, root.lowerSource(std.testing.allocator,
        \\struct P {
        \\    x: f64 = "owned",
        \\}
    , .{}));
}

fn checkFloatDefaultContext(allocator: std.mem.Allocator) !void {
    var module = try root.lowerSource(allocator,
        \\const initial: f32 = f32(1.5)
        \\fn float_default() -> f32 {
        \\    return initial;
        \\}
        \\fn integer_default() -> u32 {
        \\    return 42;
        \\}
        \\fn declare_record(value: f64) {
        \\    struct ScopedRecord {
        \\        narrow: f32 = float_default(),
        \\        wide: f64 = value,
        \\        integer: u32 = integer_default(),
        \\    }
        \\    emit.struct(ScopedRecord { });
        \\}
        \\declare_record(-2.0);
    , .{});
    defer module.deinit();
    try std.testing.expectEqual(@as(usize, 1), module.fragments.items.items.len);
    switch (module.fragments.items.items[0]) {
        .bytes => |stored| try std.testing.expectEqualSlices(u8, &.{
            0, 0, 0xc0, 0x3f, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xc0, 42, 0, 0, 0, 0, 0, 0, 0,
        }, stored.data),
        else => return error.UnexpectedFragment,
    }
}

test "native scalar defaults resolve const values user functions and local bindings" {
    try checkFloatDefaultContext(std.testing.allocator);
}

test "native scalar default context propagates every allocation failure" {
    var no_resize = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
    try std.testing.checkAllAllocationFailures(no_resize.allocator(), checkFloatDefaultContext, .{});
}

test "native float packing rejects mismatched values and out of range storage" {
    var store: types.TypeStore = .{};
    defer store.deinit(std.testing.allocator);
    const float_ty = try store.addFloat(std.testing.allocator, .f32);
    const record_ty = try store.addStruct(std.testing.allocator, "Record", &.{
        .{ .name = "scalar", .ty = float_ty },
    }, .natural);
    const name = try std.testing.allocator.dupe(u8, "scalar");
    defer std.testing.allocator.free(name);
    var fields = [_]values.StructFieldValue{.{ .name = name, .value = values.Value.int(1) }};
    const instance: values.StructValue = .{ .type_id = record_ty, .fields = &fields };
    try std.testing.expectError(error.InvalidApiArgument, values.packStructValue(std.testing.allocator, &store, instance));
    fields[0].value = .{ .float64 = 1.5 };
    try std.testing.expectError(error.InvalidApiArgument, values.packStructValue(std.testing.allocator, &store, instance));
    fields[0].value = .{ .float32 = 1.5 };
    // Simulate an inconsistent host-created layout; the serializer must check bounds.
    store.items.items[record_ty.index].@"struct".fields.items[0].offset = 1;
    try std.testing.expectError(error.FragmentTooLarge, values.packStructValue(std.testing.allocator, &store, instance));
}

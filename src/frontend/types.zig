const std = @import("std");

const Allocator = std.mem.Allocator;

/// Frontend-owned binary layout type model. These types answer layout questions
/// such as `sizeof`, `offset_of`, and `emit.struct`; they are not Meta runtime
/// value categories.
pub const TypeId = struct {
    index: u32,
};

pub const Layout = struct {
    size: u64,
    alignment: u64,
};

pub const IntSignedness = enum {
    unsigned,
    signed,
};

pub const FloatWidth = enum {
    f32,
    f64,

    pub fn layout(self: FloatWidth) Layout {
        const size: u64 = switch (self) {
            .f32 => 4,
            .f64 => 8,
        };
        return .{ .size = size, .alignment = size };
    }
};

pub const IntType = struct {
    bits: u16,
    signedness: IntSignedness = .unsigned,

    pub fn acceptsValue(self: IntType, value: u64) bool {
        if (self.bits == 0 or self.bits > @bitSizeOf(u64)) return false;

        if (self.signedness == .unsigned) {
            if (self.bits == @bitSizeOf(u64)) return true;
            const limit = (@as(u64, 1) << @intCast(self.bits)) - 1;
            return value <= limit;
        }

        const sign_bit = @as(u64, 1) << @intCast(self.bits - 1);
        const minimum_negative = 0 -% sign_bit;
        return value < sign_bit or value >= minimum_negative;
    }
};

pub const ArrayType = struct {
    child: TypeId,
    len: u64,
};

pub const PointerType = struct {
    child: TypeId,
    size: u64,
    alignment: u64,
};

pub const StructLayoutPolicy = enum {
    /// Natural ABI-like field alignment. This is still frontend-owned and does
    /// not imply any PE/ELF/COFF object section semantics.
    natural,
    /// No implicit field padding. Useful for exact binary headers and
    /// assembler-facing layout declarations.
    @"packed",
};

pub const StructField = struct {
    name: []u8,
    ty: TypeId,
    offset: u64,
    /// Integer payload, or IEEE 754 bits for a float field of the declared width.
    default_value: ?u64 = null,

    pub fn deinit(self: *StructField, allocator: Allocator) void {
        allocator.free(self.name);
        self.* = undefined;
    }
};

pub const StructType = struct {
    name: []u8,
    fields: std.ArrayList(StructField) = .empty,
    layout: Layout,
    policy: StructLayoutPolicy,

    pub fn fieldByName(self: *const StructType, name: []const u8) ?*const StructField {
        for (self.fields.items) |*field| {
            if (std.mem.eql(u8, field.name, name)) return field;
        }
        return null;
    }

    pub fn deinit(self: *StructType, allocator: Allocator) void {
        allocator.free(self.name);
        for (self.fields.items) |*field| {
            field.deinit(allocator);
        }
        self.fields.deinit(allocator);
        self.* = undefined;
    }
};

pub const UnionType = StructType;

pub const Type = union(enum) {
    void,
    int: IntType,
    float: FloatWidth,
    array: ArrayType,
    pointer: PointerType,
    @"struct": StructType,
    @"union": UnionType,

    pub fn deinit(self: *Type, allocator: Allocator) void {
        switch (self.*) {
            .@"struct", .@"union" => |*struct_type| struct_type.deinit(allocator),
            .void, .int, .float, .array, .pointer => {},
        }
        self.* = undefined;
    }
};

pub const StructFieldSpec = struct {
    name: []const u8,
    ty: TypeId,
    /// Integer payload, or IEEE 754 bits for a float field of the declared width.
    default_value: ?u64 = null,
};

pub const TypeStore = struct {
    items: std.ArrayList(Type) = .empty,

    pub fn deinit(self: *TypeStore, allocator: Allocator) void {
        for (self.items.items) |*ty| {
            ty.deinit(allocator);
        }
        self.items.deinit(allocator);
        self.* = undefined;
    }

    pub fn addVoid(self: *TypeStore, allocator: Allocator) !TypeId {
        return self.append(allocator, .void);
    }

    pub fn addInt(
        self: *TypeStore,
        allocator: Allocator,
        bits: u16,
        signedness: IntSignedness,
    ) !TypeId {
        if (bits == 0) return error.InvalidIntegerBits;
        return self.append(allocator, .{
            .int = .{
                .bits = bits,
                .signedness = signedness,
            },
        });
    }

    pub fn addArray(
        self: *TypeStore,
        allocator: Allocator,
        child: TypeId,
        len: u64,
    ) !TypeId {
        const child_layout = try self.layoutOf(child);
        try ensureMulFits(child_layout.size, len);
        return self.append(allocator, .{
            .array = .{
                .child = child,
                .len = len,
            },
        });
    }

    pub fn addFloat(self: *TypeStore, allocator: Allocator, width: FloatWidth) !TypeId {
        return self.append(allocator, .{ .float = width });
    }

    pub fn addPointer(
        self: *TypeStore,
        allocator: Allocator,
        child: TypeId,
        size: u64,
        alignment: u64,
    ) !TypeId {
        if (!isPowerOfTwoNonZero(alignment)) return error.InvalidAlignment;
        if (size == 0) return error.InvalidPointerSize;
        return self.append(allocator, .{
            .pointer = .{
                .child = child,
                .size = size,
                .alignment = alignment,
            },
        });
    }

    pub fn addStruct(
        self: *TypeStore,
        allocator: Allocator,
        name: []const u8,
        fields: []const StructFieldSpec,
        policy: StructLayoutPolicy,
    ) !TypeId {
        const id = try nextTypeId(self.items.items.len);
        const owned_name = try allocator.dupe(u8, name);
        errdefer allocator.free(owned_name);

        var owned_fields: std.ArrayList(StructField) = .empty;
        errdefer deinitFields(&owned_fields, allocator);
        try owned_fields.ensureTotalCapacity(allocator, fields.len);

        var offset: u64 = 0;
        var struct_alignment: u64 = 1;

        for (fields) |field| {
            if (field.name.len == 0) return error.InvalidFieldName;
            if (hasFieldName(owned_fields.items, field.name)) return error.DuplicateFieldName;

            const field_layout = try self.layoutOf(field.ty);
            if (policy == .natural) {
                offset = try alignForward(offset, field_layout.alignment);
            }
            const next_offset = try checkedAdd(offset, field_layout.size);

            const owned_field_name = try allocator.dupe(u8, field.name);
            errdefer allocator.free(owned_field_name);

            owned_fields.appendAssumeCapacity(.{
                .name = owned_field_name,
                .ty = field.ty,
                .offset = offset,
                .default_value = field.default_value,
            });

            offset = next_offset;
            struct_alignment = @max(struct_alignment, field_layout.alignment);
        }

        const final_size = if (policy == .natural)
            try alignForward(offset, struct_alignment)
        else
            offset;

        try self.items.append(allocator, .{
            .@"struct" = .{
                .name = owned_name,
                .fields = owned_fields,
                .layout = .{
                    .size = final_size,
                    .alignment = struct_alignment,
                },
                .policy = policy,
            },
        });
        return id;
    }

    pub fn addUnion(
        self: *TypeStore,
        allocator: Allocator,
        name: []const u8,
        fields: []const StructFieldSpec,
        policy: StructLayoutPolicy,
    ) !TypeId {
        const id = try nextTypeId(self.items.items.len);
        const owned_name = try allocator.dupe(u8, name);
        errdefer allocator.free(owned_name);

        var owned_fields: std.ArrayList(StructField) = .empty;
        errdefer deinitFields(&owned_fields, allocator);
        try owned_fields.ensureTotalCapacity(allocator, fields.len);

        var union_size: u64 = 0;
        var union_alignment: u64 = 1;

        for (fields) |field| {
            if (field.name.len == 0) return error.InvalidFieldName;
            if (hasFieldName(owned_fields.items, field.name)) return error.DuplicateFieldName;

            const field_layout = try self.layoutOf(field.ty);

            const owned_field_name = try allocator.dupe(u8, field.name);
            errdefer allocator.free(owned_field_name);

            owned_fields.appendAssumeCapacity(.{
                .name = owned_field_name,
                .ty = field.ty,
                .offset = 0,
                .default_value = field.default_value,
            });

            union_size = @max(union_size, field_layout.size);
            union_alignment = @max(union_alignment, field_layout.alignment);
        }

        const final_size = if (policy == .natural)
            try alignForward(union_size, union_alignment)
        else
            union_size;

        try self.items.append(allocator, .{
            .@"union" = .{
                .name = owned_name,
                .fields = owned_fields,
                .layout = .{
                    .size = final_size,
                    .alignment = union_alignment,
                },
                .policy = policy,
            },
        });
        return id;
    }

    pub fn get(self: *const TypeStore, id: TypeId) !*const Type {
        if (id.index >= self.items.items.len) return error.InvalidType;
        return &self.items.items[id.index];
    }

    pub fn layoutOf(self: *const TypeStore, id: TypeId) !Layout {
        const ty = try self.get(id);
        return switch (ty.*) {
            .void => .{ .size = 0, .alignment = 1 },
            .int => |int_type| intLayout(int_type),
            .float => |width| width.layout(),
            .array => |array_type| blk: {
                const child_layout = try self.layoutOf(array_type.child);
                break :blk .{
                    .size = try checkedMul(child_layout.size, array_type.len),
                    .alignment = child_layout.alignment,
                };
            },
            .pointer => |pointer_type| .{
                .size = pointer_type.size,
                .alignment = pointer_type.alignment,
            },
            .@"struct" => |struct_type| struct_type.layout,
            .@"union" => |union_type| union_type.layout,
        };
    }

    pub fn getStruct(self: *const TypeStore, id: TypeId) !*const StructType {
        const ty = try self.get(id);
        return switch (ty.*) {
            .@"struct" => |*struct_type| struct_type,
            .void, .int, .float, .array, .pointer, .@"union" => error.ExpectedStruct,
        };
    }

    pub fn getAggregate(self: *const TypeStore, id: TypeId) !*const StructType {
        const ty = try self.get(id);
        return switch (ty.*) {
            .@"struct" => |*struct_type| struct_type,
            .@"union" => |*union_type| union_type,
            .void, .int, .float, .array, .pointer => error.ExpectedStruct,
        };
    }

    pub fn structField(self: *const TypeStore, id: TypeId, name: []const u8) !*const StructField {
        const struct_type = try self.getStruct(id);
        return struct_type.fieldByName(name) orelse error.UnknownField;
    }

    pub fn aggregateField(self: *const TypeStore, id: TypeId, name: []const u8) !*const StructField {
        const aggregate_type = try self.getAggregate(id);
        return aggregate_type.fieldByName(name) orelse error.UnknownField;
    }

    pub fn structFieldOffset(self: *const TypeStore, id: TypeId, name: []const u8) !u64 {
        const field = try self.structField(id, name);
        return field.offset;
    }

    pub fn aggregateFieldOffset(self: *const TypeStore, id: TypeId, name: []const u8) !u64 {
        const field = try self.aggregateField(id, name);
        return field.offset;
    }

    fn append(self: *TypeStore, allocator: Allocator, ty: Type) !TypeId {
        const id = try nextTypeId(self.items.items.len);
        try self.items.append(allocator, ty);
        return id;
    }
};

fn hasFieldName(fields: []const StructField, name: []const u8) bool {
    for (fields) |field| {
        if (std.mem.eql(u8, field.name, name)) return true;
    }
    return false;
}

fn deinitFields(fields: *std.ArrayList(StructField), allocator: Allocator) void {
    for (fields.items) |*field| {
        field.deinit(allocator);
    }
    fields.deinit(allocator);
}

fn intLayout(int_type: IntType) !Layout {
    const byte_size = try intByteSize(int_type.bits);
    const alignment = if (byte_size == 0) 1 else nextPowerOfTwoAtMost(byte_size, 8);
    return .{
        .size = byte_size,
        .alignment = alignment,
    };
}

fn intByteSize(bits: u16) !u64 {
    if (bits == 0) return error.InvalidIntegerBits;
    const widened_bits: u64 = bits;
    return std.math.divCeil(u64, widened_bits, 8) catch error.InvalidIntegerBits;
}

fn nextTypeId(len: usize) error{TooManyTypes}!TypeId {
    if (len > std.math.maxInt(u32)) return error.TooManyTypes;
    return .{ .index = @intCast(len) };
}

fn alignForward(value: u64, alignment: u64) !u64 {
    if (!isPowerOfTwoNonZero(alignment)) return error.InvalidAlignment;
    const mask = alignment - 1;
    const added = try checkedAdd(value, mask);
    return added & ~mask;
}

fn checkedAdd(lhs: u64, rhs: u64) error{IntegerOverflow}!u64 {
    return std.math.add(u64, lhs, rhs) catch error.IntegerOverflow;
}

fn checkedMul(lhs: u64, rhs: u64) error{IntegerOverflow}!u64 {
    try ensureMulFits(lhs, rhs);
    return lhs * rhs;
}

fn ensureMulFits(lhs: u64, rhs: u64) error{IntegerOverflow}!void {
    if (lhs != 0 and rhs > std.math.maxInt(u64) / lhs) return error.IntegerOverflow;
}

fn isPowerOfTwoNonZero(value: u64) bool {
    return value != 0 and (value & (value - 1)) == 0;
}

fn nextPowerOfTwoAtMost(value: u64, max_value: u64) u64 {
    var result: u64 = 1;
    while (result < value and result < max_value) {
        result *= 2;
    }
    return result;
}

test "struct layout supports natural field alignment" {
    var store: TypeStore = .{};
    defer store.deinit(std.testing.allocator);

    const u8_ty = try store.addInt(std.testing.allocator, 8, .unsigned);
    const u32_ty = try store.addInt(std.testing.allocator, 32, .unsigned);
    const header_ty = try store.addStruct(
        std.testing.allocator,
        "Header",
        &.{
            .{ .name = "tag", .ty = u8_ty },
            .{ .name = "size", .ty = u32_ty },
        },
        .natural,
    );

    const layout = try store.layoutOf(header_ty);
    try std.testing.expectEqual(@as(u64, 8), layout.size);
    try std.testing.expectEqual(@as(u64, 4), layout.alignment);

    const header = try store.get(header_ty);
    switch (header.*) {
        .@"struct" => |struct_type| {
            try std.testing.expectEqual(@as(u64, 0), struct_type.fields.items[0].offset);
            try std.testing.expectEqual(@as(u64, 4), struct_type.fields.items[1].offset);
        },
        else => return error.UnexpectedType,
    }
}

test "struct fields can be queried by name" {
    var store: TypeStore = .{};
    defer store.deinit(std.testing.allocator);

    const u16_ty = try store.addInt(std.testing.allocator, 16, .unsigned);
    const u32_ty = try store.addInt(std.testing.allocator, 32, .unsigned);
    const header_ty = try store.addStruct(
        std.testing.allocator,
        "DosHeader",
        &.{
            .{ .name = "magic", .ty = u16_ty },
            .{ .name = "lfanew", .ty = u32_ty },
        },
        .@"packed",
    );

    try std.testing.expectEqual(@as(u64, 0), try store.structFieldOffset(header_ty, "magic"));
    try std.testing.expectEqual(@as(u64, 2), try store.structFieldOffset(header_ty, "lfanew"));

    const field = try store.structField(header_ty, "lfanew");
    try std.testing.expectEqual(u32_ty.index, field.ty.index);
    try std.testing.expectError(error.UnknownField, store.structFieldOffset(header_ty, "missing"));
}

test "struct layout rejects duplicate field names" {
    var store: TypeStore = .{};
    defer store.deinit(std.testing.allocator);

    const u8_ty = try store.addInt(std.testing.allocator, 8, .unsigned);
    try std.testing.expectError(
        error.DuplicateFieldName,
        store.addStruct(
            std.testing.allocator,
            "BadHeader",
            &.{
                .{ .name = "tag", .ty = u8_ty },
                .{ .name = "tag", .ty = u8_ty },
            },
            .@"packed",
        ),
    );
}

test "packed struct layout supports exact binary headers" {
    var store: TypeStore = .{};
    defer store.deinit(std.testing.allocator);

    const u8_ty = try store.addInt(std.testing.allocator, 8, .unsigned);
    const u32_ty = try store.addInt(std.testing.allocator, 32, .unsigned);
    const header_ty = try store.addStruct(
        std.testing.allocator,
        "PackedHeader",
        &.{
            .{ .name = "tag", .ty = u8_ty },
            .{ .name = "size", .ty = u32_ty },
        },
        .@"packed",
    );

    const layout = try store.layoutOf(header_ty);
    try std.testing.expectEqual(@as(u64, 5), layout.size);
    try std.testing.expectEqual(@as(u64, 4), layout.alignment);

    const wrapper_ty = try store.addStruct(
        std.testing.allocator,
        "NaturalWrapper",
        &.{
            .{ .name = "prefix", .ty = u8_ty },
            .{ .name = "header", .ty = header_ty },
        },
        .natural,
    );
    try std.testing.expectEqual(@as(u64, 4), try store.structFieldOffset(wrapper_ty, "header"));
    try std.testing.expectEqual(@as(u64, 12), (try store.layoutOf(wrapper_ty)).size);

    const header = try store.get(header_ty);
    switch (header.*) {
        .@"struct" => |struct_type| {
            try std.testing.expectEqual(@as(u64, 0), struct_type.fields.items[0].offset);
            try std.testing.expectEqual(@as(u64, 1), struct_type.fields.items[1].offset);
        },
        else => return error.UnexpectedType,
    }
}

test "union layout uses max field size and clear packed boundary" {
    var store: TypeStore = .{};
    defer store.deinit(std.testing.allocator);

    const byte_ty = try store.addInt(std.testing.allocator, 8, .unsigned);
    const word_ty = try store.addInt(std.testing.allocator, 16, .unsigned);
    const three_ty = try store.addStruct(std.testing.allocator, "ThreeBytes", &.{
        .{ .name = "a", .ty = byte_ty },
        .{ .name = "b", .ty = word_ty },
    }, .@"packed");

    const natural_union = try store.addUnion(std.testing.allocator, "NaturalOdd", &.{
        .{ .name = "three", .ty = three_ty },
        .{ .name = "word", .ty = word_ty },
    }, .natural);
    const packed_union = try store.addUnion(std.testing.allocator, "PackedOdd", &.{
        .{ .name = "three", .ty = three_ty },
        .{ .name = "word", .ty = word_ty },
    }, .@"packed");

    const natural_layout = try store.layoutOf(natural_union);
    try std.testing.expectEqual(@as(u64, 4), natural_layout.size);
    try std.testing.expectEqual(@as(u64, 2), natural_layout.alignment);

    const packed_layout = try store.layoutOf(packed_union);
    try std.testing.expectEqual(@as(u64, 3), packed_layout.size);
    try std.testing.expectEqual(@as(u64, 2), packed_layout.alignment);
    try std.testing.expectEqual(@as(u64, 0), try store.aggregateFieldOffset(packed_union, "three"));
}

test "struct layout overflow leaves the type store valid" {
    var store: TypeStore = .{};
    defer store.deinit(std.testing.allocator);

    const byte_ty = try store.addInt(std.testing.allocator, 8, .unsigned);
    const maximum_array_ty = try store.addArray(std.testing.allocator, byte_ty, std.math.maxInt(u64));

    try std.testing.expectError(
        error.IntegerOverflow,
        store.addStruct(
            std.testing.allocator,
            "Overflowing",
            &.{
                .{ .name = "payload", .ty = maximum_array_ty },
                .{ .name = "tail", .ty = byte_ty },
            },
            .@"packed",
        ),
    );
    try std.testing.expectEqual(@as(usize, 2), store.items.items.len);
}

fn checkAggregateTypeConstructionAllocationFailures(allocator: Allocator) !void {
    var store: TypeStore = .{};
    defer store.deinit(allocator);

    const byte_ty = try store.addInt(allocator, 8, .unsigned);
    const dword_ty = try store.addInt(allocator, 32, .unsigned);
    const struct_ty = try store.addStruct(allocator, "Header", &.{
        .{ .name = "tag", .ty = byte_ty },
        .{ .name = "size", .ty = dword_ty },
    }, .natural);
    const union_ty = try store.addUnion(allocator, "Value", &.{
        .{ .name = "byte", .ty = byte_ty },
        .{ .name = "dword", .ty = dword_ty },
    }, .@"packed");

    try std.testing.expectEqual(@as(u64, 8), (try store.layoutOf(struct_ty)).size);
    try std.testing.expectEqual(@as(u64, 4), (try store.layoutOf(union_ty)).size);
}

test "aggregate type construction handles every allocation failure" {
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        checkAggregateTypeConstructionAllocationFailures,
        .{},
    );
}

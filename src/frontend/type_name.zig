const std = @import("std");

const module_mod = @import("module.zig");
const types = @import("types.zig");

pub fn resolveNamedOrScalar(
    module: *module_mod.Module,
    name: []const u8,
) !?types.TypeId {
    if (module.lookupTypeName(name)) |id| return id;
    if (std.mem.eql(u8, name, "u8")) return try module.getOrAddIntType("u8", 8, .unsigned);
    if (std.mem.eql(u8, name, "u16")) return try module.getOrAddIntType("u16", 16, .unsigned);
    if (std.mem.eql(u8, name, "u32")) return try module.getOrAddIntType("u32", 32, .unsigned);
    if (std.mem.eql(u8, name, "u64")) return try module.getOrAddIntType("u64", 64, .unsigned);
    if (std.mem.eql(u8, name, "i8")) return try module.getOrAddIntType("i8", 8, .signed);
    if (std.mem.eql(u8, name, "i16")) return try module.getOrAddIntType("i16", 16, .signed);
    if (std.mem.eql(u8, name, "i32")) return try module.getOrAddIntType("i32", 32, .signed);
    if (std.mem.eql(u8, name, "i64")) return try module.getOrAddIntType("i64", 64, .signed);
    if (std.mem.eql(u8, name, "f32")) return try module.getOrAddFloatType("f32", .f32);
    if (std.mem.eql(u8, name, "f64")) return try module.getOrAddFloatType("f64", .f64);
    return null;
}

const std = @import("std");

const fragment = @import("fragment.zig");
const module_mod = @import("module.zig");
const section = @import("section.zig");
const source = @import("source.zig");
const target = @import("target.zig");

const Allocator = std.mem.Allocator;

pub const LayoutError = Allocator.Error || error{
    InvalidFragment,
    InvalidSection,
    OffsetOverflow,
    FragmentTooLarge,
};

pub const FragmentLayout = struct {
    fragment: fragment.FragmentId,
    offset: u64,
    logical_size: u64,
    file_size: u64,
    trim_tail: bool = false,
};

pub const SectionLayout = struct {
    section: section.SectionId,
    origin: u64,
    file_offset: u64,
    logical_size: u64,
    file_size: u64,
    fragments: []FragmentLayout,

    pub fn deinit(self: *SectionLayout, allocator: Allocator) void {
        allocator.free(self.fragments);
        self.* = undefined;
    }
};

pub const ModuleLayout = struct {
    sections: []SectionLayout,
    /// Section-relative offset of every fragment, indexed by fragment id.
    ///
    /// Resolving a fixup, patching it, and syncing an anchored label each ask
    /// for one fragment's placement, and answering by scanning that section's
    /// fragment list made a source with N forward references quadratic (N
    /// references times N fragments). The table is built once here instead.
    fragment_offsets: []u64,

    pub fn deinit(self: *ModuleLayout, allocator: Allocator) void {
        for (self.sections) |*section_layout| {
            section_layout.deinit(allocator);
        }
        allocator.free(self.sections);
        allocator.free(self.fragment_offsets);
        self.* = undefined;
    }

    /// Section layouts are stored in section-id order, so an id indexes them.
    pub fn sectionLayout(self: *const ModuleLayout, id: section.SectionId) ?*const SectionLayout {
        if (id.index >= self.sections.len) return null;
        return &self.sections[id.index];
    }

    /// Placement of one fragment, or null when no section owns it.
    pub fn fragmentOffset(self: *const ModuleLayout, id: fragment.FragmentId) ?u64 {
        if (id.index >= self.fragment_offsets.len) return null;
        return self.fragment_offsets[id.index];
    }
};

pub fn layoutModule(allocator: Allocator, module: *const module_mod.Module) LayoutError!ModuleLayout {
    var section_layouts = try allocator.alloc(SectionLayout, module.sections.items.items.len);
    var initialized_count: usize = 0;
    errdefer {
        for (section_layouts[0..initialized_count]) |*section_layout| {
            section_layout.deinit(allocator);
        }
        allocator.free(section_layouts);
    }

    var fragment_offsets = try allocator.alloc(u64, module.fragments.items.items.len);
    errdefer allocator.free(fragment_offsets);
    @memset(fragment_offsets, 0);

    for (module.sections.items.items, 0..) |stored_section, index| {
        section_layouts[index] = try layoutSection(allocator, module, .{ .index = @intCast(index) }, stored_section);
        initialized_count += 1;
        for (section_layouts[index].fragments) |entry| {
            if (entry.fragment.index >= fragment_offsets.len) return error.InvalidFragment;
            fragment_offsets[entry.fragment.index] = entry.offset;
        }
    }

    return .{ .sections = section_layouts, .fragment_offsets = fragment_offsets };
}

pub fn layoutSection(
    allocator: Allocator,
    module: *const module_mod.Module,
    section_id: section.SectionId,
    stored_section: section.Section,
) LayoutError!SectionLayout {
    var entries = try allocator.alloc(FragmentLayout, stored_section.fragments.items.len);
    errdefer allocator.free(entries);

    var cursor: u64 = 0;
    for (stored_section.fragments.items, 0..) |fragment_id, index| {
        const stored_fragment = try getFragment(module, fragment_id);
        const aligned_offset = try alignFragmentOffset(cursor, stored_fragment);
        const logical_size = try logicalFragmentSize(stored_fragment, aligned_offset);
        entries[index] = .{
            .fragment = fragment_id,
            .offset = aligned_offset,
            .logical_size = logical_size,
            .file_size = logical_size,
        };
        cursor = try checkedAdd(aligned_offset, logical_size);
    }

    var file_size = cursor;
    var reverse_index = entries.len;
    while (reverse_index > 0) {
        reverse_index -= 1;
        // Empty emission or an already-satisfied alignment does not initialize
        // bytes, so it cannot turn the preceding reserve into a file gap.
        if (entries[reverse_index].logical_size == 0) continue;
        const stored_fragment = try getFragment(module, entries[reverse_index].fragment);
        switch (stored_fragment) {
            .reserve => {
                entries[reverse_index].trim_tail = true;
                entries[reverse_index].file_size = 0;
                file_size = entries[reverse_index].offset;
            },
            else => break,
        }
    }

    const aligned_file_size = try alignForward(file_size, stored_section.file_size_alignment);

    return .{
        .section = section_id,
        .origin = stored_section.origin,
        .file_offset = stored_section.file_offset,
        .logical_size = cursor,
        .file_size = aligned_file_size,
        .fragments = entries,
    };
}

fn getFragment(module: *const module_mod.Module, id: fragment.FragmentId) LayoutError!fragment.Fragment {
    if (id.index >= module.fragments.items.items.len) return error.InvalidFragment;
    return module.fragments.items.items[id.index];
}

fn alignFragmentOffset(offset: u64, stored_fragment: fragment.Fragment) LayoutError!u64 {
    return switch (stored_fragment) {
        .reserve => |reserve| alignForward(offset, reserve.alignment),
        .alignment => offset,
        .bytes, .isa_instruction => offset,
    };
}

fn logicalFragmentSize(stored_fragment: fragment.Fragment, offset: u64) LayoutError!u64 {
    return switch (stored_fragment) {
        .bytes => |bytes| @intCast(bytes.data.len),
        .reserve => |reserve| reserve.size,
        .alignment => |alignment| {
            const aligned = try alignForward(offset, alignment.alignment);
            return aligned - offset;
        },
        .isa_instruction => |instruction| instruction.current_size,
    };
}

fn alignForward(value: u64, alignment: u64) LayoutError!u64 {
    if (alignment == 0) return error.OffsetOverflow;
    const remainder = value % alignment;
    if (remainder == 0) return value;
    return checkedAdd(value, alignment - remainder);
}

fn checkedAdd(a: u64, b: u64) LayoutError!u64 {
    return std.math.add(u64, a, b) catch error.OffsetOverflow;
}

test "layout trims tail reserve but materializes middle reserve" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    _ = try module.emitBytes(module.default_section, &.{ 0xaa, 0xbb }, source.unknown_span);
    _ = try module.reserve(module.default_section, 4, 1, source.unknown_span);
    _ = try module.emitBytes(module.default_section, &.{0xcc}, source.unknown_span);
    _ = try module.reserve(module.default_section, 8, 1, source.unknown_span);

    var result = try layoutModule(std.testing.allocator, &module);
    defer result.deinit(std.testing.allocator);

    const text = result.sectionLayout(module.default_section) orelse return error.MissingSectionLayout;
    try std.testing.expectEqual(@as(u64, 15), text.logical_size);
    try std.testing.expectEqual(@as(u64, 7), text.file_size);
    try std.testing.expectEqual(@as(usize, 4), text.fragments.len);
    try std.testing.expectEqual(@as(u64, 0), text.fragments[0].offset);
    try std.testing.expectEqual(@as(u64, 2), text.fragments[1].offset);
    try std.testing.expectEqual(@as(u64, 6), text.fragments[2].offset);
    try std.testing.expectEqual(@as(u64, 7), text.fragments[3].offset);
    try std.testing.expect(!text.fragments[1].trim_tail);
    try std.testing.expect(text.fragments[3].trim_tail);
}

test "layout accounts for alignment fragments" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    _ = try module.emitBytes(module.default_section, &.{ 1, 2, 3 }, source.unknown_span);
    _ = try module.addAlignment(module.default_section, 8, 0, source.unknown_span);
    _ = try module.emitBytes(module.default_section, &.{4}, source.unknown_span);

    var result = try layoutModule(std.testing.allocator, &module);
    defer result.deinit(std.testing.allocator);

    const text = result.sectionLayout(module.default_section) orelse return error.MissingSectionLayout;
    try std.testing.expectEqual(@as(u64, 9), text.logical_size);
    try std.testing.expectEqual(@as(u64, 9), text.file_size);
    try std.testing.expectEqual(@as(u64, 0), text.fragments[0].offset);
    try std.testing.expectEqual(@as(u64, 3), text.fragments[1].offset);
    try std.testing.expectEqual(@as(u64, 5), text.fragments[1].logical_size);
    try std.testing.expectEqual(@as(u64, 8), text.fragments[2].offset);
}

test "layout leaves reserve tails unmaterialized across empty fragments" {
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    _ = try module.emitBytes(module.default_section, &.{0xaa}, source.unknown_span);
    _ = try module.reserve(module.default_section, 3, 1, source.unknown_span);
    _ = try module.emitBytes(module.default_section, &.{}, source.unknown_span);
    _ = try module.addAlignment(module.default_section, 4, 0xbb, source.unknown_span);
    _ = try module.reserve(module.default_section, 0, 1, source.unknown_span);

    var result = try layoutModule(std.testing.allocator, &module);
    defer result.deinit(std.testing.allocator);

    const text = result.sectionLayout(module.default_section) orelse return error.MissingSectionLayout;
    try std.testing.expectEqual(@as(u64, 4), text.logical_size);
    try std.testing.expectEqual(@as(u64, 1), text.file_size);
    try std.testing.expect(text.fragments[1].trim_tail);
}

test "layout aligns file size without materializing tail reserve" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    _ = try module.emitBytes(module.default_section, &.{ 1, 2, 3 }, source.unknown_span);
    _ = try module.reserve(module.default_section, 1000, 1, source.unknown_span);
    try module.setFileSizeAlignment(module.default_section, 0x200);

    var result = try layoutModule(std.testing.allocator, &module);
    defer result.deinit(std.testing.allocator);

    const text = result.sectionLayout(module.default_section) orelse return error.MissingSectionLayout;
    try std.testing.expectEqual(@as(u64, 1003), text.logical_size);
    try std.testing.expectEqual(@as(u64, 0x200), text.file_size);
    try std.testing.expect(text.fragments[1].trim_tail);
    try std.testing.expectEqual(@as(u64, 0), text.fragments[1].file_size);
}

test "layout keeps virtual sections isolated" {
    var module = try module_mod.Module.init(std.testing.allocator, @import("target.zig").Target.default);
    defer module.deinit();

    const virtual_id = try module.createVirtualSection(0x1000);
    _ = try module.emitBytes(module.default_section, &.{0xaa}, source.unknown_span);
    _ = try module.emitBytes(virtual_id, &.{ 0x11, 0x22 }, source.unknown_span);

    var result = try layoutModule(std.testing.allocator, &module);
    defer result.deinit(std.testing.allocator);

    const main = result.sectionLayout(module.default_section) orelse return error.MissingSectionLayout;
    const virtual = result.sectionLayout(virtual_id) orelse return error.MissingSectionLayout;
    try std.testing.expectEqual(@as(u64, 0), main.origin);
    try std.testing.expectEqual(@as(u64, 1), main.file_size);
    try std.testing.expectEqual(@as(u64, 0x1000), virtual.origin);
    try std.testing.expectEqual(@as(u64, 2), virtual.file_size);
    try std.testing.expectEqual(@as(u64, 0), virtual.fragments[0].offset);
}

test "layout tolerates target import for ref all decls" {
    _ = target.Isa;
}

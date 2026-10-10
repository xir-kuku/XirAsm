const std = @import("std");

const fragment = @import("fragment.zig");

const Allocator = std.mem.Allocator;

pub const SectionId = fragment.SectionId;
pub const FragmentId = fragment.FragmentId;

pub const SectionKind = enum {
    main,
    virtual_output,
};

/// Phase 1 frontend output region.
///
/// This is deliberately not a PE/ELF/COFF section. It is a logical flat-output
/// region that owns an ordered list of fragments, an address origin, and a raw
/// output offset. Object-format section headers, flags, virtual addresses,
/// relocations, and writer policy belong to a later output-writer layer.
///
/// `origin` is the address basis used for label calculations. It must not be
/// interpreted as file padding. `file_offset` is the raw placement of this
/// logical region inside the final flat image. Explicit pad/reserve/align
/// fragments decide whether bytes are materialized. Keeping `origin` and
/// `file_offset` separate is what lets format DSLs model RVA/FOA without
/// inflating raw files.
pub const Section = struct {
    name: []u8,
    kind: SectionKind = .main,
    fragments: std.ArrayList(FragmentId) = .empty,
    origin: u64 = 0,
    file_offset: u64 = 0,
    file_size_alignment: u64 = 1,
    /// Raw-size alignment closes the region, including for later phases.
    file_aligned: bool = false,

    /// Prefix cursor cache, maintained by `layout_cursor`.
    ///
    /// `cursor_folded` counts the leading fragments whose final size is already
    /// folded into the two cursors below. A source that reads the current
    /// address once per generated row asks for the cursor once per row, and
    /// walking the whole region every time made that quadratic; folding each
    /// fragment exactly once makes it linear. Fragments are only ever appended
    /// to this list while lowering, so a folded prefix never has to be undone.
    cursor_folded: usize = 0,
    cursor_offset: u64 = 0,
    cursor_file_offset: u64 = 0,

    pub fn deinit(self: *Section, allocator: Allocator) void {
        allocator.free(self.name);
        self.fragments.deinit(allocator);
        self.* = undefined;
    }
};

pub const SectionStore = struct {
    items: std.ArrayList(Section) = .empty,

    pub fn deinit(self: *SectionStore, allocator: Allocator) void {
        for (self.items.items) |*section| {
            section.deinit(allocator);
        }
        self.items.deinit(allocator);
        self.* = undefined;
    }

    pub fn add(self: *SectionStore, allocator: Allocator, name: []const u8) !SectionId {
        return self.addWithKind(allocator, name, .main);
    }

    pub fn addWithKind(
        self: *SectionStore,
        allocator: Allocator,
        name: []const u8,
        kind: SectionKind,
    ) !SectionId {
        const id = try nextSectionId(self.items.items.len);
        const owned_name = try allocator.dupe(u8, name);
        errdefer allocator.free(owned_name);

        try self.items.append(allocator, .{
            .name = owned_name,
            .kind = kind,
        });
        return id;
    }

    pub fn appendFragment(
        self: *SectionStore,
        allocator: Allocator,
        section_id: SectionId,
        fragment_id: FragmentId,
    ) !void {
        const section = try self.getMut(section_id);
        try section.fragments.append(allocator, fragment_id);
    }

    pub fn setOrigin(self: *SectionStore, section_id: SectionId, origin: u64) !void {
        const section = try self.getMut(section_id);
        section.origin = origin;
    }

    pub fn setFileOffset(self: *SectionStore, section_id: SectionId, file_offset: u64) !void {
        const section = try self.getMut(section_id);
        section.file_offset = file_offset;
    }

    pub fn setFileSizeAlignment(self: *SectionStore, section_id: SectionId, alignment: u64) !void {
        const section = try self.getMut(section_id);
        section.file_size_alignment = alignment;
        section.file_aligned = true;
    }

    /// Used to promote a virtual region into a real one: the section keeps its
    /// fragments, labels, and fixups, and only its role changes.
    pub fn setKind(self: *SectionStore, section_id: SectionId, kind: SectionKind) !void {
        const section = try self.getMut(section_id);
        section.kind = kind;
    }

    /// A section name labels a region in diagnostics and listings; it is never
    /// used to look a region up.
    pub fn setName(
        self: *SectionStore,
        allocator: Allocator,
        section_id: SectionId,
        name: []const u8,
    ) !void {
        const owned_name = try allocator.dupe(u8, name);
        errdefer allocator.free(owned_name);

        const section = try self.getMut(section_id);
        allocator.free(section.name);
        section.name = owned_name;
    }

    pub fn hasName(self: *const SectionStore, name: []const u8) bool {
        for (self.items.items) |section| {
            if (std.mem.eql(u8, section.name, name)) return true;
        }
        return false;
    }

    pub fn get(self: *const SectionStore, id: SectionId) !*const Section {
        if (id.index >= self.items.items.len) return error.InvalidSection;
        return &self.items.items[id.index];
    }

    pub fn getMut(self: *SectionStore, id: SectionId) !*Section {
        if (id.index >= self.items.items.len) return error.InvalidSection;
        return &self.items.items[id.index];
    }
};

fn nextSectionId(len: usize) error{TooManySections}!SectionId {
    if (len > std.math.maxInt(u32)) return error.TooManySections;
    return .{ .index = @intCast(len) };
}

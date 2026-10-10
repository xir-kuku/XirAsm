const std = @import("std");

const fragment = @import("../fragment.zig");
const module_mod = @import("../module.zig");
const contracts = @import("contracts.zig");

const ActiveOutput = contracts.ActiveOutput;
const LowerError = contracts.LowerError;

pub const Error = error{
    InvalidAlignment,
    OffsetOverflow,
};

pub fn nextOffsetFromFragment(stored_fragment: fragment.Fragment, current_offset: u64) Error!u64 {
    const size: u64 = switch (stored_fragment) {
        .bytes => |bytes| @intCast(bytes.data.len),
        .reserve => |reserve| reserve.size,
        .alignment => |alignment| {
            if (alignment.alignment == 0) return error.InvalidAlignment;
            const remainder = current_offset % alignment.alignment;
            if (remainder == 0) return current_offset;
            return std.math.add(u64, current_offset, alignment.alignment - remainder) catch error.OffsetOverflow;
        },
        .isa_instruction => |instruction| instruction.current_size,
    };

    return std.math.add(u64, current_offset, size) catch error.OffsetOverflow;
}

pub fn nextFileOffsetFromFragment(
    stored_fragment: fragment.Fragment,
    current_offset: u64,
    current_file_offset: u64,
) Error!u64 {
    return switch (stored_fragment) {
        .bytes => |bytes| if (bytes.data.len == 0)
            current_file_offset
        else
            checkedAdd(try materializedOffset(current_offset, current_file_offset), @intCast(bytes.data.len)),
        .isa_instruction => |instruction| if (instruction.current_size == 0)
            current_file_offset
        else
            checkedAdd(try materializedOffset(current_offset, current_file_offset), instruction.current_size),
        .reserve => current_file_offset,
        .alignment => |alignment| {
            const aligned_offset = try alignForward(current_offset, alignment.alignment);
            if (aligned_offset == current_offset) return current_file_offset;
            const materialized = try materializedOffset(current_offset, current_file_offset);
            return alignForward(materialized, alignment.alignment);
        },
    };
}

pub fn materializedOffset(current_offset: u64, current_file_offset: u64) Error!u64 {
    return @max(current_offset, current_file_offset);
}

pub fn alignForward(value: u64, alignment: u64) Error!u64 {
    if (!isPowerOfTwoNonZero(alignment)) return error.InvalidAlignment;
    const remainder = value % alignment;
    if (remainder == 0) return value;
    return checkedAdd(value, alignment - remainder);
}

pub fn checkedAdd(a: u64, b: u64) Error!u64 {
    return std.math.add(u64, a, b) catch error.OffsetOverflow;
}

pub fn isPowerOfTwoNonZero(value: u64) bool {
    return value != 0 and (value & (value - 1)) == 0;
}

pub fn activeAddress(module: *const module_mod.Module, active: ActiveOutput) LowerError!u64 {
    const active_section = try module.sections.get(active.section_id);
    return std.math.add(u64, active_section.origin, active.offset) catch error.OffsetOverflow;
}

pub fn requireOpenOutputRegion(active: ActiveOutput) LowerError!void {
    if (active.file_aligned) return error.OutputRegionClosed;
}

pub fn discardLastActiveOutput(output_stack: *std.ArrayList(ActiveOutput)) void {
    // The API registers this only as an errdefer after a successful stack append.
    output_stack.shrinkRetainingCapacity(output_stack.items.len - 1);
}

pub fn advanceActiveOutput(active: *ActiveOutput, stored_fragment: fragment.Fragment) LowerError!void {
    active.file_offset = try nextFileOffsetFromFragment(stored_fragment, active.offset, active.file_offset);
    active.offset = try nextOffsetFromFragment(stored_fragment, active.offset);
}

/// Cursor of a section. Computing it folds newly final fragments into the
/// section's memo, so the module is taken mutably: a caller that only holds a
/// const module would silently pay the quadratic walk again.
pub fn sectionCursor(module: *module_mod.Module, section_id: fragment.SectionId) LowerError!u64 {
    return (try sectionCursors(module, section_id)).cursor;
}

pub fn sectionFileCursor(module: *module_mod.Module, section_id: fragment.SectionId) LowerError!u64 {
    const cursors = try sectionCursors(module, section_id);
    const stored_section = try module.sections.get(section_id);
    return alignForward(cursors.file_cursor, stored_section.file_size_alignment);
}

const Cursors = struct {
    cursor: u64,
    file_cursor: u64,
};

/// Walk a section's fragments, folding every fragment whose size is already
/// final into the section's cache.
///
/// Reading the current address asks for the cursor once per generated row, so
/// walking from zero every time is quadratic over such a source. A fragment
/// whose size is still unknown -- an instruction that has not been encoded yet
/// -- is applied without being folded, so the answer stays exactly what a full
/// walk would produce while the fold stays safe to keep.
fn sectionCursors(module: *module_mod.Module, section_id: fragment.SectionId) LowerError!Cursors {
    const stored_section = try module.sections.getMut(section_id);
    var cursor: u64 = stored_section.cursor_offset;
    var file_cursor: u64 = stored_section.cursor_file_offset;
    var index = stored_section.cursor_folded;
    const final_limit = module.materialized_fragment_count;

    while (index < stored_section.fragments.items.len) : (index += 1) {
        const fragment_index = stored_section.fragments.items[index].index;
        const stored_fragment = module.fragments.items.items[fragment_index];
        const next_file_cursor = try nextFileOffsetFromFragment(stored_fragment, cursor, file_cursor);
        cursor = try nextOffsetFromFragment(stored_fragment, cursor);
        file_cursor = next_file_cursor;

        if (fragment_index < final_limit) {
            stored_section.cursor_folded = index + 1;
            stored_section.cursor_offset = cursor;
            stored_section.cursor_file_offset = file_cursor;
        }
    }

    return .{ .cursor = cursor, .file_cursor = file_cursor };
}

pub fn activeFragmentPosition(module: *const module_mod.Module, section_id: fragment.SectionId) LowerError!u32 {
    const stored_section = try module.sections.get(section_id);
    if (stored_section.fragments.items.len > std.math.maxInt(u32)) return error.FragmentTooLarge;
    return @intCast(stored_section.fragments.items.len);
}

test "layout cursor rejects invalid alignment" {
    try std.testing.expectError(error.InvalidAlignment, alignForward(1, 3));
}

test "layout file cursor materializes reserve only when bytes follow" {
    const section_id: fragment.SectionId = .{ .index = 0 };
    const span = @import("../source.zig").unknown_span;
    const empty: fragment.Fragment = .{ .bytes = .{
        .section = section_id,
        .data = &.{},
        .span = span,
    } };
    try std.testing.expectEqual(@as(u64, 1), try nextFileOffsetFromFragment(empty, 4, 1));

    const aligned: fragment.Fragment = .{ .alignment = .{
        .section = section_id,
        .alignment = 4,
        .fill = 0,
        .span = span,
    } };
    try std.testing.expectEqual(@as(u64, 1), try nextFileOffsetFromFragment(aligned, 4, 1));
    try std.testing.expectEqual(@as(u64, 4), try nextFileOffsetFromFragment(aligned, 3, 1));

    var zero = [_]u8{0};
    const initialized: fragment.Fragment = .{ .bytes = .{
        .section = section_id,
        .data = &zero,
        .span = span,
    } };
    try std.testing.expectEqual(@as(u64, 5), try nextFileOffsetFromFragment(initialized, 4, 1));
}

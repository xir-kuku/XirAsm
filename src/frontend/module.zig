const std = @import("std");

const diagnostic = @import("diagnostic.zig");
const fixup = @import("fixup.zig");
const fragment = @import("fragment.zig");
const meta_function = @import("meta_function.zig");
const output_contracts = @import("output/contracts.zig");
const section = @import("section.zig");
const source = @import("source.zig");
const symbol = @import("symbol.zig");
const target_mod = @import("target.zig");
const types = @import("types.zig");
const value = @import("value.zig");

const Allocator = std.mem.Allocator;

pub const TypeNameBinding = struct {
    name: []u8,
    ty: types.TypeId,

    pub fn deinit(self: *TypeNameBinding, allocator: Allocator) void {
        allocator.free(self.name);
        self.* = undefined;
    }
};

pub const Module = struct {
    allocator: Allocator,
    target: target_mod.Target,
    sections: section.SectionStore = .{},
    symbols: symbol.SymbolStore = .{},
    /// Bumped whenever a module-level value binding is added or replaced.
    ///
    /// A macro capture keeps a snapshot of those bindings so evaluating it later
    /// reads the values it was taken with. Captures taken while this is unchanged
    /// can share one snapshot instead of each copying every generated table, and
    /// this counter is what tells them the snapshot is still current.
    value_generation: u64 = 0,
    fragments: fragment.FragmentStore = .{},
    fixups: fixup.FixupStore = .{},
    types: types.TypeStore = .{},
    type_names: std.ArrayList(TypeNameBinding) = .empty,
    /// Name lookup index for `type_names`. It borrows the names those bindings own
    /// (it must never free them) and is only consulted while it covers every entry;
    /// an insertion that cannot be indexed leaves it short, and lookup falls back to
    /// scanning. Registering types was quadratic before this index existed, because
    /// every declaration scanned the whole table to reject duplicates.
    type_name_index: std.StringHashMapUnmanaged(types.TypeId) = .empty,
    value_functions: meta_function.Store = .{},
    virtual_sections: std.ArrayList(section.SectionId) = .empty,
    /// How many fragments the last on-demand instruction encoding saw. Reading the
    /// current address needs every earlier instruction encoded, and the encoding
    /// walks all fragments, so the count is the memo that keeps that cheap.
    materialized_fragment_count: usize = 0,
    /// Set once a SPIR-V instruction fragment exists. The encoder validates that
    /// every SPIR-V fragment agrees on section and version, and that check walks
    /// the module; without this flag every x86 or RISC-V encode would pay for it.
    has_spirv_fragments: bool = false,
    /// How many anchored labels were ever defined, so the encoder can skip
    /// rebuilding a module layout for a module that has none. Redefining a name
    /// can only leave this high, which costs an unnecessary sync, never a missed
    /// one.
    anchored_label_count: usize = 0,
    late_layout: output_contracts.LateLayoutStore = .{},
    deferred: output_contracts.DeferredStore = .{},
    sources: source.SourceMap = .{},
    imported_sources: std.ArrayList([]u8) = .empty,
    diagnostics: diagnostic.DiagnosticStore = .{},
    default_section: section.SectionId,

    pub fn init(allocator: Allocator, target: target_mod.Target) !Module {
        var module = Module{
            .allocator = allocator,
            .target = target,
            .default_section = .{ .index = 0 },
        };
        errdefer module.deinit();

        module.default_section = try module.sections.add(allocator, ".text");
        return module;
    }

    pub fn deinit(self: *Module) void {
        self.diagnostics.deinit(self.allocator);
        for (self.imported_sources.items) |path| self.allocator.free(path);
        self.imported_sources.deinit(self.allocator);
        self.sources.deinit(self.allocator);
        self.deferred.deinit(self.allocator);
        self.late_layout.deinit(self.allocator);
        self.value_functions.deinit(self.allocator);
        self.type_name_index.deinit(self.allocator);
        for (self.type_names.items) |*binding| {
            binding.deinit(self.allocator);
        }
        self.type_names.deinit(self.allocator);
        self.virtual_sections.deinit(self.allocator);
        self.types.deinit(self.allocator);
        self.fixups.deinit(self.allocator);
        self.fragments.deinit(self.allocator);
        self.symbols.deinit(self.allocator);
        self.sections.deinit(self.allocator);
        self.* = undefined;
    }

    pub fn addSource(self: *Module, path: []const u8, bytes: []const u8) !source.SourceId {
        return self.sources.add(self.allocator, path, bytes);
    }

    pub fn hasImportedSource(self: *const Module, identity: []const u8) bool {
        for (self.imported_sources.items) |stored| {
            if (std.mem.eql(u8, stored, identity)) return true;
        }
        return false;
    }

    pub fn rememberImportedSource(self: *Module, identity: []const u8) Allocator.Error!void {
        if (self.hasImportedSource(identity)) return;
        const owned_identity = try self.allocator.dupe(u8, identity);
        errdefer self.allocator.free(owned_identity);
        try self.imported_sources.append(self.allocator, owned_identity);
    }

    pub fn emitBytes(
        self: *Module,
        section_id: section.SectionId,
        bytes: []const u8,
        span: source.SourceSpan,
    ) !fragment.FragmentId {
        const fragment_id = try self.fragments.addBytes(self.allocator, section_id, bytes, span);
        errdefer removeLastFragment(&self.fragments, self.allocator);
        try self.sections.appendFragment(self.allocator, section_id, fragment_id);
        return fragment_id;
    }

    /// Read from the current module byte space before final image materialization.
    ///
    /// Mutable access to an encoded ISA instruction freezes that fragment into a
    /// plain bytes fragment. After that point the original instruction text is no
    /// longer an encoding/fixup source of truth for the touched range.
    pub fn loadIntegerAt(
        self: *const Module,
        section_id: section.SectionId,
        absolute_address: u64,
        byte_count: u8,
    ) !u64 {
        if (!validScalarByteCount(byte_count)) return error.InvalidApiInteger;
        var bytes: [8]u8 = @splat(0);
        try self.loadBytesAt(section_id, absolute_address, bytes[0..byte_count]);
        return std.mem.readInt(u64, &bytes, .little);
    }

    pub fn storeIntegerAt(
        self: *Module,
        section_id: section.SectionId,
        absolute_address: u64,
        integer_value: u64,
        byte_count: u8,
    ) !void {
        if (!validScalarByteCount(byte_count)) return error.InvalidApiInteger;
        if (!integerFitsByteCount(integer_value, byte_count)) return error.InvalidApiInteger;
        var bytes: [8]u8 = undefined;
        std.mem.writeInt(u64, &bytes, integer_value, .little);
        try self.storeBytesAt(section_id, absolute_address, bytes[0..byte_count]);
    }

    pub fn loadBytesAt(
        self: *const Module,
        section_id: section.SectionId,
        absolute_address: u64,
        out: []u8,
    ) !void {
        const section_offset = try sectionOffsetForAddress(self, section_id, absolute_address, out.len);
        var copied: usize = 0;
        while (copied < out.len) {
            const part = try bytesFragmentRangeAt(self, section_id, section_offset + copied);
            const copy_count = @min(out.len - copied, part.bytes.len - part.offset);
            @memcpy(out[copied..][0..copy_count], part.bytes[part.offset..][0..copy_count]);
            copied += copy_count;
        }
    }

    pub fn storeBytesAt(
        self: *Module,
        section_id: section.SectionId,
        absolute_address: u64,
        bytes: []const u8,
    ) !void {
        const section_offset = try sectionOffsetForAddress(self, section_id, absolute_address, bytes.len);
        var copied: usize = 0;
        while (copied < bytes.len) {
            const part = try bytesFragmentRangeAtMut(self, section_id, section_offset + copied);
            const copy_count = @min(bytes.len - copied, part.bytes.len - part.offset);
            @memcpy(part.bytes[part.offset..][0..copy_count], bytes[copied..][0..copy_count]);
            copied += copy_count;
        }
    }

    pub fn appendDeferredBlock(self: *Module, block: output_contracts.DeferredBlock) !void {
        try self.deferred.append(self.allocator, block);
    }

    pub fn appendLateLayoutBlock(self: *Module, block: output_contracts.LateLayoutBlock) !void {
        try self.late_layout.append(self.allocator, block);
    }

    pub fn emitRepeatedByte(
        self: *Module,
        section_id: section.SectionId,
        byte: u8,
        count: u64,
        span: source.SourceSpan,
    ) !fragment.FragmentId {
        if (count > std.math.maxInt(usize)) return error.FragmentTooLarge;
        const bytes = try self.allocator.alloc(u8, @intCast(count));
        defer self.allocator.free(bytes);
        @memset(bytes, byte);
        return self.emitBytes(section_id, bytes, span);
    }

    pub fn reserve(
        self: *Module,
        section_id: section.SectionId,
        size: u64,
        alignment: u64,
        span: source.SourceSpan,
    ) !fragment.FragmentId {
        const fragment_id = try self.fragments.addReserve(self.allocator, section_id, size, alignment, span);
        errdefer removeLastFragment(&self.fragments, self.allocator);
        try self.sections.appendFragment(self.allocator, section_id, fragment_id);
        return fragment_id;
    }

    pub fn addAlignment(
        self: *Module,
        section_id: section.SectionId,
        alignment: u64,
        fill: u8,
        span: source.SourceSpan,
    ) !fragment.FragmentId {
        const fragment_id = try self.fragments.addAlignment(self.allocator, section_id, alignment, fill, span);
        errdefer removeLastFragment(&self.fragments, self.allocator);
        try self.sections.appendFragment(self.allocator, section_id, fragment_id);
        return fragment_id;
    }

    pub fn setOrigin(self: *Module, section_id: section.SectionId, origin: u64) !void {
        try self.sections.setOrigin(section_id, origin);
    }

    pub fn setFileOffset(self: *Module, section_id: section.SectionId, file_offset: u64) !void {
        try self.sections.setFileOffset(section_id, file_offset);
    }

    pub fn setFileSizeAlignment(self: *Module, section_id: section.SectionId, alignment: u64) !void {
        try self.sections.setFileSizeAlignment(section_id, alignment);
    }

    pub fn createOutputSection(
        self: *Module,
        name: []const u8,
        origin: u64,
        file_offset: u64,
    ) !section.SectionId {
        const section_id = try self.sections.addWithKind(self.allocator, name, .main);
        errdefer removeLastSection(&self.sections, self.allocator);

        try self.sections.setOrigin(section_id, origin);
        try self.sections.setFileOffset(section_id, file_offset);
        return section_id;
    }

    pub fn createVirtualSection(self: *Module, origin: u64) !section.SectionId {
        const section_id = try self.sections.addWithKind(self.allocator, ".virtual", .virtual_output);
        errdefer removeLastSection(&self.sections, self.allocator);

        try self.sections.setOrigin(section_id, origin);
        try self.virtual_sections.append(self.allocator, section_id);
        return section_id;
    }

    /// Turn a virtual region into a real output region at `origin`/`file_offset`.
    ///
    /// This is how scratch content reaches the file when its instructions carry
    /// references. The section keeps its fragments, labels, and fixups, so a
    /// reference encoded inside it is resolved against the new address by the
    /// ordinary fixup pass, exactly like a hand-written instruction. It has to
    /// happen before fixups are resolved, which is why late layout is the place
    /// to call it.
    pub fn promoteVirtualSection(
        self: *Module,
        section_id: section.SectionId,
        origin: u64,
        file_offset: u64,
    ) !void {
        const stored = try self.sections.get(section_id);
        if (stored.kind != .virtual_output) return error.InvalidSection;
        try self.sections.setKind(section_id, .main);
        try self.sections.setOrigin(section_id, origin);
        try self.sections.setFileOffset(section_id, file_offset);
        for (self.virtual_sections.items, 0..) |candidate, index| {
            if (candidate.index != section_id.index) continue;
            _ = self.virtual_sections.orderedRemove(index);
            break;
        }
    }

    pub fn appendIsaInstruction(
        self: *Module,
        section_id: section.SectionId,
        instruction_target: target_mod.Target,
        text: []const u8,
        span: source.SourceSpan,
    ) !fragment.FragmentId {
        const fragment_id = try self.fragments.addIsaInstruction(
            self.allocator,
            section_id,
            instruction_target,
            text,
            0,
            0,
            0,
            span,
        );
        errdefer removeLastFragment(&self.fragments, self.allocator);
        try self.sections.appendFragment(self.allocator, section_id, fragment_id);
        if (instruction_target.isa() == .spirv) self.has_spirv_fragments = true;
        return fragment_id;
    }

    pub fn addFixup(
        self: *Module,
        fragment_id: fragment.FragmentId,
        symbol_name: []const u8,
        kind: fixup.FixupKind,
        offset: u32,
        width_bits: u16,
        span: source.SourceSpan,
    ) !fixup.FixupId {
        return self.fixups.add(
            self.allocator,
            fragment_id,
            symbol_name,
            kind,
            offset,
            width_bits,
            span,
        );
    }

    pub fn addExpressionFixup(
        self: *Module,
        fragment_id: fragment.FragmentId,
        expression_text: []const u8,
        kind: fixup.FixupKind,
        offset: u32,
        width_bits: u16,
        span: source.SourceSpan,
    ) !fixup.FixupId {
        return self.fixups.addExpression(
            self.allocator,
            fragment_id,
            expression_text,
            kind,
            offset,
            width_bits,
            span,
        );
    }

    pub fn defineLabel(
        self: *Module,
        name: []const u8,
        section_id: section.SectionId,
        offset: u64,
        span: source.SourceSpan,
    ) !symbol.SymbolId {
        return self.symbols.defineLabel(self.allocator, name, section_id, offset, span);
    }

    pub fn defineAnchoredLabel(
        self: *Module,
        name: []const u8,
        section_id: section.SectionId,
        offset: u64,
        fragment_position: u32,
        span: source.SourceSpan,
    ) !symbol.SymbolId {
        self.anchored_label_count += 1;
        return self.symbols.defineAnchoredLabel(self.allocator, name, section_id, offset, fragment_position, span);
    }

    pub fn defineValue(
        self: *Module,
        name: []const u8,
        stored_value: value.Value,
        mutability: value.Mutability,
        span: source.SourceSpan,
    ) !symbol.SymbolId {
        const id = try self.symbols.defineValue(self.allocator, name, stored_value, mutability, span);
        self.value_generation +%= 1;
        return id;
    }

    pub fn setValue(
        self: *Module,
        name: []const u8,
        stored_value: value.Value,
    ) !void {
        try self.symbols.setValue(self.allocator, name, stored_value);
        self.value_generation +%= 1;
    }

    pub fn addIntType(
        self: *Module,
        bits: u16,
        signedness: types.IntSignedness,
    ) !types.TypeId {
        return self.types.addInt(self.allocator, bits, signedness);
    }

    pub fn getOrAddIntType(
        self: *Module,
        name: []const u8,
        bits: u16,
        signedness: types.IntSignedness,
    ) !types.TypeId {
        if (self.lookupTypeName(name)) |id| return id;
        const id = try self.addIntType(bits, signedness);
        errdefer removeLastType(&self.types, self.allocator);
        try self.registerTypeName(name, id);
        return id;
    }

    pub fn addStructType(
        self: *Module,
        name: []const u8,
        fields: []const types.StructFieldSpec,
        policy: types.StructLayoutPolicy,
    ) !types.TypeId {
        return self.types.addStruct(self.allocator, name, fields, policy);
    }

    pub fn getOrAddFloatType(
        self: *Module,
        name: []const u8,
        width: types.FloatWidth,
    ) !types.TypeId {
        if (self.lookupTypeName(name)) |id| return id;
        const id = try self.types.addFloat(self.allocator, width);
        errdefer removeLastType(&self.types, self.allocator);
        try self.registerTypeName(name, id);
        return id;
    }

    pub fn addUnionType(
        self: *Module,
        name: []const u8,
        fields: []const types.StructFieldSpec,
        policy: types.StructLayoutPolicy,
    ) !types.TypeId {
        return self.types.addUnion(self.allocator, name, fields, policy);
    }

    pub fn typeLayout(self: *const Module, id: types.TypeId) !types.Layout {
        return self.types.layoutOf(id);
    }

    pub fn registerTypeName(self: *Module, name: []const u8, id: types.TypeId) !void {
        if (self.lookupTypeName(name) != null) return error.DuplicateTypeName;
        const owned_name = try self.allocator.dupe(u8, name);
        errdefer self.allocator.free(owned_name);

        try self.type_names.append(self.allocator, .{
            .name = owned_name,
            .ty = id,
        });
        // The index has to take every entry. When it cannot, the entry that points
        // at the name is dropped as well, so the table never refers to freed memory.
        errdefer {
            _ = self.type_names.pop();
        }
        try self.type_name_index.put(self.allocator, owned_name, id);
    }

    pub fn lookupTypeName(self: *const Module, name: []const u8) ?types.TypeId {
        if (self.type_name_index.count() == self.type_names.items.len) {
            return self.type_name_index.get(name);
        }
        for (self.type_names.items) |binding| {
            if (std.mem.eql(u8, binding.name, name)) return binding.ty;
        }
        return null;
    }
};

fn validScalarByteCount(byte_count: u8) bool {
    return byte_count == 1 or byte_count == 2 or byte_count == 4 or byte_count == 8;
}

fn integerFitsByteCount(integer_value: u64, byte_count: u8) bool {
    return switch (byte_count) {
        1 => integer_value <= std.math.maxInt(u8),
        2 => integer_value <= std.math.maxInt(u16),
        4 => integer_value <= std.math.maxInt(u32),
        8 => true,
        else => false,
    };
}

fn sectionOffsetForAddress(
    module: *const Module,
    section_id: section.SectionId,
    absolute_address: u64,
    byte_count: usize,
) !usize {
    const stored_section = try module.sections.get(section_id);
    if (absolute_address < stored_section.origin) return error.InvalidApiArgument;
    const start_offset = absolute_address - stored_section.origin;
    if (start_offset > std.math.maxInt(usize)) return error.InvalidApiArgument;
    const end_offset = std.math.add(u64, start_offset, byte_count) catch return error.OffsetOverflow;
    if (end_offset > std.math.maxInt(usize)) return error.InvalidApiArgument;
    return @intCast(start_offset);
}

const BytesRange = struct {
    bytes: []u8,
    offset: usize,
};

const ConstBytesRange = struct {
    bytes: []const u8,
    offset: usize,
};

fn bytesFragmentRangeAt(
    module: *const Module,
    section_id: section.SectionId,
    section_offset: usize,
) !ConstBytesRange {
    const stored_section = try module.sections.get(section_id);
    var cursor: usize = 0;
    for (stored_section.fragments.items) |fragment_id| {
        const stored_fragment = try fragmentAt(module, fragment_id);
        switch (stored_fragment.*) {
            .bytes => |bytes| {
                const fragment_end = std.math.add(usize, cursor, bytes.data.len) catch return error.OffsetOverflow;
                if (section_offset < fragment_end) {
                    return .{
                        .bytes = bytes.data,
                        .offset = section_offset - cursor,
                    };
                }
                cursor = fragment_end;
            },
            .isa_instruction => |instruction| {
                const fragment_end = std.math.add(usize, cursor, instruction.encoded_bytes.len) catch return error.OffsetOverflow;
                if (section_offset < fragment_end) {
                    return .{
                        .bytes = instruction.encoded_bytes,
                        .offset = section_offset - cursor,
                    };
                }
                cursor = fragment_end;
            },
            .reserve => |reserve| {
                const fragment_start = try alignedOffsetForReserve(cursor, reserve.alignment);
                const fragment_end = std.math.add(usize, fragment_start, try sizeToUsize(reserve.size)) catch return error.OffsetOverflow;
                if (section_offset < fragment_end) return error.InvalidApiArgument;
                cursor = fragment_end;
            },
            .alignment => |alignment| {
                const fragment_end = try alignedOffset(cursor, alignment.alignment);
                if (section_offset < fragment_end) return error.InvalidApiArgument;
                cursor = fragment_end;
            },
        }
    }
    return error.InvalidApiArgument;
}

fn bytesFragmentRangeAtMut(
    module: *Module,
    section_id: section.SectionId,
    section_offset: usize,
) !BytesRange {
    const stored_section = try module.sections.get(section_id);
    var cursor: usize = 0;
    for (stored_section.fragments.items) |fragment_id| {
        const stored_fragment = try fragmentAtMut(module, fragment_id);
        switch (stored_fragment.*) {
            .bytes => |*bytes| {
                const fragment_end = std.math.add(usize, cursor, bytes.data.len) catch return error.OffsetOverflow;
                if (section_offset < fragment_end) {
                    return .{
                        .bytes = bytes.data,
                        .offset = section_offset - cursor,
                    };
                }
                cursor = fragment_end;
            },
            .isa_instruction => |*instruction| {
                const fragment_end = std.math.add(usize, cursor, instruction.encoded_bytes.len) catch return error.OffsetOverflow;
                if (section_offset < fragment_end) {
                    const frozen_section = instruction.section;
                    const frozen_span = instruction.span;
                    const frozen_text = instruction.text;
                    const frozen_bytes = instruction.encoded_bytes;
                    module.allocator.free(frozen_text);
                    stored_fragment.* = .{
                        .bytes = .{
                            .section = frozen_section,
                            .data = frozen_bytes,
                            .span = frozen_span,
                        },
                    };
                    return switch (stored_fragment.*) {
                        .bytes => |*bytes| .{
                            .bytes = bytes.data,
                            .offset = section_offset - cursor,
                        },
                        else => error.InvalidFragment,
                    };
                }
                cursor = fragment_end;
            },
            .reserve => |reserve| {
                const fragment_start = try alignedOffsetForReserve(cursor, reserve.alignment);
                const fragment_end = std.math.add(usize, fragment_start, try sizeToUsize(reserve.size)) catch return error.OffsetOverflow;
                if (section_offset < fragment_end) return error.InvalidApiArgument;
                cursor = fragment_end;
            },
            .alignment => |alignment| {
                const fragment_end = try alignedOffset(cursor, alignment.alignment);
                if (section_offset < fragment_end) return error.InvalidApiArgument;
                cursor = fragment_end;
            },
        }
    }
    return error.InvalidApiArgument;
}

fn sizeToUsize(amount: u64) !usize {
    if (amount > std.math.maxInt(usize)) return error.FragmentTooLarge;
    return @intCast(amount);
}

fn alignedOffsetForReserve(offset: usize, alignment: u64) !usize {
    return alignedOffset(offset, alignment);
}

fn alignedOffset(offset: usize, alignment: u64) !usize {
    if (alignment == 0) return error.OffsetOverflow;
    const alignment_usize = try sizeToUsize(alignment);
    const remainder = offset % alignment_usize;
    if (remainder == 0) return offset;
    return std.math.add(usize, offset, alignment_usize - remainder) catch return error.OffsetOverflow;
}

fn fragmentAt(module: *const Module, id: fragment.FragmentId) !*const fragment.Fragment {
    if (id.index >= module.fragments.items.items.len) return error.InvalidFragment;
    return &module.fragments.items.items[id.index];
}

fn fragmentAtMut(module: *Module, id: fragment.FragmentId) !*fragment.Fragment {
    if (id.index >= module.fragments.items.items.len) return error.InvalidFragment;
    return &module.fragments.items.items[id.index];
}

fn removeLastFragment(store: *fragment.FragmentStore, allocator: Allocator) void {
    if (store.items.items.len == 0) return;
    const last_index = store.items.items.len - 1;
    var removed = store.items.items[last_index];
    store.items.shrinkRetainingCapacity(last_index);
    removed.deinit(allocator);
}

fn removeLastSection(store: *section.SectionStore, allocator: Allocator) void {
    if (store.items.items.len == 0) return;
    const last_index = store.items.items.len - 1;
    var removed = store.items.items[last_index];
    store.items.shrinkRetainingCapacity(last_index);
    removed.deinit(allocator);
}

fn removeLastType(store: *types.TypeStore, allocator: Allocator) void {
    if (store.items.items.len == 0) return;
    const last_index = store.items.items.len - 1;
    var removed = store.items.items[last_index];
    store.items.shrinkRetainingCapacity(last_index);
    removed.deinit(allocator);
}

test "module initializes with default text section" {
    var module = try Module.init(std.testing.allocator, target_mod.Target.default);
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 1), module.sections.items.items.len);
    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqualStrings(".text", text.name);
    try std.testing.expectEqual(section.SectionKind.main, text.kind);
}

test "module creates isolated virtual output sections" {
    var module = try Module.init(std.testing.allocator, target_mod.Target.default);
    defer module.deinit();

    const virtual_id = try module.createVirtualSection(0x1000);
    _ = try module.emitBytes(virtual_id, &.{ 0x11, 0x22 }, source.unknown_span);

    try std.testing.expectEqual(@as(usize, 2), module.sections.items.items.len);
    try std.testing.expectEqual(@as(usize, 1), module.virtual_sections.items.len);
    try std.testing.expectEqual(virtual_id.index, module.virtual_sections.items[0].index);

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 0), text.fragments.items.len);

    const virtual = try module.sections.get(virtual_id);
    try std.testing.expectEqual(section.SectionKind.virtual_output, virtual.kind);
    try std.testing.expectEqual(@as(u64, 0x1000), virtual.origin);
    try std.testing.expectEqual(@as(usize, 1), virtual.fragments.items.len);
}

test "module creates logical output sections with raw file offsets" {
    var module = try Module.init(std.testing.allocator, target_mod.Target.default);
    defer module.deinit();

    const section_id = try module.createOutputSection(".rdata", 0x140002000, 0x400);
    const stored = try module.sections.get(section_id);

    try std.testing.expectEqual(section.SectionKind.main, stored.kind);
    try std.testing.expectEqual(@as(u64, 0x140002000), stored.origin);
    try std.testing.expectEqual(@as(u64, 0x400), stored.file_offset);
}

test "module records bytes fragments and labels" {
    var module = try Module.init(std.testing.allocator, target_mod.Target.default);
    defer module.deinit();

    const span = source.unknown_span;
    const fragment_id = try module.emitBytes(module.default_section, &.{0x90}, span);
    const symbol_id = try module.defineLabel("entry", module.default_section, 0, span);

    try std.testing.expectEqual(@as(u32, 0), fragment_id.index);
    try std.testing.expectEqual(@as(u32, 0), symbol_id.index);
    try std.testing.expect(module.symbols.lookup("entry") != null);

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
}

test "module records frontend value symbols" {
    var module = try Module.init(std.testing.allocator, target_mod.Target.default);
    defer module.deinit();

    _ = try module.defineValue("page", value.Value.int(4096), .@"const", source.unknown_span);
    const id = module.symbols.lookup("page") orelse return error.MissingSymbol;
    const stored = try module.symbols.get(id);
    switch (stored.binding) {
        .value => |binding| try std.testing.expectEqual(@as(u64, 4096), try binding.value.expectInteger()),
        else => return error.UnexpectedSymbolBinding,
    }
}

test "module records flat layout API fragments" {
    var module = try Module.init(std.testing.allocator, target_mod.Target.default);
    defer module.deinit();

    try module.setOrigin(module.default_section, 0x7c00);
    _ = try module.emitRepeatedByte(module.default_section, 0xcc, 4, source.unknown_span);
    _ = try module.reserve(module.default_section, 8, 1, source.unknown_span);
    _ = try module.addAlignment(module.default_section, 16, 0, source.unknown_span);

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(u64, 0x7c00), text.origin);
    try std.testing.expectEqual(@as(usize, 3), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 4), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0xcc), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[2].index]) {
        .alignment => |alignment| {
            try std.testing.expectEqual(@as(u64, 16), alignment.alignment);
            try std.testing.expectEqual(@as(u8, 0), alignment.fill);
        },
        else => return error.UnexpectedFragment,
    }
}

test "module records ISA instruction fragments without encoding them" {
    var module = try Module.init(std.testing.allocator, target_mod.Target.default);
    defer module.deinit();

    const fragment_id = try module.appendIsaInstruction(
        module.default_section,
        target_mod.Target.default,
        "mov rax, 1",
        source.unknown_span,
    );

    try std.testing.expectEqual(@as(u32, 0), fragment_id.index);
    const stored = module.fragments.items.items[fragment_id.index];
    switch (stored) {
        .isa_instruction => |instruction| {
            try std.testing.expectEqual(target_mod.Isa.x86_64, instruction.target.isa());
            try std.testing.expectEqual(@as(u16, 64), instruction.target.bits().?);
            try std.testing.expectEqualStrings("mov rax, 1", instruction.text);
            try std.testing.expectEqual(@as(usize, 0), instruction.encoded_bytes.len);
            try std.testing.expectEqual(@as(u32, 0), instruction.current_size);
            try std.testing.expect(!instruction.relaxable);
        },
        else => return error.UnexpectedFragment,
    }
}

test "module owns frontend type declarations" {
    var module = try Module.init(std.testing.allocator, target_mod.Target.default);
    defer module.deinit();

    const u16_ty = try module.addIntType(16, .unsigned);
    const u32_ty = try module.addIntType(32, .unsigned);
    const header_ty = try module.addStructType(
        "Header",
        &.{
            .{ .name = "magic", .ty = u16_ty },
            .{ .name = "size", .ty = u32_ty },
        },
        .@"packed",
    );

    const layout = try module.typeLayout(header_ty);
    try std.testing.expectEqual(@as(u64, 6), layout.size);
    try std.testing.expectEqual(@as(u64, 2), try module.types.structFieldOffset(header_ty, "size"));
}

test "module reuses named primitive types" {
    var module = try Module.init(std.testing.allocator, target_mod.Target.default);
    defer module.deinit();

    const first = try module.getOrAddIntType("u16", 16, .unsigned);
    const second = try module.getOrAddIntType("u16", 16, .unsigned);

    try std.testing.expectEqual(first.index, second.index);
    try std.testing.expectEqual(@as(usize, 1), module.types.items.items.len);
    try std.testing.expectEqual(@as(usize, 1), module.type_names.items.len);
    try std.testing.expect((module.lookupTypeName("u16") orelse return error.MissingType).index == first.index);
}

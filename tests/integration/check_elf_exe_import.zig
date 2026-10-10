const std = @import("std");

const Io = std.Io;
const Allocator = std.mem.Allocator;

const CheckError = error{
    InvalidNumber,
    InvalidElfExeImport,
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var stderr_buffer: [2048]u8 = undefined;
    var stderr_file_writer = Io.File.stderr().writer(init.io, &stderr_buffer);
    const stderr = &stderr_file_writer.interface;

    if (args.len != 22 and args.len != 31) {
        try stderr.print(
            "usage: {s} <elf> <file-size> <entry> <interp-foa> <dynsym-foa> <dynsym-vaddr> <dynstr-foa> <dynstr-vaddr> <dynstr-size> <hash-foa> <hash-vaddr> <rela-foa> <rela-vaddr> <rela-size> <dynamic-foa> <dynamic-vaddr> <dynamic-size> <slot-foa> <slot-vaddr> <symbol-name> <needed-library> [plt-foa plt-vaddr gotplt-foa gotplt-vaddr jmprel-foa jmprel-vaddr jmprel-size plt-slot-foa plt-slot-vaddr]\n",
            .{args[0]},
        );
        try stderr.flush();
        std.process.exit(2);
    }

    const bytes = try readFile(allocator, init.io, args[1]);
    const expected_file_size = try parseNumber(u64, args[2]);
    const expected_entry = try parseNumber(u64, args[3]);
    const expected_interp_foa = try parseNumber(u64, args[4]);
    const expected_dynsym_foa = try parseNumber(u64, args[5]);
    const expected_dynsym_vaddr = try parseNumber(u64, args[6]);
    const expected_dynstr_foa = try parseNumber(u64, args[7]);
    const expected_dynstr_vaddr = try parseNumber(u64, args[8]);
    const expected_dynstr_size = try parseNumber(u64, args[9]);
    const expected_hash_foa = try parseNumber(u64, args[10]);
    const expected_hash_vaddr = try parseNumber(u64, args[11]);
    const expected_rela_foa = try parseNumber(u64, args[12]);
    const expected_rela_vaddr = try parseNumber(u64, args[13]);
    const expected_rela_size = try parseNumber(u64, args[14]);
    const expected_dynamic_foa = try parseNumber(u64, args[15]);
    const expected_dynamic_vaddr = try parseNumber(u64, args[16]);
    const expected_dynamic_size = try parseNumber(u64, args[17]);
    const expected_slot_foa = try parseNumber(u64, args[18]);
    const expected_slot_vaddr = try parseNumber(u64, args[19]);
    const expected_symbol = args[20];
    const expected_library = args[21];

    var failed = false;
    failed = (try checkCommon(
        stderr,
        bytes,
        expected_file_size,
        expected_entry,
        expected_interp_foa,
        expected_dynsym_foa,
        expected_dynstr_foa,
        expected_dynstr_size,
        expected_hash_foa,
        expected_dynamic_foa,
        expected_dynamic_vaddr,
        expected_dynamic_size,
        expected_symbol,
        expected_library,
    )) or failed;

    if (args.len == 22) {
        failed = (try checkSlotImport(
            stderr,
            bytes,
            expected_dynsym_vaddr,
            expected_dynstr_vaddr,
            expected_hash_vaddr,
            expected_rela_foa,
            expected_rela_vaddr,
            expected_rela_size,
            expected_dynamic_foa,
            expected_slot_foa,
            expected_slot_vaddr,
        )) or failed;
    } else {
        const expected_plt_foa = try parseNumber(u64, args[22]);
        const expected_plt_vaddr = try parseNumber(u64, args[23]);
        const expected_gotplt_foa = try parseNumber(u64, args[24]);
        const expected_gotplt_vaddr = try parseNumber(u64, args[25]);
        const expected_jmprel_foa = try parseNumber(u64, args[26]);
        const expected_jmprel_vaddr = try parseNumber(u64, args[27]);
        const expected_jmprel_size = try parseNumber(u64, args[28]);
        const expected_plt_slot_foa = try parseNumber(u64, args[29]);
        const expected_plt_slot_vaddr = try parseNumber(u64, args[30]);

        failed = (try checkPltImport(
            stderr,
            bytes,
            expected_dynsym_vaddr,
            expected_dynstr_vaddr,
            expected_hash_vaddr,
            expected_rela_foa,
            expected_rela_vaddr,
            expected_rela_size,
            expected_dynamic_foa,
            expected_dynamic_vaddr,
            expected_plt_foa,
            expected_plt_vaddr,
            expected_gotplt_foa,
            expected_gotplt_vaddr,
            expected_jmprel_foa,
            expected_jmprel_vaddr,
            expected_jmprel_size,
            expected_plt_slot_foa,
            expected_plt_slot_vaddr,
        )) or failed;
    }

    if (failed) {
        try stderr.flush();
        std.process.exit(1);
    }
}

fn checkCommon(
    stderr: *Io.Writer,
    bytes: []const u8,
    expected_file_size: u64,
    expected_entry: u64,
    expected_interp_foa: u64,
    expected_dynsym_foa: u64,
    expected_dynstr_foa: u64,
    expected_dynstr_size: u64,
    expected_hash_foa: u64,
    expected_dynamic_foa: u64,
    expected_dynamic_vaddr: u64,
    expected_dynamic_size: u64,
    expected_symbol: []const u8,
    expected_library: []const u8,
) !bool {
    var failed = false;
    failed = (try expectEqual(stderr, "FileSize", expected_file_size, bytes.len)) or failed;
    failed = (try expectEqual(stderr, "Magic", @as(u32, 0x464c457f), try readU32Le(bytes, 0))) or failed;
    failed = (try expectEqual(stderr, "Class", @as(u8, 2), try readU8(bytes, 4))) or failed;
    failed = (try expectEqual(stderr, "Type", @as(u16, 2), try readU16Le(bytes, 16))) or failed;
    failed = (try expectEqual(stderr, "Machine", @as(u16, 62), try readU16Le(bytes, 18))) or failed;
    failed = (try expectEqual(stderr, "Entry", expected_entry, try readU64Le(bytes, 24))) or failed;
    failed = (try expectEqual(stderr, "ProgramHeaderOffset", @as(u64, 64), try readU64Le(bytes, 32))) or failed;
    failed = (try expectEqual(stderr, "ProgramHeaderEntrySize", @as(u16, 56), try readU16Le(bytes, 54))) or failed;
    const program_header_count = try readU16Le(bytes, 56);
    try checkProgramHeaderBounds(bytes, program_header_count);
    const text_header_offset: usize = if (program_header_count == 6) 176 else 64;
    failed = (try expectEqual(stderr, "TextLoadType", @as(u32, 1), try readU32Le(bytes, text_header_offset))) or failed;

    if (program_header_count == 4) {
        failed = (try expectEqual(stderr, "DataLoadType", @as(u32, 1), try readU32Le(bytes, 120))) or failed;
        failed = (try expectEqual(stderr, "InterpType", @as(u32, 3), try readU32Le(bytes, 176))) or failed;
        failed = (try expectEqual(stderr, "InterpOffset", expected_interp_foa, try readU64Le(bytes, 184))) or failed;
        failed = (try expectEqual(stderr, "DynamicType", @as(u32, 2), try readU32Le(bytes, 232))) or failed;
        failed = (try expectEqual(stderr, "DynamicOffset", expected_dynamic_foa, try readU64Le(bytes, 240))) or failed;
        failed = (try expectEqual(stderr, "DynamicVaddr", expected_dynamic_vaddr, try readU64Le(bytes, 248))) or failed;
        failed = (try expectEqual(stderr, "DynamicFilesz", expected_dynamic_size, try readU64Le(bytes, 264))) or failed;
    } else if (program_header_count == 5) {
        failed = (try expectEqual(stderr, "TextLoadFlags", @as(u32, 5), try readU32Le(bytes, 68))) or failed;
        failed = (try expectEqual(stderr, "PltLoadType", @as(u32, 1), try readU32Le(bytes, 120))) or failed;
        failed = (try expectEqual(stderr, "PltLoadFlags", @as(u32, 5), try readU32Le(bytes, 124))) or failed;
        failed = (try expectEqual(stderr, "MetadataLoadType", @as(u32, 1), try readU32Le(bytes, 176))) or failed;
        failed = (try expectEqual(stderr, "MetadataLoadFlags", @as(u32, 6), try readU32Le(bytes, 180))) or failed;
        failed = (try expectEqual(stderr, "InterpType", @as(u32, 3), try readU32Le(bytes, 232))) or failed;
        failed = (try expectEqual(stderr, "InterpOffset", expected_interp_foa, try readU64Le(bytes, 240))) or failed;
        failed = (try expectEqual(stderr, "DynamicType", @as(u32, 2), try readU32Le(bytes, 288))) or failed;
        failed = (try expectEqual(stderr, "DynamicOffset", expected_dynamic_foa, try readU64Le(bytes, 296))) or failed;
        failed = (try expectEqual(stderr, "DynamicVaddr", expected_dynamic_vaddr, try readU64Le(bytes, 304))) or failed;
        failed = (try expectEqual(stderr, "DynamicFilesz", expected_dynamic_size, try readU64Le(bytes, 320))) or failed;
    } else if (program_header_count == 6) {
        failed = (try expectEqual(stderr, "PhdrType", @as(u32, 6), try readU32Le(bytes, 64))) or failed;
        failed = (try expectEqual(stderr, "PhdrFlags", @as(u32, 4), try readU32Le(bytes, 68))) or failed;
        failed = (try expectEqual(stderr, "PhdrOffset", @as(u64, 64), try readU64Le(bytes, 72))) or failed;
        const header_table_size = try checkedMul(u64, program_header_count, 56);
        failed = (try expectEqual(stderr, "PhdrFilesz", header_table_size, try readU64Le(bytes, 96))) or failed;
        failed = (try expectEqual(stderr, "InterpType", @as(u32, 3), try readU32Le(bytes, 120))) or failed;
        failed = (try expectEqual(stderr, "InterpOffset", expected_interp_foa, try readU64Le(bytes, 128))) or failed;
        failed = (try expectEqual(stderr, "TextLoadFlags", @as(u32, 5), try readU32Le(bytes, 180))) or failed;
        failed = (try expectEqual(stderr, "TextLoadOffset", @as(u64, 0), try readU64Le(bytes, 184))) or failed;
        if (try readU64Le(bytes, 208) < try checkedAdd(u64, 64, header_table_size)) {
            try stderr.print("TextLoadHeaderMapping mismatch: ELF and program headers must be mapped\n", .{});
            failed = true;
        }
        failed = (try expectEqual(stderr, "PltLoadType", @as(u32, 1), try readU32Le(bytes, 232))) or failed;
        failed = (try expectEqual(stderr, "PltLoadFlags", @as(u32, 5), try readU32Le(bytes, 236))) or failed;
        failed = (try expectEqual(stderr, "MetadataLoadType", @as(u32, 1), try readU32Le(bytes, 288))) or failed;
        failed = (try expectEqual(stderr, "MetadataLoadFlags", @as(u32, 6), try readU32Le(bytes, 292))) or failed;
        failed = (try expectEqual(stderr, "DynamicType", @as(u32, 2), try readU32Le(bytes, 344))) or failed;
        failed = (try expectEqual(stderr, "DynamicOffset", expected_dynamic_foa, try readU64Le(bytes, 352))) or failed;
        failed = (try expectEqual(stderr, "DynamicVaddr", expected_dynamic_vaddr, try readU64Le(bytes, 360))) or failed;
        failed = (try expectEqual(stderr, "DynamicFilesz", expected_dynamic_size, try readU64Le(bytes, 376))) or failed;
    } else {
        try stderr.print("ProgramHeaderCount mismatch: expected 4, 5, or 6, actual {d}\n", .{program_header_count});
        failed = true;
    }

    const expected_symbol_len = std.math.cast(u64, expected_symbol.len) orelse return CheckError.InvalidElfExeImport;
    const symbol_name_end = try checkedAdd(u64, try checkedAdd(u64, expected_symbol_len, 1), 1);
    if (symbol_name_end > expected_dynstr_size) return CheckError.InvalidElfExeImport;
    if (try checkedAdd(u64, expected_dynstr_foa, expected_dynstr_size) > bytes.len) return CheckError.InvalidElfExeImport;
    const needed_name_offset = try dynamicValue(bytes, expected_dynamic_foa, expected_dynamic_size, 1);
    const needed_name_size = try checkedAdd(u64, std.math.cast(u64, expected_library.len) orelse return CheckError.InvalidElfExeImport, 1);
    if (needed_name_offset > expected_dynstr_size or needed_name_size > expected_dynstr_size - needed_name_offset) return CheckError.InvalidElfExeImport;
    const needed_name_foa = try checkedAdd(u64, expected_dynstr_foa, needed_name_offset);
    failed = (try expectEqual(stderr, "DynstrSize", expected_dynstr_size, try dynamicValue(bytes, expected_dynamic_foa, expected_dynamic_size, 10))) or failed;
    failed = (try expectBytes(stderr, "Interpreter", "/lib64/ld-linux-x86-64.so.2", bytes, try toUsize(expected_interp_foa))) or failed;
    failed = (try expectEqual(stderr, "ImportSymbolNameOffset", @as(u32, 1), try readU32Le(bytes, try checkedAdd(usize, try toUsize(expected_dynsym_foa), 24)))) or failed;
    failed = (try expectEqual(stderr, "ImportSymbolInfo", @as(u8, 0x12), try readU8(bytes, try checkedAdd(usize, try toUsize(expected_dynsym_foa), 28)))) or failed;
    failed = (try expectEqual(stderr, "ImportSymbolSection", @as(u16, 0), try readU16Le(bytes, try checkedAdd(usize, try toUsize(expected_dynsym_foa), 30)))) or failed;
    failed = (try expectBytes(stderr, "ImportSymbolName", expected_symbol, bytes, try checkedAdd(usize, try toUsize(expected_dynstr_foa), 1))) or failed;
    failed = (try expectEqual(stderr, "ImportSymbolNameTerminator", @as(u8, 0), try readU8(bytes, try toUsize(try checkedAdd(u64, expected_dynstr_foa, symbol_name_end - 1))))) or failed;
    failed = (try expectBytes(stderr, "NeededLibrary", expected_library, bytes, try toUsize(needed_name_foa))) or failed;
    failed = (try expectEqual(stderr, "NeededLibraryTerminator", @as(u8, 0), try readU8(bytes, try toUsize(try checkedAdd(u64, needed_name_foa, needed_name_size - 1))))) or failed;

    failed = (try expectEqual(stderr, "HashBucketCount", @as(u32, 1), try readU32Le(bytes, try toUsize(expected_hash_foa)))) or failed;
    failed = (try expectEqual(stderr, "HashChainCount", @as(u32, 2), try readU32Le(bytes, try checkedAdd(usize, try toUsize(expected_hash_foa), 4)))) or failed;
    failed = (try expectEqual(stderr, "HashBucket0", @as(u32, 1), try readU32Le(bytes, try checkedAdd(usize, try toUsize(expected_hash_foa), 8)))) or failed;
    failed = (try expectEqual(stderr, "HashChain0", @as(u32, 0), try readU32Le(bytes, try checkedAdd(usize, try toUsize(expected_hash_foa), 12)))) or failed;
    failed = (try expectEqual(stderr, "HashChain1", @as(u32, 0), try readU32Le(bytes, try checkedAdd(usize, try toUsize(expected_hash_foa), 16)))) or failed;
    if (expected_dynstr_size == 0) {
        try stderr.print("DynstrSizePositive mismatch: expected non-zero size\n", .{});
        failed = true;
    }
    return failed;
}

fn checkSlotImport(
    stderr: *Io.Writer,
    bytes: []const u8,
    expected_dynsym_vaddr: u64,
    expected_dynstr_vaddr: u64,
    expected_hash_vaddr: u64,
    expected_rela_foa: u64,
    expected_rela_vaddr: u64,
    expected_rela_size: u64,
    expected_dynamic_foa: u64,
    expected_slot_foa: u64,
    expected_slot_vaddr: u64,
) !bool {
    var failed = false;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 0, 4, expected_hash_vaddr)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 1, 5, expected_dynstr_vaddr)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 3, 6, expected_dynsym_vaddr)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 5, 7, expected_rela_vaddr)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 6, 8, expected_rela_size)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 7, 9, 24)) or failed;
    failed = (try expectEqual(stderr, "SlotInitialValue", @as(u64, 0), try readU64Le(bytes, try toUsize(expected_slot_foa)))) or failed;
    failed = (try expectEqual(stderr, "RelaOffset", expected_slot_vaddr, try readU64Le(bytes, try toUsize(expected_rela_foa)))) or failed;
    failed = (try expectEqual(stderr, "RelaInfo", @as(u64, 0x100000001), try readU64Le(bytes, try checkedAdd(usize, try toUsize(expected_rela_foa), 8)))) or failed;
    failed = (try expectEqual(stderr, "RelaAddend", @as(u64, 0), try readU64Le(bytes, try checkedAdd(usize, try toUsize(expected_rela_foa), 16)))) or failed;
    return failed;
}

fn checkPltImport(
    stderr: *Io.Writer,
    bytes: []const u8,
    expected_dynsym_vaddr: u64,
    expected_dynstr_vaddr: u64,
    expected_hash_vaddr: u64,
    expected_rela_foa: u64,
    expected_rela_vaddr: u64,
    expected_rela_size: u64,
    expected_dynamic_foa: u64,
    expected_dynamic_vaddr: u64,
    expected_plt_foa: u64,
    expected_plt_vaddr: u64,
    expected_gotplt_foa: u64,
    expected_gotplt_vaddr: u64,
    expected_jmprel_foa: u64,
    expected_jmprel_vaddr: u64,
    expected_jmprel_size: u64,
    expected_plt_slot_foa: u64,
    expected_plt_slot_vaddr: u64,
) !bool {
    var failed = false;
    failed = (try expectEqual(stderr, "RelaPltSizeAlias", expected_rela_size, expected_jmprel_size)) or failed;
    failed = (try expectEqual(stderr, "RelaPltFoaAlias", expected_rela_foa, expected_jmprel_foa)) or failed;
    failed = (try expectEqual(stderr, "RelaPltVaddrAlias", expected_rela_vaddr, expected_jmprel_vaddr)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 0, 4, expected_hash_vaddr)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 1, 5, expected_dynstr_vaddr)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 3, 6, expected_dynsym_vaddr)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 5, 3, expected_gotplt_vaddr)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 6, 2, expected_jmprel_size)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 7, 20, 7)) or failed;
    failed = (try expectDynamic(stderr, bytes, expected_dynamic_foa, 8, 23, expected_jmprel_vaddr)) or failed;

    failed = (try expectEqual(stderr, "GotPltDynamic", expected_dynamic_vaddr, try readU64Le(bytes, try toUsize(expected_gotplt_foa)))) or failed;
    failed = (try expectEqual(stderr, "GotPltResolver0", @as(u64, 0), try readU64Le(bytes, try checkedAdd(usize, try toUsize(expected_gotplt_foa), 8)))) or failed;
    failed = (try expectEqual(stderr, "GotPltResolver1", @as(u64, 0), try readU64Le(bytes, try checkedAdd(usize, try toUsize(expected_gotplt_foa), 16)))) or failed;
    failed = (try expectEqual(stderr, "GotPltSlotInitialValue", expected_plt_vaddr + 22, try readU64Le(bytes, try toUsize(expected_plt_slot_foa)))) or failed;
    failed = (try expectEqual(stderr, "GotPltSlotVaddr", expected_plt_slot_vaddr, expected_gotplt_vaddr + 24)) or failed;

    failed = (try expectEqual(stderr, "Plt0JmpPushOpcode", @as(u16, 0x35ff), try readU16Le(bytes, try toUsize(expected_plt_foa)))) or failed;
    failed = (try expectEqual(stderr, "Plt0JmpOpcode", @as(u16, 0x25ff), try readU16Le(bytes, try checkedAdd(usize, try toUsize(expected_plt_foa), 6)))) or failed;
    failed = (try expectEqual(stderr, "PltEntryJmpOpcode", @as(u16, 0x25ff), try readU16Le(bytes, try checkedAdd(usize, try toUsize(expected_plt_foa), 16)))) or failed;
    failed = (try expectEqual(stderr, "PltEntryPushOpcode", @as(u8, 0x68), try readU8(bytes, try checkedAdd(usize, try toUsize(expected_plt_foa), 22)))) or failed;
    failed = (try expectEqual(stderr, "PltEntryIndex", @as(u32, 0), try readU32Le(bytes, try checkedAdd(usize, try toUsize(expected_plt_foa), 23)))) or failed;
    failed = (try expectEqual(stderr, "PltEntryJmpBackOpcode", @as(u8, 0xe9), try readU8(bytes, try checkedAdd(usize, try toUsize(expected_plt_foa), 27)))) or failed;

    failed = (try expectEqual(stderr, "RelaOffset", expected_plt_slot_vaddr, try readU64Le(bytes, try toUsize(expected_jmprel_foa)))) or failed;
    failed = (try expectEqual(stderr, "RelaInfo", @as(u64, 0x100000007), try readU64Le(bytes, try checkedAdd(usize, try toUsize(expected_jmprel_foa), 8)))) or failed;
    failed = (try expectEqual(stderr, "RelaAddend", @as(u64, 0), try readU64Le(bytes, try checkedAdd(usize, try toUsize(expected_jmprel_foa), 16)))) or failed;
    return failed;
}

fn readFile(allocator: Allocator, io: Io, path: []const u8) ![]u8 {
    return try Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(std.math.maxInt(usize)));
}

fn parseNumber(comptime T: type, text: []const u8) !T {
    if (std.mem.startsWith(u8, text, "0x") or std.mem.startsWith(u8, text, "0X")) {
        return std.fmt.parseInt(T, text[2..], 16) catch return CheckError.InvalidNumber;
    }
    return std.fmt.parseInt(T, text, 10) catch return CheckError.InvalidNumber;
}

fn expectDynamic(stderr: *Io.Writer, bytes: []const u8, dynamic_offset: u64, index: usize, expected_tag: u64, expected_value: u64) !bool {
    const entry_offset = try checkedAdd(usize, try toUsize(dynamic_offset), try checkedMul(usize, index, 16));
    var failed = false;
    failed = (try expectEqual(stderr, "DynamicTag", expected_tag, try readU64Le(bytes, entry_offset))) or failed;
    failed = (try expectEqual(stderr, "DynamicValue", expected_value, try readU64Le(bytes, try checkedAdd(usize, entry_offset, 8)))) or failed;
    return failed;
}

fn checkProgramHeaderBounds(bytes: []const u8, count: u16) !void {
    const table_end = try checkedAdd(usize, 64, try checkedMul(usize, count, 56));
    if (table_end > bytes.len) return CheckError.InvalidElfExeImport;
    for (0..count) |index| {
        const header_offset = try checkedAdd(usize, 64, try checkedMul(usize, index, 56));
        const file_offset = try readU64Le(bytes, try checkedAdd(usize, header_offset, 8));
        const file_size = try readU64Le(bytes, try checkedAdd(usize, header_offset, 32));
        const memory_size = try readU64Le(bytes, try checkedAdd(usize, header_offset, 40));
        if (file_size > memory_size or try checkedAdd(u64, file_offset, file_size) > bytes.len) return CheckError.InvalidElfExeImport;
    }
}

fn dynamicValue(bytes: []const u8, offset: u64, size: u64, requested_tag: u64) !u64 {
    if (size % 16 != 0) return CheckError.InvalidElfExeImport;
    const end = try checkedAdd(u64, offset, size);
    if (end > bytes.len) return CheckError.InvalidElfExeImport;
    var entry_offset = offset;
    while (entry_offset < end) : (entry_offset = try checkedAdd(u64, entry_offset, 16)) {
        const tag = try readU64Le(bytes, try toUsize(entry_offset));
        if (tag == 0) break;
        if (tag == requested_tag) return readU64Le(bytes, try toUsize(try checkedAdd(u64, entry_offset, 8)));
    }
    return CheckError.InvalidElfExeImport;
}

fn expectEqual(stderr: *Io.Writer, name: []const u8, expected: anytype, actual: @TypeOf(expected)) !bool {
    if (actual == expected) return false;
    try stderr.print("{s} mismatch: expected {d}, actual {d}\n", .{ name, expected, actual });
    return true;
}

fn expectBytes(stderr: *Io.Writer, name: []const u8, expected: []const u8, bytes: []const u8, offset: usize) !bool {
    const end = try checkedAdd(usize, offset, expected.len);
    if (end > bytes.len) return CheckError.InvalidElfExeImport;
    if (std.mem.eql(u8, expected, bytes[offset..end])) return false;
    try stderr.print("{s} mismatch\n", .{name});
    return true;
}

fn readU8(bytes: []const u8, offset: usize) !u8 {
    const end = try checkedAdd(usize, offset, 1);
    if (end > bytes.len) return CheckError.InvalidElfExeImport;
    return bytes[offset];
}

fn readU16Le(bytes: []const u8, offset: usize) !u16 {
    const end = try checkedAdd(usize, offset, 2);
    if (end > bytes.len) return CheckError.InvalidElfExeImport;
    return @as(u16, bytes[offset]) |
        (@as(u16, bytes[offset + 1]) << 8);
}

fn readU32Le(bytes: []const u8, offset: usize) !u32 {
    const end = try checkedAdd(usize, offset, 4);
    if (end > bytes.len) return CheckError.InvalidElfExeImport;
    return @as(u32, bytes[offset]) |
        (@as(u32, bytes[offset + 1]) << 8) |
        (@as(u32, bytes[offset + 2]) << 16) |
        (@as(u32, bytes[offset + 3]) << 24);
}

fn readU64Le(bytes: []const u8, offset: usize) !u64 {
    const low = try readU32Le(bytes, offset);
    const high = try readU32Le(bytes, try checkedAdd(usize, offset, 4));
    return @as(u64, low) | (@as(u64, high) << 32);
}

fn checkedAdd(comptime T: type, lhs: T, rhs: T) !T {
    return std.math.add(T, lhs, rhs) catch return CheckError.InvalidElfExeImport;
}

fn checkedMul(comptime T: type, lhs: T, rhs: T) !T {
    return std.math.mul(T, lhs, rhs) catch return CheckError.InvalidElfExeImport;
}

fn toUsize(value: anytype) !usize {
    return std.math.cast(usize, value) orelse CheckError.InvalidElfExeImport;
}

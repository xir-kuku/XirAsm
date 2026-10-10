const std = @import("std");

const identifier = @import("../identifier.zig");
const frontend_isa_text = @import("../isa_text.zig");
const target = @import("../target.zig");

const Allocator = std.mem.Allocator;

pub const Error = Allocator.Error || error{InvalidExpression};

pub const TextRange = struct {
    start: usize,
    end: usize,
};

pub fn substituteIntegerSymbols(
    allocator: Allocator,
    active_target: target.Target,
    text: []const u8,
    resolver: anytype,
) Error![]u8 {
    var result: std.ArrayList(u8) = .empty;
    errdefer result.deinit(allocator);

    var cursor: usize = 0;
    while (cursor < text.len) {
        const byte = text[cursor];
        if (byte == '"' or byte == '\'') {
            const end = skipQuotedText(text, cursor) orelse return error.InvalidExpression;
            try result.appendSlice(allocator, text[cursor .. end + 1]);
            cursor = end + 1;
            continue;
        }
        if (!identifier.isStart(byte)) {
            try result.append(allocator, byte);
            cursor += 1;
            continue;
        }

        const start = cursor;
        cursor += 1;
        while (cursor < text.len and identifier.isContinue(text[cursor])) : (cursor += 1) {}
        const name = text[start..cursor];
        if (shouldKeepIsaIdentifier(active_target, text, start, name)) {
            try result.appendSlice(allocator, name);
        } else if (resolver.resolve(name)) |value| {
            // A u64 decimal literal is at most 20 bytes.
            var value_buffer: [20]u8 = undefined;
            const value_text = std.fmt.bufPrint(&value_buffer, "{}", .{value}) catch return error.InvalidExpression;
            try result.appendSlice(allocator, value_text);
        } else {
            try result.appendSlice(allocator, name);
        }
    }

    return result.toOwnedSlice(allocator);
}

pub fn findBuiltinCall(text: []const u8, start_index: usize) ?TextRange {
    var index = start_index;
    while (index < text.len) {
        if (text[index] == '"' or text[index] == '\'') {
            const end = skipQuotedText(text, index) orelse return null;
            index = end + 1;
            continue;
        }
        if (!identifier.isStart(text[index])) {
            index += 1;
            continue;
        }

        const name_start = index;
        index += 1;
        while (index < text.len and identifier.isContinue(text[index])) : (index += 1) {}
        const name_end = index;
        if (!isExpressionBuiltinName(text[name_start..name_end])) continue;

        var cursor = index;
        while (cursor < text.len and std.ascii.isWhitespace(text[cursor])) : (cursor += 1) {}
        if (cursor >= text.len or text[cursor] != '(') continue;

        if (findMatchingCloseParen(text, cursor)) |close| {
            return .{
                .start = name_start,
                .end = close + 1,
            };
        }
        return null;
    }
    return null;
}

fn shouldKeepIsaIdentifier(active_target: target.Target, text: []const u8, start: usize, name: []const u8) bool {
    // SPIR-V IDs have their own module namespace, independent of Meta bindings.
    if (active_target.isa() == .spirv and start > 0 and text[start - 1] == '%') return true;
    if (isFirstIsaIdentifier(text, start)) return true;
    if (isX86MnemonicAfterPrefix(text, start)) return true;
    return switch (active_target) {
        .x86 => isKnownX86IsaWord(name),
        .riscv => frontend_isa_text.isKnownRiscvWord(name),
        // An A64 line is matched by the macro library, which receives the operand
        // text as written, so nothing beyond the mnemonic and the command prefix
        // is treated as an ISA keyword here.
        .arm, .spirv => false,
    };
}

fn isFirstIsaIdentifier(text: []const u8, start: usize) bool {
    var index: usize = 0;
    while (index < start and std.ascii.isWhitespace(text[index])) : (index += 1) {}
    return index == start;
}

fn isX86MnemonicAfterPrefix(text: []const u8, start: usize) bool {
    var index = start;
    while (index > 0 and std.ascii.isWhitespace(text[index - 1])) : (index -= 1) {}
    const previous_end = index;
    while (index > 0 and identifier.isContinue(text[index - 1])) : (index -= 1) {}
    if (index == previous_end) return false;
    return isX86PrefixWord(text[index..previous_end]);
}

fn isX86PrefixWord(name: []const u8) bool {
    return std.ascii.eqlIgnoreCase(name, "lock") or
        std.ascii.eqlIgnoreCase(name, "rep") or
        std.ascii.eqlIgnoreCase(name, "repe") or
        std.ascii.eqlIgnoreCase(name, "repz") or
        std.ascii.eqlIgnoreCase(name, "repne") or
        std.ascii.eqlIgnoreCase(name, "repnz") or
        std.ascii.eqlIgnoreCase(name, "xacquire") or
        std.ascii.eqlIgnoreCase(name, "xrelease");
}

fn isKnownX86IsaWord(name: []const u8) bool {
    return isX86RegisterWord(name) or
        std.ascii.eqlIgnoreCase(name, "byte") or
        std.ascii.eqlIgnoreCase(name, "word") or
        std.ascii.eqlIgnoreCase(name, "dword") or
        std.ascii.eqlIgnoreCase(name, "qword") or
        std.ascii.eqlIgnoreCase(name, "tword") or
        std.ascii.eqlIgnoreCase(name, "oword") or
        std.ascii.eqlIgnoreCase(name, "yword") or
        std.ascii.eqlIgnoreCase(name, "zword") or
        std.ascii.eqlIgnoreCase(name, "ptr") or
        std.ascii.eqlIgnoreCase(name, "rel") or
        std.ascii.eqlIgnoreCase(name, "abs") or
        std.ascii.eqlIgnoreCase(name, "short") or
        std.ascii.eqlIgnoreCase(name, "near") or
        std.ascii.eqlIgnoreCase(name, "far") or
        std.ascii.eqlIgnoreCase(name, "strict") or
        std.ascii.eqlIgnoreCase(name, "offset") or
        isX86PrefixWord(name);
}

fn isX86RegisterWord(name: []const u8) bool {
    return std.ascii.eqlIgnoreCase(name, "al") or
        std.ascii.eqlIgnoreCase(name, "cl") or
        std.ascii.eqlIgnoreCase(name, "dl") or
        std.ascii.eqlIgnoreCase(name, "bl") or
        std.ascii.eqlIgnoreCase(name, "ah") or
        std.ascii.eqlIgnoreCase(name, "ch") or
        std.ascii.eqlIgnoreCase(name, "dh") or
        std.ascii.eqlIgnoreCase(name, "bh") or
        std.ascii.eqlIgnoreCase(name, "spl") or
        std.ascii.eqlIgnoreCase(name, "bpl") or
        std.ascii.eqlIgnoreCase(name, "sil") or
        std.ascii.eqlIgnoreCase(name, "dil") or
        std.ascii.eqlIgnoreCase(name, "ax") or
        std.ascii.eqlIgnoreCase(name, "cx") or
        std.ascii.eqlIgnoreCase(name, "dx") or
        std.ascii.eqlIgnoreCase(name, "bx") or
        std.ascii.eqlIgnoreCase(name, "sp") or
        std.ascii.eqlIgnoreCase(name, "bp") or
        std.ascii.eqlIgnoreCase(name, "si") or
        std.ascii.eqlIgnoreCase(name, "di") or
        std.ascii.eqlIgnoreCase(name, "eax") or
        std.ascii.eqlIgnoreCase(name, "ecx") or
        std.ascii.eqlIgnoreCase(name, "edx") or
        std.ascii.eqlIgnoreCase(name, "ebx") or
        std.ascii.eqlIgnoreCase(name, "esp") or
        std.ascii.eqlIgnoreCase(name, "ebp") or
        std.ascii.eqlIgnoreCase(name, "esi") or
        std.ascii.eqlIgnoreCase(name, "edi") or
        std.ascii.eqlIgnoreCase(name, "rax") or
        std.ascii.eqlIgnoreCase(name, "rcx") or
        std.ascii.eqlIgnoreCase(name, "rdx") or
        std.ascii.eqlIgnoreCase(name, "rbx") or
        std.ascii.eqlIgnoreCase(name, "rsp") or
        std.ascii.eqlIgnoreCase(name, "rbp") or
        std.ascii.eqlIgnoreCase(name, "rsi") or
        std.ascii.eqlIgnoreCase(name, "rdi") or
        std.ascii.eqlIgnoreCase(name, "rip") or
        std.ascii.eqlIgnoreCase(name, "eip") or
        std.ascii.eqlIgnoreCase(name, "ip") or
        std.ascii.eqlIgnoreCase(name, "es") or
        std.ascii.eqlIgnoreCase(name, "cs") or
        std.ascii.eqlIgnoreCase(name, "ss") or
        std.ascii.eqlIgnoreCase(name, "ds") or
        std.ascii.eqlIgnoreCase(name, "fs") or
        std.ascii.eqlIgnoreCase(name, "gs") or
        isX86ExtendedGeneralRegister(name) or
        isX86NumberedRegister(name, "mm", 7) or
        isX86NumberedRegister(name, "xmm", 31) or
        isX86NumberedRegister(name, "ymm", 31) or
        isX86NumberedRegister(name, "zmm", 31) or
        isX86NumberedRegister(name, "k", 7) or
        isX86NumberedRegister(name, "st", 7) or
        isX86NumberedRegister(name, "cr", 15) or
        isX86NumberedRegister(name, "dr", 15) or
        isX86NumberedRegister(name, "bnd", 3);
}

fn isX86ExtendedGeneralRegister(name: []const u8) bool {
    if (name.len < 2 or !std.ascii.eqlIgnoreCase(name[0..1], "r")) return false;
    var end: usize = 1;
    while (end < name.len and std.ascii.isDigit(name[end])) : (end += 1) {}
    if (end == 1) return false;
    const number = std.fmt.parseInt(u8, name[1..end], 10) catch return false;
    if (number < 8 or number > 15) return false;
    const suffix = name[end..];
    return suffix.len == 0 or
        std.ascii.eqlIgnoreCase(suffix, "b") or
        std.ascii.eqlIgnoreCase(suffix, "w") or
        std.ascii.eqlIgnoreCase(suffix, "d");
}

fn isX86NumberedRegister(name: []const u8, prefix: []const u8, max_index: u8) bool {
    if (name.len <= prefix.len) return false;
    if (!std.ascii.eqlIgnoreCase(name[0..prefix.len], prefix)) return false;
    const number = std.fmt.parseInt(u8, name[prefix.len..], 10) catch return false;
    return number <= max_index;
}

fn findMatchingCloseParen(text: []const u8, open_index: usize) ?usize {
    var depth: usize = 0;
    var index = open_index;
    while (index < text.len) : (index += 1) {
        switch (text[index]) {
            '(' => depth += 1,
            ')' => {
                depth -= 1;
                if (depth == 0) return index;
            },
            '"', '\'' => {
                index = skipQuotedText(text, index) orelse return null;
            },
            else => {},
        }
    }
    return null;
}

fn skipQuotedText(text: []const u8, quote_index: usize) ?usize {
    const quote = text[quote_index];
    var index = quote_index + 1;
    while (index < text.len) : (index += 1) {
        // A backslash escapes the next character. Instruction text read by the
        // token layer already assumes this, so the terminator scan has to agree
        // or a quoted `\"` would end the string here and somewhere else not.
        if (text[index] == '\\' and index + 1 < text.len) {
            index += 1;
            continue;
        }
        if (text[index] != quote) continue;
        if (index + 1 < text.len and text[index + 1] == quote) {
            index += 1;
            continue;
        }
        return index;
    }
    return null;
}

fn isExpressionBuiltinName(name: []const u8) bool {
    // `operand.eval` is deliberately absent. A macro substitutes the captured
    // operand as text, so by the time instruction text is scanned the call is
    // `operand.eval(<literal>)` with no operand binding left to evaluate, and
    // evaluating it here failed as a bare invalid expression. Left out, the
    // unresolved reference is reported with the guidance that actually helps:
    // bind the value to a const first.
    return std.mem.eql(u8, name, "sizeof") or
        std.mem.eql(u8, name, "lengthof") or
        std.mem.eql(u8, name, "offset_of") or
        std.mem.eql(u8, name, "here") or
        std.mem.eql(u8, name, "region_base") or
        std.mem.eql(u8, name, "file_offset") or
        std.mem.eql(u8, name, "file_cursor_real") or
        std.mem.eql(u8, name, "file_cursor_potential") or
        std.mem.eql(u8, name, "tail_reserve_size") or
        std.mem.eql(u8, name, "label_addr") or
        std.mem.eql(u8, name, "sym.unique");
}

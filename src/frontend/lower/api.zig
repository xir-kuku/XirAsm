const std = @import("std");

const ast = @import("../ast.zig");
const identifier = @import("../identifier.zig");
const module_mod = @import("../module.zig");
const target = @import("../target.zig");
const value_mod = @import("../value.zig");
const contracts = @import("contracts.zig");
const context_mod = @import("context.zig");
const layout_cursor = @import("layout_cursor.zig");

const Allocator = std.mem.Allocator;
const ActiveOutput = contracts.ActiveOutput;
const LowerContext = context_mod.LowerContext;
const LowerError = contracts.LowerError;

const alignForward = layout_cursor.alignForward;
const checkedAdd = layout_cursor.checkedAdd;
const isPowerOfTwoNonZero = layout_cursor.isPowerOfTwoNonZero;
const materializedOffset = layout_cursor.materializedOffset;

pub const SourceLoadMode = enum {
    include,
    import_once,
};

pub const Callbacks = struct {
    lower_include_or_import: *const fn (Allocator, *module_mod.Module, *ActiveOutput, *std.ArrayList(ActiveOutput), ast.ApiCallStatement, *LowerContext, SourceLoadMode) LowerError!void,
    lower_meta_function: *const fn (Allocator, *module_mod.Module, *ActiveOutput, *std.ArrayList(ActiveOutput), *LowerContext, usize, ast.ApiCallStatement) LowerError!void,
    lower_diagnostic: *const fn (Allocator, *module_mod.Module, *LowerContext, ActiveOutput, ast.ApiCallStatement, contracts.DiagnosticSeverity) LowerError!void,
    lower_assert: *const fn (Allocator, *module_mod.Module, *LowerContext, ActiveOutput, ast.ApiCallStatement) LowerError!void,
    lower_isa: *const fn (*module_mod.Module, *LowerContext, *ActiveOutput, ast.ApiCallStatement) LowerError!void,
    lower_data_emit: *const fn (*module_mod.Module, *LowerContext, *ActiveOutput, ast.ApiCallStatement, u8) LowerError!void,
    lower_float_emit: *const fn (*module_mod.Module, *LowerContext, *ActiveOutput, ast.ApiCallStatement, u8) LowerError!void,
    lower_data_reserve: *const fn (*module_mod.Module, *LowerContext, *ActiveOutput, ast.ApiCallStatement, u64) LowerError!void,
    lower_file_emit: *const fn (*module_mod.Module, *LowerContext, *ActiveOutput, ast.ApiCallStatement) LowerError!void,
    value_arg_at_context: *const fn (Allocator, *module_mod.Module, *LowerContext, ActiveOutput, ast.ApiCallStatement, usize) LowerError!value_mod.Value,
    integer_arg_at_context: *const fn (*module_mod.Module, *LowerContext, ActiveOutput, ast.ApiCallStatement, usize) LowerError!u64,
    source_path_arg_at_context: *const fn (Allocator, *module_mod.Module, *LowerContext, ActiveOutput, ast.ApiCallStatement, usize) LowerError![]u8,
    output_store_target_at_context: *const fn (*module_mod.Module, *LowerContext, ActiveOutput, ast.ApiCallStatement, usize) LowerError!contracts.OutputStoreTarget,
    emit_struct_value: *const fn (*module_mod.Module, value_mod.StructValue) LowerError![]u8,
    materialize_instruction_bytes_for_output_access: *const fn (*module_mod.Module) LowerError!void,
    sync_active_output_offset_for_layout_api: *const fn (*module_mod.Module, *ActiveOutput) LowerError!void,
    active_address: *const fn (*const module_mod.Module, ActiveOutput) LowerError!u64,
    require_open_output_region: *const fn (ActiveOutput) LowerError!void,
    require_arg_count: *const fn (ast.ApiCallStatement, usize) LowerError!void,
    active_fragment_position: *const fn (*const module_mod.Module, contracts.SectionId) LowerError!u32,
    advance_active_output: *const fn (*ActiveOutput, contracts.Fragment) LowerError!void,
    discard_last_active_output: *const fn (*std.ArrayList(ActiveOutput)) void,
};

fn integerArgAs(
    comptime T: type,
    callbacks: Callbacks,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    call: ast.ApiCallStatement,
    index: usize,
) LowerError!T {
    const value = try callbacks.integer_arg_at_context(module, context, active, call, index);
    if (value > std.math.maxInt(T)) return error.InvalidApiInteger;
    return @intCast(value);
}

// api-matrix-lower: "include"
// api-matrix-lower: "import"
// api-matrix-lower: "print"
// api-matrix-lower: "warn"
// api-matrix-lower: "err"
// api-matrix-lower: "assert"
// api-matrix-lower: "isa"
// api-matrix-lower: "origin"
// api-matrix-lower: "virtual.begin"
// api-matrix-lower: "virtual.end"
// api-matrix-lower: "region.begin"
// api-matrix-lower: "region.file_align"
// api-matrix-lower: "output.org"
// api-matrix-lower: "output.section"
// api-matrix-lower: "store.u8"
// api-matrix-lower: "store.u16"
// api-matrix-lower: "store.u32"
// api-matrix-lower: "store.u64"
// api-matrix-lower: "store.bytes"
// api-matrix-lower: "x86.use16"
// api-matrix-lower: "x86.use32"
// api-matrix-lower: "x86.use64"
// api-matrix-lower: "riscv.use32"
// api-matrix-lower: "riscv.use64"
// api-matrix-lower: "spv.use"
// api-matrix-lower: "emit.u8"
// api-matrix-lower: "emit.u16"
// api-matrix-lower: "emit.u32"
// api-matrix-lower: "emit.u64"
// api-matrix-lower: "emit.bytes"
// api-matrix-lower: "emit.file"
// api-matrix-lower: "emit.struct"
// api-matrix-lower: "reserve"
// api-matrix-lower: "pad"
// api-matrix-lower: "pad_to"
// api-matrix-lower: "align"
// api-matrix-lower: "label.define"
pub fn lowerApiCall(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    call: ast.ApiCallStatement,
    context: *LowerContext,
    callbacks: Callbacks,
) LowerError!void {
    if (std.mem.eql(u8, call.callee, "include")) {
        try callbacks.lower_include_or_import(allocator, module, active, output_stack, call, context, .include);
        return;
    }

    if (std.mem.eql(u8, call.callee, "import")) {
        try callbacks.lower_include_or_import(allocator, module, active, output_stack, call, context, .import_once);
        return;
    }

    if (context.functions.lookupIndex(call.callee)) |function_index| {
        try callbacks.lower_meta_function(allocator, module, active, output_stack, context, function_index, call);
        return;
    }

    if (std.mem.eql(u8, call.callee, "print")) {
        try callbacks.lower_diagnostic(allocator, module, context, active.*, call, .note);
        return;
    }

    if (std.mem.eql(u8, call.callee, "warn")) {
        try callbacks.lower_diagnostic(allocator, module, context, active.*, call, .warning);
        return;
    }

    if (std.mem.eql(u8, call.callee, "err")) {
        try callbacks.lower_diagnostic(allocator, module, context, active.*, call, .err);
        return error.FrontendDiagnostics;
    }

    if (std.mem.eql(u8, call.callee, "assert")) {
        try callbacks.lower_assert(allocator, module, context, active.*, call);
        return;
    }

    if (std.mem.eql(u8, call.callee, "isa")) {
        try callbacks.lower_isa(module, context, active, call);
        return;
    }

    if (std.mem.eql(u8, call.callee, "label.define")) {
        try callbacks.require_open_output_region(active.*);
        try callbacks.require_arg_count(call, 1);
        var value = try callbacks.value_arg_at_context(module.allocator, module, context, active.*, call, 0);
        defer value.deinit(module.allocator);
        const name = switch (value) {
            .string => |text| text,
            .operand, .void, .integer, .float32, .float64, .boolean, .bytes, .type, .@"struct", .list, .map => return error.InvalidApiArgument,
        };
        if (!identifier.isName(name)) return error.InvalidApiArgument;
        const fragment_position = try callbacks.active_fragment_position(module, active.section_id);
        const label_id = try module.defineAnchoredLabel(name, active.section_id, active.offset, fragment_position, call.span);
        if (label_id.index >= module.symbols.items.items.len) return error.InvalidSymbol;
        return;
    }

    if (std.mem.eql(u8, call.callee, "origin")) {
        try callbacks.require_arg_count(call, 1);
        try module.setOrigin(active.section_id, try callbacks.integer_arg_at_context(module, context, active.*, call, 0));
        return;
    }

    if (std.mem.eql(u8, call.callee, "region.begin")) {
        try callbacks.require_arg_count(call, 3);
        const name = try callbacks.source_path_arg_at_context(module.allocator, module, context, active.*, call, 0);
        defer module.allocator.free(name);
        const origin = try callbacks.integer_arg_at_context(module, context, active.*, call, 1);
        const file_offset = try callbacks.integer_arg_at_context(module, context, active.*, call, 2);
        active.* = .{
            .section_id = try module.createOutputSection(name, origin, file_offset),
            .offset = 0,
            .file_offset = 0,
            .file_aligned = false,
            .target = active.target,
            .opened_at = active.opened_at,
        };
        return;
    }

    if (std.mem.eql(u8, call.callee, "region.place")) {
        // Scratch content becomes a real region here, at coordinates chosen by
        // the caller. Doing it before fixups are resolved is what lets an
        // instruction inside the scratch carry a reference: the section keeps
        // its fragments, labels, and fixups, so those resolve against the new
        // address by the ordinary fixup pass.
        try callbacks.require_arg_count(call, 3);
        var value = try callbacks.value_arg_at_context(module.allocator, module, context, active.*, call, 0);
        defer value.deinit(module.allocator);
        const label_name = switch (value) {
            .string => |text| text,
            .operand, .void, .integer, .float32, .float64, .boolean, .bytes, .type, .@"struct", .list, .map => return error.InvalidApiArgument,
        };
        const origin = try callbacks.integer_arg_at_context(module, context, active.*, call, 1);
        const file_offset = try callbacks.integer_arg_at_context(module, context, active.*, call, 2);

        const symbol_id = module.symbols.lookup(label_name) orelse return error.UndefinedSymbol;
        const symbol = try module.symbols.get(symbol_id);
        const label = switch (symbol.binding) {
            .label => |binding| binding,
            .unknown, .absolute, .value => {
                try module.diagnostics.add(
                    allocator,
                    .err,
                    call.span,
                    "region.place expects the name of a label declared inside a virtual region",
                );
                return error.FrontendDiagnostics;
            },
        };
        const placed = try module.sections.get(label.section);
        if (placed.kind != .virtual_output) {
            try module.diagnostics.add(
                allocator,
                .err,
                call.span,
                "region.place expects a label declared inside a virtual region; this label is already part of real output",
            );
            return error.FrontendDiagnostics;
        }
        try module.promoteVirtualSection(label.section, origin, file_offset);
        // Name the region after the label when that name is free, so listings and
        // warnings show something the source can be searched for, and continue
        // emitting into it after the content it already carries.
        if (!module.sections.hasName(label_name)) {
            try module.sections.setName(module.allocator, label.section, label_name);
        }
        active.* = .{
            .section_id = label.section,
            .offset = try layout_cursor.sectionCursor(module, label.section),
            .file_offset = try layout_cursor.sectionFileCursor(module, label.section),
            .file_aligned = placed.file_aligned,
            .target = active.target,
        };
        return;
    }

    if (std.mem.eql(u8, call.callee, "region.file_align")) {
        try callbacks.require_arg_count(call, 1);
        try callbacks.sync_active_output_offset_for_layout_api(module, active);
        const alignment = try callbacks.integer_arg_at_context(module, context, active.*, call, 0);
        if (!isPowerOfTwoNonZero(alignment)) return error.InvalidAlignment;
        try module.setFileSizeAlignment(active.section_id, alignment);
        active.file_offset = try alignForward(active.file_offset, alignment);
        active.file_aligned = true;
        return;
    }

    if (std.mem.eql(u8, call.callee, "output.org") or
        std.mem.eql(u8, call.callee, "output.section"))
    {
        try callbacks.require_arg_count(call, 2);
        try callbacks.require_open_output_region(active.*);
        try callbacks.sync_active_output_offset_for_layout_api(module, active);

        const current_section = try module.sections.get(active.section_id);
        if (current_section.kind != .main) return error.InvalidApiCall;

        const name = try callbacks.source_path_arg_at_context(module.allocator, module, context, active.*, call, 0);
        defer module.allocator.free(name);
        const origin = try callbacks.integer_arg_at_context(module, context, active.*, call, 1);
        const relative_file_offset = if (std.mem.eql(u8, call.callee, "output.org"))
            active.offset
        else
            active.file_offset;
        const file_offset = try checkedAdd(current_section.file_offset, relative_file_offset);
        active.* = .{
            .section_id = try module.createOutputSection(name, origin, file_offset),
            .offset = 0,
            .file_offset = 0,
            .file_aligned = false,
            .target = active.target,
            .opened_at = active.opened_at,
        };
        return;
    }

    if (std.mem.eql(u8, call.callee, "virtual.begin")) {
        if (call.args.len != 0 and call.args.len != 1) return error.InvalidApiArity;
        // The default origin is "the current address", and the cursor only
        // includes an instruction once that instruction is encoded. Without this
        // sync the region starts short by the size of every instruction written
        // before it, which is a wrong address in the emitted image.
        try callbacks.sync_active_output_offset_for_layout_api(module, active);
        const origin = if (call.args.len == 1)
            try callbacks.integer_arg_at_context(module, context, active.*, call, 0)
        else
            try callbacks.active_address(module, active.*);
        try output_stack.append(module.allocator, active.*);
        errdefer callbacks.discard_last_active_output(output_stack);
        active.* = .{
            .section_id = try module.createVirtualSection(origin),
            .offset = 0,
            .file_offset = 0,
            .file_aligned = false,
            .target = active.target,
            .opened_at = call.span,
        };
        return;
    }

    if (std.mem.eql(u8, call.callee, "virtual.end")) {
        try callbacks.require_arg_count(call, 0);
        active.* = output_stack.pop() orelse return error.UnmatchedVirtualEnd;
        module.target = active.target;
        return;
    }

    if (std.mem.eql(u8, call.callee, "x86.use16")) {
        try callbacks.require_arg_count(call, 0);
        active.target = try target.Target.initX86(16);
        module.target = active.target;
        return;
    }

    if (std.mem.eql(u8, call.callee, "x86.use32")) {
        try callbacks.require_arg_count(call, 0);
        active.target = try target.Target.initX86(32);
        module.target = active.target;
        return;
    }

    if (std.mem.eql(u8, call.callee, "x86.use64")) {
        try callbacks.require_arg_count(call, 0);
        active.target = try target.Target.initX86(64);
        module.target = active.target;
        return;
    }

    if (std.mem.eql(u8, call.callee, "riscv.use32")) {
        try callbacks.require_arg_count(call, 0);
        active.target = try target.Target.initRiscv(32);
        module.target = active.target;
        return;
    }

    if (std.mem.eql(u8, call.callee, "riscv.use64")) {
        try callbacks.require_arg_count(call, 0);
        active.target = try target.Target.initRiscv(64);
        module.target = active.target;
        return;
    }

    if (std.mem.eql(u8, call.callee, "spv.use")) {
        try callbacks.require_arg_count(call, 0);
        active.target = target.Target.spv();
        module.target = active.target;
        return;
    }

    if (dataOperation(call.callee)) |operation| {
        try callbacks.require_open_output_region(active.*);
        switch (operation) {
            .emit => |byte_count| try callbacks.lower_data_emit(module, context, active, call, byte_count),
            .emit_float => |byte_count| try callbacks.lower_float_emit(module, context, active, call, byte_count),
            .reserve => |scale| try callbacks.lower_data_reserve(module, context, active, call, scale),
        }
        return;
    }

    if (std.mem.eql(u8, call.callee, "emit.u8")) {
        try callbacks.require_open_output_region(active.*);
        try callbacks.require_arg_count(call, 1);
        const value = try integerArgAs(u8, callbacks, module, context, active.*, call, 0);
        const fragment_id = try module.emitBytes(active.section_id, &.{value}, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (std.mem.eql(u8, call.callee, "emit.u16")) {
        try callbacks.require_open_output_region(active.*);
        try callbacks.require_arg_count(call, 1);
        var bytes: [2]u8 = undefined;
        std.mem.writeInt(u16, &bytes, try integerArgAs(u16, callbacks, module, context, active.*, call, 0), .little);
        const fragment_id = try module.emitBytes(active.section_id, &bytes, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (std.mem.eql(u8, call.callee, "emit.u32")) {
        try callbacks.require_open_output_region(active.*);
        try callbacks.require_arg_count(call, 1);
        var bytes: [4]u8 = undefined;
        std.mem.writeInt(u32, &bytes, try integerArgAs(u32, callbacks, module, context, active.*, call, 0), .little);
        const fragment_id = try module.emitBytes(active.section_id, &bytes, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (std.mem.eql(u8, call.callee, "emit.u64")) {
        try callbacks.require_open_output_region(active.*);
        try callbacks.require_arg_count(call, 1);
        var bytes: [8]u8 = undefined;
        std.mem.writeInt(u64, &bytes, try callbacks.integer_arg_at_context(module, context, active.*, call, 0), .little);
        const fragment_id = try module.emitBytes(active.section_id, &bytes, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (std.mem.eql(u8, call.callee, "emit.bytes")) {
        try callbacks.require_open_output_region(active.*);
        try callbacks.require_arg_count(call, 1);
        var value = try callbacks.value_arg_at_context(module.allocator, module, context, active.*, call, 0);
        defer value.deinit(module.allocator);
        const bytes = switch (value) {
            .bytes => |data| data,
            .string => |text| text,
            .operand, .void, .integer, .float32, .float64, .boolean, .type, .@"struct", .list, .map => return error.InvalidApiArgument,
        };
        const fragment_id = try module.emitBytes(active.section_id, bytes, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (std.mem.eql(u8, call.callee, "emit.file")) {
        try callbacks.require_open_output_region(active.*);
        try callbacks.lower_file_emit(module, context, active, call);
        return;
    }

    if (std.mem.eql(u8, call.callee, "emit.struct")) {
        try callbacks.require_open_output_region(active.*);
        try callbacks.require_arg_count(call, 1);
        var value = try callbacks.value_arg_at_context(module.allocator, module, context, active.*, call, 0);
        defer value.deinit(module.allocator);
        const struct_value = switch (value) {
            .@"struct" => |stored| stored,
            .operand, .void, .integer, .float32, .float64, .boolean, .string, .bytes, .type, .list, .map => return error.InvalidApiArgument,
        };
        const bytes = try callbacks.emit_struct_value(module, struct_value);
        defer module.allocator.free(bytes);
        const fragment_id = try module.emitBytes(active.section_id, bytes, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (std.mem.eql(u8, call.callee, "store.u8") or
        std.mem.eql(u8, call.callee, "store.u16") or
        std.mem.eql(u8, call.callee, "store.u32") or
        std.mem.eql(u8, call.callee, "store.u64"))
    {
        const byte_count = storeByteCount(call.callee) orelse return error.InvalidApiCall;
        try callbacks.require_arg_count(call, 2);
        try callbacks.materialize_instruction_bytes_for_output_access(module);
        const store_target = try callbacks.output_store_target_at_context(module, context, active.*, call, 0);
        const value = try callbacks.integer_arg_at_context(module, context, active.*, call, 1);
        try module.storeIntegerAt(store_target.section, store_target.address, value, byte_count);
        return;
    }

    if (std.mem.eql(u8, call.callee, "store.bytes")) {
        try callbacks.require_arg_count(call, 2);
        try callbacks.materialize_instruction_bytes_for_output_access(module);
        const store_target = try callbacks.output_store_target_at_context(module, context, active.*, call, 0);
        var value = try callbacks.value_arg_at_context(module.allocator, module, context, active.*, call, 1);
        defer value.deinit(module.allocator);
        const bytes = switch (value) {
            .bytes => |data| data,
            .string => |text| text,
            .operand, .void, .integer, .float32, .float64, .boolean, .type, .@"struct", .list, .map => return error.InvalidApiArgument,
        };
        try module.storeBytesAt(store_target.section, store_target.address, bytes);
        return;
    }

    if (std.mem.eql(u8, call.callee, "reserve")) {
        try callbacks.require_open_output_region(active.*);
        try callbacks.require_arg_count(call, 1);
        const fragment_id = try module.reserve(active.section_id, try callbacks.integer_arg_at_context(module, context, active.*, call, 0), 1, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (std.mem.eql(u8, call.callee, "pad")) {
        try callbacks.require_open_output_region(active.*);
        if (call.args.len != 1 and call.args.len != 2) return error.InvalidApiArity;
        try callbacks.sync_active_output_offset_for_layout_api(module, active);
        const size = try callbacks.integer_arg_at_context(module, context, active.*, call, 0);
        const fill = if (call.args.len == 2) try integerArgAs(u8, callbacks, module, context, active.*, call, 1) else 0;
        const fragment_id = try module.emitRepeatedByte(active.section_id, fill, size, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (std.mem.eql(u8, call.callee, "pad_to")) {
        try callbacks.require_open_output_region(active.*);
        if (call.args.len != 1 and call.args.len != 2) return error.InvalidApiArity;
        try callbacks.sync_active_output_offset_for_layout_api(module, active);
        const target_offset = try callbacks.integer_arg_at_context(module, context, active.*, call, 0);
        const materialized_offset = try materializedOffset(active.offset, active.file_offset);
        if (target_offset < materialized_offset) return error.InvalidApiInteger;
        const fill = if (call.args.len == 2) try integerArgAs(u8, callbacks, module, context, active.*, call, 1) else 0;
        const size = target_offset - materialized_offset;
        const fragment_id = try module.emitRepeatedByte(active.section_id, fill, size, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (std.mem.eql(u8, call.callee, "align")) {
        try callbacks.require_open_output_region(active.*);
        if (call.args.len != 1 and call.args.len != 2) return error.InvalidApiArity;
        try callbacks.sync_active_output_offset_for_layout_api(module, active);
        const alignment = try callbacks.integer_arg_at_context(module, context, active.*, call, 0);
        if (!isPowerOfTwoNonZero(alignment)) return error.InvalidAlignment;
        const fill = if (call.args.len == 2) try integerArgAs(u8, callbacks, module, context, active.*, call, 1) else 0;
        const fragment_id = try module.addAlignment(active.section_id, alignment, fill, call.span);
        try callbacks.advance_active_output(active, module.fragments.items.items[fragment_id.index]);
        return;
    }

    if (context.macros.contains(call.callee)) {
        try module.diagnostics.add(allocator, .err, call.span, "macro calls use instruction syntax without parentheses");
        return error.FrontendDiagnostics;
    }

    // A reader who mistyped a call name needs the name in the message: the
    // error alone carries no payload, and the location only points at the line.
    const message = try std.fmt.allocPrint(allocator, "unknown call: {s}", .{call.callee});
    defer allocator.free(message);
    try module.diagnostics.add(allocator, .err, call.span, message);
    return error.FrontendDiagnostics;
}

pub fn apiCallHasOutputSideEffect(callee: []const u8) bool {
    return std.mem.eql(u8, callee, "isa") or
        std.mem.eql(u8, callee, "include") or
        std.mem.eql(u8, callee, "import") or
        std.mem.eql(u8, callee, "origin") or
        std.mem.eql(u8, callee, "output.org") or
        std.mem.eql(u8, callee, "output.section") or
        std.mem.eql(u8, callee, "x86.use16") or
        std.mem.eql(u8, callee, "x86.use32") or
        std.mem.eql(u8, callee, "x86.use64") or
        std.mem.eql(u8, callee, "riscv.use32") or
        std.mem.eql(u8, callee, "riscv.use64") or
        std.mem.eql(u8, callee, "spv.use") or
        std.mem.eql(u8, callee, "emit.u8") or
        std.mem.eql(u8, callee, "emit.u16") or
        std.mem.eql(u8, callee, "emit.u32") or
        std.mem.eql(u8, callee, "emit.u64") or
        dataOperation(callee) != null or
        std.mem.eql(u8, callee, "region.begin") or
        std.mem.eql(u8, callee, "region.place") or
        std.mem.eql(u8, callee, "region.file_align") or
        std.mem.eql(u8, callee, "emit.bytes") or
        std.mem.eql(u8, callee, "emit.file") or
        std.mem.eql(u8, callee, "emit.struct") or
        std.mem.eql(u8, callee, "pad") or
        std.mem.eql(u8, callee, "pad_to") or
        std.mem.eql(u8, callee, "align") or
        std.mem.eql(u8, callee, "reserve") or
        std.mem.eql(u8, callee, "label.define") or
        std.mem.eql(u8, callee, "virtual.begin") or
        std.mem.eql(u8, callee, "virtual.end") or
        std.mem.startsWith(u8, callee, "store.");
}

pub fn storeByteCount(name: []const u8) ?u8 {
    if (std.mem.eql(u8, name, "store.u8")) return 1;
    if (std.mem.eql(u8, name, "store.u16")) return 2;
    if (std.mem.eql(u8, name, "store.u32")) return 4;
    if (std.mem.eql(u8, name, "store.u64")) return 8;
    return null;
}

pub const DataOperation = union(enum) {
    emit: u8,
    emit_float: u8,
    reserve: u64,
};

const DataOperationDescriptor = struct {
    name: []const u8,
    operation: DataOperation,
};

const data_operations = [_]DataOperationDescriptor{
    // api-matrix-lower: "emit.f32"
    .{ .name = "emit.f32", .operation = .{ .emit_float = 4 } },
    // api-matrix-lower: "emit.f64"
    .{ .name = "emit.f64", .operation = .{ .emit_float = 8 } },
    // api-matrix-lower: "db"
    .{ .name = "db", .operation = .{ .emit = 1 } },
    // api-matrix-lower: "dw"
    .{ .name = "dw", .operation = .{ .emit = 2 } },
    // api-matrix-lower: "dd"
    .{ .name = "dd", .operation = .{ .emit = 4 } },
    // api-matrix-lower: "dp"
    .{ .name = "dp", .operation = .{ .emit = 6 } },
    // api-matrix-lower: "dq"
    .{ .name = "dq", .operation = .{ .emit = 8 } },
    // api-matrix-lower: "dt"
    .{ .name = "dt", .operation = .{ .emit = 10 } },
    // api-matrix-lower: "ddq"
    .{ .name = "ddq", .operation = .{ .emit = 16 } },
    // api-matrix-lower: "dqq"
    .{ .name = "dqq", .operation = .{ .emit = 32 } },
    // api-matrix-lower: "ddqq"
    .{ .name = "ddqq", .operation = .{ .emit = 64 } },
    // api-matrix-lower: "rb"
    .{ .name = "rb", .operation = .{ .reserve = 1 } },
    // api-matrix-lower: "rw"
    .{ .name = "rw", .operation = .{ .reserve = 2 } },
    // api-matrix-lower: "rd"
    .{ .name = "rd", .operation = .{ .reserve = 4 } },
    // api-matrix-lower: "rp"
    .{ .name = "rp", .operation = .{ .reserve = 6 } },
    // api-matrix-lower: "rq"
    .{ .name = "rq", .operation = .{ .reserve = 8 } },
    // api-matrix-lower: "rt"
    .{ .name = "rt", .operation = .{ .reserve = 10 } },
    // api-matrix-lower: "rdq"
    .{ .name = "rdq", .operation = .{ .reserve = 16 } },
    // api-matrix-lower: "rqq"
    .{ .name = "rqq", .operation = .{ .reserve = 32 } },
    // api-matrix-lower: "rdqq"
    .{ .name = "rdqq", .operation = .{ .reserve = 64 } },
};

pub fn dataOperation(name: []const u8) ?DataOperation {
    for (data_operations) |descriptor| {
        if (std.mem.eql(u8, name, descriptor.name)) return descriptor.operation;
    }
    return null;
}

pub fn isAllowedLateLayoutApi(callee: []const u8) bool {
    return std.mem.eql(u8, callee, "print") or
        std.mem.eql(u8, callee, "warn") or
        std.mem.eql(u8, callee, "err") or
        std.mem.eql(u8, callee, "assert") or
        std.mem.eql(u8, callee, "origin") or
        std.mem.eql(u8, callee, "region.begin") or
        std.mem.eql(u8, callee, "region.place") or
        std.mem.eql(u8, callee, "region.file_align") or
        std.mem.eql(u8, callee, "output.org") or
        std.mem.eql(u8, callee, "output.section") or
        std.mem.eql(u8, callee, "virtual.begin") or
        std.mem.eql(u8, callee, "virtual.end") or
        std.mem.eql(u8, callee, "emit.u8") or
        std.mem.eql(u8, callee, "emit.u16") or
        std.mem.eql(u8, callee, "emit.u32") or
        std.mem.eql(u8, callee, "emit.u64") or
        std.mem.eql(u8, callee, "emit.bytes") or
        std.mem.eql(u8, callee, "emit.struct") or
        std.mem.eql(u8, callee, "store.bytes") or
        std.mem.eql(u8, callee, "reserve") or
        std.mem.eql(u8, callee, "pad") or
        std.mem.eql(u8, callee, "pad_to") or
        std.mem.eql(u8, callee, "align") or
        dataOperation(callee) != null or
        storeByteCount(callee) != null;
}

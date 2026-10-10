const std = @import("std");

const ast = @import("../ast.zig");
const fragment = @import("../fragment.zig");
const module_mod = @import("../module.zig");
const output_mod = @import("../output/root.zig");
const source = @import("../source.zig");
const contracts = @import("contracts.zig");
const context_mod = @import("context.zig");
const deferred = @import("deferred.zig");

const Allocator = std.mem.Allocator;
const ActiveOutput = contracts.ActiveOutput;
const LowerContext = context_mod.LowerContext;
const LowerError = contracts.LowerError;

pub const RuntimeCallbacks = struct {
    section_cursor: *const fn (module: *module_mod.Module, section_id: fragment.SectionId) LowerError!u64,
    section_file_cursor: *const fn (module: *module_mod.Module, section_id: fragment.SectionId) LowerError!u64,
    run_api_call: *const fn (
        allocator: Allocator,
        module: *module_mod.Module,
        active: *ActiveOutput,
        output_stack: *std.ArrayList(ActiveOutput),
        context: *LowerContext,
        call: output_mod.ApiCall,
    ) LowerError!void,
    eval_condition: *const fn (
        module: *module_mod.Module,
        context: *LowerContext,
        active: ActiveOutput,
        condition: []const u8,
    ) LowerError!bool,
};

pub const BuildCallbacks = struct {
    is_allowed_api: *const fn (callee: []const u8) bool,
    eval_condition: *const fn (
        module: *module_mod.Module,
        context: *LowerContext,
        active: ActiveOutput,
        condition: []const u8,
    ) LowerError!bool,
};

pub fn runPhase(
    allocator: Allocator,
    module: *module_mod.Module,
    callbacks: RuntimeCallbacks,
) LowerError!void {
    if (module.late_layout.items.items.len == 0) {
        return;
    }

    try runBlocksOnce(allocator, module, callbacks);
}

fn runBlocksOnce(
    allocator: Allocator,
    module: *module_mod.Module,
    callbacks: RuntimeCallbacks,
) LowerError!void {
    var context: LowerContext = .{};
    defer context.deinit(allocator);

    const default_section = try module.sections.get(module.default_section);
    var active: ActiveOutput = .{
        .section_id = module.default_section,
        .offset = try callbacks.section_cursor(module, module.default_section),
        .file_offset = try callbacks.section_file_cursor(module, module.default_section),
        .file_aligned = default_section.file_aligned,
        .target = module.target,
    };
    var output_stack: std.ArrayList(ActiveOutput) = .empty;
    defer output_stack.deinit(allocator);

    for (module.late_layout.items.items) |block| {
        const previous_expansion = module.diagnostics.active_expansion;
        module.diagnostics.active_expansion = block.span.expansion;
        defer module.diagnostics.active_expansion = previous_expansion;
        const diagnostic_start = module.diagnostics.items.items.len;
        const written_section = active.section_id;
        const fragments_before = sectionFragmentCount(module, written_section);
        runStatements(allocator, module, &active, &output_stack, &context, block.body, callbacks) catch |err| {
            if (err == error.OutOfMemory) return err;
            if (module.diagnostics.items.items.len > diagnostic_start) return err;
            try addLateLayoutDiagnostic(allocator, module, block.span, err);
            return error.FrontendDiagnostics;
        };
        // A late-layout block starts with the default region active, not the
        // region that was active where the block was written. A block that
        // appends without choosing a region therefore lands somewhere other than
        // where the source reads, and only a warning says so -- the overlap
        // warning cannot, because the two regions usually do not overlap.
        if (block.source_section_index) |source_index| {
            if (source_index != written_section.index and
                sectionFragmentCount(module, written_section) != fragments_before)
            {
                const message = try std.fmt.allocPrint(
                    allocator,
                    "this late_layout block was written inside region '{s}', but a late_layout block starts with region '{s}' active and its bytes went there; call region.place or output.section inside the block to choose the region",
                    .{
                        sectionName(module, .{ .index = source_index }),
                        sectionName(module, written_section),
                    },
                );
                defer allocator.free(message);
                try module.diagnostics.add(allocator, .warning, block.span, message);
            }
        }
    }

    if (output_stack.items.len != 0) {
        if (active.opened_at) |span| {
            try addLateLayoutDiagnostic(allocator, module, span, error.UnclosedVirtualOutput);
            return error.FrontendDiagnostics;
        }
        return error.UnclosedVirtualOutput;
    }
}

/// A late-layout block runs during assembly, long after its statements were
/// parsed, so a failure in it has no lowering-time diagnostic to fall back on.
/// Without this the reader sees only `assembly failed: <error name>`, with no
/// file and no line.
fn sectionFragmentCount(module: *const module_mod.Module, section_id: fragment.SectionId) usize {
    const stored = module.sections.get(section_id) catch return 0;
    return stored.fragments.items.len;
}

fn sectionName(module: *const module_mod.Module, section_id: fragment.SectionId) []const u8 {
    const stored = module.sections.get(section_id) catch return "?";
    return stored.name;
}

fn addLateLayoutDiagnostic(
    allocator: Allocator,
    module: *module_mod.Module,
    span: source.SourceSpan,
    err: anyerror,
) Allocator.Error!void {
    const message = if (lateLayoutErrorDetail(err)) |detail|
        try std.fmt.allocPrint(allocator, "{s} ({s})", .{ detail, @errorName(err) })
    else
        try std.fmt.allocPrint(allocator, "late layout failed: {s}", .{@errorName(err)});
    defer allocator.free(message);
    try module.diagnostics.add(allocator, .err, span, message);
}

fn lateLayoutErrorDetail(err: anyerror) ?[]const u8 {
    return switch (err) {
        error.InvalidExpression => "an expression in this late-layout statement is not valid; final region facts (region_file_size, region_logical_size, region_file_offset) are available only in a finalizer",
        error.InvalidApiCall => "the call syntax is not valid",
        error.InvalidApiArgument => "a call argument does not match what the call expects",
        error.InvalidMetaIf => "the late-layout condition is not valid",
        error.InvalidMetaStatement => "this statement is not valid inside late_layout",
        error.UnclosedVirtualOutput => "a scratch region opened here was never closed with virtual.end()",
        error.InvalidAlignment => "the alignment must be a nonzero power of two",
        else => null,
    };
}

fn runStatements(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    context: *LowerContext,
    statements: []const output_mod.LateLayoutStatement,
    callbacks: RuntimeCallbacks,
) LowerError!void {
    for (statements) |statement| {
        const diagnostic_start = module.diagnostics.items.items.len;
        runStatement(allocator, module, active, output_stack, context, statement, callbacks) catch |err| {
            if (err == error.OutOfMemory) return err;
            if (module.diagnostics.items.items.len > diagnostic_start) return err;
            try addLateLayoutDiagnostic(allocator, module, statement.span(), err);
            return error.FrontendDiagnostics;
        };
    }
}

fn runStatement(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    context: *LowerContext,
    statement: output_mod.LateLayoutStatement,
    callbacks: RuntimeCallbacks,
) LowerError!void {
    switch (statement) {
        .api_call => |call| try callbacks.run_api_call(allocator, module, active, output_stack, context, call),
        .meta_if => |meta_if| {
            if (try callbacks.eval_condition(module, context, active.*, meta_if.condition)) {
                try runStatements(allocator, module, active, output_stack, context, meta_if.body, callbacks);
            } else {
                try runStatements(allocator, module, active, output_stack, context, meta_if.else_body, callbacks);
            }
        },
    }
}

pub fn cloneBlockFromAst(
    allocator: Allocator,
    late_layout: ast.LateLayoutStatement,
    callbacks: BuildCallbacks,
) LowerError!output_mod.LateLayoutBlock {
    const body = try cloneStatementSlice(allocator, late_layout.body, callbacks);
    return .{
        .body = body,
        .span = late_layout.span,
    };
}

pub fn freezeBlockFromAst(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    late_layout: ast.LateLayoutStatement,
    callbacks: BuildCallbacks,
) LowerError!output_mod.LateLayoutBlock {
    const body = try freezeStatementSlice(allocator, module, context, active, late_layout.body, callbacks);
    return .{
        .body = body,
        .span = late_layout.span,
    };
}

fn cloneStatementSlice(
    allocator: Allocator,
    statements: []const ast.Statement,
    callbacks: BuildCallbacks,
) LowerError![]output_mod.LateLayoutStatement {
    const cloned = try allocator.alloc(output_mod.LateLayoutStatement, statements.len);
    var cloned_len: usize = 0;
    errdefer {
        for (cloned[0..cloned_len]) |*statement| {
            statement.deinit(allocator);
        }
        allocator.free(cloned);
    }

    for (statements, 0..) |statement, index| {
        cloned[index] = try cloneStatement(allocator, statement, callbacks);
        cloned_len += 1;
    }
    return cloned;
}

fn freezeStatementSlice(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    statements: []const ast.Statement,
    callbacks: BuildCallbacks,
) LowerError![]output_mod.LateLayoutStatement {
    var frozen: std.ArrayList(output_mod.LateLayoutStatement) = .empty;
    errdefer {
        for (frozen.items) |*statement| {
            statement.deinit(allocator);
        }
        frozen.deinit(allocator);
    }

    for (statements) |statement| {
        try freezeStatementAppend(allocator, module, context, active, statement, &frozen, callbacks);
    }

    return frozen.toOwnedSlice(allocator);
}

fn cloneStatement(
    allocator: Allocator,
    statement: ast.Statement,
    callbacks: BuildCallbacks,
) LowerError!output_mod.LateLayoutStatement {
    return switch (statement) {
        .api_call => |call| .{ .api_call = try cloneApiCall(allocator, call, callbacks) },
        .meta_if => |meta_if| .{ .meta_if = try cloneMetaIf(allocator, meta_if, callbacks) },
        .label,
        .isa_instruction,
        .value_decl,
        .assignment,
        .struct_decl,
        .meta_while,
        .meta_for_range,
        .meta_break,
        .meta_continue,
        .meta_fn,
        .macro_def,
        .meta_return,
        .meta_block,
        .meta_defer,
        .late_layout,
        .meta_line,
        .meta_block_start,
        .meta_block_end,
        => error.InvalidLateLayout,
    };
}

fn freezeStatementAppend(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    statement: ast.Statement,
    frozen: *std.ArrayList(output_mod.LateLayoutStatement),
    callbacks: BuildCallbacks,
) LowerError!void {
    switch (statement) {
        .api_call => |call| {
            var frozen_call = try freezeApiCall(allocator, context, call, callbacks);
            errdefer frozen_call.deinit(allocator);
            try frozen.append(allocator, .{ .api_call = frozen_call });
        },
        .meta_if => |meta_if| {
            if (try callbacks.eval_condition(module, context, active, meta_if.condition)) {
                try freezeStatementSliceInto(allocator, module, context, active, meta_if.body, frozen, callbacks);
            } else {
                try freezeStatementSliceInto(allocator, module, context, active, meta_if.else_body, frozen, callbacks);
            }
        },
        .label,
        .isa_instruction,
        .value_decl,
        .assignment,
        .struct_decl,
        .meta_while,
        .meta_for_range,
        .meta_break,
        .meta_continue,
        .meta_fn,
        .macro_def,
        .meta_return,
        .meta_block,
        .meta_defer,
        .late_layout,
        .meta_line,
        .meta_block_start,
        .meta_block_end,
        => return error.InvalidLateLayout,
    }
}

fn freezeStatementSliceInto(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    statements: []const ast.Statement,
    frozen: *std.ArrayList(output_mod.LateLayoutStatement),
    callbacks: BuildCallbacks,
) LowerError!void {
    for (statements) |statement| {
        try freezeStatementAppend(allocator, module, context, active, statement, frozen, callbacks);
    }
}

fn cloneApiCall(
    allocator: Allocator,
    call: ast.ApiCallStatement,
    callbacks: BuildCallbacks,
) LowerError!output_mod.ApiCall {
    if (!callbacks.is_allowed_api(call.callee)) return error.InvalidLateLayout;
    return .{
        .text = try allocator.dupe(u8, call.text),
        .span = call.span,
    };
}

fn freezeApiCall(
    allocator: Allocator,
    context: *LowerContext,
    call: ast.ApiCallStatement,
    callbacks: BuildCallbacks,
) LowerError!output_mod.ApiCall {
    if (!callbacks.is_allowed_api(call.callee)) return error.InvalidLateLayout;

    var text: std.ArrayList(u8) = .empty;
    errdefer text.deinit(allocator);

    try text.appendSlice(allocator, call.callee);
    try text.append(allocator, '(');
    for (call.args, 0..) |*arg, index| {
        if (index != 0) try text.appendSlice(allocator, ", ");
        const rendered = try deferred.renderFrozenArgument(allocator, context, arg);
        defer allocator.free(rendered);
        try text.appendSlice(allocator, rendered);
    }
    try text.append(allocator, ')');

    return .{
        .text = try text.toOwnedSlice(allocator),
        .span = call.span,
    };
}

fn cloneMetaIf(
    allocator: Allocator,
    meta_if: ast.MetaIfStatement,
    callbacks: BuildCallbacks,
) LowerError!output_mod.LateLayoutMetaIf {
    const condition = try allocator.dupe(u8, meta_if.condition);
    errdefer allocator.free(condition);
    const body = try cloneStatementSlice(allocator, meta_if.body, callbacks);
    errdefer {
        for (body) |*statement| {
            statement.deinit(allocator);
        }
        allocator.free(body);
    }
    const else_body = try cloneStatementSlice(allocator, meta_if.else_body, callbacks);
    return .{
        .condition = condition,
        .body = body,
        .else_body = else_body,
        .span = meta_if.span,
    };
}

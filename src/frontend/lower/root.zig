const std = @import("std");
const macro = @import("../macro.zig");

const ast = @import("../ast.zig");
const expr = @import("../expr.zig");
const diagnostic = @import("../diagnostic.zig");
const module_mod = @import("../module.zig");
const output_mod = @import("../output/root.zig");
const parser = @import("../parser.zig");
const source = @import("../source.zig");
const target = @import("../target.zig");
const value_mod = @import("../value.zig");
const aggregate_literal = @import("aggregate_literal.zig");
const arguments = @import("arguments.zig");
const collection_mutation = @import("collection_mutation.zig");
const contracts = @import("contracts.zig");
const context_mod = @import("context.zig");
const data_emission = @import("data_emission.zig");
const expression_materialization = @import("expression_materialization.zig");
const expression_bridge = @import("expression_bridge.zig");
const deferred = @import("deferred.zig");
const api_mod = @import("api.zig");
const diagnostic_lowering = @import("diagnostic_lowering.zig");
const late_layout_mod = @import("late_layout.zig");
const isa_lowering = @import("isa_lowering.zig");
const layout_cursor = @import("layout_cursor.zig");
const meta_io = @import("../meta_io.zig");
const meta_condition = @import("meta_condition.zig");
const meta_control_flow = @import("meta_control_flow.zig");
const meta_function_runtime = @import("meta_function_runtime.zig");
const output_target = @import("output_target.zig");
const source_loading = @import("source_loading.zig");
const type_declaration = @import("type_declaration.zig");
const value_binding = @import("value_binding.zig");

pub const LowerContext = context_mod.LowerContext;
pub const pushMetaScope = context_mod.pushMetaScope;
pub const popMetaScope = context_mod.popMetaScope;
pub const defineFinalLocalValue = context_mod.defineFinalLocalValue;
pub const setFinalLocalValue = context_mod.setFinalLocalValue;
pub const resolveLocalValue = context_mod.resolveLocalValue;
pub const lookupLocalValueAlias = context_mod.lookupLocalValueAlias;

const discardLastScope = context_mod.discardLastScope;

const mapLowerErrorToExpression = expression_bridge.mapLowerErrorToExpression;
const mapExpressionError = expression_bridge.mapExpressionError;
const ActiveExpressionContext = expression_bridge.ActiveExpressionContext;

const activeAddress = layout_cursor.activeAddress;
const requireOpenOutputRegion = layout_cursor.requireOpenOutputRegion;
const discardLastActiveOutput = layout_cursor.discardLastActiveOutput;
const advanceActiveOutput = layout_cursor.advanceActiveOutput;
const sectionCursor = layout_cursor.sectionCursor;
const sectionFileCursor = layout_cursor.sectionFileCursor;
const activeFragmentPosition = layout_cursor.activeFragmentPosition;

const materializeInstructionBytesForExpression = expression_materialization.forExpression;
const materializeInstructionBytesForOutputAccess = expression_materialization.forOutputAccess;
const syncActiveOutputOffsetForLayoutApi = expression_materialization.syncActiveOutput;

const Allocator = std.mem.Allocator;

pub const LowerError = contracts.LowerError;
pub const LowerOptions = contracts.LowerOptions;
pub const LateLayoutResult = contracts.LateLayoutResult;
pub const IncludeResolver = contracts.IncludeResolver;
pub const IncludeRequest = contracts.IncludeRequest;
pub const IncludeSource = contracts.IncludeSource;
pub const DirEntry = meta_io.DirEntry;
pub const DirListing = meta_io.DirListing;
pub const SectionId = contracts.SectionId;
pub const Fragment = contracts.Fragment;
pub const DiagnosticSeverity = contracts.DiagnosticSeverity;
pub const ActiveOutput = contracts.ActiveOutput;
pub const OutputStoreTarget = contracts.OutputStoreTarget;

pub const max_finalizer_loop_iterations = meta_control_flow.max_iterations;

pub fn lowerSource(
    allocator: Allocator,
    input: []const u8,
    options: LowerOptions,
) LowerError!module_mod.Module {
    return source_loading.lowerSource(allocator, input, options, sourceLoadingCallbacks());
}

pub fn lowerSourceIntoModule(
    allocator: Allocator,
    module: *module_mod.Module,
    input: []const u8,
) LowerError!void {
    return source_loading.lowerIntoModule(allocator, module, input, sourceLoadingCallbacks());
}

pub fn lowerSourceIntoModuleWithPath(
    allocator: Allocator,
    module: *module_mod.Module,
    path: []const u8,
    input: []const u8,
) LowerError!void {
    return source_loading.lowerIntoModuleWithPath(allocator, module, path, input, null, sourceLoadingCallbacks());
}

pub fn lowerSourceIntoModuleWithPathOptions(
    allocator: Allocator,
    module: *module_mod.Module,
    path: []const u8,
    input: []const u8,
    options: LowerOptions,
) LowerError!void {
    return source_loading.lowerIntoModuleWithPath(allocator, module, path, input, options, sourceLoadingCallbacks());
}

pub fn lowerStatements(
    allocator: Allocator,
    statements: []const ast.Statement,
    options: LowerOptions,
) LowerError!module_mod.Module {
    var module = try module_mod.Module.init(allocator, options.target);
    errdefer module.deinit();

    var context: LowerContext = .{ .include_resolver = options.include_resolver };
    defer context.deinit(allocator);

    try lowerStatementsIntoModuleContext(allocator, &module, statements, &context);
    return module;
}

pub fn lowerStatementsIntoModule(
    allocator: Allocator,
    module: *module_mod.Module,
    statements: []const ast.Statement,
) LowerError!void {
    var context: LowerContext = .{};
    defer context.deinit(allocator);

    try lowerStatementsIntoModuleContext(allocator, module, statements, &context);
}

fn lowerStatementsIntoModuleContext(
    allocator: Allocator,
    module: *module_mod.Module,
    statements: []const ast.Statement,
    context: *LowerContext,
) LowerError!void {
    var active: ActiveOutput = .{
        .section_id = module.default_section,
        .offset = try sectionCursor(module, module.default_section),
        .file_offset = try sectionFileCursor(module, module.default_section),
        .file_aligned = false,
        .target = module.target,
    };
    var output_stack: std.ArrayList(ActiveOutput) = .empty;
    defer output_stack.deinit(allocator);

    try lowerStatementSlice(allocator, module, &active, &output_stack, statements, context);

    // An unbalanced `virtual.begin` is found here, after every statement has
    // run, so this error cannot borrow the statement-level fallback: without a
    // recorded diagnostic the reader gets `assembly failed:
    // UnclosedVirtualOutput` with no file and no line. The open call's span
    // travelled with the active output; report the failure there.
    if (output_stack.items.len != 0) {
        if (active.opened_at) |span| {
            try addLowerErrorDiagnostic(allocator, module, span, error.UnclosedVirtualOutput);
        }
        return error.UnclosedVirtualOutput;
    }
}

fn lowerStatementSlice(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    statements: []const ast.Statement,
    context: *LowerContext,
) LowerError!void {
    for (statements) |statement| {
        const diagnostic_start = module.diagnostics.items.items.len;
        lowerStatement(allocator, module, active, output_stack, statement.withExpansion(module.diagnostics.active_expansion), context) catch |err| {
            if (err == error.MetaFunctionReturned or err == error.MetaLoopBreak or err == error.MetaLoopContinue) return err;
            if (err == error.FrontendDiagnostics) return err;
            if (err == error.OutOfMemory) return err;
            if (module.diagnostics.items.items.len > diagnostic_start) return err;
            try addLowerErrorDiagnostic(allocator, module, statement.span(), err);
            return err;
        };
    }
}

fn lowerScopedStatementSlice(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    statements: []const ast.Statement,
    context: *LowerContext,
) LowerError!void {
    try context.scopes.append(allocator, .{});
    defer discardLastScope(context, allocator);

    try lowerStatementSlice(allocator, module, active, output_stack, statements, context);
}

pub fn runLateLayoutPhase(
    allocator: Allocator,
    module: *module_mod.Module,
) LowerError!void {
    try late_layout_mod.runPhase(allocator, module, lateLayoutRuntimeCallbacks());
}

fn runLateLayoutApiCall(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    context: *LowerContext,
    call: output_mod.ApiCall,
) LowerError!void {
    var parsed = parser.parseApiCallText(allocator, call.text, call.span) catch |err| return mapParseError(err);
    defer parsed.deinit(allocator);
    try api_mod.lowerApiCall(allocator, module, active, output_stack, parsed, context, apiCallbacks());
}

fn evalLateLayoutCondition(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    condition: []const u8,
) LowerError!bool {
    return evalMetaCondition(module, context, active, condition);
}

fn lowerStatement(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    statement: ast.Statement,
    context: *LowerContext,
) LowerError!void {
    // Expression evaluation runs while a statement is being lowered, so remember
    // which statement that is: a value function reached from the expression
    // reports against this line instead of against its own body.
    const previous_statement_span = context.statement_span;
    context.statement_span = statement.span();
    defer context.statement_span = previous_statement_span;

    switch (statement) {
        .label => |label| {
            if (context.value_function_depth != 0) return error.SideEffectInValueFunction;
            try requireOpenOutputRegion(active.*);
            const fragment_position = try activeFragmentPosition(module, active.section_id);
            const label_id = try module.defineAnchoredLabel(label.name, active.section_id, active.offset, fragment_position, label.span);
            if (label_id.index >= module.symbols.items.items.len) return error.InvalidSymbol;
        },
        .value_decl => |declaration| {
            try value_binding.lowerDeclaration(module, context, active.*, declaration, valueBindingCallbacks());
        },
        .assignment => |assignment| {
            try value_binding.lowerAssignment(module, context, active.*, assignment, valueBindingCallbacks());
        },
        .isa_instruction => |instruction| {
            if (context.value_function_depth != 0) return error.SideEffectInValueFunction;
            if (try macro.dispatch(allocator, module, active, output_stack, instruction, context, .{ .lower_statements = lowerStatementSlice })) return;
            try requireOpenOutputRegion(active.*);
            const forwarded = try macro.forwardNative(allocator, context, module, active.*, instruction.text, expressionCallbacks());
            const lowered_text = forwarded orelse try isa_lowering.lowerText(allocator, module, context, active.*, instruction.text, isaLoweringCallbacks());
            defer allocator.free(lowered_text);
            const fragment_id = try module.appendIsaInstruction(
                active.section_id,
                active.target,
                lowered_text,
                instruction.span,
            );
            try advanceActiveOutput(active, module.fragments.items.items[fragment_id.index]);
        },
        .struct_decl => |declaration| {
            try type_declaration.lower(allocator, module, context, active.*, declaration, typeDeclarationCallbacks());
        },
        .api_call => |call| {
            if (call.text.len > call.callee.len and std.ascii.isWhitespace(call.text[call.callee.len]) and context.macros.contains(call.callee)) {
                if (try macro.dispatch(allocator, module, active, output_stack, .{ .text = call.text, .span = call.span }, context, .{ .lower_statements = lowerStatementSlice })) return;
            }
            if (collection_mutation.mutationKind(call.callee)) |mutation| {
                try collection_mutation.lower(module, context, active.*, call, mutation, collectionMutationCallbacks());
                return;
            }
            if (context.value_function_depth != 0 and api_mod.apiCallHasOutputSideEffect(call.callee)) return error.SideEffectInValueFunction;
            try api_mod.lowerApiCall(allocator, module, active, output_stack, call, context, apiCallbacks());
        },
        .meta_if => |meta_if| {
            if (try evalMetaCondition(module, context, active.*, meta_if.condition)) {
                try lowerScopedStatementSlice(allocator, module, active, output_stack, meta_if.body, context);
            } else {
                try lowerScopedStatementSlice(allocator, module, active, output_stack, meta_if.else_body, context);
            }
        },
        .meta_while => |meta_while| {
            try meta_control_flow.lowerWhile(allocator, module, active, output_stack, meta_while, context, metaControlFlowCallbacks());
        },
        .meta_for_range => |meta_for| {
            try meta_control_flow.lowerForRange(allocator, module, active, output_stack, meta_for, context, metaControlFlowCallbacks());
        },
        .meta_break => |meta_break| {
            if (context.in_meta_loop) return error.MetaLoopBreak;
            try module.diagnostics.add(allocator, .err, meta_break.span, "break used outside of a Meta loop");
            return error.FrontendDiagnostics;
        },
        .meta_continue => |meta_continue| {
            if (context.in_meta_loop) return error.MetaLoopContinue;
            try module.diagnostics.add(allocator, .err, meta_continue.span, "continue used outside of a Meta loop");
            return error.FrontendDiagnostics;
        },
        .meta_fn => |meta_fn| {
            if (context.scopes.items.len != 0) return error.InvalidMetaFunction;
            if (meta_fn.return_type_name == null) {
                try context.functions.define(allocator, meta_fn);
            } else {
                try module.value_functions.define(allocator, meta_fn);
            }
        },
        .macro_def => |declaration| {
            if (context.scopes.items.len != 0) return error.InvalidMacro;
            try context.macros.define(allocator, declaration);
        },
        .meta_return => |meta_return| {
            if (context.value_function_depth == 0) return error.InvalidMetaFunction;
            if (context.return_value) |*previous| {
                previous.deinit(allocator);
                context.return_value = null;
            }
            context.return_value = try evalValueAtContext(allocator, module, context, active.*, &meta_return.value);
            context.return_span = meta_return.span;
            return error.MetaFunctionReturned;
        },
        .meta_block => |meta_block| {
            try lowerScopedStatementSlice(allocator, module, active, output_stack, meta_block.body, context);
        },
        .meta_defer => |meta_defer| {
            if (context.value_function_depth != 0) return error.SideEffectInValueFunction;
            if (output_stack.items.len != 0) return error.InvalidMetaDefer;
            var block = if (context.scopes.items.len == 0)
                try deferred.cloneBlockFromAst(allocator, meta_defer, deferredCallbacks())
            else blk: {
                // The finalizer freezes `here()` now, and the cursor only counts
                // an instruction once it is encoded: without this sync a frozen
                // address is short by the size of the instructions written
                // before the defer.
                try syncActiveOutputOffsetForLayoutApi(module, active);
                break :blk try deferred.freezeBlockFromAst(
                    allocator,
                    context,
                    try activeAddress(module, active.*),
                    meta_defer,
                    deferredCallbacks(),
                );
            };
            errdefer block.deinit(allocator);
            try module.appendDeferredBlock(block);
        },
        .late_layout => |late_layout| {
            if (context.value_function_depth != 0) return error.SideEffectInValueFunction;
            if (output_stack.items.len != 0) return error.InvalidLateLayout;
            var block = if (context.scopes.items.len == 0)
                try late_layout_mod.cloneBlockFromAst(allocator, late_layout, lateLayoutBuildCallbacks())
            else blk: {
                // Same reason as the finalizer above: a frozen `here()` must
                // include the instructions written before the block.
                try syncActiveOutputOffsetForLayoutApi(module, active);
                break :blk try late_layout_mod.freezeBlockFromAst(allocator, module, context, active.*, late_layout, lateLayoutBuildCallbacks());
            };
            errdefer block.deinit(allocator);
            // Remember the region the source was in here: the block itself will
            // start with the default region active.
            block.source_section_index = active.section_id.index;
            try module.appendLateLayoutBlock(block);
        },
        .meta_line, .meta_block_start, .meta_block_end => return error.InvalidMetaStatement,
    }
}

fn addLowerErrorDiagnostic(
    allocator: Allocator,
    module: *module_mod.Module,
    span: source.SourceSpan,
    err: anyerror,
) Allocator.Error!void {
    try addStatementErrorDiagnostic(allocator, module, span, err, "lowering failed");
}

/// A source that does not parse did not fail while lowering, so it must not be
/// reported as one: the wrong phase sends a reader to the wrong place.
fn addParseErrorDiagnostic(
    allocator: Allocator,
    module: *module_mod.Module,
    span: source.SourceSpan,
    err: anyerror,
) Allocator.Error!void {
    try addStatementErrorDiagnostic(allocator, module, span, err, "invalid statement");
}

fn addStatementErrorDiagnostic(
    allocator: Allocator,
    module: *module_mod.Module,
    span: source.SourceSpan,
    err: anyerror,
    fallback_prefix: []const u8,
) Allocator.Error!void {
    if (err == error.InvalidMetaStatement) {
        try module.diagnostics.add(
            allocator,
            .err,
            span,
            "invalid Meta statement or unmatched block delimiter; block headers must end with '{' on the same line",
        );
        return;
    }
    if (err == error.LegacyDirectiveSyntax) {
        try module.diagnostics.add(
            allocator,
            .err,
            span,
            "legacy assembler directive is not supported; use modern XIRASM API syntax",
        );
        return;
    }
    if (err == error.UnionFieldDefaultNotAllowed) {
        try module.diagnostics.add(
            allocator,
            .err,
            span,
            "union fields cannot declare defaults; a union literal must select exactly one active field",
        );
        return;
    }
    if (err == error.UnexpectedEndOfStatement) {
        try module.diagnostics.add(
            allocator,
            .err,
            span,
            "the statement ends before its parentheses or braces close",
        );
        return;
    }
    if (statementErrorDetail(err)) |detail| {
        // The reason first, because that is what a reader needs, then the
        // category name, which stays searchable and is what the negative
        // fixtures match on.
        const message = try std.fmt.allocPrint(allocator, "{s} ({s})", .{ detail, @errorName(err) });
        defer allocator.free(message);
        try module.diagnostics.add(allocator, .err, span, message);
        return;
    }
    const message = try std.fmt.allocPrint(allocator, "{s}: {s}", .{ fallback_prefix, @errorName(err) });
    defer allocator.free(message);
    try module.diagnostics.add(allocator, .err, span, message);
}

/// Why a statement failed, for the failures whose name alone does not say what
/// to change. `null` keeps the raw name, which is the honest answer when the
/// cause is not known here.
fn statementErrorDetail(err: anyerror) ?[]const u8 {
    return switch (err) {
        error.InvalidExpression => "an expression in this statement is not valid",
        error.InvalidApiCall => "the call syntax is not valid",
        error.InvalidApiArgument => "a call argument does not match what the call expects",
        error.InvalidApiArity => "the call passes the wrong number of arguments",
        error.InvalidValueDeclaration => "the declaration syntax is not valid",
        error.TrailingTextAfterCall => "a line holds one statement: this call is followed by more text, so write the rest on its own line",
        error.DivisionByZero => "the expression divides by zero",
        error.ExpressionNestingTooDeep => "the expression nests deeper than the supported limit; name the inner parts as constants or bind them first",
        error.NestingTooDeep => "the document this statement reads nests deeper than the supported limit",
        error.StatementNestingTooDeep => "the statement nests deeper than the supported limit; a block, loop, function or macro body is only nested so far",
        error.StructNestingTooDeep => "the aggregate literal nests deeper than the supported limit",
        error.MissingStructFieldValue => "the aggregate literal leaves a field out",
        error.UnknownField => "the aggregate literal names a field the type does not declare",
        error.DuplicateFieldName => "the aggregate literal sets the same field twice",
        error.UnknownTypeName => "the type name is not declared",
        error.ExpectedStruct => "this name is not a struct or union type",
        error.UndefinedSymbol => "the name is not defined where it is used",
        error.SideEffectInValueFunction => "a value-returning function cannot emit instructions or change layout; declare it without a return type to run it as a procedure",
        error.MissingMetaReturn => "a value-returning function ended without reaching a return statement",
        error.InvalidMetaFunction => "the function declaration or call is not valid",
        error.IncludeCycle => "the include chain contains a cycle",
        error.UnclosedVirtualOutput => "a virtual output region was opened and never closed",
        error.FileNotAvailable => "the file this statement reads cannot be opened",
        error.IncludeNotAvailable => "the imported or included source file cannot be found",
        error.DuplicateMetaFunction => "a function with this name is already declared",
        error.DuplicateMacro => "a macro with this name is already declared",
        error.DuplicateSymbol => "this name is already declared; a label or binding is defined once",
        error.DuplicateTypeName => "a type with this name is already declared",
        error.MetaCallDepthExceeded => "calls nested past the supported depth; check for recursion between functions and macros",
        error.MetaLoopLimitExceeded => "the loop ran past the supported iteration limit",
        error.UnmatchedVirtualEnd => "virtual.end has no matching virtual.begin",
        error.OutputRegionClosed => "the active region was closed by region.file_align and cannot take more bytes",
        else => null,
    };
}

fn lowerIsaCall(
    module: *module_mod.Module,
    context: *LowerContext,
    active: *ActiveOutput,
    call: ast.ApiCallStatement,
) LowerError!void {
    return isa_lowering.lowerCall(module, context, active, call, isaLoweringCallbacks());
}

fn lowerDataEmitCall(
    module: *module_mod.Module,
    context: *LowerContext,
    active: *ActiveOutput,
    call: ast.ApiCallStatement,
    byte_count: u8,
) LowerError!void {
    return data_emission.lowerEmitCall(module, context, active, call, byte_count, dataEmissionCallbacks());
}

fn lowerFloatEmitCall(
    module: *module_mod.Module,
    context: *LowerContext,
    active: *ActiveOutput,
    call: ast.ApiCallStatement,
    byte_count: u8,
) LowerError!void {
    return data_emission.lowerFloatCall(module, context, active, call, byte_count, dataEmissionCallbacks());
}

fn lowerDataReserveCall(
    module: *module_mod.Module,
    context: *LowerContext,
    active: *ActiveOutput,
    call: ast.ApiCallStatement,
    scale: u64,
) LowerError!void {
    return data_emission.lowerReserveCall(module, context, active, call, scale, dataEmissionCallbacks());
}

fn lowerFileEmitCall(
    module: *module_mod.Module,
    context: *LowerContext,
    active: *ActiveOutput,
    call: ast.ApiCallStatement,
) LowerError!void {
    return data_emission.lowerFileCall(module, context, active, call, dataEmissionCallbacks());
}

fn lowerDiagnosticCall(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    call: ast.ApiCallStatement,
    severity: diagnostic.Severity,
) LowerError!void {
    return diagnostic_lowering.lowerDiagnostic(allocator, module, context, active, call, severity, diagnosticLoweringCallbacks());
}

fn lowerAssertCall(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    call: ast.ApiCallStatement,
) LowerError!void {
    return diagnostic_lowering.lowerAssert(allocator, module, context, active, call, diagnosticLoweringCallbacks());
}

fn lowerMetaFunctionCall(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    context: *LowerContext,
    function_index: usize,
    call: ast.ApiCallStatement,
) LowerError!void {
    return meta_function_runtime.lowerStatementFunction(allocator, module, active, output_stack, context, function_index, call, metaFunctionCallbacks());
}

fn evalUserValueFunction(
    context: *anyopaque,
    allocator: Allocator,
    name: []const u8,
    args: []const expr.BuiltinArgument,
    eval_ctx: *expr.EvalContext,
) expr.ExpressionError!value_mod.Value {
    return evalModuleValueFunction(context, allocator, name, args, eval_ctx);
}

fn evalStructLiteralValue(
    context: *anyopaque,
    allocator: Allocator,
    text: []const u8,
    eval_ctx: *expr.EvalContext,
) expr.ExpressionError!value_mod.Value {
    const lower_context: *LowerContext = @ptrCast(@alignCast(context));
    const active_section = eval_ctx.active_section orelse return error.MissingEvaluationContext;
    const active: ActiveOutput = .{
        .section_id = active_section,
        .offset = eval_ctx.active_offset,
        .file_offset = eval_ctx.active_file_offset orelse eval_ctx.active_offset,
        .target = eval_ctx.module.target,
    };
    var literal = parser.parseStructLiteralText(allocator, text) catch |err| return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        else => error.InvalidApiArgument,
    };
    defer literal.deinit(allocator);
    const struct_value = aggregate_literal.structValueFromLiteral(allocator, eval_ctx.module, lower_context, active, literal, aggregateLiteralCallbacks()) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;
        try addAggregateLiteralDiagnostic(allocator, eval_ctx, err);
        return mapLowerErrorToExpression(err);
    };
    return .{ .@"struct" = struct_value };
}

/// A literal that does not fit its type is reported against the statement that
/// wrote it. The expression layer keeps only the fact that an operand failed, so
/// the reason has to be said here.
fn addAggregateLiteralDiagnostic(
    allocator: Allocator,
    eval_ctx: *expr.EvalContext,
    err: anyerror,
) Allocator.Error!void {
    const span = eval_ctx.current_span orelse return;
    const message = if (aggregate_literal.literalErrorDetail(err)) |detail|
        try std.fmt.allocPrint(allocator, "{s} ({s})", .{ detail, @errorName(err) })
    else
        try std.fmt.allocPrint(allocator, "the aggregate literal is not valid ({s})", .{@errorName(err)});
    defer allocator.free(message);
    try eval_ctx.module.diagnostics.add(allocator, .err, span, message);
}

pub fn evalModuleValueFunction(
    context: *anyopaque,
    allocator: Allocator,
    name: []const u8,
    args: []const expr.BuiltinArgument,
    eval_ctx: *expr.EvalContext,
) expr.ExpressionError!value_mod.Value {
    const lower_context: *LowerContext = @ptrCast(@alignCast(context));
    // Neither a builtin nor a declared value function: the name is simply not
    // declared, which is worth saying instead of reporting a bad operand.
    const function_index = eval_ctx.module.value_functions.lookupIndex(name) orelse return error.UndefinedSymbol;
    const active_section = eval_ctx.active_section orelse return error.MissingEvaluationContext;
    const active: ActiveOutput = .{
        .section_id = active_section,
        .offset = eval_ctx.active_offset,
        .file_offset = eval_ctx.active_file_offset orelse eval_ctx.active_offset,
        .target = eval_ctx.module.target,
    };
    var output_stack: std.ArrayList(ActiveOutput) = .empty;
    defer output_stack.deinit(allocator);
    return meta_function_runtime.evalValueFunctionAt(allocator, eval_ctx.module, lower_context, active, eval_ctx.output_image, &output_stack, function_index, args, eval_ctx.current_span, metaFunctionCallbacks()) catch |err| return mapLowerErrorToExpression(err);
}

pub fn evalModuleOperand(
    context: *anyopaque,
    allocator: Allocator,
    operand: value_mod.OperandValue,
    eval_ctx: *expr.EvalContext,
) expr.ExpressionError!value_mod.Value {
    var operand_ctx = eval_ctx.*;
    // Direct finalizer expressions share the value-function symbol counter.
    operand_ctx.next_unique_symbol = meta_function_runtime.nextUniqueSymbol;
    return macro.evaluateOperand(context, allocator, operand, &operand_ctx);
}

pub fn evalModuleStructLiteralValue(
    context: *anyopaque,
    allocator: Allocator,
    text: []const u8,
    eval_ctx: *expr.EvalContext,
) expr.ExpressionError!value_mod.Value {
    return evalStructLiteralValue(context, allocator, text, eval_ctx);
}

const SourceLoadMode = api_mod.SourceLoadMode;

fn lowerIncludeOrImportCall(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    call: ast.ApiCallStatement,
    context: *LowerContext,
    mode: SourceLoadMode,
) LowerError!void {
    return source_loading.lowerIncludeOrImportCall(allocator, module, active, output_stack, call, context, mode, sourceLoadingCallbacks());
}

fn requireArgCount(call: ast.ApiCallStatement, expected: usize) LowerError!void {
    if (call.args.len != expected) return error.InvalidApiArity;
}

fn integerArgAtContext(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    call: ast.ApiCallStatement,
    index: usize,
) LowerError!u64 {
    return arguments.integerAtContext(module, context, active, call, index, argumentCallbacks());
}

fn valueArgAtContext(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    call: ast.ApiCallStatement,
    index: usize,
) LowerError!value_mod.Value {
    return arguments.valueAtContext(allocator, module, context, active, call, index, argumentCallbacks());
}

fn booleanArgAtContext(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    call: ast.ApiCallStatement,
    index: usize,
) LowerError!bool {
    return arguments.booleanAtContext(module, context, active, call, index, argumentCallbacks());
}

fn sourcePathArgAtContext(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    call: ast.ApiCallStatement,
    index: usize,
) LowerError![]u8 {
    return arguments.sourcePathAtContext(allocator, module, context, active, call, index, argumentCallbacks());
}

fn outputStoreTargetAtContext(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    call: ast.ApiCallStatement,
    index: usize,
) LowerError!OutputStoreTarget {
    return output_target.resolveAtContext(module, context, active, call, index, outputTargetCallbacks());
}

fn emitStructValue(
    module: *module_mod.Module,
    struct_value: value_mod.StructValue,
) LowerError![]u8 {
    return data_emission.packStructValue(module, struct_value);
}

fn evalMetaCondition(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    condition: []const u8,
) LowerError!bool {
    return meta_condition.evaluate(module, context, active, condition, metaConditionCallbacks());
}

fn evalBooleanAtContext(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    node: *const expr.Node,
) LowerError!bool {
    try materializeInstructionBytesForExpression(module, node);
    return expression_bridge.evalBooleanAtContext(
        module,
        context,
        activeExpressionContext(context, active),
        expressionCallbacks(),
        node,
    );
}

fn evalIntegerAtContext(
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    node: *const expr.Node,
) LowerError!u64 {
    var synchronized = active;
    try expression_materialization.syncForExpression(module, &synchronized, node);
    try materializeInstructionBytesForExpression(module, node);
    return expression_bridge.evalIntegerAtContext(
        module,
        context,
        activeExpressionContext(context, synchronized),
        expressionCallbacks(),
        node,
    );
}

fn evalValueAtContext(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    node: *const expr.Node,
) LowerError!value_mod.Value {
    var synchronized = active;
    try expression_materialization.syncForExpression(module, &synchronized, node);
    try materializeInstructionBytesForExpression(module, node);
    return expression_bridge.evalValueAtContext(
        allocator,
        module,
        context,
        activeExpressionContext(context, synchronized),
        expressionCallbacks(),
        node,
    );
}

fn activeExpressionContext(context: *LowerContext, active: ActiveOutput) ActiveExpressionContext {
    return .{
        .target = active.target,
        .section_id = active.section_id,
        .offset = active.offset,
        .file_offset = active.file_offset,
        .output_image = context.output_image,
    };
}

fn expressionCallbacks() expression_bridge.Callbacks {
    return .{
        .next_unique_symbol = meta_function_runtime.nextUniqueSymbol,
        .call_user_function = evalUserValueFunction,
        .evaluate_struct_literal = evalStructLiteralValue,
    };
}

fn metaFunctionCallbacks() meta_function_runtime.Callbacks {
    return .{
        .lower_statement_slice = lowerStatementSlice,
        .value_arg_at_context = valueArgAtContext,
        .call_user_function = evalUserValueFunction,
        .evaluate_struct_literal = evalStructLiteralValue,
    };
}

fn aggregateLiteralCallbacks() aggregate_literal.Callbacks {
    return .{
        .eval_integer_at_context = evalIntegerAtContext,
        .eval_value_at_context = evalValueAtContext,
    };
}

fn argumentCallbacks() arguments.Callbacks {
    return .{
        .eval_integer_at_context = evalIntegerAtContext,
        .eval_value_at_context = evalValueAtContext,
    };
}

fn outputTargetCallbacks() output_target.Callbacks {
    return .{
        .eval_integer_at_context = evalIntegerAtContext,
    };
}

fn dataEmissionCallbacks() data_emission.Callbacks {
    return .{
        .value_arg_at_context = valueArgAtContext,
        .integer_arg_at_context = integerArgAtContext,
        .file_resolver = expression_bridge.fileResolver,
        .advance_active_output = advanceActiveOutput,
    };
}

fn typeDeclarationCallbacks() type_declaration.Callbacks {
    return .{
        .eval_integer_at_context = evalIntegerAtContext,
        .eval_value_at_context = evalValueAtContext,
    };
}

fn valueBindingCallbacks() value_binding.Callbacks {
    return .{
        .eval_integer_at_context = evalIntegerAtContext,
        .eval_value_at_context = evalValueAtContext,
    };
}

fn collectionMutationCallbacks() collection_mutation.Callbacks {
    return .{
        .value_arg_at_context = valueArgAtContext,
    };
}

fn sourceLoadingCallbacks() source_loading.Callbacks {
    return .{
        .lower_statements_into_context = lowerStatementsIntoModuleContext,
        .add_lower_error_diagnostic = addLowerErrorDiagnostic,
        .add_parse_error_diagnostic = addParseErrorDiagnostic,
        .source_path_arg_at_context = sourcePathArgAtContext,
        .section_cursor = sectionCursor,
        .require_arg_count = requireArgCount,
    };
}

fn diagnosticLoweringCallbacks() diagnostic_lowering.Callbacks {
    return .{
        .boolean_arg_at_context = booleanArgAtContext,
        .eval_value_at_context = evalValueAtContext,
    };
}

fn isaLoweringCallbacks() isa_lowering.Callbacks {
    return .{
        .value_arg_at_context = valueArgAtContext,
        .eval_integer_at_context = evalIntegerAtContext,
        .advance_active_output = advanceActiveOutput,
        .require_open_output_region = requireOpenOutputRegion,
        .require_arg_count = requireArgCount,
    };
}

fn metaConditionCallbacks() meta_condition.Callbacks {
    return .{
        .eval_boolean_at_context = evalBooleanAtContext,
        .eval_integer_at_context = evalIntegerAtContext,
    };
}

fn metaControlFlowCallbacks() meta_control_flow.Callbacks {
    return .{
        .eval_condition = evalMetaCondition,
        .eval_integer_at_context = evalIntegerAtContext,
        .eval_value_at_context = evalValueAtContext,
        .lower_statement_slice = lowerStatementSlice,
        .lower_scoped_statement_slice = lowerScopedStatementSlice,
    };
}

fn apiCallbacks() api_mod.Callbacks {
    return .{
        .lower_include_or_import = lowerIncludeOrImportCall,
        .lower_meta_function = lowerMetaFunctionCall,
        .lower_diagnostic = lowerDiagnosticCall,
        .lower_assert = lowerAssertCall,
        .lower_isa = lowerIsaCall,
        .lower_data_emit = lowerDataEmitCall,
        .lower_float_emit = lowerFloatEmitCall,
        .lower_data_reserve = lowerDataReserveCall,
        .lower_file_emit = lowerFileEmitCall,
        .value_arg_at_context = valueArgAtContext,
        .integer_arg_at_context = integerArgAtContext,
        .source_path_arg_at_context = sourcePathArgAtContext,
        .output_store_target_at_context = outputStoreTargetAtContext,
        .emit_struct_value = emitStructValue,
        .materialize_instruction_bytes_for_output_access = materializeInstructionBytesForOutputAccess,
        .sync_active_output_offset_for_layout_api = syncActiveOutputOffsetForLayoutApi,
        .active_address = activeAddress,
        .require_open_output_region = requireOpenOutputRegion,
        .require_arg_count = requireArgCount,
        .active_fragment_position = activeFragmentPosition,
        .advance_active_output = advanceActiveOutput,
        .discard_last_active_output = discardLastActiveOutput,
    };
}

fn lateLayoutRuntimeCallbacks() late_layout_mod.RuntimeCallbacks {
    return .{
        .section_cursor = sectionCursor,
        .section_file_cursor = sectionFileCursor,
        .run_api_call = runLateLayoutApiCall,
        .eval_condition = evalLateLayoutCondition,
    };
}

fn lateLayoutBuildCallbacks() late_layout_mod.BuildCallbacks {
    return .{
        .is_allowed_api = api_mod.isAllowedLateLayoutApi,
        .eval_condition = evalLateLayoutCondition,
    };
}

fn deferredCallbacks() deferred.Callbacks {
    return .{
        .is_allowed_api = isAllowedDeferredApi,
    };
}

fn isAllowedDeferredApi(callee: []const u8) bool {
    return std.mem.eql(u8, callee, "print") or
        std.mem.eql(u8, callee, "warn") or
        std.mem.eql(u8, callee, "err") or
        std.mem.eql(u8, callee, "assert") or
        std.mem.eql(u8, callee, "store.bytes") or
        api_mod.storeByteCount(callee) != null;
}

/// A parser error keeps its own identity wherever lowering has the same
/// condition: a reader who sees "InvalidValueDeclaration" or "LegacyDirectiveSyntax"
/// learns something, while a flattened "InvalidApiCall" does not.
fn mapParseError(err: parser.ParseError) LowerError {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        error.SourceTooLarge => error.SourceTooLarge,
        error.InvalidLabel => error.InvalidLabel,
        error.InvalidApiCall => error.InvalidApiCall,
        error.InvalidApiArgument => error.InvalidApiArgument,
        error.InvalidExpression => error.InvalidExpression,
        error.InvalidValueDeclaration => error.InvalidValueDeclaration,
        error.InvalidStructDeclaration => error.InvalidStructDeclaration,
        error.InvalidStructField => error.InvalidStructField,
        error.StatementNestingTooDeep => error.StatementNestingTooDeep,
        error.StructNestingTooDeep => error.StructNestingTooDeep,
        error.ExpressionNestingTooDeep => error.ExpressionNestingTooDeep,
        error.NestingTooDeep => error.NestingTooDeep,
        error.UnionFieldDefaultNotAllowed => error.UnionFieldDefaultNotAllowed,
        error.InvalidMetaBlock => error.InvalidMetaBlock,
        error.InvalidMetaStatement => error.InvalidMetaStatement,
        error.InvalidMetaDefer => error.InvalidMetaDefer,
        error.InvalidLateLayout => error.InvalidLateLayout,
        error.InvalidMetaFor => error.InvalidMetaFor,
        error.InvalidMetaFunction => error.InvalidMetaFunction,
        error.InvalidMacro => error.InvalidMacro,
        error.InvalidMetaIf => error.InvalidMetaIf,
        error.InvalidMetaWhile => error.InvalidMetaWhile,
        error.UnexpectedEndOfMetaBlock => error.UnexpectedEndOfMetaBlock,
        error.UnexpectedEndOfMetaDefer => error.UnexpectedEndOfMetaDefer,
        error.UnexpectedEndOfLateLayout => error.UnexpectedEndOfLateLayout,
        error.UnexpectedEndOfMetaFor => error.UnexpectedEndOfMetaFor,
        error.UnexpectedEndOfMetaFunction => error.UnexpectedEndOfMetaFunction,
        error.UnexpectedEndOfStruct => error.UnexpectedEndOfStruct,
        error.UnexpectedEndOfMetaIf => error.UnexpectedEndOfMetaIf,
        error.UnexpectedEndOfMetaWhile => error.UnexpectedEndOfMetaWhile,
        error.TooManyStatements => error.TooManyStatements,
        error.UnexpectedEndOfStatement => error.UnexpectedEndOfStatement,
        error.TrailingTextAfterCall => error.TrailingTextAfterCall,
        error.LegacyDirectiveSyntax => error.LegacyDirectiveSyntax,
    };
}

test "lowering evaluates inline aggregate builtin results with caller allocator" {
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();
    const u16_type = try module.getOrAddIntType("u16", 16, .unsigned);
    const u32_type = try module.getOrAddIntType("u32", 32, .unsigned);
    const header = try module.addStructType("Header", &.{
        .{ .name = "magic", .ty = u16_type },
        .{ .name = "lfanew", .ty = u32_type },
    }, .@"packed");
    try module.registerTypeName("Header", header);

    var context: LowerContext = .{};
    defer context.deinit(std.testing.allocator);
    const active: ActiveOutput = .{
        .section_id = module.default_section,
        .offset = 0,
        .file_offset = 0,
        .target = module.target,
    };

    var expression = try expr.parseOwned(std.testing.allocator, "pack(Header { magic: 0x5a4d, lfanew: 0x80 })");
    defer expression.deinit(std.testing.allocator);

    var buffer: [4096]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&buffer);
    const value_allocator = fixed.allocator();
    var value = try evalValueAtContext(value_allocator, &module, &context, active, &expression);
    defer value.deinit(value_allocator);

    switch (value) {
        .bytes => |packed_bytes| {
            try std.testing.expectEqualSlices(u8, &.{ 0x4d, 0x5a, 0x80, 0x00, 0x00, 0x00 }, packed_bytes);
            try std.testing.expect(fixed.ownsSlice(packed_bytes));
        },
        else => return error.InvalidApiArgument,
    }
}

test {
    _ = @import("tests.zig");
}

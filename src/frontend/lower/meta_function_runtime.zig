const std = @import("std");

const ast = @import("../ast.zig");
const expr = @import("../expr.zig");
const module_mod = @import("../module.zig");
const output_mod = @import("../output/root.zig");
const typecheck = @import("../typecheck.zig");
const value_mod = @import("../value.zig");
const contracts = @import("contracts.zig");
const context_mod = @import("context.zig");
const expression_bridge = @import("expression_bridge.zig");

const Allocator = std.mem.Allocator;
const ActiveOutput = contracts.ActiveOutput;
const LowerContext = context_mod.LowerContext;
const LowerError = contracts.LowerError;

const max_call_depth = @import("../macro.zig").max_call_depth;

pub const Callbacks = struct {
    lower_statement_slice: *const fn (Allocator, *module_mod.Module, *ActiveOutput, *std.ArrayList(ActiveOutput), []const ast.Statement, *LowerContext) LowerError!void,
    value_arg_at_context: *const fn (Allocator, *module_mod.Module, *LowerContext, ActiveOutput, ast.ApiCallStatement, usize) LowerError!value_mod.Value,
    call_user_function: *const fn (*anyopaque, Allocator, []const u8, []const expr.BuiltinArgument, *expr.EvalContext) expr.ExpressionError!value_mod.Value,
    evaluate_struct_literal: *const fn (*anyopaque, Allocator, []const u8, *expr.EvalContext) expr.ExpressionError!value_mod.Value,
};

pub fn lowerStatementFunction(
    allocator: Allocator,
    module: *module_mod.Module,
    active: *ActiveOutput,
    output_stack: *std.ArrayList(ActiveOutput),
    context: *LowerContext,
    function_index: usize,
    call: ast.ApiCallStatement,
    callbacks: Callbacks,
) LowerError!void {
    const function = try context.functions.get(function_index);
    if (function.return_type_name != null) return error.InvalidMetaFunction;
    if (call.args.len != function.params.len) return error.InvalidApiArity;
    if (context.call_depth >= max_call_depth) return error.MetaCallDepthExceeded;

    context.call_depth += 1;
    defer context.call_depth -= 1;
    const caller_in_meta_loop = context.in_meta_loop;
    context.in_meta_loop = false;
    defer context.in_meta_loop = caller_in_meta_loop;

    try validateMutableArguments(module, context, call, function.params);

    // Keep all arguments in the caller's environment until evaluation finishes.
    const values = try allocator.alloc(value_mod.Value, function.params.len);
    var initialized: usize = 0;
    defer {
        for (values[0..initialized]) |*value| value.deinit(allocator);
        allocator.free(values);
    }
    for (function.params, 0..) |param, index| {
        const annotation = try typecheck.annotationFromName(module, param.type_name);
        if (param.type_name != null and annotation == null) return error.InvalidMetaFunction;
        var value = try callbacks.value_arg_at_context(allocator, module, context, active.*, call, index);
        errdefer value.deinit(allocator);
        try typecheck.coerceValueToAnnotation(module, &value, annotation);
        values[index] = value;
        initialized += 1;
    }

    try context.scopes.append(allocator, .{});
    defer context_mod.discardLastScope(context, allocator);
    for (function.params, 0..) |param, index| {
        try context_mod.defineLocalValue(context, allocator, param.name, values[index], param.mutability);
        values[index] = .void;
    }

    // Diagnostics raised while the body runs belong to the body, but the reader
    // wrote the call: record the invocation so the message carries both, which
    // matters when the body lives in a library include.
    const previous_expansion = module.diagnostics.active_expansion;
    module.diagnostics.active_expansion = try module.diagnostics.beginExpansion(allocator, call.span, function.span, .function);
    defer module.diagnostics.active_expansion = previous_expansion;

    try callbacks.lower_statement_slice(allocator, module, active, output_stack, function.body, context);
    try writeBackMutableArguments(allocator, module, context, call, function.params);
}

fn validateMutableArguments(
    module: *module_mod.Module,
    context: *LowerContext,
    call: ast.ApiCallStatement,
    params: []const ast.MetaFunctionParam,
) LowerError!void {
    for (params, 0..) |param, index| {
        if (param.mutability != .let) continue;
        const name = directSymbolArgument(call, index) orelse
            return fail(module, call, "mutable function argument must be a direct let binding");

        for (params[0..index], 0..) |previous, previous_index| {
            if (previous.mutability != .let) continue;
            const previous_name = directSymbolArgument(call, previous_index) orelse continue;
            if (std.mem.eql(u8, previous_name, name)) {
                return fail(module, call, "mutable function arguments cannot alias the same binding");
            }
        }

        switch (context_mod.lookupMutableLocalValue(context, name)) {
            .value => {},
            .immutable => return fail(module, call, "mutable function argument must resolve to a let binding"),
            .missing => if (context.value_function_depth != 0)
                return fail(module, call, "mutable function argument must resolve to a local let binding")
            else switch (module.symbols.lookupMutableValue(name)) {
                .value => {},
                .immutable => return fail(module, call, "mutable function argument must resolve to a let binding"),
                .missing => return fail(module, call, "mutable function argument must resolve to a let binding"),
            },
        }
    }
}

fn writeBackMutableArguments(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    call: ast.ApiCallStatement,
    params: []const ast.MetaFunctionParam,
) LowerError!void {
    for (params, 0..) |param, index| {
        if (param.mutability != .let) continue;
        const name = directSymbolArgument(call, index) orelse return error.InvalidMetaFunction;
        const local = context_mod.lookupLocalValue(context, param.name) orelse return error.InvalidMetaFunction;
        var updated = try local.clone(allocator);
        errdefer updated.deinit(allocator);
        if (try context_mod.setCallerLocalValue(context, allocator, name, updated)) continue;
        try module.setValue(name, updated);
    }
}

fn directSymbolArgument(call: ast.ApiCallStatement, index: usize) ?[]const u8 {
    if (index >= call.args.len) return null;
    return switch (call.args[index]) {
        .expression => |node| switch (node) {
            .symbol => |name| name,
            else => null,
        },
        .string, .struct_literal => null,
    };
}

fn fail(module: *module_mod.Module, call: ast.ApiCallStatement, message: []const u8) LowerError {
    module.diagnostics.add(module.allocator, .err, call.span, message) catch return error.OutOfMemory;
    return error.FrontendDiagnostics;
}

pub fn evalValueFunctionAt(
    allocator: Allocator,
    module: *module_mod.Module,
    context: *LowerContext,
    active: ActiveOutput,
    output_image: ?output_mod.Image,
    output_stack: *std.ArrayList(ActiveOutput),
    function_index: usize,
    args: []const expr.BuiltinArgument,
    call_span: ?@import("../source.zig").SourceSpan,
    callbacks: Callbacks,
) LowerError!value_mod.Value {
    const function = try module.value_functions.get(function_index);
    const return_type_name = function.return_type_name orelse return error.InvalidMetaFunction;
    if (args.len != function.params.len) {
        // The expression layer collapses every lowering error into one operand
        // error on the way back, so the counts have to be said here or not at all.
        if (call_span) |span| {
            const message = try std.fmt.allocPrint(
                module.allocator,
                "function {s} declares {d} {s}, but this call passes {d}",
                .{
                    function.name,
                    function.params.len,
                    if (function.params.len == 1) "parameter" else "parameters",
                    args.len,
                },
            );
            defer module.allocator.free(message);
            try module.diagnostics.add(module.allocator, .err, span, message);
            return error.FrontendDiagnostics;
        }
        return error.InvalidApiArity;
    }
    if (context.call_depth >= max_call_depth) return error.MetaCallDepthExceeded;

    context.call_depth += 1;
    defer context.call_depth -= 1;
    context.value_function_depth += 1;
    defer context.value_function_depth -= 1;
    const caller_in_meta_loop = context.in_meta_loop;
    context.in_meta_loop = false;
    defer context.in_meta_loop = caller_in_meta_loop;

    // A failure inside the body belongs to the body, but the reader wrote the
    // call: record the invocation so the diagnostic chain names both.
    const previous_expansion = module.diagnostics.active_expansion;
    if (call_span) |span| {
        module.diagnostics.active_expansion = try module.diagnostics.beginExpansion(allocator, span, function.span, .function);
    }
    defer module.diagnostics.active_expansion = previous_expansion;

    const previous_return = context.return_value;
    const previous_return_span = context.return_span;
    context.return_value = null;
    context.return_span = null;
    defer {
        if (context.return_value) |*stored| {
            stored.deinit(allocator);
        }
        context.return_value = previous_return;
        context.return_span = previous_return_span;
    }

    var scoped_active = active;
    var eval_ctx: expr.EvalContext = .{
        .module = module,
        .active_target = active.target,
        .active_section = active.section_id,
        .active_offset = active.offset,
        .active_file_offset = active.file_offset,
        .output_image = output_image,
        .file_resolver = expression_bridge.fileResolver(context),
        .source_path = context_mod.currentSourcePath(context),
        .local_context = context,
        .resolve_local = context_mod.resolveLocalValue,
        .lookup_local = context_mod.lookupLocalValueAlias,
        .next_unique_symbol = nextUniqueSymbol,
        .call_user_function = callbacks.call_user_function,
        .evaluate_struct_literal = callbacks.evaluate_struct_literal,
        .eval_operand = @import("../macro.zig").evaluateOperand,
    };
    const previous_output_image = context.output_image;
    context.output_image = output_image;
    defer context.output_image = previous_output_image;
    const values = try allocator.alloc(value_mod.Value, function.params.len);
    var initialized: usize = 0;
    defer {
        for (values[0..initialized]) |*value| value.deinit(allocator);
        allocator.free(values);
    }
    for (function.params, 0..) |param, index| {
        const annotation = try typecheck.annotationFromName(module, param.type_name);
        if (param.type_name != null and annotation == null) return error.InvalidMetaFunction;
        var value = expr.evaluateBuiltinValueArg(allocator, args[index], &eval_ctx) catch |err| return expression_bridge.mapExpressionError(err);
        errdefer value.deinit(allocator);
        typecheck.coerceValueToAnnotation(module, &value, annotation) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;
            // The coercion reports one declaration error for every mismatch and the
            // expression layer keeps only "an operand failed", so the two types and
            // the position are said here or nowhere.
            if (call_span) |span| {
                const message = try std.fmt.allocPrint(
                    module.allocator,
                    "argument {d} of function {s} has type {s}, but parameter {s} declares {s}",
                    .{
                        index + 1,
                        function.name,
                        value_mod.valueTypeName(value.valueType()),
                        param.name,
                        param.type_name orelse "a type",
                    },
                );
                defer module.allocator.free(message);
                try module.diagnostics.add(module.allocator, .err, span, message);
                return error.FrontendDiagnostics;
            }
            return err;
        };
        values[index] = value;
        initialized += 1;
    }

    const previous_scope_start = context.value_function_scope_start;
    context.value_function_scope_start = context.scopes.items.len;
    defer context.value_function_scope_start = previous_scope_start;
    try context.scopes.append(allocator, .{});
    defer context_mod.discardLastScope(context, allocator);
    for (function.params, 0..) |param, index| {
        try context_mod.defineLocalValue(context, allocator, param.name, values[index], .@"const");
        values[index] = .void;
    }

    // A value function is reached through expression evaluation, which carries no
    // call-site span yet, so the invocation note is recorded for statement
    // functions only; see the backlog entry for the expression-side gap.
    callbacks.lower_statement_slice(allocator, module, &scoped_active, output_stack, function.body, context) catch |err| {
        if (err != error.MetaFunctionReturned) return err;
    };
    var result = context.return_value orelse return failMissingReturn(module, function);
    context.return_value = null;
    errdefer result.deinit(allocator);

    const annotation = (try typecheck.annotationFromName(module, return_type_name)) orelse return error.InvalidMetaFunction;
    typecheck.coerceValueToAnnotation(module, &result, annotation) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;
        return failReturnType(module, context, function, return_type_name, result.valueType());
    };
    return result;
}

/// A body runs when it is called, so an error it raises would otherwise be
/// blamed on the call site; the message would also have lost the function name
/// and the reason, because the expression layer collapses every lowering error
/// into one operand error. Rejecting the value here keeps both.
fn failReturnType(
    module: *module_mod.Module,
    context: *const LowerContext,
    function: *const ast.MetaFunctionStatement,
    return_type_name: []const u8,
    produced: value_mod.ValueType,
) LowerError {
    const message = std.fmt.allocPrint(
        module.allocator,
        "function {s} declares a {s} return value, but this return statement produces a {s}",
        .{ function.name, return_type_name, value_mod.valueTypeName(produced) },
    ) catch return error.OutOfMemory;
    defer module.allocator.free(message);
    const span = context.return_span orelse function.span;
    module.diagnostics.add(module.allocator, .err, span, message) catch return error.OutOfMemory;
    return error.FrontendDiagnostics;
}

fn failMissingReturn(module: *module_mod.Module, function: *const ast.MetaFunctionStatement) LowerError {
    const message = std.fmt.allocPrint(
        module.allocator,
        "function {s} declares a return value, but its body ended without a return statement",
        .{function.name},
    ) catch return error.OutOfMemory;
    defer module.allocator.free(message);
    module.diagnostics.add(module.allocator, .err, function.span, message) catch return error.OutOfMemory;
    return error.FrontendDiagnostics;
}

pub fn nextUniqueSymbol(context: *anyopaque, allocator: Allocator, prefix: []const u8) expr.ExpressionError![]u8 {
    const lower_context: *LowerContext = @ptrCast(@alignCast(context));
    const index = lower_context.unique_symbol_counter;
    lower_context.unique_symbol_counter = std.math.add(u64, lower_context.unique_symbol_counter, 1) catch return error.InvalidNumber;
    return std.fmt.allocPrint(allocator, "{s}__{}", .{ prefix, index });
}

const std = @import("std");

const expr = @import("../expr.zig");
const meta_function = @import("../meta_function.zig");
const macro = @import("../macro.zig");
const module_mod = @import("../module.zig");
const output_mod = @import("../output/root.zig");
const source = @import("../source.zig");
const target_mod = @import("../target.zig");
const value_mod = @import("../value.zig");
const contracts = @import("contracts.zig");

const Allocator = std.mem.Allocator;

pub const LowerContext = struct {
    include_resolver: ?contracts.IncludeResolver = null,
    output_image: ?output_mod.Image = null,
    defer_here: ?u64 = null,
    deferred_captures: ?*value_mod.MapValue = null,
    source_stack: std.ArrayList(SourceFrame) = .empty,
    functions: meta_function.Store = .{},
    macros: macro.Store = .{},
    macro_expansions: usize = 0,
    frozen_local_names: std.ArrayList([]const u8) = .empty,
    scopes: std.ArrayList(MetaScope) = .empty,
    call_depth: u32 = 0,
    value_function_depth: u32 = 0,
    in_meta_loop: bool = false,
    return_value: ?value_mod.Value = null,
    /// Span of the `return` statement that produced `return_value`. The value
    /// outlives the statement, so a diagnostic raised while checking the
    /// declared return type would otherwise have no line to point at and would
    /// be blamed on the call site instead.
    return_span: ?source.SourceSpan = null,
    /// The statement whose lowering is in progress. Expression evaluation happens
    /// while a statement is being lowered, so this is the call site a nested
    /// value function reports, and the line a reader can act on.
    statement_span: ?source.SourceSpan = null,
    unique_symbol_counter: u64 = 0,
    /// The module-level binding snapshot the next capture may reuse, with the
    /// module generation it was built from. It is reused while that generation
    /// is unchanged, which is what keeps successive macro captures in one loop
    /// body from each copying every generated table.
    cached_module_snapshot: ?*value_mod.BindingSnapshot = null,
    cached_module_generation: u64 = 0,
    /// Parsed conditions, keyed by a copy of the condition text.
    ///
    /// A condition is evaluated on every execution of its statement, and parsing
    /// it again each time costs several times what walking the parsed tree does,
    /// so each distinct text is parsed once and the tree is reused.
    ///
    /// Keys and trees are both owned here. `StringHashMapUnmanaged` does not own
    /// its keys, so the text is copied in instead of borrowed, which leaves a
    /// caller free to pass a slice that does not outlive this cache. The tree is
    /// context-independent: `parseOwned` resolves no symbols, so it is safe to
    /// evaluate one tree under different scopes.
    ///
    /// Each tree is a separate allocation rather than a map value on purpose:
    /// evaluating a condition can insert another one, which may rehash this map
    /// and move its entries. A caller holding a pointer into the map would then
    /// be reading freed storage, so the map stores stable pointers and a lookup
    /// copies the pointer out before evaluating.
    condition_cache: std.StringHashMapUnmanaged(*expr.Node) = .empty,

    pub fn deinit(self: *LowerContext, allocator: Allocator) void {
        if (self.return_value) |*stored| {
            stored.deinit(allocator);
        }
        if (self.cached_module_snapshot) |snapshot| {
            snapshot.release(allocator);
        }
        for (self.scopes.items) |*scope| {
            scope.deinit(allocator);
        }
        self.scopes.deinit(allocator);
        self.functions.deinit(allocator);
        self.macros.deinit(allocator);
        self.frozen_local_names.deinit(allocator);
        self.source_stack.deinit(allocator);
        var condition_iterator = self.condition_cache.iterator();
        while (condition_iterator.next()) |entry| {
            allocator.free(entry.key_ptr.*);
            entry.value_ptr.*.deinit(allocator);
            allocator.destroy(entry.value_ptr.*);
        }
        self.condition_cache.deinit(allocator);
        self.* = undefined;
    }
};

const SourceFrame = struct {
    path: []const u8,
    identity: []const u8,
};

const MetaLocal = struct {
    name: []const u8,
    value: value_mod.Value,
    mutability: value_mod.Mutability,
    /// True when `value` is a shallow view whose storage belongs to someone else
    /// — a capture snapshot, or an alias map owned by the caller — and therefore
    /// must not be released here.
    ///
    /// A borrowed local is only ever read. Nothing can write through it:
    /// `setLocalValue` and `setCallerLocalValue` refuse anything that is not
    /// `.let`, and `collection_mutation` requires a direct `let` binding, so the
    /// owner's storage stays exactly as its owner left it.
    borrowed: bool = false,

    fn deinit(self: *MetaLocal, allocator: Allocator) void {
        if (!self.borrowed) self.value.deinit(allocator);
        self.* = undefined;
    }
};

const MetaScope = struct {
    locals: std.ArrayList(MetaLocal) = .empty,

    fn deinit(self: *MetaScope, allocator: Allocator) void {
        for (self.locals.items) |*local| {
            local.deinit(allocator);
        }
        self.locals.deinit(allocator);
        self.* = undefined;
    }
};

const LocalPosition = struct {
    scope_index: usize,
    local_index: usize,
};

pub fn discardLastScope(context: *LowerContext, allocator: Allocator) void {
    if (context.scopes.items.len == 0) return;
    const last_index = context.scopes.items.len - 1;
    var scope = context.scopes.items[last_index];
    context.scopes.shrinkRetainingCapacity(last_index);
    scope.deinit(allocator);
}

pub fn pushMetaScope(context: *LowerContext, allocator: Allocator) Allocator.Error!void {
    try context.scopes.append(allocator, .{});
}

pub fn popMetaScope(context: *LowerContext, allocator: Allocator) void {
    discardLastScope(context, allocator);
}

pub fn defineFinalLocalValue(
    context: *LowerContext,
    allocator: Allocator,
    name: []const u8,
    value: value_mod.Value,
    mutability: value_mod.Mutability,
) contracts.LowerError!void {
    try defineLocalValue(context, allocator, name, value, mutability);
}

pub fn setFinalLocalValue(
    context: *LowerContext,
    allocator: Allocator,
    name: []const u8,
    value: value_mod.Value,
) contracts.LowerError!bool {
    return setLocalValue(context, allocator, name, value);
}

pub fn defineLocalValue(
    context: *LowerContext,
    allocator: Allocator,
    name: []const u8,
    value: value_mod.Value,
    mutability: value_mod.Mutability,
) contracts.LowerError!void {
    try appendLocal(context, allocator, name, value, mutability, false);
}

/// Defines a local that *borrows* `value`'s storage instead of owning a copy.
///
/// The caller guarantees the storage outlives this local: a capture snapshot is
/// refcounted and held by the capture, and an alias map lives in the caller's
/// frame. Only a shallow copy of the value is stored, so freeing the local is a
/// no-op and the owner keeps its storage.
///
/// Nothing may write through the local, which is what makes the borrow safe — a
/// write would be visible to the owner. `mutability` therefore has to be
/// `.@"const"`: every mutation path (`setLocalValue`, `setCallerLocalValue`,
/// `collection_mutation`) rejects a binding that is not `.let`.
pub fn defineBorrowedLocalValue(
    context: *LowerContext,
    allocator: Allocator,
    name: []const u8,
    value: value_mod.Value,
    mutability: value_mod.Mutability,
) contracts.LowerError!void {
    if (mutability != .@"const") return error.InvalidValueDeclaration;
    try appendLocal(context, allocator, name, value, mutability, true);
}

fn appendLocal(
    context: *LowerContext,
    allocator: Allocator,
    name: []const u8,
    value: value_mod.Value,
    mutability: value_mod.Mutability,
    borrowed: bool,
) contracts.LowerError!void {
    if (context.scopes.items.len == 0) return error.InvalidMetaBlock;
    var scope = &context.scopes.items[context.scopes.items.len - 1];
    for (scope.locals.items) |local| {
        if (std.mem.eql(u8, local.name, name)) return error.DuplicateSymbol;
    }
    try scope.locals.append(allocator, .{
        .name = name,
        .value = value,
        .mutability = mutability,
        .borrowed = borrowed,
    });
}

pub fn setLocalValue(
    context: *LowerContext,
    allocator: Allocator,
    name: []const u8,
    new_value: value_mod.Value,
) contracts.LowerError!bool {
    const position = findLocalPosition(context, name) orelse return false;
    const local = &context.scopes.items[position.scope_index].locals.items[position.local_index];
    if (local.mutability != .let) return error.InvalidValueDeclaration;
    local.value.deinit(allocator);
    local.value = new_value;
    return true;
}

pub fn setCallerLocalValue(
    context: *LowerContext,
    allocator: Allocator,
    name: []const u8,
    new_value: value_mod.Value,
) contracts.LowerError!bool {
    if (context.scopes.items.len <= 1) return false;
    const position = findCallerLocalPosition(context, name) orelse return false;
    const local = &context.scopes.items[position.scope_index].locals.items[position.local_index];
    if (local.mutability != .let) return error.InvalidValueDeclaration;
    local.value.deinit(allocator);
    local.value = new_value;
    return true;
}

pub fn lookupLocalValue(context: *const LowerContext, name: []const u8) ?*const value_mod.Value {
    const position = findLocalPosition(context, name) orelse return null;
    return &context.scopes.items[position.scope_index].locals.items[position.local_index].value;
}

pub fn lookupMutableLocalValue(context: *LowerContext, name: []const u8) value_mod.MutableValueLookup {
    const position = findLocalPosition(context, name) orelse return .missing;
    const local = &context.scopes.items[position.scope_index].locals.items[position.local_index];
    if (local.mutability != .let) return .immutable;
    return .{ .value = &local.value };
}

fn findLocalPosition(context: *const LowerContext, name: []const u8) ?LocalPosition {
    var scope_index = context.scopes.items.len;
    while (scope_index != 0) {
        scope_index -= 1;
        const scope = &context.scopes.items[scope_index];
        var local_index = scope.locals.items.len;
        while (local_index != 0) {
            local_index -= 1;
            if (std.mem.eql(u8, scope.locals.items[local_index].name, name)) {
                return .{
                    .scope_index = scope_index,
                    .local_index = local_index,
                };
            }
        }
    }
    return null;
}

fn findCallerLocalPosition(context: *const LowerContext, name: []const u8) ?LocalPosition {
    var scope_index = context.scopes.items.len - 1;
    while (scope_index != 0) {
        scope_index -= 1;
        const scope = &context.scopes.items[scope_index];
        var local_index = scope.locals.items.len;
        while (local_index != 0) {
            local_index -= 1;
            if (std.mem.eql(u8, scope.locals.items[local_index].name, name)) {
                return .{
                    .scope_index = scope_index,
                    .local_index = local_index,
                };
            }
        }
    }
    return null;
}

pub fn resolveLocalValue(context: *anyopaque, allocator: Allocator, name: []const u8) expr.ExpressionError!?value_mod.Value {
    const lower_context: *LowerContext = @ptrCast(@alignCast(context));
    const local = lookupLocalValue(lower_context, name) orelse return null;
    return try local.clone(allocator);
}

/// The borrowing form of `resolveLocalValue`: it hands back the local's own
/// storage instead of a deep copy, so a read-only builtin can name a large map
/// or list without paying for a copy proportional to its size.
///
/// Pair it with `resolveLocalValue` and only where that one is already wired:
/// an evaluator that has the copying callback but not this one cannot tell
/// whether a local would have won a name, and must not borrow at all.
pub fn lookupLocalValueAlias(context: *anyopaque, name: []const u8) ?*const value_mod.Value {
    const lower_context: *const LowerContext = @ptrCast(@alignCast(context));
    return lookupLocalValue(lower_context, name);
}

pub fn currentSourcePath(context: *const LowerContext) ?[]const u8 {
    if (context.source_stack.items.len == 0) return null;
    return context.source_stack.items[context.source_stack.items.len - 1].path;
}

/// The module-level binding snapshot for the current module generation,
/// building it only when the cached one is stale.
///
/// The cache holds one reference of its own, so the returned snapshot always
/// carries one more for the caller. When a module-level value changes the cache
/// drops its reference; snapshots still held by captures stay alive until those
/// captures are released, which is what keeps an earlier capture reading the
/// values it was taken with.
fn moduleBindingSnapshot(
    context: *LowerContext,
    allocator: Allocator,
    module: *const @import("../module.zig").Module,
) contracts.LowerError!*value_mod.BindingSnapshot {
    if (context.cached_module_snapshot) |cached| {
        if (context.cached_module_generation == module.value_generation) {
            try cached.retain();
            return cached;
        }
        cached.release(allocator);
        context.cached_module_snapshot = null;
    }

    // The entries are built inside their own block so that the `errdefer` guarding
    // them cannot outlive the moment they are handed to the snapshot. Registered in
    // the function body it would still be armed when the cache takes the snapshot,
    // and a later failure would then free storage the cached snapshot still points
    // at. Leaving the block ends that scope, so no error path can free them twice.
    const snapshot = blk: {
        var entries: value_mod.MapValue = .{ .entries = try allocator.alloc(value_mod.MapEntry, 0) };
        errdefer entries.deinit(allocator);
        for (module.symbols.items.items) |symbol| {
            if (symbol.binding == .value) {
                entries.setCloned(allocator, symbol.name, symbol.binding.value.value) catch |err| return switch (err) {
                    error.OutOfMemory => error.OutOfMemory,
                    error.CollectionTooLarge => error.InvalidApiArgument,
                };
            }
        }

        const built = try allocator.create(value_mod.BindingSnapshot);
        built.* = .{ .entries = entries };
        break :blk built;
    };
    context.cached_module_snapshot = snapshot;
    context.cached_module_generation = module.value_generation;
    // The cache owns one reference; this is the caller's. If it cannot be taken
    // the snapshot simply stays cached, so nothing leaks either way.
    try snapshot.retain();
    return snapshot;
}

pub fn captureOperandEnvironment(
    context: *LowerContext,
    allocator: Allocator,
    module: *const @import("../module.zig").Module,
) contracts.LowerError!*value_mod.OperandEnvironment {
    const snapshot = try moduleBindingSnapshot(context, allocator, module);
    errdefer snapshot.release(allocator);

    // Only this scope chain's locals are copied. A capture reads its locals
    // first and falls back to the shared module snapshot
    // (`OperandEnvironment.capturedEntry`), which is the order the single
    // merged map used to produce because module entries were inserted first.
    var bindings: value_mod.MapValue = .{ .entries = try allocator.alloc(value_mod.MapEntry, 0) };
    errdefer bindings.deinit(allocator);
    for (context.scopes.items) |scope| {
        for (scope.locals.items) |local| {
            bindings.setCloned(allocator, local.name, local.value) catch |err| return switch (err) {
                error.OutOfMemory => error.OutOfMemory,
                error.CollectionTooLarge => error.InvalidApiArgument,
            };
        }
    }

    // Depth is a safety valve against unbounded expansion, so it is measured
    // from the bindings as they are now rather than from the snapshot. A module
    // binding can be mutated in place: `list.push_mut` on a module-level list
    // deepens its capture chain without adding or replacing any binding, so the
    // snapshot stays valid while its depth goes stale -- and a stale depth would
    // let exactly the runaway expansion this limit exists to stop slip through.
    // Reading the depth costs a walk, not a copy.
    var depth: usize = 0;
    for (module.symbols.items.items) |symbol| {
        if (symbol.binding == .value) depth = @max(depth, symbol.binding.value.value.operandCaptureDepth());
    }
    for (bindings.entries) |entry| depth = @max(depth, entry.value.operandCaptureDepth());
    if (depth >= value_mod.OperandEnvironment.max_depth) return error.MacroCaptureDepthExceeded;

    const environment = try allocator.create(value_mod.OperandEnvironment);
    environment.* = .{
        .allocator = allocator,
        .module_snapshot = snapshot,
        .bindings = bindings,
        .depth = depth + 1,
    };
    return environment;
}

pub fn sourceStackContains(context: *const LowerContext, identity: []const u8) bool {
    for (context.source_stack.items) |frame| {
        if (std.mem.eql(u8, frame.identity, identity)) return true;
    }
    return false;
}

fn exerciseModuleSnapshotCapture(allocator: Allocator) !void {
    var module = try module_mod.Module.init(allocator, target_mod.Target.default);
    defer module.deinit();

    // A module-level binding, so a snapshot has something to copy. `defineValue`
    // takes ownership only when it succeeds, so a failure there leaves the map
    // with this function and it has to be released here.
    const table: value_mod.Value = blk: {
        var building: value_mod.Value = .{ .map = .{ .entries = try allocator.alloc(value_mod.MapEntry, 0) } };
        errdefer building.deinit(allocator);
        try building.map.setCloned(allocator, "first", value_mod.Value.int(1));
        break :blk building;
    };
    _ = module.defineValue("table", table, .let, source.unknown_span) catch |err| {
        var unowned = table;
        unowned.deinit(allocator);
        return err;
    };

    // Every call gets its own module and context, so the snapshot cache always
    // starts empty. Sharing one across calls would make the allocation count
    // depend on how many times the checker has already run this function, which
    // it rejects as `NondeterministicMemoryUsage`.
    var context: LowerContext = .{};
    defer context.deinit(allocator);

    // The first capture builds and caches the snapshot; the second reuses it,
    // which is the path that keeps the generated tables from being copied again.
    const built = try captureOperandEnvironment(&context, allocator, &module);
    built.release(allocator);
    const reused = try captureOperandEnvironment(&context, allocator, &module);
    reused.release(allocator);
}

test "operand environment capture handles every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, exerciseModuleSnapshotCapture, .{});
}

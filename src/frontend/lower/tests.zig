const std = @import("std");

test {
    _ = @import("float_fields_tests.zig");
}

const module_mod = @import("../module.zig");
const pass = @import("../pass.zig");
const source_path = @import("../source_path.zig");
const target = @import("../target.zig");
const types = @import("../types.zig");
const value_mod = @import("../value.zig");
const root = @import("root.zig");

const Allocator = std.mem.Allocator;
const LowerError = root.LowerError;
const LowerOptions = root.LowerOptions;
const IncludeRequest = root.IncludeRequest;
const IncludeSource = root.IncludeSource;
const lowerSource = root.lowerSource;
const lowerSourceIntoModule = root.lowerSourceIntoModule;
const lowerSourceIntoModuleWithPathOptions = root.lowerSourceIntoModuleWithPathOptions;

test "SPIR-V ID names and quoted builtin spelling survive Meta lowering" {
    var module = try lowerSource(std.testing.allocator,
        \\spv.use()
        \\const main: u64 = 29
        \\const entry: u64 = 30
        \\OpName %main "here()"
        \\OpName %main "label_addr(\"entry\")"
        \\%main = OpTypeVoid
        \\%entry = OpTypeFunction %main
    , .{});
    defer module.deinit();
    try std.testing.expectEqual(@as(usize, 4), module.fragments.items.items.len);
    try std.testing.expectEqualStrings("OpName %main \"here()\"", module.fragments.items.items[0].isa_instruction.text);
    try std.testing.expectEqualStrings("OpName %main \"label_addr(\\\"entry\\\")\"", module.fragments.items.items[1].isa_instruction.text);
    try std.testing.expectEqualStrings("%main = OpTypeVoid", module.fragments.items.items[2].isa_instruction.text);
    try std.testing.expectEqualStrings("%entry = OpTypeFunction %main", module.fragments.items.items[3].isa_instruction.text);
}

test "lowering records labels and ISA fragments in the frontend container" {
    var module = try lowerSource(
        std.testing.allocator,
        \\entry:
        \\    mov rax, 1
        \\origin(0x7c00);
        \\packed struct Header {
        \\    magic: u16 = 0xaa55,
        \\    size: u32,
        \\}
        \\let count = 4
        \\count = count + 1
        \\    add rax, count
        \\
    ,
        .{},
    );
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 1), module.sections.items.items.len);
    try std.testing.expectEqual(@as(usize, 2), module.fragments.items.items.len);
    try std.testing.expectEqual(@as(usize, 2), module.symbols.items.items.len);
    try std.testing.expectEqual(@as(usize, 0), module.diagnostics.items.items.len);
    try std.testing.expectEqual(@as(usize, 3), module.types.items.items.len);
    try std.testing.expect((module.lookupTypeName("Header") orelse return error.MissingType).index == 2);
    const entry_id = module.symbols.lookup("entry") orelse return error.MissingSymbol;
    const entry = try module.symbols.get(entry_id);
    switch (entry.binding) {
        .label => |label| {
            try std.testing.expectEqual(module.default_section.index, label.section.index);
            try std.testing.expectEqual(@as(u64, 0), label.offset);
        },
        else => return error.UnexpectedSymbolBinding,
    }

    const count_id = module.symbols.lookup("count") orelse return error.MissingSymbol;
    const count = try module.symbols.get(count_id);
    switch (count.binding) {
        .value => |binding| {
            try std.testing.expectEqual(.let, binding.mutability);
            try std.testing.expectEqual(@as(u64, 5), try binding.value.expectInteger());
        },
        else => return error.UnexpectedSymbolBinding,
    }

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);
}

test "lowering reports bare directive syntax at the parser span" {
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    const result = lowerSourceIntoModuleWithPathOptions(
        std.testing.allocator,
        &module,
        "src/main.xir",
        "  db 0xff\n",
        .{},
    );
    try std.testing.expectError(error.LegacyDirectiveSyntax, result);
    try std.testing.expectEqual(@as(usize, 1), module.diagnostics.items.items.len);
    const diagnostic = module.diagnostics.items.items[0];
    try std.testing.expectEqual(@as(u32, 2), diagnostic.span.start);
    try std.testing.expectEqualStrings(
        "legacy assembler directive is not supported; use modern XIRASM API syntax",
        diagnostic.message,
    );
}

test "lowering updates let value bindings" {
    var module = try lowerSource(
        std.testing.allocator,
        \\let value = 41
        \\value = value + 1
        \\emit.u8(value);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const value_id = module.symbols.lookup("value") orelse return error.MissingSymbol;
    const value_symbol = try module.symbols.get(value_id);
    switch (value_symbol.binding) {
        .value => |binding| {
            try std.testing.expectEqual(value_mod.Mutability.let, binding.mutability);
            try std.testing.expectEqual(@as(u64, 42), try binding.value.expectInteger());
        },
        else => return error.UnexpectedSymbolBinding,
    }

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
}

test "lowering rejects const value assignment" {
    var module = lowerSource(
        std.testing.allocator,
        \\const value = 41
        \\value = 42
        \\
    ,
        .{},
    ) catch |err| {
        try std.testing.expectEqual(error.InvalidValueDeclaration, err);
        return;
    };
    module.deinit();
    return error.TestExpectedError;
}

test "value functions may update local let bindings only" {
    var module = try lowerSource(
        std.testing.allocator,
        \\fn bump(value: integer) -> integer {
        \\    let local = value
        \\    local = local + 1
        \\    return local
        \\}
        \\const result = bump(41)
        \\
    ,
        .{},
    );
    defer module.deinit();

    const result_id = module.symbols.lookup("result") orelse return error.MissingSymbol;
    const result_symbol = try module.symbols.get(result_id);
    switch (result_symbol.binding) {
        .value => |binding| try std.testing.expectEqual(@as(u64, 42), try binding.value.expectInteger()),
        else => return error.UnexpectedSymbolBinding,
    }

    try std.testing.expectError(
        error.InvalidExpression,
        lowerSource(
            std.testing.allocator,
            \\let outer = 41
            \\fn bump() -> integer {
            \\    outer = 42
            \\    return outer
            \\}
            \\const result = bump()
            \\
        ,
            .{},
        ),
    );
}

test "value functions cannot mutate caller locals or pass them for procedure writeback" {
    for ([_][]const u8{
        "scalar = 7",
        "list.push_mut(items, 8)",
        "list.set_mut(items, 0, 8)",
        "map.set_mut(cfg, \"entry\", 8)",
        "replace(scalar)",
    }) |mutation| {
        for ([_][]const u8{ "fn caller()", "fn caller() -> u64", "macro caller()" }) |caller| {
            const text = try std.fmt.allocPrint(
                std.testing.allocator,
                "fn replace(let target: u64) {{\n target = 7\n}}\n" ++
                    "fn inner() -> u64 {{\n {s}\n return 0\n}}\n" ++
                    "{s} {{\n let scalar: u64 = 1\n let items: list = list.of(2)\n" ++
                    " let cfg: map = map.new()\n const result = inner()\n {s}\n}}\n{s}\n",
                .{
                    mutation,
                    caller,
                    if (std.mem.eql(u8, caller, "fn caller() -> u64")) "return 0" else "",
                    if (std.mem.eql(u8, caller, "macro caller()")) "caller" else if (std.mem.eql(u8, caller, "fn caller() -> u64")) "const result = caller()" else "caller()",
                },
            );
            defer std.testing.allocator.free(text);
            try std.testing.expectError(error.InvalidExpression, lowerSource(std.testing.allocator, text, .{}));
        }
    }
    try std.testing.expectError(error.InvalidExpression, lowerSource(std.testing.allocator,
        \\let scalar: u64 = 1
        \\fn replace(let target: u64) {
        \\    target = 7
        \\}
        \\fn inner() -> u64 {
        \\    replace(scalar)
        \\    return 0
        \\}
        \\const result = inner()
    , .{}));
}

fn checkValueFunctionMutationScopes(allocator: Allocator) !void {
    var module = try lowerSource(allocator,
        \\fn append(let items: list) {
        \\    list.push_mut(items, 4)
        \\}
        \\fn inner() -> u64 {
        \\    let count: u64 = 1
        \\    count = count + 1
        \\    return count
        \\}
        \\fn build() -> list {
        \\    let items: list = list.of(1)
        \\    let cfg: map = map.new()
        \\    if true {
        \\        list.push_mut(items, inner())
        \\        list.set_mut(items, 0, 3)
        \\        map.set_mut(cfg, "size", len(items))
        \\    }
        \\    append(items)
        \\    assert(map.get(cfg, "size") == 2)
        \\    return items
        \\}
        \\fn caller() {
        \\    let scalar: u64 = 5
        \\    let items: list = build()
        \\    assert(list.eq(items, list.of(3, 2, 4)))
        \\    scalar = scalar + 1
        \\    list.push_mut(items, scalar)
        \\    assert(list.get(items, 3) == 6)
        \\}
        \\caller()
    , .{});
    defer module.deinit();
}

test "value function mutation waterlines preserve nested blocks and procedure parameters" {
    try checkValueFunctionMutationScopes(std.testing.allocator);
}

test "value function mutation waterlines clean up every allocation failure" {
    var no_resize = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
    try std.testing.checkAllAllocationFailures(no_resize.allocator(), checkValueFunctionMutationScopes, .{});
}

test "value functions reject state changing APIs before their arguments run" {
    for ([_][]const u8{
        "origin(0x1000)",
        "output.section(\"section\", 0x1000)",
        "output.org(\"org\", 0x1000)",
        "x86.use16()",
        "x86.use32()",
        "x86.use64()",
        "riscv.use32()",
        "riscv.use64()",
        "spv.use()",
        "include(\"unread.inc\")",
        "import(\"unread.inc\")",
    }) |operation| {
        for ([_]bool{ false, true }) |indirect| {
            const text = try std.fmt.allocPrint(
                std.testing.allocator,
                "fn change_state() {{\n {s}\n}}\n" ++
                    "fn calculate() -> u64 {{\n {s}\n return 0\n}}\n" ++
                    "const result = calculate()\n",
                .{ operation, if (indirect) "change_state()" else operation },
            );
            defer std.testing.allocator.free(text);
            var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
            defer module.deinit();
            try std.testing.expectError(error.InvalidExpression, lowerSourceIntoModule(std.testing.allocator, &module, text));
            try std.testing.expect(module.diagnostics.items.items.len > 0);
            try std.testing.expect(std.mem.indexOf(u8, module.diagnostics.items.items[0].message, "SideEffectInValueFunction") != null);
        }
    }
}

test "collection mutation updates let bindings without aliasing" {
    var module = try lowerSource(
        std.testing.allocator,
        \\let items: list = list.of(1)
        \\const snapshot: list = items
        \\list.push_mut(items, list.of(2));
        \\list.set_mut(items, 0, 3);
        \\let cfg: map = map.new()
        \\map.set_mut(cfg, "items", items);
        \\list.set_mut(items, 0, 4);
        \\assert(list.eq(snapshot, list.of(1)));
        \\assert(list.eq(items, list.of(4, list.of(2))));
        \\assert(list.eq(map.get(cfg, "items"), list.of(3, list.of(2))));
        \\emit.u8(list.get(items, 0));
        \\
    ,
        .{},
    );
    defer module.deinit();

    const items_id = module.symbols.lookup("items") orelse return error.MissingSymbol;
    const items_symbol = try module.symbols.get(items_id);
    switch (items_symbol.binding) {
        .value => |binding| {
            const items = try binding.value.expectList();
            try std.testing.expectEqual(@as(u64, 4), try items.items[0].expectInteger());
            try std.testing.expectEqual(@as(u64, 2), try items.items[1].list.items[0].expectInteger());
        },
        else => return error.UnexpectedSymbolBinding,
    }
}

test "collection mutation uses nearest local and survives argument scope growth" {
    var module = try lowerSource(
        std.testing.allocator,
        \\fn produce() -> integer {
        \\    let scratch: list = list.of(1)
        \\    list.push_mut(scratch, 2);
        \\    return len(scratch)
        \\}
        \\fn build() -> list {
        \\    let items: list = list.of(7)
        \\    if true {
        \\        let items: list = list.of(8)
        \\        list.push_mut(items, 9);
        \\        assert(list.eq(items, list.of(8, 9)));
        \\    }
        \\    list.push_mut(items, produce());
        \\    return items
        \\}
        \\const result: list = build()
        \\assert(list.eq(result, list.of(7, 2)));
        \\emit.u8(list.get(result, 1));
        \\
    ,
        .{},
    );
    defer module.deinit();
}

test "let procedure parameters write updated collections back to callers" {
    var module = try lowerSource(
        std.testing.allocator,
        \\fn set_entry(let cfg: map, value: u64) {
        \\    map.set_mut(cfg, "entry", value);
        \\}
        \\fn configure(let cfg: map) {
        \\    set_entry(cfg, 42);
        \\}
        \\let image: map = map.new()
        \\configure(image);
        \\assert(map.get(image, "entry") == 42);
        \\emit.u8(map.get(image, "entry"));
        \\
    ,
        .{},
    );
    defer module.deinit();
}

test "let procedure parameters reject nonmutable caller bindings" {
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();
    try std.testing.expectError(
        error.FrontendDiagnostics,
        lowerSourceIntoModule(std.testing.allocator, &module,
            \\fn set_entry(let cfg: map) {
            \\    map.set_mut(cfg, "entry", 1);
            \\}
            \\const image: map = map.new()
            \\set_entry(image);
            \\
        ),
    );
    try std.testing.expectEqual(@as(usize, 1), module.diagnostics.items.items.len);
    try std.testing.expectEqualStrings(
        "mutable function argument must resolve to a let binding",
        module.diagnostics.items.items[0].message,
    );
}

test "let procedure parameters reject temporaries and mutable aliases" {
    try expectCollectionMutationDiagnostic(
        "fn update(let cfg: map) {\n}\nupdate(map.new());\n",
        "mutable function argument must be a direct let binding",
    );
    try expectCollectionMutationDiagnostic(
        "fn update(let left: map, let right: map) {\n}\nlet cfg: map = map.new()\nupdate(cfg, cfg);\n",
        "mutable function arguments cannot alias the same binding",
    );
}

fn expectCollectionMutationDiagnostic(source_text: []const u8, expected: []const u8) !void {
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();
    try std.testing.expectError(
        error.FrontendDiagnostics,
        lowerSourceIntoModule(std.testing.allocator, &module, source_text),
    );
    try std.testing.expectEqual(@as(usize, 1), module.diagnostics.items.items.len);
    try std.testing.expectEqualStrings(expected, module.diagnostics.items.items[0].message);
    try std.testing.expect(module.diagnostics.items.items[0].span.start < module.diagnostics.items.items[0].span.end);
}

test "collection mutation rejects invalid targets and arguments precisely" {
    try expectCollectionMutationDiagnostic(
        "const items: list = list.new()\nlist.push_mut(items, 1);\n",
        "cannot mutate a const collection binding",
    );
    try expectCollectionMutationDiagnostic(
        "let items: list = list.new()\nif true {\nconst items: list = list.new()\nlist.push_mut(items, 1);\n}\n",
        "cannot mutate a const collection binding",
    );
    try expectCollectionMutationDiagnostic(
        "list.push_mut(missing, 1);\n",
        "collection mutation target must resolve to a let binding",
    );
    try expectCollectionMutationDiagnostic(
        "list.push_mut(list.new(), 1);\n",
        "collection mutation target must be a direct let binding",
    );
    try expectCollectionMutationDiagnostic(
        "let value = 1\nlist.push_mut(value, 2);\n",
        "list.push_mut target must have type list",
    );
    try expectCollectionMutationDiagnostic(
        "let items: list = list.new()\nlist.set_mut(items, 0, 1);\n",
        "list.set_mut index is outside the target list",
    );
    try expectCollectionMutationDiagnostic(
        "let cfg: map = map.new()\nmap.set_mut(cfg, 1, 2);\n",
        "map.set_mut key must have type string",
    );
    try expectCollectionMutationDiagnostic(
        "let items: list = list.new()\nlist.push_mut(items);\n",
        "invalid collection mutation argument count",
    );
}

test "collection mutation is unavailable during deferred and late layout execution" {
    try std.testing.expectError(
        error.FinalizerCannotChangeLayout,
        lowerSource(
            std.testing.allocator,
            "let items: list = list.new()\ndefer {\nlist.push_mut(items, 1);\n}\n",
            .{},
        ),
    );
    try std.testing.expectError(
        error.InvalidLateLayout,
        lowerSource(
            std.testing.allocator,
            "let items: list = list.new()\nlate_layout {\nlist.push_mut(items, 1);\n}\n",
            .{},
        ),
    );
}

test "collection mutation is not an expression API" {
    try std.testing.expectError(
        error.InvalidExpression,
        lowerSource(
            std.testing.allocator,
            "let items: list = list.new()\nconst result = list.push_mut(items, 1)\n",
            .{},
        ),
    );
}

test "lowering records Meta diagnostic API messages" {
    var module = try lowerSource(
        std.testing.allocator,
        \\print("size", 2 + 3);
        \\warn("careful", here());
        \\assert(true, "must not emit");
        \\
    ,
        .{},
    );
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 2), module.diagnostics.items.items.len);

    try std.testing.expectEqual(.note, module.diagnostics.items.items[0].severity);
    try std.testing.expectEqualStrings("size 5", module.diagnostics.items.items[0].message);
    try std.testing.expect(module.diagnostics.items.items[0].span.start < module.diagnostics.items.items[0].span.end);

    try std.testing.expectEqual(.warning, module.diagnostics.items.items[1].severity);
    try std.testing.expectEqualStrings("careful 0", module.diagnostics.items.items[1].message);
    try std.testing.expect(module.diagnostics.items.items[1].span.start < module.diagnostics.items.items[1].span.end);
}

test "lowering err emits one frontend diagnostic error" {
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try std.testing.expectError(
        error.FrontendDiagnostics,
        lowerSourceIntoModule(std.testing.allocator, &module,
            \\err("stop", 7);
            \\
        ),
    );

    try std.testing.expectEqual(@as(usize, 1), module.diagnostics.items.items.len);
    try std.testing.expectEqual(.err, module.diagnostics.items.items[0].severity);
    try std.testing.expectEqualStrings("stop 7", module.diagnostics.items.items[0].message);
    try std.testing.expect(module.diagnostics.items.items[0].span.start < module.diagnostics.items.items[0].span.end);
}

test "lowering assert false emits one frontend diagnostic error" {
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try std.testing.expectError(
        error.FrontendDiagnostics,
        lowerSourceIntoModule(std.testing.allocator, &module,
            \\assert(false, "bad state");
            \\
        ),
    );

    try std.testing.expectEqual(@as(usize, 1), module.diagnostics.items.items.len);
    try std.testing.expectEqual(.err, module.diagnostics.items.items[0].severity);
    try std.testing.expectEqualStrings("bad state", module.diagnostics.items.items[0].message);
}

test "lowering assert false has a default message" {
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try std.testing.expectError(
        error.FrontendDiagnostics,
        lowerSourceIntoModule(std.testing.allocator, &module,
            \\assert(false);
            \\
        ),
    );

    try std.testing.expectEqual(@as(usize, 1), module.diagnostics.items.items.len);
    try std.testing.expectEqual(.err, module.diagnostics.items.items[0].severity);
    try std.testing.expectEqualStrings("assertion failed", module.diagnostics.items.items[0].message);
}

test "lowering records struct declarations in the frontend type store" {
    var module = try lowerSource(
        std.testing.allocator,
        \\packed struct DosHeader {
        \\    magic: u16 = 0x5a4d,
        \\    lfanew: u32,
        \\}
        \\
    ,
        .{},
    );
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 3), module.types.items.items.len);
    const header = try module.types.getStruct(.{ .index = 2 });
    try std.testing.expectEqualStrings("DosHeader", header.name);
    try std.testing.expectEqual(types.StructLayoutPolicy.@"packed", header.policy);
    try std.testing.expectEqual(@as(u64, 6), header.layout.size);
    try std.testing.expectEqual(@as(u64, 0), try module.types.structFieldOffset(.{ .index = 2 }, "magic"));
    try std.testing.expectEqual(@as(u64, 2), try module.types.structFieldOffset(.{ .index = 2 }, "lfanew"));
    try std.testing.expect((module.lookupTypeName("DosHeader") orelse return error.MissingType).index == 2);
}

test "lowering reuses named types across structs" {
    var module = try lowerSource(
        std.testing.allocator,
        \\packed struct HeaderA {
        \\    magic: u16,
        \\    size: u32,
        \\}
        \\packed struct HeaderB {
        \\    other_magic: u16,
        \\    other_size: u32,
        \\}
        \\
    ,
        .{},
    );
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 4), module.types.items.items.len);
    try std.testing.expect((module.lookupTypeName("u16") orelse return error.MissingType).index == 0);
    try std.testing.expect((module.lookupTypeName("u32") orelse return error.MissingType).index == 1);
    try std.testing.expect((module.lookupTypeName("HeaderA") orelse return error.MissingType).index == 2);
    try std.testing.expect((module.lookupTypeName("HeaderB") orelse return error.MissingType).index == 3);
}

test "lowering executes flat v1 API calls" {
    var module = try lowerSource(
        std.testing.allocator,
        \\origin(0x7c00);
        \\entry:
        \\emit.u8(0xeb);
        \\emit.u16(0xaa55);
        \\emit.bytes("OK");
        \\reserve(4);
        \\pad(2, 0xcc);
        \\pad_to(16, 0);
        \\align(32, 0x90);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(u64, 0x7c00), text.origin);
    try std.testing.expectEqual(@as(usize, 7), text.fragments.items.len);

    const entry_id = module.symbols.lookup("entry") orelse return error.MissingSymbol;
    const entry = try module.symbols.get(entry_id);
    switch (entry.binding) {
        .label => |label| try std.testing.expectEqual(@as(u64, 0), label.offset),
        else => return error.UnexpectedSymbolBinding,
    }

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0xeb), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 2), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0x55), bytes.data[0]);
            try std.testing.expectEqual(@as(u8, 0xaa), bytes.data[1]);
        },
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[4].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 2), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0xcc), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[6].index]) {
        .alignment => |alignment| {
            try std.testing.expectEqual(@as(u64, 32), alignment.alignment);
            try std.testing.expectEqual(@as(u8, 0x90), alignment.fill);
        },
        else => return error.UnexpectedFragment,
    }
}

test "lowering rejects output after region file alignment closes physical section" {
    try std.testing.expectError(error.OutputRegionClosed, lowerSource(
        std.testing.allocator,
        \\emit.u8(1);
        \\region.file_align(0x200);
        \\emit.u8(2);
        \\
    ,
        .{},
    ));
}

test "lowering target mode APIs snapshot subsequent ISA fragments" {
    var module = try lowerSource(
        std.testing.allocator,
        \\x86.use32();
        \\    ret
        \\x86.use64();
        \\    ret
        \\riscv.use32();
        \\    addi x1, x0, 1
        \\riscv.use64();
        \\    addi x2, x0, 2
        \\spv.use();
        \\    OpCapability Shader
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 5), text.fragments.items.len);

    const first = module.fragments.items.items[text.fragments.items[0].index];
    const second = module.fragments.items.items[text.fragments.items[1].index];
    const third = module.fragments.items.items[text.fragments.items[2].index];
    const fourth = module.fragments.items.items[text.fragments.items[3].index];
    const fifth = module.fragments.items.items[text.fragments.items[4].index];

    switch (first) {
        .isa_instruction => |instruction| {
            try std.testing.expectEqual(target.Isa.x86_64, instruction.target.isa());
            try std.testing.expectEqual(@as(u16, 32), instruction.target.bits().?);
        },
        else => return error.UnexpectedFragment,
    }
    switch (second) {
        .isa_instruction => |instruction| {
            try std.testing.expectEqual(target.Isa.x86_64, instruction.target.isa());
            try std.testing.expectEqual(@as(u16, 64), instruction.target.bits().?);
        },
        else => return error.UnexpectedFragment,
    }
    switch (third) {
        .isa_instruction => |instruction| {
            try std.testing.expectEqual(target.Isa.riscv64, instruction.target.isa());
            try std.testing.expectEqual(@as(u16, 32), instruction.target.bits().?);
        },
        else => return error.UnexpectedFragment,
    }
    switch (fourth) {
        .isa_instruction => |instruction| {
            try std.testing.expectEqual(target.Isa.riscv64, instruction.target.isa());
            try std.testing.expectEqual(@as(u16, 64), instruction.target.bits().?);
        },
        else => return error.UnexpectedFragment,
    }
    switch (fifth) {
        .isa_instruction => |instruction| {
            try std.testing.expectEqual(target.Isa.spirv, instruction.target.isa());
            try std.testing.expectEqual(@as(?u16, null), instruction.target.bits());
        },
        else => return error.UnexpectedFragment,
    }

    try std.testing.expectEqual(target.Isa.spirv, module.target.isa());
    try std.testing.expectEqual(@as(?u16, null), module.target.bits());
}

test "lowering evaluates modern defined meta conditionals" {
    var module = try lowerSource(
        std.testing.allocator,
        \\const enabled = 1
        \\if defined("enabled") {
        \\emit.u8(0xaa);
        \\}
        \\if defined("missing") {
        \\emit.u8(0xbb);
        \\}
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
    try std.testing.expectEqual(@as(usize, 0), module.diagnostics.items.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0xaa), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }
}

test "lowering evaluates target meta conditionals" {
    var module = try lowerSource(
        std.testing.allocator,
        \\if target.bits == 64 {
        \\emit.u8(0x64);
        \\}
        \\if target.isa == .riscv64 {
        \\emit.u8(0xff);
        \\}
        \\
    ,
        .{ .target = try target.Target.initX86(64) },
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
    try std.testing.expectEqual(@as(usize, 0), module.diagnostics.items.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0x64), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }
}

const TestIncludeFile = struct {
    path: []const u8,
    bytes: []const u8,
};

const TestIncludeResolver = struct {
    files: []const TestIncludeFile,

    fn resolve(
        context: *anyopaque,
        allocator: Allocator,
        request: IncludeRequest,
    ) LowerError!IncludeSource {
        const resolver: *const TestIncludeResolver = @ptrCast(@alignCast(context));
        const resolved_path = try testResolveIncludePath(allocator, request.parent_path, request.path);
        errdefer allocator.free(resolved_path);

        for (resolver.files) |file| {
            if (!std.mem.eql(u8, file.path, resolved_path)) continue;

            return .{
                .path = resolved_path,
                .bytes = try allocator.dupe(u8, file.bytes),
            };
        }

        return error.IncludeNotAvailable;
    }
};

fn testResolveIncludePath(
    allocator: Allocator,
    parent_path: ?[]const u8,
    include_path: []const u8,
) Allocator.Error![]u8 {
    return source_path.resolveIdentity(allocator, parent_path, include_path);
}

test "lowering evaluates target width fields in general expressions" {
    var module = try lowerSource(
        std.testing.allocator,
        \\x86.use64();
        \\const x86_bits = target.bits
        \\assert(x86_bits == 64);
        \\assert(target.bits == 64);
        \\riscv.use32();
        \\const riscv_bits = target.xlen
        \\assert(riscv_bits == 32);
        \\assert(target.xlen == 32);
        \\emit.u8(riscv_bits);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqualSlices(u8, &.{0x20}, bytes.data),
        else => return error.UnexpectedFragment,
    }
}

test "lowering resolves source-level include relative to parent source" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/shared/prefix.xir",
            .bytes =
            \\const prefix: u64 = 2;
            \\emit.u8(prefix);
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };

    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try lowerSourceIntoModuleWithPathOptions(
        std.testing.allocator,
        &module,
        "src/main.xir",
        \\include("shared/prefix.xir");
        \\emit.u8(prefix + 1);
        \\
    ,
        .{
            .include_resolver = .{
                .context = @ptrCast(&resolver),
                .resolve = TestIncludeResolver.resolve,
            },
        },
    );

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);
    try std.testing.expectEqual(@as(usize, 0), module.diagnostics.items.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 2), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 3), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }
}

test "lowering imports source files only once" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/shared/once.xir",
            .bytes =
            \\emit.u8(0x42);
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };

    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try lowerSourceIntoModuleWithPathOptions(
        std.testing.allocator,
        &module,
        "src/main.xir",
        \\import("shared/once.xir");
        \\import("shared/once.xir");
        \\
    ,
        .{
            .include_resolver = .{
                .context = @ptrCast(&resolver),
                .resolve = TestIncludeResolver.resolve,
            },
        },
    );

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
    try std.testing.expectEqual(@as(usize, 0), module.diagnostics.items.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqual(@as(u8, 0x42), bytes.data[0]),
        else => return error.UnexpectedFragment,
    }
}

test "lowering treats lexical import aliases as one source" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/shared/once.xir",
            .bytes =
            \\emit.u8(0x43);
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try lowerSourceIntoModuleWithPathOptions(
        std.testing.allocator,
        &module,
        "src/main.xir",
        \\import("shared/once.xir");
        \\import("shared/./once.xir");
        \\
    ,
        .{ .include_resolver = .{
            .context = @ptrCast(&resolver),
            .resolve = TestIncludeResolver.resolve,
        } },
    );

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
}

test "macro definitions survive imported AST teardown and import deduplication" {
    const files = [_]TestIncludeFile{.{ .path = "src/macros.inc", .bytes = "macro byte(x) {\n emit.u8(operand.eval(x))\n}\n" }};
    var resolver: TestIncludeResolver = .{ .files = &files };
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();
    try lowerSourceIntoModuleWithPathOptions(std.testing.allocator, &module, "src/main.asm", "import(\"macros.inc\")\nimport(\"./macros.inc\")\nbyte 42\n", .{ .include_resolver = .{ .context = &resolver, .resolve = TestIncludeResolver.resolve } });
    try std.testing.expectEqual(@as(usize, 1), module.fragments.items.items.len);
    try std.testing.expectEqualSlices(u8, &.{42}, module.fragments.items.items[0].bytes.data);
}

test "module remembers imports across separate lowering sessions" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/shared/once.xir",
            .bytes =
            \\emit.u8(0x44);
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();
    const options: LowerOptions = .{ .include_resolver = .{
        .context = @ptrCast(&resolver),
        .resolve = TestIncludeResolver.resolve,
    } };

    try lowerSourceIntoModuleWithPathOptions(
        std.testing.allocator,
        &module,
        "src/first.xir",
        "import(\"shared/once.xir\");\n",
        options,
    );
    try lowerSourceIntoModuleWithPathOptions(
        std.testing.allocator,
        &module,
        "src/second.xir",
        "import(\"shared/./once.xir\");\n",
        options,
    );

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
}

test "lowering includes source files every time" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/shared/inline.xir",
            .bytes =
            \\emit.u8(0x24);
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };

    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try lowerSourceIntoModuleWithPathOptions(
        std.testing.allocator,
        &module,
        "src/main.xir",
        \\include("shared/inline.xir");
        \\include("shared/inline.xir");
        \\
    ,
        .{
            .include_resolver = .{
                .context = @ptrCast(&resolver),
                .resolve = TestIncludeResolver.resolve,
            },
        },
    );

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);
    try std.testing.expectEqual(@as(usize, 0), module.diagnostics.items.items.len);

    for (text.fragments.items) |fragment_id| {
        switch (module.fragments.items.items[fragment_id.index]) {
            .bytes => |bytes| try std.testing.expectEqual(@as(u8, 0x24), bytes.data[0]),
            else => return error.UnexpectedFragment,
        }
    }
}

test "lowering imports Meta function modules only once" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/shared/functions.xir",
            .bytes =
            \\fn emit_once(value: u64) {
            \\    emit.u8(value);
            \\}
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };

    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try lowerSourceIntoModuleWithPathOptions(
        std.testing.allocator,
        &module,
        "src/main.xir",
        \\import("shared/functions.xir");
        \\import("shared/functions.xir");
        \\emit_once(9);
        \\
    ,
        .{
            .include_resolver = .{
                .context = @ptrCast(&resolver),
                .resolve = TestIncludeResolver.resolve,
            },
        },
    );

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqual(@as(u8, 9), bytes.data[0]),
        else => return error.UnexpectedFragment,
    }
}

test "lowering includes duplicate Meta function modules as repeated source" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/shared/functions.xir",
            .bytes =
            \\fn emit_dup(value: u64) {
            \\    emit.u8(value);
            \\}
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };

    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try std.testing.expectError(
        error.DuplicateMetaFunction,
        lowerSourceIntoModuleWithPathOptions(
            std.testing.allocator,
            &module,
            "src/main.xir",
            \\include("shared/functions.xir");
            \\include("shared/functions.xir");
            \\
        ,
            .{
                .include_resolver = .{
                    .context = @ptrCast(&resolver),
                    .resolve = TestIncludeResolver.resolve,
                },
            },
        ),
    );
}

test "lowering rejects recursive source imports" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/main.xir",
            .bytes =
            \\import("main.xir");
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };

    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try std.testing.expectError(
        error.IncludeCycle,
        lowerSourceIntoModuleWithPathOptions(
            std.testing.allocator,
            &module,
            "src/main.xir",
            \\import("main.xir");
            \\
        ,
            .{
                .include_resolver = .{
                    .context = @ptrCast(&resolver),
                    .resolve = TestIncludeResolver.resolve,
                },
            },
        ),
    );
}

test "lowering rejects recursive imports through lexical aliases" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/main.xir",
            .bytes = "import(\"./main.xir\");\n",
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };
    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try std.testing.expectError(
        error.IncludeCycle,
        lowerSourceIntoModuleWithPathOptions(
            std.testing.allocator,
            &module,
            "src/main.xir",
            "import(\"./main.xir\");\n",
            .{ .include_resolver = .{
                .context = @ptrCast(&resolver),
                .resolve = TestIncludeResolver.resolve,
            } },
        ),
    );
}

test "lowering rejects scoped source imports" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/shared/mod.xir",
            .bytes =
            \\emit.u8(1);
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };

    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try std.testing.expectError(
        error.InvalidMetaBlock,
        lowerSourceIntoModuleWithPathOptions(
            std.testing.allocator,
            &module,
            "src/main.xir",
            \\{
            \\    import("shared/mod.xir");
            \\}
            \\
        ,
            .{
                .include_resolver = .{
                    .context = @ptrCast(&resolver),
                    .resolve = TestIncludeResolver.resolve,
                },
            },
        ),
    );
}

test "lowering calls Meta functions with scoped integer parameters" {
    var module = try lowerSource(
        std.testing.allocator,
        \\fn emit_pair(value: u64) {
        \\    emit.u8(value);
        \\    emit.u8(value + 1);
        \\}
        \\emit_pair(2);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 2), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 3), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }
}

test "lowering scopes block-local values without leaking symbols" {
    var module = try lowerSource(
        std.testing.allocator,
        \\const value = 1
        \\{
        \\    let value = 2
        \\    emit.u8(value);
        \\}
        \\emit.u8(value);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const value_id = module.symbols.lookup("value") orelse return error.MissingSymbol;
    const value_symbol = try module.symbols.get(value_id);
    switch (value_symbol.binding) {
        .value => |binding| try std.testing.expectEqual(@as(u64, 1), try binding.value.expectInteger()),
        else => return error.UnexpectedSymbolBinding,
    }

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqual(@as(u8, 2), bytes.data[0]),
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .bytes => |bytes| try std.testing.expectEqual(@as(u8, 1), bytes.data[0]),
        else => return error.UnexpectedFragment,
    }
}

test "lowering scopes Meta if body values without leaking symbols" {
    var module = try lowerSource(
        std.testing.allocator,
        \\const value = 1
        \\if true {
        \\    let value = 2
        \\    emit.u8(value);
        \\}
        \\emit.u8(value);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const value_id = module.symbols.lookup("value") orelse return error.MissingSymbol;
    const value_symbol = try module.symbols.get(value_id);
    switch (value_symbol.binding) {
        .value => |binding| try std.testing.expectEqual(@as(u64, 1), try binding.value.expectInteger()),
        else => return error.UnexpectedSymbolBinding,
    }

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqual(@as(u8, 2), bytes.data[0]),
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .bytes => |bytes| try std.testing.expectEqual(@as(u8, 1), bytes.data[0]),
        else => return error.UnexpectedFragment,
    }
}

test "lowering dispatches nested Meta if procedure calls" {
    var module = try lowerSource(
        std.testing.allocator,
        \\fn emit_read_mode() {
        \\    emit.u8(0x11);
        \\}
        \\fn emit_write_mode() {
        \\    emit.u8(0x22);
        \\}
        \\fn emit_poison_mode() {
        \\    emit.u8(0xcc);
        \\}
        \\fn dispatch(kind: string) {
        \\    if kind == "read" {
        \\        emit_read_mode();
        \\    } else {
        \\        if kind == "write" {
        \\            emit_write_mode();
        \\        } else {
        \\            emit_poison_mode();
        \\        }
        \\    }
        \\}
        \\dispatch("read");
        \\dispatch("write");
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);
    const expected = [_]u8{ 0x11, 0x22 };
    for (expected, 0..) |byte, index| {
        switch (module.fragments.items.items[text.fragments.items[index].index]) {
            .bytes => |bytes| try std.testing.expectEqual(byte, bytes.data[0]),
            else => return error.UnexpectedFragment,
        }
    }
}

test "lowering keeps Meta function parameters local to the call" {
    try std.testing.expectError(
        error.UndefinedSymbol,
        lowerSource(
            std.testing.allocator,
            \\fn emit_one(value: u64) {
            \\    emit.u8(value);
            \\}
            \\emit_one(7);
            \\emit.u8(value);
            \\
        ,
            .{},
        ),
    );
}

test "lowering rejects duplicate Meta function parameter names" {
    try std.testing.expectError(
        error.InvalidMetaFunction,
        lowerSource(
            std.testing.allocator,
            \\fn emit_pair(value: u64, value: u64) {
            \\    emit.u8(value);
            \\}
            \\emit_pair(1, 2);
            \\
        ,
            .{},
        ),
    );
}

test "lowering rejects duplicate local names in one Meta scope" {
    try std.testing.expectError(
        error.DuplicateSymbol,
        lowerSource(
            std.testing.allocator,
            \\{
            \\    let value = 1
            \\    let value = 2
            \\}
            \\
        ,
            .{},
        ),
    );
}

test "lowering keeps nested block locals scoped by nearest declaration" {
    var module = try lowerSource(
        std.testing.allocator,
        \\const value = 1
        \\{
        \\    let value = 2
        \\    {
        \\        let value = 3
        \\        emit.u8(value);
        \\    }
        \\    emit.u8(value);
        \\}
        \\emit.u8(value);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 3), text.fragments.items.len);

    const expected = [_]u8{ 3, 2, 1 };
    for (text.fragments.items, expected) |fragment_id, value| {
        switch (module.fragments.items.items[fragment_id.index]) {
            .bytes => |bytes| try std.testing.expectEqual(value, bytes.data[0]),
            else => return error.UnexpectedFragment,
        }
    }
}

test "lowering keeps Meta for iteration locals scoped per iteration" {
    try std.testing.expectError(
        error.UndefinedSymbol,
        lowerSource(
            std.testing.allocator,
            \\for i in range(0, 2) {
            \\    if i == 0 {
            \\        let first_only = 7
            \\    }
            \\    if i == 1 {
            \\        emit.u8(first_only);
            \\    }
            \\}
            \\
        ,
            .{},
        ),
    );
}

test "lowering keeps Meta function body locals inside call scope" {
    try std.testing.expectError(
        error.UndefinedSymbol,
        lowerSource(
            std.testing.allocator,
            \\fn emit_one(value: u64) {
            \\    let temp = value
            \\    emit.u8(temp);
            \\}
            \\emit_one(7);
            \\emit.u8(temp);
            \\
        ,
            .{},
        ),
    );
}

test "lowering names the expression that carries an undeclared name" {
    const allocator = std.testing.allocator;
    var module = try module_mod.Module.init(allocator, target.Target.default);
    defer module.deinit();

    try std.testing.expectError(error.FrontendDiagnostics, lowerSourceIntoModule(allocator, &module,
        \\let app: u64 = apk_res_dir(app, "res")
        \\
    ));
    try std.testing.expectEqual(@as(usize, 1), module.diagnostics.items.items.len);
    try std.testing.expectEqualStrings(
        "undefined name in this expression: apk_res_dir(app, \"res\")",
        module.diagnostics.items.items[0].message,
    );
}

test "lowering reports an unknown call by name" {
    const allocator = std.testing.allocator;
    var module = try module_mod.Module.init(allocator, target.Target.default);
    defer module.deinit();

    try std.testing.expectError(error.FrontendDiagnostics, lowerSourceIntoModule(allocator, &module,
        \\no_such_function(7);
        \\
    ));
    try std.testing.expectEqual(@as(usize, 1), module.diagnostics.items.items.len);
    try std.testing.expectEqualStrings("unknown call: no_such_function", module.diagnostics.items.items[0].message);
}

test "an API call statement may carry a line comment" {
    var module = try lowerSource(
        std.testing.allocator,
        \\emit.u8(7); // trailing comment
        \\emit.u8(0x41) // and one without a semicolon
        \\
    ,
        .{},
    );
    defer module.deinit();
    try std.testing.expectEqual(@as(usize, 2), module.fragments.items.items.len);
}

test "lowering rejects Meta function declarations in scoped blocks" {
    try std.testing.expectError(
        error.InvalidMetaFunction,
        lowerSource(
            std.testing.allocator,
            \\{
            \\    fn inner() {
            \\        emit.u8(1);
            \\    }
            \\}
            \\
        ,
            .{},
        ),
    );
}

test "lowering rejects recursive Meta function calls at depth limit" {
    try std.testing.expectError(
        error.MetaCallDepthExceeded,
        lowerSource(
            std.testing.allocator,
            \\fn recurse(value: u64) {
            \\    recurse(value);
            \\}
            \\recurse(1);
            \\
        ,
            .{},
        ),
    );
}

test "lowering calls Meta functions defined by source includes" {
    const files = [_]TestIncludeFile{
        .{
            .path = "src/shared/functions.xir",
            .bytes =
            \\fn emit_prefix(value: u64) {
            \\    emit.u8(value);
            \\}
            \\
            ,
        },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };

    var module = try module_mod.Module.init(std.testing.allocator, target.Target.default);
    defer module.deinit();

    try lowerSourceIntoModuleWithPathOptions(
        std.testing.allocator,
        &module,
        "src/main.xir",
        \\include("shared/functions.xir");
        \\emit_prefix(5);
        \\
    ,
        .{
            .include_resolver = .{
                .context = @ptrCast(&resolver),
                .resolve = TestIncludeResolver.resolve,
            },
        },
    );

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 5), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }
}

test "lowering isolates virtual output sections from main output" {
    var module = try lowerSource(
        std.testing.allocator,
        \\emit.u8(0xaa);
        \\virtual.begin(0x1000);
        \\VBox:
        \\emit.u8(0x11);
        \\reserve(2);
        \\emit.u8(0x22);
        \\virtual.end();
        \\after:
        \\emit.u8(0xbb);
        \\
    ,
        .{},
    );
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 2), module.sections.items.items.len);
    try std.testing.expectEqual(@as(usize, 1), module.virtual_sections.items.len);

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);

    const virtual_id = module.virtual_sections.items[0];
    const virtual = try module.sections.get(virtual_id);
    try std.testing.expectEqual(@as(u64, 0x1000), virtual.origin);
    try std.testing.expectEqual(@as(usize, 3), virtual.fragments.items.len);

    const vbox_id = module.symbols.lookup("VBox") orelse return error.MissingSymbol;
    const vbox = try module.symbols.get(vbox_id);
    switch (vbox.binding) {
        .label => |label| {
            try std.testing.expectEqual(virtual_id.index, label.section.index);
            try std.testing.expectEqual(@as(u64, 0), label.offset);
        },
        else => return error.UnexpectedSymbolBinding,
    }

    const after_id = module.symbols.lookup("after") orelse return error.MissingSymbol;
    const after = try module.symbols.get(after_id);
    switch (after.binding) {
        .label => |label| {
            try std.testing.expectEqual(module.default_section.index, label.section.index);
            try std.testing.expectEqual(@as(u64, 1), label.offset);
        },
        else => return error.UnexpectedSymbolBinding,
    }
}

test "lowering defaults virtual output origin to active address" {
    var module = try lowerSource(
        std.testing.allocator,
        \\origin(0x7c00);
        \\emit.u8(0xaa);
        \\virtual.begin();
        \\emit.u8(0x11);
        \\virtual.end();
        \\
    ,
        .{},
    );
    defer module.deinit();

    const virtual_id = module.virtual_sections.items[0];
    const virtual = try module.sections.get(virtual_id);
    try std.testing.expectEqual(@as(u64, 0x7c01), virtual.origin);
}

test "lowering rejects unmatched virtual output boundaries" {
    try std.testing.expectError(
        error.UnmatchedVirtualEnd,
        lowerSource(
            std.testing.allocator,
            \\virtual.end();
            \\
        ,
            .{},
        ),
    );

    try std.testing.expectError(
        error.UnclosedVirtualOutput,
        lowerSource(
            std.testing.allocator,
            \\virtual.begin(0x1000);
            \\emit.u8(0x11);
            \\
        ,
            .{},
        ),
    );
}

test "lowering resolves sizeof type queries" {
    var module = try lowerSource(
        std.testing.allocator,
        \\packed struct SaveArea {
        \\    rax: u64,
        \\    rcx: u64,
        \\}
        \\pad(sizeof(SaveArea), 0);
        \\sub rsp, sizeof(SaveArea)
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqual(@as(usize, 16), bytes.data.len),
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .isa_instruction => |instruction| {
            try std.testing.expectEqualStrings("sub rsp, 16", instruction.text);
        },
        else => return error.UnexpectedFragment,
    }
}

test "lowering emits struct literals and lengthof values" {
    var module = try lowerSource(
        std.testing.allocator,
        \\packed struct DosHeader {
        \\    magic: u16,
        \\    lfanew: u32,
        \\}
        \\emit.u8(lengthof("AB"));
        \\emit.struct(DosHeader { magic: 0x5a4d, lfanew: 0x80 });
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 2), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 6), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0x4d), bytes.data[0]);
            try std.testing.expectEqual(@as(u8, 0x5a), bytes.data[1]);
            try std.testing.expectEqual(@as(u8, 0x80), bytes.data[2]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[3]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[4]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[5]);
        },
        else => return error.UnexpectedFragment,
    }
}

test "lowering emits stored struct values" {
    var module = try lowerSource(
        std.testing.allocator,
        \\packed struct DosHeader {
        \\    magic: u16 = 0x5a4d,
        \\    lfanew: u32,
        \\}
        \\const hdr: DosHeader = DosHeader { lfanew: 0x80 }
        \\emit.struct(hdr);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const hdr_id = module.symbols.lookup("hdr") orelse return error.MissingSymbol;
    const hdr_symbol = try module.symbols.get(hdr_id);
    switch (hdr_symbol.binding) {
        .value => |binding| {
            try std.testing.expectEqual(value_mod.Mutability.@"const", binding.mutability);
            const stored_struct = try binding.value.expectStruct();
            try std.testing.expectEqual(@as(usize, 2), stored_struct.fields.len);
            const magic = stored_struct.fieldByName("magic") orelse return error.MissingStructFieldValue;
            const lfanew = stored_struct.fieldByName("lfanew") orelse return error.MissingStructFieldValue;
            try std.testing.expectEqual(@as(u64, 0x5a4d), try magic.value.expectInteger());
            try std.testing.expectEqual(@as(u64, 0x80), try lfanew.value.expectInteger());
        },
        else => return error.UnexpectedSymbolBinding,
    }

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 6), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0x4d), bytes.data[0]);
            try std.testing.expectEqual(@as(u8, 0x5a), bytes.data[1]);
            try std.testing.expectEqual(@as(u8, 0x80), bytes.data[2]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[3]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[4]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[5]);
        },
        else => return error.UnexpectedFragment,
    }
}

test "lowering accesses stored struct fields" {
    var module = try lowerSource(
        std.testing.allocator,
        \\packed struct DosHeader {
        \\    magic: u16 = 0x5a4d,
        \\    lfanew: u32,
        \\}
        \\const hdr: DosHeader = DosHeader { lfanew: 0x80 }
        \\const magic: u16 = hdr.magic
        \\emit.u16(hdr.magic);
        \\emit.u32(hdr.lfanew);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const magic_id = module.symbols.lookup("magic") orelse return error.MissingSymbol;
    const magic_symbol = try module.symbols.get(magic_id);
    switch (magic_symbol.binding) {
        .value => |binding| {
            const integer = try binding.value.expectIntegerValue();
            try std.testing.expectEqual(@as(u64, 0x5a4d), integer.value);
            const u16_id = module.lookupTypeName("u16") orelse return error.UnknownTypeName;
            try std.testing.expectEqual(u16_id.index, integer.type_id.?.index);
        },
        else => return error.UnexpectedSymbolBinding,
    }

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqualSlices(u8, &.{ 0x4d, 0x5a }, bytes.data),
        else => return error.UnexpectedFragment,
    }
    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .bytes => |bytes| try std.testing.expectEqualSlices(u8, &.{ 0x80, 0x00, 0x00, 0x00 }, bytes.data),
        else => return error.UnexpectedFragment,
    }
}

test "lowering passes user struct values to Meta functions" {
    var module = try lowerSource(
        std.testing.allocator,
        \\packed struct DosHeader {
        \\    magic: u16 = 0x5a4d,
        \\    lfanew: u32,
        \\}
        \\fn emit_hdr(h: DosHeader) {
        \\    emit.struct(h);
        \\}
        \\const hdr: DosHeader = DosHeader { lfanew: 0x80 }
        \\emit_hdr(hdr);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqualSlices(u8, &.{ 0x4d, 0x5a, 0x80, 0x00, 0x00, 0x00 }, bytes.data),
        else => return error.UnexpectedFragment,
    }
}

test "lowering packs struct values as bytes" {
    var module = try lowerSource(
        std.testing.allocator,
        \\packed struct Header {
        \\    magic: u16 = 0x4241,
        \\    tail: u16,
        \\}
        \\const hdr: Header = Header { tail: 0x4443 }
        \\const packed_hdr: bytes = pack(hdr)
        \\assert(pack(hdr) == b"ABCD");
        \\emit.u8(lengthof(pack(hdr)));
        \\emit.bytes(packed_hdr);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const packed_id = module.symbols.lookup("packed_hdr") orelse return error.MissingSymbol;
    const packed_symbol = try module.symbols.get(packed_id);
    switch (packed_symbol.binding) {
        .value => |binding| try std.testing.expectEqualSlices(u8, "ABCD", try binding.value.expectBytes()),
        else => return error.UnexpectedSymbolBinding,
    }

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);
    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqualSlices(u8, &.{4}, bytes.data),
        else => return error.UnexpectedFragment,
    }
    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .bytes => |bytes| try std.testing.expectEqualSlices(u8, "ABCD", bytes.data),
        else => return error.UnexpectedFragment,
    }
}

test "lowering rejects unknown struct field access" {
    try std.testing.expectError(
        error.UnknownField,
        lowerSource(
            std.testing.allocator,
            \\packed struct DosHeader {
            \\    magic: u16 = 0x5a4d,
            \\}
            \\const hdr: DosHeader = DosHeader { }
            \\emit.u16(hdr.missing);
            \\
        ,
            .{},
        ),
    );
}

test "lowering emits struct literal default field values" {
    var module = try lowerSource(
        std.testing.allocator,
        \\packed struct DosHeader {
        \\    magic: u16 = 0x5a4d,
        \\    lfanew: u32 = 0x80,
        \\    checksum: u8,
        \\}
        \\emit.struct(DosHeader { checksum: 7 });
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 7), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0x4d), bytes.data[0]);
            try std.testing.expectEqual(@as(u8, 0x5a), bytes.data[1]);
            try std.testing.expectEqual(@as(u8, 0x80), bytes.data[2]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[3]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[4]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[5]);
            try std.testing.expectEqual(@as(u8, 7), bytes.data[6]);
        },
        else => return error.UnexpectedFragment,
    }
}

fn checkAggregateLiteralAllocationFailures(allocator: std.mem.Allocator) !void {
    var module = try lowerSource(
        allocator,
        \\packed struct Header {
        \\    magic: u16 = 0x5a4d,
        \\    offset: u32,
        \\}
        \\const header: Header = Header { offset: 0x80 };
        \\
    ,
        .{},
    );
    defer module.deinit();
}

test "aggregate literal construction handles every allocation failure" {
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        checkAggregateLiteralAllocationFailures,
        .{},
    );
}

fn checkLowerPipelineAllocationFailures(allocator: std.mem.Allocator) !void {
    var module = try lowerSource(
        allocator,
        \\packed struct Header {
        \\    magic: u16 = 0x5a4d,
        \\    offset: u32,
        \\}
        \\fn align_up(value: u64, alignment: u64) -> u64 {
        \\    return ((value + alignment - 1) / alignment) * alignment;
        \\}
        \\fn emit_pair(value: u64) {
        \\    emit.u8(value);
        \\    emit.u8(value + 1);
        \\}
        \\const header: Header = Header { offset: align_up(3, 4) };
        \\let items: list = list.of(1)
        \\list.push_mut(items, list.of(2));
        \\list.set_mut(items, 0, 3);
        \\let properties: map = map.new()
        \\map.set_mut(properties, "items", items);
        \\assert(list.eq(map.get(properties, "items"), list.of(3, list.of(2))));
        \\emit.struct(header);
        \\emit_pair(1);
        \\for item in list.of(2, 3) {
        \\    emit.u8(item);
        \\}
        \\for index in range(0, 2) {
        \\    emit.u8(index);
        \\}
        \\assert(load.u16(0) == 0x5a4d);
        \\defer {
        \\    assert(load.u16(0) == 0x5a4d);
        \\}
        \\late_layout {
        \\    emit.u8(4);
        \\}
        \\nop
        \\
    ,
        .{},
    );
    defer module.deinit();
}

test "lowering pipeline handles every allocation failure" {
    // Force copy-on-growth so heap-dependent remap success cannot change the
    // allocation count between the baseline and injected-failure runs.
    var no_resize = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
    try std.testing.checkAllAllocationFailures(
        no_resize.allocator(),
        checkLowerPipelineAllocationFailures,
        .{},
    );
}

fn checkFunctionArgumentAllocationFailures(allocator: Allocator) !void {
    var module = try lowerSource(allocator,
        \\const a: string = "caller"
        \\const b: string = "callee"
        \\fn pair(a: string, b: string) {
        \\    assert(a == "callee")
        \\    assert(b == "caller")
        \\}
        \\fn second(a: string, b: string) -> string {
        \\    return b
        \\}
        \\pair(b, a)
        \\assert(second(b, a) == "caller")
        \\fn nested() {
        \\    const a: string = "local"
        \\    assert(second(b, a) == "local")
        \\}
        \\nested()
    , .{});
    defer module.deinit();
}

test "function arguments resolve before callee parameter bindings" {
    try checkFunctionArgumentAllocationFailures(std.testing.allocator);
}

test "function argument construction handles every allocation failure" {
    var no_resize = std.testing.FailingAllocator.init(std.testing.allocator, .{ .resize_fail_index = 0 });
    try std.testing.checkAllAllocationFailures(no_resize.allocator(), checkFunctionArgumentAllocationFailures, .{});
}

test "partially evaluated function arguments are freed on a type error" {
    try std.testing.expectError(error.InvalidValueDeclaration, lowerSource(std.testing.allocator,
        \\fn pair(a: string, b: u64) {
        \\    db(a, b)
        \\}
        \\pair("owned", "wrong type")
    , .{}));
    try std.testing.expectError(error.InvalidExpression, lowerSource(std.testing.allocator,
        \\fn pair(a: string, b: u64) -> string {
        \\    return a
        \\}
        \\const result = pair("owned", "wrong type")
    , .{}));
}

fn checkIncludeAllocationFailures(allocator: std.mem.Allocator) !void {
    const files = [_]TestIncludeFile{
        .{ .path = "project/child.inc", .bytes = "emit.u8(0x42);" },
    };
    var resolver: TestIncludeResolver = .{ .files = &files };

    var module = try module_mod.Module.init(allocator, target.Target.default);
    defer module.deinit();
    try lowerSourceIntoModuleWithPathOptions(
        allocator,
        &module,
        "project/root.asm",
        "include(\"child.inc\");",
        .{ .include_resolver = .{
            .context = @ptrCast(&resolver),
            .resolve = TestIncludeResolver.resolve,
        } },
    );
}

test "include lowering handles every allocation failure" {
    try std.testing.checkAllAllocationFailures(
        std.testing.allocator,
        checkIncludeAllocationFailures,
        .{},
    );
}

test "fixed-width emit APIs reject overflowing integers" {
    try std.testing.expectError(error.InvalidApiInteger, lowerSource(std.testing.allocator, "emit.u8(256);", .{}));
    try std.testing.expectError(error.InvalidApiInteger, lowerSource(std.testing.allocator, "emit.u16(65536);", .{}));
    try std.testing.expectError(error.InvalidApiInteger, lowerSource(std.testing.allocator, "emit.u32(4294967296);", .{}));
}

test "lowering resolves const and let values in API and struct expressions" {
    var module = try lowerSource(
        std.testing.allocator,
        \\const header_size: u64 = 4 * 2;
        \\let fill = 0xcc;
        \\packed struct Header {
        \\    magic: u16 = 0xaa55,
        \\    lfanew: u32,
        \\}
        \\emit.u8(fill);
        \\reserve(header_size);
        \\emit.struct(Header { lfanew: header_size + 0x20 });
        \\
    ,
        .{},
    );
    defer module.deinit();

    const header_size_id = module.symbols.lookup("header_size") orelse return error.MissingSymbol;
    const header_size = try module.symbols.get(header_size_id);
    switch (header_size.binding) {
        .value => |binding| {
            try std.testing.expectEqual(.@"const", binding.mutability);
            try std.testing.expectEqual(@as(u64, 8), try binding.value.expectInteger());
        },
        else => return error.UnexpectedSymbolBinding,
    }

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 3), text.fragments.items.len);

    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 1), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0xcc), bytes.data[0]);
        },
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .reserve => |reserve| try std.testing.expectEqual(@as(u64, 8), reserve.size),
        else => return error.UnexpectedFragment,
    }

    switch (module.fragments.items.items[text.fragments.items[2].index]) {
        .bytes => |bytes| {
            try std.testing.expectEqual(@as(usize, 6), bytes.data.len);
            try std.testing.expectEqual(@as(u8, 0x55), bytes.data[0]);
            try std.testing.expectEqual(@as(u8, 0xaa), bytes.data[1]);
            try std.testing.expectEqual(@as(u8, 0x28), bytes.data[2]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[3]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[4]);
            try std.testing.expectEqual(@as(u8, 0x00), bytes.data[5]);
        },
        else => return error.UnexpectedFragment,
    }
}

test "lowering stores Phase 1 Meta value types" {
    var module = try lowerSource(
        std.testing.allocator,
        \\const ok: bool = true
        \\const name: string = "demo"
        \\const blob: bytes = b"AB"
        \\const word_ty: type = u32
        \\print(name, blob, word_ty);
        \\emit.bytes(blob);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const ok_id = module.symbols.lookup("ok") orelse return error.MissingSymbol;
    const ok_symbol = try module.symbols.get(ok_id);
    switch (ok_symbol.binding) {
        .value => |binding| {
            try std.testing.expectEqual(value_mod.Mutability.@"const", binding.mutability);
            try std.testing.expectEqual(true, try binding.value.expectBoolean());
        },
        else => return error.UnexpectedSymbolBinding,
    }

    const name_id = module.symbols.lookup("name") orelse return error.MissingSymbol;
    const name_symbol = try module.symbols.get(name_id);
    switch (name_symbol.binding) {
        .value => |binding| try std.testing.expectEqualStrings("demo", try binding.value.expectString()),
        else => return error.UnexpectedSymbolBinding,
    }

    const blob_id = module.symbols.lookup("blob") orelse return error.MissingSymbol;
    const blob_symbol = try module.symbols.get(blob_id);
    switch (blob_symbol.binding) {
        .value => |binding| try std.testing.expectEqualSlices(u8, "AB", try binding.value.expectBytes()),
        else => return error.UnexpectedSymbolBinding,
    }

    const word_ty_id = module.symbols.lookup("word_ty") orelse return error.MissingSymbol;
    const word_ty_symbol = try module.symbols.get(word_ty_id);
    switch (word_ty_symbol.binding) {
        .value => |binding| {
            const ty = try binding.value.expectType();
            const layout = try module.typeLayout(ty);
            try std.testing.expectEqual(@as(u64, 4), layout.size);
        },
        else => return error.UnexpectedSymbolBinding,
    }

    try std.testing.expectEqual(@as(usize, 1), module.diagnostics.items.items.len);
    try std.testing.expectEqualStrings("demo b\"AB\" type#0", module.diagnostics.items.items[0].message);

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqualSlices(u8, "AB", bytes.data),
        else => return error.UnexpectedFragment,
    }
}

test "lowering uses bool expressions for Meta if and assert" {
    var module = try lowerSource(
        std.testing.allocator,
        \\const enabled: bool = true
        \\if enabled && 1 < 2 {
        \\    assert(enabled, "must pass");
        \\    emit.u8(0xaa);
        \\}
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqual(@as(u8, 0xaa), bytes.data[0]),
        else => return error.UnexpectedFragment,
    }
}

test "lowering materializes instruction bytes for Meta conditions with output loads" {
    var module = try lowerSource(
        std.testing.allocator,
        \\start:
        \\nop
        \\if load.u8(start) == 0x90 {
        \\    emit.u8(0xaa);
        \\}
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);
    switch (module.fragments.items.items[text.fragments.items[1].index]) {
        .bytes => |bytes| try std.testing.expectEqualSlices(u8, &.{0xaa}, bytes.data),
        else => return error.UnexpectedFragment,
    }
}

test "lowering type-checks Meta function parameters" {
    var module = try lowerSource(
        std.testing.allocator,
        \\fn emit_blob(flag: bool, data: bytes, ty: type) {
        \\    if flag && ty == u16 {
        \\        emit.bytes(data);
        \\    }
        \\}
        \\emit_blob(true, b"XY", u16);
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .bytes => |bytes| try std.testing.expectEqualSlices(u8, "XY", bytes.data),
        else => return error.UnexpectedFragment,
    }
}

test "lowering rejects Meta value type mismatches" {
    try std.testing.expectError(
        error.InvalidValueDeclaration,
        lowerSource(
            std.testing.allocator,
            \\const bad: MissingType = 1
            \\
        ,
            .{},
        ),
    );

    try std.testing.expectError(
        error.InvalidValueDeclaration,
        lowerSource(
            std.testing.allocator,
            \\const bad: bool = 1
            \\
        ,
            .{},
        ),
    );

    try std.testing.expectError(
        error.InvalidValueDeclaration,
        lowerSource(
            std.testing.allocator,
            \\const bad: bytes = "text"
            \\
        ,
            .{},
        ),
    );

    try std.testing.expectError(
        error.InvalidValueDeclaration,
        lowerSource(
            std.testing.allocator,
            \\const bad: type = 1
            \\
        ,
            .{},
        ),
    );
}

test "lowering rejects Meta function argument type mismatches" {
    try std.testing.expectError(
        error.InvalidValueDeclaration,
        lowerSource(
            std.testing.allocator,
            \\fn need_bool(flag: bool) {
            \\    if flag {
            \\        emit.u8(1);
            \\    }
            \\}
            \\need_bool(1);
            \\
        ,
            .{},
        ),
    );
}

test "lowering rejects wrong struct argument type for Meta functions" {
    try std.testing.expectError(
        error.InvalidValueDeclaration,
        lowerSource(
            std.testing.allocator,
            \\packed struct DosHeader {
            \\    magic: u16 = 0x5a4d,
            \\}
            \\packed struct OtherHeader {
            \\    magic: u16 = 0xaa55,
            \\}
            \\fn emit_hdr(h: DosHeader) {
            \\    emit.struct(h);
            \\}
            \\emit_hdr(OtherHeader { });
            \\
        ,
            .{},
        ),
    );
}

test "lowering rejects struct value declaration type mismatches" {
    try std.testing.expectError(
        error.InvalidValueDeclaration,
        lowerSource(
            std.testing.allocator,
            \\packed struct DosHeader {
            \\    magic: u16 = 0x5a4d,
            \\}
            \\packed struct OtherHeader {
            \\    magic: u16 = 0xaa55,
            \\}
            \\const hdr: DosHeader = OtherHeader { }
            \\
        ,
            .{},
        ),
    );
}

test "lowering records ISA fragments without pass-owned fixups" {
    var module = try lowerSource(
        std.testing.allocator,
        \\entry:
        \\    jmp target
        \\target:
        \\    ret
        \\
    ,
        .{},
    );
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 0), module.fixups.items.items.len);

    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);
}

test "lowering keeps x86 branch hints inside ISA fragments" {
    var module = try lowerSource(
        std.testing.allocator,
        \\entry:
        \\    jmp short target
        \\target:
        \\    ret
        \\
    ,
        .{},
    );
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 0), module.fixups.items.items.len);
    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 2), text.fragments.items.len);
}

test "lowering keeps riscv registers inside ISA fragments" {
    var module = try lowerSource(
        std.testing.allocator,
        \\riscv.use64();
        \\target:
        \\    addi x1, x0, target
        \\
    ,
        .{},
    );
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 0), module.fixups.items.items.len);
    const text = try module.sections.get(module.default_section);
    try std.testing.expectEqual(@as(usize, 1), text.fragments.items.len);
}

test "lowering keeps ISA expression text for backend adapter pass" {
    var module = try lowerSource(
        std.testing.allocator,
        \\target:
        \\    mov rax, target + 4
        \\
    ,
        .{},
    );
    defer module.deinit();

    try std.testing.expectEqual(@as(usize, 0), module.fixups.items.items.len);
    const text = try module.sections.get(module.default_section);
    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .isa_instruction => |instruction| try std.testing.expectEqualStrings("mov rax, target + 4", instruction.text),
        else => return error.UnexpectedFragment,
    }
}

test "lowering substitutes compile-time integer symbols in ISA operands" {
    var module = try lowerSource(
        std.testing.allocator,
        \\const FIELD_OFFSET: u64 = 8;
        \\state:
        \\    mov eax, [rel state + FIELD_OFFSET]
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .isa_instruction => |instruction| try std.testing.expectEqualStrings("mov eax, [rel state + 8]", instruction.text),
        else => return error.UnexpectedFragment,
    }
}

test "lowering preserves x86 ISA words when constants share names" {
    var module = try lowerSource(
        std.testing.allocator,
        \\const rdx: u64 = 99;
        \\const SOME_CONST: u64 = 7;
        \\entry:
        \\    cmp rdx, SOME_CONST
        \\
    ,
        .{},
    );
    defer module.deinit();

    const text = try module.sections.get(module.default_section);
    switch (module.fragments.items.items[text.fragments.items[0].index]) {
        .isa_instruction => |instruction| try std.testing.expectEqualStrings("cmp rdx, 7", instruction.text),
        else => return error.UnexpectedFragment,
    }
}

test "lowering expression fixups can resolve label arithmetic" {
    var module = try lowerSource(
        std.testing.allocator,
        \\origin(0x1000);
        \\target:
        \\    mov rax, target + 4
        \\
    ,
        .{},
    );
    defer module.deinit();

    const encode_result = try pass.encodeInstructionFragments(std.testing.allocator, &module);
    try std.testing.expectEqual(@as(usize, 1), encode_result.encoded_count);
    var result = try pass.resolveFixups(std.testing.allocator, &module);
    defer result.deinit(std.testing.allocator);

    try std.testing.expectEqual(@as(usize, 1), result.resolved_count);
    try std.testing.expectEqual(@as(usize, 0), result.pending_count);
    switch (result.items[0]) {
        .resolved => |resolved| try std.testing.expectEqual(@as(u64, 0x1004), resolved.value),
        else => return error.UnexpectedResolveState,
    }
}

test "lowering rejects unknown struct literal fields" {
    try std.testing.expectError(
        error.UnknownField,
        lowerSource(
            std.testing.allocator,
            \\packed struct DosHeader {
            \\    magic: u16,
            \\}
            \\emit.struct(DosHeader { magic: 0x5a4d, missing: 1 });
            \\
        ,
            .{},
        ),
    );
}

test "lowering rejects duplicate struct literal fields" {
    try std.testing.expectError(
        error.DuplicateFieldName,
        lowerSource(
            std.testing.allocator,
            \\packed struct DosHeader {
            \\    magic: u16,
            \\}
            \\emit.struct(DosHeader { magic: 1, magic: 2 });
            \\
        ,
            .{},
        ),
    );
}

test "lowering rejects union literals with multiple active fields" {
    try std.testing.expectError(
        error.InvalidValueDeclaration,
        lowerSource(
            std.testing.allocator,
            \\union ValueBits {
            \\    raw: u32,
            \\    tag: u8,
            \\}
            \\const bad: ValueBits = ValueBits { raw: 1, tag: 2 }
            \\
        ,
            .{},
        ),
    );
}

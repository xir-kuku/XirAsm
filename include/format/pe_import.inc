// PE import table helpers for XIRASM.
//
// This file intentionally keeps PE32 and PE64 in one helper layer. The format
// data is the same except for thunk width, thunk alignment, and ordinal flag.
//
// Import sets use grouped Meta APIs that return updated maps:
//
// let imports: map = pe_import_new()
// imports = pe_import_use64_many(imports, "KERNEL32.DLL", list.of("ExitProcess", "VirtualAlloc"))
//
// Including a large Win32 API catalog should only define helper functions and metadata.
// Nothing is emitted until pe_import_emit32/64 is called for the final import
// set. This gives deterministic dead import elimination without hidden
// use-tracking magic or bridge state.

import("pe.inc");

const pe_import_descriptor_size: u64 = 20
const pe_import_hint_header_size: u64 = 2
const pe_import_ordinal32_flag: u64 = 0x80000000
const pe_import_ordinal64_flag: u64 = 0x8000000000000000

fn pe_import_new() -> map {
    return map.new();
}

fn pe_import_use32(imports: map, dll: string, name: string) -> map {
    assert(len(dll) > 0, "PE import DLL name is empty");
    assert(len(name) > 0, "PE import function name is empty");

    const entries: list = map.get_or(imports, dll, list.new());
    for entry in entries {
        if (map.get(entry, "slot") == name) {
            assert(map.get(entry, "name") == name, "PE import slot already maps to a different name");
            assert(map.get(entry, "kind") == 0, "PE import slot already maps to an ordinal");
            return imports;
        }
    }

    let next_entries: list = entries
    list.push_mut(next_entries, pe_import_name_entry(name, name));
    let next_imports: map = imports
    map.set_mut(next_imports, dll, next_entries);
    return next_imports;
}

fn pe_import_use64(imports: map, dll: string, name: string) -> map {
    assert(len(dll) > 0, "PE import DLL name is empty");
    assert(len(name) > 0, "PE import function name is empty");

    const entries: list = map.get_or(imports, dll, list.new());
    for entry in entries {
        if (map.get(entry, "slot") == name) {
            assert(map.get(entry, "name") == name, "PE import slot already maps to a different name");
            assert(map.get(entry, "kind") == 0, "PE import slot already maps to an ordinal");
            return imports;
        }
    }

    let next_entries: list = entries
    list.push_mut(next_entries, pe_import_name_entry(name, name));
    let next_imports: map = imports
    map.set_mut(next_imports, dll, next_entries);
    return next_imports;
}

fn pe_import_use32_many(imports: map, dll: string, names: list) -> map {
    let next_imports: map = imports
    for name in names {
        next_imports = pe_import_use32(next_imports, dll, name)
    }
    return next_imports;
}

fn pe_import_use64_many(imports: map, dll: string, names: list) -> map {
    let next_imports: map = imports
    for name in names {
        next_imports = pe_import_use64(next_imports, dll, name)
    }
    return next_imports;
}

fn pe_import_use32_as(imports: map, dll: string, name: string, slot: string) -> map {
    assert(len(dll) > 0, "PE import DLL name is empty");
    assert(len(name) > 0, "PE import function name is empty");
    assert(len(slot) > 0, "PE import slot label is empty");

    const entries: list = map.get_or(imports, dll, list.new());
    for entry in entries {
        if (map.get(entry, "slot") == slot) {
            assert(map.get(entry, "name") == name, "PE import slot already maps to a different name");
            assert(map.get(entry, "kind") == 0, "PE import slot already maps to an ordinal");
            return imports;
        }
    }

    let next_entries: list = entries
    list.push_mut(next_entries, pe_import_name_entry(slot, name));
    let next_imports: map = imports
    map.set_mut(next_imports, dll, next_entries);
    return next_imports;
}

fn pe_import_use64_as(imports: map, dll: string, name: string, slot: string) -> map {
    assert(len(dll) > 0, "PE import DLL name is empty");
    assert(len(name) > 0, "PE import function name is empty");
    assert(len(slot) > 0, "PE import slot label is empty");

    const entries: list = map.get_or(imports, dll, list.new());
    for entry in entries {
        if (map.get(entry, "slot") == slot) {
            assert(map.get(entry, "name") == name, "PE import slot already maps to a different name");
            assert(map.get(entry, "kind") == 0, "PE import slot already maps to an ordinal");
            return imports;
        }
    }

    let next_entries: list = entries
    list.push_mut(next_entries, pe_import_name_entry(slot, name));
    let next_imports: map = imports
    map.set_mut(next_imports, dll, next_entries);
    return next_imports;
}

fn pe_import_use32_pairs(imports: map, dll: string, pairs: list) -> map {
    assert(len(pairs) % 2 == 0, "PE32 import pairs require slot/name entries");
    assert(len(pairs) <= 128, "PE32 import pairs exceed the batch limit");
    return pe_import_use_pairs_from(imports, dll, pairs, 0);
}

fn pe_import_use64_pairs(imports: map, dll: string, pairs: list) -> map {
    assert(len(pairs) % 2 == 0, "PE64 import pairs require slot/name entries");
    assert(len(pairs) <= 128, "PE64 import pairs exceed the batch limit");
    return pe_import_use_pairs_from(imports, dll, pairs, 0);
}

fn pe_import_use_pairs_from(imports: map, dll: string, pairs: list, index: u64) -> map {
    if index == len(pairs) {
        return imports;
    }
    const slot: string = list.get(pairs, index)
    const name: string = list.get(pairs, index + 1)
    const next_imports: map = pe_import_append_named(imports, dll, name, slot)
    return pe_import_use_pairs_from(next_imports, dll, pairs, index + 2);
}

fn pe_import_append_named(imports: map, dll: string, name: string, slot: string) -> map {
    assert(len(dll) > 0, "PE import DLL name is empty");
    assert(len(name) > 0, "PE import function name is empty");
    assert(len(slot) > 0, "PE import slot label is empty");
    const entries: list = map.get_or(imports, dll, list.new());
    for entry in entries {
        if map.get(entry, "slot") == slot {
            assert(map.get(entry, "name") == name, "PE import slot already maps to a different name");
            assert(map.get(entry, "kind") == 0, "PE import slot already maps to an ordinal");
            return imports;
        }
    }
    let next_entries: list = entries
    list.push_mut(next_entries, pe_import_name_entry(slot, name));
    let next_imports: map = imports
    map.set_mut(next_imports, dll, next_entries);
    return next_imports;
}

fn pe_import_use32_ordinal_as(imports: map, dll: string, ordinal: u64, slot: string) -> map {
    assert(len(dll) > 0, "PE import DLL name is empty");
    assert(len(slot) > 0, "PE import slot label is empty");
    assert(ordinal <= 0xffff, "PE import ordinal is out of range");

    const entries: list = map.get_or(imports, dll, list.new());
    for entry in entries {
        if (map.get(entry, "slot") == slot) {
            assert(map.get(entry, "kind") == 1, "PE import slot already maps to a named import");
            assert(map.get(entry, "ordinal") == ordinal, "PE import slot already maps to a different ordinal");
            return imports;
        }
    }

    let next_entries: list = entries
    list.push_mut(next_entries, pe_import_ordinal_entry(slot, ordinal));
    let next_imports: map = imports
    map.set_mut(next_imports, dll, next_entries);
    return next_imports;
}

fn pe_import_use64_ordinal_as(imports: map, dll: string, ordinal: u64, slot: string) -> map {
    assert(len(dll) > 0, "PE import DLL name is empty");
    assert(len(slot) > 0, "PE import slot label is empty");
    assert(ordinal <= 0xffff, "PE import ordinal is out of range");

    const entries: list = map.get_or(imports, dll, list.new());
    for entry in entries {
        if (map.get(entry, "slot") == slot) {
            assert(map.get(entry, "kind") == 1, "PE import slot already maps to a named import");
            assert(map.get(entry, "ordinal") == ordinal, "PE import slot already maps to a different ordinal");
            return imports;
        }
    }

    let next_entries: list = entries
    list.push_mut(next_entries, pe_import_ordinal_entry(slot, ordinal));
    let next_imports: map = imports
    map.set_mut(next_imports, dll, next_entries);
    return next_imports;
}

fn pe_import_name_entry(slot: string, name: string) -> map {
    assert(!contains(name, "\0"), "PE import name contains an embedded NUL");
    let entry: map = map.new()
    map.set_mut(entry, "slot", slot);
    map.set_mut(entry, "name", name);
    map.set_mut(entry, "kind", 0);
    map.set_mut(entry, "hint", 0);
    return entry;
}

fn pe_import_ordinal_entry(slot: string, ordinal: u64) -> map {
    let entry: map = map.new()
    map.set_mut(entry, "slot", slot);
    map.set_mut(entry, "ordinal", ordinal);
    map.set_mut(entry, "kind", 1);
    map.set_mut(entry, "hint", 0);
    return entry;
}

fn pe_import_descriptor(lookup_rva: u64, dll_name_rva: u64, address_rva: u64) {
    emit.u32(lookup_rva);
    emit.u32(0);
    emit.u32(0);
    emit.u32(dll_name_rva);
    emit.u32(address_rva);
}

fn pe_import_descriptor_null() {
    pe_import_descriptor(0, 0, 0);
}

fn pe_import_thunk32_name(hint_name_rva: u64) {
    emit.u32(hint_name_rva);
}

fn pe_import_thunk64_name(hint_name_rva: u64) {
    emit.u64(hint_name_rva);
}

fn pe_import_thunk32_ordinal(ordinal: u64) {
    assert(ordinal <= 0xffff, "PE32 import ordinal is out of range");
    emit.u32(pe_import_ordinal32_flag | ordinal);
}

fn pe_import_thunk64_ordinal(ordinal: u64) {
    assert(ordinal <= 0xffff, "PE64 import ordinal is out of range");
    emit.u64(pe_import_ordinal64_flag | ordinal);
}

fn pe_import_thunk32_null() {
    emit.u32(0);
}

fn pe_import_thunk64_null() {
    emit.u64(0);
}

fn pe_import_hint_name(hint: u64, name: string) {
    assert(hint <= 0xffff, "PE import hint is out of range");
    assert(len(name) > 0, "PE import hint-name text is empty");
    assert(!contains(name, "\0"), "PE import name contains an embedded NUL");
    emit.u16(hint);
    db(name, 0);
    align(2, 0);
}

fn pe_import_emit32(imports: map, idata_rva: u64, idata_start: u64) {
    pe_import_emit(imports, idata_rva, idata_start, 4);
}

fn pe_import_emit64(imports: map, idata_rva: u64, idata_start: u64) {
    pe_import_emit(imports, idata_rva, idata_start, 8);
}

fn pe_import_emit(imports: map, idata_rva: u64, idata_start: u64, thunk_size: u64) {
    assert(thunk_size == 4 || thunk_size == 8, "PE import thunk size must be 4 or 8");

    const dlls: list = map.keys(imports);
    for dll in dlls {
        assert(len(dll) > 0 && !contains(dll, "\0"), "PE import DLL name contains an embedded NUL or is empty");
        const entries: list = map.get(imports, dll);
        pe_import_emit_hint_names(dll, entries);
        pe_import_emit_dll_name(dll);
        pe_import_emit_lookup_table(dll, entries, idata_rva, idata_start, thunk_size);
        pe_import_emit_address_table(dll, entries, idata_rva, idata_start, thunk_size);
    }

    label.define("pe_import_descriptors");
    for dll in dlls {
        pe_import_descriptor(pe_import_label_rva(pe_import_lookup_label(dll), idata_rva, idata_start), pe_import_label_rva(pe_import_dll_name_label(dll), idata_rva, idata_start), pe_import_label_rva(pe_import_address_label(dll), idata_rva, idata_start));
    }
    pe_import_descriptor_null();
    label.define("pe_import_descriptors_end");
}

fn pe_import_emit_hint_names(dll: string, entries: list) {
    align(2, 0);
    for entry in entries {
        if (map.get(entry, "kind") == 0) {
            label.define(pe_import_hint_label(dll, map.get(entry, "slot")));
            pe_import_hint_name(map.get(entry, "hint"), map.get(entry, "name"));
        }
    }
}

fn pe_import_emit_dll_name(dll: string) {
    align(2, 0);
    label.define(pe_import_dll_name_label(dll));
    db(dll, 0);
    align(2, 0);
}

fn pe_import_emit_lookup_table(dll: string, entries: list, idata_rva: u64, idata_start: u64, thunk_size: u64) {
    align(thunk_size, 0);
    label.define(pe_import_lookup_label(dll));
    for entry in entries {
        pe_import_emit_thunk(dll, entry, idata_rva, idata_start, thunk_size);
    }
    pe_import_emit_null_thunk(thunk_size);
}

fn pe_import_emit_address_table(dll: string, entries: list, idata_rva: u64, idata_start: u64, thunk_size: u64) {
    label.define(pe_import_address_label(dll));
    for entry in entries {
        label.define(map.get(entry, "slot"));
        pe_import_emit_thunk(dll, entry, idata_rva, idata_start, thunk_size);
    }
    pe_import_emit_null_thunk(thunk_size);
}

fn pe_import_emit_thunk(dll: string, entry: map, idata_rva: u64, idata_start: u64, thunk_size: u64) {
    if (map.get(entry, "kind") == 1) {
        pe_import_emit_ordinal_thunk(map.get(entry, "ordinal"), thunk_size);
    }
    if (map.get(entry, "kind") == 0) {
        const hint_rva: u64 = pe_import_label_rva(pe_import_hint_label(dll, map.get(entry, "slot")), idata_rva, idata_start);
        if (thunk_size == 4) {
            pe_import_thunk32_name(hint_rva);
        }
        if (thunk_size == 8) {
            pe_import_thunk64_name(hint_rva);
        }
    }
}

fn pe_import_emit_ordinal_thunk(ordinal: u64, thunk_size: u64) {
    if (thunk_size == 4) {
        pe_import_thunk32_ordinal(ordinal);
    }
    if (thunk_size == 8) {
        pe_import_thunk64_ordinal(ordinal);
    }
}

fn pe_import_emit_null_thunk(thunk_size: u64) {
    if (thunk_size == 4) {
        pe_import_thunk32_null();
    }
    if (thunk_size == 8) {
        pe_import_thunk64_null();
    }
}

fn pe_import_label_rva(name: string, idata_rva: u64, idata_start: u64) -> u64 {
    return idata_rva + (label_addr(name) - idata_start);
}

fn pe_import_lookup_label(dll: string) -> string {
    return sym.join("pe_import_", pe_import_label_part(dll), "_lookup");
}

fn pe_import_address_label(dll: string) -> string {
    return sym.join("pe_import_", pe_import_label_part(dll), "_iat");
}

fn pe_import_dll_name_label(dll: string) -> string {
    return sym.join("pe_import_", pe_import_label_part(dll), "_name");
}

fn pe_import_hint_label(dll: string, slot: string) -> string {
    return sym.join("pe_import_", pe_import_label_part(dll), "_", pe_import_label_part(slot), "_hint");
}

fn pe_import_label_part(text: string) -> string {
    const lower_text: string = lower(text);
    const dot_text: string = replace(lower_text, ".", "_");
    const dash_text: string = replace(dot_text, "-", "_");
    const space_text: string = replace(dash_text, " ", "_");
    const at_text: string = replace(space_text, "@", "_");
    const hash_text: string = replace(at_text, "#", "_");
    return replace(hash_text, "$", "_");
}

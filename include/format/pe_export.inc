// PE export table helpers for XIRASM.
//
// Export sets use explicit value-style Meta APIs. Nothing is emitted until
// pe_export_emit32/64 is called from the final .edata placement point.
//
// Export names are sorted by their emitted byte representation before the PE
// address, name-pointer, and ordinal tables are written. Callers provide semantic
// declarations only and do not need to know the PE name-table ordering rule.

import("pe.inc");

const pe_export_directory_size: u64 = 40
const pe_export_ordinal_base: u64 = 1

fn pe_export_new() -> list {
    return list.new();
}

fn pe_export_use32(exports: list, target_label: string, export_name: string) -> list {
    return pe_export_use(exports, target_label, export_name);
}

fn pe_export_use64(exports: list, target_label: string, export_name: string) -> list {
    return pe_export_use(exports, target_label, export_name);
}

fn pe_export_use32_many(exports: list, names: list) -> list {
    let next_exports: list = exports
    for name in names {
        next_exports = pe_export_use32(next_exports, name, name)
    }
    return next_exports;
}

fn pe_export_use64_many(exports: list, names: list) -> list {
    let next_exports: list = exports
    for name in names {
        next_exports = pe_export_use64(next_exports, name, name)
    }
    return next_exports;
}

fn pe_export_use32_pairs(exports: list, pairs: list) -> list {
    assert(len(pairs) % 2 == 0, "PE32 export pairs require target/name entries");
    assert(len(pairs) <= 128, "PE32 export pairs exceed the batch limit");
    return pe_export_use_pairs_from(exports, pairs, 0);
}

fn pe_export_use64_pairs(exports: list, pairs: list) -> list {
    assert(len(pairs) % 2 == 0, "PE64 export pairs require target/name entries");
    assert(len(pairs) <= 128, "PE64 export pairs exceed the batch limit");
    return pe_export_use_pairs_from(exports, pairs, 0);
}

fn pe_export_use_pairs_from(exports: list, pairs: list, index: u64) -> list {
    if index == len(pairs) {
        return exports;
    }
    const target_label: string = list.get(pairs, index)
    const export_name: string = list.get(pairs, index + 1)
    const next_exports: list = pe_export_append_pair(exports, target_label, export_name)
    return pe_export_use_pairs_from(next_exports, pairs, index + 2);
}

fn pe_export_append_pair(exports: list, target_label: string, export_name: string) -> list {
    assert(len(target_label) > 0, "PE export target label is empty");
    assert(len(export_name) > 0, "PE export name is empty");
    for entry in exports {
        if (map.get(entry, "name") == export_name) {
            assert(map.get(entry, "target") == target_label, "PE export name already maps to a different target");
            return exports;
        }
    }
    let next_exports: list = exports
    list.push_mut(next_exports, pe_export_entry(target_label, export_name));
    return next_exports;
}

fn pe_export_use(exports: list, target_label: string, export_name: string) -> list {
    assert(len(target_label) > 0, "PE export target label is empty");
    assert(len(export_name) > 0, "PE export name is empty");

    for entry in exports {
        if (map.get(entry, "name") == export_name) {
            assert(map.get(entry, "target") == target_label, "PE export name already maps to a different target");
            return exports;
        }
    }

    let next_exports: list = exports
    list.push_mut(next_exports, pe_export_entry(target_label, export_name));
    return next_exports;
}

fn pe_export_entry(target_label: string, export_name: string) -> map {
    assert(!contains(export_name, "\0"), "PE export name contains an embedded NUL");
    let entry: map = map.new()
    map.set_mut(entry, "target", target_label);
    map.set_mut(entry, "name", export_name);
    return entry;
}

fn pe_export_emit32(exports: list, dll_name: string, edata_rva: u64, edata_start: u64) {
    pe_export_emit(exports, dll_name, edata_rva, edata_start, pe_default_image_base32);
}

fn pe_export_emit64(exports: list, dll_name: string, edata_rva: u64, edata_start: u64) {
    pe_export_emit(exports, dll_name, edata_rva, edata_start, pe_default_image_base64);
}

fn pe_export_emit(exports: list, dll_name: string, edata_rva: u64, edata_start: u64, image_base: u64) {
    assert(len(exports) > 0, "PE export table requires at least one export");
    assert(len(dll_name) > 0, "PE export DLL name is empty");
    assert(!contains(dll_name, "\0"), "PE export DLL name contains an embedded NUL");
    assert(len(exports) <= 0x10000, "PE export name ordinal exceeds 16 bits");

    virtual.begin(0);
    let sortable_exports = list.new()
    for entry in exports {
        const name: string = map.get(entry, "name")
        let prepared: map = entry
        map.set_mut(prepared, "sort_address", here());
        map.set_mut(prepared, "sort_length", len(name));
        list.push_mut(sortable_exports, prepared);
        db(name);
    }
    const sorted_exports: list = pe_export_sort_entries(sortable_exports)
    virtual.end();

    label.define("pe_export_directory");
    pe_export_directory(0, pe_export_ordinal_base, len(sorted_exports), len(sorted_exports), 0, 0, 0);

    label.define("pe_export_dll_name");
    db(dll_name, 0);
    align(4, 0);

    label.define("pe_export_address_table");
    for entry in sorted_exports {
        emit.u32(label_addr(map.get(entry, "target")) - image_base);
    }

    label.define("pe_export_ordinal_table");
    for i in range(0, len(sorted_exports)) {
        emit.u16(i);
    }
    align(4, 0);

    for i in range(0, len(sorted_exports)) {
        const entry: map = list.get(sorted_exports, i);
        label.define(pe_export_name_label(i));
        db(map.get(entry, "name"), 0);
    }
    align(4, 0);

    label.define("pe_export_name_pointer_table");
    for i in range(0, len(sorted_exports)) {
        emit.u32(pe_export_label_rva(pe_export_name_label(i), edata_rva, edata_start));
    }

    label.define("pe_export_directory_end");
    store.u32(pe_export_directory + 12, pe_export_label_rva("pe_export_dll_name", edata_rva, edata_start));
    store.u32(pe_export_directory + 28, pe_export_label_rva("pe_export_address_table", edata_rva, edata_start));
    store.u32(pe_export_directory + 32, pe_export_label_rva("pe_export_name_pointer_table", edata_rva, edata_start));
    store.u32(pe_export_directory + 36, pe_export_label_rva("pe_export_ordinal_table", edata_rva, edata_start));
}

fn pe_export_sort_entries(exports: list) -> list {
    let sorted: list = exports
    let index = 1
    while index < len(exports) {
        const entry: map = list.get(sorted, index);
        let insert_index = index
        while insert_index > 0 {
            const previous: map = list.get(sorted, insert_index - 1);
            const should_move: bool = pe_export_name_less(entry, previous);
            if should_move {
                list.set_mut(sorted, insert_index, previous);
                insert_index = insert_index - 1
                continue;
            }
            break;
        }
        list.set_mut(sorted, insert_index, entry);
        index = index + 1
    }
    return sorted;
}

fn pe_export_name_less(left: map, right: map) -> bool {
    const left_address: u64 = map.get(left, "sort_address")
    const right_address: u64 = map.get(right, "sort_address")
    const left_length: u64 = map.get(left, "sort_length")
    const right_length: u64 = map.get(right, "sort_length")

    let common_length = left_length
    if right_length < common_length {
        common_length = right_length
    }

    let index = 0
    while index < common_length {
        const left_byte: u64 = load.u8(left_address + index)
        const right_byte: u64 = load.u8(right_address + index)
        if left_byte < right_byte {
            return true;
        }
        if left_byte > right_byte {
            return false;
        }
        index = index + 1
    }

    return left_length < right_length;
}

fn pe_export_directory(dll_name_rva: u64, ordinal_base: u64, function_count: u64, name_count: u64, address_table_rva: u64, name_pointer_table_rva: u64, ordinal_table_rva: u64) {
    emit.u32(0);
    emit.u32(0);
    emit.u16(0);
    emit.u16(0);
    emit.u32(dll_name_rva);
    emit.u32(ordinal_base);
    emit.u32(function_count);
    emit.u32(name_count);
    emit.u32(address_table_rva);
    emit.u32(name_pointer_table_rva);
    emit.u32(ordinal_table_rva);
}

fn pe_export_label_rva(name: string, edata_rva: u64, edata_start: u64) -> u64 {
    return edata_rva + (label_addr(name) - edata_start);
}

fn pe_export_name_label(index: u64) -> string {
    return sym.join("pe_export_name_", to_string(index));
}

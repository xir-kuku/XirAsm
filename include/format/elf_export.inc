// ELF64 shared-object export helpers for XIRASM.
//
// Export sets use explicit value-style Meta APIs. Including a large catalog
// should define metadata and helper functions only; nothing is emitted until
// elf_export_* emitters are called at the chosen .dynsym/.dynstr/.hash/.dynamic
// placement points. This keeps export generation deterministic and avoids a
// hidden global state machine.

import("elfso.inc");

fn elf_export_new() -> list {
    return list.new();
}

fn elf_export_use64(exports: list, target_label: string, export_name: string, section_index: u64, symbol_size: u64) -> list {
    assert(len(target_label) > 0, "ELF export target label is empty");
    assert(len(export_name) > 0, "ELF export name is empty");

    for entry in exports {
        if (map.get(entry, "name") == export_name) {
            assert(map.get(entry, "target") == target_label, "ELF export name already maps to a different target");
            return exports;
        }
    }

    let next_exports: list = exports
    list.push_mut(next_exports, elf_export_entry(target_label, export_name, section_index, symbol_size));
    return next_exports;
}

fn elf_export_use64_many(exports: list, names: list, section_index: u64, symbol_size: u64) -> list {
    let next_exports: list = exports
    for name in names {
        next_exports = elf_export_use64(next_exports, name, name, section_index, symbol_size)
    }
    return next_exports;
}

fn elf_export_use64_pairs(exports: list, pairs: list, section_index: u64, symbol_size: u64) -> list {
    assert(len(pairs) % 2 == 0, "ELF export pairs require target/name entries");
    assert(len(pairs) <= 128, "ELF export pairs exceed the batch limit");
    return elf_export_use64_pairs_from(exports, pairs, section_index, symbol_size, 0);
}

fn elf_export_use64_pairs_from(exports: list, pairs: list, section_index: u64, symbol_size: u64, index: u64) -> list {
    if index == len(pairs) {
        return exports;
    }
    const target_label: string = list.get(pairs, index)
    const export_name: string = list.get(pairs, index + 1)
    const next_exports: list = elf_export_use64(exports, target_label, export_name, section_index, symbol_size)
    return elf_export_use64_pairs_from(next_exports, pairs, section_index, symbol_size, index + 2);
}

fn elf_export_entry(target_label: string, export_name: string, section_index: u64, symbol_size: u64) -> map {
    assert(elf_validate_c_name(export_name), "invalid ELF export name");
    let entry: map = map.new()
    map.set_mut(entry, "target", target_label);
    map.set_mut(entry, "name", export_name);
    map.set_mut(entry, "section", section_index);
    map.set_mut(entry, "size", symbol_size);
    return entry;
}

fn elf_export_emit_dynsym64(exports: list, first_export_name_offset: u64) {
    elfso_sym64(0, 0, elf_shn_undef, 0, 0);
    for i in range(0, len(exports)) {
        const entry: map = list.get(exports, i);
        elfso_sym64(first_export_name_offset + elf_export_name_offset(exports, i), elfso_st_info(elf_stb_global, elf_stt_func), map.get(entry, "section"), label_addr(map.get(entry, "target")), map.get(entry, "size"));
    }
}

fn elf_export_emit_dynstr64(exports: list, soname: string) {
    db(0);
    for entry in exports {
        db(map.get(entry, "name"), 0);
    }
    db(soname, 0);
}

fn elf_export_emit_dynamic64(dynstr_vaddr: u64, dynstr_size: u64, dynsym_vaddr: u64, hash_vaddr: u64, soname_offset: u64) {
    elfso_dyn64(elf_dt_hash, hash_vaddr);
    elfso_dyn64(elf_dt_strtab, dynstr_vaddr);
    elfso_dyn64(elf_dt_strsz, dynstr_size);
    elfso_dyn64(elf_dt_symtab, dynsym_vaddr);
    elfso_dyn64(elf_dt_syment, elfso_sym64_size);
    elfso_dyn64(elf_dt_soname, soname_offset);
    elfso_dyn64(elf_dt_null, 0);
}

fn elf_export_hash(exports: list) {
    dd(1);
    dd(len(exports) + 1);
    if (len(exports) > 0) {
        dd(1);
    }
    if (len(exports) == 0) {
        dd(0);
    }
    dd(0);
    for i in range(1, len(exports) + 1) {
        if (i < len(exports)) {
            dd(i + 1);
        }
        if (i == len(exports)) {
            dd(0);
        }
    }
}

fn elf_export_hash_size(exports: list) -> u64 {
    return 12 + (len(exports) + 1) * 4;
}

fn elf_export_dynstr_size(exports: list, soname: string) -> u64 {
    return 1 + elf_export_names_size(exports) + len(soname) + 1;
}

fn elf_export_names_size(exports: list) -> u64 {
    const size: u64 = 0;
    return elf_export_names_size_from(exports, 0, size);
}

fn elf_export_names_size_from(exports: list, index: u64, size: u64) -> u64 {
    if (index == len(exports)) {
        return size;
    }
    const entry: map = list.get(exports, index);
    return elf_export_names_size_from(exports, index + 1, size + len(map.get(entry, "name")) + 1);
}

fn elf_export_name_offset(exports: list, index: u64) -> u64 {
    const offset: u64 = 0;
    return elf_export_name_offset_from(exports, index, 0, offset);
}

fn elf_export_name_offset_from(exports: list, target_index: u64, index: u64, offset: u64) -> u64 {
    if (index == target_index) {
        return offset;
    }
    const entry: map = list.get(exports, index);
    return elf_export_name_offset_from(exports, target_index, index + 1, offset + len(map.get(entry, "name")) + 1);
}

// ELF64 shared-object import helpers for XIRASM.
//
// This layer deliberately models imports through explicit value-style Meta APIs.
// Including a large catalog should only define helper functions and metadata;
// nothing is emitted until elfso_import_* emitters are called with the final
// import set. The current usable model emits writable import slots plus
// .dynsym, .dynstr, .rela.dyn, and .dynamic entries. Each slot receives a
// R_X86_64_64 dynamic relocation, so generated code can load or call through
// the slot without hardcoding the final imported address:
//
//     call [rel puts_slot]
//     mov rax, [rel puts_slot]
//
// PLT/GOT helpers are explicit too: callers choose the .plt, .got.plt and
// .rela.plt placement, then emit DT_JMPREL/DT_PLTRELSZ/DT_PLTREL/DT_PLTGOT
// rows through elfso_import_emit_dynamic64_plt.

import("elfso.inc");

const elfso_import_rela64_size: u64 = 24
const elfso_import_plt0_size: u64 = 16
const elfso_import_plt_entry_size: u64 = 16
const elfso_import_gotplt_reserved_entries: u64 = 3
const elfso_import_gotplt_entry_size: u64 = 8

packed struct ElfSoRela64 {
    offset: u64,
    info: u64,
    addend: u64 = 0,
}

fn elfso_import_new() -> list {
    return list.new();
}

fn elfso_import_use64(imports: list, library: string, name: string) -> list {
    return elfso_import_use64_as(imports, library, name, name);
}

fn elfso_import_use64_many(imports: list, library: string, names: list) -> list {
    let next_imports: list = imports
    for name in names {
        next_imports = elfso_import_use64(next_imports, library, name)
    }
    return next_imports;
}

fn elfso_import_use64_pairs(imports: list, library: string, pairs: list) -> list {
    assert(len(pairs) % 2 == 0, "ELF SO import pairs require slot/name entries");
    assert(len(pairs) <= 128, "ELF SO import pairs exceed the batch limit");
    return elfso_import_use64_pairs_from(imports, library, pairs, 0);
}

fn elfso_import_use64_pairs_from(imports: list, library: string, pairs: list, index: u64) -> list {
    if index == len(pairs) {
        return imports;
    }
    const slot: string = list.get(pairs, index)
    const name: string = list.get(pairs, index + 1)
    const next_imports: list = elfso_import_use64_as(imports, library, name, slot)
    return elfso_import_use64_pairs_from(next_imports, library, pairs, index + 2);
}

fn elfso_import_use64_as(imports: list, library: string, name: string, slot: string) -> list {
    assert(elf_validate_c_name(library) && elf_validate_c_name(name), "invalid ELF SO import name");
    assert(len(library) > 0, "ELF SO import library name is empty");
    assert(len(name) > 0, "ELF SO import symbol name is empty");
    assert(len(slot) > 0, "ELF SO import slot label is empty");

    for entry in imports {
        if (map.get(entry, "slot") == slot) {
            assert(map.get(entry, "library") == library, "ELF SO import slot already maps to a different library");
            assert(map.get(entry, "name") == name, "ELF SO import slot already maps to a different symbol");
            return imports;
        }
    }

    let next_imports: list = imports
    list.push_mut(next_imports, elfso_import_entry(library, name, slot));
    return next_imports;
}

fn elfso_import_use64_plt(imports: list, library: string, name: string) -> list {
    return elfso_import_use64_plt_as(imports, library, name, sym.join(name, "_gotplt"), sym.join(name, "_plt"));
}

fn elfso_import_use64_plt_many(imports: list, library: string, names: list) -> list {
    let next_imports: list = imports
    for name in names {
        next_imports = elfso_import_use64_plt(next_imports, library, name)
    }
    return next_imports;
}

fn elfso_import_use64_plt_pairs(imports: list, library: string, pairs: list) -> list {
    assert(len(pairs) % 2 == 0, "ELF SO PLT import pairs require local/name entries");
    assert(len(pairs) <= 128, "ELF SO PLT import pairs exceed the batch limit");
    let next_imports: list = imports
    let index: u64 = 0
    while index < len(pairs) {
        const local_name: string = list.get(pairs, index)
        const import_name: string = list.get(pairs, index + 1)
        next_imports = elfso_import_use64_plt_as(
            next_imports,
            library,
            import_name,
            sym.join(local_name, "_gotplt"),
            sym.join(local_name, "_plt")
        )
        index = index + 2
    }
    return next_imports;
}

fn elfso_import_use64_plt_as(imports: list, library: string, name: string, slot: string, plt: string) -> list {
    assert(len(plt) > 0, "ELF SO import PLT label is empty");
    let next_imports: list = elfso_import_use64_as(imports, library, name, slot)
    for i in range(0, len(next_imports)) {
        const entry: map = list.get(next_imports, i)
        if map.get(entry, "slot") != slot {
            continue;
        }

        let with_plt: map = entry
        map.set_mut(with_plt, "plt", plt);
        list.set_mut(next_imports, i, with_plt);
        return next_imports;
    }
    assert(false, "ELF SO import slot was not recorded");
    return next_imports;
}

fn elfso_import_entry(library: string, name: string, slot: string) -> map {
    let entry: map = map.new()
    map.set_mut(entry, "library", library);
    map.set_mut(entry, "name", name);
    map.set_mut(entry, "slot", slot);
    return entry;
}

fn elfso_import_r_info64(symbol_index: u64, reloc_type: u64) -> u64 {
    return symbol_index * 0x100000000 + reloc_type;
}

fn elfso_import_rela64(offset: u64, symbol_index: u64, reloc_type: u64, addend: u64) {
    emit.struct(ElfSoRela64 { offset: offset, info: elfso_import_r_info64(symbol_index, reloc_type), addend: addend });
}

fn elfso_import_rel32(target: u64, next_ip: u64) -> u64 {
    if (target >= next_ip) {
        const delta: u64 = target - next_ip;
        assert(delta <= 0x7fffffff, "ELF SO PLT forward displacement does not fit rel32");
        return delta;
    }
    const delta: u64 = next_ip - target;
    assert(delta <= 0x80000000, "ELF SO PLT backward displacement does not fit rel32");
    return 0x100000000 - delta;
}

fn elfso_import_plt_size(imports: list) -> u64 {
    return elfso_import_plt0_size + len(imports) * elfso_import_plt_entry_size;
}

fn elfso_import_gotplt_size(imports: list) -> u64 {
    return (elfso_import_gotplt_reserved_entries + len(imports)) * elfso_import_gotplt_entry_size;
}

fn elfso_import_rela_plt_size(imports: list) -> u64 {
    return len(imports) * elfso_import_rela64_size;
}

fn elfso_import_dynamic_plt_size(imports: list) -> u64 {
    return (10 + len(elfso_import_libraries(imports))) * elfso_dyn64_size;
}

fn elfso_import_emit_slots64(imports: list) {
    for entry in imports {
        label.define(map.get(entry, "slot"));
        dq(0);
    }
}

fn elfso_import_emit_plt64(imports: list, plt_vaddr: u64, gotplt_vaddr: u64) {
    db(0xff, 0x35);
    dd(elfso_import_rel32(gotplt_vaddr + 8, plt_vaddr + 6));
    db(0xff, 0x25);
    dd(elfso_import_rel32(gotplt_vaddr + 16, plt_vaddr + 12));
    db(0x0f, 0x1f, 0x40, 0x00);

    for i in range(0, len(imports)) {
        const entry: map = list.get(imports, i);
        const entry_vaddr: u64 = plt_vaddr + elfso_import_plt0_size + i * elfso_import_plt_entry_size;
        const got_slot_vaddr: u64 = gotplt_vaddr + (elfso_import_gotplt_reserved_entries + i) * elfso_import_gotplt_entry_size;
        label.define(map.get(entry, "plt"));
        db(0xff, 0x25);
        dd(elfso_import_rel32(got_slot_vaddr, entry_vaddr + 6));
        db(0x68);
        dd(i);
        db(0xe9);
        dd(elfso_import_rel32(plt_vaddr, entry_vaddr + elfso_import_plt_entry_size));
    }
}

fn elfso_import_emit_gotplt64(imports: list, dynamic_vaddr: u64, plt_vaddr: u64) {
    dq(dynamic_vaddr);
    dq(0);
    dq(0);
    for i in range(0, len(imports)) {
        const entry: map = list.get(imports, i);
        label.define(map.get(entry, "slot"));
        dq(plt_vaddr + elfso_import_plt0_size + i * elfso_import_plt_entry_size + 6);
    }
}

fn elfso_import_emit_dynstr64(imports: list, soname: string) {
    db(0);
    for entry in imports {
        db(map.get(entry, "name"), 0);
    }
    db(soname, 0);
    for library in elfso_import_libraries(imports) {
        db(library, 0);
    }
}

fn elfso_import_emit_dynsym64(imports: list, first_import_name_offset: u64) {
    elfso_sym64(0, 0, elf_shn_undef, 0, 0);
    const offsets: list = elfso_import_name_offsets(imports);
    for i in range(0, len(imports)) {
        const entry: map = list.get(imports, i)
        const symbol_type: u64 = map.get_or(entry, "type", elf_stt_func)
        assert(symbol_type == elf_stt_func || symbol_type == elf_stt_object, "ELF SO import type must be function or object");
        assert(symbol_type == elf_stt_func || map.get_or(entry, "plt", "") == "", "ELF SO object import requires a GOT slot");
        elfso_sym64(first_import_name_offset + list.get(offsets, i), elfso_st_info(elf_stb_global, symbol_type), elf_shn_undef, 0, 0);
    }
}

fn elfso_import_emit_rela64(imports: list, first_import_symbol: u64) {
    elfso_import_emit_rela64_type(imports, first_import_symbol, elf_r_x86_64_64);
}

// Architecture-parameterized variant: x86-64 GLOB_DAT callers use
// elf_r_x86_64_64, AArch64 slot callers pass elf_r_aarch64_glob_dat.
fn elfso_import_emit_rela64_type(imports: list, first_import_symbol: u64, reloc_type: u64) {
    for i in range(0, len(imports)) {
        const entry: map = list.get(imports, i);
        elfso_import_rela64(label_addr(map.get(entry, "slot")), first_import_symbol + i, reloc_type, 0);
    }
}

fn elfso_import_emit_rela_plt64(imports: list, first_import_symbol: u64) {
    for i in range(0, len(imports)) {
        const entry: map = list.get(imports, i);
        elfso_import_rela64(label_addr(map.get(entry, "slot")), first_import_symbol + i, elf_r_x86_64_jump_slot, 0);
    }
}

fn elfso_import_emit_dynamic64(imports: list, dynstr_vaddr: u64, dynstr_size: u64, dynsym_vaddr: u64, hash_vaddr: u64, rela_vaddr: u64, rela_size: u64, first_needed_offset: u64) {
    elfso_dyn64(elf_dt_hash, hash_vaddr);
    elfso_dyn64(elf_dt_strtab, dynstr_vaddr);
    elfso_dyn64(elf_dt_strsz, dynstr_size);
    elfso_dyn64(elf_dt_symtab, dynsym_vaddr);
    elfso_dyn64(elf_dt_syment, elfso_sym64_size);
    elfso_dyn64(elf_dt_rela, rela_vaddr);
    elfso_dyn64(elf_dt_relasz, rela_size);
    elfso_dyn64(elf_dt_relaent, elfso_import_rela64_size);

    const libraries: list = elfso_import_libraries(imports);
    const offsets: list = elfso_import_library_offsets(libraries);
    for i in range(0, len(libraries)) {
        elfso_dyn64(elf_dt_needed, first_needed_offset + list.get(offsets, i));
    }
    elfso_dyn64(elf_dt_null, 0);
}

fn elfso_import_emit_dynamic64_plt(imports: list, dynstr_vaddr: u64, dynstr_size: u64, dynsym_vaddr: u64, hash_vaddr: u64, gotplt_vaddr: u64, rela_plt_vaddr: u64, rela_plt_size: u64, first_needed_offset: u64) {
    elfso_dyn64(elf_dt_hash, hash_vaddr);
    elfso_dyn64(elf_dt_strtab, dynstr_vaddr);
    elfso_dyn64(elf_dt_strsz, dynstr_size);
    elfso_dyn64(elf_dt_symtab, dynsym_vaddr);
    elfso_dyn64(elf_dt_syment, elfso_sym64_size);
    elfso_dyn64(elf_dt_pltgot, gotplt_vaddr);
    elfso_dyn64(elf_dt_pltrelsz, rela_plt_size);
    elfso_dyn64(elf_dt_pltrel, elf_dt_rela);
    elfso_dyn64(elf_dt_jmprel, rela_plt_vaddr);

    const libraries: list = elfso_import_libraries(imports);
    const offsets: list = elfso_import_library_offsets(libraries);
    for i in range(0, len(libraries)) {
        elfso_dyn64(elf_dt_needed, first_needed_offset + list.get(offsets, i));
    }
    elfso_dyn64(elf_dt_null, 0);
}

fn elfso_import_hash(imports: list) {
    dd(1);
    dd(len(imports) + 1);
    if (len(imports) > 0) {
        dd(1);
    }
    if (len(imports) == 0) {
        dd(0);
    }
    dd(0);
    for i in range(1, len(imports) + 1) {
        if (i < len(imports)) {
            dd(i + 1);
        }
        if (i == len(imports)) {
            dd(0);
        }
    }
}

fn elfso_import_hash_size(imports: list) -> u64 {
    return 12 + (len(imports) + 1) * 4;
}

fn elfso_import_dynstr_size(imports: list, soname: string) -> u64 {
    return 1 + elfso_import_names_size(imports) + len(soname) + 1 + elfso_import_libraries_size(elfso_import_libraries(imports));
}

fn elfso_import_names_size(imports: list) -> u64 {
    let size: u64 = 0
    let index: u64 = 0
    while (index < len(imports)) {
        const entry: map = list.get(imports, index);
        size = size + len(map.get(entry, "name")) + 1;
        index = index + 1;
    }
    return size;
}

// Prefix sums of the name table. The dynamic symbol table needs one offset per
// import, so deriving each offset from the head of the list would walk the table
// once per entry. One pass here keeps the table linear in the import count.
fn elfso_import_name_offsets(imports: list) -> list {
    let offsets: list = list.new()
    let offset: u64 = 0
    let index: u64 = 0
    while (index < len(imports)) {
        list.push_mut(offsets, offset);
        const entry: map = list.get(imports, index);
        offset = offset + len(map.get(entry, "name")) + 1;
        index = index + 1;
    }
    return offsets;
}

fn elfso_import_name_offset(imports: list, index: u64) -> u64 {
    return list.get(elfso_import_name_offsets(imports), index);
}

fn elfso_import_libraries(imports: list) -> list {
    let libraries: list = list.new()
    for entry in imports {
        const library: string = map.get(entry, "library");
        if (elfso_import_list_has(libraries, library)) {
            continue;
        }
        list.push_mut(libraries, library);
    }
    return libraries;
}

fn elfso_import_list_has(values: list, needle: string) -> bool {
    for value in values {
        if (value == needle) {
            return true;
        }
    }
    return false;
}

fn elfso_import_libraries_size(libraries: list) -> u64 {
    let size: u64 = 0
    let index: u64 = 0
    while (index < len(libraries)) {
        const library: string = list.get(libraries, index);
        size = size + len(library) + 1;
        index = index + 1;
    }
    return size;
}

// Prefix sums of the needed-library table; see elfso_import_name_offsets.
fn elfso_import_library_offsets(libraries: list) -> list {
    let offsets: list = list.new()
    let offset: u64 = 0
    let index: u64 = 0
    while (index < len(libraries)) {
        list.push_mut(offsets, offset);
        const library: string = list.get(libraries, index);
        offset = offset + len(library) + 1;
        index = index + 1;
    }
    return offsets;
}

fn elfso_import_library_offset(libraries: list, index: u64) -> u64 {
    return list.get(elfso_import_library_offsets(libraries), index);
}

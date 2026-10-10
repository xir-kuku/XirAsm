// ELF64 executable dynamic import helpers for XIRASM.
//
// This is the executable counterpart to elfso_import.inc. It keeps the same
// explicit value-style import-list model, but emits ET_EXEC-friendly dynamic
// records: PT_INTERP, PT_DYNAMIC, .dynsym, .dynstr, .hash, .rela.dyn, and
// writable import slots. Each slot is fixed by an R_X86_64_64 dynamic
// relocation, so user code can call through the slot without hardcoding the
// imported function address:
//
//     call [rel puts_slot]
//
// PLT/GOT helpers are explicit too: callers choose the .plt, .got.plt and
// .rela.plt placement, then emit DT_JMPREL/DT_PLTRELSZ/DT_PLTREL/DT_PLTGOT
// rows through elfexe_import_emit_dynamic64_plt. Executable PLT/GOT helpers
// take executable virtual addresses, not file offsets.

import("elfexe.inc");

const elfexe_import_rela64_size: u64 = 24
const elfexe_import_dyn64_size: u64 = 16
const elfexe_import_sym64_size: u64 = 24
const elfexe_import_plt0_size: u64 = 16
const elfexe_import_plt_entry_size: u64 = 16
const elfexe_import_gotplt_reserved_entries: u64 = 3
const elfexe_import_gotplt_entry_size: u64 = 8
const elfexe_import_default_interp64: string = "/lib64/ld-linux-x86-64.so.2"

packed struct ElfExeRela64 {
    offset: u64,
    info: u64,
    addend: u64 = 0,
}

packed struct ElfExeDynamic64 {
    tag: u64,
    value: u64,
}

packed struct ElfExeSymbol64 {
    name: u32 = 0,
    info: u8 = 0,
    other: u8 = 0,
    shndx: u16 = elf_shn_undef,
    value: u64 = 0,
    size: u64 = 0,
}

fn elfexe_import_new() -> list {
    return list.new();
}

fn elfexe_import_use64(imports: list, library: string, name: string) -> list {
    return elfexe_import_use64_as(imports, library, name, name);
}

fn elfexe_import_use64_many(imports: list, library: string, names: list) -> list {
    let next_imports: list = imports
    for name in names {
        next_imports = elfexe_import_use64(next_imports, library, name)
    }
    return next_imports;
}

fn elfexe_import_use64_pairs(imports: list, library: string, pairs: list) -> list {
    assert(len(pairs) % 2 == 0, "ELF executable import pairs require slot/name entries");
    assert(len(pairs) <= 128, "ELF executable import pairs exceed the batch limit");
    return elfexe_import_use64_pairs_from(imports, library, pairs, 0);
}

fn elfexe_import_use64_pairs_from(imports: list, library: string, pairs: list, index: u64) -> list {
    if index == len(pairs) {
        return imports;
    }
    const slot: string = list.get(pairs, index)
    const name: string = list.get(pairs, index + 1)
    const next_imports: list = elfexe_import_use64_as(imports, library, name, slot)
    return elfexe_import_use64_pairs_from(next_imports, library, pairs, index + 2);
}

fn elfexe_import_use64_as(imports: list, library: string, name: string, slot: string) -> list {
    assert(elf_validate_c_name(library) && elf_validate_c_name(name), "invalid ELF executable import name");
    assert(len(library) > 0, "ELF executable import library name is empty");
    assert(len(name) > 0, "ELF executable import symbol name is empty");
    assert(len(slot) > 0, "ELF executable import slot label is empty");

    for entry in imports {
        if (map.get(entry, "slot") == slot) {
            assert(map.get(entry, "library") == library, "ELF executable import slot already maps to a different library");
            assert(map.get(entry, "name") == name, "ELF executable import slot already maps to a different symbol");
            return imports;
        }
    }

    let next_imports: list = imports
    list.push_mut(next_imports, elfexe_import_entry(library, name, slot));
    return next_imports;
}

fn elfexe_import_use64_plt(imports: list, library: string, name: string) -> list {
    return elfexe_import_use64_plt_as(imports, library, name, sym.join(name, "_gotplt"), sym.join(name, "_plt"));
}

fn elfexe_import_use64_plt_many(imports: list, library: string, names: list) -> list {
    let next_imports: list = imports
    for name in names {
        next_imports = elfexe_import_use64_plt(next_imports, library, name)
    }
    return next_imports;
}

fn elfexe_import_use64_plt_pairs(imports: list, library: string, pairs: list) -> list {
    assert(len(pairs) % 2 == 0, "ELF executable PLT import pairs require local/name entries");
    assert(len(pairs) <= 128, "ELF executable PLT import pairs exceed the batch limit");
    let next_imports: list = imports
    let index: u64 = 0
    while index < len(pairs) {
        const local_name: string = list.get(pairs, index)
        const import_name: string = list.get(pairs, index + 1)
        next_imports = elfexe_import_use64_plt_as(
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

fn elfexe_import_use64_plt_as(imports: list, library: string, name: string, slot: string, plt: string) -> list {
    assert(len(plt) > 0, "ELF executable import PLT label is empty");
    let next_imports: list = elfexe_import_use64_as(imports, library, name, slot)
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
    assert(false, "ELF executable import slot was not recorded");
    return next_imports;
}

fn elfexe_import_entry(library: string, name: string, slot: string) -> map {
    let entry: map = map.new()
    map.set_mut(entry, "library", library);
    map.set_mut(entry, "name", name);
    map.set_mut(entry, "slot", slot);
    return entry;
}

fn elfexe_import_r_info64(symbol_index: u64, reloc_type: u64) -> u64 {
    return symbol_index * 0x100000000 + reloc_type;
}

fn elfexe_import_rela64(offset: u64, symbol_index: u64, reloc_type: u64, addend: u64) {
    emit.struct(ElfExeRela64 { offset: offset, info: elfexe_import_r_info64(symbol_index, reloc_type), addend: addend });
}

fn elfexe_import_dyn64(tag: u64, value: u64) {
    emit.struct(ElfExeDynamic64 { tag: tag, value: value });
}

fn elfexe_import_sym64(name: u64, info: u8, shndx: u16, value: u64, size: u64) {
    emit.struct(ElfExeSymbol64 { name: name, info: info, shndx: shndx, value: value, size: size });
}

fn elfexe_import_st_info(bind: u8, symbol_type: u8) -> u8 {
    assert(bind < 16, "ELF symbol binding must fit in four bits");
    assert(symbol_type < 16, "ELF symbol type must fit in four bits");
    return bind * 16 + symbol_type;
}

fn elfexe_import_rel32(target: u64, next_ip: u64) -> u64 {
    if (target >= next_ip) {
        const delta: u64 = target - next_ip;
        assert(delta <= 0x7fffffff, "ELF executable PLT forward displacement does not fit rel32");
        return delta;
    }
    const delta: u64 = next_ip - target;
    assert(delta <= 0x80000000, "ELF executable PLT backward displacement does not fit rel32");
    return 0x100000000 - delta;
}

fn elfexe_import_plt_size(imports: list) -> u64 {
    return elfexe_import_plt0_size + len(imports) * elfexe_import_plt_entry_size;
}

fn elfexe_import_gotplt_size(imports: list) -> u64 {
    return (elfexe_import_gotplt_reserved_entries + len(imports)) * elfexe_import_gotplt_entry_size;
}

fn elfexe_import_rela_plt_size(imports: list) -> u64 {
    return len(imports) * elfexe_import_rela64_size;
}

fn elfexe_import_dynamic_plt_size(imports: list) -> u64 {
    return (10 + len(elfexe_import_libraries(imports))) * elfexe_import_dyn64_size;
}

fn elfexe_import_emit_slots64(imports: list) {
    for entry in imports {
        label.define(map.get(entry, "slot"));
        dq(0);
    }
}

fn elfexe_import_emit_plt64(imports: list, plt_vaddr: u64, gotplt_vaddr: u64) {
    db(0xff, 0x35);
    dd(elfexe_import_rel32(gotplt_vaddr + 8, plt_vaddr + 6));
    db(0xff, 0x25);
    dd(elfexe_import_rel32(gotplt_vaddr + 16, plt_vaddr + 12));
    db(0x0f, 0x1f, 0x40, 0x00);

    for i in range(0, len(imports)) {
        const entry: map = list.get(imports, i);
        const entry_vaddr: u64 = plt_vaddr + elfexe_import_plt0_size + i * elfexe_import_plt_entry_size;
        const got_slot_vaddr: u64 = gotplt_vaddr + (elfexe_import_gotplt_reserved_entries + i) * elfexe_import_gotplt_entry_size;
        label.define(map.get(entry, "plt"));
        db(0xff, 0x25);
        dd(elfexe_import_rel32(got_slot_vaddr, entry_vaddr + 6));
        db(0x68);
        dd(i);
        db(0xe9);
        dd(elfexe_import_rel32(plt_vaddr, entry_vaddr + elfexe_import_plt_entry_size));
    }
}

fn elfexe_import_emit_gotplt64(imports: list, dynamic_vaddr: u64, plt_vaddr: u64) {
    dq(dynamic_vaddr);
    dq(0);
    dq(0);
    for i in range(0, len(imports)) {
        const entry: map = list.get(imports, i);
        label.define(map.get(entry, "slot"));
        dq(plt_vaddr + elfexe_import_plt0_size + i * elfexe_import_plt_entry_size + 6);
    }
}

fn elfexe_import_emit_dynstr64(imports: list) {
    db(0);
    for entry in imports {
        db(map.get(entry, "name"), 0);
    }
    for library in elfexe_import_libraries(imports) {
        db(library, 0);
    }
}

fn elfexe_import_emit_dynsym64(imports: list, first_import_name_offset: u64) {
    elfexe_import_sym64(0, 0, elf_shn_undef, 0, 0);
    for i in range(0, len(imports)) {
        elfexe_import_sym64(first_import_name_offset + elfexe_import_name_offset(imports, i), elfexe_import_st_info(elf_stb_global, elf_stt_func), elf_shn_undef, 0, 0);
    }
}

fn elfexe_import_emit_rela64(imports: list, first_import_symbol: u64) {
    for i in range(0, len(imports)) {
        const entry: map = list.get(imports, i);
        elfexe_import_rela64(label_addr(map.get(entry, "slot")), first_import_symbol + i, elf_r_x86_64_64, 0);
    }
}

fn elfexe_import_emit_rela_plt64(imports: list, first_import_symbol: u64) {
    for i in range(0, len(imports)) {
        const entry: map = list.get(imports, i);
        elfexe_import_rela64(label_addr(map.get(entry, "slot")), first_import_symbol + i, elf_r_x86_64_jump_slot, 0);
    }
}

fn elfexe_import_emit_dynamic64(imports: list, dynstr_vaddr: u64, dynstr_size: u64, dynsym_vaddr: u64, hash_vaddr: u64, rela_vaddr: u64, rela_size: u64, first_needed_offset: u64) {
    elfexe_import_dyn64(elf_dt_hash, hash_vaddr);
    elfexe_import_dyn64(elf_dt_strtab, dynstr_vaddr);
    elfexe_import_dyn64(elf_dt_strsz, dynstr_size);
    elfexe_import_dyn64(elf_dt_symtab, dynsym_vaddr);
    elfexe_import_dyn64(elf_dt_syment, elfexe_import_sym64_size);
    elfexe_import_dyn64(elf_dt_rela, rela_vaddr);
    elfexe_import_dyn64(elf_dt_relasz, rela_size);
    elfexe_import_dyn64(elf_dt_relaent, elfexe_import_rela64_size);

    const libraries: list = elfexe_import_libraries(imports);
    for i in range(0, len(libraries)) {
        elfexe_import_dyn64(elf_dt_needed, first_needed_offset + elfexe_import_library_offset(libraries, i));
    }
    elfexe_import_dyn64(elf_dt_null, 0);
}

fn elfexe_import_emit_dynamic64_plt(imports: list, dynstr_vaddr: u64, dynstr_size: u64, dynsym_vaddr: u64, hash_vaddr: u64, gotplt_vaddr: u64, rela_plt_vaddr: u64, rela_plt_size: u64, first_needed_offset: u64) {
    elfexe_import_dyn64(elf_dt_hash, hash_vaddr);
    elfexe_import_dyn64(elf_dt_strtab, dynstr_vaddr);
    elfexe_import_dyn64(elf_dt_strsz, dynstr_size);
    elfexe_import_dyn64(elf_dt_symtab, dynsym_vaddr);
    elfexe_import_dyn64(elf_dt_syment, elfexe_import_sym64_size);
    elfexe_import_dyn64(elf_dt_pltgot, gotplt_vaddr);
    elfexe_import_dyn64(elf_dt_pltrelsz, rela_plt_size);
    elfexe_import_dyn64(elf_dt_pltrel, elf_dt_rela);
    elfexe_import_dyn64(elf_dt_jmprel, rela_plt_vaddr);

    const libraries: list = elfexe_import_libraries(imports);
    for i in range(0, len(libraries)) {
        elfexe_import_dyn64(elf_dt_needed, first_needed_offset + elfexe_import_library_offset(libraries, i));
    }
    elfexe_import_dyn64(elf_dt_null, 0);
}

fn elfexe_import_hash(imports: list) {
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

fn elfexe_import_hash_size(imports: list) -> u64 {
    return 12 + (len(imports) + 1) * 4;
}

fn elfexe_import_dynstr_size(imports: list) -> u64 {
    return 1 + elfexe_import_names_size(imports) + elfexe_import_libraries_size(elfexe_import_libraries(imports));
}

fn elfexe_import_names_size(imports: list) -> u64 {
    const size: u64 = 0;
    return elfexe_import_names_size_from(imports, 0, size);
}

fn elfexe_import_names_size_from(imports: list, index: u64, size: u64) -> u64 {
    if (index == len(imports)) {
        return size;
    }
    const entry: map = list.get(imports, index);
    return elfexe_import_names_size_from(imports, index + 1, size + len(map.get(entry, "name")) + 1);
}

fn elfexe_import_name_offset(imports: list, index: u64) -> u64 {
    const offset: u64 = 0;
    return elfexe_import_name_offset_from(imports, index, 0, offset);
}

fn elfexe_import_name_offset_from(imports: list, target_index: u64, index: u64, offset: u64) -> u64 {
    if (index == target_index) {
        return offset;
    }
    const entry: map = list.get(imports, index);
    return elfexe_import_name_offset_from(imports, target_index, index + 1, offset + len(map.get(entry, "name")) + 1);
}

fn elfexe_import_libraries(imports: list) -> list {
    let libraries: list = list.new()
    for entry in imports {
        const library: string = map.get(entry, "library");
        if (elfexe_import_list_has(libraries, library)) {
            continue;
        }
        list.push_mut(libraries, library);
    }
    return libraries;
}

fn elfexe_import_list_has(values: list, needle: string) -> bool {
    for value in values {
        if (value == needle) {
            return true;
        }
    }
    return false;
}

fn elfexe_import_libraries_size(libraries: list) -> u64 {
    const size: u64 = 0;
    return elfexe_import_libraries_size_from(libraries, 0, size);
}

fn elfexe_import_libraries_size_from(libraries: list, index: u64, size: u64) -> u64 {
    if (index == len(libraries)) {
        return size;
    }
    const library: string = list.get(libraries, index);
    return elfexe_import_libraries_size_from(libraries, index + 1, size + len(library) + 1);
}

fn elfexe_import_library_offset(libraries: list, index: u64) -> u64 {
    const offset: u64 = 0;
    return elfexe_import_library_offset_from(libraries, index, 0, offset);
}

fn elfexe_import_library_offset_from(libraries: list, target_index: u64, index: u64, offset: u64) -> u64 {
    if (index == target_index) {
        return offset;
    }
    const library: string = list.get(libraries, index);
    return elfexe_import_library_offset_from(libraries, target_index, index + 1, offset + len(library) + 1);
}

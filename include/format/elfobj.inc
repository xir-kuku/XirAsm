// ELF relocatable object helpers for XIRASM.
//
// This is a deliberately explicit object-container DSL. Users provide section
// indexes, symbol indexes, file offsets, and relocation records explicitly.

import("elf_const.inc");

const elfobj_header64_size: u64 = 64
const elfobj_header32_size: u64 = 52
const elfobj_shdr64_size: u64 = 64
const elfobj_shdr32_size: u64 = 40
const elfobj_sym64_size: u64 = 24
const elfobj_sym32_size: u64 = 16
const elfobj_rela64_size: u64 = 24
const elfobj_rel32_size: u64 = 8

const elfobj64_shoff_foa: u64 = 40
const elfobj64_shentsize_foa: u64 = 58
const elfobj64_shnum_foa: u64 = 60
const elfobj64_shstrndx_foa: u64 = 62

const elfobj32_shoff_foa: u64 = 32
const elfobj32_shentsize_foa: u64 = 46
const elfobj32_shnum_foa: u64 = 48
const elfobj32_shstrndx_foa: u64 = 50

const elfobj_sh_name_foa: u64 = 0
const elfobj_sh_type_foa: u64 = 4
const elfobj64_sh_flags_foa: u64 = 8
const elfobj64_sh_offset_foa: u64 = 24
const elfobj64_sh_size_foa: u64 = 32
const elfobj64_sh_link_foa: u64 = 40
const elfobj64_sh_info_foa: u64 = 44
const elfobj64_sh_addralign_foa: u64 = 48
const elfobj64_sh_entsize_foa: u64 = 56

const elfobj32_sh_flags_foa: u64 = 8
const elfobj32_sh_offset_foa: u64 = 16
const elfobj32_sh_size_foa: u64 = 20
const elfobj32_sh_link_foa: u64 = 24
const elfobj32_sh_info_foa: u64 = 28
const elfobj32_sh_addralign_foa: u64 = 32
const elfobj32_sh_entsize_foa: u64 = 36

const elfobj_stb_local: u8 = elf_stb_local
const elfobj_stb_global: u8 = elf_stb_global
const elfobj_stt_notype: u8 = elf_stt_notype
const elfobj_stt_object: u8 = elf_stt_object
const elfobj_stt_func: u8 = elf_stt_func
const elfobj_stt_section: u8 = elf_stt_section

fn elfobj_align_up(value: u64, align: u64) -> u64 {
    return ((value + align - 1) / align) * align;
}

fn elfobj64_shdr_foa(section_table_foa: u64, index: u64) -> u64 {
    return section_table_foa + index * elfobj_shdr64_size;
}

fn elfobj32_shdr_foa(section_table_foa: u64, index: u64) -> u64 {
    return section_table_foa + index * elfobj_shdr32_size;
}

fn elfobj64_sym_foa(symbol_table_foa: u64, index: u64) -> u64 {
    return symbol_table_foa + index * elfobj_sym64_size;
}

fn elfobj32_sym_foa(symbol_table_foa: u64, index: u64) -> u64 {
    return symbol_table_foa + index * elfobj_sym32_size;
}

fn elfobj64_rela_foa(rela_table_foa: u64, index: u64) -> u64 {
    return rela_table_foa + index * elfobj_rela64_size;
}

fn elfobj32_rel_foa(rel_table_foa: u64, index: u64) -> u64 {
    return rel_table_foa + index * elfobj_rel32_size;
}

fn elfobj64_rela_count(start: u64, end: u64) -> u64 {
    assert(end >= start, "ELF64 RELA table end is before start");
    assert((end - start) % elfobj_rela64_size == 0, "ELF64 RELA table size is not record-aligned");
    return (end - start) / elfobj_rela64_size;
}

fn elfobj32_rel_count(start: u64, end: u64) -> u64 {
    assert(end >= start, "ELF32 REL table end is before start");
    assert((end - start) % elfobj_rel32_size == 0, "ELF32 REL table size is not record-aligned");
    return (end - start) / elfobj_rel32_size;
}

fn elfobj_reloc_offset(section_start: u64, label_address: u64) -> u64 {
    assert(label_address >= section_start, "ELF object relocation location is before its section start");
    return label_address - section_start;
}

fn elfobj_st_info(bind: u8, symbol_type: u8) -> u8 {
    return bind * 16 + symbol_type;
}

fn elfobj_r_info64(symbol_index: u64, reloc_type: u64) -> u64 {
    return symbol_index * 0x100000000 + reloc_type;
}

fn elfobj_r_info32(symbol_index: u64, reloc_type: u64) -> u64 {
    return symbol_index * 0x100 + reloc_type;
}

fn elfobj_aarch64_reloc_instruction(kind: u64) -> bool {
    return (kind == elf_r_aarch64_adr_prel_lo21 ||
        kind == elf_r_aarch64_adr_prel_pg_hi21 ||
        kind == elf_r_aarch64_add_abs_lo12_nc ||
        kind == elf_r_aarch64_ldst8_abs_lo12_nc ||
        kind == elf_r_aarch64_ldst16_abs_lo12_nc ||
        kind == elf_r_aarch64_ldst32_abs_lo12_nc ||
        kind == elf_r_aarch64_ldst64_abs_lo12_nc ||
        kind == elf_r_aarch64_condbr19 ||
        kind == elf_r_aarch64_jump26 ||
        kind == elf_r_aarch64_call26 ||
        kind == elf_r_aarch64_adr_got_page ||
        kind == elf_r_aarch64_ld64_got_lo12_nc);
}

fn elfobj_aarch64_reloc_width(kind: u64) -> u64 {
    if kind == 0 {
        return 0;
    }
    if kind == elf_r_aarch64_abs64 || kind == elf_r_aarch64_prel64 {
        return 8;
    }
    if kind == elf_r_aarch64_abs32 || kind == elf_r_aarch64_prel32 || elfobj_aarch64_reloc_instruction(kind) {
        return 4;
    }
    if kind == elf_r_aarch64_abs16 || kind == elf_r_aarch64_prel16 {
        return 2;
    }
    assert(false, "unsupported AArch64 ELF object relocation type");
    return 0;
}

packed struct ElfObjIdent {
    magic: u32 = elf_magic,
    class: u8,
    data: u8 = elf_data_lsb,
    version: u8 = 1,
    osabi: u8 = elf_osabi_none,
    abi_version: u8 = 0,
    pad0: u32 = 0,
    pad1: u16 = 0,
    pad2: u8 = 0,
}

packed struct ElfObjHeader64 {
    ident: ElfObjIdent,
    file_type: u16 = elf_type_rel,
    machine: u16 = elf_machine_x86_64,
    version: u32 = elf_version_current,
    entry: u64 = 0,
    phoff: u64 = 0,
    shoff: u64,
    flags: u32 = 0,
    ehsize: u16 = elfobj_header64_size,
    phentsize: u16 = 0,
    phnum: u16 = 0,
    shentsize: u16 = elfobj_shdr64_size,
    shnum: u16,
    shstrndx: u16,
}

packed struct ElfObjHeader32 {
    ident: ElfObjIdent,
    file_type: u16 = elf_type_rel,
    machine: u16 = elf_machine_386,
    version: u32 = elf_version_current,
    entry: u32 = 0,
    phoff: u32 = 0,
    shoff: u32,
    flags: u32 = 0,
    ehsize: u16 = elfobj_header32_size,
    phentsize: u16 = 0,
    phnum: u16 = 0,
    shentsize: u16 = elfobj_shdr32_size,
    shnum: u16,
    shstrndx: u16,
}

packed struct ElfObjSectionHeader64 {
    name: u32 = 0,
    section_type: u32 = elf_sht_null,
    flags: u64 = 0,
    addr: u64 = 0,
    offset: u64 = 0,
    size: u64 = 0,
    link: u32 = 0,
    info: u32 = 0,
    addralign: u64 = 0,
    entsize: u64 = 0,
}

packed struct ElfObjSectionHeader32 {
    name: u32 = 0,
    section_type: u32 = elf_sht_null,
    flags: u32 = 0,
    addr: u32 = 0,
    offset: u32 = 0,
    size: u32 = 0,
    link: u32 = 0,
    info: u32 = 0,
    addralign: u32 = 0,
    entsize: u32 = 0,
}

packed struct ElfObjSymbol64 {
    name: u32 = 0,
    info: u8 = 0,
    other: u8 = 0,
    shndx: u16 = elf_shn_undef,
    value: u64 = 0,
    size: u64 = 0,
}

packed struct ElfObjSymbol32 {
    name: u32 = 0,
    value: u32 = 0,
    size: u32 = 0,
    info: u8 = 0,
    other: u8 = 0,
    shndx: u16 = elf_shn_undef,
}

packed struct ElfObjRela64 {
    offset: u64,
    info: u64,
    addend: u64,
}

packed struct ElfObjRel32 {
    offset: u32,
    info: u32,
}

fn elfobj_begin64(section_count: u16, section_table_foa: u64, shstrndx: u16) {
    assert(section_count > 0, "elfobj_begin64 requires section headers");
    emit.struct(ElfObjHeader64 { ident: ElfObjIdent { class: elf_class_64 }, shoff: section_table_foa, shnum: section_count, shstrndx: shstrndx });
}

fn elfobj_begin64_deferred() {
    elfobj_begin64_deferred_machine(elf_machine_x86_64);
}

fn elfobj_begin64_deferred_machine(machine: u16) {
    emit.struct(ElfObjHeader64 { ident: ElfObjIdent { class: elf_class_64 }, machine: machine, shoff: 0, shnum: 0, shstrndx: 0 });
}

fn elfobj_begin32(section_count: u16, section_table_foa: u64, shstrndx: u16) {
    assert(section_count > 0, "elfobj_begin32 requires section headers");
    emit.struct(ElfObjHeader32 { ident: ElfObjIdent { class: elf_class_32 }, shoff: section_table_foa, shnum: section_count, shstrndx: shstrndx });
}

fn elfobj_begin32_deferred() {
    emit.struct(ElfObjHeader32 { ident: ElfObjIdent { class: elf_class_32 }, shoff: 0, shnum: 0, shstrndx: 0 });
}

fn elfobj_begin_section(name: string, raw_ptr: u64) {
    region.begin(name, 0, raw_ptr);
}

fn elfobj_end_section(raw_size: u64) {
    pad_to(raw_size, 0);
}

fn elfobj_shdr64(name: u64, section_type: u32, flags: u64, offset: u64, size: u64, link: u64, info: u64, addralign: u64, entsize: u64) {
    emit.struct(ElfObjSectionHeader64 { name: name, section_type: section_type, flags: flags, offset: offset, size: size, link: link, info: info, addralign: addralign, entsize: entsize });
}

fn elfobj_patch_header64(section_table_foa: u64, section_count: u16, shstrndx: u16) {
    defer {
        store.u64(region_base() + elfobj64_shoff_foa, section_table_foa);
        store.u16(region_base() + elfobj64_shnum_foa, section_count);
        store.u16(region_base() + elfobj64_shstrndx_foa, shstrndx);
    }
}

fn elfobj_shdr32(name: u64, section_type: u32, flags: u64, offset: u64, size: u64, link: u64, info: u64, addralign: u64, entsize: u64) {
    emit.struct(ElfObjSectionHeader32 { name: name, section_type: section_type, flags: flags, offset: offset, size: size, link: link, info: info, addralign: addralign, entsize: entsize });
}

fn elfobj_patch_header32(section_table_foa: u64, section_count: u16, shstrndx: u16) {
    defer {
        store.u32(region_base() + elfobj32_shoff_foa, section_table_foa);
        store.u16(region_base() + elfobj32_shnum_foa, section_count);
        store.u16(region_base() + elfobj32_shstrndx_foa, shstrndx);
    }
}

fn elfobj_sym64(name: u64, info: u8, shndx: u16, value: u64, size: u64) {
    emit.struct(ElfObjSymbol64 { name: name, info: info, shndx: shndx, value: value, size: size });
}

fn elfobj_sym32(name: u64, info: u8, shndx: u16, value: u64, size: u64) {
    emit.struct(ElfObjSymbol32 { name: name, info: info, shndx: shndx, value: value, size: size });
}

fn elfobj_rela64(offset: u64, symbol_index: u64, reloc_type: u64, addend: u64) {
    emit.struct(ElfObjRela64 { offset: offset, info: elfobj_r_info64(symbol_index, reloc_type), addend: addend });
}

fn elfobj_rela64_at(section_start: u64, label_address: u64, symbol_index: u64, reloc_type: u64, addend: u64) {
    elfobj_rela64(elfobj_reloc_offset(section_start, label_address), symbol_index, reloc_type, addend);
}

fn elfobj_rela64_x86_64_64_at(section_start: u64, label_address: u64, symbol_index: u64, addend: u64) {
    elfobj_rela64_at(section_start, label_address, symbol_index, elf_r_x86_64_64, addend);
}

fn elfobj_rela64_x86_64_pc32_at(section_start: u64, label_address: u64, symbol_index: u64, addend: u64) {
    elfobj_rela64_at(section_start, label_address, symbol_index, elf_r_x86_64_pc32, addend);
}

fn elfobj_rela64_x86_64_plt32_at(section_start: u64, label_address: u64, symbol_index: u64, addend: u64) {
    elfobj_rela64_at(section_start, label_address, symbol_index, elf_r_x86_64_plt32, addend);
}

fn elfobj_rela64_x86_64_gotpcrel_at(section_start: u64, label_address: u64, symbol_index: u64, addend: u64) {
    elfobj_rela64_at(section_start, label_address, symbol_index, elf_r_x86_64_gotpcrel, addend);
}

fn elfobj_rela64_x86_64_32_at(section_start: u64, label_address: u64, symbol_index: u64, addend: u64) {
    elfobj_rela64_at(section_start, label_address, symbol_index, elf_r_x86_64_32, addend);
}

fn elfobj_rela64_x86_64_32s_at(section_start: u64, label_address: u64, symbol_index: u64, addend: u64) {
    elfobj_rela64_at(section_start, label_address, symbol_index, elf_r_x86_64_32s, addend);
}

fn elfobj_rel32(offset: u64, symbol_index: u64, reloc_type: u64) {
    emit.struct(ElfObjRel32 { offset: offset, info: elfobj_r_info32(symbol_index, reloc_type) });
}

fn elfobj_rel32_at(section_start: u64, label_address: u64, symbol_index: u64, reloc_type: u64) {
    elfobj_rel32(elfobj_reloc_offset(section_start, label_address), symbol_index, reloc_type);
}

fn elfobj_rel32_386_32_at(section_start: u64, label_address: u64, symbol_index: u64) {
    elfobj_rel32_at(section_start, label_address, symbol_index, elf_r_386_32);
}

fn elfobj_rel32_386_pc32_at(section_start: u64, label_address: u64, symbol_index: u64) {
    elfobj_rel32_at(section_start, label_address, symbol_index, elf_r_386_pc32);
}

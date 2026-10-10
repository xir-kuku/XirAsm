// Shared ELF constants for XIRASM format DSL helpers.
//
// This file intentionally contains portable constants only. Container emission
// lives in elfexe.inc so COFF/PE helpers do not pull in ELF structs by accident.

const elf_magic: u32 = 0x464c457f

const elf_class_none: u8 = 0
const elf_class_32: u8 = 1
const elf_class_64: u8 = 2

const elf_data_none: u8 = 0
const elf_data_lsb: u8 = 1
const elf_data_msb: u8 = 2

const elf_osabi_none: u8 = 0
const elf_osabi_hpux: u8 = 1
const elf_osabi_netbsd: u8 = 2
const elf_osabi_gnu: u8 = 3
const elf_osabi_linux: u8 = 3
const elf_osabi_solaris: u8 = 6
const elf_osabi_aix: u8 = 7
const elf_osabi_irix: u8 = 8
const elf_osabi_freebsd: u8 = 9
const elf_osabi_tru64: u8 = 10
const elf_osabi_modesto: u8 = 11
const elf_osabi_openbsd: u8 = 12
const elf_osabi_openvms: u8 = 13
const elf_osabi_nsk: u8 = 14
const elf_osabi_aros: u8 = 15
const elf_osabi_fenixos: u8 = 16
const elf_osabi_cloudabi: u8 = 17
const elf_osabi_openvos: u8 = 18

const elf_type_none: u16 = 0
const elf_type_rel: u16 = 1
const elf_type_exec: u16 = 2
const elf_type_dyn: u16 = 3
const elf_type_core: u16 = 4

const elf_machine_none: u16 = 0
const elf_machine_386: u16 = 3
const elf_machine_x86_64: u16 = 62
const elf_machine_aarch64: u16 = 183

const elf_version_none: u32 = 0
const elf_version_current: u32 = 1

const elf_pt_null: u32 = 0
const elf_pt_load: u32 = 1
const elf_pt_dynamic: u32 = 2
const elf_pt_interp: u32 = 3
const elf_pt_note: u32 = 4
const elf_pt_shlib: u32 = 5
const elf_pt_phdr: u32 = 6
const elf_pt_gnu_eh_frame: u32 = 0x6474e550
const elf_pt_gnu_stack: u32 = 0x6474e551
const elf_pt_gnu_relro: u32 = 0x6474e552

const elf_dt_null: u64 = 0
const elf_dt_needed: u64 = 1
const elf_dt_pltrelsz: u64 = 2
const elf_dt_pltgot: u64 = 3
const elf_dt_hash: u64 = 4
const elf_dt_strtab: u64 = 5
const elf_dt_symtab: u64 = 6
const elf_dt_strsz: u64 = 10
const elf_dt_syment: u64 = 11
const elf_dt_soname: u64 = 14
const elf_dt_rela: u64 = 7
const elf_dt_relasz: u64 = 8
const elf_dt_relaent: u64 = 9
const elf_dt_symbolic: u64 = 16
const elf_dt_pltrel: u64 = 20
const elf_dt_jmprel: u64 = 23
const elf_dt_bind_now: u64 = 24

const elf_pf_x: u32 = 1
const elf_pf_w: u32 = 2
const elf_pf_r: u32 = 4

const elf_sht_null: u32 = 0
const elf_sht_progbits: u32 = 1
const elf_sht_symtab: u32 = 2
const elf_sht_strtab: u32 = 3
const elf_sht_rela: u32 = 4
const elf_sht_hash: u32 = 5
const elf_sht_dynamic: u32 = 6
const elf_sht_note: u32 = 7
const elf_sht_nobits: u32 = 8
const elf_sht_rel: u32 = 9
const elf_sht_shlib: u32 = 10
const elf_sht_dynsym: u32 = 11

const elf_shn_undef: u16 = 0

const elf_shf_write: u64 = 0x1
const elf_shf_alloc: u64 = 0x2
const elf_shf_execinstr: u64 = 0x4

const elf_stb_local: u8 = 0
const elf_stb_global: u8 = 1
const elf_stb_weak: u8 = 2

const elf_stt_notype: u8 = 0
const elf_stt_object: u8 = 1
const elf_stt_func: u8 = 2
const elf_stt_section: u8 = 3
const elf_stt_file: u8 = 4

const elf_r_x86_64_none: u32 = 0
const elf_r_x86_64_64: u32 = 1
const elf_r_x86_64_pc32: u32 = 2
const elf_r_x86_64_plt32: u32 = 4
const elf_r_x86_64_copy: u32 = 5
const elf_r_x86_64_glob_dat: u32 = 6
const elf_r_x86_64_jump_slot: u32 = 7
const elf_r_x86_64_relative: u32 = 8
const elf_r_x86_64_gotpcrel: u32 = 9
const elf_r_x86_64_32: u32 = 10
const elf_r_x86_64_32s: u32 = 11
const elf_r_x86_64_pc64: u32 = 24

const elf_r_386_none: u32 = 0
const elf_r_386_32: u32 = 1
const elf_r_386_pc32: u32 = 2
const elf_r_386_relative: u32 = 8

// AArch64 relocation type numbers verified against llvm-readobj output.
const elf_r_aarch64_abs64: u32 = 257
const elf_r_aarch64_abs32: u32 = 258
const elf_r_aarch64_abs16: u32 = 259
const elf_r_aarch64_prel64: u32 = 260
const elf_r_aarch64_prel32: u32 = 261
const elf_r_aarch64_prel16: u32 = 262
const elf_r_aarch64_adr_prel_lo21: u32 = 274
const elf_r_aarch64_adr_prel_pg_hi21: u32 = 275
const elf_r_aarch64_add_abs_lo12_nc: u32 = 277
const elf_r_aarch64_ldst8_abs_lo12_nc: u32 = 278
const elf_r_aarch64_condbr19: u32 = 280
const elf_r_aarch64_jump26: u32 = 282
const elf_r_aarch64_call26: u32 = 283
const elf_r_aarch64_ldst16_abs_lo12_nc: u32 = 284
const elf_r_aarch64_ldst32_abs_lo12_nc: u32 = 285
const elf_r_aarch64_ldst64_abs_lo12_nc: u32 = 286
const elf_r_aarch64_adr_got_page: u32 = 311
const elf_r_aarch64_ld64_got_lo12_nc: u32 = 312
const elf_r_aarch64_glob_dat: u32 = 1025
const elf_r_aarch64_jump_slot: u32 = 1026
const elf_r_aarch64_relative: u32 = 1027

const elf_default_page_align: u64 = 0x1000
const elf_android_page_align: u64 = 0x4000
const elf_default_base64: u64 = 0x400000
const elf_default_base32: u64 = 0x08048000

fn elf_validate_c_name(name: string) -> bool {
    assert(len(name) > 0, "ELF name is empty");
    assert(!contains(name, "\0"), "ELF name contains an embedded NUL");
    return true;
}

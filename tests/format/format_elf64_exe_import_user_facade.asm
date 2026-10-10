// api-matrix-fixture: format_elfexe_import_new(
// api-matrix-fixture: format_elfexe_import_many_mut(
// api-matrix-fixture: format_elfexe_import_pairs_mut(

import("format/format.inc");

let image: map = format_elf64(
    format_elf_exec,
    list.of(
        format_segment(".text", format_load | format_readable | format_executable)
    )
)
let imports: list = format_elfexe_import_new()
format_elfexe_import_pairs_mut(imports, "libc.so.6", list.of("getpid", "getpid"))
format_elfexe_tables_mut(image, imports)
format_begin(image);

format_segment_begin(image, ".text");
start:
    call getpid_plt
    xor edi, edi
    mov eax, 60
    syscall
format_segment_end(image, ".text");

format_entry_mut(image, start)
format_finish(image);

defer {
    assert(load.u16(region_base() + 16) == elf_type_exec);
    assert(load.u16(region_base() + elf64_phnum_foa) == 6);
    assert(load.u64(region_base() + elf64_entry_foa) == start);
    assert(load.u32(region_base() + elf64_phdr_foa(0) + elf64_phdr_type_foa) == elf_pt_phdr);
    assert(load.u32(region_base() + elf64_phdr_foa(1) + elf64_phdr_type_foa) == elf_pt_interp);
    assert(load.u32(region_base() + elf64_phdr_foa(2) + elf64_phdr_type_foa) == elf_pt_load);
    assert(load.u64(region_base() + elf64_phdr_foa(2) + elf64_phdr_offset_foa) == 0);
    assert(load.u64(region_base() + elf64_phdr_foa(2) + elf64_phdr_vaddr_foa) == elf_default_base64);
    assert(load.u32(region_base() + elf64_phdr_foa(3) + elf64_phdr_type_foa) == elf_pt_load);
    assert(load.u32(region_base() + elf64_phdr_foa(3) + elf64_phdr_flags_foa) == elf_pf_r | elf_pf_x);
    assert(
        load.u64(region_base() + elf64_phdr_foa(2) + elf64_phdr_offset_foa) +
        load.u64(region_base() + elf64_phdr_foa(2) + elf64_phdr_filesz_foa) <=
        load.u64(region_base() + elf64_phdr_foa(3) + elf64_phdr_offset_foa)
    );
    assert(load.u32(region_base() + elf64_phdr_foa(4) + elf64_phdr_type_foa) == elf_pt_load);
    assert(load.u32(region_base() + elf64_phdr_foa(4) + elf64_phdr_flags_foa) == elf_pf_r | elf_pf_w);
    assert(load.u32(region_base() + elf64_phdr_foa(5) + elf64_phdr_type_foa) == elf_pt_dynamic);
}

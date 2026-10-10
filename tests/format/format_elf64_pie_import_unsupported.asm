import("format/format.inc");

// PIE accepts imports; AArch64 requires eager GOT slots rather than x86 PLT.
let image: map = format_elf64_aarch64(
    format_elf_pie,
    list.of(
        format_segment(".text", format_load | format_readable | format_executable)
    )
)
let imports: list = format_elfexe_import_new()
format_elfexe_import_many_mut(imports, "libc.so.6", list.of("getpid"))
format_elfexe_tables_mut(image, imports)

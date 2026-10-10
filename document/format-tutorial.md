# XIRASM Format Tutorial

This tutorial shows how to produce PE, ELF, COFF, and macOS Mach-O files directly with XIRASM. Everything starts from `format/format.inc`: you declare the file kind, its sections or load segments, the entry point, imports, exports, and relocations, and the file headers, tables, file offsets, RVAs, alignment, and final backfills are generated for you.

If you have mostly written inline assembly inside C, C++, Rust, or another language, the surrounding toolchain handled the file format, and none of the following questions came up. XIRASM writes the output file itself, so every one of them has to be answered:

- which label execution starts at;
- which bytes are code and which are data;
- which ranges become readable, writable, or executable memory;
- which ranges occupy memory but take no initialized file bytes;
- which external symbols are imported or exported;
- which absolute addresses the loader or linker has to adjust;
- which fields need a final backfill.

The whole tutorial needs one import:

```asm
import("format/format.inc")
```

The files under `include/format/` fall into three groups, and day-to-day work needs only the first:

- `format.inc` is the common entry point: format configuration, section and segment declarations, imports, exports, resources, relocations, symbol tables, and the final generation pass.
- `pe32.inc`, `pe64.inc`, `elf32.inc`, and `elf64.inc` are width-specific entry points, imported directly only to keep an existing source working or to write a specialized format.
- `pe.inc`, `elfexe.inc`, `elfobj.inc`, and their relatives expose finer constructors for headers, directories, section tables, program headers, and dynamic tables, used when `format.inc` cannot express the layout you need.

For hand-written PE/ELF headers, directories, section tables, program headers, or dynamic tables, read the [Advanced Format Construction Guide](advanced-formats.md).

## Chapters

1. [Choose a Template](format-tutorial/01-choose-a-template.md)
2. [Windows PE and DLLs](format-tutorial/02-windows-pe.md)
3. [Linux ELF Executables and Shared Objects](format-tutorial/03-linux-elf.md)
4. [COFF and ELF Object Files](format-tutorial/04-object-files.md)
5. [Common Rules and Mistakes](format-tutorial/05-common-rules.md)
6. [macOS Mach-O](format-tutorial/06-macos-macho.md)

See [Format validation](format-validation.md) for dynamic pointers and container input checks.

## Quick Choice Table

| Goal | Start with | Main calls |
| --- | --- | --- |
| Windows executable | `format_pe32` or `format_pe64` | `format_section_begin`, `format_pe_import_section`, `format_pe_resource_section`, `format_pe_reloc_section` |
| Windows DLL | `format_pe32` or `format_pe64` with `format_pe_dll` | `format_pe_export_section`, optional imports, resources, and relocations |
| Linux executable | `format_elf32` or `format_elf64` with `format_elf_exec` | `format_segment_begin`, `format_entry_mut`, `format_finish` |
| Linux PIE | `format_elf64` with `format_elf_pie` | `format_segment_begin`, `format_entry_mut`, `format_finish` |
| Linux shared object | `format_elf64_so` | `format_elfso_tables_mut`, `format_segment_begin`, `format_finish` |
| Android shared object (AArch64) | `format_elf64_so_aarch64` | `format_elfso_import_slots_mut`, `format_elfso_tables_mut`, `format_segment_begin`, `format_finish` |
| COFF object | `format_coff32` or `format_coff64` | `format_coff_tables_mut`, `format_section_begin`, `format_finish` |
| ELF object (x86) | `format_elfobj32` or `format_elfobj64` | `format_elfobj_tables_mut`, `format_section_begin`, `format_finish` |
| ELF object (AArch64) | `format_elfobj64_aarch64` | `format_elfobj_tables_mut`, `format_section_begin`, `format_finish` |
| macOS Mach-O object | `format_macho64_object` | `format_macho64_target_arm64` or `format_macho64_target_x86_64`, `format_macho64_tables_mut`, `format_section_begin`, `format_finish` |
| macOS Mach-O executable | `format_macho64_exe` | `format_macho64_segment`, `format_entry_mut`, `format_finish` |
| macOS Mach-O dylib | `format_macho64_dylib` | `format_macho64_segment`, `format_macho64_exports_mut`, `format_finish` |

## Lifecycle

Every format configuration follows one line of five steps:

```asm id=format-lifecycle target=x86-64
import("format/format.inc")

// 1. Build the configuration: file role, subsystem, safety flags, ASLR policy.
let image: map = format_pe64(
    format_pe_exe | format_pe_console | format_pe_nx | format_pe_aslr_disabled,
    list.of(
        // 2. Declare which sections the file has.
        format_section(".text", format_code | format_readable | format_executable)
    )
)

// 3. Start the output: the headers and section rows are reserved here.
format_begin(image)

// 4. Content goes only inside a declared section.
format_section_begin(image, ".text")
start:
    xor eax, eax
    ret
format_section_end(image, ".text")

// 5. An executable sets its entry, then every field is backfilled.
format_entry_mut(image, start)
format_finish(image)
```

Chapter 1 shows this skeleton in full, together with the ELF executable equivalent.

Metadata destined for the linker — symbol tables, relocation tables, import and export tables — attaches to the configuration before step 3, because the headers and dynamic tables have to reserve room for it. A function belongs to that group when its name ends in `format_*_tables_mut`; the rest write section content and belong between steps 3 and 5.

## Usage Principles

- Choose the output kind first, then write sections, segments, and tables; do not start from raw PE/ELF fields.
- Use `format_section(...)` for PE, COFF, and ELF object files; use `format_segment(...)` for ELF executables and shared objects.
- Headers, tables, alignment, RVAs, file offsets, and the final backfills come from `format.inc`; the source declares content boundaries and the metadata that cannot be derived.
- Do not mix `format.inc` with hand-written PE/ELF headers or tables in one file; when those fields must be written by hand, organize the whole file as advanced construction.
- Start from the smallest `.text` template, get it assembling, and only then add imports, exports, resources, relocations, and BSS.

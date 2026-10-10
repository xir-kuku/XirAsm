# Format validation

The helpers under `include/format/` check the structure they generate before accepting an output file. Finish each output explicitly: call `format_finish(image)` for a configured executable or object, and `zip_finish()` for a standalone ZIP. Adding ZIP entries without the final central directory is rejected, as is appending bytes after the completed archive.

ELF64 dynamic EXEC and PIE support x86-64 PLT imports and x86-64/AArch64 eager GOT imports. `format_elfexe_import_slots_mut(imports, library, names)` creates slots named by `names`; use an indirect call through the slot. Declare import tables, exports, and a custom interpreter before `format_begin`.

For an absolute pointer into a dynamic ELF image, place `format_elf_relptr_mut(image, segment_name, target_label)` at the pointer's location in an open writable segment. `target_label` is the label's name string, as used by the other dynamic format helpers. The slot uses a symbol-free `RELATIVE` relocation in PIE/SO. Default-visible exported targets require symbol-based slots to preserve interposition. Fixed-address dynamic EXEC writes the target address directly. An executable without import or export tables must enable the dynamic plan with `format_elf_dynamic_mut` before `format_begin` to use this helper.

AArch64 object relocation records remain explicit. Unknown types, unaligned instruction fields, and fields outside their section are rejected. Reserving a trailing address slot in a file-backed object section keeps that section `PROGBITS`; explicitly uninitialized `.bss` remains `NOBITS`.

Android AXML requires matching element and namespace closures, declared namespace URIs, and unique attributes within each element. AXML and ARSC string values accept strict UTF-8 input, including Chinese text, supplementary characters, and empty strings. The APK application helper requires at least one native library and a matching main library for every included ABI. Invalid package names, duplicate archive paths, invalid native ELF files, and insufficient native-library alignment are rejected.

AArch64 lazy PLT, TLS declarations, custom IFUNC/IRELATIVE resolvers, explicit symbol versions, and a complete linker remain outside these helpers. A64 instruction encoding and automatic instruction relocation capture are separate from the explicit format API.

# 4. COFF and ELF Object Files

A file handed to a linker and a file that runs directly are two different things. An object file has no entry address and no load segments: the operating system never loads it. It states which sections exist, which symbols the linker should see, and which fields the linker has to fill in, and tools like `link.exe` or `ld.lld` combine several object files into one executable.

Generating one with `format.inc` changes the order used in the previous chapters: declare the sections, write their content, and only then attach the symbol and relocation tables to the configuration before `format_finish`. Those two tables are the whole point of an object file, so they are required content rather than decoration.

## COFF Object Template

A COFF object serves MSVC-style linkers on Windows. It supports code, data, and BSS sections, and its section names are limited to eight bytes.

```asm id=coff64-object target=x86-64
import("format/format.inc")

// A 64-bit COFF object for Windows/MSVC-style linkers.
let object: map = format_coff64(
    list.of(
        format_section(".text", format_code | format_readable | format_executable),
        format_section(".data", format_data | format_readable | format_writeable),
        format_section(".bss", format_uninitialized_data | format_readable | format_writeable)
    )
)
format_begin(object)

// .text leaves a call displacement for the linker to fill in.
format_section_begin(object, ".text")
text_start:
main:
    db(0xe8)
call_disp:
    dd(0)
    xor eax, eax
    ret
format_section_end(object, ".text")

format_section_begin(object, ".data")
data_start:
answer:
    dd(42)
format_section_end(object, ".data")

format_section_begin(object, ".bss")
bss_start:
scratch:
    rb(64)
format_section_end(object, ".bss")

// Public and external symbols: the stored value is "address minus section start".
const symbols: list = list.of(
    format_coff_public("main", ".text", text_start, main, coff_sym_type_function),
    format_coff_public("answer", ".data", data_start, answer, coff_sym_type_null),
    format_coff_public("scratch", ".bss", bss_start, scratch, coff_sym_type_null),
    format_coff_extern("puts", coff_sym_type_function)
)

// The relocation names the four placeholder bytes of the call displacement.
const relocs: list = list.of(
    format_coff_reloc(".text", text_start, call_disp, "puts", coff_rel_amd64_rel32)
)
format_coff_tables_mut(object, symbols, relocs)
format_finish(object)
```

This example is 240 bytes. Its symbol table holds four symbols: `main` in `.text`, `answer` in `.data`, and `scratch` in `.bss`, all three with value 0 (their offset inside their section), while `puts` sits in `IMAGE_SYM_UNDEFINED` with function type, waiting for the linker to resolve it.

Two argument conventions:

- `format_coff_public(name, section_name, section_start, address, sym_type)` takes the symbol label as `address` and the containing section's start label as `section_start`; the value written into the symbol table is the difference between them.
- `format_coff_reloc(section_name, section_start, address, symbol_name, reloc_type)` takes as `address` the **placeholder the linker must correct**, not the target symbol. In the example above that is `call_disp`, the four-byte displacement of `call rel32`.

A COFF symbol name and a relocation's symbol reference are both limited to eight bytes; exceeding it reports `COFF symbol names must fit in eight bytes` or `COFF relocation symbol names must fit in eight bytes`. A repeated symbol name reports `COFF symbol name is duplicated`, and a relocation naming an undeclared symbol reports `COFF relocation target symbol is not declared`.

The eight-byte limit is checked while the symbol is constructed, so this layer never emits COFF's string-table indirection: the name goes straight into the eight-byte field and is padded with zeros, leaving the string table at the end of the symbol table as a four-byte header. A symbol name longer than eight bytes belongs to advanced construction.

Common relative call relocations:

| Width | Relocation type |
| --- | --- |
| 32-bit | `coff_rel_i386_rel32` |
| 64-bit | `coff_rel_amd64_rel32` |
| AArch64 | the `coff_rel_arm64_*` family |

## ELF Object Template

An ELF object serves linkers such as `ld` and `ld.lld`, and its section names are not limited to eight bytes.

```asm id=elfobj64-object target=x86-64
import("format/format.inc")

// ELF section names may be longer than eight bytes.
let object: map = format_elfobj64(
    list.of(
        format_section(".text", format_code | format_readable | format_executable),
        format_section(".bss", format_uninitialized_data | format_readable | format_writeable),
        format_section(".rodata", format_data | format_readable)
    )
)
format_begin(object)

format_section_begin(object, ".text")
text_start:
_start:
    db(0xe8)
call_disp:
    dd(0)
    xor eax, eax
    ret
format_section_end(object, ".text")

format_section_begin(object, ".bss")
bss_start:
scratch:
    reserve(64)
format_section_end(object, ".bss")

format_section_begin(object, ".rodata")
data_start:
answer:
    dd(42)
format_section_end(object, ".rodata")

// An ELF public symbol also needs a size and a type.
const symbols: list = list.of(
    format_elfobj_public("_start", ".text", text_start, _start, 8, elfobj_stt_func),
    format_elfobj_public("scratch", ".bss", bss_start, scratch, 64, elfobj_stt_object),
    format_elfobj_public("answer", ".rodata", data_start, answer, 4, elfobj_stt_object),
    format_elfobj_extern("puts", elfobj_stt_func)
)

// A RELA record carries an explicit addend: -4 is the width of the rel32 field.
const relocs: list = list.of(
    format_elfobj_reloc(".text", text_start, call_disp, "puts", elf_r_x86_64_plt32, 0xfffffffffffffffc)
)
format_elfobj_tables_mut(object, symbols, relocs)
format_finish(object)
```

This example is 992 bytes with type `ET_REL`. Its symbol table holds `_start` (function, size 8), `scratch` (data, size 64), `answer` (data, size 4), and an undefined `puts`; its relocation table holds one record, `R_X86_64_PLT32 puts 0xFFFFFFFFFFFFFFFC`.

ELF64 uses RELA records, with the addend written explicitly into the record. The addend above is `-4`, that is `0xfffffffffffffffc`, which is the width of the `rel32` displacement field itself, following the x86-64 psABI. This is where ELF objects differ most easily from COFF: a COFF displacement already includes "relative to the next instruction", while ELF leaves that to the addend.

`format_elfobj_public` takes two parameters more than its COFF counterpart: a symbol size and a symbol type (`elfobj_stt_notype`, `elfobj_stt_object`, `elfobj_stt_func`, `elfobj_stt_section`). The stored value is likewise "address minus section start".

Type and binding share one byte in the file: the type says whether the symbol is a function or data, and the binding is always global (`STB_GLOBAL`). Local binding appears only on the generated section symbols; a user-declared symbol has no local form.

The symbol table layout decides the index a relocation refers to:

1. index 0 is the reserved null symbol;
2. then one section symbol per section, with `shndx` set to the section number, occupying indices 1 through the section count;
3. user-declared symbols follow, so the first of them has index `1 + section count`.

The upper 32 bits of `r_info` in a relocation record hold exactly that index. Checking with `readelf -s` shows the user symbols after the section symbols.

## After the Linker Takes Over

The purpose of an object file is to be linked into something else, so the most direct check is to link it once for real. The example below exports one function for C to call:

```asm id=elfobj64-export-for-c target=x86-64
import("format/format.inc")

// An ELF64 object for mixed-language use: one function exported to C.
let object: map = format_elfobj64(
    list.of(
        format_section(".text", format_code | format_readable | format_executable)
    )
)
format_begin(object)

format_section_begin(object, ".text")
text_start:
xirasm_double:
    // long xirasm_double(long v) { return v * 2; }
    lea rax, [rdi + rdi]
    ret
format_section_end(object, ".text")

const symbols: list = list.of(
    format_elfobj_public("xirasm_double", ".text", text_start, xirasm_double, 4, elfobj_stt_func)
)
format_elfobj_tables_mut(object, symbols, list.new())
format_finish(object)
```

This example is 600 bytes. Write a C file declaring the same function name, then hand both files to `gcc`:

```c
#include <stdio.h>

/* xirasm_double comes from the XIRASM-generated ELF64 object. */
long xirasm_double(long value);

int main(void) {
    /* Call the function from the object and check that it returns 42. */
    long result = xirasm_double(21);
    printf("xirasm_double(21) = %ld\n", result);
    return result == 42 ? 0 : 1;
}
```

```text
gcc -o mix main.c mix.o
./mix
```

The program prints `xirasm_double(21) = 42` and exits with 0. Linking successfully means the names, types, and section numbers in the symbol table are all correct — the linker accepts the object file.

A cross-language call has to follow the ABI: on x86-64 Linux the first integer argument goes in `rdi` and the return value comes back in `rax`. The `lea rax, [rdi + rdi]` above is "return the first argument multiplied by two". A mismatch between argument types and registers still links and still runs, and produces a wrong answer — the ABI is an agreement between the two sides, and the linker cannot check it.

`readelf -s mix.o` checks the symbol table: `xirasm_double` has `Ndx` pointing at `.text`, `Type` set to `FUNC`, and `Size` 4.

An object file can also be disassembled before linking. `llvm-objdump -d` reconstructs the machine code from the symbol table and the relocations, which verifies instruction bytes, symbol values, and relocation records together — and it needs no successful link first:

```text
llvm-objdump -d mix.o
objdump -dr mix.o
```

`objdump -dr` prints the disassembly and the relocation records together, the usual way to check that a "placeholder bytes plus relocation" pair agrees.

### Choosing the ELF Machine

| Constructor | `e_machine` | Notes |
| --- | --- | --- |
| `format_elfobj32(sections)` | `EM_386` | also switches the assembler to 32-bit x86 text mode |
| `format_elfobj64(sections)` | `EM_X86_64` | also switches the assembler to 64-bit x86 text mode |
| `format_elfobj64_aarch64(sections)` | `EM_AARCH64` | arm64 Linux and BSD |
| `format_elfobj64_machine(sections, machine)` | by argument | accepts `elf_machine_x86_64` or `elf_machine_aarch64` |

The AArch64 form selects no x86 text mode, so instruction words are written as data: with `emit.u32`, or through the AArch64 DSL layer. Relocation types come from `elf_const.inc`:

```asm id=elfobj64-aarch64 target=aarch64
import("format/format.inc")

// An AArch64 object: instruction words go in as data, each relocation names one placeholder.
let object: map = format_elfobj64_aarch64(
    list.of(
        format_section(".text", format_code | format_readable | format_executable),
        format_section(".data", format_data | format_readable | format_writeable)
    )
)
format_begin(object)

format_section_begin(object, ".text")
text_start:
    // bl printf: the low 26 bits are left for the linker.
    bl_site:
        emit.u32(0x94000000)
    // adrp x0, answer: the page base part.
    page_site:
        emit.u32(0x90000000)
    // add x0, x0, :lo12:answer: the low 12 bits.
    lo12_site:
        emit.u32(0x91000000)
format_section_end(object, ".text")

format_section_begin(object, ".data")
data_start:
    // .xword printf: an eight-byte absolute address the linker fills in whole.
    ptr_slot:
        emit.u64(0)
format_section_end(object, ".data")

const symbols: list = list.of(
    format_elfobj_public("_start", ".text", text_start, bl_site, 16, elfobj_stt_func),
    format_elfobj_public("answer", ".data", data_start, ptr_slot, 8, elfobj_stt_object),
    format_elfobj_extern("printf", elfobj_stt_func)
)

// Each relocation names the placeholder word the linker corrects; AArch64 uses
// RELA, so the addend is explicit.
const relocs: list = list.of(
    format_elfobj_reloc(".text", text_start, bl_site, "printf", elf_r_aarch64_call26, 0),
    format_elfobj_reloc(".text", text_start, page_site, "answer", elf_r_aarch64_adr_prel_pg_hi21, 0),
    format_elfobj_reloc(".text", text_start, lo12_site, "answer", elf_r_aarch64_add_abs_lo12_nc, 0),
    format_elfobj_reloc(".data", data_start, ptr_slot, "printf", elf_r_aarch64_abs64, 0)
)
format_elfobj_tables_mut(object, symbols, relocs)
format_finish(object)
```

This example is 1016 bytes, its `e_machine` is `EM_AARCH64` (183), and its relocation table holds four records: `R_AARCH64_CALL26` at offset 0, `R_AARCH64_ADR_PREL_PG_HI21` at offset 4, `R_AARCH64_ADD_ABS_LO12_NC` at offset 8, and `R_AARCH64_ABS64` at offset 0 of `.data`.

When an `adrp` and an `add` together produce a symbol's address, each instruction needs its own relocation: the page base uses `elf_r_aarch64_adr_prel_pg_hi21` and the low 12 bits use `elf_r_aarch64_add_abs_lo12_nc`.

`elf_const.inc` also provides `elf_r_aarch64_abs64`, `elf_r_aarch64_abs32`, `elf_r_aarch64_adr_prel_lo21`, the `elf_r_aarch64_ldst{8,16,32,64}_abs_lo12_nc` family, `elf_r_aarch64_condbr19`, `elf_r_aarch64_jump26`, and the GOT forms `elf_r_aarch64_adr_got_page` and `elf_r_aarch64_ld64_got_lo12_nc`.

The AArch64 object facade rejects unknown relocation types, instruction relocation offsets that are not multiples of four, and fields that extend beyond the target section. Data relocations use their actual two-, four-, or eight-byte width. RELA addends are passed as 64-bit bit patterns; for example, `0xfffffffffffffffc` represents `-4`.

ELF32 uses `format_elfobj32`, and its common 32-bit relative call relocation is `elf_r_386_pc32`.

## Mach-O Objects

A Mach-O relocatable object comes from `format_macho64_object(target, sections)` in chapter 6, and follows the same section lifecycle as the two templates above. Its symbol table, relocation table, and `LC_SYMTAB` are covered there.

## API Summary

| Family | Function | Purpose |
| --- | --- | --- |
| COFF | `format_coff32(sections)` / `format_coff64(sections)` | create a COFF object configuration |
| COFF | `format_coff64_arm64(sections)` | create an AArch64 COFF object configuration |
| COFF | `format_coff_public(name, section_name, section_start, address, sym_type)` | declare a public symbol |
| COFF | `format_coff_extern(name, sym_type)` | declare an external symbol |
| COFF | `format_coff_reloc(section_name, section_start, address, symbol_name, reloc_type)` | declare a field the linker must correct |
| COFF | `format_coff_tables_mut(plan, symbols, relocs)` | attach the symbol and relocation tables |
| ELF | `format_elfobj32(sections)` / `format_elfobj64(sections)` | create an x86 object configuration |
| ELF | `format_elfobj64_aarch64(sections)` | create an AArch64 object configuration |
| ELF | `format_elfobj64_machine(sections, machine)` | create an object configuration for a named machine |
| ELF | `format_elfobj_public(name, section_name, section_start, address, symbol_size, symbol_type)` | declare a public symbol |
| ELF | `format_elfobj_extern(name, symbol_type)` | declare an external symbol |
| ELF | `format_elfobj_reloc(section_name, section_start, address, symbol_name, reloc_type, addend)` | declare a field the linker must correct |
| ELF | `format_elfobj_tables_mut(plan, symbols, relocs)` | attach the symbol and relocation tables |

A relocation must point at bytes that already exist. Write the placeholder first, then describe it with `format_*_reloc`; the reverse — declaring a relocation for a field that was never emitted — leaves the linker nothing to overwrite.

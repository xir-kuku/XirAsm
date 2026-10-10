# 3. Linux ELF Executables and Shared Objects

To produce a file that runs directly on Linux, or a `.so` that other programs load at run time, use the ELF format. An ELF image is not organized by sections the way a PE image is; it is organized by **load segments**: each segment states where it sits in the file, which virtual address it maps to, how many file bytes it covers, how much memory it reserves, and what permissions it has at run time. The loader reads only the program headers and maps the file into memory according to them.

Section names and segment names serve different readers: section names are for linkers and debuggers, segment names are for the loader. With `format.inc` you declare load segments, the program headers are generated from them, and so is the `p_vaddr == p_offset (mod p_align)` relation the loader depends on.

## ELF Executable

A fixed-address executable uses `format_elf_exec`:

```asm id=elf64-executable target=x86-64
import("format/format.inc")

// Three segments: code, initialized data, and zero-filled data.
let image: map = format_elf64(
    format_elf_exec,
    list.of(
        // Code segment: readable and executable.
        format_segment(".text", format_load | format_readable | format_executable),
        // Data segment: readable and writable.
        format_segment(".data", format_load | format_readable | format_writeable),
        // BSS segment: readable and writable, but memory only.
        format_segment(".bss", format_load | format_readable | format_writeable)
    )
)
format_begin(image)

format_segment_begin(image, ".text")
start:
    // Syscall 60: exit(0).
    mov eax, 60
    xor edi, edi
    syscall
format_segment_end(image, ".text")

format_segment_begin(image, ".data")
answer:
    dd(42)
format_segment_end(image, ".data")

format_segment_begin(image, ".bss")
scratch:
    rb(128)
format_segment_end(image, ".bss")

format_entry_mut(image, start)
format_finish(image)
```

This example is 253 bytes and carries three `PT_LOAD` program headers:

| Segment | File offset | Virtual address | File size | Memory size | Permissions |
| --- | --- | --- | --- | --- | --- |
| `.text` | `0xF0` | `0x4000F0` | 9 | 9 | `R\|X` |
| `.data` | `0xF9` | `0x4010F9` | 4 | 4 | `R\|W` |
| `.bss` | `0xFD` | `0x4020FD` | **0** | **128** | `R\|W` |

That `.bss` row is the whole meaning of BSS: no bytes in the file, 128 bytes of memory. `format.inc` writes those two numbers into the program header's `p_filesz` and `p_memsz`, and the loader zero-fills the range accordingly.

For ELF32, swap `format_elf64` for `format_elf32`; the option is still limited to `format_elf_exec`, because this layer has no ELF32 PIE entry point.

## A Program That Does Something

The example above only clears a register and exits, which says little about writing a real program. The one below prints a line of text and reports a computed value through its exit code — the result a script or CI job checks most easily:

```asm id=linux-write-and-exit target=x86-64
import("format/format.inc")

// A real Linux x86-64 program: compute a value, print a line, exit with the value.
let image: map = format_elf64(
    format_elf_exec,
    list.of(
        // Code segment: readable and executable.
        format_segment(".text", format_load | format_readable | format_executable),
        // Read-only data segment: the message.
        format_segment(".rodata", format_load | format_readable)
    )
)

// The value is computed from these two.
const INPUT: u64 = 35
const DELTA: u64 = 7

format_begin(image)

format_segment_begin(image, ".text")
start:
    // Compute the argument: lea adds without touching the flags.
    lea r12, [INPUT + DELTA]

    // write(1, message, length)
    mov eax, 1
    mov edi, 1
    lea rsi, [rel message]
    lea rdx, [rel message_end]
    sub rdx, rsi
    syscall

    // exit(result)
    mov edi, r12d
    mov eax, 60
    syscall
format_segment_end(image, ".text")

format_segment_begin(image, ".rodata")
message:
    db("xirasm: exit status carries the computed result", 10)
// The trailing label measures the length, so no byte count is written by hand.
message_end:
format_segment_end(image, ".rodata")

format_entry_mut(image, start)
format_finish(image)
```

This example is 271 bytes with two `PT_LOAD` segments: `.text` at offset `0xB0`, 47 bytes, permissions `R|X`, and `.rodata` at offset `0xDF`, 48 bytes, permissions `R` — code and data sit apart, and read-only data carries no execute permission.

Run it on x86-64 Linux and the terminal prints:

```text
xirasm: exit status carries the computed result
```

The exit status is `42`, the value of `INPUT + DELTA`.

Two habits in that source are worth keeping:

- **Measure a string with a label.** `lea rdx, [rel message_end]` minus `rsi` is the length, computed by the assembler; a hard-coded byte count has to be edited whenever the text changes.
- **Cross-segment references need `rel`.** Code in `.text` reaching a label in `.rodata` must use the RIP-relative form, which holds wherever the segment lands.

## ELF64 PIE

A position-independent executable uses `format_elf_pie`:

```asm id=elf64-pie target=x86-64
import("format/format.inc")

let image: map = format_elf64(
    format_elf_pie,
    list.of(
        format_segment(".text", format_load | format_readable | format_executable),
        format_segment(".bss", format_load | format_readable | format_writeable),
        format_segment(".rodata", format_load | format_readable)
    )
)
format_begin(image)

format_segment_begin(image, ".text")
start:
    // The loader may move the whole image, so every label reference is RIP-relative.
    lea rbx, [rel scratch]
    lea rsi, [rel message]
    mov dword [rbx], 0x5a
    mov eax, 60
    xor edi, edi
    syscall
format_segment_end(image, ".text")

format_segment_begin(image, ".bss")
scratch:
    rb(64)
format_segment_end(image, ".bss")

format_segment_begin(image, ".rodata")
message:
    db("XIRASM PIE", 0)
format_segment_end(image, ".rodata")

format_entry_mut(image, start)
format_finish(image)
```

PIE differs from a fixed-address executable in one substantial way: the loader decides the base address. **Every reference into the image must therefore be RIP-relative** (`[rel label]`), which encodes a displacement that holds wherever the image moves and needs no dynamic relocation. Storing an absolute pointer in `.data` instead does require a dynamic relocation, and arbitrary user pointer relocations are not available through `format.inc`; they belong to direct ELF construction.

PIE does not support executable imports. Attaching an import table to a PIE configuration reports `ELF executable imports require fixed-address EXEC mode`.

## ELF64 Executable Imports

A fixed-address executable can call external functions through PLT entries. Once imports are declared, `format.inc` generates the dynamic segment, the PLT, the GOT, and the matching relocations:

```asm id=elf64-exe-imports target=x86-64
import("format/format.inc")

let image: map = format_elf64(
    format_elf_exec,
    list.of(
        format_segment(".text", format_load | format_readable | format_executable)
    )
)

// One grouped call per library, all sharing one import list.
let imports: list = format_elfexe_import_new()
format_elfexe_import_many_mut(imports, "libc.so.6", list.of("getpid", "getppid"))
// cos is imported under the local prefix cos_fn.
format_elfexe_import_pairs_mut(imports, "libm.so.6", list.of("cos_fn", "cos"))
format_elfexe_tables_mut(image, imports)

format_begin(image)

format_segment_begin(image, ".text")
start:
    // Call the generated PLT labels.
    call getpid_plt
    call getppid_plt
    xor edi, edi
    mov eax, 60
    syscall
format_segment_end(image, ".text")

format_entry_mut(image, start)
format_finish(image)
```

This example is 960 bytes, and its dynamic segment carries two `NEEDED` entries (`libc.so.6` and `libm.so.6`) with three undefined functions in the dynamic symbol table: `getpid`, `getppid`, and `cos`.

Declaring imports adds load segments to the file. The example above declares one load segment, `.text`, and ends up with five program headers:

| Program header | File offset | Virtual address | File size | Permissions | Source |
| --- | --- | --- | --- | --- | --- |
| `PT_LOAD` | `0x0` | `0x400000` | 371 | `R\|X` | the declared `.text` |
| `PT_LOAD` | `0x180` | `0x401180` | 64 | `R\|X` | generated, holding the PLT |
| `PT_LOAD` | `0x1C0` | `0x4021C0` | 512 | `R\|W` | generated, holding the GOT, dynamic symbols, strings, hash, RELA, and the dynamic segment |
| `PT_INTERP` | `0x1F0` | `0x4021F0` | 28 | `R` | the dynamic linker path |
| `PT_DYNAMIC` | `0x300` | `0x402300` | 192 | `R\|W` | the dynamic segment itself |

The two generated load segments follow every declared segment, each page-aligned. File size and address layout therefore cannot be computed from the declared segments alone — the import tables take a writable segment of their own. The linker path is fixed at `/lib64/ld-linux-x86-64.so.2`, written where `PT_INTERP` points.

The writable segment lays its content out in a fixed order: GOTPLT, the interpreter path, the dynamic symbol table, the dynamic string table, the hash, `RELA.PLT`, and the dynamic segment. That order is not an option to adjust; `format.inc` writes each part aligned to the next, so the offsets inside the segment are predictable.

Label names follow a rule: `many` uses the imported name, so `getpid` becomes `getpid_plt` and `getpid_gotplt`; a `pairs` list gives "local prefix, real symbol name", so `cos_fn` becomes `cos_fn_plt` and `cos_fn_gotplt`. A `pairs` list needs an even number of entries, at most 128.

`format_elfexe_tables_mut` must be called **before** `format_begin`: the dynamic segment, the PLT, and the GOT need their space reserved before output starts.

Calling into libc means loading the argument registers and then calling a generated PLT label. The program below prints a line with `write` and then uses the value from `getpid` as its exit status:

```asm id=linux-libc-imports target=x86-64
import("format/format.inc")

// A real program with libc imports: write to print, getpid for the result.
let image: map = format_elf64(
    format_elf_exec,
    list.of(
        format_segment(".text", format_load | format_readable | format_executable),
        format_segment(".rodata", format_load | format_readable)
    )
)

let imports: list = format_elfexe_import_new()
format_elfexe_import_many_mut(imports, "libc.so.6", list.of("write", "getpid"))
format_elfexe_tables_mut(image, imports)

format_begin(image)

format_segment_begin(image, ".text")
start:
    // write(1, message, length): a libc call through the PLT.
    mov edi, 1
    lea rsi, [rel message]
    lea rdx, [rel message_end]
    sub rdx, rsi
    call write_plt

    // getpid(): returns the current process id.
    call getpid_plt

    // Carry the value out through the exit status so a script can check it.
    mov edi, eax
    mov eax, 60
    syscall
format_segment_end(image, ".text")

format_segment_begin(image, ".rodata")
message:
    db("xirasm: write() came from libc through the PLT", 10)
message_end:
format_segment_end(image, ".rodata")

format_entry_mut(image, start)
format_finish(image)
```

This example is 960 bytes. The program prints `xirasm: write() came from libc through the PLT` on x86-64 Linux, and its exit status is the current process id, which differs on every run.

`readelf -d` shows the parts `format.inc` generated: one `NEEDED` naming `libc.so.6`, `PLTRELSZ` of 48 bytes — two imported functions, each a 24-byte RELA record — and `PLTREL` set to `RELA`. `ldd` lists three dependencies: `linux-vdso.so.1`, `libc.so.6`, and `/lib64/ld-linux-x86-64.so.2`, the last being the interpreter named by `PT_INTERP` and filled in by `format.inc`.

Two habits matter here. Place arguments in System V AMD64 register order (`rdi`, `rsi`, `rdx`, …) before the `call`; a wrong order or count still assembles and links, and produces the wrong answer. After the call, read the result out of `eax` before deciding what to do — the example moves `eax` into `edi` precisely to use it as the exit status.

## ELF64 Shared Object

A shared object has no executable entry. It exposes dynamic symbols and may also import symbols. The SONAME is an argument to the constructor:

```asm id=elf64-so-exports target=x86-64
import("format/format.inc")

let image: map = format_elf64_so(
    "libxirasm_demo.so",
    list.of(
        format_segment(".text", format_load | format_readable | format_executable)
    )
)

let exports: list = format_elfso_export_new()
// Two functions exported under their label names, each four bytes.
format_elfso_export_many_mut(exports, list.of("x_add7", "x_sub3"), ".text", 4)
// answer_impl exported as x_answer, six bytes.
format_elfso_export_pairs_mut(exports, list.of("answer_impl", "x_answer"), ".text", 6)
format_elfso_tables_mut(image, exports, list.new())

format_begin(image)

format_segment_begin(image, ".text")
x_add7:
    lea eax, [rdi + 7]
    ret
x_sub3:
    lea eax, [rdi - 3]
    ret
answer_impl:
    mov eax, 42
    ret
format_segment_end(image, ".text")

format_finish(image)
```

An export declaration names the segment it lives in and the symbol size. `.dynsym`, `.dynstr`, the hash, `.dynamic`, and the GOT/PLT come from `format.inc`. A shared object does not call `format_entry_mut` either.

A shared object carries a section header table; an executable does not. Both files below were generated for x86-64 by `format.inc`, and they differ in header and layout like this:

| Item | ELF executable | ELF shared object |
| --- | --- | --- |
| File type | `ET_EXEC`, or `ET_DYN` for PIE | `ET_DYN` |
| Section header table | **absent** (`e_shnum = 0`) | present, seven entries: the null section, `.text`, `.dynsym`, `.dynstr`, `.hash`, `.dynamic`, `.shstrtab` |
| Segment base | from `0x400000` | from `0` |
| Segment mapping | one `PT_LOAD` per declared segment | declared segments inside `PT_LOAD`, plus `PT_DYNAMIC` |

A shared object starts at address 0 because the loader decides where it goes; the addresses in its section headers are recorded against a base of 0. Because an executable has no section header table, `readelf -S` prints nothing for it; use `readelf -l` for the program headers, or `llvm-readobj --program-headers`.

## ELF64 Shared Object Imports

A shared object imports with the same per-library grouping, except that imports and exports share one `tables_mut` call:

```text
let imports: list = format_elfso_import_new()
format_elfso_import_many_mut(imports, "libc.so.6", list.of("puts", "getpid"))
format_elfso_import_pairs_mut(imports, "libm.so.6", list.of("cos_fn", "cos"))
format_elfso_tables_mut(image, exports, imports)
```

Import names and export names must not collide, and the generated `*_plt` and `*_gotplt` labels must be unique. References inside the image are written `rel`; calls into an import use a generated PLT label.

## Choosing the Machine

`format_elf64` and `format_elf64_so` build x86-64 images by default. AArch64 has its own entry points, and a machine-parameterized form covers the case where the machine comes from configuration:

| Entry point | Result |
| --- | --- |
| `format_elf64(options, segments)` | ELF64 x86-64 executable or PIE |
| `format_elf64_aarch64(options, segments)` | ELF64 AArch64 executable or PIE |
| `format_elf64_machine(options, segments, machine)` | machine named by `elf_machine_x86_64` or `elf_machine_aarch64` |
| `format_elf64_so(soname, segments)` | ELF64 x86-64 shared object, LOAD segments aligned to 4 KiB |
| `format_elf64_so_aarch64(soname, segments)` | ELF64 AArch64 shared object, LOAD segments aligned to 16 KiB |
| `format_elf64_so_machine(soname, segments, machine)` | shared object for a machine named by argument |
| `format_elfobj64_aarch64(sections)` | AArch64 ELF64 object file |

The two machines differ in three places:

| Difference | x86-64 | AArch64 |
| --- | --- | --- |
| LOAD segment page alignment | 4 KiB, the Linux default | **16 KiB**, required by Android 15 and later |
| Import mechanism | PLT entries and GLOB_DAT slots, including mixed imports | GLOB_DAT slots, declared with `format_elfso_import_slots_mut` |
| Executable imports | supported | unsupported, import through a shared object instead |

A larger page alignment costs file bytes only when a segment has to move to the next page boundary: virtual addresses advance by whole pages while the file layout stays compact. To choose another page size, set `"load_align"` on the configuration before `format_begin`.

`"load_align"` must be a nonzero power of two. It controls page alignment for user LOAD segments, the PLT, and dynamic metadata. Set it to `elf_android_page_align` when packaging an x86-64 shared object for Android, so both its LOAD segments and its APK entry data align to 16 KiB.

x86-64 shared objects accept GOT slots declared with `format_elfso_import_slots_mut` together with PLT imports. Dynamic symbol records default to `elf_stt_func`; set `"type"` to `elf_stt_object` on an import or export record for a data symbol. Data imports require GOT slots. Export addresses and sizes must fit within their declared segment. Library and dynamic symbol names cannot contain NUL. Generated table names such as `.dynsym` and `.dynamic` are reserved by the format layer.

Each load segment also honours the alignment its sections declare: 16 bytes for a segment marked `format_executable`, 8 bytes otherwise. That alignment applies to the **file offset** as well, because the loader requires `p_vaddr == p_offset (mod p_align)` — the low bits of the address follow from the file offset, so moving only the address would break the relation. The result is that every section satisfies `sh_addr % sh_addralign == 0`, which is the guarantee code doing aligned accesses depends on; the cost is a few padding bytes when a segment would otherwise land on a carry inside the page.

## API Summary

| Function | Purpose |
| --- | --- |
| `format_elf32(format_elf_exec, segments)` | ELF32 executable |
| `format_elf64(format_elf_exec, segments)` | ELF64 x86-64 fixed-address executable |
| `format_elf64(format_elf_pie, segments)` | ELF64 x86-64 PIE |
| `format_elf64_aarch64(options, segments)` | ELF64 AArch64 executable or PIE |
| `format_elf64_machine(options, segments, machine)` | ELF64 executable or PIE for a named machine |
| `format_elf64_so(soname, segments)` | ELF64 x86-64 shared object |
| `format_elf64_so_aarch64(soname, segments)` | ELF64 AArch64 shared object, Android page alignment |
| `format_elf64_so_machine(soname, segments, machine)` | ELF64 shared object for a named machine |
| `format_elfobj64_aarch64(sections)` | AArch64 ELF64 object file |
| `format_elfexe_import_new()` | create an ELF64 executable import list |
| `format_elfexe_import_many_mut(imports, library, names)` | add a batch of same-named imports from one library |
| `format_elfexe_import_pairs_mut(imports, library, pairs)` | add "local prefix, real symbol name" pairs |
| `format_elfexe_tables_mut(plan, imports)` | attach executable import metadata to the configuration |
| `format_elfso_export_new()` | create a shared-object export list |
| `format_elfso_export_many_mut(exports, names, segment, size)` | export a batch of same-named symbols |
| `format_elfso_export_pairs_mut(exports, pairs, segment, size)` | export "internal label, public name" pairs |
| `format_elfso_import_new()` | create a shared-object import list |
| `format_elfso_import_many_mut(imports, library, names)` | add a batch of shared-object imports from one library |
| `format_elfso_import_pairs_mut(imports, library, pairs)` | add "local prefix, real symbol name" pairs |
| `format_elfso_import_slots_mut(imports, library, names)` | x86-64/AArch64 shared-object GLOB_DAT import slots |
| `format_elfso_tables_mut(plan, exports, imports)` | attach shared-object dynamic metadata to the configuration |

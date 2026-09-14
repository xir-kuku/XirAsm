# XIRASM

[简体中文](README.zh-CN.md) | [Website](https://xirasm-site.pages.dev/) | [What's New](https://xirasm-site.pages.dev/#updates)

**One modern assembler for x86, AArch64, RISC-V, and SPIR-V. Write real
assembly, emit usable binaries for Windows, Linux, macOS, and Android, and make
the build programmable when you need more.**

XIRASM is an assembler that finishes the job. You write ordinary assembly text,
and what comes out is a file you can run: a Windows PE, a Linux ELF, a macOS
Mach-O image, a flat binary, a SPIR-V module, or an installable Android APK.
Nothing sits between the source and that file — the format layer writes the import
tables, the relocation records, and the alignment itself.

Reach for the compile-time language when a project outgrows copy-and-paste. It is
not a text-macro layer: it is a typed language that runs while assembling and
leaves nothing behind in the output.

- **Four instruction sets:** x86 in 16/32/64-bit modes, AArch64, RV32/RV64, and
  SPIR-V 1.6.
- **Output that runs:** PE32/PE64 executables and DLLs, COFF32/COFF64 objects,
  ELF32/ELF64 executables, ELF64 PIE and shared libraries, Mach-O 64 executables,
  dylibs and objects, flat binaries, SPIR-V modules, and installable Android APKs.
- **The linker's share of the work is already done:** import tables, export
  tables, base relocations, PLT/GOT slots, dynamic symbol tables, and dyld stubs
  are written by the format layer, so one source file can become a runnable image.
- **AArch64 that reaches a real device:** `arm/a64-macros.inc` brings AArch64
  instruction text, and the format layer carries the encoded bytes into ELF64
  executables, PIE, objects, and Android shared libraries, PE64/COFF64 images,
  and Mach-O arm64 executables, dylibs, and objects, with the relocations and
  import stubs each of those needs.
- **Android without a Java build:** the APK writer emits the ZIP container, the
  binary `AndroidManifest.xml`, and a `resources.arsc` compiled from a resource
  tree, and it can carry the NativeActivity shared library assembled from the
  same source. Platform resource IDs such as
  `@android:style/Theme.DeviceDefault` come from a generated framework catalog.
- **A language, not a macro layer:** typed values, functions, collections,
  modules, structured control flow, and source-located diagnostics. Project
  templates give you a working Windows, Linux, or bare-metal program in one
  command.

## Download

Every release is published as prebuilt packages as well, so a toolchain is only
needed if you want to change XIRASM itself:

- Windows x86-64 (ZIP) and Linux x86-64 (statically linked TAR.GZ);
- macOS Apple Silicon (TAR.GZ);
- the VS Code extension and language server (VSIX).

Get the current release from [the project site](https://xirasm-site.pages.dev/#downloads)
or from the [GitHub release](https://github.com/xir-kuku/XirAsm/releases/latest), which
lists the SHA-256 of every package. Each archive carries the executable, the
`include` library, the test corpus, and the English and Chinese documentation.

## Build a Native Program

Build XIRASM with Zig 0.17, or start from a package above:

```text
zig build -Doptimize=ReleaseSafe
```

Put the resulting `xirasm` executable on `PATH`, then create and build a native
project:

```text
xirasm init hello --template pe64
cd hello
xirasm build
```

The generated project carries its own source and `xirasm.toml`, so after that the
build is just `xirasm build`. `--template elf64` produces the same starter as an
ELF executable, and `xirasm help templates` lists the rest.

Assembling a single file needs no options at all: `xirasm hello.asm` writes
`hello.bin` beside it, and `--isa` only supplies a starting target for a source
that does not select one itself. Output format is not a command-line concern —
the source imports the format layer it wants and the assembler just turns the
source into bytes.

`--listing hello.lst` writes a listing beside the output. Its rows lead with the
address, then the file offset, the source line, a row kind (`code`, `data`,
`resv`, `algn`, `gap`, `trim`), the expansion depth, the bytes, and the source
line. Bytes that the file holds but no fragment claims appear as `gap` rows with
their actual contents; reserved space trimmed from the file tail appears as `trim`
with no file offset, because the file holds no byte there. A line produced by a
macro or function expansion leads with the call site that produced it, so a
listing of a macro library stays readable.

One CLI rule worth knowing up front: subcommands come before their options, so it
is `xirasm build --timings`, not `xirasm --timings build`.

## Assembly Stays Assembly

Labels and processor instructions use their normal text form. Compile-time code
appears only where it earns its place:

```asm
x86.use64();

fn emit_square_table(count: u8) {
    for value in range(0, count) {
        dd(value * value);
    }
}

const answer: u32 = 40 + 2;

entry:
    mov eax, answer
    ret

table:
emit_square_table(4);
```

The function and loop run while assembling. The output contains only the
machine code and generated data, with no runtime interpreter and no instruction
wrapper syntax.

For a minimal flat binary, a source file can be as small as:

```asm
x86.use64();

entry:
    mov eax, 42
    ret
```

```text
xirasm hello.asm
```

## One Tool, Multiple Targets

| Instruction set | How you select it | What it produces |
| --- | --- | --- |
| x86, 16/32/64-bit | `--isa x86-64` or `--isa x86` | PE32/PE64, COFF32/COFF64, ELF32/ELF64, flat images |
| AArch64 | `--isa aarch64`, or `import("arm/a64-macros.inc")` in the source | ELF64 executables, PIE, shared libraries and objects, PE64, COFF64, Mach-O arm64, Android libraries |
| RISC-V RV64/RV32 | `--isa rv64` or `--isa rv32` | flat images and RISC-V instruction streams |
| SPIR-V 1.6 | `--isa spv` | complete modules for GPU and IR tooling |

The ISA flag is a starting target, not a requirement: a source that selects an ISA
itself (`x86.use64()`, `riscv.use32()`, the A64 macros) decides, and the flag only
covers sources that do not. `--target` is the older spelling of `--isa` and still
works.

AArch64 has no backend encoder: its instruction layer is an include, not a decoder
in the assembler. Once imported, `mov x8, #93` and `svc #0` assemble like any other
instruction, and the format facade decides whether the result becomes an ELF64
image, a PE64 image, an object file, or a Mach-O image. The PE, COFF, ELF, and
Mach-O facades cover x86-64 and AArch64 today; RISC-V and SPIR-V are assembled to
instruction streams and modules.

The project model and the compile-time language are the same across all four. You
do not learn one macro system for x86 and a different generation language for
RISC-V.

## Output Formats

| Platform | What XIRASM writes |
| --- | --- |
| Windows | PE32/PE64 executables and DLLs for x86 and ARM64, with import tables, export tables, resources, and `.reloc` base relocations (DIR64 and HIGHLOW); COFF32/COFF64 objects carrying x86-64 and ARM64 relocations |
| Linux | ELF32/ELF64 executables, ELF64 PIE and shared libraries for x86-64 and AArch64, and ELF32/ELF64 objects. Shared-library imports get `.plt`/`.got.plt` with `R_X86_64_JUMP_SLOT` on x86-64 and `.got` with `R_AARCH64_GLOB_DAT` on AArch64, plus the dynamic symbol table and hash; executables get `.rela.plt` and PLT stubs |
| macOS | Mach-O 64 executables, dylibs, and objects for x86_64 and arm64, with dyld imports (stubs and slots) and export tries |
| Android | APK archives: ZIP container, binary manifest, `resources.arsc` compiled from a `res/` tree, assets (optionally DEFLATE), and per-ABI native libraries |
| Bare metal and tooling | Flat and application-specific binaries |
| GPU and IR tooling | Complete SPIR-V 1.6 modules |

Normal PE, COFF, ELF, and Mach-O projects use the format library's high-level
facades:

```asm
import("format/format.inc");
```

That library is not compiler machinery. It is XIRASM source: 34 `.inc` files under
`include/format/`, plus a generated resource-ID catalog, covering PE, COFF, ELF,
Mach-O, ZIP, and the pieces an APK needs. You can read it, change it, or copy one
as the starting point for a format of your own. When a loader or file format needs
an unusual layout, regions, labels, alignment, fixups, and finalizers are
available at the same level.

## Build an Android APK

An APK is a ZIP archive holding a binary manifest and a compiled resource table.
XIRASM writes all three, and the native library inside can come from the same
project:

```asm
import("format/apk.inc");

origin(0)

let app: map = apk_new("com.example.tool", 1, "1.0", "demo")
app = apk_res_dir(app, "res")
app = apk_native_lib(app, "arm64-v8a", "libdemo.so", "build/arm64-v8a/libdemo.so")
apk_emit(app)
```

The archive installs and runs with no DEX, no Java source, and no third-party
runtime: the activity is a NativeActivity whose entry point is the shared
library's own `ANativeActivity_onCreate`.

What the APK writer covers: `apk_res_dir` scans a `res/` tree and compiles it into
`resources.arsc`, density and locale qualifiers included, so a `values-zh`
directory works; assets can be stored with DEFLATE while the shared libraries and
the resource table stay uncompressed and aligned, which is what Android requires —
AArch64 libraries are aligned for Android 15+ 16 KiB pages. The platform's own
resource IDs, `@android:style/Theme.DeviceDefault` among them, come from a
catalog generated by reading `android.jar` through `aapt2`.

`tests/format/android_gl_demo/` is the proof: a GLES2 renderer and the archive
around it, both written by the assembler — 6,496 bytes of library inside a 39 KB
APK, with the texture generated at assembly time. `aapt2` and `zipalign` read the
result back cleanly. Signing stays outside the assembler on purpose; the
[Android guide](document/android.md) has the SDK command sequence.

The platform libraries themselves are catalogued: `import("os/android/imports/liblog.inc")`
gives you `android_import_log___android_log_write`, so a source never spells a
library name or an API level by hand, and `import("os/android/defs/native_activity.inc")`
gives you the structures the platform hands back — 25 libraries and 4,416
symbol/library rows from the NDK stubs, plus 1,168 constants and 161 field offsets
from the NDK headers, each checked against `llvm-nm` and clang. The same
[Android guide](document/android.md) covers the two ways to use that catalog and
where the data stops being true.

## More Than a Macro Assembler

XIRASM's compile-time language is designed for assembly projects that outgrow
copy-and-paste and textual substitution:

- typed constants, mutable bindings, functions, and lexical scope;
- `if`/`else if`, `while`, `for`, `break`, and `continue`;
- strings, byte sequences, mutable lists and maps;
- structs, unions, packing, alignment, and reserve operations;
- modules, imports, JSON, TOML, and file-driven generation;
- reading files and listing directories while assembling;
- raw DEFLATE compression for the archive entries the format layer writes;
- token matching for compact domain-specific source forms;
- assertions and diagnostics tied to the original source location.

That is what makes XIRASM useful for systems programs, executable-format work,
embedded binaries, and instruction-level experiments, without turning ordinary
instruction text into a programming-language API.

## Validation

The regression suite checks final encoded bytes and boundary behavior, not only
whether source text parses. It includes x86 layout and fixup cases, RISC-V and
AArch64 byte comparisons with LLVM tooling, SPIR-V assembly/disassembly and
validation, and structural, linker, loader, and native-runtime checks for
supported binary formats. Independent readers verify the results: LLVM tools for
instruction encodings and ELF, COFF, and Mach-O structure, and Android SDK tools
(`aapt2`, `zipalign`) plus a separate decompressor for the APK.

## Editor and Documentation

The standalone [XIRASM VS Code extension](https://github.com/xir-kuku/xir-vscode)
provides highlighting, completion, navigation, and compiler-backed diagnostics.

- [Language Guide](document/language.md) - learn the assembly and compile-time
  language model.
- [Format Tutorial](document/format-tutorial.md) - build PE, COFF, ELF, and
  Mach-O files with user-facing facade APIs.
- [Android Guide](document/android.md) - assemble a NativeActivity library and the
  APK, resource table, and manifest around it, and use the generated NDK symbol
  catalog and header constants instead of hand-written library names and offsets.
- [Language API Reference](document/api-reference.md) - look up syntax and
  built-in APIs.
- [Advanced Format Construction](document/advanced-formats.md) - take direct
  control of uncommon binary layouts.

## Status

Current version: **0.3.3**. See the [release notes](document/releases/0.3.3.md).

XIRASM is pre-1.0 software. The assembler, language APIs, format library, CLI, and
editor support are usable today, and public contracts may still be refined before
1.0. It is not meant to take the place of the established macro assemblers — they
carry decades of tooling and far larger ecosystems. What XIRASM offers instead is
four instruction sets under one language model, a format layer you can read and
change, and whole-image output with no linker in the middle.

## License

Apache-2.0.

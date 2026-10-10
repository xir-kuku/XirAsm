# 4. COFF 和 ELF 目标文件

发给链接器的文件，和能直接运行的文件，是两回事。目标文件里没有入口地址，也没有装载段：操作系统不会加载它，它只负责说明「有哪些节、哪些符号要让链接器看见、哪些字段要留给链接器回填」，由 `link.exe`、`ld.lld` 之类的工具把多个目标文件拼成一个可执行文件。

用 `format.inc` 生成目标文件时，前面几章的顺序有一处不同：先声明节、写内容，**再**把符号表和重定位表挂到配置上，最后 `format_finish`。符号表和重定位表就是目标文件的全部意义，因此它们不是可选装饰，而是必须提供的内容。

## COFF 目标文件模板

COFF 目标文件供 Windows 的 MSVC 风格链接器使用，支持代码、数据、BSS 三类节，节名不能超过八字节。

```asm id=coff64-object target=x86-64
import("format/format.inc")

// 面向 Windows/MSVC 风格链接器的 64 位 COFF 目标文件。
let object: map = format_coff64(
    list.of(
        format_section(".text", format_code | format_readable | format_executable),
        format_section(".data", format_data | format_readable | format_writeable),
        format_section(".bss", format_uninitialized_data | format_readable | format_writeable)
    )
)
format_begin(object)

// .text 里留一个 call 位移占位，链接器负责回填。
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

// 声明公开符号和外部符号：符号值是「地址 − 所在节起始」。
const symbols: list = list.of(
    format_coff_public("main", ".text", text_start, main, coff_sym_type_function),
    format_coff_public("answer", ".data", data_start, answer, coff_sym_type_null),
    format_coff_public("scratch", ".bss", bss_start, scratch, coff_sym_type_null),
    format_coff_extern("puts", coff_sym_type_function)
)

// 重定位指向 call_disp 这 4 字节占位，类型取 32 位相对调用。
const relocs: list = list.of(
    format_coff_reloc(".text", text_start, call_disp, "puts", coff_rel_amd64_rel32)
)
format_coff_tables_mut(object, symbols, relocs)
format_finish(object)
```

生成的映像为 240 字节，符号表里有四个符号：`main` 落在 `.text`、`answer` 落在 `.data`、`scratch` 落在 `.bss`，三个值都是 0（各自节内的偏移），而 `puts` 落在 `IMAGE_SYM_UNDEFINED`，类型是函数，等待链接器解析。

两条参数约定：

- `format_coff_public(name, section_name, section_start, address, sym_type)` 的 `address` 是符号标签，`section_start` 是它所在节的起始标签，写进符号表的值是两者之差；
- `format_coff_reloc(section_name, section_start, address, symbol_name, reloc_type)` 的 `address` 是**需要链接器修正的占位**，不是目标符号。上例的 `call_disp` 就是 `call rel32` 那条 4 字节位移。

COFF 符号名和重定位引用的符号名都不能超过八字节，超出报 `COFF symbol names must fit in eight bytes` 或 `COFF relocation symbol names must fit in eight bytes`。符号名重复报 `COFF symbol name is duplicated`，重定位引用了没声明的符号报 `COFF relocation target symbol is not declared`。

这八字节限制在构造符号时就检查，因此这一层不会生成 COFF 的字符串表间接名：名字直接写进 8 字节字段，后面用零补齐，符号表末尾的字符串表只留 4 字节头。需要超过八字节的符号名时，走高级格式构造。

常用相对调用重定位：

| 位宽 | 重定位类型 |
| --- | --- |
| 32 位 | `coff_rel_i386_rel32` |
| 64 位 | `coff_rel_amd64_rel32` |
| AArch64 | `coff_rel_arm64_*` 系列 |

## ELF 目标文件模板

ELF 目标文件供 `ld`、`ld.lld` 这类链接器使用，节名不受八字节限制。

```asm id=elfobj64-object target=x86-64
import("format/format.inc")

// ELF 目标文件的节名可以超过 8 字节。
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

// ELF 公开符号除名称、节、节起始、地址外，还要给符号大小和类型。
const symbols: list = list.of(
    format_elfobj_public("_start", ".text", text_start, _start, 8, elfobj_stt_func),
    format_elfobj_public("scratch", ".bss", bss_start, scratch, 64, elfobj_stt_object),
    format_elfobj_public("answer", ".rodata", data_start, answer, 4, elfobj_stt_object),
    format_elfobj_extern("puts", elfobj_stt_func)
)

// RELA 记录带显式 addend：-4 就是 rel32 位移字段自身的宽度。
const relocs: list = list.of(
    format_elfobj_reloc(".text", text_start, call_disp, "puts", elf_r_x86_64_plt32, 0xfffffffffffffffc)
)
format_elfobj_tables_mut(object, symbols, relocs)
format_finish(object)
```

生成的映像为 992 字节，类型是 `ET_REL`。符号表里有 `_start`（函数，大小 8）、`scratch`（数据，大小 64）、`answer`（数据，大小 4）和未定义的 `puts`；重定位表里是一条 `R_X86_64_PLT32 puts 0xFFFFFFFFFFFFFFFC`。

ELF64 用的是 RELA 记录，addend 显式写在记录里。上面这条的 addend 是 `-4`，也就是 `0xfffffffffffffffc`——它就是 `rel32` 位移字段自身的宽度，来自 x86-64 psABI 的约定。这是 ELF 目标文件相对 COFF 最容易出错的一处：COFF 的位移里已经包含了「相对下一条指令」，ELF 则把它交给 addend。

`format_elfobj_public` 比 COFF 多两个参数：符号大小和符号类型（`elfobj_stt_notype`、`elfobj_stt_object`、`elfobj_stt_func`、`elfobj_stt_section`）。符号值同样是「地址 − 所在节起始」。

符号类型和绑定在文件里合成一个字节：类型决定这个符号是函数还是数据，绑定固定为全局（`STB_GLOBAL`）。本地绑定只用在自动生成的节符号上，用户声明的符号没有本地符号这一档。

符号表的排布决定了重定位引用的下标：

1. 下标 0 是保留的空符号；
2. 接着每个节一个节符号，`shndx` 是节号，下标从 1 到节数；
3. 用户声明的符号排在后面，所以第一个用户符号的下标是 `1 + 节数`。

重定位记录里的 `r_info` 高 32 位就是按这个下标写进去的。用 `readelf -s` 核对时，用户符号显示在节符号之后。

## 链接器接手之后

目标文件的用处是被别的代码链进去，最直接的检验就是真正链接一次。下面导出一个函数给 C 调用：

```asm id=elfobj64-export-for-c target=x86-64
import("format/format.inc")

// 与 C 混编用的 ELF64 目标文件：导出一个函数给 C 调用。
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

生成的映像为 600 字节。写一个 C 文件声明同一个函数名，两个文件一起交由 `gcc` 链接：

```c
#include <stdio.h>

/* xirasm_double 由 XIRASM 生成的 ELF64 目标文件提供。 */
long xirasm_double(long value);

int main(void) {
    /* 调用目标文件里的函数，并核对它返回 42。 */
    long result = xirasm_double(21);
    printf("xirasm_double(21) = %ld\n", result);
    return result == 42 ? 0 : 1;
}
```

```text
gcc -o mix main.c mix.o
./mix
```

程序打印 `xirasm_double(21) = 42` 并以 0 退出。能链上就说明符号表里的名字、类型和节号都对，链接器认可这份目标文件。

跨语言调用要按 ABI 对齐：x86-64 Linux 的第一个整型参数放 `rdi`，返回值放 `rax`。上例的 `lea rax, [rdi + rdi]` 就是「把第一个参数乘 2 后返回」。参数类型和寄存器不符，链接一样能过，运行结果却会错——ABI 由调用双方约定，链接器管不了。

`readelf -s mix.o` 用来核对符号表：`xirasm_double` 的 `Ndx` 指向 `.text`，`Type` 为 `FUNC`，`Size` 为 4。

目标文件还可以先反汇编再链接。`llvm-objdump -d` 按符号表和重定位把机器码还原出来，能同时验证指令字节、符号值和重定位记录三者是否一致——这一步不需要先链成功：

```text
llvm-objdump -d mix.o
objdump -dr mix.o
```

`objdump -dr` 会同时打印反汇编和重定位记录，是核对「占位字节 + 重定位」这一对是否对得上的常用手段。

### 选择 ELF 机器类型

| 构造函数 | `e_machine` | 说明 |
| --- | --- | --- |
| `format_elfobj32(sections)` | `EM_386` | 同时把汇编器切换到 32 位 x86 文本模式 |
| `format_elfobj64(sections)` | `EM_X86_64` | 同时把汇编器切换到 64 位 x86 文本模式 |
| `format_elfobj64_aarch64(sections)` | `EM_AARCH64` | 面向 arm64 Linux 与 BSD |
| `format_elfobj64_machine(sections, machine)` | 由参数指定 | 接受 `elf_machine_x86_64` 或 `elf_machine_aarch64` |

AArch64 形式不会切换 x86 文本模式，因此指令字要当数据写：用 `emit.u32` 写，或者走 AArch64 的 DSL 层。重定位类型从 `elf_const.inc` 取：

```asm id=elfobj64-aarch64 target=aarch64
import("format/format.inc")

// AArch64 目标文件：指令字当数据写，每条重定位标明一处占位。
let object: map = format_elfobj64_aarch64(
    list.of(
        format_section(".text", format_code | format_readable | format_executable),
        format_section(".data", format_data | format_readable | format_writeable)
    )
)
format_begin(object)

format_section_begin(object, ".text")
text_start:
    // bl printf：低 26 位留给链接器填。
    bl_site:
        emit.u32(0x94000000)
    // adrp x0, answer：页基址部分。
    page_site:
        emit.u32(0x90000000)
    // add x0, x0, :lo12:answer：低 12 位部分。
    lo12_site:
        emit.u32(0x91000000)
format_section_end(object, ".text")

format_section_begin(object, ".data")
data_start:
    // .xword printf：8 字节绝对地址，链接器整体回填。
    ptr_slot:
        emit.u64(0)
format_section_end(object, ".data")

const symbols: list = list.of(
    format_elfobj_public("_start", ".text", text_start, bl_site, 16, elfobj_stt_func),
    format_elfobj_public("answer", ".data", data_start, ptr_slot, 8, elfobj_stt_object),
    format_elfobj_extern("printf", elfobj_stt_func)
)

// 每条重定位描述链接器要修正的占位字；AArch64 用 RELA，addend 显式给出。
const relocs: list = list.of(
    format_elfobj_reloc(".text", text_start, bl_site, "printf", elf_r_aarch64_call26, 0),
    format_elfobj_reloc(".text", text_start, page_site, "answer", elf_r_aarch64_adr_prel_pg_hi21, 0),
    format_elfobj_reloc(".text", text_start, lo12_site, "answer", elf_r_aarch64_add_abs_lo12_nc, 0),
    format_elfobj_reloc(".data", data_start, ptr_slot, "printf", elf_r_aarch64_abs64, 0)
)
format_elfobj_tables_mut(object, symbols, relocs)
format_finish(object)
```

生成的映像为 1016 字节，`e_machine` 是 `EM_AARCH64`（183），重定位表里有四条记录：偏移 0 的 `R_AARCH64_CALL26`、偏移 4 的 `R_AARCH64_ADR_PREL_PG_HI21`、偏移 8 的 `R_AARCH64_ADD_ABS_LO12_NC`，加上 `.data` 里偏移 0 的 `R_AARCH64_ABS64`。

一条 `adrp` 加一条 `add` 组合出符号地址时，两条指令各要一条重定位：页基址用 `elf_r_aarch64_adr_prel_pg_hi21`，低 12 位用 `elf_r_aarch64_add_abs_lo12_nc`。

`elf_const.inc` 里常用的 AArch64 类型还有：`elf_r_aarch64_abs64`、`elf_r_aarch64_abs32`、`elf_r_aarch64_adr_prel_lo21`、`elf_r_aarch64_ldst{8,16,32,64}_abs_lo12_nc` 系列、`elf_r_aarch64_condbr19`、`elf_r_aarch64_jump26`，以及 GOT 形式的 `elf_r_aarch64_adr_got_page` 和 `elf_r_aarch64_ld64_got_lo12_nc`。

AArch64 目标文件接口拒绝未知重定位类型、不是四字节倍数的指令重定位偏移，以及超出目标节的字段。数据重定位按实际的二、四或八字节宽度检查。RELA 加数使用 64 位位模式，例如 `0xfffffffffffffffc` 表示 `-4`。

ELF32 用 `format_elfobj32`，常用的 32 位相对调用重定位是 `elf_r_386_pc32`。

## Mach-O 目标文件

Mach-O 可重定位目标文件由第 6 章的 `format_macho64_object(target, sections)` 生成，节生命周期与上面两个模板一致。符号表、重定位表和 `LC_SYMTAB` 也在那边讲。

## API 摘要

| 家族 | 函数 | 用途 |
| --- | --- | --- |
| COFF | `format_coff32(sections)` / `format_coff64(sections)` | 创建 COFF 目标文件配置 |
| COFF | `format_coff64_arm64(sections)` | 创建 AArch64 COFF 目标文件配置 |
| COFF | `format_coff_public(name, section_name, section_start, address, sym_type)` | 声明公开符号 |
| COFF | `format_coff_extern(name, sym_type)` | 声明外部符号 |
| COFF | `format_coff_reloc(section_name, section_start, address, symbol_name, reloc_type)` | 声明需要链接器修正的字段 |
| COFF | `format_coff_tables_mut(plan, symbols, relocs)` | 把符号表和重定位表挂到配置上 |
| ELF | `format_elfobj32(sections)` / `format_elfobj64(sections)` | 创建 x86 目标文件配置 |
| ELF | `format_elfobj64_aarch64(sections)` | 创建 AArch64 目标文件配置 |
| ELF | `format_elfobj64_machine(sections, machine)` | 以显式机器类型创建目标文件配置 |
| ELF | `format_elfobj_public(name, section_name, section_start, address, symbol_size, symbol_type)` | 声明公开符号 |
| ELF | `format_elfobj_extern(name, symbol_type)` | 声明外部符号 |
| ELF | `format_elfobj_reloc(section_name, section_start, address, symbol_name, reloc_type, addend)` | 声明需要链接器修正的字段 |
| ELF | `format_elfobj_tables_mut(plan, symbols, relocs)` | 把符号表和重定位表挂到配置上 |

重定位指向的字节必须先写出来。先写占位，再用 `format_*_reloc` 描述这段占位该由链接器怎样修正；反过来，对没有写出的字节声明重定位，链接器拿不到可以覆盖的位置。

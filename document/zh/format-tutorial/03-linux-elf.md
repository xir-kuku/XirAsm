# 3. Linux ELF 可执行文件和共享库

要在 Linux 上生成可直接运行的文件，或者要被其他程序动态加载的 `.so`，用 ELF 格式。ELF 映像不像 PE 那样按节组织内容，它按**装载段**组织：每一段记录自己在文件里的位置、映射到的虚拟地址、占多少文件字节、占多少内存、运行时是什么权限。加载器只读程序头，按这些记录把文件映射进内存。

节名和装载段名的用处不同：节名给链接器和调试器看，装载段名给加载器看。用 `format.inc` 时声明的是装载段，程序头由它生成，`p_vaddr == p_offset (mod p_align)` 这个加载器依赖的关系也由它维持。

## ELF 可执行文件

固定地址可执行文件用 `format_elf_exec`：

```asm id=elf64-executable target=x86-64
import("format/format.inc")

// 三段：代码、已初始化数据、零初始化数据。
let image: map = format_elf64(
    format_elf_exec,
    list.of(
        // 代码段可读可执行。
        format_segment(".text", format_load | format_readable | format_executable),
        // 数据段可读可写。
        format_segment(".data", format_load | format_readable | format_writeable),
        // BSS 段可读可写，但只占内存。
        format_segment(".bss", format_load | format_readable | format_writeable)
    )
)
format_begin(image)

format_segment_begin(image, ".text")
start:
    // 系统调用 60：exit(0)。
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

这个例子是 253 字节，三个 `PT_LOAD` 程序头：

| 装载段 | 文件偏移 | 虚拟地址 | 文件大小 | 内存大小 | 权限 |
| --- | --- | --- | --- | --- | --- |
| `.text` | `0xF0` | `0x4000F0` | 9 | 9 | `R\|X` |
| `.data` | `0xF9` | `0x4010F9` | 4 | 4 | `R\|W` |
| `.bss` | `0xFD` | `0x4020FD` | **0** | **128** | `R\|W` |

`.bss` 那一行把 BSS 的含义说全了：文件里一个字节都不占，内存里保留 128 字节。`format.inc` 把这两个数字分别写进程序头的 `p_filesz` 和 `p_memsz`，加载器据此把这段内存清零。

ELF32 把 `format_elf64` 换成 `format_elf32`，选项仍只能是 `format_elf_exec`：这一层没有 ELF32 PIE 入口。

## 一个完整的程序

前面的例子只把寄存器清零就退出，不足以说明实际程序如何编写。下面这个程序打印一行文本，并用退出码返回计算结果——退出码是脚本和 CI 最容易核对的一项结果：

```asm id=linux-write-and-exit target=x86-64
import("format/format.inc")

// Linux x86-64 实际程序：算出结果，打印一行，用退出码报告状态。
let image: map = format_elf64(
    format_elf_exec,
    list.of(
        // 代码段：可读可执行。
        format_segment(".text", format_load | format_readable | format_executable),
        // 只读数据段：提示文本。
        format_segment(".rodata", format_load | format_readable)
    )
)

// 从输入值算出结果。
const INPUT: u64 = 35
const DELTA: u64 = 7

format_begin(image)

format_segment_begin(image, ".text")
start:
    // 算入参：lea 在不改动标志位的前提下做加法。
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
// 尾部标号用来算长度，不用手数字节。
message_end:
format_segment_end(image, ".rodata")

format_entry_mut(image, start)
format_finish(image)
```

这个例子是 271 字节，两个 `PT_LOAD` 段：`.text` 在偏移 `0xB0`，47 字节，权限 `R|X`；`.rodata` 在偏移 `0xDF`，48 字节，权限 `R`——代码段和数据段分开，只读数据不带执行权限。

在 x86-64 Linux 上直接运行，终端打印：

```text
xirasm: exit status carries the computed result
```

退出码是 `42`，也就是 `INPUT + DELTA`。

这段代码里有两条实际写法值得记住：

- **字符串长度用标号算**。`lea rdx, [rel message_end]` 再减去 `rsi`，长度由汇编器算出来；写死字节数，改文本时就得跟着改数字。
- **标签跨段引用要写 `rel`**。`.text` 里的代码引用 `.rodata` 的标号，必须用 RIP 相对形式，这样装载段落在哪个地址都成立。

## ELF64 PIE

位置无关可执行文件用 `format_elf_pie`：

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
    // 加载器可能把整个映像搬到别处，所以标签一律走 RIP 相对引用。
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

PIE 的基址由加载器决定。RIP 相对引用（`[rel label]`）在映像移动后仍然有效。可写数据中的绝对指针需要动态重定位：`format_elf_relptr_mut(image, segment_name, target_label)` 输出八字节槽，并为内部目标登记 `RELATIVE`；固定地址的动态 EXEC 则直接写目标地址。此接口要求动态配置；没有导入或导出表时，先在 `format_begin` 前调用 `format_elf_dynamic_mut` 开启。默认可见的导出目标应通过符号导入槽访问，让加载器仍能执行符号抢占。

PIE 支持可执行文件导入表。x86-64 支持 PLT 调用和提前解析的 GOT 槽，AArch64 使用提前解析的 GOT 槽。表必须在 `format_begin` 之前声明。需要指定解释器，或者启用没有导入的动态可执行文件时，在 `format_begin` 之前调用 `format_elf_dynamic_mut(image, interpreter)`。

## ELF64 可执行文件导入

x86-64 的固定地址可执行文件和 PIE 都可以通过 PLT 条目调用外部函数。声明导入之后，`format.inc` 会生成动态段、PLT、GOT 以及配套的重定位：

```asm id=elf64-exe-imports target=x86-64
import("format/format.inc")

let image: map = format_elf64(
    format_elf_exec,
    list.of(
        format_segment(".text", format_load | format_readable | format_executable)
    )
)

// 每个库调用一次分组函数，共用一个导入列表。
let imports: list = format_elfexe_import_new()
format_elfexe_import_many_mut(imports, "libc.so.6", list.of("getpid", "getppid"))
// cos 以本地前缀 cos_fn 导入。
format_elfexe_import_pairs_mut(imports, "libm.so.6", list.of("cos_fn", "cos"))
format_elfexe_tables_mut(image, imports)

format_begin(image)

format_segment_begin(image, ".text")
start:
    // 调用生成出来的 PLT 标签。
    call getpid_plt
    call getppid_plt
    xor edi, edi
    mov eax, 60
    syscall
format_segment_end(image, ".text")

format_entry_mut(image, start)
format_finish(image)
```

动态段里有两条 `NEEDED`（`libc.so.6` 和 `libm.so.6`），以及三个导入函数 `getpid`、`getppid`、`cos`。

动态可执行文件除了装载段，还带有 `PT_PHDR`、`PT_INTERP` 和 `PT_DYNAMIC`。`PT_PHDR` 排在第一项，第一个 `PT_LOAD` 覆盖 ELF 头和程序头表。自动生成的 PLT 可执行；GOT 槽和动态元数据位于有文件内容的可写区域。用 `readelf -lW` 和 `readelf -dW -rW` 检查实际地址和重定位表。

x86-64 默认解释器为 `/lib64/ld-linux-x86-64.so.2`，AArch64 为 `/lib/ld-linux-aarch64.so.1`。目标系统使用其他路径时，通过 `format_elf_dynamic_mut` 覆盖。

标签的生成规则：`many` 用导入名本身，`getpid` 生成 `getpid_plt` 和 `getpid_gotplt`；`pairs` 的列表按「本地前缀, 真实符号名」成对给出，上例的 `cos_fn` 生成 `cos_fn_plt` 和 `cos_fn_gotplt`。`pairs` 的项数必须是偶数，上限 128。

`format_elfexe_tables_mut` 必须在 `format_begin` **之前**调用：动态段、PLT 和 GOT 的空间要在开始输出时就预留出来。

调用 libc 的实际写法是给参数寄存器赋值后 `call` 生成的 PLT 标号。下面这个程序用 `write` 打印一行，再把 `getpid` 的返回值当退出码：

```asm id=linux-libc-imports target=x86-64
import("format/format.inc")

// 带 libc 导入的实际程序：用 write 打印，用 getpid 生成结果。
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
    // write(1, message, length)：经 PLT 调用 libc。
    mov edi, 1
    lea rsi, [rel message]
    lea rdx, [rel message_end]
    sub rdx, rsi
    call write_plt

    // getpid()：返回当前进程号。
    call getpid_plt

    // 用退出码把这个值带出去，方便脚本核对。
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

程序在 x86-64 Linux 上打印 `xirasm: write() came from libc through the PLT`，退出码是当前进程号的低八位。

`readelf -d` 显示动态段里的 `NEEDED` 一条指向 `libc.so.6`，`PLTRELSZ` 为 48 字节——两个导入函数各占一条 24 字节的 RELA 记录，`PLTREL` 为 `RELA`。`ldd` 列出三个依赖：`linux-vdso.so.1`、`libc.so.6`、`/lib64/ld-linux-x86-64.so.2`，最后一项来自程序头中 `PT_INTERP` 指定的解释器，由 `format.inc` 填为 `/lib64/ld-linux-x86-64.so.2`。

两条实际写法：先按 System V AMD64 的寄存器顺序放好参数（`rdi`、`rsi`、`rdx`……）再 `call`，参数个数或顺序写错不会报错，只会得出错误结果；调用返回后先取 `eax` 里的返回值，再据此判断后续动作，上例把 `eax` 搬到 `edi` 就是为了当退出码。

## ELF64 共享库

共享库没有可执行入口，它对外暴露动态符号，同时也可以自己导入符号。SONAME 作为参数传给构造函数：

```asm id=elf64-so-exports target=x86-64
import("format/format.inc")

let image: map = format_elf64_so(
    "libxirasm_demo.so",
    list.of(
        format_segment(".text", format_load | format_readable | format_executable)
    )
)

let exports: list = format_elfso_export_new()
// 两个函数按标签原名导出，符号大小都是 4 字节。
format_elfso_export_many_mut(exports, list.of("x_add7", "x_sub3"), ".text", 4)
// answer_impl 以 x_answer 之名导出，符号大小 6 字节。
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

导出声明要给出所在装载段名和符号大小。`.dynsym`、`.dynstr`、hash、`.dynamic`、GOT/PLT 这些载荷由 `format.inc` 生成。共享库同样不调用 `format_entry_mut`。

共享库和动态可执行文件带有描述符号和重定位表的节头；静态可执行文件不带节头表：

| 项目 | ELF 可执行文件 | ELF 共享库 |
| --- | --- | --- |
| 文件类型 | `ET_EXEC` 或 PIE 的 `ET_DYN` | `ET_DYN` |
| 节头表 | 静态 EXEC 没有，动态 EXEC/PIE 有 | 有，包括动态符号表和字符串表 |
| 段基址 | `0x400000` 起 | `0` 起 |
| 段对应关系 | 每个声明的装载段一个 `PT_LOAD` | 声明的段合进 `PT_LOAD`，另有 `PT_DYNAMIC` |

共享库的地址从 0 起算，是因为它被加载到哪个地址由加载器决定，节头里的地址都按基址 0 记录。用 `readelf -l` 或 `llvm-readobj --program-headers` 查看加载器实际映射的段。

## ELF64 共享库导入

共享库的导入用同一套「按库分组」写法，区别是导入和导出共用一张 `tables_mut`：

```text
let imports: list = format_elfso_import_new()
format_elfso_import_many_mut(imports, "libc.so.6", list.of("puts", "getpid"))
format_elfso_import_pairs_mut(imports, "libm.so.6", list.of("cos_fn", "cos"))
format_elfso_tables_mut(image, exports, imports)
```

导入可以与导出使用同一个公开名称：它们共用一个已定义的动态符号，加载器可以对它执行符号抢占。多个不同的本地槽也可以引用同一个公开符号。重复导出声明和自动生成的本地标签冲突会被拒绝。映像内部的引用写 `rel`，调用 PLT 导入函数用自动生成的 PLT 标签。

## 选择目标机器

`format_elf64` 和 `format_elf64_so` 默认生成 x86-64 映像。AArch64 另有入口，机器名来自配置时可以用带机器参数的通用形式：

| 入口 | 产物 |
| --- | --- |
| `format_elf64(options, segments)` | ELF64 x86-64 可执行文件或 PIE |
| `format_elf64_aarch64(options, segments)` | ELF64 AArch64 可执行文件或 PIE |
| `format_elf64_machine(options, segments, machine)` | 机器由 `elf_machine_x86_64` 或 `elf_machine_aarch64` 指定 |
| `format_elf64_so(soname, segments)` | ELF64 x86-64 共享库，LOAD 段按 4 KiB 对齐 |
| `format_elf64_so_aarch64(soname, segments)` | ELF64 AArch64 共享库，LOAD 段按 16 KiB 对齐 |
| `format_elf64_so_machine(soname, segments, machine)` | 机器由参数指定的 ELF64 共享库 |
| `format_elfobj64_aarch64(sections)` | AArch64 ELF64 目标文件 |

两种机器有三处差别：

| 差别 | x86-64 | AArch64 |
| --- | --- | --- |
| LOAD 段页对齐 | 4 KiB，Linux 默认值 | **16 KiB**，Android 15 及以后设备的要求 |
| 导入方式 | PLT 条目和 GLOB_DAT 槽位，可以混用 | GLOB_DAT 槽位，用 `format_elfso_import_slots_mut` 声明 |
| 可执行文件导入 | EXEC/PIE，PLT 和 GOT 槽 | EXEC/PIE，GOT 槽 |

页对齐调大只在装载段必须挪到下一个页边界时才多占文件字节：虚拟地址按整页前进，文件布局仍然紧凑。要换别的页大小，在 `format_begin` 之前给配置设置 `"load_align"`。

`"load_align"` 必须是非零的二次幂。它同时控制用户 LOAD 段、PLT 和动态表的页对齐。为 Android 打包 x86-64 共享库时，把该值设置为 `elf_android_page_align`，使库内 LOAD 段和 APK 中的文件数据都按 16 KiB 对齐。

x86-64 共享库通过 `format_elfso_import_slots_mut` 声明 GOT 槽位，可以与 PLT 导入一起使用。动态符号的 `"type"` 默认为 `elf_stt_func`；在导入或导出记录中设置 `"type"` 为 `elf_stt_object`，即可声明数据符号。数据导入必须使用 GOT 槽位。导出地址和大小必须完全位于声明的段内，库名和动态符号名不得包含 NUL。`.dynsym`、`.dynamic` 等生成表名由格式层保留。

每个装载段还会遵守所属节声明的对齐：`format_executable` 段是 16 字节，其余是 8 字节。这个对齐**同时作用在文件偏移上**，因为加载器要求 `p_vaddr == p_offset (mod p_align)`——地址低位由文件偏移决定，只调地址会破坏这个关系。结果是每个节都满足 `sh_addr % sh_addralign == 0`，做对齐访问的代码依赖的正是这条保证；代价是装载段原本会落在页内进位处时，文件里多几个填充字节。

## API 摘要

| 函数 | 用途 |
| --- | --- |
| `format_elf32(format_elf_exec, segments)` | ELF32 可执行文件 |
| `format_elf64(format_elf_exec, segments)` | ELF64 x86-64 固定地址可执行文件 |
| `format_elf64(format_elf_pie, segments)` | ELF64 x86-64 PIE |
| `format_elf64_aarch64(options, segments)` | ELF64 AArch64 可执行文件或 PIE |
| `format_elf64_machine(options, segments, machine)` | 指定机器的 ELF64 可执行文件或 PIE |
| `format_elf64_so(soname, segments)` | ELF64 x86-64 共享库 |
| `format_elf64_so_aarch64(soname, segments)` | ELF64 AArch64 共享库，按 Android 页大小对齐 |
| `format_elf64_so_machine(soname, segments, machine)` | 指定机器的 ELF64 共享库 |
| `format_elfobj64_aarch64(sections)` | AArch64 ELF64 目标文件 |
| `format_elfexe_import_new()` | 创建 ELF64 可执行文件导入列表 |
| `format_elfexe_import_many_mut(imports, library, names)` | 从同一个库批量加入同名导入 |
| `format_elfexe_import_pairs_mut(imports, library, pairs)` | 加入「本地前缀, 真实符号名」成对导入 |
| `format_elfexe_import_slots_mut(imports, library, names)` | x86-64/AArch64 可执行文件 GLOB_DAT 导入槽 |
| `format_elfexe_import_slots_pairs_mut(imports, library, pairs)` | 加入「本地槽, 公开符号」成对 GOT 导入 |
| `format_elfexe_tables_mut(plan, imports)` | 把可执行文件导入元数据挂到配置上 |
| `format_elfexe_exports_mut(plan, exports)` | 用共享库导出列表配置动态可执行文件的导出 |
| `format_elf_dynamic_mut(plan, interpreter)` | 启用动态可执行文件并选择解释器 |
| `format_elf_relptr_mut(plan, segment, target_label)` | 在可写段中输出指向内部目标的绝对指针 |
| `format_elfso_export_new()` | 创建共享库导出列表 |
| `format_elfso_export_many_mut(exports, names, segment, size)` | 批量导出同名符号 |
| `format_elfso_export_pairs_mut(exports, pairs, segment, size)` | 批量导出「内部标签, 公开名称」成对符号 |
| `format_elfso_import_new()` | 创建共享库导入列表 |
| `format_elfso_import_many_mut(imports, library, names)` | 从同一个库批量加入共享库导入 |
| `format_elfso_import_pairs_mut(imports, library, pairs)` | 加入共享库「本地前缀, 真实符号名」成对导入 |
| `format_elfso_import_slots_mut(imports, library, names)` | x86-64/AArch64 共享库 GLOB_DAT 导入槽位 |
| `format_elfso_tables_mut(plan, exports, imports)` | 把共享库动态元数据挂到配置上 |

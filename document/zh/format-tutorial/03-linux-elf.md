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

PIE 与固定地址可执行文件只有一个实质区别：基址由加载器决定。因此**所有指向映像内部的引用都必须写成 RIP 相对形式**（`[rel label]`），这种引用编码的是位移，不管映像被搬到哪里都成立，也不需要动态重定位。反过来，把绝对指针存进 `.data` 就需要一条动态重定位记录，而任意用户指针的动态重定位目前要通过 ELF 直接构造来完成，`format.inc` 这一层不提供。

PIE 不支持可执行文件导入。把导入表挂到 PIE 配置上会报 `ELF executable imports require fixed-address EXEC mode`。

## ELF64 可执行文件导入

固定地址可执行文件可以通过 PLT 条目调用外部函数。声明导入之后，`format.inc` 会生成动态段、PLT、GOT 以及配套的重定位：

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

生成的映像为 960 字节，动态段里有两条 `NEEDED`（`libc.so.6` 和 `libm.so.6`），动态符号表里有三个未定义函数 `getpid`、`getppid`、`cos`。

声明导入会让文件多出装载段。上例只声明了 `.text` 一个装载段，最终的程序头有五个：

| 程序头 | 文件偏移 | 虚拟地址 | 文件大小 | 权限 | 来源 |
| --- | --- | --- | --- | --- | --- |
| `PT_LOAD` | `0x0` | `0x400000` | 371 | `R\|X` | 声明的 `.text` |
| `PT_LOAD` | `0x180` | `0x401180` | 64 | `R\|X` | 自动生成，放 PLT |
| `PT_LOAD` | `0x1C0` | `0x4021C0` | 512 | `R\|W` | 自动生成，放 GOT、动态符号表、字符串表、hash、RELA 和动态段 |
| `PT_INTERP` | `0x1F0` | `0x4021F0` | 28 | `R` | 动态链接器路径 |
| `PT_DYNAMIC` | `0x300` | `0x402300` | 192 | `R\|W` | 动态段本身 |

后两个装载段排在所有声明段之后，各自页对齐。因此文件大小和地址布局不能只按声明的段来算——导入表本身要占一个可写段。动态链接器的路径固定为 `/lib64/ld-linux-x86-64.so.2`，写在 `PT_INTERP` 指向的位置。

可写装载段里的内容按固定顺序排布：GOTPLT、解释器路径、动态符号表、动态字符串表、hash、`RELA.PLT`、动态段。这个顺序不是可以调整的选项，`format.inc` 逐个对齐着写，因此段内偏移是可预测的。

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

生成的映像为 960 字节。程序在 x86-64 Linux 上打印 `xirasm: write() came from libc through the PLT`，退出码是当前进程号（每次运行不同，属于正常现象）。

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

共享库带节头表，可执行文件不带。同样是 x86-64 下由 `format.inc` 生成的文件，两者在头部和布局上的差别如下：

| 项目 | ELF 可执行文件 | ELF 共享库 |
| --- | --- | --- |
| 文件类型 | `ET_EXEC` 或 PIE 的 `ET_DYN` | `ET_DYN` |
| 节头表 | **没有**（`e_shnum = 0`） | 有，共 7 项：空节、`.text`、`.dynsym`、`.dynstr`、`.hash`、`.dynamic`、`.shstrtab` |
| 段基址 | `0x400000` 起 | `0` 起 |
| 段对应关系 | 每个声明的装载段一个 `PT_LOAD` | 声明的段合进 `PT_LOAD`，另有 `PT_DYNAMIC` |

共享库的地址从 0 起算，是因为它被加载到哪个地址由加载器决定，节头里的地址都按基址 0 记录。可执行文件没有节头表，`readelf -S` 不会有输出；要用 `readelf -l` 看程序头，或者用 `llvm-readobj --program-headers`。

## ELF64 共享库导入

共享库的导入用同一套「按库分组」写法，区别是导入和导出共用一张 `tables_mut`：

```text
let imports: list = format_elfso_import_new()
format_elfso_import_many_mut(imports, "libc.so.6", list.of("puts", "getpid"))
format_elfso_import_pairs_mut(imports, "libm.so.6", list.of("cos_fn", "cos"))
format_elfso_tables_mut(image, exports, imports)
```

导入名和导出名不能冲突，生成出来的 `*_plt` 和 `*_gotplt` 标签也必须唯一。映像内部的引用写 `rel`，调用导入函数用生成出来的 PLT 标签。

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
| 可执行文件导入 | 支持 | 不支持，改由共享库导入 |

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
| `format_elfexe_tables_mut(plan, imports)` | 把可执行文件导入元数据挂到配置上 |
| `format_elfso_export_new()` | 创建共享库导出列表 |
| `format_elfso_export_many_mut(exports, names, segment, size)` | 批量导出同名符号 |
| `format_elfso_export_pairs_mut(exports, pairs, segment, size)` | 批量导出「内部标签, 公开名称」成对符号 |
| `format_elfso_import_new()` | 创建共享库导入列表 |
| `format_elfso_import_many_mut(imports, library, names)` | 从同一个库批量加入共享库导入 |
| `format_elfso_import_pairs_mut(imports, library, pairs)` | 加入共享库「本地前缀, 真实符号名」成对导入 |
| `format_elfso_import_slots_mut(imports, library, names)` | x86-64/AArch64 共享库 GLOB_DAT 导入槽位 |
| `format_elfso_tables_mut(plan, exports, imports)` | 把共享库动态元数据挂到配置上 |

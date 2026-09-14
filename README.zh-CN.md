# XIRASM

[English](README.md) | [项目网站](https://xirasm-site.pages.dev/) | [版本更新](https://xirasm-site.pages.dev/#updates)

**一款同时支持 x86、AArch64、RISC-V 与 SPIR-V 的现代汇编器：直接写汇编，
直接生成 Windows、Linux、macOS 与 Android 上的可用产物；需要时，再用
编译期语言把构建过程变成程序。**

XIRASM 是一个把活干完的汇编器。你写的是普通汇编文本，拿到的是一个能直接跑的文件——
Windows 的 PE、Linux 的 ELF、macOS 的 Mach-O、flat 二进制、SPIR-V 模块，或者一个能装的
安卓 APK。从源码到产物中间没有别的东西：导入表、重定位记录和对齐，都由格式层自己写出来。

当项目开始超出复制粘贴的范围时，再动用它的编译期语言。那不是文本宏：它是一门在汇编期
运行的类型化语言，产物里不会留下任何痕迹。

- **四类指令集：** x86 16/32/64 位模式、AArch64、RV32/RV64 与 SPIR-V 1.6。
- **产物开箱能跑：** PE32/PE64 可执行文件与 DLL、COFF32/COFF64 目标文件、ELF32/ELF64
  可执行文件、ELF64 PIE 与共享库、Mach-O 64 可执行文件与 dylib 与目标文件、flat 二进制、
  SPIR-V 模块，以及能直接安装的安卓 APK。
- **链接器那份活已经做完了：** 导入表、导出表、基址重定位、PLT/GOT 槽位、动态符号表和
  dyld 桩都由格式层写出来，所以一个源文件就能变成一个可运行镜像。
- **能落到真机上的 AArch64：** `arm/a64-macros.inc` 提供 AArch64 指令文本，格式层再把
  编码结果带进 ELF64 可执行文件、PIE、目标文件与 Android 共享库，以及 PE64/COFF64 镜像
  和 Mach-O arm64 的可执行文件、dylib 与目标文件，并各自带上对应的重定位和导入桩。
- **不需要 Java 构建链的 Android：** APK 写出器生成 ZIP 容器、二进制
  `AndroidManifest.xml`，以及由资源目录编译出的 `resources.arsc`，并能装载同一份源码
  汇编出的 NativeActivity 共享库。`@android:style/Theme.DeviceDefault` 这类平台资源 ID
  来自生成好的框架目录表。
- **是一门语言，不是宏层：** 类型值、函数、集合、模块、结构化控制流，以及定位到源码的
  诊断。工程模板一条命令就能给你一个可构建的 Windows、Linux 或裸机程序。

## 下载

每个版本同时提供预编译包，只有要修改 XIRASM 本身时才需要自己装工具链：

- Windows x86-64（ZIP）与 Linux x86-64（静态链接 TAR.GZ）；
- macOS Apple Silicon（TAR.GZ）；
- VS Code 扩展与语言服务器（VSIX）。

从[项目网站](https://xirasm-site.pages.dev/#downloads)或
[GitHub Release](https://github.com/xir-kuku/XirAsm/releases/latest)获取当前版本，
Release 正文列出每个包的 SHA-256。每个包内含可执行文件、`include` 库、测试用例以及
中英文文档。

## 几步生成原生程序

使用 Zig 0.17 构建 XIRASM，或者直接拿上面的预编译包：

```text
zig build -Doptimize=ReleaseSafe
```

将生成的 `xirasm` 加入 `PATH`，然后创建并构建一个原生项目：

```text
xirasm init hello --template pe64
cd hello
xirasm build
```

生成目录自带源码和 `xirasm.toml`，之后进目录执行 `xirasm build` 就行。换成
`--template elf64` 得到的是同一套起步工程，只是产出 ELF 可执行文件；其余模板用
`xirasm help templates` 查看。

汇编单个文件**不需要任何选项**：`xirasm hello.asm` 会在源文件旁写出 `hello.bin`；
`--isa` 只是给"自己没有选择 ISA 的源码"提供一个起始目标。输出格式不是命令行的事——
源码自己 import 需要的格式层，汇编器只负责把源码变成字节。

`--listing hello.lst` 会在产物旁边写一份列表文件。每行依次是：**地址（RVA）、文件偏移
（FOA）、源码行号、行类型（`code`/`data`/`resv`/`algn`/`gap`/`trim`）、展开深度、字节、
源码行**。文件里存在但不属于任何片段的字节会以 `gap` 行列出来并显示其真实内容；被裁掉的
尾部预留空间显示为 `trim` 且**没有文件偏移**（文件里并没有那个字节）。由宏或函数展开产生
的行会**以调用点开头**，所以宏库的列表依然可读。

有一条 CLI 规则值得先知道：子命令写在选项之前，用 `xirasm build --timings`，
不要写成 `xirasm --timings build`。

## 汇编仍然是汇编

标号与处理器指令保持自然写法。只有真正适合自动生成的部分才使用编译期代码：

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

函数与循环只在汇编阶段运行，最终产物中只有机器码和生成的数据；没有运行时解释器，
也不需要把每条指令写成函数调用。

最小的 flat binary 源码可以只有几行：

```asm
x86.use64();

entry:
    mov eax, 42
    ret
```

```text
xirasm hello.asm
```

## 一套工具，多种目标

| 指令集 | 怎么选 | 产出什么 |
| --- | --- | --- |
| x86，16/32/64 位 | `--isa x86-64` 或 `--isa x86` | PE32/PE64、COFF32/COFF64、ELF32/ELF64、flat 镜像 |
| AArch64 | `--isa aarch64`，或在源码里 `import("arm/a64-macros.inc")` | ELF64 可执行文件、PIE、共享库与目标文件、PE64、COFF64、Mach-O arm64、Android 库 |
| RISC-V RV64/RV32 | `--isa rv64` 或 `--isa rv32` | flat 镜像与 RISC-V 指令流 |
| SPIR-V 1.6 | `--isa spv` | 给 GPU 与 IR 工具用的完整模块 |

`--isa` 是**起始目标**而不是强制要求：源码自己选了 ISA（`x86.use64()`、`riscv.use32()`、
A64 宏库）就听源码的，这个旗标只兜住没选的源码。`--target` 是 `--isa` 的旧拼写，仍然可用。

AArch64 没有后端编码器：它的指令层是一个 include，而不是汇编器里的解码器。引入之后，
`mov x8, #93` 和 `svc #0` 与别的指令一样汇编；至于结果变成 ELF64 镜像、PE64 镜像、目标文件
还是 Mach-O 镜像，由格式接口决定。目前 PE、COFF、ELF 与 Mach-O 的封装覆盖 x86-64 和
AArch64；RISC-V 与 SPIR-V 对应的是指令流和模块。

四类目标的工程模型和编译期语言是同一套。不必为 x86 学一套宏系统，再为 RISC-V 学另一套
生成方式。

## 支持的输出格式

| 平台 | XIRASM 会写出什么 |
| --- | --- |
| Windows | x86 与 ARM64 的 PE32/PE64 可执行文件与 DLL，含导入表、导出表、资源与 `.reloc` 基址重定位（DIR64 与 HIGHLOW）；x86-64 与 ARM64 的 COFF32/COFF64 目标文件，带对应重定位 |
| Linux | ELF32/ELF64 可执行文件，x86-64 与 AArch64 的 ELF64 PIE 与共享库，以及 ELF32/ELF64 目标文件。共享库导入在 x86-64 走 `.plt`/`.got.plt` 与 `R_X86_64_JUMP_SLOT`，在 AArch64 走 `.got` 与 `R_AARCH64_GLOB_DAT`，另配动态符号表与哈希；可执行文件的导入走 `.rela.plt` 与 PLT 桩 |
| macOS | x86_64 与 arm64 的 Mach-O 64 可执行文件、dylib 与目标文件，含 dyld 导入（桩与槽位）和导出 trie |
| Android | APK 归档：ZIP 容器、二进制清单、由 `res/` 目录编译出的 `resources.arsc`、assets（可选 DEFLATE）与按 ABI 划分的原生库 |
| 裸机与工具开发 | flat binary 与应用专用二进制 |
| GPU 与 IR 工具 | 完整 SPIR-V 1.6 模块 |

常规 PE、COFF、ELF 与 Mach-O 项目使用格式库的高层封装：

```asm
import("format/format.inc");
```

这个库不是编译器内部机制，而是 XIRASM 源码本身：`include/format/` 下 34 个 `.inc`，
外加一份生成的资源 ID 目录表，覆盖 PE、COFF、ELF、Mach-O、ZIP 以及 APK 需要的各个部分。
可以读、可以改，也可以挑一个当作自己格式的起点。自定义加载器或文件格式需要特殊布局时，
region、label、对齐、fixup 与 finalizer 都在同一层可用。

## 构建 Android APK

APK 就是一个装着二进制清单与编译后资源表的 ZIP 归档。这三部分 XIRASM 都能写出，
而里面的原生库可以和汇编代码来自同一个工程：

```asm
import("format/apk.inc");

origin(0)

let app: map = apk_new("com.example.tool", 1, "1.0", "demo")
app = apk_res_dir(app, "res")
app = apk_native_lib(app, "arm64-v8a", "libdemo.so", "build/arm64-v8a/libdemo.so")
apk_emit(app)
```

产物可以直接安装运行：没有 DEX、没有 Java 源文件，也不依赖任何第三方运行时，
Activity 就是 NativeActivity，入口是共享库自己导出的 `ANativeActivity_onCreate`。

APK 写出器覆盖的范围：`apk_res_dir` 扫描 `res/` 目录并编译出 `resources.arsc`，密度与
语言限定符都在内，所以 `values-zh` 这种目录能正常工作；assets 可以用 DEFLATE 存，
而共享库和资源表保持不压缩并对齐，这是 Android 的硬要求——AArch64 库按 Android 15+ 的
16 KiB 页对齐。平台自己的资源 ID（比如 `@android:style/Theme.DeviceDefault`）来自一份
用 `aapt2` 读 `android.jar` 生成的目录表。

`tests/format/android_gl_demo/` 就是证据：一份 GLES2 渲染器加包住它的归档，两者都由
汇编器写出——6,496 字节的库装在 39 KB 的 APK 里，贴图是汇编期生成的。`aapt2` 与
`zipalign` 能把产物完整读回。签名有意留在汇编器之外，SDK 命令序列见
[Android 指南](document/android.md)。

平台库本身也有一份目录：`import("os/android/imports/liblog.inc")` 之后用
`android_import_log___android_log_write`，源码里既不写库名也不写 API 级别；
`import("os/android/defs/native_activity.inc")` 则给出平台回传的结构体布局——来自 NDK
stub 的 **25 个库、4,416 条（符号, 库）记录**，加上来自 NDK 头文件的 **1,168 个常量与
161 个字段偏移**，全部逐条与 `llvm-nm`、clang 核对过。两条使用路径与"数据到哪儿就不再
为真"见同一份 [Android 指南](document/android.md)。

## 不只是另一套宏汇编器

当汇编项目开始出现大量复制、替换与生成逻辑时，XIRASM 提供的是一门真正的编译期
语言：

- 类型化常量、可变绑定、函数与词法作用域；
- `if`/`else if`、`while`、`for`、`break` 与 `continue`；
- string、bytes、可变 list 与 map；
- struct、union、pack、alignment 与 reserve；
- module、import、JSON、TOML 与文件驱动生成；
- 汇编期读文件、列目录；
- 给格式层写出的归档条目做裸 DEFLATE 压缩；
- 用于紧凑领域语法的 token matching；
- assert 与定位到原始源码的诊断。

因此它既适合系统程序和嵌入式二进制，也适合可执行格式与指令级实验；同时不会把普通
ISA 指令改造成一套编程语言 API。

## 验证

回归测试关注最终编码字节和边界行为，而不只是“源码能够解析”。覆盖内容包括 x86
布局与 fixup、与 LLVM 工具对照的 RISC-V 与 AArch64 字节、SPIR-V 汇编/反汇编与
验证，以及受支持二进制格式的结构检查、链接、加载和真机运行测试。结果还由独立
工具复核：指令编码与 ELF、COFF、Mach-O 结构交给 LLVM 工具，APK 交给 Android SDK
的 `aapt2`、`zipalign` 以及一个独立的解压实现。

## 编辑器与文档

独立的 [XIRASM VS Code 扩展](https://github.com/xir-kuku/xir-vscode)
提供语法高亮、补全、导航与编译器诊断。

- [完整中文文档 PDF](document/zh/pdf/xirasm中文文档0.3.0.pdf) - 合并语言指南、
  格式教程与语言 API 参考，适合离线阅读。
- [中文可执行格式 PDF](document/zh/pdf/xirasm中文可执行格式0.3.0.pdf) - 单讲可执行与目标文件的构造。
- [中文语言指南](document/zh/language.md) - 学习汇编器与编译期语言模型。
- [中文格式教程](document/zh/format-tutorial.md) - 使用高层封装构建 PE、COFF 与 ELF。
- [Android 指南](document/android.md) - 汇编 NativeActivity 库，以及包住它的 APK、资源表与清单；并用生成的 NDK 符号目录与头文件常量取代手写的库名与偏移。
- [中文语言 API 参考](document/zh/api-reference.md) - 查询语法与内置 API。
- [高级格式构造指南（英文）](document/advanced-formats.md) - 直接控制特殊二进制布局。

## 状态

当前版本：**0.3.3**。参见[版本说明](document/zh/releases/0.3.3.md)。

XIRASM 仍处于 1.0 之前。汇编器、语言 API、格式库、CLI 与编辑器支持目前已经可以实际使用，
公开契约在 1.0 前仍可能继续收敛。它无意取代那些成熟的宏汇编器——它们背后是几十年的工具
积累和更大的生态；XIRASM 提供的是另一种取舍：四类指令集共用一套语言模型、一个可以读和改
的格式层，以及中间不带链接器的整镜像输出。

## 许可证

Apache-2.0。

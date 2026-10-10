# XIRASM 格式教程

这份教程讲如何用 XIRASM 直接生成 PE、ELF、COFF 和 macOS Mach-O 文件。写法从 `format/format.inc` 开始：声明文件类型、节或装载段、入口、导入导出和重定位，文件头、表项、文件偏移、RVA、对齐以及最终回填由 `format.inc` 生成。

如果过去主要在 C、C++、Rust 或其他语言里写内联汇编，文件格式通常由编译器、链接器和运行时处理，不需要自己回答下面这些问题。XIRASM 直接生成输出文件，因此每一项都要明确给出：

- 程序从哪个标签开始执行；
- 哪些字节是代码，哪些字节是数据；
- 哪些范围在运行时可读、可写或可执行；
- 哪些范围只占内存大小，不占初始化文件内容；
- 需要导入或导出哪些外部符号；
- 文件里哪些绝对地址需要让加载器或链接器修正；
- 最终阶段需要回填哪些地址、校验和或表项字段。

整个教程只需要一个导入：

```asm
import("format/format.inc")
```

`include/format/` 下的文件分三类，日常使用不必全部了解：

- `format.inc` 是常用入口，提供格式配置、节与装载段声明、导入、导出、资源、重定位、符号表和最终生成流程；
- `pe32.inc`、`pe64.inc`、`elf32.inc`、`elf64.inc` 是按位宽拆出的专用入口，维护已有源码或编写专门格式时才直接导入；
- `pe.inc`、`elfexe.inc`、`elfobj.inc` 等文件提供更细的文件头、目录、节表、程序头和动态表构造函数，`format.inc` 无法表达目标布局时才使用。

需要手写 PE/ELF 头部、目录、节表、程序头或动态表时，阅读[高级格式构造指南](../advanced-formats.md)。

## 章节

1. [先选输出类型](format-tutorial/01-choose-a-template.md)
2. [Windows PE 和 DLL](format-tutorial/02-windows-pe.md)
3. [Linux ELF 可执行文件和共享库](format-tutorial/03-linux-elf.md)
4. [COFF 和 ELF 目标文件](format-tutorial/04-object-files.md)
5. [通用规则和常见错误](format-tutorial/05-common-rules.md)
6. [macOS Mach-O](format-tutorial/06-macos-macho.md)

动态指针和容器输入检查见[格式校验](format-validation.md)。

## 快速选择

| 目标 | 起始函数 | 主要操作 |
| --- | --- | --- |
| Windows 可执行文件 | `format_pe32` 或 `format_pe64` | `format_section_begin`、`format_pe_import_section`、`format_pe_resource_section`、`format_pe_reloc_section` |
| Windows DLL | `format_pe32` 或 `format_pe64`，选项含 `format_pe_dll` | `format_pe_export_section`，可选导入、资源和重定位 |
| Linux 可执行文件 | `format_elf32` 或 `format_elf64`，选项为 `format_elf_exec` | `format_segment_begin`、`format_entry_mut`、`format_finish` |
| Linux PIE | `format_elf64`，选项为 `format_elf_pie` | `format_segment_begin`、`format_entry_mut`、`format_finish` |
| Linux 共享库 | `format_elf64_so` | `format_elfso_tables_mut`、`format_segment_begin`、`format_finish` |
| Android 共享库（AArch64） | `format_elf64_so_aarch64` | `format_elfso_import_slots_mut`、`format_elfso_tables_mut`、`format_segment_begin`、`format_finish` |
| COFF 目标文件 | `format_coff32` 或 `format_coff64` | `format_coff_tables_mut`、`format_section_begin`、`format_finish` |
| ELF 目标文件（x86） | `format_elfobj32` 或 `format_elfobj64` | `format_elfobj_tables_mut`、`format_section_begin`、`format_finish` |
| ELF 目标文件（AArch64） | `format_elfobj64_aarch64` | `format_elfobj_tables_mut`、`format_section_begin`、`format_finish` |
| macOS Mach-O 目标文件 | `format_macho64_object` | `format_macho64_target_arm64` 或 `format_macho64_target_x86_64`、`format_macho64_tables_mut`、`format_section_begin`、`format_finish` |
| macOS Mach-O 可执行文件 | `format_macho64_exe` | `format_macho64_segment`、`format_entry_mut`、`format_finish` |
| macOS Mach-O 动态库 | `format_macho64_dylib` | `format_macho64_segment`、`format_macho64_exports_mut`、`format_finish` |

## 基本生命周期

所有格式配置都沿同一条主线推进：

```asm id=format-lifecycle target=x86-64
import("format/format.inc")

// 1. 建立配置：文件角色、子系统、安全选项、ASLR 策略。
let image: map = format_pe64(
    format_pe_exe | format_pe_console | format_pe_nx | format_pe_aslr_disabled,
    list.of(
        // 2. 声明这个文件有哪些节。
        format_section(".text", format_code | format_readable | format_executable)
    )
)

// 3. 开始输出：头部和节表的空间在这里预留。
format_begin(image)

// 4. 只能写进已经声明过的节。
format_section_begin(image, ".text")
start:
    xor eax, eax
    ret
format_section_end(image, ".text")

// 5. 可执行文件设入口，然后完成全部回填。
format_entry_mut(image, start)
format_finish(image)
```

第 1 章给出了这个骨架的完整版本，以及 ELF 可执行文件对应的写法。

需要交给链接器的元数据（符号表、重定位表、导入导出表）在第 3 步之前挂到配置上，因为头部和动态表要为它们预留空间。判断某个函数属于哪一类，看它是否以 `format_*_tables_mut` 命名；其余生成节内容的函数放在第 3 步之后、第 5 步之前。

## 使用原则

- 先选输出文件类型，再写节、装载段和表项，不要从 PE/ELF 的原始字段开始推。
- PE、COFF 和 ELF 目标文件用 `format_section(...)` 声明节；ELF 可执行文件和共享库用 `format_segment(...)` 声明装载段。
- 头部、表项、对齐、RVA、文件偏移和最终回填都由 `format.inc` 生成，源文件只声明内容边界和必要元数据。
- 同一个文件不要一边用 `format.inc`，一边手写 PE/ELF 头部或表项；必须手写这些字段时，整份文件都按高级格式构造的方式组织。
- 从最小的 `.text` 模板开始，先让最小模板汇编通过，再逐步加入导入、导出、资源、重定位和 BSS。

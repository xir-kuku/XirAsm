# 格式校验

`include/format/` 在接受输出文件之前检查所生成的结构。每种输出都必须显式收尾：可执行文件和目标文件调用 `format_finish(image)`，独立 ZIP 调用 `zip_finish()`。添加 ZIP 条目后漏写中央目录，或者在归档完成后追加字节，都会被拒绝。

ELF64 动态 EXEC 和 PIE 支持 x86-64 PLT 导入，以及 x86-64/AArch64 提前解析的 GOT 导入。`format_elfexe_import_slots_mut(imports, library, names)` 按 `names` 中的名称创建地址槽，通过槽间接调用函数。导入表、导出和自定义解释器必须在 `format_begin` 之前声明。

需要指向动态 ELF 映像内部的绝对指针时，在已经打开的可写段中，指针所在位置调用 `format_elf_relptr_mut(image, segment_name, target_label)`。`target_label` 使用标签名称字符串，与其它动态格式接口一致。PIE/SO 中的槽使用不引用动态符号的 `RELATIVE` 重定位。默认可见的导出目标应使用符号地址槽，保留符号抢占行为；固定地址的动态 EXEC 则直接写入目标地址。没有导入或导出表的可执行文件，须先在 `format_begin` 前调用 `format_elf_dynamic_mut` 开启动态配置，才能使用此接口。

AArch64 目标文件继续显式登记重定位。未知类型、未对齐的指令字段和超出所在节的字段会被拒绝。在有文件内容的目标节中保留尾部地址槽，仍生成 `PROGBITS`；显式声明的未初始化 `.bss` 保持 `NOBITS`。

Android AXML 要求元素和命名空间配对关闭、命名空间 URI 已声明，以及每个元素的属性唯一。AXML 和 ARSC 字符串值接收严格 UTF-8 输入，包括中文、补充平面字符和空字符串。APK 应用接口要求至少一个原生库，并且每个包含的 ABI 都有对应主库。非法包名、重复归档路径、无效原生 ELF 和不足的原生库对齐都会被拒绝。

AArch64 延迟 PLT、TLS 声明、自定义 IFUNC/IRELATIVE resolver、显式符号版本和完整链接器仍不在这些接口范围内。A64 指令编码和自动指令重定位捕获与显式格式接口分开实现。

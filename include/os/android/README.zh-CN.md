# XIRASM Android SDK include

[English](README.md)

这些声明覆盖 NDK r27d 平台符号、常量与原生结构。每个提供库、每个 ABI 分别保存首次 API、符号类型和 GNU 版本，保留原有五个 ABI 位。AArch64 与 x86-64 各有 4,562 个符号/库配对，其中 265 个是对象；ELF 导入支持这两个 64 位机器。

头文件分区提供 1,168 个常量。结构分区提供 25 个 LP64 类型及 25 个明确命名的 ARM32 变体，包含嵌套、union、固定数组和回调地址。

## 选择声明

`os/android/sdk.inc` 导入全部常量、结构类型和目录查询；`os/android.inc` 另加常用的八个平台库；`imports.inc` 声明全部 25 个库。小型源码可只导入 `defs/`、`structs/`、`imports/` 下需要的文件。声明本身不输出字节，也不生成动态导入。

```asm
import("os/android/sdk.inc")
assert(sizeof(ANativeWindow_Buffer) == 48)
assert(sizeof(ANativeWindow_Buffer_arm32) == 44)
assert(android_native_window_WINDOW_FORMAT_RGBA_8888 == 1)
```

## 分配和初始化结构体

真实类型可配合字面量、`emit.struct`、`pack`、`sizeof` 和 `offset_of` 使用：

```asm
import("os/android/structs/native_window.inc")
import("os/android/structs/rect.inc")
const buffer: ANativeWindow_Buffer = ANativeWindow_Buffer {
    width: 640,
    height: 480,
    stride: 640,
    format: 1,
    reserved: android_ANativeWindow_Buffer_reserved { }
}
const dirty: ARect = ARect { right: 640, bottom: 480 }
assert(buffer.width == 640)
assert(offset_of(ANativeWindow_Buffer, bits) == 16)
assert(sizeof(ARect) == 16)
emit.struct(buffer)
emit.struct(dirty)
```

默认名称采用 AArch64 与 x86-64 共用的 LP64 布局；`_arm32` 明确描述 ARM32，不能当作 i686 类型。存储地址须遵循 ABI 对齐，64 位调用前保持栈 16 字节对齐。`sizeof` 包括结构尾部填充，但不会对齐发射实例的当前位置。

LP64 的指针和回调保存为 `u64` 地址，ARM32 保存为 `u32`。C `float` 字段使用 `f32`，以 `f32(1.5)` 等精确宽度的值初始化。固定数组用含 `element0`、`element1` 等字段的辅助结构表示。匿名 C union 使用命名容器，例如 `ASensorEvent.payload.values.acceleration.components.cartesian.x`，按声明路径调用 `offset_of`。

平台提供的对象也按真实类型访问：

```asm
import("os/android/structs/native_activity.inc")
x86.use64()
mov rax, [rdi + offset_of(ANativeActivity, callbacks)]
lea rdx, [rel on_destroy]
mov [rax + offset_of(ANativeActivityCallbacks, onDestroy)], rdx
ret
on_destroy:
ret
```

旧 `android_layout_<Type>_size64/size32` 和字段偏移常量继续兼容；新代码使用真实类型。

## 逐个检查导入的 API 与 ABI

先创建 ELF 映像，再在 `format_begin` 前用严格库入口声明导入。入口检查映像机器、提供库、最低 API 和符号类型。

| 入口 | 用途 |
| --- | --- |
| `android_import_<别名>_add_checked_mut(imports, image, names, minimum_api, abi_bit)` | x86-64 函数 PLT |
| `android_import_<别名>_add_slots_checked_mut(imports, image, names, minimum_api, abi_bit)` | AArch64/x86-64 函数或对象的提前解析 GOT |
| `android_import_<别名>_import_mut(imports, image, local_name, name, minimum_api, abi_bit, plt)` | 单个导入及本地别名 |
| `android_import_<别名>_add_pairs_checked_mut(imports, image, pairs, minimum_api, abi_bit, plt)` | 交替的本地/公开名称 |

稳定 ABI 位为 `android_abi_aarch64=1`、`android_abi_arm=2`、`android_abi_x86=4`、`android_abi_riscv64=8`、`android_abi_x86_64=16`。一次传一个位；ELF64 入口接收 AArch64 或 x86-64。

```asm
import("format/format.inc")
import("os/android/imports/liblog.inc")
import("arm/a64-macros.inc")
let image: map = format_elf64_so_aarch64("libwrite.so",
    list.of(format_segment(".text", format_load | format_readable | format_executable)))
let exports: list = format_elfso_export_new()
format_elfso_export_many_mut(exports, list.of("write_wrapper"), ".text", 8)
let imports: list = format_elfso_import_new()
android_import_log_add_slots_checked_mut(imports, image,
    list.of(android_import_log___android_log_write), 26, android_abi_aarch64)
format_elfso_tables_mut(image, exports, imports)
format_begin(image)
format_segment_begin(image, ".text")
write_wrapper:
    ldr x8, __android_log_write
    br x8
format_segment_end(image, ".text")
format_finish(image)
```

旧的两参数 `add_mut` 和 `add_slots_mut` 检查库归属并拒绝对象 PLT，但不能检查调用方的最低 API 或映像 ABI。新代码使用严格入口。`tests/format/android_gl_demo/` 的两个 GLES 例子均使用严格导入和真实回调类型。

## 对象导入

对象 GOT 槽保存对象地址。OpenSL 的 `SL_IID_ENGINE` 等接口 ID 是指针变量，需要再读一次对象，得到接口 ID 值；不能走函数 PLT。

```asm
import("format/format.inc")
import("os/android/imports/libOpenSLES.inc")
let image: map = format_elf64_so("libengineid.so",
    list.of(format_segment(".text", format_load | format_readable | format_executable)))
let exports: list = format_elfso_export_new()
format_elfso_export_many_mut(exports, list.of("read_engine_id"), ".text", 11)
let imports: list = format_elfso_import_new()
android_import_opensles_add_slots_checked_mut(imports, image,
    list.of(android_import_opensles_SL_IID_ENGINE), 26, android_abi_x86_64)
format_elfso_tables_mut(image, exports, imports)
format_begin(image)
format_segment_begin(image, ".text")
read_engine_id:
    mov rax, [rel SL_IID_ENGINE]
    mov rax, [rax]
    ret
format_segment_end(image, ".text")
format_finish(image)
```

## 查询指定提供库与 ABI

```asm
import("os/android/catalog.inc")
const syms: map = android_symbols()
assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", android_abi_aarch64) == 30)
assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", android_abi_x86_64) == 29)
assert(!android_symbol_available_for(syms, "__tls_get_addr", "libc.so", 29, android_abi_aarch64))
assert(android_symbol_kind_for(syms, "SL_IID_ENGINE", "libOpenSLES.so", android_abi_aarch64) == "object")
```

`android_symbol_provider` 返回精确的 `api`、`kind`、`ver`；`android_symbol_version_for` 读取 GNU 版本。旧聚合查询可用于搜索，但跨 ABI 的最早 API 不能用来证明目标导入可用。

## 范围与验证

常量和原生布局由 NDK Clang 核对，结构测试另检查真实实例字节；符号记录与 NDK ELF 表核对。生成清单记录源哈希。使用这些 include 不要求安装 NDK。

NDK stub 描述链接期接口，设备可能导出更少或更多名字。GNU 版本仅保存为元数据，导入按无版本名字解析。TLS 重定位声明、IFUNC resolver、完整 C 原型、完整 JNI/POSIX 或图形音频绑定，以及 Java/Kotlin 工具链仍不在这些声明范围内。通用 Vulkan 绑定由独立 Vulkan API 层维护。

来源和许可见 [NOTICE.md](NOTICE.md)，APK 构造见 [Android 教程](../../../document/android.md)。

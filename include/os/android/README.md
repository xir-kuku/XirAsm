# XIRASM Android SDK Includes

[简体中文](README.zh-CN.md)

These declarations cover Android NDK r27d platform symbols, constants and native record layouts. API, symbol kind and GNU version are stored separately for each provider library and ABI. All five catalog ABI bits are preserved; AArch64 and x86-64 each have 4,562 symbol/library pairs, including 265 objects. ELF import helpers support those two 64-bit machines.

The header partitions provide 1,168 constants. The structure partitions provide 25 native record types for LP64 and 25 explicitly named ARM32 variants, with nested records, unions, fixed arrays and callback addresses.

## Choose Declarations

`os/android/sdk.inc` imports all constants, structure types and catalog queries. `os/android.inc` adds the usual eight platform libraries. `imports.inc` declares all 25 libraries. For a smaller source, import individual files under `defs/`, `structs/` and `imports/`. Declarations emit no bytes or dynamic imports by themselves.

```asm
import("os/android/sdk.inc")
assert(sizeof(ANativeWindow_Buffer) == 48)
assert(sizeof(ANativeWindow_Buffer_arm32) == 44)
assert(android_native_window_WINDOW_FORMAT_RGBA_8888 == 1)
```

## Allocate and Initialize Native Structures

Use the actual types with literals, `emit.struct`, `pack`, `sizeof` and `offset_of`:

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

Default names use the LP64 layout shared by AArch64 and x86-64. `_arm32` types describe ARM32 and must not be treated as i686 types. Align storage according to the ABI; preserve 16-byte stack alignment around 64-bit calls. `sizeof` includes record padding and does not align the address at which a record is emitted.

Pointers and callbacks are `u64` addresses in LP64 and `u32` in ARM32. C `float` fields are `f32`; initialize them with exact-width values such as `f32(1.5)`. A fixed array is a helper structure with `element0`, `element1`, and so on. Anonymous C unions have named containers, such as `ASensorEvent.payload.values.acceleration.components.cartesian.x`; use the declared path with `offset_of`.

Platform-owned records can be accessed through the same types:

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

The old `android_layout_<Type>_size64/size32` and field-offset constants remain available for compatibility. New sources should use the native types.

## Check Each Import's API and ABI

Create the ELF image first, then choose imports through the checked helper before `format_begin`. It checks the image machine, provider library, minimum API and symbol kind.

| Helper | Use |
| --- | --- |
| `android_import_<alias>_add_checked_mut(imports, image, names, minimum_api, abi_bit)` | x86-64 function PLT imports |
| `android_import_<alias>_add_slots_checked_mut(imports, image, names, minimum_api, abi_bit)` | AArch64/x86-64 eager GOT imports for functions or objects |
| `android_import_<alias>_import_mut(imports, image, local_name, name, minimum_api, abi_bit, plt)` | One import with a local alias |
| `android_import_<alias>_add_pairs_checked_mut(imports, image, pairs, minimum_api, abi_bit, plt)` | Alternating local/public names |

Stable ABI bits are `android_abi_aarch64=1`, `android_abi_arm=2`, `android_abi_x86=4`, `android_abi_riscv64=8`, `android_abi_x86_64=16`. Pass one bit; the ELF64 helpers accept AArch64 or x86-64.

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

The old two-argument `add_mut` and `add_slots_mut` helpers check library ownership and reject object PLT imports, but cannot check the caller's minimum API or image ABI. Prefer the checked helpers. Both GLES examples under `tests/format/android_gl_demo/` use checked imports and native callback types.

## Object Imports

An object GOT slot contains the object's address. OpenSL interface IDs such as `SL_IID_ENGINE` are pointer-valued objects: read the object once more to obtain the interface ID. Objects cannot be called through a PLT.

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

## Query Exact Provider Metadata

```asm
import("os/android/catalog.inc")
const syms: map = android_symbols()
assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", android_abi_aarch64) == 30)
assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", android_abi_x86_64) == 29)
assert(!android_symbol_available_for(syms, "__tls_get_addr", "libc.so", 29, android_abi_aarch64))
assert(android_symbol_kind_for(syms, "SL_IID_ENGINE", "libOpenSLES.so", android_abi_aarch64) == "object")
```

`android_symbol_provider` returns the exact `api`, `kind` and `ver` row. `android_symbol_version_for` reads its GNU version. Existing aggregate queries remain useful for searching, but an earliest API across several ABIs is insufficient to validate a target import.

## Scope and Validation

Constants and native layouts are checked against NDK Clang; structure tests also inspect actual typed instance bytes. Symbol records are checked against NDK ELF tables. Generated manifests record source hashes. An NDK installation is not needed to use these includes.

NDK stubs describe a link-time surface; a device can export fewer or additional names. GNU versions are metadata and imports resolve unversioned names. TLS relocation declarations, IFUNC resolvers, complete C prototypes, complete JNI/POSIX or graphics/audio bindings, and Java/Kotlin tooling remain outside these declarations. Generic Vulkan bindings belong in the separate Vulkan API layer.

See [NOTICE.md](NOTICE.md) for the source and license, and [the Android guide](../../../document/android.md) for APK construction.

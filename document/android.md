# 用 XIRASM 写 Android：原生 APK 与平台符号目录

XIRASM 把一份汇编源码变成可安装的 Android APK：二进制清单、资源表、图标与资源条目、ZIP 容器、native 共享库都在汇编期生成，构造阶段不需要资源编译器。签名是唯一的外部步骤，交给 Android SDK 自带的签名工具。

配套的 SDK 在 `include/os/android/`：`imports/` 给出平台符号及逐 ABI 的 API 门槛，`defs/` 提供头文件常量，`structs/` 提供可实例化的原生结构体与 union。完整声明入口是 `os/android/sdk.inc`，平台库仍按需导入。平台库名、API 级别和结构体布局由这些声明提供。

两部分合起来覆盖 NativeActivity 类纯原生应用：没有 Java/Kotlin 业务代码，界面与逻辑都在 native 层。工具、图形程序、示例，以及需要精确控制加载内容、不愿引入重量级构建链的项目适合这条路。

## 各产物由谁生成

| 产物 | 生成者 |
| --- | --- |
| `AndroidManifest.xml`（二进制 AXML） | XIRASM，`format/axml.inc` |
| `resources.arsc`（资源表） | XIRASM，`format/arsc.inc` |
| 图标、字符串、资源与 assets 条目 | XIRASM，`format/apk.inc`（含 `res/` 目录扫描） |
| ZIP 容器、CRC-32、条目对齐 | XIRASM，`format/zip.inc` |
| `lib/<abi>/*.so`（ELF 共享库） | XIRASM，`format/format.inc` |
| `classes.dex`（启动占位） | XIRASM，`format/apk.inc` |
| APK 签名（v1/v2/v3） | 外部签名工具，例如 Android SDK 的 `apksigner` |

其余部分由 Android 负责：PackageManager 解析清单与资源表，动态链接器加载 native 库，NativeActivity 驱动进程与窗口。构造阶段不需要 `aapt2`，它只在独立复核产物时作为对照器使用。

## 环境

- XIRASM 本体。
- Android SDK Build Tools 36 或更高版本：提供 `aapt2`（对照检查）、`zipalign`（对齐检查）、`apksigner`（签名）。
- JDK：只用于运行 `apksigner`，不参与 native 程序运行。
- `adb`：把 APK 装到模拟器或真机。

这四个工具可以直接放进 `PATH`，也可以在命令行给出各自的完整路径。

## 构建分三步

原生 APK 不是一次汇编出来的。共享库要先进 APK 的归档，而归档的构造需要一个已经存在的 `.so` 文件，所以顺序固定为：**先编库，再打包，最后签名**。

| 步骤 | 命令 | 产物 |
| --- | --- | --- |
| 1. 汇编共享库 | `xirasm min-so.asm -o libmain.so` | `libmain.so` |
| 2. 打包归档 | `xirasm demo-apk.asm -o demo-unsigned.apk` | 未签名 APK |
| 3. 对齐并签名 | `zipalign` 与 `apksigner` | 可安装 APK |

第一步与第二步是两个独立的汇编任务，各自读一份源码。第二步把第一步的产物当**输入文件**读进来，所以工作目录里必须先有 `libmain.so`；缺了会报 `apk entry input file does not exist`。库的文件名要与打包脚本里写的一致，`apk_new` 的第四个参数（下面例子里的 `"main"`）则是清单 `android.app.lib_name` 元数据的值，框架按这个名字去 `lib/<abi>/` 里找库，末尾不带 `.so`。

每换一个 ABI 就重跑一遍第一步，然后把每个 ABI 的库都登记进同一个 APK。

## 汇编共享库

框架加载 native 库后只找一个符号：导出的 `ANativeActivity_onCreate`。库把回调函数写进框架传进来的函数表，之后窗口创建、重绘、销毁都由框架按表调用。下面这份源码是一个完整的库：它取下窗口宽高，把这三个回调登记好。

```asm id=apk-native-so-callbacks
import("format/format.inc")
import("os/android/defs/native_activity.inc")
import("os/android/structs/native_activity.inc")
import("os/android/imports/libandroid.inc")

// 文件类型是共享库，两个装载段分别放代码与可写数据。
let image: map = format_elf64_so(
    "libmain.so",
    list.of(
        format_segment(".text", format_load | format_readable | format_executable),
        format_segment(".data", format_load | format_readable | format_writeable)
    )
)

// 只导出框架要解析的那一个符号。第三个参数是符号大小，桩函数用跳转实现，给 16 字节即可。
let exports: list = format_elfso_export_new()
format_elfso_export_many_mut(exports, list.of("ANativeActivity_onCreate"), ".text", 16)

// 导入只写符号名，库名由生成的目录补齐，不在这里手写。
let imports: list = format_elfso_import_new()
android_import_android_add_checked_mut(imports, image, list.of(
    android_import_android_ANativeWindow_getWidth,
    android_import_android_ANativeWindow_getHeight), 26, 16)
format_elfso_tables_mut(image, exports, imports)

// 上面的严格入口逐个检查符号能否用于 API 26、x86-64 的映像。

format_begin(image)
format_segment_begin(image, ".text")

// 框架解析的入口。它只负责登记回调，真正的初始化留给窗口创建回调。
ANativeActivity_onCreate:
    jmp demo_install_callbacks

// 第一个参数是 ANativeActivity，它的首字段是回调表指针。
demo_install_callbacks:
    mov rax, [rdi + offset_of(ANativeActivity, callbacks)]
    lea rdx, [rel demo_on_window_created]
    mov [rax + offset_of(ANativeActivityCallbacks, onNativeWindowCreated)], rdx
    lea rdx, [rel demo_on_window_destroyed]
    mov [rax + offset_of(ANativeActivityCallbacks, onNativeWindowDestroyed)], rdx
    lea rdx, [rel demo_on_destroy]
    mov [rax + offset_of(ANativeActivityCallbacks, onDestroy)], rdx
    ret

// 窗口创建时框架传来第二个参数 ANativeWindow，宽高要从它身上问。
demo_on_window_created:
    push rbx
    mov rbx, rsi
    mov rdi, rbx
    call ANativeWindow_getWidth_plt
    mov [rel demo_width], eax
    mov rdi, rbx
    call ANativeWindow_getHeight_plt
    mov [rel demo_height], eax
    pop rbx
    ret

// 窗口没了，存下来的尺寸随即失效，清零避免下一次重绘读到旧值。
demo_on_window_destroyed:
    mov dword [rel demo_width], 0
    mov dword [rel demo_height], 0
    ret

// 没有要释放的资源，也没有退出的调用可做，框架自己结束 activity 并卸载库。
demo_on_destroy:
    ret

format_segment_end(image, ".text")

// 回调之间共享的状态放数据段。未初始化的槽位必须在文件里有值，否则是未定义内容。
format_segment_begin(image, ".data")
demo_width:
    dd(0)
demo_height:
    dd(0)
format_segment_end(image, ".data")

format_finish(image)
```

要点：

- **x86-64 共享库的导入函数在调用点加 `_plt`**，直接 `call ANativeWindow_getWidth_plt` 就完成了一次 PLT 跳转，不需要自己写 GOT 槽位的取值。
- **回调表使用真实结构体**：`offset_of(ANativeActivityCallbacks, 字段)` 从类型声明取成员位置。声明的大小与字段位置由 NDK Clang 和汇编产物分别核对。
- **导出符号的大小不影响框架**，它只按名字解析地址。桩函数写小一点，符号表里这个大小就只是桩的大小，不会随实现增长。
- **库名来自目录**：产物里的 `DT_NEEDED` 是 `libandroid.so`（用了 EGL 就是 `libEGL.so`、`libGLESv2.so`），全部由 `android_import_<别名>_add_mut` 推出，源码里一个库名都没写。
- **不写 `libmain.so` 的依赖**：共享库不链接 libc，它只用平台库与自己的段。

AArch64 用 `format_elf64_so_aarch64`，它把 LOAD 段的对齐提到 16 KiB，这是 Android 15 及以后在 arm64 上的页大小要求，用 `format_elf64_so` 编出来的默认对齐在这类设备上装不进去。AArch64 的导入也不走 PLT，而是 GOT 槽位加间接跳转，辅助函数与调用写法见下文「挂平台导入：一个 .so 两种写法」。

编译并独立复核，用 LLVM 工具读回产物：

```text
xirasm min-so.asm -o libmain.so
llvm-readobj --file-headers libmain.so
llvm-readobj --dynamic-table libmain.so
llvm-nm -D --undefined-only libmain.so
llvm-objdump -d libmain.so
```

上面那份源码编出来是 1768 字节的 ELF64 共享库，`Type: SharedObject`、`Machine: EM_X86_64`，动态符号表里 `ANativeActivity_onCreate` 是 `.text` 段里唯一的定义符号，`ANativeWindow_getWidth` 与 `ANativeWindow_getHeight` 是未定义导入，`NEEDED` 只有 `libandroid.so`。反汇编能看到三条写回调表的指令落在偏移 `0x28`、`0x38`、`0x50`，也就是 40、56、80 字节——与 `defs` 里给出的 `onDestroy`、`onNativeWindowCreated`、`onNativeWindowDestroyed` 偏移一致。

### 一份完整的渲染器

仓库里带一个能出画面的库 `tests/format/android_gl_demo/gl-demo-so.asm`（439 行）：窗口创建时建 EGL 上下文、编译两个 shader、上传一张汇编期按公式算出来的 16×16 RGBA 纹理、画一个全屏四边形。顶点坐标与纹理都在汇编期算好写进数据段，运行期只做一次 `glTexImage2D` 上传，所以库里没有素材、没有第三方依赖。

它用到了几个继续往下写时会用到的写法：EGL 属性数组（用 `dd` 逐个写属性名与值）、shader 源码作为 NUL 结尾字符串留在数据段、`glTexImage2D` 的九个参数里有三个从栈上传，以及用 `while` 循环在汇编期生成纹理像素。

那份源码用到的导入覆盖 `libandroid`、`libEGL`、`libGLESv2` 三个库，仍然没有一个库名是手写的。

## 一条龙打包

打包脚本用一份编译期文档描述整个应用，`apk_emit` 一次写出清单、资源表、图标、assets、启动 DEX 与各个 ABI 的 native 库：

```asm id=apk-facade-all-in-one skip
// 需要输入文件：本块不单独汇编，配套文件见正文说明（needs input files）。
import("format/apk.inc")

origin(0)

let app: map = apk_new("com.example.tool", 1, "1.0", "demo")
app = apk_set_sdk(app, 26, 34)
app = apk_label_string(app, "app_name", "Example Tool")
app = apk_icon(app, "mdpi", "res/mipmap-mdpi/ic_launcher.png", "icons/mdpi.png")
app = apk_icon(app, "hdpi", "res/mipmap-hdpi/ic_launcher.png", "icons/hdpi.png")
app = apk_asset(app, "assets/readme.txt", "docs/readme.txt")
app = apk_native_lib(app, "arm64-v8a", "libdemo.so", "build/arm64-v8a/libdemo.so")
app = apk_native_lib(app, "x86_64", "libdemo.so", "build/x86_64/libdemo.so")
apk_emit(app)
```

这段代码演示调用形状；它引用的 `icons/`、`docs/` 和 `build/` 下的文件要由项目自己准备，缺了会报 `apk entry input file does not exist`。其中 `build/` 下的两个 `.so` 就是上一步编出来的库。

同样的应用，让资源目录自己声明资源，再把主库加入归档：

```asm id=apk-facade-res-dir skip
// 需要输入文件：本块不单独汇编，配套文件见正文说明（needs input files）。
import("format/apk.inc")

origin(0)

let app: map = apk_new("com.example.tool", 1, "1.0", "demo")
app = apk_set_sdk(app, 26, 34)
app = apk_res_dir(app, "res")
app = apk_native_lib(app, "arm64-v8a", "libdemo.so", "build/arm64-v8a/libdemo.so")
apk_emit(app)
```

要点：

- **配置是赋值链，不是就地修改**：每个 `apk_*` 返回一份新的应用文档，所以必须写成 `app = apk_xxx(app, ...)`。漏掉赋值时那一步的配置不会进入产物。
- **`apk_icon` 与 `apk_resource_file` 把资源表条目和归档条目成对登记**，两者用的必须是同一个路径字符串，成对登记后就不可能写岔。`apk_icon_bytes` 与 `apk_asset_bytes` 接受内联字节，适合构建期生成的小文件。
- 只要声明了资源，清单里的 `android:label` 与 `android:icon` 就写成资源引用，`resources.arsc` 一并产出；一个资源都没声明时走固定模板清单。
- `apk_label` 是字面量应用名，不建资源表；`apk_label_string` 建字符串资源并让清单引用它，两者同时给出时后者优先。
- 字符串资源的值可以是任何文字（中文、emoji 都可以）；资源名、类型名和包名保持 ASCII，这也是 Android 对它们的要求。XIRASM 源码本身按 ASCII 读取，所以非 ASCII 文本从数据文件读入：

  ```asm id=apk-non-ascii-strings skip
  // 需要输入文件：本块不单独汇编，配套文件见正文说明。
  import("format/apk.inc")

  // 字符串放在源文件旁边，用 | 分隔。
  const raw: string = fs.read_text("strings.txt")
  const values: list = split(raw, "|")

  let app: map = apk_new("com.example.tool", 1, "1.0", "demo")
  app = apk_label_string(app, "app_name", trim(list.get(values, 0)))
  app = apk_string_resource(app, "tagline", trim(list.get(values, 1)))
  ```

  资源池按平台的方式存储文本：补充平面字符（例如 emoji）写成代理对，两半各自编码，读回来与系统其它应用一致。
- 默认写出 112 字节的启动 DEX，应用声明 `hasCode=false`、不执行任何 Java 代码；用 `apk_skip_dex(app)` 可以不写。
- `.so` 条目自动按 16 KiB 对齐，满足 Android 15 及以后对未压缩共享库的页对齐要求。
- 清单设置 `extractNativeLibs=false`，让 Android 直接映射 APK 中对齐的未压缩库。
- `apk_emit` 至少需要一个 native 库；每个声明的 ABI 都必须包含 `lib<lib_name>.so` 主库。包名、版本、SDK 范围和重复归档条目会在输出前检查。
- 条目默认按 STORED（不压缩）写入；需要压缩的条目逐条选择，见下文。

## 应用配置 API

`format/apk.inc` 一共导出 58 个 `apk_*` 函数，下面按用途分组列出全部面向调用者的那些。每个函数返回一份新的应用文档，签名里的 `app` 就是当前文档；表中第三列是它对产物的作用。

创建与整体设置：

| 函数 | 参数 | 作用 |
| --- | --- | --- |
| `apk_new` | `package_name`, `version_code`, `version_name`, `lib_name` | 建一份应用文档。`version_code` 是整数、`version_name` 是显示给用户的字符串，`lib_name` 是清单里 `android.app.lib_name` 的值，也就是框架要加载的库名（不带 `.so`）。两个字符串都不得为空 |
| `apk_set_sdk` | `app`, `min_sdk`, `target_sdk` | 写清单里的 `minSdkVersion` 与 `targetSdkVersion`。不调用时取模块默认值 24 与 35 |
| `apk_set_min_sdk` / `apk_set_target_sdk` | `value` | 改模块默认值，影响之后新建的应用文档。它们是整份源码的全局设置，与上面按应用设置的入口等价，选一个用 |
| `apk_skip_dex` | `app` | 不写启动 DEX 条目。应用没有任何 Java 代码时可以省掉 |

应用名与图标：

| 函数 | 参数 | 作用 |
| --- | --- | --- |
| `apk_label` | `app`, `text` | 字面量应用名。只在应用没有声明资源时有效，声明了字符串资源时以资源为准 |
| `apk_label_string` | `app`, `name`, `text` | 建一条字符串资源并用它作应用名，会让清单改走资源引用 |
| `apk_string_resource` | `app`, `name`, `text` | 建一条字符串资源，但不把它当应用名 |
| `apk_string_resource_locale` | `app`, `name`, `text`, `locale` | 同上，带两字母语言配置 |
| `apk_use_label` | `app`, `name` | 改用一条**已经声明**的字符串资源作应用名。名字写错在写清单时报错 |
| `apk_use_icon` | `app`, `type_name`, `res_name` | 改用一条已经声明的文件资源作启动图标 |
| `apk_use_theme_id` | `app`, `style_id` | 按框架资源 ID 设置应用主题。收 ID 而不是名字，因为名字到 ID 的目录很大，只有真要用它的程序才该导入 |

图标与文件资源：

| 函数 | 参数 | 作用 |
| --- | --- | --- |
| `apk_icon` | `app`, `density_name`, `apk_path`, `local_path` | 一档密度的启动图标，字节从文件读 |
| `apk_icon_bytes` | `app`, `density_name`, `apk_path`, `data` | 同上，字节在源码里内联给出 |
| `apk_resource_file` | `app`, `type_name`, `res_name`, `density_name`, `apk_path`, `local_path` | 其它类型的文件资源。资源表条目与归档条目在这里一起登记 |
| `apk_native_lib` | `app`, `abi_dir`, `so_name`, `local_path` | 收编一个 ABI 的 native 库，按 16 KiB 对齐写入 `lib/<abi>/` |

assets 与普通条目：

| 函数 | 参数 | 作用 |
| --- | --- | --- |
| `apk_asset` | `app`, `apk_path`, `local_path` | 普通归档条目，不产生资源表条目 |
| `apk_asset_bytes` | `app`, `apk_path`, `data` | 同上，字节内联给出 |

资源目录扫描：

| 函数 | 参数 | 作用 |
| --- | --- | --- |
| `apk_res_dir` | `app`, `local_dir` | 扫描整个 `res/` 树，归档路径镜像该目录 |
| `apk_res_dir_at` | `app`, `local_dir`, `apk_prefix` | 同上，归档前缀由调用者给出。目录不叫 `res` 时用它 |

压缩条目（与上面几个一一对应，差别只在归档里存成 DEFLATE）：

| 函数 | 参数 | 作用 |
| --- | --- | --- |
| `apk_asset_compressed` | `app`, `apk_path`, `local_path` | `apk_asset` 的压缩版 |
| `apk_asset_bytes_compressed` | `app`, `apk_path`, `data` | `apk_asset_bytes` 的压缩版 |
| `apk_resource_file_compressed` | `app`, `type_name`, `res_name`, `density_name`, `apk_path`, `local_path` | `apk_resource_file` 的压缩版。资源表里记的路径不变，条目与表仍然一致 |

写出：

| 函数 | 参数 | 作用 |
| --- | --- | --- |
| `apk_emit` | `app` | 写出整份 APK：清单、资源表、每个资源与 asset 条目、启动 DEX、native 库，然后关闭归档 |

## 资源表构造 API

资源表也可以不用 facade，直接用 `format/arsc.inc` 的值风格 builder 逐条组装。声明一条资源就是加一条 `(类型, 名字, 配置) → 值` 的记录：

```asm id=apk-arsc-tables skip
// 需要输入文件：本块不单独汇编，配套文件见正文说明（needs input files）。
import("format/apk.inc")

origin(0)

// 包 ID 取 0x7f，是应用自己的资源空间。
let res: map = arsc_new("com.example.tool", 0x7f)
res = arsc_string(res, "app_name", "Example Tool")
res = arsc_string_locale(res, "app_name", "Example Tool ZH", "zh")
res = arsc_file(res, "mipmap", "ic_launcher", "mdpi", "res/mipmap-mdpi/ic_launcher.png")
res = arsc_file(res, "mipmap", "ic_launcher", "hdpi", "res/mipmap-hdpi/ic_launcher.png")
res = arsc_int(res, "integer", "version_slot", 3)
res = arsc_bool(res, "bool", "enabled", true)

apk_manifest_res_entry(res, "com.example.tool", 1, "1.0",
    "string/app_name", "mipmap/ic_launcher", "demo")
apk_resources_entry(res)
apk_res_file_entry("res/mipmap-mdpi/ic_launcher.png", "icons/mdpi.png")
apk_res_file_entry("res/mipmap-hdpi/ic_launcher.png", "icons/hdpi.png")
```

这段代码需要 `icons/` 与 `res/` 下的文件存在，缺了会报输入文件不存在。

可用的 builder：

| 函数 | 参数 | 说明 |
| --- | --- | --- |
| `arsc_new` | `package_name`, `package_id` | 新建资源表文档。应用自己的资源用包 ID `0x7f` |
| `arsc_string` | `doc`, `name`, `text` | 默认配置下的字符串资源 |
| `arsc_string_locale` | `doc`, `name`, `text`, `locale` | 两字母语言配置下的字符串资源 |
| `arsc_file` | `doc`, `type_name`, `name`, `density_name`, `path` | 文件资源，`path` 是资源值指向的 APK 条目名 |
| `arsc_file_locale` | `doc`, `type_name`, `name`, `density_name`, `locale`, `path` | 文件资源，带语言配置，密度可以为空 |
| `arsc_int` | `doc`, `type_name`, `name`, `value` | 整数资源，按十进制读 |
| `arsc_hex` | `doc`, `type_name`, `name`, `value` | 整数资源，按十六进制读 |
| `arsc_bool` | `doc`, `type_name`, `name`, `value` | 布尔资源 |
| `arsc_reference` | `doc`, `type_name`, `name`, `target` | 存放另一个资源 ID 的引用 |
| `arsc_add` | `doc`, `type_name`, `name`, `kind`, `text`, `value`, `density`, `locale` | 上面几个的通用形式，`kind` 是值类型编号 |
| `arsc_density` | `name` | 密度名字转成表里用的数值 |

查询与取出 ID：

| 函数 | 参数 | 说明 |
| --- | --- | --- |
| `arsc_resolve_id` | `out`, `doc`, `type_name`, `entry_name` | 把一条已声明资源的数字 ID 写进 `out`（一个 `bytes` 缓冲区），形式是 `0x7f...`，可以直接喂给 `axml_attr_reference` 在自定义 XML 里引用资源 |
| `arsc_type_names` | `items` | 文档里出现的类型名，按首次出现顺序去重 |
| `arsc_entry_names` | `items`, `type_name` | 某一类型的条目名，按首次出现顺序去重 |
| `arsc_find` | `items`, `type_name`, `name`, `density`, `locale` | 定位一条资源值，返回它在文档列表里的下标 |
| `arsc_build` | `out`, `doc` | 把文档编成 `resources.arsc` 字节写进 `out` |

规则：

- **资源 ID 由名字决定，与声明顺序无关**：类型 ID 从 1 开始按类型名字典序分配，类型内的条目 ID 按条目名字典序分配。同一组资源无论按什么顺序写，产物字节相同。
- 密度用名字写：`ldpi`、`mdpi`、`tvdpi`、`hdpi`、`xhdpi`、`xxhdpi`、`xxxhdpi`、`nodpi`。
- 资源条目里记录的路径就是 APK 内的条目名。用低层入口时要自己保证 `arsc_file` 的路径与 `apk_res_file_entry` 的路径一致；走 facade 的 `apk_icon` 时这条自动成立。
- 字符串值支持中文、补充平面字符和空字符串；补充平面字符按平台的代理对方式编码。资源名必须保持 ASCII 标识符。

`format/axml.inc` 的独立清单构造器也支持这些文本。开始和结束节点必须同名配对，命名空间必须配对关闭；使用未声明的 URI、重复活跃前缀或同一节点的重复属性会被拒绝。

## 压缩条目

归档条目可以按 DEFLATE（ZIP method 8）写入，压缩由引擎的原生实现完成：

```asm id=apk-compressed-entries skip
// 需要输入文件：本块不单独汇编，配套文件见正文说明（needs input files）。
import("format/apk.inc")

origin(0)

const notes: bytes = b"XIRASM XIRASM XIRASM XIRASM XIRASM XIRASM XIRASM"

let app: map = apk_new("com.example.tool", 1, "1.0", "demo")
app = apk_label(app, "Example Tool")
app = apk_asset_bytes_compressed(app, "assets/notes.txt", notes)
app = apk_asset_compressed(app, "assets/readme.txt", "docs/readme.txt")
app = apk_resource_file_compressed(app, "raw", "notice", "", "res/raw/notice.txt", "docs/readme.txt")
app = apk_native_lib(app, "arm64-v8a", "libdemo.so", "build/arm64-v8a/libdemo.so")
apk_emit(app)
```

规则：

- **压缩按条目选择，默认不压缩。** 资源表、清单、`.so` 与图标保持 STORED 加对齐：前两者是 Android 要求的，后两者本来就压不动。适合压缩的是 assets、文本、体积大的数据文件。
- 归档里记的 CRC-32 是**未压缩**数据的校验值，两种尺寸各记一份。`zip_finish` 的自检对压缩条目只核对头部一致性——压缩载荷没法在汇编期解压回来再核对，因此这一步交给真正的解压器：`tests/format/check_apk.py` 用 Python 的 `zipfile` 解出每个条目并核对 CRC。
- 压缩是确定性的：同样的输入与默认级别每次产出相同的字节，因此仍然可复现。
- 级别由引擎的 `deflate.compress(data, level)` 承担（1 最快，9 最小）。facade 用默认级别；要换级别就走低层入口 `zip_entry_compressed_level(name, data, level)`。不要自己压完再交给 `apk_asset_bytes`，那会被再压一次。
- 压不小的载荷按未压缩存更小，因为压缩流自带块头。

## 按目录扫描资源

资源数量增加之后，逐条声明不如让目录结构承担这项工作：`res/` 树的形状本身就是资源的坐标，`apk_res_dir` 把整棵树读进来。

```asm id=apk-res-dir-scan skip
// 需要输入文件：本块不单独汇编，配套文件见正文说明（needs input files）。
import("format/apk.inc")

origin(0)

let app: map = apk_new("com.example.tool", 1, "1.0", "demo")
app = apk_set_sdk(app, 26, 34)
// 读入源文件旁边的 res/ 树。
app = apk_res_dir(app, "res")
app = apk_native_lib(app, "arm64-v8a", "libdemo.so", "build/arm64-v8a/libdemo.so")
apk_emit(app)
```

这段代码要求工作目录下存在 `res/` 树，缺了会报 `apk resource directory is missing or unreadable: res`。仓库里现成可用的是 `tests/format/android_gl_demo/res/`，把它放在源文件旁边即可运行。

目录约定：

| 目录 | 含义 |
| --- | --- |
| `res/values/strings.toml` | 字符串资源，一个键一条；`app_name` 兼作应用名 |
| `res/values-zh/strings.toml` | 两字母语言配置下的同名资源 |
| `res/mipmap-hdpi/ic_launcher.png` | 文件资源：类型 `mipmap`，密度 `hdpi` |
| `res/drawable/logo.png` | 文件资源：默认配置 |

规则：

- 文件目录名写成 `<类型>[-<限定符>...]`。限定符可以是密度名（`ldpi`、`mdpi`、`tvdpi`、`hdpi`、`xhdpi`、`xxhdpi`、`xxxhdpi`、`nodpi`）、两字母语言码，或 `-v4` 这类 API 版本限定符。别的写法（`-land`、`-night`、`-sw600dp`、`-12`）直接报错而不是被丢掉——丢掉会让两个不同的值塌进同一个配置。
- 资源表只编译密度与语言两个轴，因此**一个目录最多带一个密度限定符和一个语言限定符**，多出来的同样报错。API 版本限定符被接受但不写进配置；两个目录因此落到同一个配置时，重复声明检查会把它们当作冲突报出来。
- 资源名是文件名里第一个点之前的部分，归档条目名保留原文件名。资源表里记的路径与归档里的条目名是同一个字符串，写不岔。
- `values*` 目录里放 TOML 表而不是文件，每个键一条字符串资源，值必须是字符串。这类目录只认 `.toml` 文件、不接受子目录，限定符只能带语言码或 API 版本（字符串没有密度轴）。TOML 只是编译期输入，不进归档。
- 扫描是递归的，跳过点开头的条目，顺序取排序后的目录枚举，所以同一棵树每次产出相同字节。同一棵树扫两遍无害；同一个资源配置被两个文件同时声明会报错。
- 声明了资源就要求清单里有应用名：扫描时 `app_name` 会自动绑定；树里没有 `app_name` 时用 `apk_label` 给字面量，或用 `apk_label_string` 显式建资源。`mipmap/ic_launcher` 同理自动成为图标。
- 约定名只在应用**完全没有设置**应用名或图标时自动绑定，显式设置过的不会被覆盖。换别的资源用 `apk_use_label(app, "name")` 与 `apk_use_icon(app, "mipmap", "ic_launcher_round")`；这两个调用只登记引用，资源是否存在在写清单时校验，且应用一个资源都没有时它们会报错（固定模板清单没有资源可引用）。
- 归档路径默认镜像被扫描的目录，所以 `apk_res_dir(app, "res")` 产出的正是 `res/...` 条目；目录不叫 `res` 时用 `apk_res_dir_at(app, "app_res", "res")` 显式给出归档前缀。

`tests/format/apk_res_scan_user_facade.asm` 是一份完整例子：`check_apk.py` 会用 `aapt2` 把扫出来的资源名、密度、语言配置和归档路径逐条读回来复核。APK 包含清单、资源表、资源文件、启动 DEX 和主库；`aapt2 dump badging` 读出包名 `com.example.xirasm.resdir`、版本号 3、默认应用名 `XIRASM Res Scan`、中文配置下的应用名 `资源目录扫描`，以及 `mdpi` 与 `hdpi` 两档图标各自的归档路径。

## 框架资源与主题

清单或资源值里引用 `@android:...` 时，要带上平台给这个资源的 ID，形式是 `0x01 <类型> <条目>`。仓库里带一份从平台 jar 生成的目录：

```asm id=apk-framework-theme skip
// 需要输入文件：先汇编 build/arm64-v8a/libdemo.so（needs input files）。
import("format/apk.inc")
import("format/android/generated/framework_ids.inc")

origin(0)

const ids: map = android_framework_ids()

let app: map = apk_new("com.example.tool", 1, "1.0", "demo")
app = apk_label_string(app, "app_name", "Example Tool")
app = apk_use_theme_id(app, android_style_id(ids, "Theme.DeviceDefault"))
app = apk_native_lib(app, "arm64-v8a", "libdemo.so", "build/arm64-v8a/libdemo.so")
apk_emit(app)
```

- 表本体是数据文件 `include/format/android/generated/framework_ids.toml`，由 `tests/format/generate_android_ids.py` 生成：它用 `aapt2` 读平台 jar 的 `resources.arsc`，也就是用平台自己的读取器而不是第二个解析器；随附的 `.inc` 只有一层薄封装。
- **只收录公开资源**：平台在表里给公开项打了 `PUBLIC`，应用本来也只该引用这些；私有项与 id 高于 `0x7f` 的动态资源类型（RRO 之类）不收录，当前平台上是 17 个类型、3037 条。确实需要全表时给生成器加 `--include-private`。
- 用法是加载一次、查多次：`android_framework_ids()` 读一次数据文件，之后 `android_attr_id`、`android_style_id`、`android_string_id`、`android_drawable_id`、`android_color_id` 或通用的 `android_id(ids, "类型", "名字")` 都只是在已加载的表里查；名字写错会带名字报错。
- 代价：import 这个 include 与什么都不导入的基线相当（134 ms），加载一次表约 0.2 s，单次查询可以忽略。**只有真正要用框架资源的源文件才 import 它**——把整张表在导入时逐条填进 `map` 的写法要 2 s，现在换成数据文件加原生 TOML 解析。
- `apk_use_theme_id` 收的是 **ID** 而不是名字，这样 `format/apk.inc` 不必背这份目录。
- 固定模板清单（一个资源都没声明时走的那条路）没有属性映射表，所以主题需要资源表：只设 `apk_label`、`apk_label_string` 或图标其中之一就会走资源表那条路。
- 目录里的 ID 与平台对得上：fixture 断言了 `attr/label = 0x01010001`、`attr/icon = 0x01010002`、`style/Theme.DeviceDefault = 0x01030128`、`string/ok = 0x0104000a`，验收脚本还会用 `aapt2` 把写进清单的主题 ID 读回来核对。
- 名字里带点的资源（`Theme.DeviceDefault`）在数据文件里以 `~` 代替点存储，查询助手负责换回来。这是为了避开"引号键里的点仍被拆成嵌套表"这一 TOML 解析偏差；TOML 规范里引号键是字面量。

## 低层打包入口

需要逐步控制时，facade 下面的入口都可以直接用：

```asm id=apk-low-level-entries skip
// 需要输入文件：本块不单独汇编，配套文件见正文说明（needs input files）。
import("format/apk.inc")

origin(0)
apk_set_min_sdk(26)
apk_set_target_sdk(34)
apk_manifest_entry("com.example.tool", 1, "1.0", "Example Tool", "demo")
apk_dex_entry()
apk_lib(b"arm64-v8a", b"libdemo.so", "build/arm64-v8a/libdemo.so")
apk_lib(b"x86_64", b"libdemo.so", "build/x86_64/libdemo.so")
apk_file_entry(b"assets/readme.txt", "docs/readme.txt")
zip_finish()
```

- `apk_manifest_entry` 写出固定模板清单：`hasCode=false`、NativeActivity、MAIN/LAUNCHER、`android.app.lib_name`。
- `apk_set_min_sdk` 与 `apk_set_target_sdk` 是模块级设置，默认 24 与 35。
- `apk_lib` 按 ABI 目录收编 native 库并按 16 KiB 对齐；`apk_file_entry` 收编任意预制文件。这两个都收字节串形式的条目名，所以 ABI 目录与库名写成 `b"..."`。
- 需要资源表时另外调 `apk_manifest_res_entry`（清单引用资源表）与 `apk_resources_entry`（写出 `resources.arsc`）。
- `zip_finish` 关闭归档并注册完整性检查：最终镜像里的 CRC-32、条目对齐、中央目录与 EOCD 都会在汇编结束前逐项复核。

上面这段引用的 `build/` 与 `docs/` 下的文件同样要由项目自己准备。

## 检查

汇编时可以同时输出逐行清单，含逻辑地址、文件偏移、字节与源码对照，调试布局很方便：

```text
xirasm app.xir -o app-unsigned.apk --listing app.lst
```

用 Android 自带工具独立复核产物：

```text
aapt2 dump badging app-unsigned.apk
aapt2 dump xmltree app-unsigned.apk --file AndroidManifest.xml
aapt2 dump resources app-unsigned.apk
zipalign -c -v 4 app-unsigned.apk
zipalign -c -v -P 16 4 app-unsigned.apk
```

`badging` 显示应用名和各密度的图标条目，`xmltree` 显示清单结构，`resources` 逐条列出资源 ID、配置和值。三者都能读通，说明清单和资源表是 Android 工具链认可的二进制格式。

native 库单独核对时用 LLVM 工具，它读的是 ELF 结构本身：

```text
llvm-readobj --file-headers libmain.so
llvm-readobj --dynamic-table libmain.so
llvm-nm -D libmain.so
llvm-objdump -d libmain.so
```

`--dynamic-table` 里的 `NEEDED` 应当是平台库（`libandroid.so`、`libEGL.so` 等），`llvm-nm -D` 里应当有 `T ANativeActivity_onCreate` 和若干 `U` 开头的导入，两者与源码里登记的导入导出对得上，库才可能在设备上加载起来。

仓库里带一个可复现的验收脚本，它自己汇编 fixture，并用上面的工具当裁判：

```text
python tests/format/check_apk.py --assembler zig-out/bin/xirasm.exe
```

不带工具路径时只用 Python 标准库做结构自检（ZIP 完整性、CRC-32、4 字节对齐、AXML 与 resources.arsc 的 chunk 走查）；通过 `--sdk-bin` 把 Build Tools 目录传进来之后，会额外跑 `aapt2 badging`、`aapt2 xmltree`、`aapt2 resources` 与 `zipalign` 的全部检查。

## 签名

**签名不在 XIRASM 内，也不在路线图里**：引擎不做密钥与证书运算，`apk_emit` 产出的是未签名 APK，交由外部签名工具处理。Android PackageManager 会拒绝没有证书的 APK，所以侧载也要签；这一步用任何能签 APK 的工具都可以——随 Android SDK 发行的 `apksigner` 最直接，图形化打包流程和 JDK 自带的 `keytool` 加签名工具也都行。开发和内部使用自签名证书即可，免费，不需要账号或审核。

用 SDK 工具的一条完整命令序列：

```text
keytool -genkeypair -keystore debug.keystore -alias androiddebugkey ^
    -storepass android -keypass android -dname "CN=Android Debug,O=Android,C=US"
zipalign -f -P 16 4 app-unsigned.apk app-aligned.apk
apksigner sign --ks debug.keystore --ks-key-alias androiddebugkey ^
    --ks-pass pass:android --key-pass pass:android --out app-debug.apk app-aligned.apk
apksigner verify --verbose app-debug.apk
```

- 自签名证书的 `-dname` 可以随意填写，只在设备上区分签名身份时用到；换机器重签要沿用同一个 keystore，否则覆盖安装会因签名不一致被拒。
- 签名版本（v1/v2/v3）由签名工具按 `--min-sdk-version` 与 `--max-sdk-version` 决定，XIRASM 侧不需要知道，也不对这些块做任何假设。
- 签名必须在最终布局和对齐完成之后进行。改过 APK 内容就要重新对齐、重新签名。

## 安装和调试

```text
adb install -r app-debug.apk
adb shell monkey -p com.example.tool 1
adb logcat
```

排查 native 加载问题：

```text
adb logcat | findstr /i "PackageManager linker AndroidRuntime DEBUG"
```

常见原因：设备 ABI 与 APK 里的 `lib/<abi>` 不匹配、入口符号没有导出、依赖库缺失、签名无效，或者设备没有被 `adb` 识别。

## 平台符号目录

`include/os/android/` 提供平台符号目录、头文件常量和可分配的原生结构体。导入辅助函数核对每个符号的提供库、目标 ABI 和首次可用 API；结构体通过 `sizeof`、`offset_of`、字面量与 `emit.struct` 使用。

| 数据 | 规模 | 来源 |
| --- | --- | --- |
| 符号 → 库、首次可用 API、ABI、类型、版本标签 | **25 个库 / 4,405 个符号 / 4,684 条符号与库组合 / 22,956 条 ABI 记录**，API 21–35 × 5 个 ABI | NDK r27d（`Pkg.Revision = 27.3.13750724`）的 stub 库 |
| 头文件常量 | **1,168 个常量**，33 个头文件分区；保留原有大小与偏移常量 | 同一份 NDK 头文件 |
| 原生结构体 | **25 个 LP64 类型 + 25 个显式 ARM32 类型**，包含嵌套记录、union、固定数组与回调地址 | fasmg Android SDK 的结构模型，以同一份 NDK Clang 核对 |

两条使用路径，日常只用第一条：

- **常量路径（主）**：`import("os/android/imports/liblog.inc")` 之后用 `android_import_log___android_log_write`；库名被写在生成的辅助函数里。
- **查询路径（辅）**：`import("os/android/catalog.inc")` 之后按名字问目录（`android_symbol_library(syms, "__android_log_write")` 得到 `"liblog.so"`），供工具与诊断使用。

## 挂平台导入：一个 .so 两种写法

导入接口本来就是"库名 + 符号名"绑在一起的，目录把库名那一半接管了。x86-64 走 PLT，AArch64 走 GOT 槽位，**目标决定用哪个辅助函数**：

| 目标 | 辅助函数 | 调用写法 |
| --- | --- | --- |
| x86-64 | `android_import_<别名>_add_checked_mut(imports, image, names, minimum_api, android_abi_x86_64)` | `call <符号>_plt` |
| AArch64 | `android_import_<别名>_add_slots_checked_mut(imports, image, names, minimum_api, android_abi_aarch64)` | `ldr x8, <符号>` 然后 `blr x8`，调用者须保存返回地址 |

下面是一份完整可汇编的 AArch64 共享库，库名一个都没有手写：

```asm id=android-import-slots-aarch64 target=aarch64
import("format/format.inc")
import("os/android/imports/libGLESv2.inc")
import("arm/a64-macros.inc")

let image: map = format_elf64_so_aarch64(
    "libclear.so",
    list.of(format_segment(".text", format_load | format_readable | format_executable))
)
let exports: list = format_elfso_export_new()
format_elfso_export_many_mut(exports, list.of("clear_color"), ".text", 8)
let imports: list = format_elfso_import_new()
android_import_glesv2_add_slots_checked_mut(imports, image, list.of(
    android_import_glesv2_glClearColor,
    android_import_glesv2_glClear), 26, android_abi_aarch64)
format_elfso_tables_mut(image, exports, imports)
format_begin(image)
format_segment_begin(image, ".text")
clear_color:
    // 转发调用者的 s0..s3 与返回地址。
    ldr x8, glClearColor
    br x8
format_segment_end(image, ".text")
format_finish(image)
```

产物里会出现 `NEEDED [libGLESv2.so]`、两个 `U glClearColor` 与 `U glClear`，以及两条 `R_AARCH64_GLOB_DAT` —— 全部由目录给出的库名推出。

导入槽用符号名做标签，所以调用点就是"取该槽、跳过去"。两个辅助函数都往同一个导入列表里追加，因此不同库的导入可以共用一个列表。

## 常量与结构体

同一批头文件还声明了要传给平台的枚举（窗口格式、事件动作、键码）和平台回传的结构体。`defs/<头文件>.inc` 把两者都收编，命名规则是：

| 表面 | 形式 |
| --- | --- |
| 枚举成员或宏 | `android_<头文件>_<名字>` |
| 结构体大小 | `android_layout_<Struct>_size64` / `_size32` |
| 字段偏移 | `android_layout_<Struct>_<字段>_offset64` / `_offset32` |

`defs/` 保留历史布局常量。新源码导入 `structs/<头文件>.inc`，直接使用类型名。默认类型对应 AArch64 与 x86-64 的 LP64 布局；`_arm32` 对应 ARM32，不能当作 i686 类型。匿名 C 成员在类型中使用命名的嵌套容器。

```asm id=android-layout-constants target=aarch64
import("os/android/structs/native_activity.inc")
import("os/android/defs/native_window.inc")
import("os/android/structs/native_window.inc")
import("arm/a64-macros.inc")

// ANativeActivityCallbacks：十六个函数指针，按声明顺序排布。
str x2, [x1, #offset_of(ANativeActivityCallbacks, onDestroy)]

// ANativeWindow_lock 填好的缓冲区，逐字段读回。
ldr w3, [x0, #offset_of(ANativeWindow_Buffer, width)]
ldr w4, [x0, #offset_of(ANativeWindow_Buffer, height)]
ldr w5, [x0, #offset_of(ANativeWindow_Buffer, format)]

assert(android_native_window_WINDOW_FORMAT_RGBA_8888 == 1, "the legacy RGBA format")
```

`import("os/android/defs.inc")` 一次导入全部 33 个分区；日常源码只导入自己用到的头文件。

`import("os/android/structs.inc")` 导入全部原生类型；`os/android/sdk.inc` 同时导入常量、类型与目录查询。声明本身不输出字节，也不会登记动态依赖。

## 按名字查目录

工具、诊断与编辑器补全走查询路径。调用一次 `android_symbols()` 解析表，并复用返回的 map 回答多次查询：

```asm id=android-catalog-query
import("os/android/catalog.inc")

const syms: map = android_symbols()
const library: string = android_symbol_library(syms, "__android_log_write")
const api: u64 = android_symbol_min_api_for(syms, "__android_log_write", "liblog.so", android_abi_aarch64)
const now: bool = android_symbol_available_for(syms, "dlvsym", "libdl.so", 24, android_abi_aarch64)
const early: bool = android_symbol_available_for(syms, "dlvsym", "libdl.so", 21, android_abi_aarch64)
assert(library == "liblog.so", "liblog provides __android_log_write")
assert(api == 21, "__android_log_write appears in API 21")
assert(now, "dlvsym appears in API 24")
assert(!early, "dlvsym is not available in API 21")
```

`android_symbol_provider(syms, name, library, abi_bit)` 返回精确的 `api`、`kind` 和 `ver`。对应快捷查询为 `android_symbol_min_api_for`、`android_symbol_available_for`、`android_symbol_kind_for`、`android_symbol_version_for`。历史聚合查询仍可检索名称与提供库；跨 ABI 的最早 API 或版本不能用于验证目标导入。

## API 级别怎么用

每个符号在每个提供库与 ABI 下分别记录首次可用 API。只检查库首次出现的 API 会漏掉后来新增的符号；实际导入应使用上面的 checked 辅助函数。查询时也指定库和 ABI：

```asm id=android-min-api-guard
import("os/android/catalog.inc")
const syms: map = android_symbols()
assert(android_symbol_available_for(syms, "glClearColor", "libGLESv2.so", 26, android_abi_aarch64))
assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", android_abi_aarch64) == 30)
assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", android_abi_x86_64) == 29)
```

旧的双参数 `add_mut` 与 `add_slots_mut` 保留兼容，只核对库所属和对象不能走 PLT；它们无法核对调用者的 minSdk 或 ELF machine。对象导入使用 GOT，槽内是对象地址；OpenSL 的 `SL_IID_*` 对象本身还保存接口 ID 指针，读取接口 ID 时需要再解引用一次。

## 平台侧的完整链路

`tests/format/android_gl_demo/` 是一个只用 XIRASM 写成的 GLES2 渲染器：EGL 初始化、shader 编译、汇编期生成的纹理、九参数 `glTexImage2D`、`glDrawArrays` 全在里面。x86-64 与 AArch64 源码按每个符号核对 API 26 和 ABI，并用原生回调类型的 `offset_of` 访问字段。三个归档变体由 `tests/format/check_apk.py` 验收，通用包在设备上按 ABI 取对应库。

## 生成物是怎么保证正确的

| 手段 | 做什么 |
| --- | --- |
| 生成器 `tests/os/generate_android_symbols.py` | 纯 Python 解析 stub 的动态符号表与版本表；`--check` 逐字节比对，产物可复现 |
| 校验器 `tests/os/validate_android_symbols.py` | 用 LLVM 读回动态符号与版本表，逐 ABI 核对 API、符号类型与版本 |
| 生成器 `tests/os/generate_android_constants.py` | 纯 Python 解析头文件（含 `#define`、枚举、结构体布局），`--check` 可复现 |
| 校验器 `tests/os/validate_android_constants.py` | 把每个常量与偏移改写成 `_Static_assert`，交给 NDK 的 clang 按 **LP64 与 ILP32** 两模型编译 |
| 结构生成器与检查器 `tests/os/generate_android_structures.py`、`check_android_structures.py` | 从结构模型生成实际类型；核对 Clang 布局、全部字段路径和实际实例字节 |
| 检查器 `tests/os/check_android_symbols.py`、`check_android_import_reference.py` | 引用全部 4,684 个符号与库组合；在真实汇编器中核对精确查询、对象与函数重定位，以及无效 API/ABI 导入诊断 |
| 检查器 `tests/os/check_android_docs.py` | 本文与目录 README 里的**每个示例都汇编一遍**，文档不能与语言脱节 |
| 设备侧 `tests/os/check_catalog_vs_device.py` | 把目标设备自己的 `.so` 取出来，与其真实导出比对 |
| 设备侧 `tests/os/make_android_smoke.py` | 生成"每个库抽样导入"的冒烟 `.so`：装载即验证几百条映射 |

## 这套目录的限度

- **来源是 NDK stub 的链接期接口**。具体设备可能导出更多或更少的名称；目录查询通过不等于已经在设备上运行过。使用设备检查器核对所部署的系统。
- **GOT 导入在装载时解析**。即使不调用，设备缺少一个已登记的符号也会使库无法装载。
- **同名符号可以属于多个库**。精确查询指定提供库；需要不同本地槽名时，使用 `import_mut` 或 `add_pairs_checked_mut` 显式取别名。
- **GNU 版本标签是目录元数据**。当前 ELF 导入按未版本化名称解析；TLS 重定位与 IFUNC resolver 不由这套辅助函数声明。
- **C++ 头未收编**：9 个 binder/aidl 头只有 C++ 侧能用，不在 `defs/` 里。
- **常量未带 `__INTRODUCED_IN` 可用性**：目前只有符号轴有 min API；常量轴以后可以加。

## 再生成

```powershell
$ndk = "<android-ndk-r27d>"
python tests/os/generate_android_symbols.py  --ndk $ndk --check
python tests/os/generate_android_constants.py --ndk $ndk --check
python tests/os/generate_android_structures.py --check
python tests/os/validate_android_symbols.py  --ndk $ndk
python tests/os/validate_android_constants.py --ndk $ndk
python tests/os/check_android_symbols.py --assembler zig-out/bin/xirasm.exe
python tests/os/check_android_structures.py --assembler zig-out/bin/xirasm.exe --ndk $ndk
python tests/os/check_android_import_reference.py --assembler zig-out/bin/xirasm.exe
python tests/os/check_android_docs.py    --xirasm zig-out/bin/xirasm.exe
```

升级 NDK 时先跑 `--check` 看差异，再重新生成并跑两遍校验器；`manifest.json` 与 `defs-manifest.json` 记录版本、计数与所用文件的摘要。

## 使用原生结构体

平台回传的结构体通过真实类型访问，字段偏移由类型计算：

```asm id=android-struct-offsets target=aarch64
import("os/android/structs/native_window.inc")
import("arm/a64-macros.inc")

// ANativeWindow_lock 填好的缓冲区：宽、高、行距、像素格式、像素指针
ldr w3, [x0, #offset_of(ANativeWindow_Buffer, width)]
ldr w4, [x0, #offset_of(ANativeWindow_Buffer, height)]
ldr w5, [x0, #offset_of(ANativeWindow_Buffer, stride)]
ldr w6, [x0, #offset_of(ANativeWindow_Buffer, format)]
ldr x7, [x0, #offset_of(ANativeWindow_Buffer, bits)]
```

指针与回调是 LP64 下的 `u64`、ARM32 下的 `u32` 地址。C `float` 使用 `f32`。固定数组使用包含 `element0`、`element1` 等成员的辅助结构；匿名 union 使用命名容器，例如 `ASensorEvent.payload.values.acceleration.components.cartesian.x`。嵌套偏移使用声明中的完整路径。

### 分配与初始化

结构体字面量能实际初始化数据；`sizeof` 包含 C 记录的内部与尾部填充。写入地址的对齐仍由调用者安排，64 位调用保持 16 字节栈对齐。

```asm id=android-struct-size target=aarch64
import("os/android/structs/log.inc")
import("os/android/structs/native_window.inc")
const message: __android_log_message = __android_log_message {
    struct_size: sizeof(__android_log_message),
    priority: 4
}
const buffer: ANativeWindow_Buffer = ANativeWindow_Buffer {
    width: 640,
    height: 480,
    stride: 640,
    format: 1,
    reserved: android_ANativeWindow_Buffer_reserved { }
}
assert(sizeof(__android_log_message) == 48)
assert(sizeof(__android_log_message_arm32) == 28)
assert(sizeof(ANativeWindow_Buffer) == 48)
assert(sizeof(ANativeWindow_Buffer_arm32) == 44)
emit.struct(message)
emit.struct(buffer)
```

上例只演示记录初始化；其中字符串与指针仍为零，调用平台函数前须赋有效地址。标量默认值为零，嵌套结构须给出对应字面量。`pack` 可得到同样的字节，供格式容器或文件写入使用。

## 能力边界

已经内建并经过实机验证：

| 能力 | 说明 |
| --- | --- |
| ZIP 容器与 CRC-32 | 含中央目录与 EOCD 的完整性自检 |
| 二进制清单（AXML） | 固定模板清单与资源表清单两条路径 |
| `resources.arsc` | 字符串、文件、整数、布尔、引用五类值，默认配置加密度与语言限定符，字符串值支持任意文字含补充平面 |
| 密度图标 | 五档密度，与资源表成对登记 |
| 启动 DEX | 112 字节 `hasCode=false` 占位 |
| 多 ABI native 库收编 | 按 ABI 目录写入并按 16 KiB 对齐 |
| 按目录扫描资源 | `res/` 树即资源坐标 |
| 两级对齐 | 4 字节与 16 KiB |
| 框架资源 ID 与主题 | `format/android/generated/framework_ids.toml`，公开资源 17 个类型、3037 条 |
| 条目压缩 | 逐条选择 DEFLATE，确定性输出 |
| 平台符号目录 | 25 个库、4,684 个符号与库组合，逐 ABI 存储 API、类型与版本 |
| 头文件常量与原生类型 | 1,168 个常量、25 个 LP64 类型与 25 个 ARM32 类型，可初始化并输出记录 |

清单与资源表在开发中与 Android 自带资源编译器的输出**逐字节比对过**（同输入同字节，四组夹具分别 556、1360、1172、704 字节）；19.9 MB 的演示 APK 回归同样逐字节一致。仓库内的验收脚本用 `aapt2` 与 `zipalign` 把这些产物逐项读回来复核。

不在覆盖范围内：

- **签名**：由外部工具完成，引擎不做密钥与证书运算。任何能签 APK 的工具都可以，自签名证书免费。
- **Java/Kotlin 代码**：不编译 DEX 业务代码，应用必须是 `hasCode=false` 的纯原生程序。
- **`styleable` 与 `attr` 表的编译**：框架资源的 **ID 表**已经收录（见上文），但把自定义 XML 里的样式和属性声明编译成资源表不在范围内。
- **多包资源**：只处理应用自己的包 ID。
- **资源目录限定符**：只编译密度与语言两个配置轴。每个目录最多一个密度加一个语言，其余限定符（`-land`、`-night`、`-sw600dp` 等）在扫描时报错而不是被静默忽略；API 版本限定符（`-v4`）被接受但不写进配置。

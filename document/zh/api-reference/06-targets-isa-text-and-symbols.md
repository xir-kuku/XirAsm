# 第 6 章：目标平台、处理器指令与符号

## 语法摘要

| 形式 | 语法 | 结果 |
| --- | --- | --- |
| 目标平台宽度 | `target.bits` | 返回当前 x86 指令模式或 RISC-V XLEN。 |
| 目标平台系列条件 | `target.isa == .name` | 在 `if` 中检查当前指令集系列。 |
| x86 模式 | `x86.use16()`、`x86.use32()`、`x86.use64()` | 选择 x86 及其指令模式。 |
| RISC-V 模式 | `riscv.use32()`、`riscv.use64()` | 选择 RISC-V 及其 XLEN。 |
| SPIR-V 模块 | `spv.use()` | 选择 SPIR-V 1.6 完整模块输出。 |
| 动态处理器指令 | `isa(text)` | 根据文本值追加一条指令。 |
| 逻辑原点 | `origin(address)` | 设置当前输出区域的基地址。 |
| 当前位置 | `here()` | 返回当前逻辑地址。 |
| 动态标号 | `label.define(name)` | 根据文本值定义标号。 |
| 标号地址 | `label_addr(name)` | 返回标号或绝对符号的地址。 |

## 目标平台查询

`target.bits` 是整数表达式。对于 x86，它表示当前指令模式；对于 RISC-V，它表示当前 XLEN：

```asm
// 仅在当前目标平台系列为 x86 时检查并写出模式位数。
if target.isa == .x86_64 {
    assert(target.bits == 64)
    emit.u8(target.bits)
}
```

SPIR-V 没有适用于整个目标平台的整数位宽，因此该目标平台不能使用 `target.bits`。

`target.isa` 是目标平台条件形式，而不是通用值表达式。请在源码 `if` 中把它放在 `==` 或 `!=` 左侧：

```text
if target.isa == .x86_64 { ... }
if target.isa != .riscv64 { ... }
if target.isa == .spirv { ... }
```

可用的系列字面量是 `.x86_64`、`.riscv64` 和 `.spirv`。系列名称不会随宽度变化：x86 的 16 位、32 位和 64 位模式都使用 `.x86_64`，RISC-V 的 XLEN 32 和 XLEN 64 都使用 `.riscv64`。

## 选择指令模式

模式过程会选择后续处理器指令片段保存的目标平台。已经记录的指令仍然保留先前的目标平台。

| 调用 | 后续处理器指令 |
| --- | --- |
| `x86.use16()` | x86 16 位模式 |
| `x86.use32()` | x86 32 位模式 |
| `x86.use64()` | x86-64 模式 |
| `riscv.use32()` | XLEN 为 32 的 RISC-V |
| `riscv.use64()` | XLEN 为 64 的 RISC-V |
| `spv.use()` | SPIR-V 1.6 模块文本 |

```asm
// 依次记录使用 16 位、32 位和 64 位模式的 x86 指令。
x86.use16()
isa("mov ax, 0x1234")

x86.use32()
isa("mov eax, 0x12345678")

x86.use64()
isa("mov rax, 0x0102030405060708")

// 随后切换到两种 RISC-V XLEN，并分别记录一条指令。
riscv.use32()
isa("addi x1, x0, 1")

riscv.use64()
isa("addi x2, x0, 2")
```

这些过程是普通源码操作。它们不会改变早先指令的含义，也不是收尾处理操作。

`spv.use()` 开始一个完整的 SPIR-V 模块。SPIR-V 指令使用标准 `Op*` 拼写，结果 ID 可写数字也可写名字：

```asm
spv.use()

OpCapability Shader
OpMemoryModel Logical GLSL450
%1 = OpTypeVoid
```

整个输出只能包含同一 section、同一版本的 SPIR-V 指令片段。混入其他 ISA、数据写出、预留或对齐操作都会被拒绝。

`IdResult` 可以写成字面数字，也可以写成名字。数字保持写下的号不变。名字从 1 开始按**首次出现**顺序编号，并跳过字面数字已占用的号；因此 `OpEntryPoint GLCompute %main "main"` 这类前向引用能解析，尽管定义 `%main` 的 `OpFunction` 行在后面。模块头部的上界把两者都算进去。整个模块里从未定义的名字、以及定义了两次的名字，都会带着出错行号被拒绝；名字最终拿到几号不会单独回报，请按首次出现规则推算，或直接看产物。命令行的 `--isa spv` 和 `--isa spirv`（旧拼写 `--target` 同样可用）都选择 SPIR-V 1.6。

## 动态处理器指令

`isa(text)` 只接受一个非空的单行文本值：

```asm
// 编译期绑定提供需要追加的单行处理器指令。
const instruction = "nop"
isa(instruction)
```

指令已经固定写在源码中时，应使用普通处理器指令行；编译期逻辑生成指令文本时，才使用 `isa`。汇编器会按照调用位置当前生效的目标平台解析并编码这条指令。

普通处理器指令不使用编译期语言的语句结束符。不要在普通指令行末添加 `;`，也不要把它放入传给 `isa` 的字符串：

```text
nop;          // 无效的处理器指令文本。
isa("nop;")   // 无效的处理器指令文本。
```

空字符串、其他类型的值、包含换行符的文本或以分号结尾的文本都无效。

## 逻辑原点与当前位置

`origin(address)` 会改变当前输出区域的逻辑基地址。它不会写出字节、插入填充，也不会改变文件中的物理位置。

`here()` 返回：

```text
active region origin + current logical offset
```

```asm
// 设置逻辑原点，再验证写出两个字节后的当前位置和标号地址。
origin(0x4000)

header:
emit.u16(0x1234)

assert(here() == 0x4002)
assert(label_addr(header) == 0x4000)
```

请在定义依赖新基地址的地址之前调用 `origin`。普通源码和后期布局都可以调用它，但 `defer` 中不能调用。

## 静态标号与动态标号

源码标号定义固定名称：

```text
entry:
```

`label.define(name)` 根据文本值定义同一种锚定标号：

```asm
// 在新的逻辑原点定义动态标号，并验证它锚定在写出字节之前。
origin(0x5000)

const generated_name = "generated_entry"
label.define(generated_name)
emit.u8(0xaa)

assert(label_addr(generated_name) == 0x5000)
```

生成的名称必须是有效的标号标识符。`label.define` 是普通源码操作，并且要求已经打开输出区域。

`label_addr` 既可以接受直接书写的标号名称，也可以接受文本表达式：

```text
label_addr(entry)
label_addr("entry")
label_addr(generated_name)
```

未知符号会被拒绝。值绑定不是标号，不能通过 `label_addr` 获得地址。

## 处理器指令编码期间的地址稳定性

数据写出、预留和对齐操作会立即更新普通源码游标。处理器指令则先被记录，稍后再编码。处理器指令之后的标号会锚定到对应源码位置，并在指令编码和分支长度调整完成后获得最终偏移。

如果标号依赖前面的处理器指令长度，不要把普通 `label_addr` 的结果直接写死到数据中。应先写出固定宽度的占位值，再在 `defer` 中回填：

```asm
// 先为最终地址预留固定宽度字段。
origin(0x4000)

target_field:
emit.u64(0)

    jmp done
done:
    ret

// 指令长度稳定后，把 done 的最终逻辑地址写回占位字段。
defer {
    store.u64(target_field, label_addr(done))
}
```

执行 `defer` 时，布局和指令长度都已经稳定，因此 `label_addr(done)` 是最终逻辑地址。这个规则也适用于位于处理器指令之后的动态标号。

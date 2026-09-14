# 第 8 章：目标、指令与标号

编译期语言决定生成什么；汇编器模型决定生成的指令和数据放在哪里、由哪个指令集编码，以及符号引用如何变成具体值。

## 目标

每条指令都按当前目标编码。目标包含指令集系列，以及该指令集需要的位宽。

命令行选项给出起始目标：

```text
xirasm program.xir --isa x86-64
xirasm program.xir --isa x86
xirasm program.xir --isa rv64
xirasm program.xir --isa rv32
xirasm module.spvasm --isa spv
```

汇编单个文件不需要选项：`xirasm program.xir` 在源文件旁输出纯二进制 `program.bin`，`-o` 只是覆盖这个路径。`--isa`（旧拼写 `--target`）是**默认值**，只作用于自己没有选择指令集的源码；源码里写了 `x86.use32()`，或 import 了 A64 宏库，结果以源码为准。

没有显式选择时，XIRASM 默认使用 64 位 x86。示例、可复用 include 和依赖特定位宽的代码都建议在源文件里写明：

```asm id=08-use64
// 明确选择后续指令使用的 64 位 x86 编码。
x86.use64()

entry:
    // 生成一个返回零的最小指令序列。
    xor eax, eax
    ret
```

模式调用只影响它之后的指令，不回改已经写出的指令。

## 模式调用

源文件内用这些接口切换模式：

| 接口              | 后续指令按什么模式编码 |
| ----------------- | ---------------------- |
| `x86.use16()`   | 16 位 x86              |
| `x86.use32()`   | 32 位 x86              |
| `x86.use64()`   | 64 位 x86              |
| `riscv.use32()` | 32 位 RISC-V           |
| `riscv.use64()` | 64 位 RISC-V           |
| `spv.use()`     | SPIR-V 1.6 模块        |

同一个源文件里可以切换：

```asm id=08-use16
// 第一条指令使用 16 位 x86 编码。
x86.use16()
mov ax, 1

// 第二条指令使用 32 位 x86 编码。
x86.use32()
mov eax, 2

// 第三条指令使用 64 位 x86 编码。
x86.use64()
mov rax, 3
```

三条指令分别按 16 位、32 位和 64 位 x86 编码。模式调用不会回头修改前面的指令。

上表只列原生目标。AArch64 不在其中：x86、RISC-V、SPIR-V 由后端编码器直接支持，而 AArch64 指令是在宏库 `arm/a64-macros.inc` 里用宏实现的，属于可执行格式扩展那一层，不是原生 API。要写 A64 指令，导入该库之后按 AArch64 汇编文本直接写即可（见第 5 章《AArch64 指令宏库》）。

选择编码模式不等于让生成的程序在运行时切换处理器模式：引导映像、内核、固件组件和混合模式程序仍要自己安排运行时模式转换。RISC-V 的宽度选择遵循同样的源码顺序规则：

```asm id=08-use64-2
// 选择 XLEN 为 64 位的 RISC-V 模式。
riscv.use64()

// 两条指令都会按照当前 64 位 RISC-V 目标编码。
addi x1, x0, 1
addi x0, x0, 0
```

x86 的模式概念不适用于 RISC-V 或 SPIR-V。XIRASM 分别保存各 ISA 的目标设置，不会把所有 ISA 压成一个通用的 `mode_bits` 值。

SPIR-V 不是逐条独立编码的机器指令流，而是一个完整的逻辑模块。用 `spv.use()` 选择 SPIR-V 1.6，然后直接书写标准 `Op*` 指令和结果 ID（数字或名字都可以）：

```asm id=08-use
// SPIR-V 按模块写：这里是模块头部和类型声明，不是逐条机器指令。
spv.use()

OpCapability Shader
OpMemoryModel Logical GLSL450
%1 = OpTypeVoid
```

命令行可用 `--isa spv` 或 `--isa spirv`，两者都选择 SPIR-V 1.6。同一个 SPIR-V 输出只能包含同一个 section、同一个模块版本的 SPIR-V 指令行，不能混入 x86/RISC-V 指令，也不能混入数据写出、预留或对齐片段。

结果 ID 写成数字或名字都行：

- 数字 ID 保持原样，写第几号就是第几号，一个都不重编号；
- 名字按**首次出现**的顺序从 1 开始编号，并跳过数字 ID 已经占用的号。

按首次出现编号，前向引用才成立：`OpEntryPoint GLCompute %main "main"` 可以先写 `%main`，定义它的 `OpFunction` 行在后面。模块头部的 ID 上界把两者一起算进去。整个模块里从未定义过的名字、以及定义了两次的名字，都会带着行号报错，不会静默分配一个号。

## 查询当前目标

编译期控制流可以检查当前目标：

```asm id=08-use64-3
// 选择 x86 后端和 64 位模式。
x86.use64()

// 这个条件在汇编期间判断，不会生成运行时分支。
if target.isa == .x86_64 {
    assert(target.bits == 64)
    mov eax, 1
}
```

可查询的目标系列值：

| 值           | 目标系列                 |
| ------------ | ------------------------ |
| `.x86_64`  | x86（use16/use32/use64） |
| `.riscv64` | RISC-V（xlen 32/64）     |
| `.spirv`   | SPIR-V                   |

目标系列名称标识后端系列，不报告当前指令宽度。例如 `x86.use32()` 之后 `target.isa == .x86_64` 仍然成立，但 `target.bits == 32`。

判定位宽用 `target.bits`；RISC-V 条件也可以使用 `target.xlen`：

```asm id=08-use32
// 选择 XLEN 为 32 位的 RISC-V 模式。
riscv.use32()

// 同时检查后端系列与 XLEN。
if target.isa == .riscv64 {
    assert(target.xlen == 32)
    addi x1, x0, 1
}
```

## 书写指令

指令使用所选指令集的常规汇编语法：

```asm id=08-use64-4
// 选择 64 位 x86，然后直接编写指令。
x86.use64()

entry:
    mov rax, 1
    add rax, 2
    ret
```

一行由助记符和操作数组成，操作数之间用空格分隔。方括号、圆括号或花括号里的逗号属于嵌套操作数的一部分，不会把指令错误地拆开。

编译期调用按编译期语法写，处理器指令按汇编语法写。指令行尾不写分号——那是错误：

```asm id=08-use64-5
// 这两行是编译期接口调用。
x86.use64()
emit.u8(0x90)

// 这一行是处理器指令，末尾同样不写分号。
nop
```

XIRASM 把指令内容和当前目标一起交给对应后端编码；标号、布局、输出区域和地址回填仍由前端负责。

SPIR-V 是例外：汇编器按源码顺序收集整个模块的指令，再一次性交给后端，使模块头、ID 上界、类型上下文和扩展指令集保持一致。

## 在指令中使用编译期值

编译期常量可以直接出现在指令操作数中：

```asm id=08-use64-6
// 在汇编期间计算立即数。
x86.use64()
const initial_value: u32 = 40 + 2

entry:
    // 编译期常量会直接成为指令操作数。
    mov eax, initial_value
    ret
```

标号也可以在指令中参与运算：

```asm id=08-use64-7
// 把逻辑起始地址设置为 0x1000。
x86.use64()
origin(0x1000)

target:
    // 操作数表示标号地址再加四。
    mov rax, target + 4
    ret
```

距离还没确定的跳转按 **near**（近跳）形式编码，所以即使两条指令相邻，`jmp target` 也是五字节。距离已知时写明要哪种形式：

```asm id=08-use64-8
x86.use64()

loop:
    nop
    jmp short loop      // short 选两字节形式，所以是 eb fd
```

`short` 选两字节形式，`near` 选宽形式，与普通 x86 汇编一致。

汇编器以符号形式保留整个表达式，等地址确定后再求值。只有确实需要动态生成指令时，才拼接指令字符串。

## 静态标号

标号写在名字后面加冒号：

```asm id=08-use64-9
// 使用普通标号表达控制流。
x86.use64()

entry:
    mov eax, 1
    jmp done

done:
    ret
```

标号不产生任何字节，只把名字绑定到当前位置。

标号可以先使用后定义：

```asm id=08-use64-10
// finished 在跳转指令之后定义，仍然可以提前引用。
x86.use64()

entry:
    jmp short finished
    mov eax, 1

finished:
    ret
```

前向引用的长度选择属于指令编码约束。源码可以显式写出 `short` 或 `near`，也可以让布局和后端在约束允许时处理符号位移；不要在源码中手动计算跳转偏移。

## 符号引用与地址回填

引用标号的指令，有时要等布局确定后才能知道最终位移。XIRASM 的处理顺序是：

1. 源文件定义标号并生成指令片段。
2. 后端先编码指令，把依赖标号的字段暂时留下。
3. 布局器给标号和片段分配最终地址。
4. 地址确定后计算标号表达式，并把结果写回指令字段。

前向引用不需要手动计算地址：

```asm id=08-use64-11
// 跳转目标稍后定义，位移由汇编器计算。
x86.use64()

entry:
    jmp target
    nop

target:
    ret
```

只要源文件描述的是指令及其标号表达式，而不是手动填写的偏移，前面的指令改变长度就不会让这里失效。

## 动态指令文本与动态标号

编译期需要计算名字时使用动态指令和标号：

```asm id=08-join
// 根据多个固定部分组成动态标号名称。
const done: string = sym.join("generated_", "done")

// 动态指令和动态标号仍然进入正常的汇编流程。
isa(sym.join("jmp ", done))
label.define(done)
isa("ret")
```

上面那段等价于直接写出来：

```asm id=08
// 这是上一个动态示例所对应的普通静态写法。
jmp generated_done
generated_done:
ret
```

`isa(text)` 把指令文本交给当前目标编码，`label.define(name)` 在当前位置创建标号。命名用 `sym.join`，需要唯一名称时用 `sym.unique`。

动态标号只在确实需要时使用，不要用它替代 `loop:`、`done:` 这样的静态写法。

## 读取标号地址

`label_addr(label_or_name)` 返回标号的逻辑地址：

```asm id=08-use64-12
// 定义一个标号，并把它的逻辑地址写入输出。
x86.use64()

entry:
    ret

dq(label_addr(entry))
```

指令内部的标号引用通过地址计算完成，不需要手动查询。`label_addr()` 用于在数据里写入标号地址这类场景。

布局未稳定时，在 `defer` 里延迟查询（见第 12 章）。需要重定位时用格式接口提供的重定位声明，不要手动填偏移。

[返回目录](../language.md)

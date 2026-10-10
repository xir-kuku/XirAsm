# 第 9 章：数据与二进制布局

汇编指令不是输出字节的唯一来源。文件头、查找表、消息字面量、预留空间，都需要明确的二进制布局。

为什么要自己布局，而不是交给外部链接器去拼二进制？

因为 XIRASM 一开始就被设计成既是编译器、又是解释器，靠这个能力它还能当链接器——一个工具做所有事。安卓 APK 不必依赖外部工具就能打包、任意可执行格式都能生成，原因之一就在这里：所有能力都源自对二进制的控制能力，也就是布局。

布局本来是高级静态编译器和链接器干的事。传统的 NASM 那类汇编器只能生成中间目标文件，没有成熟的可执行格式层，还得依赖 GNU 工具链；XIRASM 不需要这些。写 Windows、Linux、macOS 都行，x86、RISC-V、AArch64 也都行。

XIRASM 在这一层提供两种写法：直接写数据的调用，以及定义结构体与联合体的类型系统。几行数据直接用写接口就够了；会被反复使用的记录格式，定义成结构体。

## 写出数据

数据从当前位置开始追加：

```asm id=09-u8 bytes=113322776655440807060504030201
// 按 1、2、4、8 字节的宽度依次写出整数。
emit.u8(0x11)
emit.u16(0x2233)
emit.u32(0x44556677)
emit.u64(0x0102030405060708)
```

按小端序写：

```text
11
33 22
77 66 55 44
08 07 06 05 04 03 02 01
```

值超出目标宽度会报错，不会静默截断；需要更宽的字段时，换一个更宽的写出接口。

简写形式把宽度写在助记符上：

| 简写     | 宽度    | 用途                         |
| -------- | ------- | ---------------------------- |
| -------  | ------- | ---------------------------- |
| `db`   | 1 字节  | 字节值、字符串和`bytes` 值 |
| `dw`   | 2 字节  | 小端整数                     |
| `dd`   | 4 字节  | 小端整数                     |
| `dp`   | 6 字节  | 小端整数                     |
| `dq`   | 8 字节  | 小端整数                     |
| `dt`   | 10 字节 | 从`u64` 零扩展的小端整数   |
| `ddq`  | 16 字节 | 从`u64` 零扩展的小端整数   |
| `dqq`  | 32 字节 | 从`u64` 零扩展的小端整数   |
| `ddqq` | 64 字节 | 从`u64` 零扩展的小端整数   |

例如：

```asm id=09-db
// 使用简写按固定宽度写出同一组小端整数。
db(0x41)
dw(0x1122)
dd(0x33445566)
dq(0x0102030405060708)
```

简写接受多个参数。`db` 还能接字符串和字节序列，其他简写只接整数。1、2、4、6、8 字节写出会检查范围；10、16、32、64 字节写出从 `u64` 零扩展。需要精确位模式时用 `emit.bytes`。`dt` 只是 10 字节整数写出形式，不表示 x87 f80 浮点格式。

## 浮点值

```asm id=09-f32
// 带小数点的字面量是 f64；窄化成 f32 要显式写 f32(...)。
const scale: f64 = 1.5
const compact: f32 = f32(scale)

emit.f32(compact)       // 这里写出：00 00 c0 3f
emit.f64(scale * 2.0)   // 这里写出：00 00 00 00 00 00 08 40
```

`emit.f32` 和 `emit.f64` 写出 IEEE-754 binary32 / binary64。实参类型必须精确匹配：`emit.f32` 接受 `f32`，`emit.f64` 接受 `f64`。溢出、NaN 和 Infinity 都会报错；有限下溢和有符号零按 IEEE-754 位模式保留。

## 字符串与字节序列

一次 `db` 调用可以同时组合字节值、字符串和 `bytes` 值：

```asm id=09 bytes=4142434400
// suffix 保存需要原样接在文本之后的两个字节。
const suffix: bytes = b"CD"

// 依次写出字节 A、字符串 B、字节序列 CD 和显式终止零。
db(0x41, "B", suffix, 0)
```

输出：

```text
41 42 43 44 00
```

字符串和字节序列原样复制，XIRASM 不自动加 NUL——要终止符就自己写。

`emit.bytes(value)` 写出字符串或 `bytes` 值：

```asm id=09-from-hex
// 从十六进制文本构造精确的四字节签名。
const signature: bytes = bytes.from_hex("7f454c46")

// 先写出二进制签名，再直接写出四个文本字节。
emit.bytes(signature)
emit.bytes("DATA")
```

要写出的是一段精确的二进制内容，用 `bytes`；要写出的是一段文本，用字符串。

## 预留空间

`reserve(count)` 让输出位置前进指定的字节数：

```asm id=09-db-2 bytes=eb0000fe
// 在两个已初始化字节之间预留两个字节。
db(0xeb)
reserve(2)
db(0xfe)
```

在普通 flat binary 输出中，这会写出：

```text
eb 00 00 fe
```

预留简写把数量乘以元素宽度：

|                 |                |
| --------------- | -------------- |
| 简写            | 预留字节数     |
| -----------     | ------------   |
| `rb(count)`   | `count`      |
| `rw(count)`   | `count * 2`  |
| `rd(count)`   | `count * 4`  |
| `rp(count)`   | `count * 6`  |
| `rq(count)`   | `count * 8`  |
| `rt(count)`   | `count * 10` |
| `rdq(count)`  | `count * 16` |
| `rqq(count)`  | `count * 32` |
| `rdqq(count)` | `count * 64` |

```asm id=09-rb
// 预留两个字节，写出 aa，再预留两个字节并写出 bb。
rb(2)
db(0xaa)
rw(1)
db(0xbb)
```

这会依次写出两个零字节、`aa`、另外两个零字节和 `bb`。

预留表达的是未使用的空间，不是已初始化内容。后面还有已初始化的输出时，预留范围会在 flat binary 中成为真实的零填充间隙；连续的预留空间位于末尾时，可能只增加逻辑大小而不占用 raw 文件字节。第 11 章用 FOA 和尾部 reserve 解释这一区别。

## 填充与对齐

`pad(count, fill)` 写出 count 个重复字节：

```asm id=09-db-3 bytes=01aaaaaa02
// 在 01 与 02 之间写出三个 aa 填充字节。
db(1)
pad(3, 0xaa)
db(2)
```

结果为：

```text
01 aa aa aa 02
```

填充值实参可以省略，默认是零：

```asm id=09-pad
// 使用默认填充值写出四个零字节。
pad(4)
```

`pad_to(position, fill)` 持续写出填充字节，直到当前输出位置达到指定位置：

```asm id=09-db-4 bytes=11229090909033
// 当前位置为 2；用 90 填充到位置 6，再写出 33。
db(0x11, 0x22)
pad_to(6, 0x90)
db(0x33)
```

输出：

```text
11 22 90 90 90 90 33
```

指定位置不能位于当前输出位置之前。

`align(boundary, fill)` 让输出位置前进到该边界的下一个整数倍：

```asm id=09-db-5
// 三个初始字节之后，用 cc 补齐到 8 字节边界。
db(0x11, 0x22, 0x33)
align(8, 0xcc)
db(0x44)
```

这会在 `44` 之前写出五个 `cc` 字节。填充值实参默认也是零。

对齐边界必须是非零的二次幂：1、2、4、16、4096 有效，3 或 24 会被拒绝。

四种调用各自的用法：

| 需求                   | 使用                                                                              |
| ---------------------- | --------------------------------------------------------------------------------- |
| 已知大小的未初始化空间 | `reserve` 或 `rb`/`rw`/`rd`/`rp`/`rq`/`rt`/`rdq`/`rqq`/`rdqq` |
| 精确数量的填充字节     | `pad`                                                                           |
| 到达已知输出位置       | `pad_to`                                                                        |
| 到达下一个对齐位置     | `align`                                                                         |

## 声明结构体

结构体为一组顺序排列的字段指定名称和类型：

```asm id=09-2
// 自然布局会按字段类型的对齐要求安排偏移。
struct NaturalHeader {
    tag: u8
    size: u32
}
```

这是自然对齐：`tag` 从偏移 0 开始，`u32` 要求 4 字节对齐，所以 `size` 从偏移 4 开始，总共 8 字节。

```text
偏移 0：tag
偏移 1：填充
偏移 2：填充
偏移 3：填充
偏移 4：size
偏移 5：size
偏移 6：size
偏移 7：size
```

自然布局对齐每个字段，并把最终大小向上取整到结构体的对齐要求，适合布局应遵循各字段对齐要求的内存记录。

需要精确的文件布局时，声明紧凑结构体：

```asm id=09-3
// packed 禁止在字段之间和结构体末尾自动插入填充。
packed struct FileHeader {
    tag: u8
    size: u32
}
```

`FileHeader` 占五个字节：`size` 从偏移 1 开始，紧接在 `tag` 之后，末尾也没有填充。

紧凑布局移除内部和尾部填充，但类型本身的对齐要求不变：紧凑结构体仍然要对齐到它最大字段的宽度。

这在外层是自然布局时看得出来：

```asm id=09-packed
packed struct Inner {
    a: u8
    b: u64
}

struct Outer {
    tag: u8
    inner: Inner
    tail: u8
}

assert(sizeof(Inner) == 9)            // 紧凑：中间和末尾都没有填充
assert(sizeof(Outer) == 24)
assert(offset_of(Outer, inner) == 8)  // Inner 要求 8 字节对齐，所以跳过 7 字节
assert(offset_of(Outer, tail) == 17)
```

`Inner` 内部没有填充，但它含有 `u64`，所以它自己要求 8 字节对齐。`Outer` 是自然布局，于是把 `inner` 放到偏移 8，末尾再补到 24。

文件头、协议记录、指令元数据和其他由外部规范规定的字节布局，使用紧凑布局；运行时内存记录使用自然布局。

## 字段默认值与结构体字面量

结构体的整数与浮点字段可以提供编译期默认值：

```asm id=09-4
// magic 和 flags 提供默认值，size 由每个实例显式指定。
packed struct Header {
    magic: u16 = 0x5a4d
    flags: u16 = 1
    size: u32
}

// 字面量只覆盖 size，其余字段沿用声明中的默认值。
const header: Header = Header {
    size: 0x40
}

// 通过普通字段访问读取需要写出的成员。
emit.u16(header.magic)
emit.u32(header.size)
```

这个字面量提供了 `size`，`magic` 和 `flags` 使用默认值。字面量中的字段按名称匹配，不按源码中的排列顺序匹配。

每个省略的字段都必须有默认值。未知字段、重复字段和值类型不正确的字段都会导致源码错误。

联合体字段不能声明默认值；联合体值必须始终显式选择、且只选择一个当前字段。

二进制字段支持 `f32` 和 `f64`，自然对齐分别为 4 与 8 字节。字段值与默认值必须匹配声明的宽度；用 `f32(...)` 显式缩窄。打包保留小端 IEEE-754 位模式。

```asm id=float-fields bytes=0000c03f00000000000000c0
packed struct FloatingPair {
    x: f32 = f32(1.5)
    y: f64 = -2.0
}
const pair: FloatingPair = FloatingPair { }
assert(sizeof(FloatingPair) == 12)
assert(offset_of(FloatingPair, y) == 4)
emit.struct(pair)
```

字段用普通的字段访问语法读取，如上面两个写出调用。字段访问是从**值**上读字段，所以先把字面量写进绑定，再从绑定读字段：

```asm id=09-struct
struct Pair {
    left: u32
    right: u32
}

// 字段要从值上读，所以先绑到名字上，再取字段。
const pair: Pair = Pair { left: 1, right: 2 }

emit.u8(pair.left)      // 这里写出：01
```

`Pair { left: 1, right: 2 }.left` 这种直接写在字面量上的字段访问不被接受。

复合值存在于汇编期间，仅仅声明它并不会自动写入输出内容。

## 测量布局

`sizeof(Type)` 返回二进制类型的完整大小：

```asm id=09-5
// 自然布局需要为 u32 字段和结构体末尾保留对齐空间。
struct NaturalHeader {
    tag: u8
    size: u32
}

// 紧凑布局保持字段连续排列。
packed struct PackedHeader {
    tag: u8
    size: u32
}

// 同时验证两种布局的总大小和关键字段偏移。
assert(sizeof(NaturalHeader) == 8)
assert(sizeof(PackedHeader) == 5)
assert(offset_of(NaturalHeader, tag) == 0)
assert(offset_of(NaturalHeader, size) == 4)
assert(offset_of(PackedHeader, size) == 1)
```

`offset_of(Type, field)` 返回字段偏移。两者都是编译期表达式，可以用在指令、写出字段、断言和其他布局计算里：

```asm id=09-use64
// 选择 64 位 x86 指令编码。
x86.use64()

// 两个 64 位寄存器槽位组成连续的保存区。
packed struct SaveArea {
    rax: u64
    rcx: u64
}

// 根据结构体大小调整栈指针，避免硬编码保存区字节数。
sub rsp, sizeof(SaveArea)
```

使用符号化的布局计算，可以避免新增字段或更改类型后，源码其他位置仍残留过期的硬编码大小。

## 在 x86-64 栈上使用结构体布局

复合类型是汇编期的布局描述。x86 没有把整个结构体值一次性压栈的指令，正确做法是先在栈上分配记录空间，再把 `offset_of` 用于普通内存操作数：

```asm id=09-use64-2
x86.use64()

// tag 占 1 字节，value 要对齐到 4，所以中间补 3 字节，尾部再补 2 字节。
struct StackFrame {
    tag: u8,
    value: u32,
    tail: u16,
}

assert(sizeof(StackFrame) == 12)
assert(offset_of(StackFrame, value) == 4)
assert(offset_of(StackFrame, tail) == 8)

// 偏移由 offset_of 算，不要在源码里写死数字。
sub rsp, sizeof(StackFrame)
mov dword [rsp + offset_of(StackFrame, value)], 0x44332211
mov eax, [rsp + offset_of(StackFrame, value)]
mov word [rsp + offset_of(StackFrame, tail)], 0x6655
add rsp, sizeof(StackFrame)
```

紧凑布局与嵌套布局使用相同写法，嵌套字段可以直接写成 `[rsp + offset_of(NestedFrame, point.y)]`。

如果这段代码还要调用 Windows x64 函数，必须另外满足调用约定的栈对齐与影子空间要求：`sizeof(StackFrame)` 只描述结构体记录本身，不会补齐调用边界需要的栈空间。在 PE64 程序里使用结构体栈帧时同样如此。

## 打包并写出结构体值

`pack(value)` 把复合值转换为 `bytes` 值：

```asm id=09-6
// 两个小端 u16 字段共同组成四个连续字节。
packed struct Header {
    magic: u16 = 0x4241
    tail: u16
}

const header: Header = Header {
    tail: 0x4443
}

// 先打包以便比较，再把同一字节序列写入输出。
const encoded: bytes = pack(header)
assert(encoded == b"ABCD")
emit.bytes(encoded)
```

`emit.struct(value)` 直接完成打包和写出：

```asm id=09-7 bytes=4100000044332211
// 自然布局会在 tag 与 size 之间加入三个零填充字节。
struct NaturalHeader {
    tag: u8 = 0x41
    size: u32 = 0x11223344
}

// 空字面量使用所有字段默认值，并立即写出完整结构体布局。
const header: NaturalHeader = NaturalHeader { }
emit.struct(header)
```

这会写出八个字节，其中自然布局产生的三个填充字节都是零：

```text
41 00 00 00 44 33 22 11
```

还需要比较、转换、把字节序列存进集合，或者传给另一个函数时用 `pack`；只需要立即写出该值时用 `emit.struct`。

## 联合体与当前字段

联合体让多个不同类型的字段重叠在偏移 0：

```asm id=09-8
// Point 的两个坐标以紧凑形式连续存放。
packed struct Point {
    x: u16
    y: u16
}

// raw 与 point 共享同一段四字节存储。
union ValueBits {
    raw: u32
    point: Point
}

// 此字面量选择 point 作为联合体的当前字段。
const coordinates: ValueBits = ValueBits {
    point: Point {
        x: 0x1122,
        y: 0x3344
    }
}
```

联合体的每个字段都从偏移 0 开始。自然布局的联合体以最大字段大小为基础，再按最大的字段对齐要求向上取整；`packed` 联合体直接使用最大字段的精确大小。

`coordinates` 字面量只选择一个当前字段。联合体字面量既不能省略所有字段，也不能同时初始化多个字段。联合体字段声明不能提供默认值，因为默认值无法表示一次显式的当前字段选择。

联合体还可以嵌套在结构体中：

```asm id=09-9
// Point 描述联合体的一种四字节解释方式。
packed struct Point {
    x: u16
    y: u16
}

union ValueBits {
    raw: u32
    point: Point
}

// 紧凑记录把种类字节与联合体内容连续排列。
packed struct Record {
    kind: u8
    value: ValueBits
}

// 此实例选择 raw 作为嵌套联合体的当前字段。
const record: Record = Record {
    kind: 1,
    value: ValueBits {
        raw: 0xaabbccdd
    }
}

// 嵌套字段路径会累计外层和内层字段的偏移。
assert(offset_of(Record, value) == 1)
assert(offset_of(Record, value.point.y) == 3)
emit.struct(record)
```

`offset_of` 支持嵌套字段路径：第二个结果把 `value` 在 `Record` 中的偏移与 `y` 在 `Point` 中的偏移相加。

## 何时使用结构体

| 情况                                       | 使用               |
| ------------------------------------------ | ------------------ |
| 只有少数字段                               | 直接写出整数和字节 |
| 字段只写一次，之后不再需要名称             | 直接写出整数和字节 |
| 与外部格式强绑定，显式调用比类型声明更清晰 | 直接写出整数和字节 |
| 精确的二进制记录会被重复使用               | 紧凑结构体和联合体 |
| 字段名称能提高可读性                       | 紧凑结构体和联合体 |
| 其他计算应由`sizeof`、`offset_of` 驱动 | 紧凑结构体和联合体 |
| 值需要默认值、嵌套、比较或转成`bytes`    | 紧凑结构体和联合体 |
| 记录表示对齐的内存而非序列化布局           | 自然布局结构体     |
| 填充是有意保留的，且应遵循字段对齐要求     | 自然布局结构体     |

外部规范定义的布局用 `sizeof` 和 `offset_of` 验证。断言把格式假设变成可执行检查，后续修改也更安全。

[返回语言指南](../language.md)

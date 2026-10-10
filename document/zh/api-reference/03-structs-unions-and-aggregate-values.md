# 第 3 章：结构体、联合体与复合值

结构体和联合体用于描述二进制布局。它们的值会在汇编期间存在，直到被打包成字节或写入输出内容。

## 语法摘要

| 形式 | 用途 |
| --- | --- |
| `struct Name { fields }` | 声明自然布局结构体。 |
| `packed struct Name { fields }` | 声明不含填充的结构体。 |
| `union Name { fields }` | 声明自然布局联合体。 |
| `packed union Name { fields }` | 声明不含尾部填充的联合体。 |
| `Name { field: value }` | 构造复合值。 |
| `value.field` | 读取复合值的字段。 |
| `emit.struct(value)` | 打包复合值并立即写出。 |
| `sizeof(Type)` | 返回类型的二进制大小。 |
| `offset_of(Type, field_path)` | 返回字段偏移。 |
| `pack(value)` | 将复合值转换为 `bytes`。 |

## 自然布局结构体与紧凑结构体

```asm
// 自然布局会按字段的对齐要求插入填充。
struct NaturalHeader {
    tag: u8
    size: u32
}

// 紧凑布局让字段连续排列，不插入填充。
packed struct PackedHeader {
    tag: u8
    size: u32
}

// 对比两种布局的总大小和 size 字段偏移。
assert(sizeof(NaturalHeader) == 8)
assert(offset_of(NaturalHeader, size) == 4)
assert(sizeof(PackedHeader) == 5)
assert(offset_of(PackedHeader, size) == 1)
```

自然布局结构体会按照每个字段的类型对齐，并将最终大小向上取整到结构体的对齐要求。字段之间和结构体末尾都可能出现填充。

紧凑结构体会把每个字段紧接在前一个字段之后，不添加尾部填充。需要精确描述文件记录和协议记录时使用紧凑布局；记录中的字段需要对齐时使用自然布局。

紧凑布局只移除填充，不会清除复合类型自身的对齐属性。紧凑复合类型仍保留最大字段对齐，因此自然布局的外层复合类型会按照该边界放置嵌套的紧凑字段。

同一个声明中的字段名称必须唯一。

## 字段默认值与结构体字面量

```asm
// magic 使用声明中的字段默认值，tail 由结构体字面量指定。
packed struct Header {
    magic: u16 = 0x4241
    tail: u16
}

const header: Header = Header {
    tail: 0x4443
}

// 读取默认字段，并写出完整的紧凑结构体。
assert(header.magic == 0x4241)
emit.struct(header)
```

结构体字面量按名称为字段赋值。字面量中的书写顺序不必与声明顺序一致。

结构体的整数与浮点字段可以声明默认值。省略的标量字段使用声明的默认值，省略其他字段会报错。字面量中出现未知字段或重复字段也会报错。联合体字段不能声明默认值。

`f32` 和 `f64` 字段分别占 4 与 8 字节，自然对齐与宽度相同。字面量与默认值必须精确匹配字段类型：`f32` 使用 `f32(1.5)`，`f64` 使用 `1.5`。整数和不同宽度的浮点值不会隐式转换。`pack` 与 `emit.struct` 保留小端 IEEE-754 位模式，包括带符号的零。

复合值字面量可以直接传给内置表达式：

```asm
// 构造 Pair 后立即打包，并把所得两个字节写入输出内容。
packed struct Pair {
    low: u8
    high: u8
}

emit.bytes(pack(Pair {
    low: 3,
    high: 4
}))
```

## 自然布局联合体与紧凑联合体

```asm
// ThreeBytes 的紧凑布局大小为三个字节。
packed struct ThreeBytes {
    tag: u8
    value: u16
}

// 自然布局联合体会按最大字段的对齐要求取整最终大小。
union NaturalValue {
    bytes: ThreeBytes
    word: u16
}

// 紧凑联合体只保留最大字段的精确大小。
packed union PackedValue {
    bytes: ThreeBytes
    word: u16
}

assert(sizeof(NaturalValue) == 4)
assert(sizeof(PackedValue) == 3)
```

联合体的每个字段都从偏移零开始。自然布局联合体采用最大字段的大小，并把最终大小向上取整到最大字段的对齐要求。紧凑联合体则采用最大字段的精确大小。

联合体字面量必须恰好选择一个当前字段：

```asm
// word 是这个联合体值唯一的当前字段。
packed union Value {
    byte: u8
    word: u16
}

const value: Value = Value {
    word: 0x1234
}

// 按 word 字段的声明宽度打包并写出联合体。
emit.struct(value)
```

联合体初始化时不指定字段，或指定多个字段，都是无效写法。
联合体字段声明不能提供默认值；字面量必须始终显式选择当前字段。

## 嵌套复合值字面量

```asm
// Point 将两个坐标连续存放。
packed struct Point {
    x: u16
    y: u16
}

// ValueBits 的当前字段可以是原始整数，也可以是 Point。
union ValueBits {
    raw: u32
    point: Point
}

packed struct Record {
    kind: u8
    value: ValueBits
}

// 在 Record 中逐层构造联合体和结构体字段。
const record: Record = Record {
    kind: 1,
    value: ValueBits {
        point: Point {
            x: 0x1122,
            y: 0x3344
        }
    }
}

// 点分字段路径会累加每一层的字段偏移。
assert(offset_of(Record, value.point.y) == 3)
emit.struct(record)
```

嵌套的复合值字段可以接受其声明类型对应的嵌套字面量。`offset_of` 接受点分字段路径，并累加各层的字段偏移。

## 字段访问

```asm
// 构造头部后，通过字段访问分别读取两个值。
packed struct Header {
    magic: u16
    size: u32
}

const header: Header = Header {
    magic: 0x5a4d,
    size: 0x40
}

// 按字段各自的声明宽度写出读取结果。
emit.u16(header.magic)
emit.u32(header.size)
```

字段访问会从已经保存的复合值中读取一个值。字段名称必须存在于该值的声明类型中。

## `sizeof` 与 `offset_of`

```text
sizeof(Type)
offset_of(Type, field_path)
```

`sizeof` 返回完整的二进制大小，其中包括自然布局产生的填充。

`offset_of` 返回直接字段或嵌套字段的字节偏移。它不需要复合值；这两个操作查询的都是声明类型的布局。

## `pack`

```text
pack(value) -> bytes
```

`pack` 会创建包含复合值二进制表示的字节序列。整数字段会按照其声明宽度编码。自然布局中的填充字节为零。

需要检查、比较、保存这些字节，或把它们传给另一个函数时，使用 `pack`。

## `emit.struct`

```text
emit.struct(value)
```

`emit.struct` 会打包复合值，并把所得字节写入当前输出区域。它等价于写出 `pack` 的结果，但不会公开中间的 `bytes` 值。

## 无效的复合值字面量

以下形式都会被拒绝：

```text
const unknown: Pair = Pair {
    missing: 1
}
```

```text
const duplicate: Pair = Pair {
    low: 1,
    low: 2
}
```

```text
const incomplete: Pair = Pair {
    low: 1
}
```

```text
const invalid_union: Value = Value {
    byte: 1,
    word: 2
}
```

这些错误依次表示：未知字段、重复字段、缺少没有默认值的字段，以及联合体存在多个当前字段。

## 完整示例

```asm
// 自然布局头部包含字段对齐和尾部填充。
struct NaturalHeader {
    tag: u8 = 0x41
    size: u32 = 0x11223344
}

// 紧凑头部连续存放 tag 和 tail。
packed struct PackedHeader {
    tag: u8 = 0x42
    tail: u16
}

packed struct Point {
    x: u16
    y: u16
}

// ValueBits 让原始整数和坐标值共享存储空间。
union ValueBits {
    raw: u32
    point: Point
}

packed struct Record {
    kind: u8
    value: ValueBits
}

// 三字节字段用于演示联合体最终大小的布局差异。
packed struct ThreeBytes {
    tag: u8
    value: u16
}

union NaturalOdd {
    bytes: ThreeBytes
    word: u16
}

packed union PackedOdd {
    bytes: ThreeBytes
    word: u16
}

// 使用全部字段默认值，并写出自然布局结构体及其布局信息。
const natural: NaturalHeader = NaturalHeader { }
emit.struct(natural)
emit.u8(sizeof(NaturalHeader))
emit.u8(offset_of(NaturalHeader, size))
emit.u32(natural.size)

// 为 tail 指定值，tag 继续使用字段默认值。
emit.bytes(pack(PackedHeader { tail: 0x4443 }))

// 嵌套构造 Record，并选择 point 作为联合体的当前字段。
const record: Record = Record {
    kind: 1,
    value: ValueBits {
        point: Point {
            x: 0x1122,
            y: 0x3344
        }
    }
}

emit.bytes(pack(record))

// 选择 ThreeBytes 作为紧凑联合体的当前字段。
const odd: PackedOdd = PackedOdd {
    bytes: ThreeBytes {
        tag: 0x55,
        value: 0x7766
    }
}

// 写出联合体内容、两种联合体大小以及 Record 的 kind 字段。
emit.bytes(pack(odd))
emit.u8(sizeof(NaturalOdd))
emit.u8(sizeof(PackedOdd))
emit.u8(record.kind)
```

源代码会写出：

```text
41 00 00 00 44 33 22 11 08 04 44 33 22 11
42 43 44 01 22 11 44 33 55 66 77 04 03 01
```

## 选用指南

| 需求 | 使用形式 |
| --- | --- |
| 按字段自然对齐，并对最终大小取整 | `struct` |
| 精确的连续字节布局 | `packed struct` |
| 让字段重叠，并按自然对齐要求确定最终大小 | `union` |
| 让字段重叠，并采用最大字段的精确大小 | `packed union` |
| 查询声明的布局 | `sizeof` 或 `offset_of` |
| 以值的形式取得复合值字节 | `pack` |
| 立即写出复合值字节 | `emit.struct` |

# XIRASM Language API Reference

This reference describes XIRASM language forms and built-in APIs. It is the
compact lookup companion to the [Language Guide](language.md), which introduces
the same features through longer explanations and progressively developed
examples.

Executable and object format APIs are documented separately:

- [Format Tutorial](format-tutorial.md) for ordinary PE, COFF, ELF, and macOS Mach-O
  workflows.
- [Advanced Formats Guide](advanced-formats.md) for direct header, table,
  region, and relocation control.

This reference does not list `format_*` procedures or direct format-family
helpers.

## Using This Reference

Syntax forms use the following notation:

- `name` is an identifier supplied by the program.
- `expression` is any expression valid in that position.
- `type` is an optional explicit type.
- Text inside brackets in a syntax form is optional.

Examples use x86-64 ISA text unless a different target is required. Compile-time
language rules are otherwise independent of the selected instruction set.

## Reference Map

The language reference is organized by responsibility:

1. Source, bindings, and scope
2. Functions and control flow
3. Structs, unions, and aggregate values
4. Finalization forms
5. Modules and diagnostics
6. Targets, ISA text, and symbols
7. Emission, reservation, and alignment
8. Regions, output areas, and cursors
9. Loads, stores, and final region facts
10. Text, conversion, and symbol names
11. Byte sequences
12. Lists and maps
13. Files and structured data
14. Tokens and pattern matching
15. Crypto helpers

## Part I: Core Language

### Chapter 1: Source, Bindings, and Scope

#### Syntax Summary

| Form | Syntax | Purpose |
| --- | --- | --- |
| Label | `name:` | Defines a source label at the current logical address. |
| ISA instruction | `mnemonic operands` | Emits a normal target instruction. |
| Constant | `const name [: type] = expression` | Declares an immutable compile-time value. |
| Variable | `let name [: type] = expression` | Declares a mutable compile-time value. |
| Assignment | `name = expression` | Updates an existing mutable binding. |
| Block | `{ statements }` | Creates a nested lexical scope. |
| Multiline arguments | `callee(` ... `)` | Continues an expression across source lines. |

#### Labels

```asm
start:
    mov rax, 1
```

A label binds its name to the logical address at its source position. Labels
may be referenced by later instructions, expressions, fixups, and symbol APIs.
Forward references are allowed when the selected encoding or output operation
can be resolved by the assembler pipeline.

A label is not a compile-time `const` or `let` binding. It represents an
assembler symbol whose final value depends on layout.

#### ISA Instructions

```asm
mov rax, 1
add rax, 2
ret
```

ISA instructions use their normal textual form. They are not written as
compile-time function calls. The active target determines which mnemonics,
registers, operands, and encodings are accepted.

Compile-time statements and ISA instructions can appear in the same source
file. Compile-time expressions decide what is emitted; ISA lines describe the
instructions to emit.

#### Constants

```asm
const page_size = 4096
const marker: u8 = 0x90
```

`const` evaluates its initializer and creates an immutable binding in the
current scope. The explicit type is optional when the value can be inferred.

Assigning to a constant is invalid:

```text
const value = 1
value = 2
```

Use `const` for configuration, computed addresses, descriptor values, and other
facts that should not change after declaration.

#### Variables

```asm
let count = 1
let flags: u32 = 0

count = count + 1
flags = flags | 0x20
```

`let` creates a mutable binding in the current scope. Assignment updates the
nearest visible mutable binding with the given name.

Assignment does not declare a new name. The target must already exist and must
be mutable.

#### Fixed-Width Integer Types

| Type family | Types | Accepted values |
| --- | --- | --- |
| Unsigned | `u8`, `u16`, `u32`, `u64` | `0` through `2^width - 1` |
| Signed | `i8`, `i16`, `i32`, `i64` | `-2^(width - 1)` through `2^(width - 1) - 1` |

These types may annotate `const` and `let` bindings, function parameters and
results, and integer fields in structs and unions. Signed values use
two's-complement representation when an aggregate is packed or emitted.

```asm
const displacement: i32 = -4
let retry_count: u16 = 3
```

An initializer outside the declared range is rejected.

#### Blocks and Shadowing

```asm
const value = 1

{
    let value = 2
    value = value + 1
    assert(value == 3)
}

assert(value == 1)
```

Braces create a lexical scope. A declaration inside a block may shadow a name
from an outer scope without changing the outer binding.

Bindings declared inside a block cease to exist when the block ends:

```text
{
    let hidden = 1
}

emit.u8(hidden)
```

Use blocks to limit temporary values, isolate helper calculations, and make
shadowing explicit.

#### Multiline Expression Arguments

An expression call may continue across source lines while its parentheses are
open:

```asm
const value = 1

assert(
    value == 1
)
```

Indentation improves readability but does not replace the closing delimiter.
Nested calls may use the same form. The complete expression is evaluated only
after all delimiters have closed.

#### Complete Example

The following source combines all seven forms from this chapter:

```asm
const value = 1

{
    let value = 2
    value = value + 1
    assert(value == 3)
}

assert(
    value == 1
)

start:
    mov rax, 1

emit.u8(value)
```

The source emits:

```text
b8 01 00 00 00 01
```

The inner `value` is mutable and scoped to the block. The outer `value` remains
the immutable value `1`, which is emitted after the instruction.

#### Selection Guide

| Requirement | Use |
| --- | --- |
| Bind an address produced by layout | A label |
| Describe a target instruction | An ISA instruction line |
| Name an immutable compile-time fact | `const` |
| Keep mutable compile-time state | `let` |
| Update mutable state | Assignment |
| Limit lifetime or shadow a name | A block |
| Format a long call or nested expression | Multiline arguments |

### Chapter 2: Functions and Control Flow

Functions and control-flow statements execute while the source is assembled.
They calculate values, select source operations, and repeat source operations.
They do not create runtime calls, branches, or loops unless their bodies emit
the corresponding ISA instructions.

#### Syntax Summary

| Form | Syntax | Purpose |
| --- | --- | --- |
| Procedure | `fn name(parameters) { statements }` | Packages compile-time actions. |
| Mutable procedure parameter | `let name: type` | Writes the final parameter value back to a direct caller `let` binding. |
| Procedure call | `name(arguments)` | Executes a procedure. |
| Value function | `fn name(parameters) -> type { statements }` | Calculates an expression value. |
| Return | `return expression` | Completes a value function with a result. |
| Value call | `name(arguments)` | Uses a value function in an expression. |
| Conditional | `if condition { statements }` | Executes a block when a boolean is true. |
| Alternative | `} else { statements }` | Executes an alternative block. |
| Conditional loop | `while condition { statements }` | Repeats while a boolean remains true. |
| Range loop | `for name in range(start, end) { statements }` | Iterates a half-open range. |
| List loop | `for name in list_value { statements }` | Iterates list values in order. |

#### Procedure Functions

```asm
fn emit_pair(value: u8) {
    emit.u8(value)
    emit.u8(value + 1)
}

emit_pair(2)
emit_pair(8)
```

A function without `-> type` is a procedure. A procedure performs actions and
does not produce an expression value. Its body may emit data or instructions,
change layout, declare local values, use control flow, and call other
procedures.

Parameters are positional. Their type annotations are optional, but an
annotation validates the corresponding argument at the call boundary. Every
call must supply exactly one argument for each parameter.

Procedure parameters are read-only unless prefixed with `let`. A `let`
parameter writes its final value back to the caller, so its argument must be a
direct mutable binding. Mutable parameters cannot receive constants,
temporaries, or duplicate aliases. Value-returning functions cannot declare
`let` parameters.

Procedure calls are statements. A trailing semicolon is accepted but is not
required.

#### Value-Returning Functions

```asm
fn align_up(value: u64, alignment: u64) -> u64 {
    return ((value + alignment - 1) / alignment) * alignment
}

emit.u16(align_up(0x73, 0x20))
```

A function with `-> type` is a value-returning function. Its call is an
expression and may appear in declarations, conditions, arguments, returns, or
larger expressions.

`return` evaluates its expression and converts the result to the declared
return type. Every executed path through a value function must reach a
`return`.

Value functions are calculation helpers. They may use local bindings, control
flow, and other value functions, but they may not emit output or perform other
layout-changing actions.

#### Function Declaration and Call Rules

- Functions must be declared at top level.
- A declaration must appear before its first call.
- Parameter names must be unique within the declaration.
- `let` parameters are valid only in procedures and require direct caller `let`
  bindings.
- Parameters and local bindings belong to one invocation.
- Procedure calls cannot be used as expression values.
- `return` is valid only in a value-returning function.
- Function call chains are limited to 128 active calls.

Recursive value functions are allowed when they terminate before the call-depth
limit. Use a loop when the operation is naturally iterative.

#### `if` and `else`

```asm
const enabled = false

if enabled {
    emit.u8(0x11)
} else {
    emit.u8(0x22)
}
```

The condition must evaluate to `bool`. Only the selected branch executes. Each
branch has its own lexical scope.

Write alternatives in the canonical `} else if condition {` and `} else {`
forms. Both `else if` and the final `else` are optional.

An `if` statement selects source operations during assembly. Runtime
conditional behavior still requires an ISA branch instruction.

#### `while`

```asm
let value = 1

while value <= 3 {
    emit.u8(value)
    value = value + 1
}
```

`while` evaluates its boolean condition before every iteration. If the
condition is initially false, the body does not execute.

`break` ends the innermost active Meta loop. `continue` starts its next
iteration without executing the remaining statements in the body. They also
work in `for` loops and deferred `while` blocks. A compile-time loop is limited
to 1,000,000 iterations. A loop-control statement outside a loop, or across a
function call boundary, is invalid.

#### Range Iteration

```asm
for index in range(0, 4) {
    emit.u8(index)
}
```

`range(start, end)` includes `start` and excludes `end`. The example emits
`00 01 02 03`.

The range must move forward or be empty. A descending range is invalid:

```text
for value in range(2, 0) {
    emit.u8(value)
}
```

The loop binding is a read-only local value. Each iteration receives a fresh
binding and a fresh body scope.

#### List Iteration

```asm
const opcodes: list = list.of(0x90, 0x90, 0xc3)

for opcode in opcodes {
    emit.u8(opcode)
}
```

A list loop visits values in list order. The loop binding is local to the
iteration and cannot be assigned.

Only list values are accepted directly by this form. To iterate map content,
first obtain a list with a map helper such as `map.keys(...)` or
`map.values(...)`.

#### Invalid Function Forms

A procedure cannot return a value:

```text
fn invalid() {
    return 1
}

invalid()
```

A value function cannot fall through without returning:

```text
fn invalid() -> u64 {
    const value = 1
}

const result = invalid()
```

A value function cannot emit output:

```text
fn invalid() -> u64 {
    emit.u8(1)
    return 1
}

const result = invalid()
```

Use a procedure when the operation changes output or layout. Use a value
function when the caller needs a calculated result.

#### Complete Example

```asm
fn emit_pair(value: u8) {
    emit.u8(value)
    emit.u8(value + 1)
}

fn choose(value: u64, limit: u64) -> u64 {
    if value > limit {
        return limit
    } else {
        return value
    }
}

emit_pair(1)
emit.u8(choose(9, 5))

const enabled = true

if enabled {
    emit.u8(0xaa)
} else {
    emit.u8(0xff)
}

let counter = 0

while counter < 2 {
    emit.u8(0x10 + counter)
    counter = counter + 1
}

for index in range(0, 2) {
    emit.u8(0x20 + index)
}

const values: list = list.of(0x30, 0x31)

for value in values {
    emit.u8(value)
}
```

The source emits:

```text
01 02 05 aa 10 11 20 21 30 31
```

#### Selection Guide

| Requirement | Use |
| --- | --- |
| Package output or layout actions | Procedure |
| Calculate a reusable expression value | Value-returning function |
| Select one source block | `if` |
| Select one of two source blocks | `if` / `else` |
| Select one of several source blocks | `if` / `else if` / `else` |
| Repeat until mutable state reaches a condition | `while` |
| Iterate a fixed integer interval | `for` with `range` |
| Iterate known collection values | `for` with a list |
| End the innermost loop early | `break` |
| Skip the rest of one iteration | `continue` |

#### Statement Macros

```asm
macro emit_byte(value) {
    emit.u8(operand.eval(value))
}
emit_byte 42
```

`macro name(parameters) {` starts a multiline top-level declaration. Parameters
are immutable `operand` values; a final `...name` is a `list` of operands.
No parameter annotations, defaults, return types, or return statements are
allowed. Definitions are ordered and case-sensitive. Dot-separated names are
allowed; duplicate parameter names, duplicate exact arities, multiple variadic
overloads, and names reserved by statement syntax are rejected.

Calls use instruction syntax. Exact arity wins over a matching variadic overload.
A known name with mismatching arity reports `MacroArityMismatch`. Empty operands,
unbalanced delimiters, and semicolon-separated instruction text are invalid.
`name (expression)` is a one-operand call; `name(expression)` remains function
syntax. Macros may shadow native mnemonics; `isa(text)` bypasses macro lookup.

| API | Result | Contract |
| --- | --- | --- |
| `operand.text(op)` | `string` | Returns spelling without evaluating it. |
| `operand.eval(op)` | expression value | Uses captured value bindings and the existing Meta evaluator. |
| `operand.slice(op, start, end)` | `operand` | Half-open byte range; requires `0 <= start <= end <= byte length`. |
| `operand.split(op)` | `list` | Top-level comma split preserving each piece's capture; empty text gives an empty list. |

All four APIs require an `operand`, with no implicit string conversion. Slices
may select any valid byte range; evaluating incomplete tokens is an expression
error. Empty slices are valid values but cannot be evaluated. Operand values
may be cloned into collections and outlive the invocation; their captures remain
immutable. Collection equality compares operand pieces and capture identity,
not only spelling. Compare `operand.text` results for spelling equality.

Captured bindings preserve caller values before later mutations or callee
shadowing. Operand-valued identifiers in instruction operands forward their
original capture; ordinary strings and quoted text do not substitute. Forwarded
text is not rescanned. Mixed templates preserve each piece's value bindings;
called functions and location builtins use the first piece's capture context.
Repeated explicit evaluation repeats expression execution. Unknown identifiers
are errors, not zero or deferred macro-local lookups.

Macros execute once per reached call during lowering, with ordinary Meta typing,
scopes, control flow and side-effect restrictions. Encoding and layout do not
re-execute them. Static labels remain module labels; use `sym.unique` and
`label.define` for private labels. A macro may register a valid finalizer but
stored `defer`/`late_layout` bodies cannot contain macro definitions or calls.
Limits: 128 shared function/macro call depth, 100,000 cumulative macro calls,
256 operands per call, and 64 nested operand delimiters.
Source nesting is bounded and reported with a location: statements 128 levels
(`StatementNestingTooDeep`), expressions 64 levels of parentheses, prefix
operators and `list.of` elements (`ExpressionNestingTooDeep`, flat operator
chains exempt), aggregate literals 64 levels (`StructNestingTooDeep`), and
documents read by `toml.parse`/`json.parse` 64 levels (`NestingTooDeep`).
References through previously saved operand captures are limited to 128 levels
(`MacroCaptureDepthExceeded`). Snapshots copy visible value bindings; storing
evaluated values avoids retaining unnecessary environments and large collections.

The opt-in `arm/a64-macros.inc` exposes the generated A64 floating-point, SIMD
and memory families through direct DSL calls. Scalar integer arithmetic,
branches and system instructions are not yet included in this library.
`#` immediate prefixes are parsed by this include, not by `operand.eval`.
Its mnemonic ownership is not target-scoped; `arm/a64.inc` is API-only.
See the language guide for usage and supported scope.

### Chapter 3: Structs, Unions, and Aggregate Values

Structs and unions describe binary layouts. Their values exist during assembly
until they are packed into bytes or emitted to the output.

#### Syntax Summary

| Form | Purpose |
| --- | --- |
| `struct Name { fields }` | Declares a naturally aligned struct. |
| `packed struct Name { fields }` | Declares a struct without padding. |
| `union Name { fields }` | Declares a naturally aligned union. |
| `packed union Name { fields }` | Declares a union without final padding. |
| `Name { field: value }` | Constructs an aggregate value. |
| `value.field` | Reads a field from an aggregate value. |
| `emit.struct(value)` | Packs and immediately emits an aggregate value. |
| `sizeof(Type)` | Returns the binary size of a type. |
| `offset_of(Type, field_path)` | Returns a field offset. |
| `pack(value)` | Converts an aggregate value to `bytes`. |

#### Natural and Packed Structs

```asm
struct NaturalHeader {
    tag: u8
    size: u32
}

packed struct PackedHeader {
    tag: u8
    size: u32
}

assert(sizeof(NaturalHeader) == 8)
assert(offset_of(NaturalHeader, size) == 4)
assert(sizeof(PackedHeader) == 5)
assert(offset_of(PackedHeader, size) == 1)
```

A natural struct aligns each field according to its type and rounds the final
size to the struct alignment. Padding may appear between fields and at the end.

A packed struct places each field immediately after the previous field and
does not add trailing padding. Use packed layout for exact file and protocol
records. Use natural layout for records that require field alignment.

Packing removes padding but does not erase the aggregate's alignment property.
A packed aggregate retains the largest field alignment, so a naturally aligned
outer aggregate aligns a nested packed field to that boundary.

Field names within one declaration must be unique.

#### Field Defaults and Struct Literals

```asm
packed struct Header {
    magic: u16 = 0x4241
    tail: u16
}

const header: Header = Header {
    tail: 0x4443
}

assert(header.magic == 0x4241)
emit.struct(header)
```

A struct literal assigns fields by name. Source order inside the literal does
not have to match declaration order.

An omitted integer struct field uses its declared default. Every other omitted
field is an error. Unknown and duplicate literal fields are also errors. Union
fields cannot declare defaults.

Aggregate literals can be passed directly to built-in expressions:

```asm
packed struct Pair {
    low: u8
    high: u8
}

emit.bytes(pack(Pair {
    low: 3,
    high: 4
}))
```

#### Natural and Packed Unions

```asm
packed struct ThreeBytes {
    tag: u8
    value: u16
}

union NaturalValue {
    bytes: ThreeBytes
    word: u16
}

packed union PackedValue {
    bytes: ThreeBytes
    word: u16
}

assert(sizeof(NaturalValue) == 4)
assert(sizeof(PackedValue) == 3)
```

Every union field begins at offset zero. A natural union uses the largest field
size and rounds the final size to the largest field alignment. A packed union
uses the exact largest field size.

A union literal must select exactly one active field:

```asm
packed union Value {
    byte: u8
    word: u16
}

const value: Value = Value {
    word: 0x1234
}

emit.struct(value)
```

Initializing no union fields or more than one field is invalid.
Union field declarations cannot provide defaults; the active field must always
be selected explicitly by the literal.

#### Nested Aggregate Literals

```asm
packed struct Point {
    x: u16
    y: u16
}

union ValueBits {
    raw: u32
    point: Point
}

packed struct Record {
    kind: u8
    value: ValueBits
}

const record: Record = Record {
    kind: 1,
    value: ValueBits {
        point: Point {
            x: 0x1122,
            y: 0x3344
        }
    }
}

assert(offset_of(Record, value.point.y) == 3)
emit.struct(record)
```

Nested aggregate fields accept nested literals of the declared field type.
`offset_of` accepts a dotted field path and accumulates each nested offset.

#### Field Access

```asm
packed struct Header {
    magic: u16
    size: u32
}

const header: Header = Header {
    magic: 0x5a4d,
    size: 0x40
}

emit.u16(header.magic)
emit.u32(header.size)
```

Field access reads a value from a stored aggregate. The field name must exist
in the value's declared type.

#### `sizeof` and `offset_of`

```text
sizeof(Type)
offset_of(Type, field_path)
```

`sizeof` returns the complete binary size, including natural-layout padding.

`offset_of` returns the byte offset of a direct or nested field. It does not
require an aggregate value; both operations query the declared type layout.

#### `pack`

```text
pack(value) -> bytes
```

`pack` creates a byte sequence containing the aggregate's binary
representation. Integer fields are encoded into their declared widths.
Natural-layout padding bytes are zero.

Use `pack` when the bytes must be inspected, compared, stored, or passed to
another function.

#### `emit.struct`

```text
emit.struct(value)
```

`emit.struct` packs an aggregate value and writes the resulting bytes to the
active output region. It is equivalent to emitting the result of `pack`, but
does not expose an intermediate `bytes` value.

#### Invalid Aggregate Literals

The following forms are rejected:

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

The failures respectively represent an unknown field, a duplicate field, a
missing field without a default, and a union with multiple active fields.

#### Complete Example

```asm
struct NaturalHeader {
    tag: u8 = 0x41
    size: u32 = 0x11223344
}

packed struct PackedHeader {
    tag: u8 = 0x42
    tail: u16
}

packed struct Point {
    x: u16
    y: u16
}

union ValueBits {
    raw: u32
    point: Point
}

packed struct Record {
    kind: u8
    value: ValueBits
}

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

const natural: NaturalHeader = NaturalHeader { }
emit.struct(natural)
emit.u8(sizeof(NaturalHeader))
emit.u8(offset_of(NaturalHeader, size))
emit.u32(natural.size)

emit.bytes(pack(PackedHeader { tail: 0x4443 }))

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

const odd: PackedOdd = PackedOdd {
    bytes: ThreeBytes {
        tag: 0x55,
        value: 0x7766
    }
}

emit.bytes(pack(odd))
emit.u8(sizeof(NaturalOdd))
emit.u8(sizeof(PackedOdd))
emit.u8(record.kind)
```

The source emits:

```text
41 00 00 00 44 33 22 11 08 04 44 33 22 11
42 43 44 01 22 11 44 33 55 66 77 04 03 01
```

#### Selection Guide

| Requirement | Use |
| --- | --- |
| Native field alignment and final-size rounding | `struct` |
| Exact sequential byte layout | `packed struct` |
| Overlaid fields with natural final alignment | `union` |
| Overlaid fields with exact largest-field size | `packed union` |
| Query a declared layout | `sizeof` or `offset_of` |
| Obtain aggregate bytes as a value | `pack` |
| Write aggregate bytes immediately | `emit.struct` |

### Chapter 4: Finalization Forms

XIRASM provides two deliberately separate late phases:

- `late_layout` performs restricted layout-changing work before the output is
  sealed.
- `defer` reads and patches the sealed image without changing its layout.

Do not use the two forms interchangeably.

#### Phase Order

| Phase | Allowed responsibility |
| --- | --- |
| Ordinary source | Declare labels, emit content, reserve space, and register late blocks. |
| Instruction encoding | Encode ordinary ISA fragments. |
| `late_layout` | Append or reorganize restricted layout content once. |
| Fixup and layout | Resolve references and compute final logical addresses and raw file placement. |
| Output image | Create the final byte image and patch resolved fixups. |
| `defer` | Load, validate, and patch existing final bytes. |

Blocks of each kind execute in registration order.

#### `late_layout`

```asm
emit.u8(0x10)

late_layout {
    emit.u8(0x20)
}

late_layout {
    emit.u8(0x30)
}
```

The example emits `10 20 30`.

A late-layout block runs once after ordinary source emission and instruction
encoding, but before fixup resolution and final layout. Its emitted data
participates in final offsets and sizes.

`late_layout` accepts:

- output and layout API calls;
- integer, byte, and aggregate emission;
- reserve, padding, and alignment calls;
- output-region and virtual-region calls;
- stores into existing module content;
- diagnostics and assertions;
- `if` and `else`.

It does not accept local declarations, assignment, loops, labels, ISA text,
function declarations, source loading, `defer`, or another `late_layout`.

Late layout is a one-time phase. It is not an implicit repeated-pass mechanism.

#### Reserved Tails and Late Layout

Appending initialized data in the same region after a reserved tail turns that
tail into a raw file gap:

```asm
emit.u8(0xaa)
reserve(2)

late_layout {
    emit.u8(0xbb)
}
```

The output is `aa 00 00 bb`. Use `output.section` or an explicit region switch
when the reserved tail must remain logical-only.

#### `defer`

```asm
origin(0)

size_field:
emit.u16(0)

payload:
emit.bytes(b"AB")

defer {
    store.u16(size_field, region_file_size(size_field))
    assert(load.u16(size_field) == 4)
}
```

The output is `04 00 41 42`.

A deferred block runs after final layout, materialization, and fixup patching.
It sees the exact byte image that will be written.

A deferred body may contain:

- `const` and `let` declarations;
- assignment to local `let` values;
- `if`, `else`, and `while`;
- `store.u8`, `store.u16`, `store.u32`, `store.u64`, and `store.bytes`;
- `assert`, `print`, `warn`, and `err`.

Expressions may use pure operators, value functions, labels, `load.*`, and
stable region facts.

Each deferred block has its own local scope. A loop is limited to 1,000,000
iterations.

#### Deferred Local Computation

```asm
origin(0)

checksum_field:
emit.u16(0)

payload:
emit.bytes(b"ABCD")

defer {
    let cursor = payload
    let checksum = 0
    const end = region_base() + region_file_size(payload)

    while cursor < end {
        checksum = checksum + load.u8(cursor)
        cursor = cursor + 1
    }

    store.u16(checksum_field, checksum)
}
```

`let` creates mutable finalizer-local state. Assignment updates that state, and
`while` supports bounded scans and folds over the completed image.

#### Registering a Finalizer from a Procedure

```asm
fn patch_u16(address: u64, value: u64) {
    defer {
        store.u16(address, value)
    }
}

field:
emit.u16(0)

patch_u16(field, 0x1234)
```

The output is `34 12`.

The procedure call occurs during ordinary source processing. Values captured
from the procedure scope are frozen for the deferred block. The procedure is
not called from inside `defer`.

Referenced local lists, maps, structs, type values, and operands are also
snapshotted at registration. Later mutations of the originals do not change the
snapshot. Deferred locals may shadow captured names; their initializers still
see the outer captured value. An operand retains its caller bindings and capture
location and is evaluated only by an explicit `operand.eval`. Use `label_addr`
inside a captured expression to resolve a label after layout. Module-level
bindings referenced directly by a top-level `defer` retain their existing
finalization-time lookup behavior.

#### Deferred Execution Order

```asm
origin(0)
emit.u8(0)

defer {
    store.u8(0, 1)
}

defer {
    store.u8(0, load.u8(0) + 1)
}
```

The output is `02`. A later deferred block observes patches made by earlier
blocks.

#### Finalizer Restrictions

`defer` cannot create bytes, labels, regions, alignment, or reserve space:

```text
defer {
    emit.u8(0x22)
}
```

Nested late phases are also invalid:

```text
defer {
    late_layout {
        emit.u8(0x22)
    }
}
```

Reserve or emit every patch target before finalization. A store may address
only bytes that exist in the final file image. A trimmed reserved tail has
logical extent but no raw file byte to patch:

```text
origin(0)
emit.u8(0x11)
reserve(1)

defer {
    store.u8(1, 0x22)
}
```

This store is rejected instead of writing beyond the final raw bytes.

#### Complete Example

```asm
origin(0)

size_field:
emit.u16(0)

checksum_field:
emit.u16(0)

payload:
emit.bytes(b"AB")

late_layout {
    emit.bytes(b"CD")
}

defer {
    let cursor = payload
    let checksum = 0
    const end = region_base() + region_file_size(payload)

    while cursor < end {
        checksum = checksum + load.u8(cursor)
        cursor = cursor + 1
    }

    store.u16(size_field, region_file_size(size_field))
    store.u16(checksum_field, checksum)

    assert(load.u16(size_field) == 8)
    assert(load.u16(checksum_field) == 0x010a)
    assert(load.bytes(payload, 4) == b"ABCD")
}
```

The source emits:

```text
08 00 0a 01 41 42 43 44
```

`late_layout` adds the final two payload bytes. `defer` then sees the complete
eight-byte image, calculates the checksum, and patches the two existing header
fields.

#### Selection Guide

| Requirement | Use |
| --- | --- |
| Emit normal source content | Ordinary source |
| Append real bytes before offsets and sizes are finalized | `late_layout` |
| Patch a fixed-width placeholder after layout | `defer` |
| Calculate a checksum over final bytes | `defer` with `load.*` and local state |
| Validate final offsets, sizes, or contents | `defer` with `assert` |

## Part II: Assembler Operations

### Chapter 5: Modules and Diagnostics

#### Syntax Summary

| API | Syntax | Result |
| --- | --- | --- |
| Include source | `include(path)` | Executes the resolved source at every call site. |
| Import source | `import(path)` | Executes the resolved source once. |
| Note | `print(value, ...)` | Records a non-fatal note. |
| Warning | `warn(value, ...)` | Records a non-fatal warning. |
| Error | `err(value, ...)` | Records an error and stops assembly. |
| Assertion | `assert(condition[, message])` | Stops assembly when the condition is false. |

#### Source Paths

The `path` argument to `include` and `import` must evaluate to text. A relative
path is resolved from the source file that contains the call, so a loaded file
may load another file relative to its own directory.

The resolved source path is also its module identity. Two different spellings
that resolve to the same source are one import.

#### Repeated Inclusion

`include(path)` evaluates the loaded source every time it is called:

```text
include("row.inc")
include("row.inc")
```

If `row.inc` emits one byte, the byte is emitted twice. Repeated inclusion also
repeats declarations, so including a file that declares the same function or
type more than once may produce a duplicate-declaration error.

Use `include` for deliberately repeated source expansion and small source
fragments whose declarations are safe at each call site.

#### Importing a Module Once

`import(path)` evaluates the loaded source only on its first import:

```text
import("library.inc")
import("library.inc")
```

The second call has no effect. This makes `import` the normal choice for files
that define functions, types, constants, or reusable data.

Imports are top-level module operations. An import inside a lexical block or
function is invalid. Recursive include or import chains are rejected instead
of partially evaluating a cycle.

#### Diagnostic Messages

`print`, `warn`, and `err` accept one or more values:

```asm
origin(0)

print("offset", here())
warn("diagnostic example", true)
assert(here() == 0, "unexpected origin")

emit.u8(0x5a)
```

The values are formatted using their normal textual representation and joined
with single spaces. The example records:

```text
note: offset 0
warning: diagnostic example true
```

`print` and `warn` do not stop assembly. `err` records an error at the call
site and stops assembly:

```text
err("unsupported width", 24)
```

Diagnostic APIs are also available in deferred finalizers. Module-loading APIs
are not finalizer operations.

#### Assertions

`assert` accepts a Boolean condition and an optional message:

```asm
const width = 64
assert(width == 64)
assert(width % 8 == 0, "width must use whole bytes")

emit.u8(width / 8)
```

When the condition is true, `assert` has no output and records no diagnostic.
When it is false, assembly stops with the supplied message. If the message is
omitted, the diagnostic text is `assertion failed`.

#### Complete Module Example

The following four files demonstrate repeated inclusion, import-once
semantics, nested relative paths, and diagnostics.

`main.asm`:

```text
origin(0)

include("repeat.inc")
include("repeat.inc")

import("module/once.inc")
import("module/once.inc")

print("module bytes", here())
warn("diagnostic example", true)
assert(here() == 4, "unexpected module output")

emit.u8(0x44)
```

`repeat.inc`:

```text
emit.u8(0x11)
```

`module/once.inc`:

```text
include("nested.inc")
emit.u8(0x22)
```

`module/nested.inc`:

```text
emit.u8(0x33)
```

The output is:

```text
11 11 33 22 44
```

`repeat.inc` runs twice. `module/once.inc` runs once, and its nested include is
resolved relative to the `module` directory.

### Chapter 6: Targets, ISA Text, and Symbols

#### Syntax Summary

| Form | Syntax | Result |
| --- | --- | --- |
| Target width | `target.bits` | Returns the active x86 mode or RISC-V XLEN. |
| Target family condition | `target.isa == .name` | Tests the active ISA family in `if`. |
| x86 mode | `x86.use16()`, `x86.use32()`, `x86.use64()` | Selects x86 and its mode. |
| RISC-V mode | `riscv.use32()`, `riscv.use64()` | Selects RISC-V and its XLEN. |
| SPIR-V module | `spv.use()` | Selects SPIR-V 1.6 complete-module output. |
| Generated ISA text | `isa(text)` | Appends one instruction from a text value. |
| Logical origin | `origin(address)` | Sets the base address of the active output region. |
| Current address | `here()` | Returns the current logical address. |
| Dynamic label | `label.define(name)` | Defines a label from a text value. |
| Label address | `label_addr(name)` | Returns a label or absolute symbol address. |

#### Target Queries

`target.bits` is an integer expression. For x86 it is the current instruction
mode, and for RISC-V it is the current XLEN:

```asm
if target.isa == .x86_64 {
    assert(target.bits == 64)
    emit.u8(target.bits)
}
```

SPIR-V has no target-wide integer bit width, so `target.bits` is not available
for that target.

`target.isa` is a target-condition form rather than a general value expression.
Use it as the left side of `==` or `!=` in a source `if`:

```text
if target.isa == .x86_64 { ... }
if target.isa != .riscv64 { ... }
if target.isa == .spirv { ... }
```

The accepted family literals are `.x86_64`, `.riscv64`, and `.spirv`. The
family name does not change with its width: x86 16-, 32-, and 64-bit modes all
use `.x86_64`, while RISC-V XLEN 32 and 64 both use `.riscv64`.

#### Selecting an Instruction Mode

The mode procedures select the target stored on subsequent ISA instruction
fragments. Instructions already recorded keep their earlier target.

| Call | Subsequent ISA text |
| --- | --- |
| `x86.use16()` | x86 16-bit mode |
| `x86.use32()` | x86 32-bit mode |
| `x86.use64()` | x86-64 mode |
| `riscv.use32()` | RISC-V with XLEN 32 |
| `riscv.use64()` | RISC-V with XLEN 64 |
| `spv.use()` | SPIR-V 1.6 module text |

```asm
x86.use16()
isa("mov ax, 0x1234")

x86.use32()
isa("mov eax, 0x12345678")

x86.use64()
isa("mov rax, 0x0102030405060708")

riscv.use32()
isa("addi x1, x0, 1")

riscv.use64()
isa("addi x2, x0, 2")
```

These procedures are ordinary source operations. They do not change the
meaning of earlier instructions and are not finalizer operations.

`spv.use()` begins a complete SPIR-V module. SPIR-V lines use standard `Op*`
spelling and numeric or symbolic result IDs:

```asm
spv.use()

OpCapability Shader
OpMemoryModel Logical GLSL450
%1 = OpTypeVoid
```

The complete output must contain only SPIR-V ISA fragments in one section and
at one version. Mixing SPIR-V with another ISA, emitted data, reservations, or
alignment operations is rejected.

An `IdResult` may be written as a literal number or as a name. A literal keeps the
number it was written with. A name is numbered from 1 upward in order of first
appearance, skipping numbers literals already use; a forward reference such as
`OpEntryPoint GLCompute %main "main"` therefore resolves even though the
`OpFunction` line defining `%main` comes later. The module header bound covers
both. A name that is never defined anywhere in the module, and a name defined
more than once, are both rejected with the line that caused it; the number a name
received is not reported, so read it from the emitted module or from the
first-appearance rule. CLI `--isa spv` and
`--isa spirv` (older spelling `--target`) both select version 1.6.

#### Generated ISA Text

`isa(text)` accepts exactly one non-empty, single-line text value:

```asm
const instruction = "nop"
isa(instruction)
```

Use normal ISA lines when the instruction is fixed in the source. Use `isa`
when compile-time logic produces the instruction text. The instruction is
parsed and encoded under the target active at the call site.

ISA text does not use the Meta-language statement terminator. Do not append
`;` to a normal instruction line or include it in the string passed to `isa`:

```text
nop;          // Invalid ISA text.
isa("nop;")   // Invalid ISA text.
```

An empty string, a value of another type, text containing a line break, or
text ending in a semicolon is invalid.

#### Logical Origins and the Current Address

`origin(address)` changes the logical base of the active output region. It does
not emit bytes, insert padding, or change the raw file offset.

`here()` returns:

```text
active region origin + current logical offset
```

```asm
origin(0x4000)

header:
emit.u16(0x1234)

assert(here() == 0x4002)
assert(label_addr(header) == 0x4000)
```

Call `origin` before defining addresses that depend on the new base. It is
available in ordinary source and late layout, but it cannot run in `defer`.

#### Static and Dynamic Labels

A source label defines a fixed name:

```text
entry:
```

`label.define(name)` defines the same kind of anchored label from a text value:

```asm
origin(0x5000)

const generated_name = "generated_entry"
label.define(generated_name)
emit.u8(0xaa)

assert(label_addr(generated_name) == 0x5000)
```

The generated name must be a valid label identifier. `label.define` is an
ordinary source operation and requires an open output region.

`label_addr` accepts either a bare label name or a text expression:

```text
label_addr(entry)
label_addr("entry")
label_addr(generated_name)
```

Unknown symbols are rejected. Value bindings are not labels and do not gain an
address through `label_addr`.

#### Address Stability Across ISA Encoding

Data, reserve, and alignment operations update the ordinary source cursor
immediately. ISA instructions are recorded first and encoded later. A label
after ISA text is anchored to its source position and receives its final
offset after instruction encoding and relaxation.

Do not hard-code an ordinary `label_addr` result into data when the label
depends on preceding ISA instruction sizes. Emit a fixed-width placeholder and
patch it in `defer`:

```asm
origin(0x4000)

target_field:
emit.u64(0)

    jmp done
done:
    ret

defer {
    store.u64(target_field, label_addr(done))
}
```

During `defer`, layout and instruction sizes are stable, so `label_addr(done)`
is the final logical address. This rule also applies to dynamically named
labels placed after ISA instructions.

### Chapter 7: Emission, Reservation, and Alignment

#### Syntax Summary

| Form | Syntax | Result |
| --- | --- | --- |
| Fixed-width integer | `emit.u8(value)` through `emit.u64(value)` | Emits one little-endian integer. |
| Fixed-width float | `emit.f32(value)`, `emit.f64(value)` | Emits one little-endian IEEE-754 value. |
| Data sequence | `db`/`dw`/`dd`/`dp`/`dq`/`dt`/`ddq`/`dqq`/`ddqq` | Emits integer elements of width 1 through 64 bytes. |
| Byte sequence | `emit.bytes(value)` | Emits a string or `bytes` value unchanged. |
| File bytes | `emit.file(path, offset?, count?)` | Emits a complete source-relative file or exact range. |
| Byte reserve | `reserve(count)` | Reserves `count` logical bytes. |
| Element reserve | `rb`/`rw`/`rd`/`rp`/`rq`/`rt`/`rdq`/`rqq`/`rdqq` | Reserves elements of width 1 through 64 bytes. |
| Fixed padding | `pad(count, fill?)` | Emits exactly `count` fill bytes. |
| Absolute padding | `pad_to(position, fill?)` | Emits until the active region reaches `position`. |
| Alignment | `align(boundary, fill?)` | Advances to the next aligned position. |

#### Fixed-Width Integer Emission

The `emit.u*` procedures accept one unsigned integer and write it in
little-endian order:

| Call | Accepted range | Bytes written |
| --- | --- | --- |
| `emit.u8(value)` | `0` through `0xff` | 1 |
| `emit.u16(value)` | `0` through `0xffff` | 2 |
| `emit.u32(value)` | `0` through `0xffffffff` | 4 |
| `emit.u64(value)` | `0` through `0xffffffffffffffff` | 8 |

```asm
emit.u8(0x11)
emit.u16(0x2233)
emit.u32(0x44556677)
emit.u64(0x8899aabbccddeeff)
```

The output begins:

```text
11 33 22 77 66 55 44 ff ee dd cc bb aa 99 88
```

Values outside the selected width are rejected rather than truncated.

#### Data Sequences

The data aliases accept one or more arguments:

| Call | Element width | Accepted arguments |
| --- | --- | --- |
| `db(values...)` | 1 byte | Integers, strings, and `bytes` values |
| `dw(values...)` | 2 bytes | Integers |
| `dd(values...)` | 4 bytes | Integers |
| `dp(values...)` | 6 bytes | Integers |
| `dq(values...)` | 8 bytes | Integers |
| `dt(values...)` | 10 bytes | Integers, zero-extended from `u64` |
| `ddq(values...)` | 16 bytes | Integers, zero-extended from `u64` |
| `dqq(values...)` | 32 bytes | Integers, zero-extended from `u64` |
| `ddqq(values...)` | 64 bytes | Integers, zero-extended from `u64` |

```asm
db(0x10, "AZ", b"BC")
dw(0x1234, 0xabcd)
dd(0x10203040)
dq(0x0102030405060708)
```

Strings and byte sequences passed to `db` are copied byte for byte. Wider
aliases require integers and encode every element in little-endian order.
Calling a data alias without arguments is invalid.

Values narrower than eight bytes are range-checked and never truncated. `dt`
is raw 10-byte data, not an `f80` or x87 value. Use `emit.bytes` for exact wide
bit patterns.

#### Floating-Point Emission

Decimal fractional and exponent literals are `f64`. `f32(value)` explicitly
narrows a finite `f64`; `f64(value)` widens `f32` or preserves `f64`.

```asm
const compact: f32 = f32(1.5)
emit.f32(compact)
emit.f64(-0.0)
```

`emit.f32` and `emit.f64` require exact matching types and write IEEE-754 bits
in little-endian order. There is no implicit integer conversion or `f80`
surface. NaN, Infinity, and overflow are rejected; finite underflow and signed
zero are preserved.

#### Byte Sequences

`emit.bytes(value)` accepts one string or `bytes` value:

```asm
const signature = b"XIR"
emit.bytes(signature)
emit.bytes("ASM")
```

No terminator, length field, or encoding conversion is added. Use `db` when a
single call must combine text, byte sequences, and integer byte values.

#### Reserved Storage

`reserve(count)` advances the logical position by `count` bytes. The aliases
express the count in fixed-width elements:

| Call | Logical bytes reserved |
| --- | --- |
| `rb(count)` | `count` |
| `rw(count)` | `count * 2` |
| `rd(count)` | `count * 4` |
| `rp(count)` | `count * 6` |
| `rq(count)` | `count * 8` |
| `rt(count)` | `count * 10` |
| `rdq(count)` | `count * 16` |
| `rqq(count)` | `count * 32` |
| `rdqq(count)` | `count * 64` |

```asm
db(0xaa)
reserve(3)
db(0xbb)

tail_start:
rq(2)
tail_end:

assert(tail_end - tail_start == 16)
```

A reserve followed by initialized output becomes a zero-filled middle gap. A
reserve at the end of an output region can remain logical storage without
adding bytes to the file. Chapter 8 describes the real and potential file
cursors that control this distinction.

Reserve arithmetic is checked. A count whose scaled byte size cannot be
represented is rejected.

#### Padding and Alignment

Padding always emits initialized bytes. The optional fill value defaults to
zero and must fit in one byte.

```asm
db(0x11, 0x22)
pad(2, 0xaa)
pad_to(8, 0xbb)
align(16, 0xcc)
db(0x33)
```

`pad(count, fill)` writes exactly `count` bytes.

`pad_to(position, fill)` treats `position` as a file position relative to the
active output region. Its starting point is the next committed raw file
position, so a preceding reserve is accounted for exactly once. The target
cannot be behind that position.

`align(boundary, fill)` advances the logical and file positions to the next
multiple of `boundary`. The boundary must be a non-zero power of two. If the
current position is already aligned, it emits no bytes.

Use reserve for logical uninitialized storage. Use padding or alignment when
the fill bytes are part of the file format.

### Chapter 8: Regions, Output Areas, and Cursors

#### Syntax Summary

| Form | Syntax | Result |
| --- | --- | --- |
| Explicit region | `region.begin(name, origin, file_offset)` | Starts a main output region with explicit logical address basis and FOA. |
| File-size alignment | `region.file_align(boundary)` | Aligns and closes the active region's raw file size. |
| Preserve tail reserve | `output.org(name, origin)` | Starts a main output area after the active tail reserve. |
| Trim tail reserve | `output.section(name, origin)` | Starts a main output area at the committed raw file tail. |
| Virtual area | `virtual.begin([origin])` | Starts a nested area that has logical addresses but no file bytes. |
| End virtual area | `virtual.end()` | Returns to the output area active before `virtual.begin`. |
| Region origin | `region_base()` | Returns the active region's logical base address. |
| Current file position | `file_offset()` | Returns the committed absolute FOA for the active region. |
| Real file cursor | `file_cursor_real()` | Returns the next committed FOA. |
| Potential file cursor | `file_cursor_potential()` | Returns the FOA if the active tail reserve were kept as file zeros. |
| Tail reserve | `tail_reserve_size()` | Returns active tail reserve bytes not yet in the raw file. |

#### Logical Address and Raw File Offset

Main output regions maintain independent logical address and raw file offset
facts:

| Fact | Meaning |
| --- | --- |
| Logical address | The address used by labels, `here()`, instructions, and fixups. |
| Committed FOA | The raw file position after bytes currently known to enter the output. |
| Tail-reserve FOA | The raw file position that would result if the active tail reserve were kept as file zeros. |

For an active main region:

```text
here()                  = region_base() + logical offset
file_cursor_real()      = region FOA + committed relative offset
file_cursor_potential() = region file offset + logical offset
tail_reserve_size()     = logical bytes beyond the committed relative offset
```

`file_offset()` is the ordinary name for the current committed FOA. It returns
the same value as `file_cursor_real()`.

Initialized bytes advance both logical address and committed FOA. A trailing
reserve advances only logical address:

```asm
region.begin("payload", 0x4000, 0x20)

emit.u8(0x11)
reserve(3)

assert(region_base() == 0x4000)
assert(here() == 0x4004)
assert(file_offset() == 0x21)
assert(file_cursor_real() == 0x21)
assert(file_cursor_potential() == 0x24)
assert(tail_reserve_size() == 3)
```

If initialized output follows the reserve in the same region, the intervening
gap becomes raw file zeros. The committed FOA then catches up before advancing
past the new bytes.

#### Starting an Explicit Region

`region.begin(name, origin, file_offset)` starts a new main output region:

- `name` identifies the region for diagnostics and layout facts.
- `origin` is its logical base address.
- `file_offset` is its absolute starting position in the output file.

The new region begins with zero relative logical and file cursors. The
arguments are independent, so a format can map a compact file range at a
different virtual address.

`region.begin` does not infer continuity from the previous region. Use the
cursor queries before the call when the new region must continue an existing
layout.

#### Choosing the Next FOA

`output.section(name, origin)` and `output.org(name, origin)` both start a new
main output area and assign it a new logical origin. They differ in the file
position selected from the previous area:

| Procedure | New file position | Effect on a trailing reserve |
| --- | --- | --- |
| `output.section` | Previous committed FOA | Keeps the tail reserve out of the raw file. |
| `output.org` | FOA after the reserve | Preserves the tail as raw file zeros when later bytes are emitted. |

```asm
region.begin("header", 0x4000, 0x20)
emit.u8(0x11)
reserve(3)

output.section("trimmed", 0x5000)
assert(file_offset() == 0x21)
emit.u8(0x22)
reserve(2)

output.org("preserved", 0x6000)
assert(file_offset() == 0x24)
emit.u8(0x33)
```

The first switch places `trimmed` immediately after byte `0x11`; the
three-byte trailing reserve is not written. The second switch starts after the
reserve, so the two reserved bytes between `0x22` and `0x33` become a middle
file gap.

Both procedures require an open main output region. They are invalid inside a
virtual area.

#### Aligning Raw Size

`region.file_align(boundary)` rounds the active region's raw file size up to a
non-zero power-of-two boundary and closes that region for further output:

```asm
region.begin("record", 0x8000, 0)
emit.u8(0x7f)
region.file_align(8)

assert(file_cursor_real() == 8)
assert(file_cursor_potential() == 1)
```

The aligned raw tail is part of the file and is zero-filled. Alignment can
therefore move the committed FOA beyond the logical-position-derived FOA. Once
the call succeeds, emitting, reserving, or aligning more data in that region is
invalid. Start another region or output area to continue.

#### Virtual Output Areas

`virtual.begin()` starts a nested logical area at the current logical address.
`virtual.begin(origin)` uses an explicit logical origin. Virtual output can
define labels, reserve storage, and hold temporary bytes, but it contributes
no bytes to the final file.

```asm
region.begin("main", 0x7000, 0)
emit.u8(0xaa)

virtual.begin()
assert(region_base() == 0x7001)
emit.u16(0x1234)
reserve(2)
assert(here() == 0x7005)
virtual.end()

assert(region_base() == 0x7000)
assert(here() == 0x7001)
emit.u8(0xbb)
```

The final file contains only `aa bb`. `virtual.end()` restores the previous
output area and its cursors. Virtual areas may be nested, but every
`virtual.begin` must have a matching `virtual.end`.

File-cursor queries describe real output, not final placement for a virtual
area. Use logical addresses and labels while the virtual area is active, then
explicitly copy virtual bytes into a real region if they should enter the file.

#### Error Conditions

The region APIs reject:

- a zero or non-power-of-two `region.file_align` boundary;
- output after `region.file_align` has closed the active region;
- `output.section` or `output.org` while a virtual area is active;
- `virtual.end` without a matching begin;
- a source file that ends with an unclosed virtual area.

### Chapter 9: Loads, Stores, and Final Region Facts

#### Syntax Summary

| Form | Syntax | Result |
| --- | --- | --- |
| Load integer | `load.u8(address)` | Reads one byte. |
| Load integer | `load.u16(address)` | Reads a little-endian 16-bit integer. |
| Load integer | `load.u32(address)` | Reads a little-endian 32-bit integer. |
| Load integer | `load.u64(address)` | Reads a little-endian 64-bit integer. |
| Load bytes | `load.bytes(address, count)` | Returns `count` bytes. |
| Store integer | `store.u8(address, value)` | Writes one byte. |
| Store integer | `store.u16(address, value)` | Writes a little-endian 16-bit integer. |
| Store integer | `store.u32(address, value)` | Writes a little-endian 32-bit integer. |
| Store integer | `store.u64(address, value)` | Writes a little-endian 64-bit integer. |
| Store bytes | `store.bytes(address, value)` | Writes a string or byte sequence. |
| Region file offset | `region_file_offset(address)` | Returns the final FOA of a region. |
| Region file size | `region_file_size(address)` | Returns the final raw file size of a region. |
| Region logical size | `region_logical_size(address)` | Returns the final logical size of a region. |

#### Ordinary and Final Output Access

Load and store operations can access two different representations:

| Phase | Addressed data |
| --- | --- |
| Ordinary source evaluation | Bytes already present in the current module layout. |
| `defer` finalization | Bytes in the stable final output image. |

An ordinary store can initialize or replace bytes after their storage has been
emitted. A deferred store is intended for fields that depend on final layout,
such as sizes, offsets, checksums, and directory entries.

```asm
region.begin("data", 0x3000, 0)

byte_slot:
emit.u8(0)

word_slot:
emit.u16(0)

dword_slot:
emit.u32(0)

qword_slot:
emit.u64(0)

bytes_slot:
db(0, 0, 0)

store.u8(byte_slot, 0xaa)
store.u16(word_slot, 0x2233)

assert(load.u8(byte_slot) == 0xaa)
assert(load.u16(word_slot) == 0x2233)

defer {
    store.u32(dword_slot, 0x44556677)
    store.u64(qword_slot, 0x0102030405060708)
    store.bytes(bytes_slot, b"XYZ")

    assert(load.u8(byte_slot) == 0xaa)
    assert(load.u16(word_slot) == 0x2233)
    assert(load.u32(dword_slot) == 0x44556677)
    assert(load.u64(qword_slot) == 0x0102030405060708)
    assert(load.bytes(bytes_slot, 3) == b"XYZ")
}
```

The integer forms accept only values representable by their stated width.
Loads and stores must remain within bytes that exist in the current or final
output image. They do not allocate storage, extend a region, or change layout.

#### Labels and Output-Area Identity

A logical address is not always enough to identify file bytes. Two output
areas may use overlapping logical ranges while occupying different raw file
ranges.

When a load, store, or region-fact expression directly contains a label,
XIRASM preserves the label's output-area identity and combines it with the
logical address. This selects the correct raw file range even when another
area uses the same address.

```asm
region.begin("outer", 0x1000, 0)

outer:
emit.u32(0x44332211)
reserve(4)

output.section("inner", 0x1002)

inner:
emit.u16(0x6655)

defer {
    assert(region_file_offset(outer) == 0)
    assert(region_file_size(outer) == 4)
    assert(region_logical_size(outer) == 8)

    assert(region_file_offset(inner) == 4)
    assert(region_file_size(inner) == 2)
    assert(region_logical_size(inner) == 2)

    assert(load.u16(inner) == 0x6655)
    store.u16(inner, 0x8877)
    assert(load.u16(inner) == 0x8877)
    assert(load.u16(outer + 2) == 0x4433)
}
```

Here, `outer + 2` and `inner` have the same logical address. Their labels retain
different output-area identities, so they refer to different bytes.

A plain integer carries no output-area identity. If logical ranges can overlap,
keep the label in the access expression instead of first converting it to a
numeric variable or function parameter.

#### Final Region Facts

The three region-fact expressions are available only after layout and output
materialization are stable, normally inside `defer`:

| Expression | Meaning |
| --- | --- |
| `region_file_offset(label)` | Absolute FOA where the region begins in the file. |
| `region_file_size(label)` | Number of raw file bytes owned by the region, including file-size alignment. |
| `region_logical_size(label)` | Logical address span of the region, including a trailing reserve. |

The distinction is important for uninitialized storage. In the preceding
example, `outer` has a logical size of eight bytes but a file size of four.
`output.section` begins `inner` at the real file cursor, so the four-byte
trailing reserve is not written to the file.

The reserved addresses remain part of the logical span, but they are not
loadable or writable final-image bytes. A finalizer cannot use load or store to
turn a trimmed tail into raw file output.

#### Address and Range Errors

These APIs reject:

- an integer store value that does not fit the selected width;
- a load or store that extends beyond existing raw file bytes;
- access to a trailing reserve removed from the raw file layout;
- a region-fact query before final output is stable;
- a region-fact query whose address does not belong to a final logical region;
- a label expression that combines labels from different output areas.

Use emission, reservation, and region procedures to define layout. Use load,
store, and final region facts only to inspect or backfill storage that the
layout has already established.

## Part III: Meta Helper Library

### Chapter 10: Text, Conversion, and Symbol Names

#### Syntax Summary

| Function | Result | Description |
| --- | --- | --- |
| `lengthof(value)` | `u64` | Returns a byte length or an integer's decimal digit count. |
| `len(value)` | `u64` | Returns the number of bytes, list items, or map entries. |
| `to_string(value)` | `string` | Converts an integer, Boolean, string, or bytes value to text. |
| `trim(text)` | `string` | Removes ASCII space, tab, carriage return, and line feed at both ends. |
| `lower(text)` | `string` | Converts ASCII letters to lowercase. |
| `upper(text)` | `string` | Converts ASCII letters to uppercase. |
| `starts_with(text, prefix)` | `bool` | Tests a string prefix. |
| `ends_with(text, suffix)` | `bool` | Tests a string suffix. |
| `contains(value, needle)` | `bool` | Searches a string or byte sequence. |
| `replace(text, needle, replacement)` | `string` | Replaces every non-overlapping string match. |
| `split(text, separator)` | `list` | Splits a string into a list of strings. |
| `join(parts, separator)` | `string` | Joins a list of strings. |
| `sym.join(parts...)` | `string` | Converts and concatenates values without a separator. |
| `sym.unique(prefix)` | `string` | Returns a distinct generated name for the current assembly. |

All functions in this chapter are ordinary Meta expressions. They create new
values and do not modify their inputs.

#### Length Queries

`lengthof` and `len` answer different questions:

| Input | `lengthof` | `len` |
| --- | --- | --- |
| `string` | Byte length | Byte length |
| `bytes` | Byte length | Byte length |
| unsigned integer | Number of decimal digits | Not accepted |
| `list` | Not accepted | Number of items |
| `map` | Not accepted | Number of entries |

Strings are measured in bytes. The functions do not count Unicode code points.
For an integer, `lengthof(0)` is one because its decimal text is `"0"`.

```asm
assert(lengthof(4096) == 4)
assert(lengthof("XIRASM") == 6)
assert(len(split("code::data::", "::")) == 3)

db(to_string(lengthof(4096)))
```

The output is the ASCII byte `0x34`, representing the text `"4"`.

#### Conversion to Text

`to_string(value)` uses these conversions:

| Input | Text form |
| --- | --- |
| integer | Unsigned decimal |
| Boolean | `"true"` or `"false"` |
| string | An unchanged copy |
| bytes | Lowercase hexadecimal, two digits per byte |

```asm
assert(to_string(42) == "42")
assert(to_string(true) == "true")
assert(to_string("ready") == "ready")
assert(to_string(b"AZ") == "415a")
```

Struct, list, and map values are not converted implicitly. Convert their
individual fields or elements instead.

#### Text Transformation and Search

`trim`, `lower`, and `upper` operate on ASCII text. `trim` recognizes only
space, horizontal tab, carriage return, and line feed as surrounding
whitespace. Case conversion leaves non-ASCII bytes unchanged.

`starts_with` and `ends_with` accept strings. `contains` accepts either two
strings or two byte sequences; the two arguments must use the same value kind.

```asm
const name: string = lower(trim("  Kernel32.DLL  "))

assert(name == "kernel32.dll")
assert(starts_with(name, "kernel"))
assert(ends_with(name, ".dll"))
assert(contains(name, "32"))

db(name)
```

#### Replacement, Splitting, and Joining

`replace` substitutes every non-overlapping occurrence of `needle`.
`needle` must not be empty.

`split` divides a string at every occurrence of a non-empty separator. Empty
fields are preserved, including fields created by adjacent separators or a
trailing separator. An empty input string therefore produces a one-item list
containing an empty string.

`join` requires a list whose every item is a string. An empty list produces an
empty string.

```asm
const fields: list = split("red::green::", "::")

assert(len(fields) == 3)
assert(join(fields, "|") == "red|green|")
assert(replace("one fish, one fish", "one", "two") == "two fish, two fish")

db(join(fields, "|"))
```

#### Constructing Symbol Names

`sym.join(parts...)` converts each argument using the same scalar and byte
rules as `to_string`, then concatenates the results without inserting a
separator:

```asm
const slot: string = sym.join("_slot_", 12, "_", true)

assert(slot == "_slot_12_true")
label.define(slot)
emit.u8(0xaa)
```

Use explicit punctuation in the arguments when a separator is required.

`sym.unique(prefix)` returns a different generated string for each call in the
current assembly. The order is deterministic, but the suffix format is not a
source-level contract. Keep the returned string and use it consistently rather
than reconstructing the name.

```asm
const first: string = sym.unique("_temporary")
const second: string = sym.unique("_temporary")

assert(first != second)

label.define(first)
emit.u8(0x11)

label.define(second)
emit.u8(0x22)
```

`sym.unique` guarantees uniqueness, not label syntax. When the result is passed
to `label.define`, choose a prefix that makes the complete result a valid label
name.

#### Error Conditions

These helpers reject:

- `lengthof` values other than strings, bytes, and unsigned integers;
- `len` values other than strings, bytes, lists, and maps;
- aggregate values passed to `to_string` or `sym.join`;
- mixed string and bytes arguments to `contains`;
- an empty `replace` needle or `split` separator;
- a `join` list containing a non-string item;
- a generated name that does not satisfy `label.define` when used as a label.

### Chapter 11: Byte Sequences

#### Syntax Summary

| Function | Result | Description |
| --- | --- | --- |
| `bytes.new()` | `bytes` | Creates an empty byte sequence. |
| `bytes.push(value, byte)` | `bytes` | Appends one byte. |
| `bytes.concat(left, right)` | `bytes` | Concatenates two byte sequences. |
| `bytes.repeat(count, byte)` | `bytes` | Creates `count` copies of one byte. |
| `bytes.le(value, width)` | `bytes` | Encodes the low `width` bytes of an integer in little-endian order. |
| `bytes.insert(value, index, addition)` | `bytes` | Inserts bytes at a zero-based index. |
| `bytes.replace(value, index, count, replacement)` | `bytes` | Replaces a byte range. |
| `bytes.eq(left, right)` | `bool` | Tests two byte sequences for exact equality. |
| `bytes.hex(value)` | `string` | Formats bytes as lowercase hexadecimal text. |
| `bytes.from_hex(text)` | `bytes` | Parses uppercase or lowercase hexadecimal text. |

Every operation returns a new value. Source byte sequences are never modified,
so an intermediate value may be reused in more than one construction.

#### Creating and Combining Bytes

`bytes.new()` returns an empty sequence. `bytes.push` appends one integer in the
range 0 through 255. `bytes.concat` joins two sequences, and `bytes.repeat`
creates a sequence filled with one byte.

```asm
const empty: bytes = bytes.new()
const tag: bytes = bytes.push(empty, 0x7f)
const padding: bytes = bytes.repeat(3, 0xaa)
const result: bytes = bytes.concat(tag, padding)

assert(len(empty) == 0)
assert(bytes.eq(result, bytes.from_hex("7faaaaaa")))

emit.bytes(result)
```

The original `empty` value remains empty after `bytes.push`.

#### Little-Endian Integer Encoding

`bytes.le(value, width)` produces between zero and eight bytes. The first byte
contains the least significant eight bits. When `width` is smaller than eight,
higher bits are discarded.

```asm
const magic: bytes = bytes.from_hex("58495200")
const version: bytes = bytes.le(3, 2)
const header: bytes = bytes.concat(magic, version)

assert(bytes.hex(header) == "584952000300")
assert(bytes.eq(bytes.le(0x1234, 1), bytes.from_hex("34")))
assert(bytes.eq(bytes.le(0x1234, 0), bytes.new()))

emit.bytes(header)
```

The integer is an unsigned compile-time value. `bytes.le` does not perform
signed extension or test whether discarded high bits are zero.

#### Inserting and Replacing Ranges

Byte indexes are zero-based. `bytes.insert(value, index, addition)` accepts any
index from zero through `len(value)`, including the position immediately after
the final byte.

`bytes.replace(value, index, count, replacement)` removes `count` bytes
beginning at `index`, then inserts `replacement` at that position:

- a zero `count` inserts without removing bytes;
- an empty replacement deletes the selected range;
- changing both values performs an ordinary replacement.

```asm
const base: bytes = b"ABC"
const marked: bytes = bytes.insert(base, 1, b"-")
const patched: bytes = bytes.replace(marked, 2, 1, b"Z")
const trailer: bytes = bytes.repeat(2, 0xff)
const result: bytes = bytes.concat(
    bytes.push(bytes.new(), 0x7f),
    bytes.concat(patched, trailer)
)

assert(bytes.eq(base, b"ABC"))
assert(bytes.eq(bytes.replace(b"AB", 1, 0, b"-"), b"A-B"))
assert(bytes.eq(bytes.replace(b"ABCD", 1, 2, bytes.new()), b"AD"))

emit.bytes(result)
```

This example emits `7f 41 2d 5a 43 ff ff`.

#### Hexadecimal Conversion and Equality

`bytes.from_hex` accepts an even number of hexadecimal digits. Letter digits
may be uppercase or lowercase, and every pair of characters produces one
byte. An empty string produces an empty byte sequence.

`bytes.hex` performs the reverse conversion and always uses lowercase digits.
Use `bytes.eq` when exact byte equality should be explicit.

```asm
const value: bytes = bytes.from_hex("DEadBEEF")
const text: string = bytes.hex(value)

assert(text == "deadbeef")
assert(bytes.eq(bytes.from_hex(text), value))
assert(bytes.eq(bytes.from_hex(""), bytes.new()))

emit.bytes(value)
```

#### Error Conditions

The byte helpers reject:

- a byte argument outside the range 0 through 255;
- a non-bytes value where a byte sequence is required;
- a `bytes.le` width greater than eight;
- an insertion index greater than the current length;
- a replacement range that extends beyond the current length;
- hexadecimal text with an odd number of characters;
- hexadecimal text containing a non-hexadecimal character;
- an incorrect number of function arguments.

### Chapter 12: Lists and Maps

Lists and maps are compile-time value collections. For incremental
construction, prefer the explicit mutation statements on direct `let`
bindings. Expression helpers that add, replace, or combine values still return
a new collection and leave every input unchanged; use them when a value-style
transform is clearer than step-by-step construction.

#### List Functions

| Function | Result | Description |
| --- | --- | --- |
| `list.new()` | `list` | Creates an empty list. |
| `list.of(values...)` | `list` | Creates a list from zero or more values. |
| `list.push(value, item)` | `list` | Appends one item. |
| `list.concat(left, right)` | `list` | Concatenates two lists. |
| `list.get(value, index)` | value | Returns the item at a zero-based index. |
| `list.set(value, index, item)` | `list` | Replaces one item. |
| `list.slice(value, start, count)` | `list` | Returns a contiguous range. |
| `list.eq(left, right)` | `bool` | Tests ordered, recursive list equality. |

The statement APIs mutate a direct `let` binding and return no value:

| Statement | Description |
| --- | --- |
| `list.push_mut(target, item);` | Appends a cloned item to `target`. |
| `list.set_mut(target, index, item);` | Replaces an existing item with a cloned value. |

`list.get` and `list.set` require an index smaller than the list length.
`list.slice` accepts a starting index from zero through the list length, but
the selected range must remain inside the list. A zero-length slice at the end
is valid.

```asm
let items: list = list.of(1, 2, 3)
list.push_mut(items, 4);
list.set_mut(items, 1, 0xaa);

const middle: list = list.slice(items, 1, 2)
const combined: list = list.concat(list.of(0x10, 0x11), middle)

assert(list.get(items, 1) == 0xaa)
assert(list.eq(items, list.of(1, 0xaa, 3, 4)))
assert(list.eq(middle, list.of(0xaa, 3)))

for value in combined {
    emit.u8(value)
}
```

This emits `10 11 aa 03`. List equality is order-sensitive and compares nested
lists, maps, structs, strings, and byte sequences recursively.

#### Map Functions

| Function | Result | Description |
| --- | --- | --- |
| `map.new()` | `map` | Creates an empty map. |
| `map.set(value, key, item)` | `map` | Adds or replaces a string-keyed entry. |
| `map.has(value, key)` | `bool` | Tests whether a string key exists. |
| `map.get(value, key)` | value | Returns the value for a required key. |
| `map.get_or(value, key, fallback)` | value | Returns a value or the supplied fallback. |
| `map.keys(value)` | `list` | Returns keys in insertion order. |
| `map.values(value)` | `list` | Returns values in matching insertion order. |
| `map.eq(left, right)` | `bool` | Tests recursive map equality without considering key order. |

`map.set_mut(target, key, item);` inserts or replaces a cloned value in a
direct `let`-bound map. The key must be a string. Replacing a key keeps its
insertion position.

Map keys are strings. Adding a new key appends an entry to the insertion order.
Replacing an existing key keeps its position. Consequently, `map.keys` and
`map.values` return parallel lists whose indexes refer to the same entries.

```asm
const empty: map = map.new()
let complete: map = map.new()
map.set_mut(complete, "arch", "x64");
map.set_mut(complete, "mode", 64);
map.set_mut(complete, "arch", "rv64");
map.set_mut(complete, "tags", list.of("asm", "dsl"));

assert(len(empty) == 0)
assert(map.has(complete, "arch"))
assert(!map.has(complete, "missing"))
assert(map.get(complete, "arch") == "rv64")
assert(map.get_or(complete, "missing", "default") == "default")
assert(list.eq(map.keys(complete), list.of("arch", "mode", "tags")))
assert(list.eq(map.get(complete, "tags"), list.of("asm", "dsl")))

let reordered: map = map.new()
map.set_mut(reordered, "tags", list.of("asm", "dsl"));
map.set_mut(reordered, "mode", 64);
map.set_mut(reordered, "arch", "rv64");

assert(map.eq(complete, reordered))
emit.u8(map.get(complete, "mode"))
```

This emits `40`. `map.eq` compares keys and nested values, but does not require
the maps to have the same insertion order.

#### Mutable Collection Binding Rules

The target of `list.push_mut`, `list.set_mut`, or `map.set_mut` must be a direct
identifier that resolves to the nearest `let` binding. The target cannot be a
`const`, temporary expression, call result, field access, or value of the wrong
collection type. Top-level `let` bindings are valid during ordinary lowering.
Inside a value function, only bindings local to that invocation may be
mutated. These statements are not expression calls and are unavailable in
`defer` and `late_layout` blocks.

Inserted values are deep-cloned before the mutation commits. A prior clone of
the target and a collection inserted into another target therefore remain
independent. Allocation failure leaves the target unchanged.

#### Error Conditions

The collection helpers reject:

- a non-list argument passed to a `list.*` operation;
- a non-map argument passed to a `map.*` operation;
- an incorrect number of function arguments;
- a list index outside the available elements;
- a list slice that extends beyond the list;
- a non-string map key;
- a missing key passed to `map.get`.

Use `map.has` or `map.get_or` when absence is expected.

### Chapter 13: Files and Structured Data

#### Syntax Summary

| Function | Result | Description |
| --- | --- | --- |
| `fs.exists(path)` | `bool` | Tests whether a file can be resolved. |
| `fs.read_text(path)` | `string` | Reads an entire file as text. |
| `fs.read_bytes(path)` | `bytes` | Reads an entire file as bytes. |
| `fs.read_bytes(path, offset, count)` | `bytes` | Reads an exact byte range. |
| `fs.list_dir(path)` | `list` | Lists the entry names of a directory in ascending byte order. |
| `fs.is_dir(path)` | `bool` | Tests whether a path names a directory. |
| `emit.file(path)` | statement | Emits an entire source-relative file. |
| `emit.file(path, offset, count)` | statement | Emits an exact file byte range. |
| `json.parse(value)` | value | Parses JSON held in a string or byte sequence. |
| `json.file(path)` | value | Reads and parses a JSON file. |
| `toml.parse(value)` | `map` | Parses a TOML document held in a string or byte sequence. |
| `toml.file(path)` | `map` | Reads and parses a TOML file. |

File paths use the same controlled resolver as `include` and `import`.
A relative path is interpreted from the source file containing the call.
Moving a call into a nested module therefore moves the base directory for its
relative data paths.

#### Availability by Phase

| Operation | Ordinary source | `late_layout` | `defer` |
| --- | --- | --- | --- |
| `fs.exists`, `fs.read_text`, `fs.read_bytes`, `emit.file` | Available | Unavailable | Unavailable |
| `fs.list_dir`, `fs.is_dir` | Available | Unavailable | Unavailable |
| `json.file`, `toml.file` | Available | Unavailable | Unavailable |
| `json.parse`, `toml.parse` | Available | Available in value expressions | Available in value expressions |

File operations require an active source resolver. Late-layout and deferred
execution do not reopen source files. Parse structured data during ordinary
source evaluation and retain the resulting value when it is needed later.

The `parse` functions do not access the filesystem. They operate only on the
provided string or bytes value.

#### Checking and Reading Files

`fs.exists` returns `false` when a path cannot be resolved. The read functions
instead report an error for a missing file.

`fs.read_text` preserves the complete file contents and does not add a
terminating zero byte. `fs.read_bytes` returns the same contents as a byte
sequence.

```asm
assert(fs.exists("payload.bin"))
assert(fs.exists("banner.txt"))
assert(!fs.exists("optional.bin"))

const header: bytes = fs.read_bytes("payload.bin", 0, 4)
const banner: string = fs.read_text("banner.txt")

emit.bytes(header)
emit.bytes(banner)
```

If `payload.bin` contains `XIR!` and `banner.txt` contains `ready` followed by
a line feed, the example emits:

```text
58 49 52 21 72 65 61 64 79 0a
```

The range overload uses a zero-based offset and a byte count. The complete
range must fit inside the file. A zero-length range at the end of a file is
valid.

`emit.file` uses the same resolver and range rules as `fs.read_bytes`, but
emits directly instead of returning a `bytes` value.

#### Listing a Directory

`fs.list_dir(path)` returns the entry names directly inside a directory as a
list of strings, sorted in ascending byte order so a listing never depends on
the order the filesystem happens to return. Names are entry names, not paths,
and directories appear like any other entry.

`fs.is_dir(path)` reports whether a path names a directory. Like `fs.exists` it
answers `false` for a path that cannot be resolved, while `fs.list_dir` reports
an error instead. Guard an optional scan with `fs.is_dir` when a missing
directory is acceptable:

```asm
const entries: list = fs.list_dir("assets")
assert(len(entries) == 2)
assert(list.get(entries, 0) == "logo.bin")
assert(list.get(entries, 1) == "notes")

for entry in entries {
    if fs.is_dir(sym.join("assets/", entry)) {
        continue;
    }
    emit.file(sym.join("assets/", entry));
}
```

Both functions use the same controlled resolver as the rest of this chapter: the
build supplies directory support, and a host that cannot enumerate directories
reports the path as unavailable rather than guessing.

#### JSON Values

JSON values become Meta values as follows:

| JSON value | Meta value |
| --- | --- |
| `null` | `void` |
| Boolean | `bool` |
| String | `string` |
| Non-negative integer | integer |
| Array | `list` |
| Object | `map` |

`json.file` reads and parses in one call. `json.parse` accepts either a string
or byte sequence that already contains JSON.

```asm
const config: map = json.file("config.json")
const parsed_again: map = json.parse(fs.read_bytes("config.json"))
const values: list = map.get(config, "values")

assert(map.eq(config, parsed_again))
assert(map.get(config, "enabled"))
assert(map.has(config, "nothing"))

emit.bytes(map.get(config, "name"))
emit.u8(map.get(config, "bits"))

for value in values {
    emit.u8(value)
}
```

For this input:

```json
{
  "name": "XR",
  "bits": 64,
  "enabled": true,
  "values": [1, 2],
  "nothing": null
}
```

the example emits `58 52 40 01 02`.

JSON floating-point values, negative integers, duplicate object keys, malformed
input, and integers outside the supported range are rejected.

#### TOML Values

TOML documents become maps. Nested tables become nested maps, arrays become
lists, and strings, booleans, and non-negative integers keep their
corresponding Meta value kinds.

```asm
const config: map = toml.file("config.toml")
const parsed_again: map = toml.parse(fs.read_text("config.toml"))
const target: map = map.get(config, "target")
const values: list = map.get(parsed_again, "values")

assert(map.eq(config, parsed_again))
assert(map.get(config, "enabled"))

emit.bytes(map.get(config, "name"))
emit.u8(map.get(target, "bits"))

for value in values {
    emit.u8(value)
}
```

For this input:

```toml
name = "XR"
enabled = true
values = [3, 4]

[target]
bits = 32
```

the example emits `58 52 20 03 04`.

Floating-point values, timestamps, negative integers, malformed documents, and
duplicate keys are rejected during conversion.

#### Error Conditions

These helpers reject:

- a non-string file path;
- a missing file passed to a read or `*.file` function;
- a byte range that extends outside the file;
- a non-string and non-bytes value passed to `json.parse` or `toml.parse`;
- malformed JSON or TOML;
- duplicate object or table keys;
- structured values that cannot be represented by the Meta value model;
- an incorrect number of function arguments.

Use `fs.exists` before a read only when absence is an expected condition.

### Chapter 14: Tokens and Pattern Matching

#### Syntax Summary

| Function | Signature | Result |
| --- | --- | --- |
| Tokenize source-like text | `tokens.of(source)` | `list` of token strings |
| Render token strings | `tokens.join(tokens)` | Canonical `string` |
| Match a token shape | `match.tokens(pattern, input)` | Result `map` |

`tokens.of` accepts either a string or an existing list of strings. A string is
tokenized; a list is validated and copied.

`tokens.join` accepts a list whose items are all strings.

`match.tokens` accepts either strings or lists of strings for both arguments.
When the pattern is a list, each item is one complete pattern piece. When the
input is a list, its items are matched directly without tokenizing again.

#### Tokenization

`tokens.of` is a lightweight tokenizer for source-shaped text. It separates
names, literals, punctuation, brackets, and operators while discarding
insignificant whitespace.

```asm
const input: list = tokens.of("load rax, [rbx + 4]")

assert(len(input) == 8);
assert(list.get(input, 0) == "load");
assert(list.get(input, 2) == ",");
assert(list.get(input, 3) == "[");
assert(tokens.join(input) == "load rax, [rbx+4]");

emit.u8(len(input));
emit.bytes(tokens.join(input));
```

This emits:

```text
08 6c 6f 61 64 20 72 61 78 2c 20 5b 72 62 78 2b 34 5d
```

Quoted text remains one token, including its quote characters. An unterminated
quoted token is invalid.

The tokenizer recognizes these two-character operators as single tokens:

```text
==  !=  <=  >=  &&  ||  <<  >>  ->  =>  ::
```

It also separates these single-character tokens:

```text
, ( ) [ ] { } < > : = + - * / % & | ^ ~ . ! ? ;
```

Other adjacent non-whitespace characters remain in the same token until a
quote or recognized operator begins.

#### Canonical Rendering

`tokens.join` produces canonical source-like text. It inserts spaces between
ordinary adjacent tokens and removes unnecessary spaces around brackets,
punctuation, and tight operators.

Canonical rendering is not a byte-for-byte reconstruction of the original
string:

```asm
const input: list = tokens.of("left  && middle ||  right")
assert(tokens.join(input) == "left&&middle||right");
```

Keep the original string when exact whitespace is significant.

#### Pattern Pieces

A token pattern is a whitespace-separated sequence of pieces. Every piece is
either an exact literal or a named capture.

| Piece | Meaning |
| --- | --- |
| `=token` | Match one exact token |
| `name:token` | Capture any one token as a string |
| `name:name` | Capture one identifier-like token as a string |
| `name:int` | Capture one integer token as an integer |
| `name:quoted` | Capture one quoted token as an unquoted string |
| `name:tokens` | Capture a balanced token range as a list |

The leading `=` is the literal marker. For example:

```text
=load  matches the token load
=,     matches the comma token
===    matches the == token
```

Capture names use identifier syntax and must be unique within the pattern.

#### Match Results

`match.tokens` returns a map with two entries:

| Key | Value |
| --- | --- |
| `"ok"` | Boolean indicating whether the entire input matched |
| `"captures"` | Map of capture names to captured values |

A successful match requires the complete pattern and complete input to be
consumed.

```asm
const result: map = match.tokens(
    "=load destination:name =, address:tokens",
    "load rax, [rbx+(rcx*4)]"
)

assert(map.get(result, "ok"));

const captures: map = map.get(result, "captures")
const destination: string = map.get(captures, "destination")
const address: list = map.get(captures, "address")

assert(destination == "rax");
assert(tokens.join(address) == "[rbx+(rcx*4)]");

emit.bytes(destination);
emit.bytes(tokens.join(address));
```

This emits:

```text
72 61 78 5b 72 62 78 2b 28 72 63 78 2a 34 29 5d
```

Check `"ok"` before reading named captures. A non-match returns `false` and an
empty capture map.

#### Capture Values

`token` and `name` captures return strings. `token` accepts any one token;
`name` requires an identifier beginning with an ASCII letter or underscore,
followed by ASCII letters, digits, or underscores.

`int` parses one token as an unsigned integer using the usual numeric prefixes:

```asm
const result: map = match.tokens(
    "=set target:name =, value:int",
    "set count, 0x2a"
)
const captures: map = map.get(result, "captures")

assert(map.get(result, "ok"));
assert(map.get(captures, "target") == "count");
assert(map.get(captures, "value") == 42);
```

`quoted` accepts either single or double quotes, removes the delimiters, and
decodes the same escape set string and byte literals use: `\n`, `\r`, `\t`,
`\0`, `\\`, `\uXXXX` for one code point, and the quote that opened the token.
Every other backslash is not an escape, so both characters are kept as written.

`tokens` returns a list of token strings. It may capture zero or more tokens.
Parentheses, brackets, and braces inside the captured range must remain
balanced.

#### Minimal Matching and Backtracking

A `tokens` capture initially consumes the shortest balanced range. If later
pattern pieces do not match, it expands and tries again:

```asm
const result: map = match.tokens(
    "prefix:tokens value:int",
    "name 42"
)
const captures: map = map.get(result, "captures")

assert(map.get(result, "ok"));
assert(tokens.join(map.get(captures, "prefix")) == "name");
assert(map.get(captures, "value") == 42);
```

Comparison operators `<` and `>` are normal tokens, not grouping delimiters.
Only `()`, `[]`, and `{}` participate in balance checks.

Patterns do not contain an alternatives operator. Try complete patterns in
normal `if`/`else` control flow when an input may have several valid shapes.

#### Misses and Invalid Patterns

These conditions are ordinary misses and return `"ok" == false`:

- an exact literal differs;
- a typed capture receives an unsuitable token;
- a `tokens` capture cannot form a balanced range;
- the pattern ends before the input;
- the input ends before the pattern.

These conditions reject the call as an invalid expression:

- a pattern piece is neither a literal nor a capture;
- a literal marker has no following token;
- a capture name is invalid or duplicated;
- a capture kind is unknown;
- a quoted input token is unterminated;
- an argument is not a string or list of strings;
- `tokens.join` receives a list containing a non-string value;
- an incorrect number of arguments is supplied.

#### Limits

Token matching has fixed limits to keep compile-time parsing bounded:

| Limit | Maximum |
| --- | --- |
| Pattern pieces | 64 |
| Input tokens | 256 |
| Match attempts | 4096 |
| Nested bracket depth | 64 |

Exceeding a limit rejects the match call rather than returning an ordinary
miss.

### Chapter 15: Crypto Helpers

#### Syntax Summary

| Function | Result | Description |
| --- | --- | --- |
| `crypto.crc32(input)` | integer | Computes the CRC-32 (IEEE 802.3) checksum. |
| `crypto.adler32(input)` | integer | Computes the Adler-32 checksum (RFC 1950). |
| `crypto.sha1(input)` | `bytes` | Computes the 20-byte SHA-1 digest. |
| `crypto.sha256(input)` | `bytes` | Computes the 32-byte SHA-256 digest. |

`input` accepts a `bytes` value or a `string`, which contributes its byte
sequence. The helpers are pure expression calls and are available wherever
value expressions are, including inside deferred finalizers.

Checksum helpers return unsigned integers. Digest helpers return a new
byte sequence.

```asm
const payload: bytes = b"123456789"
const crc: u64 = crypto.crc32(payload)
const digest: bytes = crypto.sha256(payload)

assert(crc == 0xcbf43926);
assert(len(digest) == 32);

emit.u32(crc);
emit.bytes(digest);
```

The computation runs at native speed. Use these helpers instead of
checksum loops written in Meta; a megabyte payload hashes immediately
instead of spending compile time in a per-byte scan.

#### Error Conditions

- an argument that is neither a `bytes` value nor a `string`;
- an incorrect number of arguments.

### Chapter 16: Compression

#### Syntax Summary

| Function | Result | Description |
| --- | --- | --- |
| `deflate.compress(input)` | `bytes` | Compresses at the default level. |
| `deflate.compress(input, level)` | `bytes` | Compresses at a level from 1 (fastest) to 9 (best). |
| `deflate.decompress(input)` | `bytes` | Decompresses a raw DEFLATE stream. |

`input` accepts a `bytes` value or a `string`, which contributes its byte
sequence. The result is a **raw DEFLATE** stream: the compressed blocks on their
own, with no zlib or gzip header and no checksum trailer. That is exactly what a
ZIP entry of method 8 stores, so the archive records the CRC-32 of the
*uncompressed* bytes and the sizes of both forms.

```asm
const text: bytes = b"XIRASM XIRASM XIRASM XIRASM"
const packed: bytes = deflate.compress(text)
const best: bytes = deflate.compress(text, 9)

assert(len(packed) < len(text));
assert(len(best) < len(text));
emit.u16(len(text));
emit.u16(len(packed));
```

Compression is deterministic: the same input and level produce the same stream
every time, which is what lets a format include build a reproducible archive.
Small inputs may grow slightly, because a stream carries its own block headers;
store a payload uncompressed when it does not shrink.

The level trades time for size. The default is level 6, which suits the payloads
an assembler stores; level 1 is useful for large, barely compressible inputs, and
level 9 for the smallest possible output when assembly time does not matter.

`deflate.decompress` is the inverse, for reading a stream this build produced or
one a data file carries:

```asm
const packed: bytes = deflate.compress(text)
const restored: bytes = deflate.decompress(packed)

assert(bytes.eq(restored, text));
```

A raw stream records no length, so the decoder runs until the stream's final
block and returns everything it decoded; a stream that ends early or contradicts
itself is reported as an invalid argument rather than a partial result. Because a
stream can expand far more than it weighs, decompression stops at 256 MiB and
reports the output as too large instead of consuming the machine.

#### Error Conditions

- an argument that is neither a `bytes` value nor a `string`;
- a level outside 1 through 9;
- an input that is not a valid DEFLATE stream, or one that decodes to more than
  256 MiB;
- an incorrect number of arguments.

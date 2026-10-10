// Capture token spans without losing the caller's expression bindings.
fn a64xs_numeric_shape(arg: operand) -> bool {
const text: string = trim(operand.text(arg))
if len(operand.split(arg)) != 1 || starts_with(text, "#") || starts_with(text, "[") || starts_with(text, "{") {
return false;
}
const parts: list = tokens.of(text)
if len(parts) == 0 {
return false;
}
return len(a64x_source_register(list.get(parts, 0))) == 0;
}
fn a64xs_sub(left: integer, right: integer) -> integer {
if left >= right {
return left - right;
}
return -(right - left);
}
fn a64xs_targetvalue(arg: operand, instruction_address: integer) -> integer {
const clean: operand = a64_number(arg)
const target: list = a64_parse_target(clean, true)
if list.get(target, 0) == 36 {
return label_addr(list.get(target, 1));
}
return operand.eval(clean);
}
fn a64xs_number(numbers: list, key: string) -> integer {
for pair in numbers {
if list.get(pair, 0) == key {
return list.get(pair, 1);
}
}
assert(false, "a64: missing captured numeric value")
return 0;
}
fn a64xs_float(numbers: list, key: string) -> f64 {
for pair in numbers {
if list.get(pair, 0) == key {
return f64(list.get(pair, 1));
}
}
assert(false, "a64: missing captured floating value")
return 0.0;
}
fn a64xs_prepare(args: list) -> list {
let input: list = list.new()
let spans: list = list.new()
let argindex: u64 = 0
for arg in args {
if argindex != 0 {
list.push_mut(input, ",");
list.push_mut(spans, list.new())
}
const text: string = operand.text(arg)
let offset: u64 = 0
for token in tokens.of(text) {
const width: u64 = len(token)
while offset + width <= len(text) && operand.text(operand.slice(arg, offset, offset + width)) != token {
offset = offset + 1
}
assert(offset + width <= len(text), "a64: token span is not representable")
let part: u64 = offset
let cursor: u64 = offset
while cursor < offset + width {
const char: string = operand.text(operand.slice(arg, cursor, cursor + 1))
if char == "#" || char == "." {
if cursor > part {
list.push_mut(input, lower(operand.text(operand.slice(arg, part, cursor))))
list.push_mut(spans, list.of(arg, argindex, part, cursor))
}
list.push_mut(input, char)
list.push_mut(spans, list.of(arg, argindex, cursor, cursor + 1))
part = cursor + 1
}
cursor = cursor + 1
}
if part < offset + width {
list.push_mut(input, lower(operand.text(operand.slice(arg, part, offset + width))))
list.push_mut(spans, list.of(arg, argindex, part, offset + width))
}
offset = offset + width
}
argindex = argindex + 1
}
return list.of(input, spans);
}
fn a64xs_capture(prepared: list, pieces: list, count: u64) -> list {
const result: map = match.tokens(pieces, list.get(prepared, 0))
if !map.get(result, "ok") {
return list.of(false, list.new());
}
const matches: map = map.get(result, "captures")
const spans: list = list.get(prepared, 1)
let captures: list = list.new()
let keys: list = list.new()
let index: u64 = 0
while index < count {
list.push_mut(captures, 0);
list.push_mut(keys, "");
index = index + 1
}
let position: u64 = 0
for piece in pieces {
if starts_with(piece, "=") {
position = position + 1
} else {
const names: list = split(piece, ":")
const name: string = list.get(names, 0)
const tokens: list = map.get(matches, name)
if len(tokens) == 0 {
return list.of(false, list.new());
}
const first: list = list.get(spans, position)
const last: list = list.get(spans, position + len(tokens) - 1)
if len(first) == 0 || len(last) == 0 {
return list.of(false, list.new());
}
if list.get(first, 1) != list.get(last, 1) {
return list.of(false, list.new());
}
const captured: operand = operand.slice(list.get(first, 0), list.get(first, 2), list.get(last, 3))
let start: u64 = list.get(first, 2)
const raw: operand = list.get(first, 0)
const end: u64 = list.get(last, 3)
while start < end && trim(operand.text(operand.slice(raw, start, start + 1))) == "" {
start = start + 1
}
if start < end && operand.text(operand.slice(raw, start, start + 1)) == "#" {
start = start + 1
}
while start < end && trim(operand.text(operand.slice(raw, start, start + 1))) == "" {
start = start + 1
}
const cache_key: string = sym.join(list.get(first, 1), ":", start, ":", end)
let slot: u64 = 0
while slot < count {
if name == sym.join("p", slot) {
list.set_mut(captures, slot, captured);
list.set_mut(keys, slot, cache_key)
}
slot = slot + 1
}
position = position + len(tokens)
}
}
return list.of(true, captures, keys);
}
// Numeric failures are overload misses; the selected public entry diagnoses them.
fn a64xs_encode_logical(value: integer, width: integer) -> integer {
if width == 32 {
return a64_scalar_special(value, "logical_immediate_w");
}
assert(width == 64, "a64: invalid logical immediate width")
return a64_scalar_special(value, "logical_immediate_x");
}
fn a64xs_encode_fp(value: f64) -> integer {
let magnitude: f64 = value
let sign: integer = 0
if value < 0.0 {
magnitude = -value
sign = 128
}
let index: integer = 0
for candidate in a64_fp_values {
if magnitude == candidate {
return sign | index;
}
index = index + 1
}
return 0xffffffffffffffff;
}

// Meta integers carry signed values as two's-complement 64-bit bit patterns.
fn a64xs_div_signed(value: integer, denominator: integer) -> integer {
assert(denominator > 0 && denominator < 0x8000000000000000, "a64: invalid signed divisor")
if value >= 0x8000000000000000 {
return -((-value) / denominator);
}
return value / denominator;
}
// ZA slice identity is shape, orientation and tile; it is not an opcode.
fn a64xs_za_head(arg: operand) -> list {
const text: string = lower(trim(operand.text(arg)))
const pieces: list = split(text, ".")
if len(pieces) != 2 {
return list.new();
}
const suffix: string = list.get(pieces, 1)
const sizes: list = list.of("b", "h", "s", "d", "q")
let shape: integer = 0
let matched: bool = false
for size in sizes {
if suffix == size {
matched = true
}
if !matched {
shape = shape + 1
}
}
if !matched {
return list.new();
}
const head: string = list.get(pieces, 0)
if head == "za" {
return list.of(0, 0, shape, "vector");
}
let tile: integer = 0
while tile < (1 << shape) {
if head == sym.join("za", tile, "h") {
return list.of(tile, 0, shape, "slice");
}
if head == sym.join("za", tile, "v") {
return list.of(tile, 1, shape, "slice");
}
tile = tile + 1
}
return list.new();
}

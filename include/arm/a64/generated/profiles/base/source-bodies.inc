// Source-derived A64 encoding contracts; shared bodies use explicit opcode and identity.
fn a64xs_gdb071634e3fe68c3(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "sp")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v2 >= 0 && v2 <= 1008) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 16 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 16)
if !(true && true && v3 >= 0 && v3 <= 15) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 63) << 16) | (((v3 >> 0) & 15) << 10)
return list.of(true, word, identity);
}
fn a64xs_gbd66d0fd348ef011(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709551488 || v2 <= 127)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 255) << 10)
return list.of(true, word, identity);
}
fn a64xs_gc8d98ffd3861c6ab(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v2 >= 0 && v2 <= 255) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 255) << 10)
return list.of(true, word, identity);
}
fn a64xs_gbefd2fedc9f0761b(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709551488 || v2 <= 127)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 255) << 10)
return list.of(true, word, identity);
}
fn a64xs_gf3da4e312d78d91f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v2 >= 0 && v2 <= 255) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 255) << 10)
return list.of(true, word, identity);
}
fn a64xs_g390d8f2ab03e4cc0(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_g171aaa5c1da4bad5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_gee902e7bb7bdd523(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
if !evaluate {
return list.of(true, 0, identity);
}
const word: integer = opcode
return list.of(true, word, identity);
}
fn a64xs_gdb112e33d338555f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "keep" {
v0 = 0;
found0 = true
}
if k0 == "strm" {
v0 = 1;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
const word: integer = opcode | (((v0 >> 0) & 1) << 5)
return list.of(true, word, identity);
}
fn a64xs_g3445586103504a48(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "osh" {
v0 = 0;
found0 = true
}
if k0 == "nsh" {
v0 = 1;
found0 = true
}
if k0 == "ish" {
v0 = 2;
found0 = true
}
if k0 == "sy" {
v0 = 3;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
const word: integer = opcode | (((v0 >> 0) & 3) << 10)
return list.of(true, word, identity);
}
fn a64xs_gbe72d9d3100ff8e0(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 3)) && (((word >> 5) & 7) == 6))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gb65fab3642cb904f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 2)) && (((word >> 5) & 7) == 7))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g8ccc1891f3f88c26(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 3)) && (((word >> 5) & 7) == 4))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g80fd3e5a092fb27d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 7)) && (((word >> 5) & 7) == 0))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_ge4496f0120808852(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 7)) && (((word >> 5) & 7) == 2))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g9e219f304fe15558(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 3)) && (((word >> 5) & 7) == 5))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_ge8338735e3ad4e7f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 3)) && (((word >> 5) & 7) == 7))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g3b127297c07c19bb(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 6)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 0)) && (((word >> 5) & 7) == 0))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gcf1725dcd95f88e8(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 7)) && (((word >> 5) & 7) == 3))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_ga2215d600a59193c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g3540bc4b632f2b7f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !((true && (((word >> 0) & 31) != 31))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gffc58658e29b0865(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 5) | (((v1 >> 0) & 31) << 0)
return list.of(true, word, identity);
}
fn a64xs_gd8570f0070b65bcf(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_g24b7651ccab7f1ed(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_g1ba0bc6203b86c94(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 0 && v1 <= 63) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 63) << 15) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_g2cb1a563535e183f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 0 && v1 <= 63) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 63) << 15) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_g5f2d600def8dcaeb(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
if !a64xs_numeric_shape(p0) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
v0 = a64xs_number(numbers, list.get(keys, 0))
const raw0: integer = v0
if !(true && true && v0 >= 0 && v0 <= 65535) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v0 >> 5) & 127) << 5) | (((v0 >> 12) & 7) << 16) | (((v0 >> 15) & 1) << 21)
if !((true && !((((((word >> 21) & 1) == 0) && (((word >> 16) & 7) == 3)) && (((word >> 0) & 31) == 31))))) {
return list.of(false, 0, -1);
}
if !((true && !((((((word >> 21) & 1) == 0) && (((word >> 16) & 7) == 3)) && (((word >> 0) & 31) == 31))))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g5a6195ed89c469a7(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gd47141773e4c9104(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g38c51ed74b96672a(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "sp")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709547520 || v2 <= 4080)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 16 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 16)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12)
return list.of(true, word, identity);
}
fn a64xs_gd67297b37bb06cc1(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "sp")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12)
return list.of(true, word, identity);
}
fn a64xs_g6bbc277de015ac82(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12)
return list.of(true, word, identity);
}
fn a64xs_ge4cc59e71a491019(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709547520 || v2 <= 4080)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 16 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 16)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12)
return list.of(true, word, identity);
}
fn a64xs_g1cc6afecc674dd51(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v0 != v2) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g926c156c825496e5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g00468e9ac24051f7(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v0 != v2) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gff46221351f75cc0(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g26db7cd683fafa62(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gc52c4ffd66041dbf(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12)
return list.of(true, word, identity);
}
fn a64xs_g4c600e43522c3fb4(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709551360 || v2 <= 255)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12)
return list.of(true, word, identity);
}
fn a64xs_gd1aae8b7440b7f04(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709551360 || v2 <= 255)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12)
return list.of(true, word, identity);
}
fn a64xs_g397e9dceedbcc0ab(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "b")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g728d93cae7e5bae5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "b")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709551360 || v2 <= 255)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g22160283910d9a1d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "q")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g5e68b0b5429e68ca(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "q")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709551360 || v2 <= 255)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_ge70b282feebdda90(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g5ecef4b65da4f2be(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709551360 || v2 <= 255)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g53e97a1e691f8333(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g007168f7fc7e549c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709551360 || v2 <= 255)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gbf9ad4eedf932c3e(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g4f3b4a1b0b9bc32c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709551360 || v2 <= 255)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12)
if (((word >> 23) & 1) == 1) && (((word >> 30) & 3) != 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g8d2d3de6530bf287(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g0d3b6f7d23605b84(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 5)
if !((true && ((((word >> 23) & 1) == 0) && (((word >> 0) & 31) == 31)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_ga7226de1a1a18ddf(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 5)
if !((true && ((((word >> 23) & 1) == 0) && (((word >> 0) & 31) == 31)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g0b13bd1d575decb9(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v3 >= 18446744073709550592 || v3 <= 1008)) {
return list.of(false, 0, -1);
}
if !((v3 - 0) % 16 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 0), 16)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((v3 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_g252d6d0bc94be57c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((0 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_gfb90848580bd42fb(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 31) << 5)
if (((word >> 3) & 3) == 3) || (((word >> 0) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g65d15c2214e25675(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if (((word >> 3) & 3) == 3) || (((word >> 0) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gd7166bac9484ec63(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g3bb3de5fcd5530c0(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g6a564289d81097f5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g382fca8ce3ccfc44(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_ge0e55862cb5d0d45(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 0) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g64edd3b40719adce(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gd72d5f4e923d8e9a(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "w" && v2 < 31) || k2 == "wzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_ge8231d92af0741af(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_gbfcd7d219d6af3d3(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_gfeeb8f237d75a12f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_gba5be29958f3d7ae(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_gc663d3b00ccd14a9(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "sp")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 5) | (((v1 >> 0) & 31) << 16)
if !((true && ((((word >> 29) & 1) == 1) && (((word >> 0) & 31) == 31)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_ge1a216f1ee736b36(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gc53f41c8f7b78960(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_ge75cd480ef8950e1(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "sp")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((0 >> 0) & 7) << 10)
return list.of(true, word, identity);
}
fn a64xs_ge1431a09498158c4(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "sp")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((v3 >> 0) & 7) << 10)
return list.of(true, word, identity);
}
fn a64xs_g19d2f9c8a771a0a8(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 0 && v1 <= 63) {
return list.of(false, 0, -1);
}
if !(true && true && v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 5) | (((v1 >> 0) & 63) << 15) | (((v2 >> 0) & 15) << 0)
return list.of(true, word, identity);
}
fn a64xs_gb4ebdd196477a3e5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g5c2be2269cfc6765(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
const r3: list = a64x_source_register(operand.text(p3))
if len(r3) == 0 {
return list.of(false, 0, -1);
}
const k3: string = list.get(r3, 0)
v3 = list.get(r3, 1)
if !(((k3 == "x" && v3 < 31) || k3 == "xzr")) {
return list.of(false, 0, -1);
}
if v3 < 0 || v3 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v3 >= 0 && v3 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((v3 >> 0) & 31) << 10)
return list.of(true, word, identity);
}
fn a64xs_gf3fb2ad6628a56b9(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g48ad80b5952380e0(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gd49294543dc8b4b4(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v2h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if (((word >> 22) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g0aa5ed53ca206a3e(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 0
}
if k0 == "v8h" {
s0 = 1
}
if !((k0 == "v4h") || (k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 0
}
if k1 == "v8h" {
s1 = 1
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "v4h" {
s2 = 0
}
if k2 == "v8h" {
s2 = 1
}
if !((k2 == "v4h") || (k2 == "v8h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g0812641d4acfde8d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 0
}
if k0 == "v8h" {
s0 = 1
}
if !((k0 == "v4h") || (k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 0
}
if k1 == "v8h" {
s1 = 1
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g23b98eec97c4e478(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 0
}
if k0 == "v4s" {
s0 = 1
}
if !((k0 == "v2s") || (k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v8b" {
s1 = 0
}
if k1 == "v16b" {
s1 = 1
}
if !((k1 == "v8b") || (k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "v8b" {
s2 = 0
}
if k2 == "v16b" {
s2 = 1
}
if !((k2 == "v8b") || (k2 == "v16b")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g583972b82bc5317d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v8b" {
s0 = 0
}
if k0 == "v16b" {
s0 = 1
}
if !((k0 == "v8b") || (k0 == "v16b")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 0
}
if k1 == "v8h" {
s1 = 1
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "v4h" {
s2 = 0
}
if k2 == "v8h" {
s2 = 1
}
if !((k2 == "v4h") || (k2 == "v8h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g2d5d003d3422c4c0(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 0
}
if k0 == "v8h" {
s0 = 1
}
if !((k0 == "v4h") || (k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v8b" {
s1 = 0
}
if k1 == "v16b" {
s1 = 1
}
if !((k1 == "v8b") || (k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "v8b" {
s2 = 0
}
if k2 == "v16b" {
s2 = 1
}
if !((k2 == "v8b") || (k2 == "v16b")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g355f64041de80719(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 0
}
if k0 == "v4s" {
s0 = 1
}
if !((k0 == "v2s") || (k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 0
}
if k1 == "v8h" {
s1 = 1
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "v4h" {
s2 = 0
}
if k2 == "v8h" {
s2 = 1
}
if !((k2 == "v4h") || (k2 == "v8h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g9ad046dcf2162698(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 0
}
if k0 == "v4s" {
s0 = 1
}
if k0 == "v2d" {
s0 = 3
}
if !((k0 == "v2s") || (k0 == "v4s") || (k0 == "v2d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v2s" {
s1 = 0
}
if k1 == "v4s" {
s1 = 1
}
if k1 == "v2d" {
s1 = 3
}
if !((k1 == "v2s") || (k1 == "v4s") || (k1 == "v2d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 1) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if (((((word >> 30) & 1) << 0) | (((word >> 22) & 1) << 1)) == 2) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g55f1c9825403cff3(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 0
}
if k0 == "v4s" {
s0 = 1
}
if !((k0 == "v2s") || (k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v2h" {
s1 = 0
}
if k1 == "v4h" {
s1 = 1
}
if !((k1 == "v2h") || (k1 == "v4h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "v2h" {
s2 = 0
}
if k2 == "v4h" {
s2 = 1
}
if !((k2 == "v2h") || (k2 == "v4h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
if (((word >> 22) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g6e9334d8bb13889a(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 0
}
if k0 == "v4s" {
s0 = 1
}
if k0 == "v2d" {
s0 = 3
}
if !((k0 == "v2s") || (k0 == "v4s") || (k0 == "v2d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v2s" {
s1 = 0
}
if k1 == "v4s" {
s1 = 1
}
if k1 == "v2d" {
s1 = 3
}
if !((k1 == "v2s") || (k1 == "v4s") || (k1 == "v2d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "v2s" {
s2 = 0
}
if k2 == "v4s" {
s2 = 1
}
if k2 == "v2d" {
s2 = 3
}
if !((k2 == "v2s") || (k2 == "v4s") || (k2 == "v2d")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 1) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
if (((word >> 30) & 1) == 0) && (((word >> 22) & 3) == 3) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g190a9b77302e93c7(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gc0269cb1f8b14f0f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gbd3c1373b14eef1a(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gd1cf2b824d6c55d0(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if ((((word >> 22) & 2) == 2)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g7b53d257f5b3823f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gc018341768a17f65(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if ((((word >> 22) & 2) == 2)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g7f6fc2e7ecf410f5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g146a587774abafdc(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
const k3: string = lower(replace(operand.text(p3), " ", ""))
let found3: bool = false
if k3 == "eq" {
v3 = 0;
found3 = true
}
if k3 == "ne" {
v3 = 1;
found3 = true
}
if k3 == "cs" {
v3 = 2;
found3 = true
}
if k3 == "cc" {
v3 = 3;
found3 = true
}
if k3 == "mi" {
v3 = 4;
found3 = true
}
if k3 == "pl" {
v3 = 5;
found3 = true
}
if k3 == "vs" {
v3 = 6;
found3 = true
}
if k3 == "vc" {
v3 = 7;
found3 = true
}
if k3 == "hi" {
v3 = 8;
found3 = true
}
if k3 == "ls" {
v3 = 9;
found3 = true
}
if k3 == "ge" {
v3 = 10;
found3 = true
}
if k3 == "lt" {
v3 = 11;
found3 = true
}
if k3 == "gt" {
v3 = 12;
found3 = true
}
if k3 == "le" {
v3 = 13;
found3 = true
}
if k3 == "al" {
v3 = 14;
found3 = true
}
if k3 == "nv" {
v3 = 15;
found3 = true
}
if !found3 && !starts_with(k3, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !found3 {
v3 = a64xs_number(numbers, list.get(keys, 3))
}
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 5) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 15) << 0) | (((v3 >> 0) & 15) << 12)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g22b11fd507822312(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
const k3: string = lower(replace(operand.text(p3), " ", ""))
let found3: bool = false
if k3 == "eq" {
v3 = 0;
found3 = true
}
if k3 == "ne" {
v3 = 1;
found3 = true
}
if k3 == "cs" {
v3 = 2;
found3 = true
}
if k3 == "cc" {
v3 = 3;
found3 = true
}
if k3 == "mi" {
v3 = 4;
found3 = true
}
if k3 == "pl" {
v3 = 5;
found3 = true
}
if k3 == "vs" {
v3 = 6;
found3 = true
}
if k3 == "vc" {
v3 = 7;
found3 = true
}
if k3 == "hi" {
v3 = 8;
found3 = true
}
if k3 == "ls" {
v3 = 9;
found3 = true
}
if k3 == "ge" {
v3 = 10;
found3 = true
}
if k3 == "lt" {
v3 = 11;
found3 = true
}
if k3 == "gt" {
v3 = 12;
found3 = true
}
if k3 == "le" {
v3 = 13;
found3 = true
}
if k3 == "al" {
v3 = 14;
found3 = true
}
if k3 == "nv" {
v3 = 15;
found3 = true
}
if !found3 && !starts_with(k3, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !found3 {
v3 = a64xs_number(numbers, list.get(keys, 3))
}
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((v3 >> 0) & 15) << 12)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g0c7f62e9a67e5f54(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "lane_h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 15 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v3 >> 0) & 1) << 20) | (((v3 >> 1) & 1) << 21) | (((v3 >> 2) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_gc7ba0d43614964e0(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "h" {
s0 = 1
}
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "h" {
s1 = 1
}
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_h" {
s2 = 1
}
if !((k2 == "lane_h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 15 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 3) << 22)) & 12582912) == ((2134953984) & 12582912)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v3 >> 0) & 1) << 20) | (((v3 >> 1) & 1) << 21) | (((v3 >> 2) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_gd7b8df99a952d1aa(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "s" {
s0 = 2
}
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "s" {
s1 = 2
}
if !((k1 == "s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_s" {
s2 = 2
}
if !((k2 == "lane_s")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 3) << 22)) & 12582912) == ((2139148288) & 12582912)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v2 >> 4) & 1) << 20) | (((v3 >> 0) & 1) << 21) | (((v3 >> 1) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_g36b18acb37bfeee5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "h" {
s0 = 1
}
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "h" {
s1 = 1
}
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_h" {
s2 = 1
}
if !((k2 == "lane_h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 15 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 3) << 22)) & 12582912) == ((2134962176) & 12582912)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v3 >> 0) & 1) << 20) | (((v3 >> 1) & 1) << 21) | (((v3 >> 2) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_g526dd8c496ede001(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "s" {
s0 = 2
}
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "s" {
s1 = 2
}
if !((k1 == "s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_s" {
s2 = 2
}
if !((k2 == "lane_s")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 3) << 22)) & 12582912) == ((2139156480) & 12582912)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(s2 == s1) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v2 >> 4) & 1) << 20) | (((v3 >> 0) & 1) << 21) | (((v3 >> 1) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_gce1e2a0647ae211f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const p4: operand = list.get(captures, 4)
let v4: integer = 0
let s4: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v8h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
const r3: list = a64x_source_register(operand.text(p3))
if len(r3) == 0 {
return list.of(false, 0, -1);
}
const k3: string = list.get(r3, 0)
v3 = list.get(r3, 1)
if !((k3 == "v")) {
return list.of(false, 0, -1);
}
if v3 < 0 || v3 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p4) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
const raw3: integer = v3
v4 = a64xs_number(numbers, list.get(keys, 4))
const raw4: integer = v4
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
v2 = (v2 - 1) & 31
if !(v2 == v1) {
return list.of(false, 0, -1);
}
if !(v3 >= 0 && v3 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v4 >= 0 && v4 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v3 >> 0) & 31) << 16) | (((v4 >> 0) & 3) << 13)
if (((word >> 13) & 1) == 0) && (((word >> 12) & 1) == 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g139eb192fe549050(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v16b")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((v3 >> 0) & 1) << 14)
if (((word >> 13) & 1) == 0) && (((word >> 12) & 1) == 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g3dcce5bd044d619d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v16b")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((v3 >> 0) & 3) << 13)
if (((word >> 22) & 3) == 2) && (((word >> 12) & 1) == 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g47ecff583cfdce1b(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((v3 >> 0) & 1) << 12) | (((v3 >> 1) & 3) << 13)
if (((word >> 22) & 3) == 2) && (((word >> 12) & 1) == 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g2a8fb55202c36e50(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v8b" {
s0 = 0
}
if !((k0 == "v8b")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v4s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v4s")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 1) << 30)) & 1073741824) == ((234943488) & 1073741824)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g77161fd5bcc3bbb3(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v16b" {
s0 = 1
}
if !((k0 == "v16b")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v4s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v4s")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 1) << 30)) & 1073741824) == ((1308685312) & 1073741824)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g4e8b95bcd04a1ca5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 2
}
if k0 == "v8h" {
s0 = 3
}
if k0 == "v2s" {
s0 = 4
}
if k0 == "v4s" {
s0 = 5
}
if k0 == "v2d" {
s0 = 7
}
if !((k0 == "v4h") || (k0 == "v8h") || (k0 == "v2s") || (k0 == "v4s") || (k0 == "v2d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 2
}
if k1 == "v8h" {
s1 = 3
}
if k1 == "v2s" {
s1 = 4
}
if k1 == "v4s" {
s1 = 5
}
if k1 == "v2d" {
s1 = 7
}
if !((k1 == "v4h") || (k1 == "v8h") || (k1 == "v2s") || (k1 == "v4s") || (k1 == "v2d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "v4h" {
s2 = 2
}
if k2 == "v8h" {
s2 = 3
}
if k2 == "v2s" {
s2 = 4
}
if k2 == "v4s" {
s2 = 5
}
if k2 == "v2d" {
s2 = 7
}
if !((k2 == "v4h") || (k2 == "v8h") || (k2 == "v2s") || (k2 == "v4s") || (k2 == "v2d")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
let pc: u64 = 0
let steps: u64 = 0
let immediate_bits: integer = 0
let immediate_ok: bool = false
while pc < 16 {
steps = steps + 1
assert(steps < 4096, "a64: numeric contract did not terminate")
if pc == 0 {
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
pc = 1
continue
}
if pc == 1 {
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
pc = 2
continue
}
if pc == 2 {
if !(s1 == s0) {
return list.of(false, 0, -1);
}
pc = 3
continue
}
if pc == 3 {
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
pc = 4
continue
}
if pc == 4 {
if !(s2 == s1) {
return list.of(false, 0, -1);
}
pc = 5
continue
}
if pc == 5 {
if !(true && true) {
return list.of(false, 0, -1);
}
pc = 6
continue
}
if pc == 6 {
if !(v3 == 0) {
pc = 8
continue
}
pc = 7
continue
}
if pc == 7 {
v3 = 0
pc = 15
continue
}
if pc == 8 {
if !(v3 == 90) {
pc = 10
continue
}
pc = 9
continue
}
if pc == 9 {
v3 = 1
pc = 15
continue
}
if pc == 10 {
if !(v3 == 180) {
pc = 12
continue
}
pc = 11
continue
}
if pc == 11 {
v3 = 2
pc = 15
continue
}
if pc == 12 {
if !(v3 == 270) {
pc = 14
continue
}
pc = 13
continue
}
if pc == 13 {
v3 = 3
pc = 15
continue
}
if pc == 14 {
return list.of(false, 0, -1);
}
if pc == 15 {
pc = 16
continue
}
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((v3 >> 0) & 3) << 11)
if (((word >> 22) & 3) == 0) {
return list.of(false, 0, -1);
}
if (((word >> 30) & 1) == 0) && (((word >> 22) & 3) == 3) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g721ec3d39858bb1c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 2
}
if k0 == "v8h" {
s0 = 3
}
if k0 == "v2s" {
s0 = 4
}
if k0 == "v4s" {
s0 = 5
}
if k0 == "v2d" {
s0 = 7
}
if !((k0 == "v4h") || (k0 == "v8h") || (k0 == "v2s") || (k0 == "v4s") || (k0 == "v2d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 2
}
if k1 == "v8h" {
s1 = 3
}
if k1 == "v2s" {
s1 = 4
}
if k1 == "v4s" {
s1 = 5
}
if k1 == "v2d" {
s1 = 7
}
if !((k1 == "v4h") || (k1 == "v8h") || (k1 == "v2s") || (k1 == "v4s") || (k1 == "v2d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "v4h" {
s2 = 2
}
if k2 == "v8h" {
s2 = 3
}
if k2 == "v2s" {
s2 = 4
}
if k2 == "v4s" {
s2 = 5
}
if k2 == "v2d" {
s2 = 7
}
if !((k2 == "v4h") || (k2 == "v8h") || (k2 == "v2s") || (k2 == "v4s") || (k2 == "v2d")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
let pc: u64 = 0
let steps: u64 = 0
let immediate_bits: integer = 0
let immediate_ok: bool = false
while pc < 12 {
steps = steps + 1
assert(steps < 4096, "a64: numeric contract did not terminate")
if pc == 0 {
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
pc = 1
continue
}
if pc == 1 {
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
pc = 2
continue
}
if pc == 2 {
if !(s1 == s0) {
return list.of(false, 0, -1);
}
pc = 3
continue
}
if pc == 3 {
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
pc = 4
continue
}
if pc == 4 {
if !(s2 == s1) {
return list.of(false, 0, -1);
}
pc = 5
continue
}
if pc == 5 {
if !(true && true) {
return list.of(false, 0, -1);
}
pc = 6
continue
}
if pc == 6 {
if !(v3 == 90) {
pc = 8
continue
}
pc = 7
continue
}
if pc == 7 {
v3 = 0
pc = 11
continue
}
if pc == 8 {
if !(v3 == 270) {
pc = 10
continue
}
pc = 9
continue
}
if pc == 9 {
v3 = 1
pc = 11
continue
}
if pc == 10 {
return list.of(false, 0, -1);
}
if pc == 11 {
pc = 12
continue
}
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((v3 >> 0) & 1) << 12)
if (((word >> 22) & 3) == 0) {
return list.of(false, 0, -1);
}
if (((word >> 30) & 1) == 0) && (((word >> 22) & 3) == 3) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_ge0457c1e660076d9(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v8h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g54b6d80199dcfb0f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v16b")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_gc06497cf0a9a7707(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v16b")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_gabe84ea49872c8f2(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v8h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g2695a24a7ab96fe1(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 0
}
if !((k0 == "v4h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v4s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 1) << 30)) & 1073741824) == ((245458944) & 1073741824)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g821134313e85e3de(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v8h" {
s0 = 1
}
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v4s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 1) << 30)) & 1073741824) == ((1319200768) & 1073741824)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gaf8a3de7ee14f576(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v8b" {
s1 = 0
}
if !((k1 == "v8b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s1 >> 0) & 1) << 30)) & 1073741824) == ((773945344 | (((v0 >> 0) & 31) << 0)) & 1073741824)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((s1 >> 0) & 1) << 30) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g085a42a45f2c65d2(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v16b" {
s1 = 1
}
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s1 >> 0) & 1) << 30)) & 1073741824) == ((1847687168 | (((v0 >> 0) & 31) << 0)) & 1073741824)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((s1 >> 0) & 1) << 30) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gc92b70369f7e11dc(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v8b" {
s1 = 0
}
if !((k1 == "v8b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s1 >> 0) & 1) << 30)) & 1073741824) == ((778139648 | (((v0 >> 0) & 31) << 0)) & 1073741824)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((s1 >> 0) & 1) << 30) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_ga77b0a4cbdc90e12(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v16b" {
s1 = 1
}
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s1 >> 0) & 1) << 30)) & 1073741824) == ((1851881472 | (((v0 >> 0) & 31) << 0)) & 1073741824)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((s1 >> 0) & 1) << 30) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g2a1fd3852ce31790(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v8b" {
s1 = 0
}
if !((k1 == "v8b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s1 >> 0) & 1) << 30)) & 1073741824) == ((782333952 | (((v0 >> 0) & 31) << 0)) & 1073741824)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((s1 >> 0) & 1) << 30) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gf87aa73be355bff0(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v16b" {
s1 = 1
}
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s1 >> 0) & 1) << 30)) & 1073741824) == ((1856075776 | (((v0 >> 0) & 31) << 0)) & 1073741824)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((s1 >> 0) & 1) << 30) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g3d750357d683ea80(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v8b" {
s1 = 0
}
if !((k1 == "v8b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s1 >> 0) & 1) << 30)) & 1073741824) == ((786528256 | (((v0 >> 0) & 31) << 0)) & 1073741824)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((s1 >> 0) & 1) << 30) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gb242c8a666bbd3cc(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v16b" {
s1 = 1
}
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s1 >> 0) & 1) << 30)) & 1073741824) == ((1860270080 | (((v0 >> 0) & 31) << 0)) & 1073741824)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((s1 >> 0) & 1) << 30) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g1037e4883bd90012(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "h" {
s0 = 0
}
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 0
}
if k1 == "v8h" {
s1 = 1
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((s1 >> 0) & 1) << 30) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g0ef863d6e05c7a63(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 0
}
if k0 == "v8h" {
s0 = 1
}
if !((k0 == "v4h") || (k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_encode_fp(a64xs_float(numbers, list.get(keys, 1)))
if v1 == 0xffffffffffffffff {
return list.of(false, 0, -1);
}
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 1) << 5) | (((v1 >> 1) & 1) << 6) | (((v1 >> 2) & 1) << 7) | (((v1 >> 3) & 1) << 8) | (((v1 >> 4) & 1) << 9) | (((v1 >> 5) & 1) << 16) | (((v1 >> 6) & 1) << 17) | (((v1 >> 7) & 1) << 18)
return list.of(true, word, identity);
}
fn a64xs_gcd3d4405ede06686(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 0
}
if k0 == "v4s" {
s0 = 1
}
if !((k0 == "v2s") || (k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v8b" {
s1 = 0
}
if k1 == "v16b" {
s1 = 1
}
if !((k1 == "v8b") || (k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v4b")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v2 >> 4) & 1) << 20) | (((v3 >> 0) & 1) << 21) | (((v3 >> 1) & 1) << 11)
if (((word >> 22) & 3) != 2) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g428d4bc4e9ac4209(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 0
}
if k0 == "v4s" {
s0 = 1
}
if !((k0 == "v2s") || (k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v8b" {
s1 = 0
}
if k1 == "v16b" {
s1 = 1
}
if !((k1 == "v8b") || (k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v4b")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v2 >> 4) & 1) << 20) | (((v3 >> 0) & 1) << 21) | (((v3 >> 1) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_g44a01b941409f5f3(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 0
}
if k0 == "v8h" {
s0 = 1
}
if !((k0 == "v4h") || (k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 0
}
if k1 == "v8h" {
s1 = 1
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "lane_h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 15 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v3 >> 0) & 1) << 20) | (((v3 >> 1) & 1) << 21) | (((v3 >> 2) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_g1b9a2bfee03585d4(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 0
}
if k0 == "v8h" {
s0 = 1
}
if !((k0 == "v4h") || (k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v8b" {
s1 = 0
}
if k1 == "v16b" {
s1 = 1
}
if !((k1 == "v8b") || (k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v2b")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 15 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v3 >> 0) & 1) << 20) | (((v3 >> 1) & 1) << 21) | (((v3 >> 2) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_gde9772efda02553a(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 0
}
if k0 == "v4s" {
s0 = 1
}
if !((k0 == "v2s") || (k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 0
}
if k1 == "v8h" {
s1 = 1
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "v2h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v2 >> 4) & 1) << 20) | (((v3 >> 0) & 1) << 21) | (((v3 >> 1) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_ge244032a69511353(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 0
}
if k0 == "v4s" {
s0 = 1
}
if !((k0 == "v2s") || (k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v2h" {
s1 = 0
}
if k1 == "v4h" {
s1 = 1
}
if !((k1 == "v2h") || (k1 == "v4h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "lane_h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 15 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v3 >> 0) & 1) << 20) | (((v3 >> 1) & 1) << 21) | (((v3 >> 2) & 1) << 11)
if (((word >> 22) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g0d35ba67a27a5421(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "lane_h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 15 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 15) << 16) | (((v3 >> 0) & 1) << 20) | (((v3 >> 1) & 1) << 21) | (((v3 >> 2) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_gc52b4066ed9d5910(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 2
}
if k0 == "v8h" {
s0 = 3
}
if !((k0 == "v4h") || (k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 2
}
if k1 == "v8h" {
s1 = 3
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_h" {
s2 = 1
}
if !((k2 == "lane_h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 15 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22)) & 12582912) == ((792776704) & 12582912)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
if !((((((s2 >> 0) & 3) << 22)) & 12582912) == ((792776704 | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)) & 12582912)) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((s2 >> 0) & 3) << 22) | (((v2 >> 0) & 15) << 16) | (((v3 >> 0) & 1) << 20) | (((v3 >> 1) & 1) << 21) | (((v3 >> 2) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_ge1c3d2aa98b5ca96(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 4
}
if k0 == "v4s" {
s0 = 5
}
if !((k0 == "v2s") || (k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v2s" {
s1 = 4
}
if k1 == "v4s" {
s1 = 5
}
if !((k1 == "v2s") || (k1 == "v4s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_s" {
s2 = 2
}
if !((k2 == "lane_s")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22)) & 12582912) == ((796971008) & 12582912)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s2 >> 0) & 3) << 22)) & 12582912) == ((796971008 | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)) & 12582912)) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((s2 >> 0) & 3) << 22) | (((v2 >> 0) & 15) << 16) | (((v2 >> 4) & 1) << 20) | (((v3 >> 0) & 1) << 21) | (((v3 >> 1) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_ge5770918229a9ed6(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 2
}
if k0 == "v8h" {
s0 = 3
}
if !((k0 == "v4h") || (k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 2
}
if k1 == "v8h" {
s1 = 3
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_h" {
s2 = 1
}
if !((k2 == "lane_h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 15 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22)) & 12582912) == ((792784896) & 12582912)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 15) {
return list.of(false, 0, -1);
}
if !((((((s2 >> 0) & 3) << 22)) & 12582912) == ((792784896 | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)) & 12582912)) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 7) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((s2 >> 0) & 3) << 22) | (((v2 >> 0) & 15) << 16) | (((v3 >> 0) & 1) << 20) | (((v3 >> 1) & 1) << 21) | (((v3 >> 2) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_gb9ef5215857f1ca6(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v2s" {
s0 = 4
}
if k0 == "v4s" {
s0 = 5
}
if !((k0 == "v2s") || (k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v2s" {
s1 = 4
}
if k1 == "v4s" {
s1 = 5
}
if !((k1 == "v2s") || (k1 == "v4s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_s" {
s2 = 2
}
if !((k2 == "lane_s")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22)) & 12582912) == ((796979200) & 12582912)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(s1 == s0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !((((((s2 >> 0) & 3) << 22)) & 12582912) == ((796979200 | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)) & 12582912)) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((s2 >> 0) & 3) << 22) | (((v2 >> 0) & 15) << 16) | (((v2 >> 4) & 1) << 20) | (((v3 >> 0) & 1) << 21) | (((v3 >> 1) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_g76bffa48a2f22ede(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const p4: operand = list.get(captures, 4)
let v4: integer = 0
let s4: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4h" {
s0 = 2
}
if k0 == "v8h" {
s0 = 3
}
if !((k0 == "v4h") || (k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4h" {
s1 = 2
}
if k1 == "v8h" {
s1 = 3
}
if !((k1 == "v4h") || (k1 == "v8h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_h" {
s2 = 1
}
if !((k2 == "lane_h")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p4) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
v4 = a64xs_number(numbers, list.get(keys, 4))
const raw4: integer = v4
let pc: u64 = 0
let steps: u64 = 0
let immediate_bits: integer = 0
let immediate_ok: bool = false
while pc < 18 {
steps = steps + 1
assert(steps < 4096, "a64: numeric contract did not terminate")
if pc == 0 {
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
pc = 1
continue
}
if pc == 1 {
if !((((((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22)) & 12582912) == ((792727552) & 12582912)) {
return list.of(false, 0, -1);
}
pc = 2
continue
}
if pc == 2 {
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
pc = 3
continue
}
if pc == 3 {
if !(s1 == s0) {
return list.of(false, 0, -1);
}
pc = 4
continue
}
if pc == 4 {
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
pc = 5
continue
}
if pc == 5 {
if !((((((s2 >> 0) & 3) << 22)) & 12582912) == ((792727552 | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)) & 12582912)) {
return list.of(false, 0, -1);
}
pc = 6
continue
}
if pc == 6 {
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
pc = 7
continue
}
if pc == 7 {
if !(true && true) {
return list.of(false, 0, -1);
}
pc = 8
continue
}
if pc == 8 {
if !(v4 == 0) {
pc = 10
continue
}
pc = 9
continue
}
if pc == 9 {
v4 = 0
pc = 17
continue
}
if pc == 10 {
if !(v4 == 90) {
pc = 12
continue
}
pc = 11
continue
}
if pc == 11 {
v4 = 1
pc = 17
continue
}
if pc == 12 {
if !(v4 == 180) {
pc = 14
continue
}
pc = 13
continue
}
if pc == 13 {
v4 = 2
pc = 17
continue
}
if pc == 14 {
if !(v4 == 270) {
pc = 16
continue
}
pc = 15
continue
}
if pc == 15 {
v4 = 3
pc = 17
continue
}
if pc == 16 {
return list.of(false, 0, -1);
}
if pc == 17 {
pc = 18
continue
}
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((s2 >> 0) & 3) << 22) | (((v2 >> 0) & 15) << 16) | (((v2 >> 4) & 1) << 20) | (((v3 >> 0) & 1) << 21) | (((v3 >> 1) & 1) << 11) | (((v4 >> 0) & 3) << 13)
if !((true)) {
return list.of(false, 0, -1);
}
if ((((word >> 22) & 3) == 0) || (((word >> 22) & 3) == 3)) {
return list.of(false, 0, -1);
}
if (!((true)) && (((word >> 22) & 3) == 1)) {
return list.of(false, 0, -1);
}
if ((((word >> 22) & 3) == 2) && (((((word >> 21) & 1) == 1) || (((word >> 30) & 1) == 0)))) {
return list.of(false, 0, -1);
}
if (((((word >> 22) & 3) == 1) && (((word >> 11) & 1) == 1)) && (((word >> 30) & 1) == 0)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g9f45c8ad6a0143e1(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const p4: operand = list.get(captures, 4)
let v4: integer = 0
let s4: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if k0 == "v4s" {
s0 = 5
}
if !((k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if k1 == "v4s" {
s1 = 5
}
if !((k1 == "v4s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if k2 == "lane_s" {
s2 = 2
}
if !((k2 == "lane_s")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p4) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
v4 = a64xs_number(numbers, list.get(keys, 4))
const raw4: integer = v4
let pc: u64 = 0
let steps: u64 = 0
let immediate_bits: integer = 0
let immediate_ok: bool = false
while pc < 18 {
steps = steps + 1
assert(steps < 4096, "a64: numeric contract did not terminate")
if pc == 0 {
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
pc = 1
continue
}
if pc == 1 {
if !((((((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22)) & 1086324736) == ((1870663680) & 1086324736)) {
return list.of(false, 0, -1);
}
pc = 2
continue
}
if pc == 2 {
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
pc = 3
continue
}
if pc == 3 {
if !(s1 == s0) {
return list.of(false, 0, -1);
}
pc = 4
continue
}
if pc == 4 {
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
pc = 5
continue
}
if pc == 5 {
if !((((((s2 >> 0) & 3) << 22)) & 12582912) == ((1870663680 | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)) & 12582912)) {
return list.of(false, 0, -1);
}
pc = 6
continue
}
if pc == 6 {
if !(true && true && v3 >= 0 && v3 <= 1) {
return list.of(false, 0, -1);
}
pc = 7
continue
}
if pc == 7 {
if !(true && true) {
return list.of(false, 0, -1);
}
pc = 8
continue
}
if pc == 8 {
if !(v4 == 0) {
pc = 10
continue
}
pc = 9
continue
}
if pc == 9 {
v4 = 0
pc = 17
continue
}
if pc == 10 {
if !(v4 == 90) {
pc = 12
continue
}
pc = 11
continue
}
if pc == 11 {
v4 = 1
pc = 17
continue
}
if pc == 12 {
if !(v4 == 180) {
pc = 14
continue
}
pc = 13
continue
}
if pc == 13 {
v4 = 2
pc = 17
continue
}
if pc == 14 {
if !(v4 == 270) {
pc = 16
continue
}
pc = 15
continue
}
if pc == 15 {
v4 = 3
pc = 17
continue
}
if pc == 16 {
return list.of(false, 0, -1);
}
if pc == 17 {
pc = 18
continue
}
}
const word: integer = opcode | (((s0 >> 0) & 1) << 30) | (((s0 >> 1) & 3) << 22) | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((s2 >> 0) & 3) << 22) | (((v2 >> 0) & 15) << 16) | (((v2 >> 4) & 1) << 20) | (((v3 >> 0) & 1) << 11) | (((v4 >> 0) & 3) << 13)
if !((true)) {
return list.of(false, 0, -1);
}
if ((((word >> 22) & 3) == 0) || (((word >> 22) & 3) == 3)) {
return list.of(false, 0, -1);
}
if (!((true)) && (((word >> 22) & 3) == 1)) {
return list.of(false, 0, -1);
}
if ((((word >> 22) & 3) == 2) && (((((word >> 21) & 1) == 1) || (((word >> 30) & 1) == 0)))) {
return list.of(false, 0, -1);
}
if (((((word >> 22) & 3) == 1) && (((word >> 11) & 1) == 1)) && (((word >> 30) & 1) == 0)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_geea0b7eed0a38a25(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v8h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "lane_b")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 7 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 7) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 15) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 7) << 16) | (((v3 >> 0) & 1) << 19) | (((v3 >> 1) & 1) << 20) | (((v3 >> 2) & 1) << 21) | (((v3 >> 3) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_gf190e0c83a6f4fd4(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v16b")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "lane_b")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 7 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 7) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 15) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 7) << 16) | (((v3 >> 0) & 1) << 19) | (((v3 >> 1) & 1) << 20) | (((v3 >> 2) & 1) << 21) | (((v3 >> 3) & 1) << 11)
return list.of(true, word, identity);
}
fn a64xs_g3dcd7a166071b2e5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "v4s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "v4s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !((k2 == "lane_s")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v3 >= 0 && v3 <= 3) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16) | (((v3 >> 0) & 3) << 12)
return list.of(true, word, identity);
}
fn a64xs_g7ad15e7a3e468f36(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true) {
return list.of(false, 0, -1);
}
if !(v2 >= 1 && v2 <= 32) {
return list.of(false, 0, -1);
}
v2 = 64 - v2
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 63) << 10)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
if (((word >> 31) & 1) == 0) && (((word >> 15) & 1) == 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g410c880d78cba77f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true) {
return list.of(false, 0, -1);
}
if !(v2 >= 1 && v2 <= 32) {
return list.of(false, 0, -1);
}
v2 = 64 - v2
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 63) << 10)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
if (((word >> 31) & 1) == 0) && (((word >> 15) & 1) == 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g61dcc547caf1c213(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true) {
return list.of(false, 0, -1);
}
if !(v2 >= 1 && v2 <= 64) {
return list.of(false, 0, -1);
}
v2 = 64 - v2
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 63) << 10)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
if (((word >> 31) & 1) == 0) && (((word >> 15) & 1) == 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g30e0fa0026cff3a1(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true) {
return list.of(false, 0, -1);
}
if !(v2 >= 1 && v2 <= 64) {
return list.of(false, 0, -1);
}
v2 = 64 - v2
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 63) << 10)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
if (((word >> 31) & 1) == 0) && (((word >> 15) & 1) == 0) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gcd3c8b732e9f845c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if ((3 == 2) && (((3 << 2) | 0) != 13)) {
return list.of(false, 0, -1);
}
if ((3 == 3) && !((true))) {
return list.of(false, 0, -1);
}
if ((16 != 16) && (16 != 32)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g60c5eef4f157d321(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if ((3 == 2) && (((3 << 2) | 0) != 13)) {
return list.of(false, 0, -1);
}
if ((3 == 3) && !((true))) {
return list.of(false, 0, -1);
}
if ((16 != 16) && (16 != 32)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g043dcd6e2e8140c5(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if ((3 == 2) && (((3 << 2) | 0) != 13)) {
return list.of(false, 0, -1);
}
if ((3 == 3) && !((true))) {
return list.of(false, 0, -1);
}
if ((16 != 16) && (16 != 64)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g125633d34df5acdb(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if ((3 == 2) && (((3 << 2) | 0) != 13)) {
return list.of(false, 0, -1);
}
if ((3 == 3) && !((true))) {
return list.of(false, 0, -1);
}
if ((16 != 16) && (16 != 64)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gd38c81ee7cc65a0d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if (1 == 2) {
return list.of(false, 0, -1);
}
if ((((0 == 0) && (1 == 0))) || (((0 == 1) && (1 == 1)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g3e5d1f57d269cad4(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if (1 == 2) {
return list.of(false, 0, -1);
}
if ((((0 == 0) && (1 == 0))) || (((0 == 1) && (1 == 1)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gae4eb8fd96b347a9(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if (3 == 2) {
return list.of(false, 0, -1);
}
if ((((0 == 0) && (3 == 0))) || (((0 == 1) && (3 == 1)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g357808d956183136(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if (3 == 2) {
return list.of(false, 0, -1);
}
if ((((0 == 0) && (3 == 0))) || (((0 == 1) && (3 == 1)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g9d08040f80e8a96d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "h")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if (3 == 2) {
return list.of(false, 0, -1);
}
if ((((1 == 0) && (3 == 0))) || (((1 == 1) && (3 == 1)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g6205ac7a4e2997db(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if (3 == 2) {
return list.of(false, 0, -1);
}
if ((((1 == 0) && (3 == 0))) || (((1 == 1) && (3 == 1)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gd1653e645408646b(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "s")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if (0 == 2) {
return list.of(false, 0, -1);
}
if ((((1 == 0) && (0 == 0))) || (((1 == 1) && (0 == 1)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_geef7120b8dad48fb(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "s")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "d")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
if !((true)) {
return list.of(false, 0, -1);
}
if (0 == 2) {
return list.of(false, 0, -1);
}
if ((((1 == 0) && (0 == 0))) || (((1 == 1) && (0 == 1)))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g227ea4f87eda95bc(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "h")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_encode_fp(a64xs_float(numbers, list.get(keys, 1)))
if v1 == 0xffffffffffffffff {
return list.of(false, 0, -1);
}
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 255) << 13)
if (((word >> 22) & 3) == 2) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g3cbed018de326921(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
if !a64xs_numeric_shape(p0) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
v0 = a64xs_number(numbers, list.get(keys, 0))
const raw0: integer = v0
v0 = a64xs_sub(v0, instruction_address)
if !(true && true && (v0 >= 18446744073709289476 || v0 <= 0)) {
return list.of(false, 0, -1);
}
if !(v0 % 4 == 0) {
return list.of(false, 0, -1);
}
v0 = -a64xs_div_signed(v0, 4)
const word: integer = opcode | (((v0 >> 0) & 65535) << 5)
return list.of(true, word, identity);
}
fn a64xs_ga4a7a47d31a94062(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 0 && v1 < 32) {
return list.of(false, 0, -1);
}
v1 = (-v1) & 31
if !(true && true && v2 >= 1 && v2 <= 32 - raw1) {
return list.of(false, 0, -1);
}
v2 = v2 - 1
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 63) << 16) | (((v2 >> 0) & 63) << 10)
if !((true && (((word >> 5) & 31) == 31))) {
return list.of(false, 0, -1);
}
if !(((word >> 10) & 63) < ((word >> 16) & 63)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g1392e5fbb40879c6(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 0 && v1 < 64) {
return list.of(false, 0, -1);
}
v1 = (-v1) & 63
if !(true && true && v2 >= 1 && v2 <= 64 - raw1) {
return list.of(false, 0, -1);
}
v2 = v2 - 1
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 63) << 16) | (((v2 >> 0) & 63) << 10)
if !((true && (((word >> 5) & 31) == 31))) {
return list.of(false, 0, -1);
}
if !(((word >> 10) & 63) < ((word >> 16) & 63)) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_ga7e0c32daf53fe6b(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
if !a64xs_numeric_shape(p0) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
v0 = a64xs_number(numbers, list.get(keys, 0))
const raw0: integer = v0
v0 = a64xs_sub(v0, instruction_address)
if !(true && true && (v0 >= 18446744073708503040 || v0 <= 1048572)) {
return list.of(false, 0, -1);
}
if !((v0 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v0 = a64xs_div_signed((v0 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 524287) << 5)
return list.of(true, word, identity);
}
fn a64xs_g5d4e3b574499fbad(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
if !a64xs_numeric_shape(p0) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
v0 = a64xs_number(numbers, list.get(keys, 0))
const raw0: integer = v0
if !(true && true && v0 >= 0 && v0 <= 127) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 127) << 5) | (((0 >> 0) & 1) << 17)
return list.of(true, word, identity);
}
fn a64xs_g254430131586c389(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
if !a64xs_numeric_shape(p0) {
return list.of(false, 0, -1);
}
const k1: string = lower(replace(operand.text(p1), " ", ""))
let found1: bool = false
if k1 == "nb" {
v1 = 1;
found1 = true
}
if !found1 && !starts_with(k1, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
v0 = a64xs_number(numbers, list.get(keys, 0))
const raw0: integer = v0
if !found1 {
v1 = a64xs_number(numbers, list.get(keys, 1))
}
const raw1: integer = v1
if !(true && true && v0 >= 0 && v0 <= 127) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 127) << 5) | (((v1 >> 0) & 1) << 17)
return list.of(true, word, identity);
}
fn a64xs_g3e1f6b4ccac6c00b(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
return list.of(true, word, identity);
}
fn a64xs_g4f37d86041af691b(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
if !evaluate {
return list.of(true, 0, identity);
}
const word: integer = opcode | 0
return list.of(true, word, identity);
}
fn a64xs_g3278fe8aa1643251(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
if !evaluate {
return list.of(true, 0, identity);
}
const word: integer = opcode | 32
return list.of(true, word, identity);
}
fn a64xs_g8467236b16c0468b(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
if !evaluate {
return list.of(true, 0, identity);
}
const word: integer = opcode
if !(((((true && (((word >> 16) & 7) == 0)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 7)) && (((word >> 5) & 7) == 4))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g75553fcf24dfc10f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "iall" {
v0 = 4;
found0 = true
}
if k0 == "inj" {
v0 = 5;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
const word: integer = opcode | (((v0 >> 0) & 7) << 5)
if !((((true && (((word >> 16) & 7) == 1)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 2))) {
return list.of(false, 0, -1);
}
if !(((1 == 1) && (7 == 7) && (2 == 2) && (((word >> 5) & 7) == 4)) || ((1 == 1) && (7 == 7) && (2 == 2) && (((word >> 5) & 7) == 5))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g98e523a172fd29e4(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
if !evaluate {
return list.of(true, 0, identity);
}
const word: integer = opcode
if !(((((true && (((word >> 16) & 7) == 0)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 7)) && (((word >> 5) & 7) == 5))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g1bd86745612f5296(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
if !evaluate {
return list.of(true, 0, identity);
}
const word: integer = opcode
if !(((((true && (((word >> 16) & 7) == 0)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 7)) && (((word >> 5) & 7) == 6))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g42ec71ec637ee43c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "sys" {
v0 = 0;
found0 = true
}
if k0 == "ack" {
v0 = 1;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
const word: integer = opcode | (((v0 >> 0) & 7) << 5)
if !((((true && (((word >> 16) & 7) == 0)) && (((word >> 12) & 15) == 12)) && (((word >> 8) & 15) == 0))) {
return list.of(false, 0, -1);
}
if !(((0 == 0) && (12 == 12) && (0 == 0) && (((word >> 5) & 7) == 0)) || ((0 == 0) && (12 == 12) && (0 == 0) && (((word >> 5) & 7) == 1))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gc4155e69e4117afb(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "cddis" {
v0 = 8;
found0 = true
}
if k0 == "cden" {
v0 = 9;
found0 = true
}
if k0 == "cdpri" {
v0 = 10;
found0 = true
}
if k0 == "cdaff" {
v0 = 11;
found0 = true
}
if k0 == "cdpend" {
v0 = 12;
found0 = true
}
if k0 == "cdrcfg" {
v0 = 13;
found0 = true
}
if k0 == "cdeoi" {
v0 = 15;
found0 = true
}
if k0 == "cddi" {
v0 = 16;
found0 = true
}
if k0 == "cdhm" {
v0 = 17;
found0 = true
}
if k0 == "vddis" {
v0 = 520;
found0 = true
}
if k0 == "vden" {
v0 = 521;
found0 = true
}
if k0 == "vdpri" {
v0 = 522;
found0 = true
}
if k0 == "vdaff" {
v0 = 523;
found0 = true
}
if k0 == "vdpend" {
v0 = 524;
found0 = true
}
if k0 == "vdrcfg" {
v0 = 525;
found0 = true
}
if k0 == "vddi" {
v0 = 528;
found0 = true
}
if k0 == "vdhm" {
v0 = 529;
found0 = true
}
if k0 == "lddis" {
v0 = 776;
found0 = true
}
if k0 == "lden" {
v0 = 777;
found0 = true
}
if k0 == "ldpri" {
v0 = 778;
found0 = true
}
if k0 == "ldaff" {
v0 = 779;
found0 = true
}
if k0 == "ldpend" {
v0 = 780;
found0 = true
}
if k0 == "ldrcfg" {
v0 = 781;
found0 = true
}
if k0 == "lddi" {
v0 = 784;
found0 = true
}
if k0 == "ldhm" {
v0 = 785;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
const word: integer = opcode | (((v0 >> 0) & 7) << 5) | (((v0 >> 3) & 15) << 8) | (((v0 >> 7) & 7) << 16) | (((31 >> 0) & 31) << 0)
if !(((true && (((word >> 12) & 15) == 12)) && (((((word >> 8) & 15) & 15) == 1) || ((((word >> 8) & 15) & 15) == 2)))) {
return list.of(false, 0, -1);
}
if !(((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 3)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 5)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 7)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 3)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 5)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 3)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 5)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 1))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g5848c640d4f651bb(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "cddis" {
v0 = 8;
found0 = true
}
if k0 == "cden" {
v0 = 9;
found0 = true
}
if k0 == "cdpri" {
v0 = 10;
found0 = true
}
if k0 == "cdaff" {
v0 = 11;
found0 = true
}
if k0 == "cdpend" {
v0 = 12;
found0 = true
}
if k0 == "cdrcfg" {
v0 = 13;
found0 = true
}
if k0 == "cdeoi" {
v0 = 15;
found0 = true
}
if k0 == "cddi" {
v0 = 16;
found0 = true
}
if k0 == "cdhm" {
v0 = 17;
found0 = true
}
if k0 == "vddis" {
v0 = 520;
found0 = true
}
if k0 == "vden" {
v0 = 521;
found0 = true
}
if k0 == "vdpri" {
v0 = 522;
found0 = true
}
if k0 == "vdaff" {
v0 = 523;
found0 = true
}
if k0 == "vdpend" {
v0 = 524;
found0 = true
}
if k0 == "vdrcfg" {
v0 = 525;
found0 = true
}
if k0 == "vddi" {
v0 = 528;
found0 = true
}
if k0 == "vdhm" {
v0 = 529;
found0 = true
}
if k0 == "lddis" {
v0 = 776;
found0 = true
}
if k0 == "lden" {
v0 = 777;
found0 = true
}
if k0 == "ldpri" {
v0 = 778;
found0 = true
}
if k0 == "ldaff" {
v0 = 779;
found0 = true
}
if k0 == "ldpend" {
v0 = 780;
found0 = true
}
if k0 == "ldrcfg" {
v0 = 781;
found0 = true
}
if k0 == "lddi" {
v0 = 784;
found0 = true
}
if k0 == "ldhm" {
v0 = 785;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
const raw1: integer = v1
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 7) << 5) | (((v0 >> 3) & 15) << 8) | (((v0 >> 7) & 7) << 16) | (((v1 >> 0) & 31) << 0)
if !(((true && (((word >> 12) & 15) == 12)) && (((((word >> 8) & 15) & 15) == 1) || ((((word >> 8) & 15) & 15) == 2)))) {
return list.of(false, 0, -1);
}
if !(((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 3)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 5)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 7)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 3)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 5)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 3)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 5)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (12 == 12) && (((word >> 8) & 15) == 2) && (((word >> 5) & 7) == 1))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gc8b6544d76f69d7c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "vmalle1os" {
v0 = 1288;
found0 = true
}
if k0 == "perme1os" {
v0 = 1289;
found0 = true
}
if k0 == "aside1os" {
v0 = 1290;
found0 = true
}
if k0 == "permae1os" {
v0 = 1291;
found0 = true
}
if k0 == "vmalle1is" {
v0 = 1304;
found0 = true
}
if k0 == "perme1is" {
v0 = 1305;
found0 = true
}
if k0 == "aside1is" {
v0 = 1306;
found0 = true
}
if k0 == "permae1is" {
v0 = 1307;
found0 = true
}
if k0 == "vmalle1" {
v0 = 1336;
found0 = true
}
if k0 == "perme1" {
v0 = 1337;
found0 = true
}
if k0 == "aside1" {
v0 = 1338;
found0 = true
}
if k0 == "permae1" {
v0 = 1339;
found0 = true
}
if k0 == "vmalle1osnxs" {
v0 = 1352;
found0 = true
}
if k0 == "perme1osnxs" {
v0 = 1353;
found0 = true
}
if k0 == "aside1osnxs" {
v0 = 1354;
found0 = true
}
if k0 == "permae1osnxs" {
v0 = 1355;
found0 = true
}
if k0 == "vmalle1isnxs" {
v0 = 1368;
found0 = true
}
if k0 == "perme1isnxs" {
v0 = 1369;
found0 = true
}
if k0 == "aside1isnxs" {
v0 = 1370;
found0 = true
}
if k0 == "permae1isnxs" {
v0 = 1371;
found0 = true
}
if k0 == "vmalle1nxs" {
v0 = 1400;
found0 = true
}
if k0 == "perme1nxs" {
v0 = 1401;
found0 = true
}
if k0 == "aside1nxs" {
v0 = 1402;
found0 = true
}
if k0 == "permae1nxs" {
v0 = 1403;
found0 = true
}
if k0 == "alle2os" {
v0 = 9480;
found0 = true
}
if k0 == "perme2os" {
v0 = 9481;
found0 = true
}
if k0 == "alle1os" {
v0 = 9484;
found0 = true
}
if k0 == "alle2is" {
v0 = 9496;
found0 = true
}
if k0 == "perme2is" {
v0 = 9497;
found0 = true
}
if k0 == "alle1is" {
v0 = 9500;
found0 = true
}
if k0 == "alle2" {
v0 = 9528;
found0 = true
}
if k0 == "perme2" {
v0 = 9529;
found0 = true
}
if k0 == "alle1" {
v0 = 9532;
found0 = true
}
if k0 == "alle2osnxs" {
v0 = 9544;
found0 = true
}
if k0 == "perme2osnxs" {
v0 = 9545;
found0 = true
}
if k0 == "alle1osnxs" {
v0 = 9548;
found0 = true
}
if k0 == "alle2isnxs" {
v0 = 9560;
found0 = true
}
if k0 == "perme2isnxs" {
v0 = 9561;
found0 = true
}
if k0 == "alle1isnxs" {
v0 = 9564;
found0 = true
}
if k0 == "alle2nxs" {
v0 = 9592;
found0 = true
}
if k0 == "perme2nxs" {
v0 = 9593;
found0 = true
}
if k0 == "alle1nxs" {
v0 = 9596;
found0 = true
}
if k0 == "alle3os" {
v0 = 13576;
found0 = true
}
if k0 == "perme3os" {
v0 = 13577;
found0 = true
}
if k0 == "alle3is" {
v0 = 13592;
found0 = true
}
if k0 == "perme3is" {
v0 = 13593;
found0 = true
}
if k0 == "alle3" {
v0 = 13624;
found0 = true
}
if k0 == "perme3" {
v0 = 13625;
found0 = true
}
if k0 == "alle3osnxs" {
v0 = 13640;
found0 = true
}
if k0 == "perme3osnxs" {
v0 = 13641;
found0 = true
}
if k0 == "alle3isnxs" {
v0 = 13656;
found0 = true
}
if k0 == "perme3isnxs" {
v0 = 13657;
found0 = true
}
if k0 == "alle3nxs" {
v0 = 13688;
found0 = true
}
if k0 == "perme3nxs" {
v0 = 13689;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
if !((((((v0 >> 0) & 7) << 5) | (((v0 >> 3) & 15) << 8) | (((v0 >> 7) & 15) << 12) | (((v0 >> 11) & 7) << 16)) & 61440) == ((3574112256) & 61440)) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 7) << 5) | (((v0 >> 3) & 15) << 8) | (((v0 >> 7) & 15) << 12) | (((v0 >> 11) & 7) << 16) | (((31 >> 0) & 31) << 0)
if !((true && (((word >> 12) & 15) == 10))) {
return list.of(false, 0, -1);
}
if !(((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 1))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gdce0f9245d680757(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "vmalle1os" {
v0 = 1288;
found0 = true
}
if k0 == "perme1os" {
v0 = 1289;
found0 = true
}
if k0 == "aside1os" {
v0 = 1290;
found0 = true
}
if k0 == "permae1os" {
v0 = 1291;
found0 = true
}
if k0 == "vmalle1is" {
v0 = 1304;
found0 = true
}
if k0 == "perme1is" {
v0 = 1305;
found0 = true
}
if k0 == "aside1is" {
v0 = 1306;
found0 = true
}
if k0 == "permae1is" {
v0 = 1307;
found0 = true
}
if k0 == "vmalle1" {
v0 = 1336;
found0 = true
}
if k0 == "perme1" {
v0 = 1337;
found0 = true
}
if k0 == "aside1" {
v0 = 1338;
found0 = true
}
if k0 == "permae1" {
v0 = 1339;
found0 = true
}
if k0 == "vmalle1osnxs" {
v0 = 1352;
found0 = true
}
if k0 == "perme1osnxs" {
v0 = 1353;
found0 = true
}
if k0 == "aside1osnxs" {
v0 = 1354;
found0 = true
}
if k0 == "permae1osnxs" {
v0 = 1355;
found0 = true
}
if k0 == "vmalle1isnxs" {
v0 = 1368;
found0 = true
}
if k0 == "perme1isnxs" {
v0 = 1369;
found0 = true
}
if k0 == "aside1isnxs" {
v0 = 1370;
found0 = true
}
if k0 == "permae1isnxs" {
v0 = 1371;
found0 = true
}
if k0 == "vmalle1nxs" {
v0 = 1400;
found0 = true
}
if k0 == "perme1nxs" {
v0 = 1401;
found0 = true
}
if k0 == "aside1nxs" {
v0 = 1402;
found0 = true
}
if k0 == "permae1nxs" {
v0 = 1403;
found0 = true
}
if k0 == "alle2os" {
v0 = 9480;
found0 = true
}
if k0 == "perme2os" {
v0 = 9481;
found0 = true
}
if k0 == "alle1os" {
v0 = 9484;
found0 = true
}
if k0 == "alle2is" {
v0 = 9496;
found0 = true
}
if k0 == "perme2is" {
v0 = 9497;
found0 = true
}
if k0 == "alle1is" {
v0 = 9500;
found0 = true
}
if k0 == "alle2" {
v0 = 9528;
found0 = true
}
if k0 == "perme2" {
v0 = 9529;
found0 = true
}
if k0 == "alle1" {
v0 = 9532;
found0 = true
}
if k0 == "alle2osnxs" {
v0 = 9544;
found0 = true
}
if k0 == "perme2osnxs" {
v0 = 9545;
found0 = true
}
if k0 == "alle1osnxs" {
v0 = 9548;
found0 = true
}
if k0 == "alle2isnxs" {
v0 = 9560;
found0 = true
}
if k0 == "perme2isnxs" {
v0 = 9561;
found0 = true
}
if k0 == "alle1isnxs" {
v0 = 9564;
found0 = true
}
if k0 == "alle2nxs" {
v0 = 9592;
found0 = true
}
if k0 == "perme2nxs" {
v0 = 9593;
found0 = true
}
if k0 == "alle1nxs" {
v0 = 9596;
found0 = true
}
if k0 == "alle3os" {
v0 = 13576;
found0 = true
}
if k0 == "perme3os" {
v0 = 13577;
found0 = true
}
if k0 == "alle3is" {
v0 = 13592;
found0 = true
}
if k0 == "perme3is" {
v0 = 13593;
found0 = true
}
if k0 == "alle3" {
v0 = 13624;
found0 = true
}
if k0 == "perme3" {
v0 = 13625;
found0 = true
}
if k0 == "alle3osnxs" {
v0 = 13640;
found0 = true
}
if k0 == "perme3osnxs" {
v0 = 13641;
found0 = true
}
if k0 == "alle3isnxs" {
v0 = 13656;
found0 = true
}
if k0 == "perme3isnxs" {
v0 = 13657;
found0 = true
}
if k0 == "alle3nxs" {
v0 = 13688;
found0 = true
}
if k0 == "perme3nxs" {
v0 = 13689;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
const raw1: integer = v1
if !((((((v0 >> 0) & 7) << 5) | (((v0 >> 3) & 15) << 8) | (((v0 >> 7) & 15) << 12) | (((v0 >> 11) & 7) << 16)) & 61440) == ((3574112256) & 61440)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 7) << 5) | (((v0 >> 3) & 15) << 8) | (((v0 >> 7) & 15) << 12) | (((v0 >> 11) & 7) << 16) | (((v1 >> 0) & 31) << 0)
if !((true && (((word >> 12) & 15) == 10))) {
return list.of(false, 0, -1);
}
if !(((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 0) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 2)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 4) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 4)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 1) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 3) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 7) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 9) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 11) && (((word >> 5) & 7) == 1)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 0)) || ((((word >> 16) & 7) == 6) && (10 == 10) && (((word >> 8) & 15) == 15) && (((word >> 5) & 7) == 1))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gc22358138a574ebb(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
if !evaluate {
return list.of(true, 0, identity);
}
const word: integer = opcode | (((31 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 7)) && (((word >> 5) & 7) == 1))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g01baac078ef4212f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0)
if !(((((true && (((word >> 16) & 7) == 3)) && (((word >> 12) & 15) == 7)) && (((word >> 8) & 15) == 7)) && (((word >> 5) & 7) == 1))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g38bd83e7e54e0c65(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const k1: string = lower(replace(operand.text(p1), " ", ""))
let found1: bool = false
if k1 == "cdia" {
v1 = 0;
found1 = true
}
if k1 == "cdnmia" {
v1 = 1;
found1 = true
}
if !found1 && !starts_with(k1, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
if !found1 {
v1 = a64xs_number(numbers, list.get(keys, 1))
}
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 7) << 5)
if !((((true && (((word >> 16) & 7) == 0)) && (((word >> 12) & 15) == 12)) && (((word >> 8) & 15) == 3))) {
return list.of(false, 0, -1);
}
if !(((0 == 0) && (12 == 12) && (3 == 3) && (((word >> 5) & 7) == 0)) || ((0 == 0) && (12 == 12) && (3 == 3) && (((word >> 5) & 7) == 1))) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g531a288c79718f38(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_sysreg(p0, 2, false, numbers, p0, 0)
if len(r0) == 0 {
return list.of(false, 0, -1);
}
v0 = list.get(r0, 1)
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 1 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 1 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !((v2 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 1), 1)
if !(v2 == v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 7) << 5) | (((v0 >> 3) & 15) << 8) | (((v0 >> 7) & 15) << 12) | (((v0 >> 11) & 7) << 16) | (((v0 >> 14) & 1) << 19) | (((v1 >> 0) & 31) << 0)
if (((word >> 0) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gd33ca44dc1d5e2c3(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 1 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_sysreg(p2, 1, false, numbers, p2, 0)
if len(r2) == 0 {
return list.of(false, 0, -1);
}
v2 = list.get(r2, 1)
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 1 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((v1 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v1 = a64xs_div_signed((v1 - 1), 1)
if !(v1 == v0) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v2 >> 0) & 7) << 5) | (((v2 >> 3) & 15) << 8) | (((v2 >> 7) & 15) << 12) | (((v2 >> 11) & 7) << 16) | (((v2 >> 14) & 1) << 19)
if (((word >> 0) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_gf2226f0636de0c82(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
if !evaluate {
return list.of(true, 0, identity);
}
const word: integer = opcode | (((0 >> 0) & 1) << 10)
return list.of(true, word, identity);
}
fn a64xs_gde8d7c9276403f61(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "nb" {
v0 = 1;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
const word: integer = opcode | (((v0 >> 0) & 1) << 10)
return list.of(true, word, identity);
}
fn a64xs_g6a4318c912970ca8(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 1) << 17)
return list.of(true, word, identity);
}
fn a64xs_gbce2e85cd19bebaf(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const k2: string = lower(replace(operand.text(p2), " ", ""))
let found2: bool = false
if k2 == "nb" {
v2 = 1;
found2 = true
}
if !found2 && !starts_with(k2, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !found2 {
v2 = a64xs_number(numbers, list.get(keys, 2))
}
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 1) << 17)
return list.of(true, word, identity);
}
fn a64xs_gbd38a6671c68a267(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 0 && v1 <= 127) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 127) << 5) | (((0 >> 0) & 1) << 17)
return list.of(true, word, identity);
}
fn a64xs_ga984a003b1c31480(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
const k2: string = lower(replace(operand.text(p2), " ", ""))
let found2: bool = false
if k2 == "nb" {
v2 = 1;
found2 = true
}
if !found2 && !starts_with(k2, "#") {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
if !found2 {
v2 = a64xs_number(numbers, list.get(keys, 2))
}
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 0 && v1 <= 127) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 127) << 5) | (((v2 >> 0) & 1) << 17)
return list.of(true, word, identity);
}
fn a64xs_gab1a70145e9e4125(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 1 && v1 <= 64) {
return list.of(false, 0, -1);
}
if !((v1 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v1 = a64xs_div_signed((v1 - 1), 1)
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 63) << 15) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_g22fcd2ae5fa17c3c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v1 >= 18446744073709551615 || v1 <= 62)) {
return list.of(false, 0, -1);
}
if !((v1 - 18446744073709551615) % 1 == 0) {
return list.of(false, 0, -1);
}
v1 = a64xs_div_signed((v1 - 18446744073709551615), 1)
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 63) << 15) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_gf1d433d0af16ac5d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 1 && v1 <= 64) {
return list.of(false, 0, -1);
}
if !((v1 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v1 = a64xs_div_signed((v1 - 1), 1)
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 63) << 15) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_g2dc698977cd3b211(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
v2 = a64xs_sub(v2, instruction_address)
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v1 >= 18446744073709551615 || v1 <= 62)) {
return list.of(false, 0, -1);
}
if !((v1 - 18446744073709551615) % 1 == 0) {
return list.of(false, 0, -1);
}
v1 = a64xs_div_signed((v1 - 18446744073709551615), 1)
if !(true && true && (v2 >= 18446744073709550592 || v2 <= 1020)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 4 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 4)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 63) << 15) | (((v2 >> 0) & 511) << 5)
return list.of(true, word, identity);
}
fn a64xs_ga364a527b994ac77(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const p4: operand = list.get(captures, 4)
let v4: integer = 0
let s4: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 1 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "w" && v2 < 31) || k2 == "wzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
const r3: list = a64x_source_register(operand.text(p3))
if len(r3) == 0 {
return list.of(false, 0, -1);
}
const k3: string = list.get(r3, 0)
v3 = list.get(r3, 1)
if !(((k3 == "w" && v3 < 31) || k3 == "wzr")) {
return list.of(false, 0, -1);
}
if v3 < 1 || v3 > 31 {
return list.of(false, 0, -1);
}
const r4: list = a64x_source_register(operand.text(p4))
if len(r4) == 0 {
return list.of(false, 0, -1);
}
const k4: string = list.get(r4, 0)
v4 = list.get(r4, 1)
if !(((k4 == "x" && v4 < 31) || k4 == "sp")) {
return list.of(false, 0, -1);
}
if v4 < 0 || v4 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
const raw3: integer = v3
const raw4: integer = v4
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 1 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((v1 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v1 = a64xs_div_signed((v1 - 1), 1)
if !(v1 == v0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v3 >= 1 && v3 <= 31) {
return list.of(false, 0, -1);
}
if !((v3 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 1), 1)
if !(v3 == v2) {
return list.of(false, 0, -1);
}
if !(v4 >= 0 && v4 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 0) | (((v4 >> 0) & 31) << 5)
if (((word >> 16) & 1) == 1) || (((word >> 0) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g917f92fe39d8f1a7(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const p4: operand = list.get(captures, 4)
let v4: integer = 0
let s4: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 1 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
const r3: list = a64x_source_register(operand.text(p3))
if len(r3) == 0 {
return list.of(false, 0, -1);
}
const k3: string = list.get(r3, 0)
v3 = list.get(r3, 1)
if !(((k3 == "x" && v3 < 31) || k3 == "xzr")) {
return list.of(false, 0, -1);
}
if v3 < 1 || v3 > 31 {
return list.of(false, 0, -1);
}
const r4: list = a64x_source_register(operand.text(p4))
if len(r4) == 0 {
return list.of(false, 0, -1);
}
const k4: string = list.get(r4, 0)
v4 = list.get(r4, 1)
if !(((k4 == "x" && v4 < 31) || k4 == "sp")) {
return list.of(false, 0, -1);
}
if v4 < 0 || v4 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
const raw3: integer = v3
const raw4: integer = v4
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 1 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((v1 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v1 = a64xs_div_signed((v1 - 1), 1)
if !(v1 == v0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v3 >= 1 && v3 <= 31) {
return list.of(false, 0, -1);
}
if !((v3 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 1), 1)
if !(v3 == v2) {
return list.of(false, 0, -1);
}
if !(v4 >= 0 && v4 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 0) | (((v4 >> 0) & 31) << 5)
if (((word >> 16) & 1) == 1) || (((word >> 0) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g92497e9b333d1f0f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "lane_d")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p1) {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
v1 = a64xs_number(numbers, list.get(keys, 1))
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && v1 >= 0 && v1 <= 1) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 1) << 30) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gae939cde954f9def(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const p4: operand = list.get(captures, 4)
let v4: integer = 0
let s4: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 1 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
const r3: list = a64x_source_register(operand.text(p3))
if len(r3) == 0 {
return list.of(false, 0, -1);
}
const k3: string = list.get(r3, 0)
v3 = list.get(r3, 1)
if !(((k3 == "x" && v3 < 31) || k3 == "xzr")) {
return list.of(false, 0, -1);
}
if v3 < 1 || v3 > 31 {
return list.of(false, 0, -1);
}
const r4: list = a64x_source_register(operand.text(p4))
if len(r4) == 0 {
return list.of(false, 0, -1);
}
const k4: string = list.get(r4, 0)
v4 = list.get(r4, 1)
if !(((k4 == "x" && v4 < 31) || k4 == "sp")) {
return list.of(false, 0, -1);
}
if v4 < 0 || v4 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
const raw3: integer = v3
const raw4: integer = v4
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 1 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !((v1 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v1 = a64xs_div_signed((v1 - 1), 1)
if !(v1 == v0) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v3 >= 1 && v3 <= 31) {
return list.of(false, 0, -1);
}
if !((v3 - 1) % 1 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 1), 1)
if !(v3 == v2) {
return list.of(false, 0, -1);
}
if !(v4 >= 0 && v4 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 0) | (((v4 >> 0) & 31) << 5)
if (((word >> 16) & 1) == 1) {
return list.of(false, 0, -1);
}
if (((word >> 0) & 1) == 1) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g6917f99beb3c7dd2(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
if (((word >> 0) & 31) == 31) {
return list.of(false, 0, -1);
}
if (((word >> 16) & 31) == 31) {
return list.of(false, 0, -1);
}
return list.of(true, word, identity);
}
fn a64xs_g6d21c103fe3d29f1(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v0) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g1c0a9706f3af547c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g36fa28993f47de09(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v0) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v1) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g28153dbc84437561(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "w" && v1 < 31) || k1 == "wzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_ge2b8ad1d08ff108c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v0) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g17914c9d47397985(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v0) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v1) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gf871eb4f52d7cd2d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "w" && v0 < 31) || k0 == "wzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 == 31 || v1 != v0) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g2b9189553a2bbbb8(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 == 31 || v1 != v0) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gff665a9bd0d62890(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
if !(v0 != 31 && v1 != 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gb53ec516bd269c4c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v2) {
return list.of(false, 0, -1);
}
if !(v0 != 31 && v2 != 31) {
return list.of(false, 0, -1);
}
if !(v1 != v0 && v1 != v2 && v1 != 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_gbbf897fb9a3d0fa2(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
if !(v0 != 31 && v1 != 31) {
return list.of(false, 0, -1);
}
if !(v2 != v0 && v2 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_gbe7a1a9e8977598b(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v3 >= 18446744073709551104 || v3 <= 504)) {
return list.of(false, 0, -1);
}
if !((v3 - 0) % 8 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 0), 8)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((v3 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_g244dcea8dbf2c352(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((0 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_g508fc4efb0f3c091(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v3 >= 18446744073709551104 || v3 <= 504)) {
return list.of(false, 0, -1);
}
if !((v3 - 0) % 8 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 0), 8)
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((v3 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_gaccdabaa338e079a(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "q")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "q")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((0 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_g8cf78d1d85c60c36(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "q")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "q")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v3 >= 18446744073709550592 || v3 <= 1008)) {
return list.of(false, 0, -1);
}
if !((v3 - 0) % 16 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 0), 16)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((v3 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_g043c825af9a76a58(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "q")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "q")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((0 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_g8e46bc5bc235e95d(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !((k0 == "q")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !((k1 == "q")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v3 >= 18446744073709550592 || v3 <= 1008)) {
return list.of(false, 0, -1);
}
if !((v3 - 0) % 16 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 0), 16)
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((v3 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_g16beaab3d012fbc4(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v3 >= 18446744073709551104 || v3 <= 504)) {
return list.of(false, 0, -1);
}
if !((v3 - 0) % 8 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 0), 8)
if !(v2 == 31 || v2 != v0) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((v3 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_g889cb77e798bc231(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const p3: operand = list.get(captures, 3)
let v3: integer = 0
let s3: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p3) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
v3 = a64xs_number(numbers, list.get(keys, 3))
const raw3: integer = v3
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v3 >= 18446744073709551104 || v3 <= 504)) {
return list.of(false, 0, -1);
}
if !((v3 - 0) % 8 == 0) {
return list.of(false, 0, -1);
}
v3 = a64xs_div_signed((v3 - 0), 8)
if !(v2 == 31 || v2 != v0) {
return list.of(false, 0, -1);
}
if !(v2 == 31 || v2 != v1) {
return list.of(false, 0, -1);
}
if !(v0 != v1) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 10) | (((v2 >> 0) & 31) << 5) | (((v3 >> 0) & 127) << 15)
return list.of(true, word, identity);
}
fn a64xs_g9f2c1f1ae4fffd93(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const k0: string = lower(replace(operand.text(p0), " ", ""))
let found0: bool = false
if k0 == "pldkeep" {
v0 = 152;
found0 = true
}
if k0 == "pstkeep" {
v0 = 153;
found0 = true
}
if k0 == "pldstrm" {
v0 = 156;
found0 = true
}
if k0 == "pststrm" {
v0 = 157;
found0 = true
}
if !found0 && !starts_with(k0, "#") {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
if !found0 {
v0 = a64xs_number(numbers, list.get(keys, 0))
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !((((((v0 >> 0) & 31) << 0) | (((v0 >> 5) & 1) << 12) | (((v0 >> 6) & 7) << 13)) & 16408) == ((4171253784) & 16408)) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v0 >> 5) & 1) << 12) | (((v0 >> 6) & 7) << 13) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g4b85e7911b30255f(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
if !a64xs_numeric_shape(p0) {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "xzr")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "sp")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
v0 = a64xs_number(numbers, list.get(keys, 0))
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(true && true && v0 >= 0 && v0 <= 63) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 7) << 0) | (((v0 >> 3) & 1) << 12) | (((v0 >> 4) & 1) << 13) | (((v0 >> 5) & 1) << 15) | (((v1 >> 0) & 31) << 16) | (((v2 >> 0) & 31) << 5)
return list.of(true, word, identity);
}
fn a64xs_g63a22feba12e9c1c(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12) | (((0 >> 9) & 1) << 22)
return list.of(true, word, identity);
}
fn a64xs_ge92dac5e276fe7df(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709547520 || v2 <= 4088)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 8 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 8)
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12) | (((v2 >> 9) & 1) << 22)
return list.of(true, word, identity);
}
fn a64xs_g85948e52aa4361e8(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 == 31 || v1 != v0) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((0 >> 0) & 511) << 12) | (((0 >> 9) & 1) << 22)
return list.of(true, word, identity);
}
fn a64xs_g3ccdb1793a8861bf(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "xzr")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !a64xs_numeric_shape(p2) {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
v2 = a64xs_number(numbers, list.get(keys, 2))
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(true && true && (v2 >= 18446744073709547520 || v2 <= 4088)) {
return list.of(false, 0, -1);
}
if !((v2 - 0) % 8 == 0) {
return list.of(false, 0, -1);
}
v2 = a64xs_div_signed((v2 - 0), 8)
if !(v1 == 31 || v1 != v0) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 511) << 12) | (((v2 >> 9) & 1) << 22)
return list.of(true, word, identity);
}
fn a64xs_g0dc793e637578996(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "sp")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((31 >> 0) & 31) << 16)
return list.of(true, word, identity);
}
fn a64xs_g74f2ad0f23d6e800(captures: list, keys: list, opcode: integer, identity: integer, evaluate: bool, numbers: list, instruction_address: integer) -> list {
const p0: operand = list.get(captures, 0)
let v0: integer = 0
let s0: integer = 0
const p1: operand = list.get(captures, 1)
let v1: integer = 0
let s1: integer = 0
const p2: operand = list.get(captures, 2)
let v2: integer = 0
let s2: integer = 0
const r0: list = a64x_source_register(operand.text(p0))
if len(r0) == 0 {
return list.of(false, 0, -1);
}
const k0: string = list.get(r0, 0)
v0 = list.get(r0, 1)
if !(((k0 == "x" && v0 < 31) || k0 == "sp")) {
return list.of(false, 0, -1);
}
if v0 < 0 || v0 > 31 {
return list.of(false, 0, -1);
}
const r1: list = a64x_source_register(operand.text(p1))
if len(r1) == 0 {
return list.of(false, 0, -1);
}
const k1: string = list.get(r1, 0)
v1 = list.get(r1, 1)
if !(((k1 == "x" && v1 < 31) || k1 == "sp")) {
return list.of(false, 0, -1);
}
if v1 < 0 || v1 > 31 {
return list.of(false, 0, -1);
}
const r2: list = a64x_source_register(operand.text(p2))
if len(r2) == 0 {
return list.of(false, 0, -1);
}
const k2: string = list.get(r2, 0)
v2 = list.get(r2, 1)
if !(((k2 == "x" && v2 < 31) || k2 == "xzr")) {
return list.of(false, 0, -1);
}
if v2 < 0 || v2 > 31 {
return list.of(false, 0, -1);
}
if !evaluate {
return list.of(true, 0, identity);
}
const raw0: integer = v0
const raw1: integer = v1
const raw2: integer = v2
if !(v0 >= 0 && v0 <= 31) {
return list.of(false, 0, -1);
}
if !(v1 >= 0 && v1 <= 31) {
return list.of(false, 0, -1);
}
if !(v2 >= 0 && v2 <= 31) {
return list.of(false, 0, -1);
}
const word: integer = opcode | (((v0 >> 0) & 31) << 0) | (((v1 >> 0) & 31) << 5) | (((v2 >> 0) & 31) << 16)
return list.of(true, word, identity);
}

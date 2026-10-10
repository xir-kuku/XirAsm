emit.u8(0xaa)
reserve(3)
emit.u8(0)
assert(here() == 5)
assert(file_cursor_real() == 5)
assert(tail_reserve_size() == 0)

reserve(2)
align(8, 0xcc)
assert(here() == 8)
assert(file_cursor_real() == 8)
assert(tail_reserve_size() == 0)

output.section("next", 0x1000)
assert(file_cursor_real() == 8)
emit.u8(0xbb)

defer {
    assert(region_file_size(0) == 8)
    assert(region_logical_size(0) == 8)
    assert(region_file_offset(0x1000) == 8)
}

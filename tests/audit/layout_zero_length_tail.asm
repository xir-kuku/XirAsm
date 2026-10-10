emit.u8(0xaa)
reserve(3)
emit.bytes(b"")
db(b"")
pad(0)
pad_to(4)
align(4)

assert(here() == 4)
assert(file_cursor_real() == 1)
assert(file_cursor_potential() == 4)
assert(tail_reserve_size() == 3)

output.section("next", 0x1000)
assert(file_cursor_real() == 1)
emit.u8(0xbb)

late_layout {
    emit.bytes(b"")
    align(4)
    assert(file_cursor_real() == 1)
    assert(tail_reserve_size() == 3)
}

defer {
    assert(region_file_size(0) == 1)
    assert(region_logical_size(0) == 4)
    assert(region_file_offset(0x1000) == 1)
}

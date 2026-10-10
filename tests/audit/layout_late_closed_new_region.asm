emit.u8(0xaa)
region.file_align(8)

late_layout {
    region.begin("late", 0x1000, 8)
    emit.u8(0xbb)
}

defer {
    assert(region_file_size(0) == 8)
    assert(region_logical_size(0) == 1)
    assert(region_file_offset(0x1000) == 8)
}

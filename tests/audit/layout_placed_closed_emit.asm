virtual.begin(0x1000)
scratch:
emit.u8(0xaa)
region.file_align(8)
virtual.end()

region.place("scratch", 0x2000, 0)
emit.u8(0xbb)

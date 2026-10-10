// ZIP container helpers for XIRASM.
//
// Design boundary (mirrors pe.inc):
// - The archive is one flat main region. Entries, the central directory, and
//   the end-of-central-directory record are emitted in file order. Do not
//   switch output regions while an archive is open.
// - Entry payloads are caller-supplied `bytes`. The CRC-32 is computed
//   eagerly with the engine crypto builtin and stored back before the
//   central directory is emitted, so entries need no placeholder backfill.
// - ZIP stores the directory AFTER the data. When `zip_finish` runs, every
//   offset and size is already known, so central directory and EOCD fields
//   are emitted directly. The only finalizer is `zip_verify`, which checks
//   the completed image instead of patching it.
// - Data alignment uses the zipalign extra field (id 0xd935) so uncompressed
//   entries are installed-aligned the way Android package tooling expects.
// - STORED (method 0) and DEFLATE (method 8) entries. ZIP64 and multi-disk
//   archives are out of scope and rejected by assertions. A deflated entry
//   stores the CRC-32 of the uncompressed bytes, so the final-image verifier
//   cannot re-scan its payload; it checks the headers there instead.
//
// Usage:
//   import("format/zip.inc");
//   zip_entry(b"AndroidManifest.xml", manifest_bytes);
//   zip_entry_aligned(b"lib/arm64-v8a/libdemo.so", so_bytes, 16384);
//   zip_entry_compressed(b"assets/readme.txt", text_bytes);
//   zip_finish();
//
// `zip_dos_time` and `zip_dos_date` are module-level `let` bindings; assign
// them once after the import to stamp every entry with fixed values for
// reproducible builds.

const zip_lfh_sig: u64 = 0x04034b50
const zip_cd_sig: u64 = 0x02014b50
const zip_eocd_sig: u64 = 0x06054b50
const zip_method_store: u64 = 0
const zip_method_deflate: u64 = 8
const zip_deflate_level_default: u64 = 6
const zip_version_needed: u64 = 20
const zip_version_made: u64 = 20
const zip_flag_utf8: u64 = 0x0800

// Local file header field offsets from the record start.
const zip_lfh_fixed_size: u64 = 30
const zip_lfh_flags_foa: u64 = 6
const zip_lfh_method_foa: u64 = 8
const zip_lfh_crc_foa: u64 = 14
const zip_lfh_csize_foa: u64 = 18
const zip_lfh_usize_foa: u64 = 22
const zip_lfh_namelen_foa: u64 = 26
const zip_lfh_extralen_foa: u64 = 28

// Central directory record.
const zip_cd_fixed_size: u64 = 46
const zip_cd_crc_foa: u64 = 16
const zip_cd_lfh_off_foa: u64 = 42

// End of central directory record.
const zip_eocd_fixed_size: u64 = 22
const zip_eocd_cd_size_foa: u64 = 12
const zip_eocd_cd_off_foa: u64 = 16

// zipalign-compatible alignment extra field.
const zip_extra_align_id: u64 = 0xd935

let zip_dos_time: u64 = 0
let zip_dos_date: u64 = 0x5c21

// One map per emitted entry, in file order: name, method, crc, size
// (uncompressed), csize (stored size), lfh_foa, data_foa, flags, extra_len,
// alignment.
let zip_entries: list = list.new()
let zip_finished: bool = false
let zip_expected: u64 = file_offset()

defer {
    assert(zip_finished, "zip archive is missing zip_finish");
}

// CRC-32 (IEEE 802.3, reflected, polynomial 0xedb88320) via the engine
// crypto builtin, which is native-speed: any payload size hashes in
// negligible compile time, so both the eager per-entry pass and the
// final-image verifier re-scan stay instant.
fn zip_crc32_chunked(begin: u64, end: u64) -> u64 {
    if end <= begin {
        return 0;
    }
    return crypto.crc32(load.bytes(begin, end - begin));
}

// Small-range variant for names and final-image spot checks.
fn zip_crc32_range(begin: u64, end: u64) -> u64 {
    return zip_crc32_chunked(begin, end);
}

// Total extra-field length that puts data at `foa + result` on an
// `alignment` boundary. Zero when already aligned; at least 4 bytes
// (the id/size header) and even otherwise.
fn zip_align_extra_len(foa: u64, alignment: u64) -> u64 {
    assert(alignment >= 4, "zip data alignment must be at least 4 (zipalign rule)");
    assert(alignment <= 0x8000 && (alignment & (alignment - 1)) == 0, "zip alignment must be a power of two no greater than 32768");
    const raw: u64 = (alignment - (foa % alignment)) % alignment
    let total = 0
    if raw > 0 {
        total = raw
        if total < 4 {
            total = total + alignment
        }
    }
    return total;
}

// Data alignment: `data_alignment` 0 or 1 means the zipalign standard of
// 4-byte alignment for uncompressed entries, which `zipalign -c 4` checks on
// every entry (not only shared libraries). Larger values (e.g. 16384 for
// Android 15+ shared libraries) imply the 4-byte rule.
fn zip_entry_method(name: bytes, data: bytes, flags: u64, data_alignment: u64, method: u64, level: u64) {
    assert(!zip_finished, "zip archive is already finished");
    assert(here() == file_offset(), "zip output address must equal its file offset");
    assert(file_offset() == zip_expected, "zip output changed between entries");
    assert(len(name) > 0, "zip entry name must not be empty");
    assert(len(name) <= 0xffff, "zip entry name is too long");
    assert(len(zip_entries) < 0xfffe, "zip entry count requires ZIP64");
    assert(len(data) < 0xffffffff, "zip entry size requires ZIP64");
    assert(method == zip_method_store || method == zip_method_deflate, "zip entry method is not supported");
    assert((flags & ~zip_flag_utf8) == 0, "zip entry flags request an unsupported ZIP feature");
    assert(zip_dos_time <= 0xffff && zip_dos_date <= 0xffff, "zip timestamp exceeds its 16-bit field");

    let entry_align: u64 = data_alignment
    if entry_align <= 1 {
        entry_align = 4;
    }

    // Name scan in scratch space: UTF-8 detection for the flag bit.
    virtual.begin();
    const scan_base: u64 = here()
    emit.bytes(name);
    let high_byte = 0
    let remaining: u64 = 0
    let scalar: u64 = 0
    let minimum: u64 = 0
    let p = scan_base
    const name_end: u64 = scan_base + len(name)
    while p < name_end {
        const byte: u64 = load.u8(p)
        assert(byte != 0 && byte != 92, "zip entry name contains NUL or a backslash");
        assert(p != scan_base || byte != 47, "zip entry name is an absolute path");
        assert(p != scan_base + 1 || byte != 58, "zip entry name contains a drive prefix");
        if byte >= 0x80 {
            high_byte = 1
        }
        if remaining == 0 {
            if byte < 0x80 {
            } else if byte >= 0xc2 && byte <= 0xdf {
                remaining = 1
                scalar = byte & 31
                minimum = 0x80
            } else if byte >= 0xe0 && byte <= 0xef {
                remaining = 2
                scalar = byte & 15
                minimum = 0x800
            } else if byte >= 0xf0 && byte <= 0xf4 {
                remaining = 3
                scalar = byte & 7
                minimum = 0x10000
            } else {
                assert(false, "zip entry name is invalid UTF-8");
            }
        } else {
            assert(byte >= 0x80 && byte <= 0xbf, "zip entry name is invalid UTF-8");
            scalar = (scalar << 6) | (byte & 63)
            remaining = remaining - 1
            if remaining == 0 {
                assert(scalar >= minimum && scalar <= 0x10ffff && (scalar < 0xd800 || scalar > 0xdfff), "zip entry name is invalid UTF-8");
            }
        }
        p = p + 1
    }
    assert(remaining == 0, "zip entry name is truncated UTF-8");
    virtual.end();

    const use_flags: u64 = flags | high_byte * zip_flag_utf8

    // The CRC always covers the uncompressed bytes, whichever method stores
    // them; that is what a reader checks after it decodes the entry.
    let payload: bytes = data
    if method == zip_method_deflate {
        payload = deflate.compress(data, level);
    }
    const crc: u64 = crypto.crc32(data)
    const csize: u64 = len(payload)
    const usize: u64 = len(data)
    assert(csize < 0xffffffff, "zip compressed size requires ZIP64");

    const lfh_foa: u64 = file_offset()
    const name_len: u64 = len(name)
    const extra_len: u64 = zip_align_extra_len(lfh_foa + zip_lfh_fixed_size + name_len, entry_align)
    assert(extra_len <= 0xffff, "zip alignment extra field exceeds 16 bits");
    assert(lfh_foa + zip_lfh_fixed_size + name_len + extra_len + csize < 0xffffffff, "zip entry offset requires ZIP64");

    emit.u32(zip_lfh_sig);
    emit.u16(zip_version_needed);
    emit.u16(use_flags);
    emit.u16(method);
    emit.u16(zip_dos_time);
    emit.u16(zip_dos_date);
    emit.u32(crc);
    emit.u32(csize);
    emit.u32(usize);
    emit.u16(name_len);
    emit.u16(extra_len);
    emit.bytes(name);
    if extra_len > 0 {
        emit.u16(zip_extra_align_id);
        emit.u16(extra_len - 4);
        emit.bytes(bytes.repeat(extra_len - 4, 0));
    }

    const data_foa: u64 = file_offset()
    assert(data_foa % entry_align == 0, "zip entry data did not land on the requested alignment");
    emit.bytes(payload);

    let entry = map.new()
    map.set_mut(entry, "name", name);
    map.set_mut(entry, "method", method);
    map.set_mut(entry, "crc", crc);
    map.set_mut(entry, "size", usize);
    map.set_mut(entry, "csize", csize);
    map.set_mut(entry, "lfh_foa", lfh_foa);
    map.set_mut(entry, "data_foa", data_foa);
    map.set_mut(entry, "flags", use_flags);
    map.set_mut(entry, "extra_len", extra_len);
    map.set_mut(entry, "alignment", entry_align);
    map.set_mut(entry, "time", zip_dos_time);
    map.set_mut(entry, "date", zip_dos_date);
    list.push_mut(zip_entries, entry);
    zip_expected = file_offset()
}

// Stored entry with the zipalign-default 4-byte data alignment.
fn zip_entry_full(name: bytes, data: bytes, flags: u64, data_alignment: u64) {
    zip_entry_method(name, data, flags, data_alignment, zip_method_store, 0);
}

// STORED entry with the zipalign-default 4-byte data alignment.
fn zip_entry(name: bytes, data: bytes) {
    zip_entry_full(name, data, 0, 0);
}

// STORED entry whose data starts on an `alignment` byte boundary using the
// zipalign extra field. Use 16384 for Android 15+ shared libraries.
fn zip_entry_aligned(name: bytes, data: bytes, alignment: u64) {
    zip_entry_full(name, data, 0, alignment);
}

// DEFLATE entry (method 8) at the given level. A reader gets the original bytes
// back from the CRC-32 this records, so a payload that does not shrink is
// better stored: a deflated stream carries its own block headers.
fn zip_entry_compressed_level(name: bytes, data: bytes, level: u64) {
    zip_entry_method(name, data, 0, 0, zip_method_deflate, level);
}

fn zip_entry_compressed(name: bytes, data: bytes) {
    zip_entry_compressed_level(name, data, zip_deflate_level_default);
}

// Emit the central directory and the end-of-central-directory record, then
// register the integrity verifier. The archive is complete after this call.
fn zip_finish() {
    assert(!zip_finished, "zip archive is already finished");
    assert(here() == file_offset(), "zip output address must equal its file offset");
    const entry_count: u64 = len(zip_entries)
    assert(entry_count < 0xffff, "zip entry count requires ZIP64");
    assert(file_offset() == zip_expected, "zip output changed between entries");

    let cd_size = 0
    for entry in zip_entries {
        cd_size = cd_size + zip_cd_fixed_size + len(map.get(entry, "name"));
    }
    assert(cd_size < 0xffffffff, "zip central directory requires ZIP64");

    const cd_foa: u64 = file_offset()
    assert(cd_foa + cd_size + zip_eocd_fixed_size < 0xffffffff, "zip archive requires ZIP64");

    for entry in zip_entries {
        emit.u32(zip_cd_sig);
        emit.u16(zip_version_made);
        emit.u16(zip_version_needed);
        emit.u16(map.get(entry, "flags"));
        emit.u16(map.get(entry, "method"));
        emit.u16(map.get(entry, "time"));
        emit.u16(map.get(entry, "date"));
        emit.u32(map.get(entry, "crc"));
        emit.u32(map.get(entry, "csize"));
        emit.u32(map.get(entry, "size"));
        emit.u16(len(map.get(entry, "name")));
        emit.u16(0);
        emit.u16(0);
        emit.u16(0);
        emit.u16(0);
        emit.u32(0);
        emit.u32(map.get(entry, "lfh_foa"));
        emit.bytes(map.get(entry, "name"));
    }

    const eocd_foa: u64 = file_offset()
    emit.u32(zip_eocd_sig);
    emit.u16(0);
    emit.u16(0);
    emit.u16(entry_count);
    emit.u16(entry_count);
    emit.u32(cd_size);
    emit.u32(cd_foa);
    emit.u16(0);
    zip_finished = true

    defer {
        assert(region_file_size(0) == eocd_foa + zip_eocd_fixed_size, "zip archive has trailing bytes after the EOCD");
        assert(load.u32(eocd_foa) == zip_eocd_sig, "zip EOCD signature mismatch");
        assert(load.u32(eocd_foa + zip_eocd_cd_size_foa) == cd_size, "zip EOCD central directory size mismatch");
        assert(load.u32(eocd_foa + zip_eocd_cd_off_foa) == cd_foa, "zip EOCD central directory offset mismatch");
        if entry_count > 0 {
            assert(load.u32(cd_foa) == zip_cd_sig, "zip central directory signature mismatch");
        }

        let index = 0
        while index < entry_count {
            const entry: map = list.get(zip_entries, index)
            const lfh_foa: u64 = map.get(entry, "lfh_foa")
            const method: u64 = map.get(entry, "method")
            const size: u64 = map.get(entry, "size")
            const csize: u64 = map.get(entry, "csize")
            const data_foa: u64 = map.get(entry, "data_foa")
            const alignment: u64 = map.get(entry, "alignment")
            const extra_len: u64 = map.get(entry, "extra_len")
            const name_len: u64 = len(map.get(entry, "name"))

            assert(load.u32(lfh_foa) == zip_lfh_sig, "zip local header signature mismatch");
            assert(load.u16(lfh_foa + zip_lfh_method_foa) == method, "zip local header method mismatch");
            assert(load.u32(lfh_foa + zip_lfh_crc_foa) == map.get(entry, "crc"), "zip local header CRC mismatch");
            assert(load.u32(lfh_foa + zip_lfh_csize_foa) == csize, "zip local header compressed size mismatch");
            assert(load.u32(lfh_foa + zip_lfh_usize_foa) == size, "zip local header uncompressed size mismatch");
            assert(load.u16(lfh_foa + zip_lfh_namelen_foa) == name_len, "zip local header name length mismatch");
            assert(load.u16(lfh_foa + zip_lfh_extralen_foa) == extra_len, "zip local header extra length mismatch");
            assert(alignment <= 1 || data_foa % alignment == 0, "zip entry data alignment regressed in the final image");

            if method == zip_method_store {
                // Independent chunked CRC re-scan of the stored bytes in the
                // final image; safe for any payload size. A deflated entry
                // cannot be re-scanned here, because its CRC covers the bytes
                // a reader gets after decoding, so its headers are checked
                // instead and a decoder judges the payload afterwards.
                assert(zip_crc32_chunked(data_foa, data_foa + csize) == map.get(entry, "crc"), "zip stored data fails its CRC-32");
            } else {
                assert(csize <= size + (size / 16) + 64, "zip deflated entry grew beyond its stored form");
            }
            index = index + 1
        }
    }
}

// Android resource table (resources.arsc) builder for XIRASM.
//
// Design boundary (mirrors axml.inc / zip.inc):
// - Resources are described as compile-time data: arsc_new returns a document
//   and every arsc_* builder returns an updated document. Nothing is emitted
//   until arsc_build runs, so a document can be queried and reused first.
// - Chunk layout follows an aapt2 2.20 linked reference byte for byte:
//   ResTable header, global UTF-8 value pool, package chunk with a UTF-16
//   type name pool and a UTF-8 key pool, one type spec per type, then one
//   type chunk per (type, configuration).
// - Ordering is canonical rather than declaration order: type names and entry
//   names sort ascending, configurations sort by their 64-byte record, and
//   the value pool is sorted and deduplicated. Two documents holding the same
//   resources therefore produce identical bytes.
// - String values may use any script. A UTF-8 pool entry stores the UTF-16
//   code unit count and then the UTF-8 byte count, so the counts are measured
//   from the encoded bytes instead of assumed to be equal. Type names, package
//   names, and resource names stay ASCII, which is what Android requires of
//   them and what the UTF-16 type-name pool can transcode.
// - A file resource names an APK entry path; the caller emits that archive
//   entry too (see apk.inc) so the table and the archive agree.
// - Signing stays external (apksigner).

import("axml.inc");

const arsc_chunk_string_pool: u64 = 0x0001
const arsc_chunk_table: u64 = 0x0002
const arsc_chunk_package: u64 = 0x0200
const arsc_chunk_type: u64 = 0x0201
const arsc_chunk_type_spec: u64 = 0x0202

const arsc_package_header_size: u64 = 288
const arsc_config_bytes: u64 = 64
const arsc_config_key_bytes: u64 = 8
const arsc_entry_bytes: u64 = 16
const arsc_none: u64 = 0xffffffff

// Value kinds stored in a document.
const arsc_kind_string: u64 = 1
const arsc_kind_file: u64 = 2
const arsc_kind_int: u64 = 3
const arsc_kind_hex: u64 = 4
const arsc_kind_bool: u64 = 5
const arsc_kind_reference: u64 = 6

// Res_value data types.
const arsc_value_reference: u64 = 0x01
const arsc_value_string: u64 = 0x03
const arsc_value_int_dec: u64 = 0x10
const arsc_value_int_hex: u64 = 0x11
const arsc_value_boolean: u64 = 0x12

// Configuration axis bits recorded in a type spec entry.
const arsc_axis_locale: u64 = 0x0004
const arsc_axis_density: u64 = 0x0100

const arsc_density_nodpi: u64 = 0xfffe

// ---------------------------------------------------------------------------
// Documents and builders
// ---------------------------------------------------------------------------

fn arsc_new(package_name: string, package_id: u64) -> map {
    assert(len(package_name) > 0, "arsc package name must not be empty");
    assert(package_id >= 0x02 && package_id <= 0xff, "arsc package id must fit one byte");
    let doc: map = map.new()
    map.set_mut(doc, "package", package_name);
    map.set_mut(doc, "id", package_id);
    map.set_mut(doc, "res", list.new());
    return doc
}

fn arsc_density(name: string) -> u64 {
    if name == "ldpi" {
        return 120;
    }
    if name == "mdpi" {
        return 160;
    }
    if name == "tvdpi" {
        return 213;
    }
    if name == "hdpi" {
        return 240;
    }
    if name == "xhdpi" {
        return 320;
    }
    if name == "xxhdpi" {
        return 480;
    }
    if name == "xxxhdpi" {
        return 640;
    }
    if name == "nodpi" {
        return arsc_density_nodpi;
    }
    err("arsc density name is unknown", name);
    return 0;
}

fn arsc_item(type_name: string, name: string, kind: u64, text: string, value: u64, density: u64, locale: string) -> map {
    let item: map = map.new()
    map.set_mut(item, "type", type_name);
    map.set_mut(item, "name", name);
    map.set_mut(item, "kind", kind);
    map.set_mut(item, "text", text);
    map.set_mut(item, "value", value);
    map.set_mut(item, "density", density);
    map.set_mut(item, "locale", locale);
    return item
}

fn arsc_add(doc: map, type_name: string, name: string, kind: u64, text: string, value: u64, density: u64, locale: string) -> map {
    assert(len(type_name) > 0, "arsc resource type must not be empty");
    assert(len(name) > 0, "arsc resource name must not be empty");
    assert(android_ascii_identifier(type_name, false, true) && android_ascii_identifier(name, false, true), "arsc resource type and name must be Android identifiers");
    assert(len(locale) == 0 || len(locale) == 2, "arsc locale must be a two letter code");
    if locale != "" {
        let remaining: string = locale
        for letter in android_lowercase_letters {
            remaining = replace(remaining, letter, "")
        }
        assert(remaining == "", "arsc locale must contain lowercase letters");
    }
    assert(density <= 0xffff, "arsc density exceeds u16");
    assert(kind == arsc_kind_string || kind == arsc_kind_file || kind == arsc_kind_int || kind == arsc_kind_hex || kind == arsc_kind_bool || kind == arsc_kind_reference, "arsc value kind is not supported");
    assert(value <= 0xffffffff || value >= 0xffffffff80000000, "arsc value exceeds u32");
    const item: map = arsc_item(type_name, name, kind, text, value & 0xffffffff, density, locale)
    let items: list = map.get(doc, "res")
    for existing in items {
        assert(map.get(existing, "type") != type_name || map.get(existing, "name") != name || map.get(existing, "density") != density || map.get(existing, "locale") != locale, "arsc resource configuration is duplicated");
    }
    list.push_mut(items, item);
    return map.set(doc, "res", items)
}

// A string resource in the default configuration.
fn arsc_string(doc: map, name: string, text: string) -> map {
    return arsc_add(doc, "string", name, arsc_kind_string, text, 0, 0, "")
}

// A string resource in a two letter locale configuration.
fn arsc_string_locale(doc: map, name: string, text: string, locale: string) -> map {
    return arsc_add(doc, "string", name, arsc_kind_string, text, 0, 0, locale)
}

// A file resource. `path` is the APK entry name the value refers to.
fn arsc_file(doc: map, type_name: string, name: string, density_name: string, path: string) -> map {
    assert(len(path) > 0, "arsc file resource needs an APK path");
    let density: u64 = 0
    if density_name != "" {
        density = arsc_density(density_name);
    }
    return arsc_add(doc, type_name, name, arsc_kind_file, path, 0, density, "")
}

// A file resource in a locale configuration, optionally with a density.
fn arsc_file_locale(doc: map, type_name: string, name: string, density_name: string, locale: string, path: string) -> map {
    assert(len(path) > 0, "arsc file resource needs an APK path");
    let density: u64 = 0
    if density_name != "" {
        density = arsc_density(density_name);
    }
    return arsc_add(doc, type_name, name, arsc_kind_file, path, 0, density, locale)
}

fn arsc_int(doc: map, type_name: string, name: string, value: u64) -> map {
    return arsc_add(doc, type_name, name, arsc_kind_int, "", value, 0, "")
}

fn arsc_hex(doc: map, type_name: string, name: string, value: u64) -> map {
    return arsc_add(doc, type_name, name, arsc_kind_hex, "", value, 0, "")
}

fn arsc_bool(doc: map, type_name: string, name: string, value: bool) -> map {
    let data: u64 = 0
    if value {
        data = arsc_none;
    }
    return arsc_add(doc, type_name, name, arsc_kind_bool, "", data, 0, "")
}

// A reference resource holding another resource id.
fn arsc_reference(doc: map, type_name: string, name: string, target: u64) -> map {
    return arsc_add(doc, type_name, name, arsc_kind_reference, "", target, 0, "")
}

// ---------------------------------------------------------------------------
// Queries
// ---------------------------------------------------------------------------

fn arsc_utf8_count_bytes(count: u64) -> u64 {
    if count < 0x80 {
        return 1;
    }
    return 2
}

fn arsc_utf16_count_bytes(count: u64) -> u64 {
    if count < 0x8000 {
        return 2;
    }
    return 4
}

fn arsc_index_of(items: list, needle: string) -> u64 {
    let i: u64 = 0
    while i < len(items) {
        if list.get(items, i) == needle {
            return i;
        }
        i = i + 1
    }
    return arsc_none;
}

// Unique type names in first appearance order.
fn arsc_type_names(items: list) -> list {
    let names: list = list.new()
    for item in items {
        const type_name: string = map.get(item, "type")
        if arsc_index_of(names, type_name) == arsc_none {
            list.push_mut(names, type_name);
        }
    }
    return names
}

// Unique entry names of one type in first appearance order.
fn arsc_entry_names(items: list, type_name: string) -> list {
    let names: list = list.new()
    for item in items {
        if map.get(item, "type") == type_name {
            const name: string = map.get(item, "name")
            if arsc_index_of(names, name) == arsc_none {
                list.push_mut(names, name);
            }
        }
    }
    return names
}

fn arsc_config_new(density: u64, locale: string) -> map {
    let cfg: map = map.new()
    map.set_mut(cfg, "density", density);
    map.set_mut(cfg, "locale", locale);
    return cfg
}

fn arsc_config_is_default(cfg: map) -> bool {
    return map.get(cfg, "density") == 0 && map.get(cfg, "locale") == ""
}

fn arsc_config_axis(cfg: map) -> u64 {
    let flags: u64 = 0
    if map.get(cfg, "density") != 0 {
        flags = flags | arsc_axis_density
    }
    if map.get(cfg, "locale") != "" {
        flags = flags | arsc_axis_locale
    }
    return flags
}

fn arsc_config_index(configs: list, needle: map) -> u64 {
    let i: u64 = 0
    while i < len(configs) {
        const cfg: map = list.get(configs, i)
        if map.get(cfg, "density") == map.get(needle, "density") {
            if map.get(cfg, "locale") == map.get(needle, "locale") {
                return i;
            }
        }
        i = i + 1
    }
    return arsc_none;
}

// Unique configurations of one type in first appearance order.
fn arsc_type_configs(items: list, type_name: string) -> list {
    let configs: list = list.new()
    for item in items {
        if map.get(item, "type") == type_name {
            const cfg: map = arsc_config_new(map.get(item, "density"), map.get(item, "locale"))
            if arsc_config_index(configs, cfg) == arsc_none {
                list.push_mut(configs, cfg);
            }
        }
    }
    return configs
}

// Locate one resource value; returns an index into the document list.
fn arsc_find(items: list, type_name: string, name: string, density: u64, locale: string) -> u64 {
    let i: u64 = 0
    while i < len(items) {
        const item: map = list.get(items, i)
        if map.get(item, "type") == type_name {
            if map.get(item, "name") == name {
                if map.get(item, "density") == density {
                    if map.get(item, "locale") == locale {
                        return i;
                    }
                }
            }
        }
        i = i + 1
    }
    return arsc_none;
}

// ---------------------------------------------------------------------------
// Canonical ordering
// ---------------------------------------------------------------------------

// Compare two byte ranges of the current output area.
// result: 0 equal, 1 left is smaller, 2 left is larger.
fn arsc_band_cmp(let result, left: u64, left_len: u64, right: u64, right_len: u64) {
    let limit: u64 = left_len
    if right_len < limit {
        limit = right_len;
    }
    result = 0
    let i: u64 = 0
    while i < limit {
        const l: u64 = load.u8(left + i)
        const r: u64 = load.u8(right + i)
        if l < r {
            result = 1
        }
        if l > r {
            result = 2
        }
        if result != 0 {
            break;
        }
        i = i + 1
    }
    if result == 0 {
        if left_len < right_len {
            result = 1
        }
        if left_len > right_len {
            result = 2
        }
    }
}

// Selection sort of `count` equal-size records emitted at `start` in the
// current output area, producing the ascending index order.
fn arsc_order_records(let out, start: u64, count: u64, stride: u64) {
    let order: list = list.new()
    for i in range(0, count) {
        list.push_mut(order, i);
    }
    let a: u64 = 0
    while a < count {
        let best: u64 = a
        let b: u64 = a + 1
        while b < count {
            const here_b: u64 = start + stride * list.get(order, b)
            const here_best: u64 = start + stride * list.get(order, best)
            let cmp: u64 = 0
            arsc_band_cmp(cmp, here_b, stride, here_best, stride)
            if cmp == 1 {
                best = b
            }
            b = b + 1
        }
        if best != a {
            const held: u64 = list.get(order, a)
            list.set_mut(order, a, list.get(order, best));
            list.set_mut(order, best, held);
        }
        a = a + 1
    }
    out = order;
}

// Sort strings ascending by their bytes. Meta has no ordering comparison for
// strings, so the bytes are written to a scratch area and compared there.
fn arsc_sort_strings(let out, items: list) {
    const count: u64 = len(items)
    if count < 2 {
        out = items
    } else {
        virtual.begin();
        const band: u64 = here()
        let offsets: list = list.new()
        let lengths: list = list.new()
        let cursor: u64 = 0
        for text in items {
            list.push_mut(offsets, band + cursor);
            list.push_mut(lengths, len(text));
            emit.bytes(text);
            cursor = cursor + len(text)
        }

        let order: list = list.new()
        for i in range(0, count) {
            list.push_mut(order, i);
        }
        let a: u64 = 0
        while a < count {
            let best: u64 = a
            let b: u64 = a + 1
            while b < count {
                const at_b: u64 = list.get(order, b)
                const at_best: u64 = list.get(order, best)
                let cmp: u64 = 0
                arsc_band_cmp(cmp, list.get(offsets, at_b), list.get(lengths, at_b), list.get(offsets, at_best), list.get(lengths, at_best))
                if cmp == 1 {
                    best = b
                }
                b = b + 1
            }
            if best != a {
                const held: u64 = list.get(order, a)
                list.set_mut(order, a, list.get(order, best));
                list.set_mut(order, best, held);
            }
            a = a + 1
        }

        let result: list = list.new()
        for i in range(0, count) {
            list.push_mut(result, list.get(items, list.get(order, i)));
        }
        virtual.end();
        out = result;
    }
}

// ResTable_config record. Only the density and locale axes are compiled; every
// other axis stays zero, which is what a default configuration means.
fn arsc_emit_config(density: u64, locale: string) {
    const start: u64 = here()
    emit.u32(arsc_config_bytes);
    emit.u16(0);
    emit.u16(0);
    if len(locale) == 2 {
        emit.bytes(locale);
    } else {
        emit.u16(0);
    }
    emit.u16(0);
    emit.u8(0);
    emit.u8(0);
    emit.u16(density);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    assert(here() - start == arsc_config_bytes, "arsc configuration record drifted");
}

fn arsc_sort_configs(let out, configs: list) {
    const count: u64 = len(configs)
    if count < 2 {
        out = configs
    } else {
        virtual.begin();
        const band: u64 = here()
        for cfg in configs {
            arsc_emit_config_key(map.get(cfg, "density"), map.get(cfg, "locale"));
        }
        let order: list = list.new()
        arsc_order_records(order, band, count, arsc_config_key_bytes);
        let result: list = list.new()
        for i in range(0, count) {
            list.push_mut(result, list.get(configs, list.get(order, i)));
        }
        virtual.end();
        out = result;
    }
}

// Configuration order follows aapt2: locale first, then density compared as a
// number. The raw record cannot be byte compared, because a density shares its
// low byte with the stored little-endian value (640 looks smaller than 160),
// so ordering uses this fixed-width key instead.
fn arsc_emit_config_key(density: u64, locale: string) {
    const start: u64 = here()
    if len(locale) == 2 {
        emit.bytes(locale);
    } else {
        emit.u16(0);
    }
    emit.u16(0);
    emit.u8(density >> 8);
    emit.u8(density & 0xff);
    emit.u16(0);
    assert(here() - start == arsc_config_key_bytes, "arsc configuration key drifted");
}

fn arsc_dedup(items: list) -> list {
    let unique: list = list.new()
    let previous: string = ""
    let first: bool = true
    for text in items {
        if first {
            list.push_mut(unique, text);
            previous = text
            first = false
        } else {
            if text != previous {
                list.push_mut(unique, text);
                previous = text
            }
        }
    }
    return unique
}

// ---------------------------------------------------------------------------
// Encoders
// ---------------------------------------------------------------------------

fn arsc_emit_utf8_count(count: u64) {
    if count < 0x80 {
        emit.u8(count);
    } else {
        assert(count < 0x8000, "arsc string exceeds the UTF-8 pool length field");
        emit.u8(0x80 | (count >> 8));
        emit.u8(count & 0xff);
    }
}

// True when every byte of the text is ASCII. Meta strings are not indexable,
// so the bytes are written to a scratch area and inspected there.
fn arsc_text_is_ascii(let out, text: string) {
    const n: u64 = len(text)
    let ascii: bool = true
    if n > 0 {
        virtual.begin();
        const band: u64 = here()
        emit.bytes(text);
        let i: u64 = 0
        while i < n {
            if load.u8(band + i) >= 0x80 {
                ascii = false
            }
            i = i + 1
        }
        virtual.end();
    }
    out = ascii;
}

// Write one UTF-8 pool's strings into the raw band and record, for each of
// them, where it starts, its UTF-16 code unit count, and its encoded byte
// count.
//
// The encoded count is not always the source byte count: a code point above
// U+FFFF is stored as a surrogate pair with each half in its own three byte
// sequence, which is the encoding the platform's resource reader writes and
// expects. Four source bytes therefore become six encoded bytes and two code
// units. Everything below U+FFFF is copied unchanged.
fn arsc_pool_band(let offsets, let units, let lengths, let cursor, items: list, band: u64) {
    let index: u64 = 0
    while index < len(items) {
        const text: string = list.get(items, index)
        const n: u64 = len(text)
        list.push_mut(offsets, band + cursor);
        emit.bytes(text);
        let code_units: u64 = 0
        let encoded: u64 = 0
        let i: u64 = 0
        while i < n {
            const decoded: map = android_utf8_decode(band + cursor + i, band + cursor + n)
            if map.get(decoded, "value") >= 0x10000 {
                code_units = code_units + 2;
                encoded = encoded + 6;
            } else {
                code_units = code_units + 1
                encoded = encoded + map.get(decoded, "size");
            }
            i = i + map.get(decoded, "size")
        }
        list.push_mut(units, code_units);
        list.push_mut(lengths, encoded);
        cursor = cursor + n;
        index = index + 1
    }
}

// Emit one stored string as the pool encodes it: bytes pass through, and a
// four byte source sequence becomes the two three byte surrogate sequences.
fn arsc_emit_utf8_data(source: u64, bytes: u64) {
    let i: u64 = 0
    while i < bytes {
        const byte: u64 = load.u8(source + i)
        if byte >= 0xf0 && i + 4 <= bytes {
            const b1: u64 = load.u8(source + i + 1)
            const b2: u64 = load.u8(source + i + 2)
            const b3: u64 = load.u8(source + i + 3)
            const code_point: u64 = ((byte & 0x07) << 18) | ((b1 & 0x3f) << 12) | ((b2 & 0x3f) << 6) | (b3 & 0x3f)
            const remaining: u64 = code_point - 0x10000
            arsc_emit_utf8_sequence(0xd800 + (remaining >> 10));
            arsc_emit_utf8_sequence(0xdc00 + (remaining & 0x3ff));
            i = i + 4
        } else {
            emit.u8(byte);
            i = i + 1
        }
    }
}

fn arsc_emit_utf8_sequence(value: u64) {
    emit.u8(0xe0 | (value >> 12));
    emit.u8(0x80 | ((value >> 6) & 0x3f));
    emit.u8(0x80 | (value & 0x3f));
}

fn arsc_utf8_body(items: list, units: list, lengths: list) -> u64 {
    let body: u64 = 0
    let index: u64 = 0
    while index < len(items) {
        const code_units: u64 = list.get(units, index)
        const encoded: u64 = list.get(lengths, index)
        body = body + arsc_utf8_count_bytes(code_units) + arsc_utf8_count_bytes(encoded) + encoded + 1;
        index = index + 1
    }
    return body
}

fn arsc_utf8_pool_size(items: list, units: list, lengths: list) -> u64 {
    let size: u64 = 28 + 4 * len(items) + arsc_utf8_body(items, units, lengths)
    size = size + (4 - size % 4) % 4
    return size
}

// UTF-8 pool entry: [UTF-16 code units][UTF-8 bytes]<chars> 0x00.
fn arsc_emit_utf8_pool(items: list, units: list, lengths: list, sources: list) {
    const count: u64 = len(items)
    const body: u64 = arsc_utf8_body(items, units, lengths)
    const size: u64 = arsc_utf8_pool_size(items, units, lengths)
    const slack: u64 = size - (28 + 4 * count + body)

    emit.u16(arsc_chunk_string_pool);
    emit.u16(28);
    emit.u32(size);
    emit.u32(count);
    emit.u32(0);
    emit.u32(0x00000100);
    emit.u32(28 + 4 * count);
    emit.u32(0);
    let offset: u64 = 0
    let index: u64 = 0
    while index < count {
        emit.u32(offset);
        const code_units: u64 = list.get(units, index)
        const encoded: u64 = list.get(lengths, index)
        offset = offset + arsc_utf8_count_bytes(code_units) + arsc_utf8_count_bytes(encoded) + encoded + 1;
        index = index + 1
    }
    index = 0
    while index < count {
        const text: string = list.get(items, index)
        arsc_emit_utf8_count(list.get(units, index));
        arsc_emit_utf8_count(list.get(lengths, index));
        arsc_emit_utf8_data(list.get(sources, index), len(text));
        emit.u8(0);
        index = index + 1
    }
    for i in range(0, slack) {
        emit.u8(0);
    }
}

fn arsc_utf16_body(items: list) -> u64 {
    let body: u64 = 0
    for text in items {
        const n: u64 = len(text)
        body = body + arsc_utf16_count_bytes(n) + 2 * n + 2
    }
    return body
}

fn arsc_utf16_pool_size(items: list) -> u64 {
    let size: u64 = 28 + 4 * len(items) + arsc_utf16_body(items)
    size = size + (4 - size % 4) % 4
    return size
}

fn arsc_store_utf16_count(address: u64, count: u64) {
    if count < 0x8000 {
        store.u16(address, count);
    } else {
        store.u16(address, 0x8000 | (count >> 16));
        store.u16(address + 2, count & 0xffff);
    }
}

// UTF-16LE pool. Character bytes are transcoded from the raw ASCII band at
// `band_offsets`, because Meta strings are not indexable.
fn arsc_emit_utf16_pool(items: list, band_offsets: list) {
    const count: u64 = len(items)
    const body: u64 = arsc_utf16_body(items)
    const size: u64 = arsc_utf16_pool_size(items)
    const slack: u64 = size - (28 + 4 * count + body)

    emit.u16(arsc_chunk_string_pool);
    emit.u16(28);
    emit.u32(size);
    emit.u32(count);
    emit.u32(0);
    emit.u32(0);
    emit.u32(28 + 4 * count);
    emit.u32(0);
    let offset: u64 = 0
    for text in items {
        emit.u32(offset);
        const n: u64 = len(text)
        offset = offset + arsc_utf16_count_bytes(n) + 2 * n + 2
    }
    const data_base: u64 = here()
    for i in range(0, body) {
        emit.u8(0);
    }
    for i in range(0, slack) {
        emit.u8(0);
    }

    let run: u64 = 0
    let index: u64 = 0
    while index < count {
        const text: string = list.get(items, index)
        const n: u64 = len(text)
        const source: u64 = list.get(band_offsets, index)
        arsc_store_utf16_count(data_base + run, n);
        let j: u64 = 0
        while j < n {
            const ch: u64 = load.u8(source + j)
            assert(ch < 0x80, "arsc type and package names must be ASCII");
            store.u16(data_base + run + arsc_utf16_count_bytes(n) + 2 * j, ch);
            j = j + 1
        }
        store.u16(data_base + run + arsc_utf16_count_bytes(n) + 2 * n, 0);
        run = run + arsc_utf16_count_bytes(n) + 2 * n + 2;
        index = index + 1
    }
    assert(run == body, "arsc UTF-16 pool drifted");
}

fn arsc_emit_value(kind: u64, data: u64) {
    emit.u16(8);
    emit.u8(0);
    if kind == arsc_kind_string {
        emit.u8(arsc_value_string);
    } else {
        if kind == arsc_kind_file {
            emit.u8(arsc_value_string);
        } else {
            if kind == arsc_kind_int {
                emit.u8(arsc_value_int_dec);
            } else {
                if kind == arsc_kind_hex {
                    emit.u8(arsc_value_int_hex);
                } else {
                    if kind == arsc_kind_bool {
                        emit.u8(arsc_value_boolean);
                    } else {
                        emit.u8(arsc_value_reference);
                    }
                }
            }
        }
    }
    emit.u32(data);
}

// Package name field: 128 UTF-16LE code units, zero padded.
fn arsc_store_package_name(address: u64, source: u64, package_name: string) {
    const n: u64 = len(package_name)
    assert(n < 128, "arsc package name is too long");
    let i: u64 = 0
    while i < n {
        const ch: u64 = load.u8(source + i)
        assert(ch < 0x80, "arsc package name must be ASCII");
        store.u16(address + 2 * i, ch);
        i = i + 1
    }
    while i < 128 {
        store.u16(address + 2 * i, 0);
        i = i + 1
    }
}

// ---------------------------------------------------------------------------
// Sizes
// ---------------------------------------------------------------------------

fn arsc_type_spec_size(entry_count: u64) -> u64 {
    return 16 + 4 * entry_count
}

fn arsc_type_chunk_size(entry_count: u64, present: u64) -> u64 {
    return 20 + arsc_config_bytes + 4 * entry_count + arsc_entry_bytes * present
}

// ---------------------------------------------------------------------------
// Table assembly
// ---------------------------------------------------------------------------

fn arsc_present_count(items: list, type_name: string, type_entries: list, cfg: map) -> u64 {
    let present: u64 = 0
    let entry_at: u64 = 0
    while entry_at < len(type_entries) {
        if arsc_find(items, type_name, list.get(type_entries, entry_at), map.get(cfg, "density"), map.get(cfg, "locale")) != arsc_none {
            present = present + 1
        }
        entry_at = entry_at + 1
    }
    return present
}

fn arsc_build(let out, doc: map) {
    const items: list = map.get(doc, "res")
    const package_name: string = map.get(doc, "package")
    const package_id: u64 = map.get(doc, "id")

    // Canonical type order and entry order.
    const raw_types: list = arsc_type_names(items)
    let types: list = list.new()
    arsc_sort_strings(types, raw_types);

    let entries: list = list.new()
    for type_name in types {
        const raw_entries: list = arsc_entry_names(items, type_name)
        let ordered: list = list.new()
        arsc_sort_strings(ordered, raw_entries);
        list.push_mut(entries, ordered);
    }

    let configs: list = list.new()
    for type_name in types {
        const raw_configs: list = arsc_type_configs(items, type_name)
        let ordered: list = list.new()
        arsc_sort_configs(ordered, raw_configs);
        list.push_mut(configs, ordered);
    }

    // Value pool: string values and file paths, sorted and deduplicated.
    let raw_pool: list = list.new()
    for item in items {
        const kind: u64 = map.get(item, "kind")
        if kind == arsc_kind_string {
            list.push_mut(raw_pool, map.get(item, "text"));
        }
        if kind == arsc_kind_file {
            list.push_mut(raw_pool, map.get(item, "text"));
        }
    }
    let sorted_pool: list = list.new()
    arsc_sort_strings(sorted_pool, raw_pool);
    const value_pool: list = arsc_dedup(sorted_pool)

    let pool_index: map = map.new()
    let pool_at: u64 = 0
    while pool_at < len(value_pool) {
        map.set_mut(pool_index, list.get(value_pool, pool_at), pool_at);
        pool_at = pool_at + 1
    }

    // Key pool: type order, then entry order. Resource names must stay ASCII
    // identifiers; only string values may carry other scripts.
    let key_pool: list = list.new()
    for type_entries in entries {
        for name in type_entries {
            let name_ascii: bool = false
            arsc_text_is_ascii(name_ascii, name);
            assert(name_ascii, "arsc resource names must be ASCII");
            list.push_mut(key_pool, name);
        }
    }

    // Raw band behind the table: the type names the UTF-16 pool transcodes,
    // the package name, and the source bytes of both UTF-8 pools. The band pass
    // also measures each stored string, because the table size depends on the
    // code unit counts and the encoded byte counts.
    virtual.begin();
    const band: u64 = here()
    let band_offsets: list = list.new()
    let band_cursor: u64 = 0
    for text in types {
        list.push_mut(band_offsets, band + band_cursor);
        emit.bytes(text);
        band_cursor = band_cursor + len(text);
    }

    let value_sources: list = list.new()
    let value_units: list = list.new()
    let value_lengths: list = list.new()
    arsc_pool_band(value_sources, value_units, value_lengths, band_cursor, value_pool, band);

    let key_sources: list = list.new()
    let key_units: list = list.new()
    let key_lengths: list = list.new()
    arsc_pool_band(key_sources, key_units, key_lengths, band_cursor, key_pool, band);

    const name_source: u64 = band + band_cursor
    emit.bytes(package_name);

    const value_pool_size: u64 = arsc_utf8_pool_size(value_pool, value_units, value_lengths)
    const type_pool_size: u64 = arsc_utf16_pool_size(types)
    const key_pool_size: u64 = arsc_utf8_pool_size(key_pool, key_units, key_lengths)

    let package_size: u64 = arsc_package_header_size + type_pool_size + key_pool_size
    let type_at: u64 = 0
    while type_at < len(types) {
        const type_name: string = list.get(types, type_at)
        const type_entries: list = list.get(entries, type_at)
        const type_configs: list = list.get(configs, type_at)
        package_size = package_size + arsc_type_spec_size(len(type_entries));
        for cfg in type_configs {
            package_size = package_size + arsc_type_chunk_size(len(type_entries), arsc_present_count(items, type_name, type_entries, cfg));
        }
        type_at = type_at + 1
    }
    const table_size: u64 = 12 + value_pool_size + package_size

    const base: u64 = here()
    const package_base: u64 = base + 12 + value_pool_size

    emit.u16(arsc_chunk_table);
    emit.u16(12);
    emit.u32(table_size);
    emit.u32(1);

    arsc_emit_utf8_pool(value_pool, value_units, value_lengths, value_sources);

    emit.u16(arsc_chunk_package);
    emit.u16(arsc_package_header_size);
    emit.u32(package_size);
    emit.u32(package_id);
    for i in range(0, 256) {
        emit.u8(0);
    }
    emit.u32(arsc_package_header_size);
    emit.u32(0);
    emit.u32(arsc_package_header_size + type_pool_size);
    emit.u32(0);
    emit.u32(0);

    arsc_emit_utf16_pool(types, band_offsets);
    arsc_emit_utf8_pool(key_pool, key_units, key_lengths, key_sources);

    let key_base: u64 = 0
    type_at = 0
    while type_at < len(types) {
        const type_name: string = list.get(types, type_at)
        const type_entries: list = list.get(entries, type_at)
        const type_configs: list = list.get(configs, type_at)

        emit.u16(arsc_chunk_type_spec);
        emit.u16(16);
        emit.u32(arsc_type_spec_size(len(type_entries)));
        emit.u8(type_at + 1);
        emit.u8(0);
        emit.u16(len(type_configs));
        emit.u32(len(type_entries));
        let entry_at: u64 = 0
        while entry_at < len(type_entries) {
            let flags: u64 = 0
            for cfg in type_configs {
                if !arsc_config_is_default(cfg) {
                    if arsc_find(items, type_name, list.get(type_entries, entry_at), map.get(cfg, "density"), map.get(cfg, "locale")) != arsc_none {
                        flags = flags | arsc_config_axis(cfg);
                    }
                }
            }
            emit.u32(flags);
            entry_at = entry_at + 1
        }

        for cfg in type_configs {
            const present: u64 = arsc_present_count(items, type_name, type_entries, cfg)
            emit.u16(arsc_chunk_type);
            emit.u16(20 + arsc_config_bytes);
            emit.u32(arsc_type_chunk_size(len(type_entries), present));
            emit.u8(type_at + 1);
            emit.u8(0);
            emit.u16(0);
            emit.u32(len(type_entries));
            emit.u32(20 + arsc_config_bytes + 4 * len(type_entries));
            arsc_emit_config(map.get(cfg, "density"), map.get(cfg, "locale"));

            let run: u64 = 0
            entry_at = 0
            while entry_at < len(type_entries) {
                const found: u64 = arsc_find(items, type_name, list.get(type_entries, entry_at), map.get(cfg, "density"), map.get(cfg, "locale"))
                if found == arsc_none {
                    emit.u32(arsc_none);
                } else {
                    emit.u32(run);
                    run = run + arsc_entry_bytes
                }
                entry_at = entry_at + 1
            }

            entry_at = 0
            while entry_at < len(type_entries) {
                const found: u64 = arsc_find(items, type_name, list.get(type_entries, entry_at), map.get(cfg, "density"), map.get(cfg, "locale"))
                if found != arsc_none {
                    const item: map = list.get(items, found)
                    const kind: u64 = map.get(item, "kind")
                    emit.u16(8);
                    emit.u16(0);
                    emit.u32(key_base + entry_at);
                    if kind == arsc_kind_string || kind == arsc_kind_file {
                        arsc_emit_value(kind, map.get(pool_index, map.get(item, "text")));
                    } else {
                        arsc_emit_value(kind, map.get(item, "value"));
                    }
                }
                entry_at = entry_at + 1
            }
        }

        key_base = key_base + len(type_entries);
        type_at = type_at + 1
    }

    arsc_store_package_name(package_base + 12, name_source, package_name);
    assert(here() - base == table_size, "arsc table layout drifted");
    out = load.bytes(base, table_size);
    virtual.end();
}

// Resolve the numeric id of a declared resource: package, type, entry.
fn arsc_resolve_id(let out, doc: map, type_name: string, entry_name: string) {
    const items: list = map.get(doc, "res")
    const raw_types: list = arsc_type_names(items)
    let types: list = list.new()
    arsc_sort_strings(types, raw_types);
    const type_at: u64 = arsc_index_of(types, type_name)
    if type_at == arsc_none {
        err("arsc resource type is not declared", type_name);
    }
    const raw_entries: list = arsc_entry_names(items, type_name)
    let entries: list = list.new()
    arsc_sort_strings(entries, raw_entries);
    const entry_at: u64 = arsc_index_of(entries, entry_name)
    if entry_at == arsc_none {
        err("arsc resource name is not declared", entry_name);
    }
    out = (map.get(doc, "id") << 24) | ((type_at + 1) << 16) | entry_at;
}

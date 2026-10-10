// Binary Android XML (AXML) encoder for XIRASM.
//
// Design boundary (mirrors pe.inc / zip.inc):
// - The document is a plain compile-time map built with value-style calls
//   (every builder returns the updated document; nothing is emitted until
//   axml_build runs). This keeps AXML generation data-driven: manifests and
//   other Android XML trees are described as element/attribute lists.
// - Chunk layout follows an aapt2-linked reference byte for byte: UTF-16LE
//   string pool, optional resource map (attribute name -> framework id),
//   namespace chunks, and start/end element chunks with 20-byte attributes.
// - String values are interned into one deduplicated pool. The transcoder
//   validates UTF-8 and records UTF-16 code-unit lengths, including surrogate
//   pairs for supplementary characters.
// - The builder emits inside a scratch virtual area and copies the finished
//   chunk tree out as `bytes`, ready for zip_entry or further patching.

const axml_res_xml_type: u64 = 0x0003
const axml_res_string_pool_type: u64 = 0x0001
const axml_res_xml_resource_map_type: u64 = 0x0180
const axml_res_start_ns_type: u64 = 0x0100
const axml_res_end_ns_type: u64 = 0x0101
const axml_res_start_element_type: u64 = 0x0102
const axml_res_end_element_type: u64 = 0x0103

const axml_value_type_reference: u64 = 0x01
const axml_value_type_string: u64 = 0x03
const axml_value_type_int_dec: u64 = 0x10
const axml_value_type_int_hex: u64 = 0x11
const axml_value_type_boolean: u64 = 0x12
const axml_none: u64 = 0xffffffff

const android_lowercase_letters: list = list.of("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
const android_decimal_digits: list = list.of("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")

fn android_ascii_identifier(text: string, uppercase: bool, underscore_start: bool) -> bool {
    let starts: bool = underscore_start && starts_with(text, "_")
    let remaining: string = text
    for letter in android_lowercase_letters {
        if starts_with(text, letter) || (uppercase && starts_with(text, upper(letter))) {
            starts = true
        }
        remaining = replace(remaining, letter, "")
        if uppercase {
            remaining = replace(remaining, upper(letter), "")
        }
    }
    for digit in android_decimal_digits {
        remaining = replace(remaining, digit, "")
    }
    remaining = replace(remaining, "_", "")
    return starts && remaining == "";
}

// Decode one scalar from the source band, preserving its byte width.
fn android_utf8_decode(source: u64, end: u64) -> map {
    assert(source < end, "Android string is truncated UTF-8");
    const first: u64 = load.u8(source)
    let value: u64 = first
    let size: u64 = 1
    let minimum: u64 = 0
    if first >= 0x80 {
        if first >= 0xc2 && first <= 0xdf {
            value = first & 31
            size = 2
            minimum = 0x80
        } else if first >= 0xe0 && first <= 0xef {
            value = first & 15
            size = 3
            minimum = 0x800
        } else {
            assert(first >= 0xf0 && first <= 0xf4, "Android string is invalid UTF-8");
            value = first & 7
            size = 4
            minimum = 0x10000
        }
        assert(size <= end - source, "Android string is truncated UTF-8");
        for i in range(1, size) {
            const byte: u64 = load.u8(source + i)
            assert(byte >= 0x80 && byte <= 0xbf, "Android string is invalid UTF-8");
            value = (value << 6) | (byte & 63)
        }
        assert(value >= minimum && value <= 0x10ffff && (value < 0xd800 || value > 0xdfff), "Android string is invalid UTF-8");
    }
    let decoded: map = map.new()
    map.set_mut(decoded, "value", value);
    map.set_mut(decoded, "size", size);
    return decoded;
}

fn android_utf16_units(let out, text: string) {
    virtual.begin();
    const source: u64 = here()
    emit.bytes(text);
    let cursor: u64 = source
    let units: u64 = 0
    while cursor < source + len(text) {
        const decoded: map = android_utf8_decode(cursor, source + len(text))
        units = units + 1
        if map.get(decoded, "value") >= 0x10000 {
            units = units + 1
        }
        cursor = cursor + map.get(decoded, "size")
    }
    virtual.end();
    out = units;
}

fn android_utf16_length_size(units: u64) -> u64 {
    assert(units < 0x40000000, "Android string exceeds the UTF-16 pool length field");
    if units < 0x8000 {
        return 2;
    }
    return 4;
}

fn axml_without_last(items: list) -> list {
    assert(len(items) > 0, "axml stack is empty");
    let result: list = list.new()
    for i in range(0, len(items) - 1) {
        list.push_mut(result, list.get(items, i));
    }
    return result;
}

fn axml_require_namespace(doc: map, uri: string) {
    if uri != "" {
        let found: bool = false
        for entry in map.get(doc, "namespaces") {
            if map.get(entry, "uri") == uri {
                found = true
            }
        }
        assert(found, "axml namespace URI is not declared");
    }
}

fn axml_new() -> map {
    let doc: map = map.new()
    map.set_mut(doc, "pool", list.new());
    map.set_mut(doc, "lookup", map.new());
    map.set_mut(doc, "resmap", map.new());
    map.set_mut(doc, "nodes", list.new());
    map.set_mut(doc, "elements", list.new());
    map.set_mut(doc, "namespaces", list.new());
    return doc;
}

// Intern a string into the pool. Explicit interning lets callers fix the
// pool order (aapt2 keeps attribute names first for the resource map);
// element builders intern anything still missing in first-use order.
fn axml_pool_intern(doc: map, text: string) -> map {
    const lookup: map = map.get(doc, "lookup")
    if map.has(lookup, text) {
        return doc;
    }
    let pool: list = map.get(doc, "pool")
    list.push_mut(pool, text);
    let linked: map = map.set(doc, "lookup", map.set(lookup, text, len(pool) - 1))
    return map.set(linked, "pool", pool);
}

fn axml_pool_index(doc: map, text: string) -> u64 {
    const lookup: map = map.get(doc, "lookup")
    assert(map.has(lookup, text), "axml string was not interned");
    return map.get(lookup, text);
}

// Register a framework resource id for an attribute name; the resource map
// chunk emits one row per registered attribute in pool order.
fn axml_attr_resource_id(doc: map, attr_name: string, resource_id: u64) -> map {
    assert(resource_id <= 0xffffffff, "axml attribute resource id exceeds u32");
    const resmap: map = map.get(doc, "resmap")
    if map.has(resmap, attr_name) && map.get(resmap, attr_name) != 0 {
        assert(map.get(resmap, attr_name) == resource_id, "axml attribute resource id conflicts with its previous declaration");
    }
    return map.set(doc, "resmap", map.set(resmap, attr_name, resource_id));
}

fn axml_attr_entry(name: string, ns: string, kind: u64, data: u64, value_text: string) -> map {
    let attr: map = map.new()
    map.set_mut(attr, "name", name);
    map.set_mut(attr, "ns", ns);
    map.set_mut(attr, "kind", kind);
    map.set_mut(attr, "data", data);
    map.set_mut(attr, "value_text", value_text);
    return attr;
}

// An empty ns means the attribute carries no namespace (the package-level
// "package" attribute); otherwise ns is the namespace URI text.
fn axml_attr_string(name: string, ns: string, value: string) -> map {
    return axml_attr_entry(name, ns, axml_value_type_string, 0, value);
}

fn axml_attr_int(name: string, ns: string, value: u64) -> map {
    return axml_attr_entry(name, ns, axml_value_type_int_dec, value, "");
}

fn axml_attr_hex(name: string, ns: string, value: u64) -> map {
    return axml_attr_entry(name, ns, axml_value_type_int_hex, value, "");
}

// aapt2 encodes booleans as INT_BOOLEAN with data 0 for false and -1 for true.
fn axml_attr_bool(name: string, ns: string, value: u64) -> map {
    return axml_attr_entry(name, ns, axml_value_type_boolean, value, "");
}

// A reference to a resource by its full id (for example an application icon).
fn axml_attr_reference(name: string, ns: string, resource_id: u64) -> map {
    return axml_attr_entry(name, ns, axml_value_type_reference, resource_id, "");
}

fn axml_ns_start(doc: map, prefix: string, uri: string) -> map {
    assert(len(map.get(doc, "elements")) == 0, "axml namespace must be declared outside elements");
    assert(len(uri) > 0, "axml namespace URI must not be empty");
    let namespaces: list = map.get(doc, "namespaces")
    for entry in namespaces {
        assert(map.get(entry, "prefix") != prefix, "axml namespace prefix is already active");
    }
    let entry: map = map.new()
    map.set_mut(entry, "prefix", prefix);
    map.set_mut(entry, "uri", uri);
    list.push_mut(namespaces, entry);
    let linked: map = axml_pool_intern(doc, prefix)
    let complete: map = axml_pool_intern(linked, uri)
    let node: map = map.new()
    map.set_mut(node, "kind", axml_res_start_ns_type);
    map.set_mut(node, "prefix_idx", axml_pool_index(complete, prefix));
    map.set_mut(node, "uri_idx", axml_pool_index(complete, uri));
    let nodes: list = map.get(complete, "nodes")
    list.push_mut(nodes, node);
    return map.set(map.set(complete, "nodes", nodes), "namespaces", namespaces);
}

fn axml_ns_end(doc: map, prefix: string, uri: string) -> map {
    assert(len(map.get(doc, "elements")) == 0, "axml namespace must close outside elements");
    const namespaces: list = map.get(doc, "namespaces")
    assert(len(namespaces) > 0, "axml namespace has no matching start");
    const entry: map = list.get(namespaces, len(namespaces) - 1)
    assert(map.get(entry, "prefix") == prefix && map.get(entry, "uri") == uri, "axml namespace closing order does not match");
    let linked: map = axml_pool_intern(doc, prefix)
    let complete: map = axml_pool_intern(linked, uri)
    let node: map = map.new()
    map.set_mut(node, "kind", axml_res_end_ns_type);
    map.set_mut(node, "prefix_idx", axml_pool_index(complete, prefix));
    map.set_mut(node, "uri_idx", axml_pool_index(complete, uri));
    let nodes: list = map.get(complete, "nodes")
    list.push_mut(nodes, node);
    return map.set(map.set(complete, "nodes", nodes), "namespaces", axml_without_last(namespaces));
}

fn axml_start(doc: map, name: string, attrs: list) -> map {
    return axml_start_ns(doc, name, "", attrs);
}

fn axml_start_ns(doc: map, name: string, uri: string, attrs: list) -> map {
    axml_require_namespace(doc, uri);
    assert(len(attrs) <= 0xffff, "axml attribute count exceeds u16");
    let linked: map = axml_pool_intern(doc, name)
    const name_idx: u64 = axml_pool_index(linked, name)
    let element_ns: u64 = axml_none
    if uri != "" {
        linked = axml_pool_intern(linked, uri)
        element_ns = axml_pool_index(linked, uri)
    }

    let resolved: list = list.new()
    for attr in attrs {
        const ns: string = map.get(attr, "ns")
        axml_require_namespace(linked, ns);
        let ns_idx: u64 = axml_none
        if ns != "" {
            let ns_linked: map = axml_pool_intern(linked, ns)
            ns_idx = axml_pool_index(ns_linked, ns);
            linked = ns_linked
        }
        const attr_name: string = map.get(attr, "name")
        let named: map = axml_pool_intern(linked, attr_name)
        const attr_name_idx: u64 = axml_pool_index(named, attr_name)
        for previous in resolved {
            assert(map.get(previous, "name_idx") != attr_name_idx || map.get(previous, "ns_idx") != ns_idx, "axml attribute is duplicated");
        }

        const kind: u64 = map.get(attr, "kind")
        let raw_idx: u64 = axml_none
        let data: u64 = map.get(attr, "data")
        assert(kind == axml_value_type_string || kind == axml_value_type_int_dec || kind == axml_value_type_int_hex || kind == axml_value_type_boolean || kind == axml_value_type_reference, "axml attribute value kind is not supported");
        assert(data <= 0xffffffff || data >= 0xffffffff80000000, "axml attribute value exceeds u32");
        data = data & 0xffffffff
        if kind == axml_value_type_string {
            const value_text: string = map.get(attr, "value_text")
            let valued: map = axml_pool_intern(named, value_text)
            raw_idx = axml_pool_index(valued, value_text);
            data = raw_idx;
            named = valued
        }

        let row: map = map.new()
        map.set_mut(row, "ns_idx", ns_idx);
        map.set_mut(row, "name_idx", attr_name_idx);
        map.set_mut(row, "raw_idx", raw_idx);
        map.set_mut(row, "kind", kind);
        map.set_mut(row, "data", data);
        list.push_mut(resolved, row);
        linked = named
    }

    let node: map = map.new()
    map.set_mut(node, "kind", axml_res_start_element_type);
    map.set_mut(node, "name_idx", name_idx);
    map.set_mut(node, "ns_idx", element_ns);
    map.set_mut(node, "attrs", resolved);
    let nodes: list = map.get(linked, "nodes")
    list.push_mut(nodes, node);
    let elements: list = map.get(linked, "elements")
    list.push_mut(elements, node);
    return map.set(map.set(linked, "nodes", nodes), "elements", elements);
}

fn axml_end(doc: map, name: string) -> map {
    const elements: list = map.get(doc, "elements")
    assert(len(elements) > 0, "axml element has no matching start");
    const opening: map = list.get(elements, len(elements) - 1)
    assert(list.get(map.get(doc, "pool"), map.get(opening, "name_idx")) == name, "axml closing element does not match");
    let linked: map = axml_pool_intern(doc, name)
    const name_idx: u64 = axml_pool_index(linked, name)
    let node: map = map.new()
    map.set_mut(node, "kind", axml_res_end_element_type);
    map.set_mut(node, "name_idx", name_idx);
    map.set_mut(node, "ns_idx", map.get(opening, "ns_idx"));
    let nodes: list = map.get(linked, "nodes")
    list.push_mut(nodes, node);
    return map.set(map.set(linked, "nodes", nodes), "elements", axml_without_last(elements));
}

fn axml_build(let out, doc: map) {
    assert(len(map.get(doc, "elements")) == 0 && len(map.get(doc, "namespaces")) == 0, "axml document has unclosed elements or namespaces");
    const pool: list = map.get(doc, "pool")
    const nodes: list = map.get(doc, "nodes")
    const resmap_ids: map = map.get(doc, "resmap")
    const pool_count: u64 = len(pool)

    let pool_data: u64 = 0
    let pool_units: list = list.new()
    for text in pool {
        let units: u64 = 0
        android_utf16_units(units, text);
        list.push_mut(pool_units, units);
        pool_data = pool_data + android_utf16_length_size(units) + 2 * units + 2
    }
    const pool_padding: u64 = (4 - pool_data % 4) % 4
    const pool_size: u64 = 28 + 4 * pool_count + pool_data + pool_padding

    // The resource map is a positional array: row i holds the framework id of
    // string pool entry i, and rows for non-attribute strings stay zero. It
    // must cover every index up to the last attribute name, not only the
    // entries that registered an id.
    let resmap_count: u64 = 0
    let resmap_index: u64 = 0
    while resmap_index < pool_count {
        if map.has(resmap_ids, list.get(pool, resmap_index)) {
            resmap_count = resmap_index + 1
        }
        resmap_index = resmap_index + 1
    }
    let resmap_size: u64 = 0
    if resmap_count > 0 {
        resmap_size = 8 + 4 * resmap_count
    }

    let elements_size: u64 = 0
    for node in nodes {
        const kind: u64 = map.get(node, "kind")
        if kind == axml_res_start_element_type {
            const attrs: list = map.get(node, "attrs")
            elements_size = elements_size + 36 + 20 * len(attrs)
        }
        if kind == axml_res_end_element_type {
            elements_size = elements_size + 24
        }
        if kind == axml_res_start_ns_type {
            elements_size = elements_size + 24
        }
        if kind == axml_res_end_ns_type {
            elements_size = elements_size + 24
        }
    }
    const total: u64 = 8 + pool_size + resmap_size + elements_size
    assert(total < 0x100000000, "axml document exceeds u32");

    virtual.begin();
    const base: u64 = here()

    // Wrapper chunk; the total size is patched after assembly.
    emit.u16(axml_res_xml_type);
    emit.u16(8);
    emit.u32(0);

    // String pool: header, zeroed offset table, zeroed data area. The raw
    // UTF-8 strings ride behind the chunk tree as a scratch band and are
    // transcoded in place below.
    emit.u16(axml_res_string_pool_type);
    emit.u16(28);
    emit.u32(pool_size);
    emit.u32(pool_count);
    emit.u32(0);
    emit.u32(0);
    emit.u32(28 + 4 * pool_count);
    emit.u32(0);
    const offsets_base: u64 = here()
    for i in range(0, pool_count) {
        emit.u32(0);
    }
    const data_base: u64 = here()
    emit.bytes(bytes.repeat(pool_data + pool_padding, 0));

    if resmap_count > 0 {
        emit.u16(axml_res_xml_resource_map_type);
        emit.u16(8);
        emit.u32(resmap_size);
        for i in range(0, resmap_count) {
            const text: string = list.get(pool, i)
            if map.has(resmap_ids, text) {
                emit.u32(map.get(resmap_ids, text));
            } else {
                emit.u32(0);
            }
        }
    }

    for node in nodes {
        const kind: u64 = map.get(node, "kind")
        if kind == axml_res_start_ns_type {
            emit.u16(kind);
            emit.u16(16);
            emit.u32(24);
            emit.u32(0);
            emit.u32(axml_none);
            emit.u32(map.get(node, "prefix_idx"));
            emit.u32(map.get(node, "uri_idx"));
        }
        if kind == axml_res_end_ns_type {
            emit.u16(kind);
            emit.u16(16);
            emit.u32(24);
            emit.u32(0);
            emit.u32(axml_none);
            emit.u32(map.get(node, "prefix_idx"));
            emit.u32(map.get(node, "uri_idx"));
        }
        if kind == axml_res_start_element_type {
            const name_idx: u64 = map.get(node, "name_idx")
            const attrs: list = map.get(node, "attrs")
            emit.u16(kind);
            emit.u16(16);
            emit.u32(36 + 20 * len(attrs));
            emit.u32(0);
            emit.u32(axml_none);
            emit.u32(map.get(node, "ns_idx"));
            emit.u32(name_idx);
            emit.u16(20);
            emit.u16(20);
            emit.u16(len(attrs));
            let id_index: u64 = 0
            let class_index: u64 = 0
            let style_index: u64 = 0
            for i in range(0, len(attrs)) {
                const attr: map = list.get(attrs, i)
                const name: string = list.get(pool, map.get(attr, "name_idx"))
                const ns: u64 = map.get(attr, "ns_idx")
                if ns != axml_none && name == "id" {
                    if list.get(pool, ns) == "http://schemas.android.com/apk/res/android" {
                        id_index = i + 1
                    }
                }
                if ns == axml_none && name == "class" {
                    class_index = i + 1
                }
                if ns == axml_none && name == "style" {
                    style_index = i + 1
                }
            }
            emit.u16(id_index);
            emit.u16(class_index);
            emit.u16(style_index);
            for attr in attrs {
                emit.u32(map.get(attr, "ns_idx"));
                emit.u32(map.get(attr, "name_idx"));
                emit.u32(map.get(attr, "raw_idx"));
                emit.u16(8);
                emit.u8(0);
                emit.u8(map.get(attr, "kind"));
                emit.u32(map.get(attr, "data"));
            }
        }
        if kind == axml_res_end_element_type {
            emit.u16(kind);
            emit.u16(16);
            emit.u32(24);
            emit.u32(0);
            emit.u32(axml_none);
            emit.u32(map.get(node, "ns_idx"));
            emit.u32(map.get(node, "name_idx"));
        }
    }

    assert(here() - base == 8 + pool_size + resmap_size + elements_size, "axml layout drifted");

    // Scratch band: UTF-8 strings behind the AXML body.
    const draft_base: u64 = here()
    for text in pool {
        emit.bytes(text);
    }

    // Transcode in place: pool entry = u16 length, u16 chars, u16 NUL.
    let run: u64 = 0
    let draft_off: u64 = 0
    let i: u64 = 0
    while i < pool_count {
        const text: string = list.get(pool, i)
        const n: u64 = list.get(pool_units, i)
        const prefix: u64 = android_utf16_length_size(n)
        store.u32(offsets_base + 4 * i, run);
        if prefix == 2 {
            store.u16(data_base + run, n);
        } else {
            store.u16(data_base + run, 0x8000 | (n >> 16));
            store.u16(data_base + run + 2, n & 0xffff);
        }
        let source: u64 = draft_base + draft_off
        let unit: u64 = 0
        while source < draft_base + draft_off + len(text) {
            const decoded: map = android_utf8_decode(source, draft_base + draft_off + len(text))
            const scalar: u64 = map.get(decoded, "value")
            if scalar < 0x10000 {
                store.u16(data_base + run + prefix + 2 * unit, scalar);
                unit = unit + 1
            } else {
                store.u16(data_base + run + prefix + 2 * unit, 0xd800 + ((scalar - 0x10000) >> 10));
                store.u16(data_base + run + prefix + 2 * unit + 2, 0xdc00 + ((scalar - 0x10000) & 1023));
                unit = unit + 2
            }
            source = source + map.get(decoded, "size")
        }
        store.u16(data_base + run + prefix + 2 * n, 0);
        run = run + prefix + 2 * n + 2;
        draft_off = draft_off + len(text);
        i = i + 1
    }
    assert(run == pool_data, "axml transcode drifted");

    store.u32(base + 4, total);
    out = load.bytes(base, total);
    virtual.end();
}

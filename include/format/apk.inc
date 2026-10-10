// APK packaging helpers for XIRASM (NativeActivity flavor, stage 2).
//
// Design boundary (mirrors pe.inc / zip.inc):
// - This layer sits on `zip.inc` and adds the Android-specific entries:
//   a compiled binary AndroidManifest.xml (AXML), a minimal classes.dex
//   bootstrap, and aligned native libraries.
// - The manifest is assembled in one virtual area from a fixed
//   NativeActivity template. Chunk layout follows an aapt2-linked reference
//   manifest byte for byte: UTF-16LE string pool (attr names first, mirrored
//   by a resource-map chunk), u32 pool indices, 20-byte attributes with a
//   4-byte alignment gap after the element header fields.
// - Manifest strings are ASCII in stage 2 (asserted while transcoding);
//   full UTF-8/UTF-16 support belongs to the stage-4 axml/arsc work.
// - Assembly trick: the AXML body is emitted first with a zeroed string
//   pool data area; the raw ASCII strings are appended behind it as a
//   scratch band and transcoded in place via load/store. Only the AXML body
//   is copied out of the virtual area.
// - Attribute resource IDs are well-known framework constants verified
//   against a reference manifest; do not "fix" them from memory.
// - Signing stays external (apksigner).
// - The facade has two front doors. Resources can be declared one at a time, or
//   a `res/` tree can be scanned: the tree already encodes every coordinate a
//   resource needs, and reading it at compile time keeps the resource table and
//   the archive entries in step. See `apk_res_dir` below.

import("zip.inc");
import("axml.inc");
import("arsc.inc");

const apk_android_ns: string = "http://schemas.android.com/apk/res/android"

const apk_attr_theme: u64 = 0x01010000
const apk_attr_label: u64 = 0x01010001
const apk_attr_icon: u64 = 0x01010002
const apk_attr_name: u64 = 0x01010003
const apk_attr_hascode: u64 = 0x0101000c
const apk_attr_exported: u64 = 0x01010010
const apk_attr_value: u64 = 0x01010024
const apk_attr_version_code: u64 = 0x0101021b
const apk_attr_version_name: u64 = 0x0101021c
const apk_attr_min_sdk: u64 = 0x0101020c
const apk_attr_target_sdk: u64 = 0x01010270
const apk_attr_screen_orientation: u64 = 0x0101001e
const apk_attr_config_changes: u64 = 0x0101001f
const apk_attr_gl_es_version: u64 = 0x01010281
const apk_attr_required: u64 = 0x0101028e

let apk_min_sdk: u64 = 24
let apk_target_sdk: u64 = 35

// Module setters are used by callers because assignments to imported module
// bindings are intentionally local to the caller's scope.
fn apk_set_min_sdk(value: u64) {
    apk_min_sdk = value
}

fn apk_set_target_sdk(value: u64) {
    apk_target_sdk = value
}

// Minimal empty DEX 035 (112 bytes): header only, zero classes, valid
// Adler-32 checksum and SHA-1, as DEX 035 requires for an empty program.
fn apk_tiny_dex() -> bytes {
    return bytes.concat(
        bytes.concat(
            bytes.from_hex("6465780a30333500f10df7a10130d3e9"),
            bytes.from_hex("a89fb283e02a43e59eab6ebca05fd2ad")
        ),
        bytes.concat(
            bytes.concat(
                bytes.from_hex("70000000700000007856341200000000"),
                bytes.from_hex("00000000000000000000000000000000")
            ),
            bytes.concat(
                bytes.from_hex("00000000000000000000000000000000"),
                bytes.concat(
                    bytes.from_hex("00000000000000000000000000000000"),
                    bytes.from_hex("00000000000000000000000070000000")
                )
            )
        )
    );
}

// classes.dex entry for hasCode="false" applications.
fn apk_dex_entry() {
    zip_entry(b"classes.dex", apk_tiny_dex());
}

// Native library entry, uncompressed and 16 KB-aligned for Android 15+.
fn apk_lib(abi_dir: bytes, so_name: bytes, path: string) {
    assert(abi_dir == b"arm64-v8a" || abi_dir == b"x86_64", "apk native ELF requires arm64-v8a or x86_64");
    assert(len(so_name) > 6 && !contains(so_name, b"/") && !contains(so_name, b"\\") && !contains(so_name, b":") && !contains(so_name, b"\0"), "apk native library filename is invalid");
    virtual.begin();
    const name_start: u64 = here()
    emit.bytes(so_name);
    assert(load.u8(name_start) == 108 && load.u8(name_start + 1) == 105 && load.u8(name_start + 2) == 98, "apk native library filename must start with lib");
    assert(load.u8(name_start + len(so_name) - 3) == 46 && load.u8(name_start + len(so_name) - 2) == 115 && load.u8(name_start + len(so_name) - 1) == 111, "apk native library filename must end with .so");
    virtual.end();
    assert(fs.exists(path), "apk_lib input file does not exist");
    const prefix: bytes = bytes.concat(b"lib/", abi_dir)
    const entry_name: bytes = bytes.concat(prefix, bytes.concat(b"/", so_name))
    const payload: bytes = fs.read_bytes(path)
    assert(len(payload) >= 64, "apk native ELF header is truncated");
    virtual.begin();
    const base: u64 = here()
    emit.bytes(payload);
    assert(load.u32(base) == 0x464c457f && load.u8(base + 4) == 2 && load.u8(base + 5) == 1 && load.u16(base + 16) == 3, "apk native ELF must be a little-endian ELF64 shared object");
    let machine: u64 = 62
    if abi_dir == b"arm64-v8a" {
        machine = 183
    }
    assert(load.u16(base + 18) == machine, "apk native ELF machine does not match its ABI directory");
    const phoff: u64 = load.u64(base + 32)
    const phsize: u64 = load.u16(base + 54)
    const phcount: u64 = load.u16(base + 56)
    assert(phsize == 56 && phcount > 0 && phoff >= 64 && phoff <= len(payload), "apk native ELF program header table is invalid");
    assert(phcount <= (len(payload) - phoff) / phsize, "apk native ELF program header table is truncated");
    let loads: u64 = 0
    for i in range(0, phcount) {
        const row: u64 = base + phoff + i * phsize
        if load.u32(row) == 1 {
            const offset: u64 = load.u64(row + 8)
            const address: u64 = load.u64(row + 16)
            const filesz: u64 = load.u64(row + 32)
            const memsz: u64 = load.u64(row + 40)
            const alignment: u64 = load.u64(row + 48)
            assert(alignment >= 16384 && (alignment & (alignment - 1)) == 0, "apk native ELF LOAD alignment must be a power of two at least 16384");
            assert(offset % alignment == address % alignment, "apk native ELF LOAD address and file offset are not congruent");
            assert(offset <= len(payload) && filesz <= len(payload) - offset && filesz <= memsz, "apk native ELF LOAD range is invalid");
            loads = loads + 1
        }
    }
    assert(loads > 0, "apk native ELF has no LOAD segments");
    virtual.end();
    zip_entry_aligned(
        entry_name,
        payload,
        16384
    );
}

// Raw-file entry (icons, assets, prebuilt resources), zipalign-default 4.
fn apk_file_entry(name: bytes, path: string) {
    assert(fs.exists(path), "apk_file_entry input file does not exist");
    const payload: bytes = fs.read_bytes(path)
    zip_entry(name, payload);
}

// Convert a string to the same bytes, for APIs that take a byte sequence
// (ZIP entry names) while the resource table stores text.
fn apk_string_bytes(let out, text: string) {
    virtual.begin();
    const base: u64 = here()
    emit.bytes(text);
    out = load.bytes(base, len(text));
    virtual.end();
}

// ---------------------------------------------------------------------------
// Resource table entries (resources.arsc via arsc.inc)
// ---------------------------------------------------------------------------

// Emit resources.arsc for `tbl` with the zipalign-default 4-byte alignment
// Android expects for an uncompressed resource table.
fn apk_resources_entry(tbl: map) {
    let payload = bytes.new()
    arsc_build(payload, tbl);
    zip_entry(b"resources.arsc", payload);
}

// Emit one file resource. `apk_path` must be the exact path string stored in
// the resource table, so the archive entry and the table agree.
fn apk_res_file_entry(apk_path: string, local_path: string) {
    assert(fs.exists(local_path), "apk_res_file_entry input file does not exist");
    let name = bytes.new()
    apk_string_bytes(name, apk_path);
    zip_entry(name, fs.read_bytes(local_path));
}

// ---------------------------------------------------------------------------
// Binary manifest construction (data-driven via axml.inc)
// ---------------------------------------------------------------------------

// Shared element sequence. `app_attrs` supplies the application attributes so
// the fixed-template and resource-driven manifests differ only in their
// declared pool and attribute values.
fn apk_manifest_body(doc_in: map, app_attrs: list, package_name: string, version_code: u64, version_name: string, lib_name: string) {
    let doc: map = doc_in
    doc = axml_ns_start(doc, "android", apk_android_ns);

    doc = axml_start(doc, "manifest", list.of(
        axml_attr_string("package", "", package_name),
        axml_attr_int("versionCode", apk_android_ns, version_code),
        axml_attr_string("versionName", apk_android_ns, version_name)
    ));
    doc = axml_start(doc, "uses-sdk", list.of(
        axml_attr_int("minSdkVersion", apk_android_ns, apk_min_sdk),
        axml_attr_int("targetSdkVersion", apk_android_ns, apk_target_sdk)
    ));
    doc = axml_end(doc, "uses-sdk");

    doc = axml_start(doc, "uses-feature", list.of(
        axml_attr_hex("glEsVersion", apk_android_ns, 0x00030000),
        axml_attr_bool("required", apk_android_ns, axml_none)
    ));
    doc = axml_end(doc, "uses-feature");

    doc = axml_start(doc, "application", app_attrs);

    doc = axml_start(doc, "activity", list.of(
        axml_attr_string("name", apk_android_ns, "android.app.NativeActivity"),
        axml_attr_bool("exported", apk_android_ns, axml_none),
        axml_attr_int("screenOrientation", apk_android_ns, 0),
        axml_attr_hex("configChanges", apk_android_ns, 0x000004a0)
    ));

    doc = axml_start(doc, "intent-filter", list.new());
    doc = axml_start(doc, "action", list.of(
        axml_attr_string("name", apk_android_ns, "android.intent.action.MAIN")
    ));
    doc = axml_end(doc, "action");
    doc = axml_start(doc, "category", list.of(
        axml_attr_string("name", apk_android_ns, "android.intent.category.LAUNCHER")
    ));
    doc = axml_end(doc, "category");
    doc = axml_end(doc, "intent-filter");

    doc = axml_start(doc, "meta-data", list.of(
        axml_attr_string("name", apk_android_ns, "android.app.lib_name"),
        axml_attr_string("value", apk_android_ns, lib_name)
    ));
    doc = axml_end(doc, "meta-data");

    doc = axml_end(doc, "activity");
    doc = axml_end(doc, "application");
    doc = axml_end(doc, "manifest");

    doc = axml_ns_end(doc, "android", apk_android_ns);

    let manifest_bytes = bytes.new()
    axml_build(manifest_bytes, doc);
    zip_entry(b"AndroidManifest.xml", manifest_bytes);
}

// Attribute resource ids shared by both manifest flavors.
fn apk_manifest_resmap(doc_in: map) -> map {
    let doc: map = doc_in
    doc = axml_attr_resource_id(doc, "theme", apk_attr_theme);
    doc = axml_attr_resource_id(doc, "label", apk_attr_label);
    doc = axml_attr_resource_id(doc, "icon", apk_attr_icon);
    doc = axml_attr_resource_id(doc, "name", apk_attr_name);
    doc = axml_attr_resource_id(doc, "hasCode", apk_attr_hascode);
    doc = axml_attr_resource_id(doc, "exported", apk_attr_exported);
    doc = axml_attr_resource_id(doc, "value", apk_attr_value);
    doc = axml_attr_resource_id(doc, "versionCode", apk_attr_version_code);
    doc = axml_attr_resource_id(doc, "versionName", apk_attr_version_name);
    doc = axml_attr_resource_id(doc, "minSdkVersion", apk_attr_min_sdk);
    doc = axml_attr_resource_id(doc, "targetSdkVersion", apk_attr_target_sdk);
    doc = axml_attr_resource_id(doc, "screenOrientation", apk_attr_screen_orientation);
    doc = axml_attr_resource_id(doc, "configChanges", apk_attr_config_changes);
    doc = axml_attr_resource_id(doc, "glEsVersion", apk_attr_gl_es_version);
    doc = axml_attr_resource_id(doc, "required", apk_attr_required);
    return doc
}

// The fixed NativeActivity manifest template, parameterized by package
// name, version code/name, application label, and native library name.
// Emits "AndroidManifest.xml" through zip_entry. The template pool order is
// interned explicitly so output stays byte-identical across releases.
fn apk_manifest_entry(package_name: string, version_code: u64, version_name: string, app_label: string, lib_name: string) {
    let doc: map = axml_new()
    const template_strings: list = list.of(
        "label", "name", "hasCode", "exported", "value", "versionCode", "versionName",
        "minSdkVersion", "targetSdkVersion", "screenOrientation", "configChanges",
        "glEsVersion", "required",
        "activity", "android", "android.app.NativeActivity", "android.app.lib_name",
        "android.intent.action.MAIN", "android.intent.category.LAUNCHER",
        "application", "category", "http://schemas.android.com/apk/res/android",
        "intent-filter", "manifest", "meta-data", "package", "action", "uses-sdk", "uses-feature",
        package_name, version_name, app_label, lib_name
    )
    for text in template_strings {
        doc = axml_pool_intern(doc, text)
    }
    doc = apk_manifest_resmap(doc);

    assert(apk_min_sdk >= 24 && apk_min_sdk <= apk_target_sdk, "apk SDK range is invalid");
    assert(apk_target_sdk <= 0xffffffff, "apk target SDK exceeds u32");

    apk_manifest_body(doc, list.of(
        axml_attr_bool("hasCode", apk_android_ns, 0),
        axml_attr_string("label", apk_android_ns, app_label)
    ), package_name, version_code, version_name, lib_name);
}

// Manifest whose label and icon are references into the generated resource
// table. `label_res` and `icon_res` are qualified names such as
// "string/app_name" and "mipmap/ic_launcher".
fn apk_manifest_res_entry(tbl: map, package_name: string, version_code: u64, version_name: string, label_res: string, icon_res: string, lib_name: string) {
    const label_parts: list = split(label_res, "/")
    const icon_parts: list = split(icon_res, "/")
    assert(len(label_parts) == 2, "apk label reference must be type/name");
    assert(len(icon_parts) == 2, "apk icon reference must be type/name");

    let label_id: u64 = 0
    arsc_resolve_id(label_id, tbl, list.get(label_parts, 0), list.get(label_parts, 1));
    let icon_id: u64 = 0
    arsc_resolve_id(icon_id, tbl, list.get(icon_parts, 0), list.get(icon_parts, 1));

    let doc: map = axml_new()
    const template_strings: list = list.of(
        "label", "icon", "name", "hasCode", "exported", "value", "versionCode", "versionName",
        "minSdkVersion", "targetSdkVersion", "screenOrientation", "configChanges",
        "glEsVersion", "required",
        "activity", "android", "android.app.NativeActivity", "android.app.lib_name",
        "android.intent.action.MAIN", "android.intent.category.LAUNCHER",
        "application", "category", "http://schemas.android.com/apk/res/android",
        "intent-filter", "manifest", "meta-data", "package", "action", "uses-sdk", "uses-feature",
        package_name, version_name, lib_name
    )
    for text in template_strings {
        doc = axml_pool_intern(doc, text)
    }
    doc = apk_manifest_resmap(doc);

    assert(apk_min_sdk >= 24 && apk_min_sdk <= apk_target_sdk, "apk SDK range is invalid");

    apk_manifest_body(doc, list.of(
        axml_attr_reference("label", apk_android_ns, label_id),
        axml_attr_reference("icon", apk_android_ns, icon_id),
        axml_attr_bool("hasCode", apk_android_ns, 0)
    ), package_name, version_code, version_name, lib_name);
}

// ---------------------------------------------------------------------------
// Whole-application facade
// ---------------------------------------------------------------------------
//
// The builders above stay available for callers that want direct control. This
// facade describes one application as a single compile-time document:
//
//   let app: map = apk_new("com.example.tool", 1, "1.0", "main")
//   app = apk_label_string(app, "app_name", "Example Tool")
//   app = apk_icon(app, "mdpi", "res/mipmap-mdpi-v4/ic_launcher.png", "icons/mdpi.png")
//   app = apk_native_lib(app, "x86_64", "libmain.so", "build/libmain.so")
//   apk_emit(app);
//
// A resource tree can declare the resources instead, in which case the facade
// is three calls long:
//
//   let app: map = apk_new("com.example.tool", 1, "1.0", "main")
//   app = apk_res_dir(app, "res")
//   apk_emit(app);
//
// apk_emit writes the binary manifest, the resource table, every resource and
// asset entry, the bootstrap DEX, and the native libraries, then closes the
// archive. A file resource records its resource-table path and its archive
// entry together, so the two can never disagree.
//
// The fixed-template manifest path stays in use while an application declares
// no resources, which keeps its output byte-identical to earlier releases.

fn apk_new(package_name: string, version_code: u64, version_name: string, lib_name: string) -> map {
    assert(len(package_name) > 0, "apk package name must not be empty");
    assert(len(lib_name) > 0, "apk native library name must not be empty");
    let app: map = map.new()
    map.set_mut(app, "package", package_name);
    map.set_mut(app, "version_code", version_code);
    map.set_mut(app, "version_name", version_name);
    map.set_mut(app, "lib_name", lib_name);
    map.set_mut(app, "min_sdk", apk_min_sdk);
    map.set_mut(app, "target_sdk", apk_target_sdk);
    map.set_mut(app, "label_text", "");
    map.set_mut(app, "label_name", "");
    map.set_mut(app, "icon_resource", "");
    map.set_mut(app, "theme_id", 0);
    map.set_mut(app, "res", arsc_new(package_name, 0x7f));
    map.set_mut(app, "icons", list.new());
    map.set_mut(app, "assets", list.new());
    map.set_mut(app, "libs", list.new());
    map.set_mut(app, "dex", true);
    return app
}

fn apk_set_sdk(app: map, min_sdk: u64, target_sdk: u64) -> map {
    assert(min_sdk >= 24 && min_sdk <= target_sdk, "apk SDK range is invalid");
    assert(target_sdk <= 0xffffffff, "apk target SDK exceeds u32");
    return map.set(map.set(app, "min_sdk", min_sdk), "target_sdk", target_sdk)
}

// Literal application label. Used only while the application declares no
// resources; a declared string resource takes precedence.
fn apk_label(app: map, text: string) -> map {
    assert(len(text) > 0, "apk label must not be empty");
    return map.set(app, "label_text", text)
}

// Add an ASCII string resource and use it as the application label.
fn apk_label_string(app: map, name: string, text: string) -> map {
    const res: map = map.get(app, "res")
    let linked: map = map.set(app, "res", arsc_string(res, name, text))
    linked = map.set(linked, "label_name", name);
    return map.set(linked, "label_text", "")
}

// Add a string resource without making it the application label. Values may
// use any script; XIRASM sources are ASCII, so non-ASCII text arrives through a
// data file (fs.read_text) or a structured file.
fn apk_string_resource(app: map, name: string, text: string) -> map {
    const res: map = map.get(app, "res")
    return map.set(app, "res", arsc_string(res, name, text))
}

// String resource variant for a two letter locale configuration.
fn apk_string_resource_locale(app: map, name: string, text: string, locale: string) -> map {
    if locale == "" {
        return apk_string_resource(app, name, text)
    }
    const res: map = map.get(app, "res")
    return map.set(app, "res", arsc_string_locale(res, name, text, locale))
}

// Set the application theme from a framework resource ID, which is what
// `@android:style/...` resolves to. Pass the ID rather than the name: the
// catalog that maps names to IDs is a large generated include, and only a
// program that needs it should import it.
//
//   import("format/android/generated/framework_ids.inc");
//   app = apk_use_theme_id(app, android_style_id("Theme.DeviceDefault"));
fn apk_use_theme_id(app: map, style_id: u64) -> map {
    assert(style_id >= 0x01000000 && style_id <= 0x01ffffff,
        "apk theme must be a framework resource id (0x01xxxxxx)");
    return map.set(app, "theme_id", style_id)
}

// Use an already declared string resource as the application label. The
// resource is checked when the manifest is written, so a misspelled name still
// fails at assembly time.
fn apk_use_label(app: map, name: string) -> map {
    assert(len(name) > 0, "apk label resource name must not be empty");
    return map.set(map.set(app, "label_name", name), "label_text", "")
}

// Use an already declared file resource as the launcher icon.
fn apk_use_icon(app: map, type_name: string, res_name: string) -> map {
    assert(len(type_name) > 0 && len(res_name) > 0, "apk icon resource needs a type and a name");
    return map.set(app, "icon_resource", sym.join(type_name, "/", res_name))
}

fn apk_push(app: map, key: string, item: map) -> map {
    let items: list = map.get(app, key)
    list.push_mut(items, item);
    return map.set(app, key, items)
}

fn apk_payload_file(apk_path: string, local_path: string) -> map {
    assert(len(apk_path) > 0, "apk entry path must not be empty");
    assert(len(local_path) > 0, "apk entry needs a source file");
    let item: map = map.new()
    map.set_mut(item, "apk_path", apk_path);
    map.set_mut(item, "local_path", local_path);
    map.set_mut(item, "data", bytes.new());
    map.set_mut(item, "inline", false);
    map.set_mut(item, "compressed", false);
    return item
}

fn apk_payload_bytes(apk_path: string, data: bytes) -> map {
    assert(len(apk_path) > 0, "apk entry path must not be empty");
    assert(len(data) > 0, "apk entry payload must not be empty");
    let item: map = map.new()
    map.set_mut(item, "apk_path", apk_path);
    map.set_mut(item, "local_path", "");
    map.set_mut(item, "data", data);
    map.set_mut(item, "inline", true);
    map.set_mut(item, "compressed", false);
    return item
}

// Turn a payload into a DEFLATE entry. Android requires the resource table and
// shared libraries to stay uncompressed and aligned, so this is a per-entry
// choice rather than a default; assets and large data files are the usual
// candidates.
fn apk_payload_compress(item: map) -> map {
    return map.set(item, "compressed", true)
}

fn apk_icon_payload(app: map, type_name: string, res_name: string, density_name: string, item: map) -> map {
    const res: map = map.get(app, "res")
    const apk_path: string = map.get(item, "apk_path")
    let linked: map = map.set(app, "res", arsc_file(res, type_name, res_name, density_name, apk_path))
    linked = apk_push(linked, "icons", item);
    if map.get(linked, "icon_resource") == "" {
        linked = map.set(linked, "icon_resource", sym.join(type_name, "/", res_name))
    }
    return linked
}

// One density variant of a file-backed launcher icon.
fn apk_icon(app: map, density_name: string, apk_path: string, local_path: string) -> map {
    return apk_icon_payload(app, "mipmap", "ic_launcher", density_name, apk_payload_file(apk_path, local_path))
}

// One density variant whose payload is supplied inline.
fn apk_icon_bytes(app: map, density_name: string, apk_path: string, data: bytes) -> map {
    return apk_icon_payload(app, "mipmap", "ic_launcher", density_name, apk_payload_bytes(apk_path, data))
}

// A file resource of another type, with its archive entry recorded together.
fn apk_resource_file(app: map, type_name: string, res_name: string, density_name: string, apk_path: string, local_path: string) -> map {
    const res: map = map.get(app, "res")
    let linked: map = map.set(app, "res", arsc_file(res, type_name, res_name, density_name, apk_path))
    return apk_push(linked, "assets", apk_payload_file(apk_path, local_path))
}

// A plain archive entry with no resource-table entry (assets, notices, ...).
fn apk_asset(app: map, apk_path: string, local_path: string) -> map {
    return apk_push(app, "assets", apk_payload_file(apk_path, local_path))
}

fn apk_asset_bytes(app: map, apk_path: string, data: bytes) -> map {
    return apk_push(app, "assets", apk_payload_bytes(apk_path, data))
}

// The same entries, stored as DEFLATE. Use these for text and other payloads
// that shrink; a payload that does not shrink is smaller stored.
fn apk_asset_compressed(app: map, apk_path: string, local_path: string) -> map {
    return apk_push(app, "assets", apk_payload_compress(apk_payload_file(apk_path, local_path)))
}

fn apk_asset_bytes_compressed(app: map, apk_path: string, data: bytes) -> map {
    return apk_push(app, "assets", apk_payload_compress(apk_payload_bytes(apk_path, data)))
}

// A file resource whose archive entry is compressed. The resource table keeps
// the same path, so the entry and the table still agree.
fn apk_resource_file_compressed(app: map, type_name: string, res_name: string, density_name: string, apk_path: string, local_path: string) -> map {
    const res: map = map.get(app, "res")
    let linked: map = map.set(app, "res", arsc_file(res, type_name, res_name, density_name, apk_path))
    return apk_push(linked, "assets", apk_payload_compress(apk_payload_file(apk_path, local_path)))
}

fn apk_native_lib(app: map, abi_dir: string, so_name: string, local_path: string) -> map {
    assert(len(abi_dir) > 0 && len(so_name) > 0, "apk native library needs an ABI directory and a name");
    assert(len(local_path) > 0, "apk native library needs a source file");
    let item: map = map.new()
    map.set_mut(item, "abi", abi_dir);
    map.set_mut(item, "so", so_name);
    map.set_mut(item, "path", local_path);
    return apk_push(app, "libs", item)
}

// --- Resource directory scanning -------------------------------------------
//
// A `res/` tree can declare the resources by itself, because the tree already
// encodes every coordinate a resource needs:
//
//   res/values/strings.toml           string resources, one key per name
//   res/values-zh/strings.toml        two letter locale variant
//   res/mipmap-hdpi/ic_launcher.png   file resource, density variant
//   res/drawable/logo.png             file resource, no qualifier
//
// The last path segment of a file directory is `<type>[-<qualifier>...]`, and
// each qualifier is either a density name, a two letter locale, or an
// API-version qualifier such as `-v4` that the table does not need to store. The
// resource name is the file name without its extension; the archive path keeps
// the original file name, so the resource table value and the archive entry can
// never disagree. `values*` directories hold TOML tables instead of files and
// every key becomes a string resource.
//
// Scanning is recursive, skips dot entries, and is deterministic because
// `fs.list_dir` returns sorted entries. Two conventional names are bound
// automatically while the application leaves them unset: `app_name` becomes the
// application label and `mipmap/ic_launcher` becomes the icon. Use
// `apk_use_label` and `apk_use_icon` to choose different resources.

fn apk_res_is_density(name: string) -> bool {
    for known in list.of("ldpi", "mdpi", "tvdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi", "nodpi") {
        if known == name {
            return true;
        }
    }
    return false
}

// Last path segment, used for both archive and local paths.
fn apk_res_last_segment(path: string) -> string {
    const parts: list = split(path, "/")
    assert(len(parts) > 0, "apk resource path is malformed");
    return list.get(parts, len(parts) - 1)
}

// An API-version qualifier is `v` followed by decimal digits.
fn apk_res_is_api_qual(name: string) -> bool {
    if !starts_with(name, "v") || len(name) < 2 {
        return false
    }
    let rest: string = name
    for digit in list.of("0", "1", "2", "3", "4", "5", "6", "7", "8", "9") {
        rest = replace(rest, digit, "");
    }
    return rest == "v"
}

const apk_res_ascii_letters: list = list.of(
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
)

// A locale qualifier is exactly two ASCII letters, which is the only language
// field the table can store. Anything else of that length (`-xx1`, `-12`) is not
// a language and must not reach the table as one.
fn apk_res_is_locale_qual(name: string) -> bool {
    if len(name) != 2 || apk_res_is_api_qual(name) {
        return false
    }
    let rest: string = lower(name)
    for letter in apk_res_ascii_letters {
        rest = replace(rest, letter, "");
    }
    return rest == ""
}

// Qualifiers of a directory name, starting after the type segment.
fn apk_res_qualifiers(dir_name: string) -> list {
    const parts: list = split(dir_name, "-")
    return list.slice(parts, 1, len(parts) - 1)
}

// A directory may carry several qualifiers, but the table compiles one density
// axis and one locale axis. A second density or locale would be dropped
// silently, so the caller rejects it instead.
fn apk_res_qualifiers_ok(dir_name: string, where: string, allow_density: bool) -> bool {
    let densities: u64 = 0
    let locales: u64 = 0
    for qual in apk_res_qualifiers(dir_name) {
        const density: bool = allow_density && apk_res_is_density(qual)
        assert(density || apk_res_is_locale_qual(qual) || apk_res_is_api_qual(qual),
            sym.join("apk resource directory qualifier is not supported: ", where));
        if density {
            densities = densities + 1;
        }
        if apk_res_is_locale_qual(qual) {
            locales = locales + 1;
        }
    }
    return densities <= 1 && locales <= 1
}

fn apk_res_density_of(dir_name: string) -> string {
    for qual in apk_res_qualifiers(dir_name) {
        if apk_res_is_density(qual) {
            return qual;
        }
    }
    return ""
}

fn apk_res_locale_of(dir_name: string) -> string {
    for qual in apk_res_qualifiers(dir_name) {
        if apk_res_is_locale_qual(qual) {
            return qual;
        }
    }
    return ""
}

// Validate a file directory name and return its resource type.
//
// An API-version qualifier (`-vNN`) is accepted and ignored because the table
// compiles the density and locale axes only. Every other qualifier is rejected
// rather than dropped, because dropping an orientation, night, or size
// qualifier would merge two different values into one configuration; when
// ignoring an API-version qualifier does merge two directories, the repeated
// declaration check reports it.
fn apk_res_dir_type(dir_name: string, apk_prefix: string) -> string {
    assert(len(dir_name) > 0, sym.join("apk resource directory has no type: ", apk_prefix));
    const type_name: string = list.get(split(dir_name, "-"), 0)
    assert(len(type_name) > 0, sym.join("apk resource directory has no type: ", apk_prefix));
    assert(apk_res_qualifiers_ok(dir_name, apk_prefix, true),
        sym.join("apk resource directory has more than one compiled qualifier: ", apk_prefix));
    return type_name
}

// A values directory carries string resources, so it takes a locale or an
// ignored API-version qualifier and never a density.
fn apk_res_values_locale(dir_name: string, where: string) -> string {
    assert(apk_res_qualifiers_ok(dir_name, where, false),
        sym.join("apk values directory has more than one compiled qualifier: ", where));
    return apk_res_locale_of(dir_name)
}

// Resource name of a file entry: the file name before its first dot.
fn apk_res_stem(name: string) -> string {
    return list.get(split(name, "."), 0)
}

fn apk_res_file_is_values(dir_name: string) -> bool {
    return dir_name == "values" || starts_with(dir_name, "values-")
}

// Add a scanned string resource, tolerating a repeated identical declaration
// and rejecting a conflicting one for the same configuration.
fn apk_res_add_string(app: map, name: string, text: string, locale: string) -> map {
    const res: map = map.get(app, "res")
    const items: list = map.get(res, "res")
    const found: u64 = arsc_find(items, "string", name, 0, locale)
    if found != arsc_none {
        const existing: map = list.get(items, found)
        assert(map.get(existing, "text") == text,
            sym.join("apk string resource is declared twice with different values: ", name));
        return app
    }
    return apk_string_resource_locale(app, name, text, locale)
}

fn apk_res_add_values(app: map, local_dir: string, locale: string) -> map {
    let out: map = app
    for entry in fs.list_dir(local_dir) {
        if starts_with(entry, ".") {
            continue;
        }
        const path: string = sym.join(local_dir, "/", entry)
        assert(!fs.is_dir(path), sym.join("apk values directory must not contain subdirectories: ", path));
        assert(ends_with(entry, ".toml"), sym.join("apk values directory accepts .toml tables only: ", path));
        const table: map = toml.file(path)
        for key in map.keys(table) {
            const text: string = map.get(table, key)
            out = apk_res_add_string(out, key, text, locale);
            // Bind the conventional name only while the application sets no
            // label at all: an explicit apk_label is a decision, not a default.
            if key == "app_name" && map.get(out, "label_name") == "" && map.get(out, "label_text") == "" {
                out = apk_use_label(out, key);
            }
        }
    }
    return out
}

fn apk_res_add_file(app: map, local_dir: string, apk_prefix: string, type_name: string, dir_name: string, entry: string) -> map {
    const res_name: string = apk_res_stem(entry)
    const local_path: string = sym.join(local_dir, "/", entry)
    const apk_path: string = sym.join(apk_prefix, "/", entry)
    const density_name: string = apk_res_density_of(dir_name)
    const locale: string = apk_res_locale_of(dir_name)
    assert(len(res_name) > 0, sym.join("apk resource file name is malformed: ", apk_path));

    const res: map = map.get(app, "res")
    let density: u64 = 0
    if density_name != "" {
        density = arsc_density(density_name)
    }
    const items: list = map.get(res, "res")
    const found: u64 = arsc_find(items, type_name, res_name, density, locale)
    if found != arsc_none {
        // Scanning the same tree twice is harmless, but two files claiming one
        // resource in one configuration would silently lose a value.
        const existing: map = list.get(items, found)
        assert(map.get(existing, "text") == apk_path,
            sym.join("apk resource is declared twice with different files: ", apk_path));
        return app
    }

    let linked: map = map.set(app, "res", arsc_file_locale(res, type_name, res_name, density_name, locale, apk_path))
    linked = apk_push(linked, "assets", apk_payload_file(apk_path, local_path));
    if type_name == "mipmap" && res_name == "ic_launcher" && map.get(linked, "icon_resource") == "" {
        linked = apk_use_icon(linked, type_name, res_name);
    }
    return linked
}

fn apk_res_scan(app: map, local_dir: string, apk_prefix: string) -> map {
    const dir_name: string = apk_res_last_segment(apk_prefix)
    if apk_res_file_is_values(dir_name) {
        return apk_res_add_values(app, local_dir, apk_res_values_locale(dir_name, apk_prefix))
    }
    const type_name: string = apk_res_dir_type(dir_name, apk_prefix)
    let out: map = app
    for entry in fs.list_dir(local_dir) {
        if starts_with(entry, ".") {
            continue;
        }
        const path: string = sym.join(local_dir, "/", entry)
        if fs.is_dir(path) {
            out = apk_res_scan(out, path, sym.join(apk_prefix, "/", entry));
        } else {
            out = apk_res_add_file(out, local_dir, apk_prefix, type_name, dir_name, entry);
        }
    }
    return out
}

// Declare every resource under `local_dir`. Archive paths mirror that directory,
// so scanning `res` produces the `res/...` entries an Android build expects.
fn apk_res_dir(app: map, local_dir: string) -> map {
    assert(fs.is_dir(local_dir), sym.join("apk resource directory is missing or unreadable: ", local_dir));
    return apk_res_scan(app, local_dir, local_dir)
}

// Same scan with an explicit archive prefix.
fn apk_res_dir_at(app: map, local_dir: string, apk_prefix: string) -> map {
    assert(len(apk_prefix) > 0, "apk resource archive prefix must not be empty");
    assert(fs.is_dir(local_dir), sym.join("apk resource directory is missing or unreadable: ", local_dir));
    return apk_res_scan(app, local_dir, apk_prefix)
}

// hasCode=false applications need no DEX; the bootstrap entry is emitted by
// default and this disables it.
fn apk_skip_dex(app: map) -> map {
    return map.set(app, "dex", false)
}

// Manifest with a resource-backed label and/or icon. Attributes are listed in
// the order aapt2 writes them.
fn apk_manifest_app_entry(app: map) {
    const res: map = map.get(app, "res")
    const package_name: string = map.get(app, "package")
    const version_code: u64 = map.get(app, "version_code")
    const version_name: string = map.get(app, "version_name")
    const lib_name: string = map.get(app, "lib_name")
    const label_name: string = map.get(app, "label_name")
    const icon_resource: string = map.get(app, "icon_resource")

    let doc: map = axml_new()
    const theme_id: u64 = map.get(app, "theme_id")
    const template_strings: list = list.of(
        "label", "icon", "name", "hasCode", "exported", "value", "versionCode", "versionName",
        "minSdkVersion", "targetSdkVersion", "screenOrientation", "configChanges",
        "glEsVersion", "required",
        "activity", "android", "android.app.NativeActivity", "android.app.lib_name",
        "android.intent.action.MAIN", "android.intent.category.LAUNCHER",
        "application", "category", "http://schemas.android.com/apk/res/android",
        "intent-filter", "manifest", "meta-data", "package", "action", "uses-sdk", "uses-feature",
        package_name, version_name, lib_name
    )
    for text in template_strings {
        doc = axml_pool_intern(doc, text)
    }
    // Interned only when a theme is set, so a manifest without one keeps the
    // string pool it always had.
    if theme_id != 0 {
        doc = axml_pool_intern(doc, "theme");
    }
    doc = apk_manifest_resmap(doc);

    assert(apk_min_sdk >= 24 && apk_min_sdk <= apk_target_sdk, "apk SDK range is invalid");

    let app_attrs: list = list.new()
    if theme_id != 0 {
        list.push_mut(app_attrs, axml_attr_reference("theme", apk_android_ns, theme_id));
    }
    if label_name != "" {
        let label_id: u64 = 0
        arsc_resolve_id(label_id, res, "string", label_name);
        list.push_mut(app_attrs, axml_attr_reference("label", apk_android_ns, label_id));
    } else {
        const label_text: string = map.get(app, "label_text")
        assert(label_text != "", "apk application label is not set");
        list.push_mut(app_attrs, axml_attr_string("label", apk_android_ns, label_text));
    }
    if icon_resource != "" {
        const parts: list = split(icon_resource, "/")
        assert(len(parts) == 2, "apk icon resource name is malformed");
        let icon_id: u64 = 0
        arsc_resolve_id(icon_id, res, list.get(parts, 0), list.get(parts, 1));
        list.push_mut(app_attrs, axml_attr_reference("icon", apk_android_ns, icon_id));
    }
    list.push_mut(app_attrs, axml_attr_bool("hasCode", apk_android_ns, 0));

    apk_manifest_body(doc, app_attrs, package_name, version_code, version_name, lib_name);
}

fn apk_payload_emit(item: map) {
    let name = bytes.new()
    apk_string_bytes(name, map.get(item, "apk_path"));

    // A compressed entry needs the bytes in hand, so a file-backed payload is
    // read either way; the stored path used to read it too.
    const inline: bool = map.get(item, "inline")
    let payload: bytes = map.get(item, "data")
    if !inline {
        const local_path: string = map.get(item, "local_path")
        assert(fs.exists(local_path), "apk entry input file does not exist");
        payload = fs.read_bytes(local_path);
    }

    if map.get(item, "compressed") {
        zip_entry_compressed(name, payload);
    } else {
        zip_entry(name, payload);
    }
}

// Emit the complete APK described by `app`.
fn apk_emit(app: map) {
    const res: map = map.get(app, "res")
    const has_table: bool = len(map.get(res, "res")) > 0

    apk_set_min_sdk(map.get(app, "min_sdk"));
    apk_set_target_sdk(map.get(app, "target_sdk"));

    if has_table {
        apk_manifest_app_entry(app);
    } else {
        // The template manifest embeds literal values, so a bound resource name
        // would be dropped without a word.
        assert(map.get(app, "label_name") == "" && map.get(app, "icon_resource") == "",
            "apk label and icon resources need a declared resource table");
        assert(map.get(app, "theme_id") == 0,
            "apk theme needs a declared resource table; the fixed template carries no attribute map");
        apk_manifest_entry(
            map.get(app, "package"),
            map.get(app, "version_code"),
            map.get(app, "version_name"),
            map.get(app, "label_text"),
            map.get(app, "lib_name")
        );
    }
    if has_table {
        apk_resources_entry(res);
    }
    for icon in map.get(app, "icons") {
        apk_payload_emit(icon);
    }
    for asset in map.get(app, "assets") {
        apk_payload_emit(asset);
    }
    for lib in map.get(app, "libs") {
        let abi = bytes.new()
        apk_string_bytes(abi, map.get(lib, "abi"));
        let so = bytes.new()
        apk_string_bytes(so, map.get(lib, "so"));
        apk_lib(abi, so, map.get(lib, "path"));
    }
    if map.get(app, "dex") {
        apk_dex_entry()
    }
    zip_finish();
}

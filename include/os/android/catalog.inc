// Android platform symbol catalog queries.
//
// The table beside this include is generated from NDK stub libraries, spanning
// API 21 to 35 and five ABIs. Importing this file costs nothing; it is parsed when a
// query asks for it, and one parse answers any number of queries.
//
//   const syms: map = android_symbols()
//   const lib: string = android_symbol_library(syms, "__android_log_write")  // liblog.so
//   const api: u64 = android_symbol_min_api(syms, "__android_log_write")     // 21
//   const ok: bool = android_symbol_available_at(syms, "dlvsym", 21)
//
// Use these queries for tooling and diagnostics. Generated code should import the
// library file it needs instead (os/android/imports/liblog.inc and friends): those
// constants cost nothing at all, and their helper functions weld the library name
// onto the import list for you.

const android_symbols_data: string = "os/android/catalog/symbols.toml"

// The whole generated document, including its [meta] table.
fn android_catalog() -> map {
    return toml.file(android_symbols_data);
}

// The [symbols] table on its own: one entry per platform symbol. Load it once and
// pass it to the queries below rather than calling this per lookup.
fn android_symbols() -> map {
    return map.get(android_catalog(), "symbols");
}

fn android_catalog_meta() -> map {
    return map.get(android_catalog(), "meta");
}

fn android_symbol_row(syms: map, name: string) -> map {
    assert(map.has(syms, name), "android platform symbol is unknown");
    return map.get(syms, name)
}

// The first library that provides the symbol, in name order. A symbol can be
// provided by several libraries, and the per-library API levels differ; use
// android_symbol_libraries when that matters.
fn android_symbol_library(syms: map, name: string) -> string {
    const row: map = android_symbol_row(syms, name)
    const first: string = list.get(split(map.get(row, "lib"), ","), 0)
    return list.get(split(first, ":"), 0)
}

fn android_symbol_libraries(syms: map, name: string) -> list {
    const row: map = android_symbol_row(syms, name)
    let names: list = list.new()
    for entry in split(map.get(row, "lib"), ",") {
        list.push_mut(names, list.get(split(entry, ":"), 0))
    }
    return names;
}

// Compatibility summary across all libraries and ABIs. For a minimum SDK check,
// select a library and ABI with android_symbol_available_for instead.
fn android_symbol_min_api(syms: map, name: string) -> u64 {
    const row: map = android_symbol_row(syms, name)
    return map.get(row, "api")
}

// Note on per-library levels: a symbol can appear in several libraries at
// different levels (ANativeWindow_acquire is in libandroid.so from API 21 and in
// libnativewindow.so from API 26). android_symbol_library_api answers that from
// the catalog; the same number is also a constant in the library's own include
// file, which is the cheaper form when the library is already imported:
//
//   import("os/android/imports/libnativewindow.inc")
//   const needs: u64 = android_import_nativewindow_min_api    // 26
fn android_symbol_library_api(syms: map, name: string, library: string) -> u64 {
    const row: map = android_symbol_row(syms, name)
    for entry in split(map.get(row, "lib"), ",") {
        const parts: list = split(entry, ":")
        const entry_library: string = list.get(parts, 0)
        if entry_library == library {
            const parsed: map = match.tokens("value:int", list.get(parts, 1))
            assert(map.get(parsed, "ok"), "android platform symbol entry carries no API level");
            const captures: map = map.get(parsed, "captures")
            return map.get(captures, "value");
        }
    }
    assert(false, "android platform symbol is not provided by that library");
    return 0;
}

fn android_symbol_available_at(syms: map, name: string, api: u64) -> bool {
    return android_symbol_min_api(syms, name) <= api;
}

// ABI bit mask over the catalog's abi_order list: aarch64, arm, i686, riscv64,
// x86_64, in that order, least significant bit first.
fn android_symbol_abis(syms: map, name: string) -> u64 {
    const row: map = android_symbol_row(syms, name)
    return map.get(row, "abis")
}

// The GNU version tag the stub declares, empty when it declares none.
fn android_symbol_version(syms: map, name: string) -> string {
    const row: map = android_symbol_row(syms, name)
    return map.get_or(row, "ver", "")
}

fn android_symbol_kind(syms: map, name: string) -> string {
    const row: map = android_symbol_row(syms, name)
    return map.get(row, "kind")
}

const android_abi_aarch64: u64 = 1
const android_abi_arm: u64 = 2
const android_abi_x86: u64 = 4
const android_abi_riscv64: u64 = 8
const android_abi_x86_64: u64 = 16

fn android_abi_key(abi_bit: u64) -> string {
    if abi_bit == android_abi_aarch64 {
        return "a64";
    }
    if abi_bit == android_abi_arm {
        return "arm";
    }
    if abi_bit == android_abi_x86 {
        return "x86";
    }
    if abi_bit == android_abi_riscv64 {
        return "riscv64";
    }
    if abi_bit == android_abi_x86_64 {
        return "x64";
    }
    assert(false, "Android ABI must be one catalog ABI bit");
    return "";
}

fn android_library_key(library: string) -> string {
    return replace(replace(library, ".", "_"), "+", "_");
}

// This record is authoritative for one provider and one ABI. GNU versions are
// catalog metadata; the format layer currently emits unversioned ELF imports.
fn android_symbol_provider(syms: map, name: string, library: string, abi_bit: u64) -> map {
    const key: string = android_abi_key(abi_bit)
    const providers: map = map.get(android_symbol_row(syms, name), "providers")
    const provider_key: string = android_library_key(library)
    assert(map.has(providers, provider_key), "android platform symbol is not provided by that library");
    const by_abi: map = map.get(providers, provider_key)
    assert(map.get(by_abi, "library") == library, "android platform symbol is not provided by that library");
    assert(map.has(by_abi, key), "android platform symbol is unavailable for that ABI");
    return map.get(by_abi, key);
}

fn android_symbol_min_api_for(syms: map, name: string, library: string, abi_bit: u64) -> u64 {
    return map.get(android_symbol_provider(syms, name, library, abi_bit), "api");
}

fn android_symbol_kind_for(syms: map, name: string, library: string, abi_bit: u64) -> string {
    return map.get(android_symbol_provider(syms, name, library, abi_bit), "kind");
}

fn android_symbol_version_for(syms: map, name: string, library: string, abi_bit: u64) -> string {
    return map.get(android_symbol_provider(syms, name, library, abi_bit), "ver");
}

fn android_symbol_available_for(syms: map, name: string, library: string, api: u64, abi_bit: u64) -> bool {
    const key: string = android_abi_key(abi_bit)
    const providers: map = map.get(android_symbol_row(syms, name), "providers")
    const provider_key: string = android_library_key(library)
    if !map.has(providers, provider_key) {
        return false;
    }
    const by_abi: map = map.get(providers, provider_key)
    if map.get(by_abi, "library") != library {
        return false;
    }
    if !map.has(by_abi, key) {
        return false;
    }
    return map.get(map.get(by_abi, key), "api") <= api;
}

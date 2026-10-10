// Android catalog checks reuse the format layer's import entries and writer.
import("format/format.inc")
import("os/android/catalog.inc")

fn android_import_has_name(names: list, name: string) -> bool {
    for candidate in names {
        if candidate == name {
            return true;
        }
    }
    return false;
}

fn android_import_append_mut(let imports: list, library: string, local_name: string, name: string, kind: string, plt: bool) {
    assert(len(local_name) > 0, "Android import local label is empty");
    assert(kind == "func" || kind == "object", "Android ELF format does not support IFUNC imports");
    assert(!plt || kind == "func", "Android object imports require GOT slots");
    let symbol_type: u64 = elf_stt_func
    if kind == "object" {
        symbol_type = elf_stt_object;
    }
    let slot: string = local_name
    if plt {
        slot = sym.join(local_name, "_gotplt");
    }
    for entry in imports {
        if map.get(entry, "slot") == slot {
            assert(map.get_or(entry, "type", elf_stt_func) == symbol_type, "Android import slot has conflicting symbol types");
            assert((map.get_or(entry, "plt", "") != "") == plt, "Android import slot has conflicting binding modes");
        }
    }
    if plt {
        imports = elfso_import_use64_plt_as(imports, library, name, slot, sym.join(local_name, "_plt"));
    } else {
        imports = elfso_import_use64_as(imports, library, name, slot);
    }
    for i in range(0, len(imports)) {
        let entry: map = list.get(imports, i)
        if map.get(entry, "slot") == slot {
            map.set_mut(entry, "type", symbol_type);
            list.set_mut(imports, i, entry);
        }
    }
}

fn android_import_legacy_mut(let imports: list, library: string, names: list, all_names: list, objects: list, ifuncs: list, plt: bool) {
    for name in names {
        assert(android_import_has_name(all_names, name), "android platform symbol is not provided by that library");
        assert(!android_import_has_name(ifuncs, name), "Android ELF format does not support IFUNC imports");
        let kind: string = "func"
        if android_import_has_name(objects, name) {
            kind = "object";
        }
        android_import_append_mut(imports, library, name, name, kind, plt);
    }
}

fn android_import_checked_mut(let imports: list, image: map, syms: map, library: string, local_name: string, name: string, minimum_api: u64, abi_bit: u64, plt: bool) {
    assert(map.get(image, "kind") == format_kind_elfso64 || map.get(image, "kind") == format_kind_elf64, "Android imports require a dynamic ELF64 image plan");
    assert(!map.get_or(image, "started", false), "Android imports must be configured before format_begin");
    assert(abi_bit == android_abi_aarch64 || abi_bit == android_abi_x86_64, "Android ELF imports support AArch64 or x86-64 ABI");
    const machine: u64 = map.get(image, "machine")
    assert((machine == elf_machine_aarch64 && abi_bit == android_abi_aarch64) || (machine == elf_machine_x86_64 && abi_bit == android_abi_x86_64), "Android import ABI does not match the ELF machine");
    assert(!plt || machine == elf_machine_x86_64, "Android AArch64 imports require GOT slots");
    const record: map = android_symbol_provider(syms, name, library, abi_bit)
    assert(minimum_api >= map.get(record, "api"), "Android import exceeds the selected minimum API");
    android_import_append_mut(imports, library, local_name, name, map.get(record, "kind"), plt);
}

fn android_import_names_checked_mut(let imports: list, image: map, library: string, names: list, minimum_api: u64, abi_bit: u64, plt: bool) {
    const syms: map = android_symbols()
    for name in names {
        android_import_checked_mut(imports, image, syms, library, name, name, minimum_api, abi_bit, plt);
    }
}

fn android_import_pairs_checked_mut(let imports: list, image: map, library: string, pairs: list, minimum_api: u64, abi_bit: u64, plt: bool) {
    assert(len(pairs) % 2 == 0, "Android import pairs require local/name entries");
    const syms: map = android_symbols()
    let i: u64 = 0
    while i < len(pairs) {
        android_import_checked_mut(imports, image, syms, library, list.get(pairs, i), list.get(pairs, i + 1), minimum_api, abi_bit, plt);
        i = i + 2
    }
}

fn android_import_one_checked_mut(let imports: list, image: map, library: string, local_name: string, name: string, minimum_api: u64, abi_bit: u64, plt: bool) {
    android_import_checked_mut(imports, image, android_symbols(), library, local_name, name, minimum_api, abi_bit, plt);
}

#!/usr/bin/env python3
"""Check Android import API/type/ABI contracts with an existing release assembler.

Freeze the consumed includes, assemble real ELF64 images, inspect dynamic symbols
and relocations independently, and require invalid imports to leave no product.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import tomllib

ROOT = Path(__file__).resolve().parents[2]


def sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def freeze(source: Path, target: Path) -> dict:
    files = [*source.rglob("format/**/*.inc"), *source.rglob("format/**/*.toml"), *source.glob("os/android/imports/*.inc")]
    files += [source / name for name in ("os/android/imports.inc", "os/android/import_helpers.inc",
                                        "os/android/catalog.inc", "os/android/catalog/symbols.toml")]
    selected = {path.resolve() for path in files}
    hashes = {}
    for path in files:
        relative = path.relative_to(source)
        destination = target / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        original = path.read_bytes()
        content = original.decode("utf-8")
        if path.suffix == ".inc":
            def resolve(match):
                name = match.group(1)
                candidate = (source / name).resolve() if name.startswith(("format/", "os/")) else (path.parent / name).resolve()
                assert candidate in selected, (path, name, "unfrozen dependency")
                return "import(" + json.dumps((target / candidate.relative_to(source)).as_posix()) + ")"
            content = re.sub(r'import\("([^"\n]+)"\)', resolve, content)
        if relative.as_posix() == "os/android/catalog.inc":
            content = content.replace('"os/android/catalog/symbols.toml"', json.dumps((target / "os/android/catalog/symbols.toml").as_posix()))
        destination.write_text(content, encoding="utf-8", newline="\n")
        hashes[relative.as_posix()] = {"source": sha(original), "test_input": sha(destination.read_bytes())}
    assert all(sha((source / name).read_bytes()) == values["source"] for name, values in hashes.items()), "includes changed during freeze"
    return hashes


def elf(path: Path) -> dict:
    data = path.read_bytes()
    h = struct.unpack_from("<16sHHIQQQIHHHHHH", data)
    assert h[0][:5] == b"\x7fELF\x02"
    sections = [struct.unpack_from("<IIQQQQIIQQ", data, h[6] + i * h[11]) for i in range(h[12])]
    strings = sections[h[13]]
    names = data[strings[4]:strings[4] + strings[5]]
    lookup = {names[s[0]:names.index(0, s[0])].decode(): s for s in sections}
    sym = lookup[".dynsym"]
    strings = sections[sym[6]]
    names = data[strings[4]:strings[4] + strings[5]]
    symbols = []
    for off in range(sym[4], sym[4] + sym[5], sym[9]):
        row = struct.unpack_from("<IBBHQQ", data, off)
        symbols.append({"name": names[row[0]:names.index(0, row[0])].decode(), "type": row[1] & 15, "section": row[3]})
    relocations = []
    for name in (".rela.dyn", ".rela.plt"):
        if name not in lookup:
            continue
        sec = lookup[name]
        for off in range(sec[4], sec[4] + sec[5], 24):
            address, info, addend = struct.unpack_from("<QQq", data, off)
            relocations.append({"section": name, "name": symbols[info >> 32]["name"], "type": info & 0xffffffff,
                                "address": address, "addend": addend})
    return {"machine": h[2], "type": h[1], "symbols": symbols, "relocations": relocations}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--assembler", type=Path, required=True)
    parser.add_argument("--include-dir", type=Path, default=ROOT / "include")
    parser.add_argument("--output", type=Path, default=ROOT / "tmp/android-import-reference")
    args = parser.parse_args()
    out, exe = args.output.resolve(), args.assembler.resolve()
    out.mkdir(parents=True, exist_ok=True)
    includes = out / "include"
    hashes = freeze(args.include_dir.resolve(), includes)
    rows = []
    preamble = f'import({json.dumps((includes / "os/android/imports.inc").as_posix())});\n'

    def assemble(name, source, error=None):
        asm, product = out / (name + ".asm"), out / (name + ".bin")
        asm.write_text(preamble + source, encoding="utf-8")
        product.unlink(missing_ok=True)
        command = [str(exe), str(asm), "-o", str(product)]
        result = subprocess.run(command, capture_output=True, timeout=900 if name == "all-native-records" else 300)
        output = (result.stdout + result.stderr).decode("utf-8", errors="replace")
        (out / (name + ".log")).write_text(output, encoding="utf-8")
        assert result.returncode == (1 if error else 0), (name, result.returncode, output)
        if error:
            assert error in output, (name, error, output)
            assert not product.exists(), (name, "rejected import left a product")
        row = {"name": name, "command": command, "exit_code": result.returncode, "source_sha256": sha(asm.read_bytes()),
               "expected_error": error, "product_sha256": sha(product.read_bytes()) if product.exists() else None}
        rows.append(row)
        (out / "progress.json").write_text(json.dumps({"assembler_sha256": sha(exe.read_bytes()), "include_hashes": hashes, "tests": rows}, indent=2) + "\n", encoding="utf-8")
        print("PASS:", name, flush=True)
        return product, row

    query = '''const syms = android_symbols();
assert(android_symbol_min_api(syms, "__tls_get_addr") == 29);
assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", 1) == 30);
assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", 16) == 29);
assert(android_symbol_version_for(syms, "__tls_get_addr", "libc.so", 1) == "LIBC_R");
assert(android_symbol_version_for(syms, "__tls_get_addr", "libc.so", 16) == "LIBC_Q");
assert(!android_symbol_available_for(syms, "__tls_get_addr", "libc.so", 29, 1));
assert(android_symbol_available_for(syms, "__tls_get_addr", "libc.so", 29, 16));
assert(android_symbol_kind_for(syms, "SL_IID_ENGINE", "libOpenSLES.so", 1) == "object");
assert(android_symbol_kind_for(syms, "SL_IID_ENGINE", "libOpenSLES.so", 16) == "object");
assert(android_symbol_min_api_for(syms, "__android_log_write", "liblog.so", 8) == 35);
assert(android_symbol_min_api_for(syms, "__aeabi_memcpy", "libc.so", 2) == 21);
assert(!android_symbol_available_for(syms, "__aeabi_memcpy", "libc.so", 35, 1));
assert(!android_symbol_available_for(syms, "glClear", "liblog.so", 35, 1));
assert(android_symbol_version_for(syms, "__android_log_write", "liblog.so", 4) == "");
assert(android_symbol_min_api_for(syms, "ANativeWindow_acquire", "libandroid.so", 16) == 21);
assert(android_symbol_min_api_for(syms, "ANativeWindow_acquire", "libnativewindow.so", 16) == 26);
db(42);
'''
    assemble("exact-queries", query)

    # Traverse every table with the release DSL, then compare byte-level rows
    # with Python's independent TOML parser. Keep the local provider map rather
    # than repeatedly passing the entire catalog by value to each row lookup.
    sweep = '''const syms = android_symbols();
for name in map.keys(syms) {
    const providers = map.get(map.get(syms, name), "providers");
    for provider_key in map.keys(providers) {
        const provider = map.get(providers, provider_key);
        const library = map.get(provider, "library");
        assert(android_library_key(library) == provider_key);
        for bit in list.of(1, 2, 4, 8, 16) {
            if map.has(provider, android_abi_key(bit)) {
                const record = map.get(provider, android_abi_key(bit));
                const kind = map.get(record, "kind");
                let kind_number: u64 = 2;
                if kind == "object" {
                    kind_number = 1;
                }
                if kind == "ifunc" {
                    kind_number = 10;
                }
                const version = map.get(record, "ver");
                dw(len(name));
                db(name);
                dw(len(library));
                db(library);
                db(bit, map.get(record, "api"), kind_number);
                dw(len(version));
                db(version);
            }
        }
    }
}
'''
    product, row = assemble("all-native-records", sweep)
    with (includes / "os/android/catalog/symbols.toml").open("rb") as stream:
        data = tomllib.load(stream)
    expected = {}
    abi_keys = ("a64", "arm", "x86", "riscv64", "x64")
    for name, symbol in data["symbols"].items():
        for provider in symbol["providers"].values():
            for index, abi_key in enumerate(abi_keys):
                if abi_key in provider:
                    native = provider[abi_key]
                    expected[name, provider["library"], 1 << index] = (native["api"], {"object": 1, "func": 2, "ifunc": 10}[native["kind"]], native["ver"])
    actual, content, cursor = {}, product.read_bytes(), 0
    def string():
        nonlocal cursor
        size, = struct.unpack_from("<H", content, cursor)
        cursor += 2
        value = content[cursor:cursor + size].decode("ascii")
        cursor += size
        return value
    while cursor < len(content):
        name, library = string(), string()
        bit, api, kind = content[cursor:cursor + 3]
        cursor += 3
        version = string()
        key = (name, library, bit)
        assert key not in actual, key
        actual[key] = (api, kind, version)
    assert actual == expected, "release DSL provider rows disagree with independent TOML parser"
    row["native_rows"] = len(actual)
    row["libraries"] = len({key[1] for key in actual})

    def plan(abi, mode="so"):
        segments = 'list.of(format_segment(".text", format_load | format_readable | format_executable), format_segment(".data", format_load | format_readable | format_writeable))'
        if mode == "so":
            ctor = f'format_elf64_so{"_aarch64" if abi == 1 else ""}("libcatalog.so", {segments})'
        else:
            ctor = f'format_elf64{"_aarch64" if abi == 1 else ""}(format_elf_{mode}, {segments})'
        return f'let image = {ctor};\nlet imports = format_elfso_import_new();\n'

    def body(abi, mode):
        text = plan(abi, mode)
        text += f'android_import_opensles_add_pairs_checked_mut(imports, image, list.of("engine_a", "SL_IID_ENGINE"), 21, {abi}, false);\n'
        text += f'android_import_opensles_import_mut(imports, image, "engine_b", "SL_IID_ENGINE", 21, {abi}, false);\n'
        text += 'android_import_opensles_add_slots_mut(imports, list.of(android_import_opensles_SL_IID_ENGINE));\n'
        text += f'android_import_log_add_slots_checked_mut(imports, image, list.of(android_import_log___android_log_write), 21, {abi});\n'
        if abi == 16:
            text += 'android_import_opensles_add_checked_mut(imports, image, list.of(android_import_opensles_slCreateEngine), 21, 16);\n'
        else:
            text += 'android_import_opensles_add_slots_checked_mut(imports, image, list.of(android_import_opensles_slCreateEngine), 21, 1);\n'
        if mode == "so":
            text += 'let exports = format_elfso_export_new();\nformat_elfso_export_many_mut(exports, list.of("probe"), ".text", 4);\nformat_elfso_tables_mut(image, exports, imports);\n'
        else:
            text += 'format_elf_dynamic_mut(image, "/system/bin/linker64");\nformat_elfexe_tables_mut(image, imports);\n'
        text += 'format_begin(image);\nformat_segment_begin(image, ".text");\nprobe:\n'
        text += 'dd(0xd65f03c0);\n' if abi == 1 else 'db(0xc3, 0x90, 0x90, 0x90);\n'
        text += 'format_segment_end(image, ".text");\nformat_segment_begin(image, ".data");\ndq(0);\nformat_segment_end(image, ".data");\n'
        if mode != "so":
            text += 'format_entry_mut(image, probe);\n'
        return text + 'format_finish(image);\n'

    for abi in (1, 16):
        for mode in ("so", "exec", "pie"):
            product, row = assemble(f"typed-{abi}-{mode}", body(abi, mode))
            result = elf(product)
            assert result["machine"] == (183 if abi == 1 else 62)
            symbols = [s for s in result["symbols"] if s["name"] == "SL_IID_ENGINE"]
            assert len(symbols) == 1 and symbols[0]["type"] == 1 and symbols[0]["section"] == 0, symbols
            object_relocs = [r for r in result["relocations"] if r["name"] == "SL_IID_ENGINE"]
            assert len(object_relocs) == 3 and all(r["section"] == ".rela.dyn" and r["type"] == (1025 if abi == 1 else 6) and r["addend"] == 0 for r in object_relocs)
            function_reloc = [r for r in result["relocations"] if r["name"] == "slCreateEngine"]
            assert len(function_reloc) == 1 and function_reloc[0]["type"] == (1025 if abi == 1 else 7)
            assert function_reloc[0]["section"] == (".rela.dyn" if abi == 1 else ".rela.plt")
            row["elf"] = result

    for abi, api in ((1, 30), (16, 29)):
        assemble(f"tls-{abi}-api{api}", plan(abi) + f'android_import_c_import_mut(imports, image, "tls", "__tls_get_addr", {api}, {abi}, false);\ndb(len(imports));\n')

    negatives = [
        ("a64-tls-api29", 1, 'android_import_c_add_slots_checked_mut(imports, image, list.of("__tls_get_addr"), 29, 1);', "Android import exceeds the selected minimum API"),
        ("x64-tls-api28", 16, 'android_import_c_add_slots_checked_mut(imports, image, list.of("__tls_get_addr"), 28, 16);', "Android import exceeds the selected minimum API"),
        ("later-provider", 1, 'android_import_nativewindow_add_slots_checked_mut(imports, image, list.of("ANativeWindow_acquire"), 25, 1);', "Android import exceeds the selected minimum API"),
        ("object-plt", 16, 'android_import_opensles_add_checked_mut(imports, image, list.of("SL_IID_ENGINE"), 21, 16);', "Android object imports require GOT slots"),
        ("object-legacy-plt", 16, 'android_import_opensles_add_mut(imports, list.of("SL_IID_ENGINE"));', "Android object imports require GOT slots"),
        ("wrong-library-legacy-got", 1, 'android_import_opensles_add_slots_mut(imports, list.of("ANativeWindow_lock"));', "android platform symbol is not provided by that library"),
        ("wrong-library-legacy-plt", 16, 'android_import_opensles_add_mut(imports, list.of("ANativeWindow_lock"));', "android platform symbol is not provided by that library"),
        ("a64-plt", 1, 'android_import_log_add_checked_mut(imports, image, list.of("__android_log_write"), 21, 1);', "Android AArch64 imports require GOT slots"),
        ("machine-mismatch", 1, 'android_import_log_add_slots_checked_mut(imports, image, list.of("__android_log_write"), 21, 16);', "Android import ABI does not match the ELF machine"),
        ("abi-mask", 16, 'android_import_log_add_slots_checked_mut(imports, image, list.of("__android_log_write"), 21, 17);', "Android ELF imports support AArch64 or x86-64 ABI"),
        ("abi-arm", 16, 'android_import_log_add_slots_checked_mut(imports, image, list.of("__android_log_write"), 21, 2);', "Android ELF imports support AArch64 or x86-64 ABI"),
        ("missing-abi", 1, 'android_import_c_add_slots_checked_mut(imports, image, list.of("__aeabi_memcpy"), 35, 1);', "android platform symbol is unavailable for that ABI"),
        ("wrong-library", 1, 'android_import_log_add_slots_checked_mut(imports, image, list.of("strlen"), 35, 1);', "android platform symbol is not provided by that library"),
        ("unknown-symbol", 1, 'android_import_log_add_slots_checked_mut(imports, image, list.of("missing_android_symbol"), 35, 1);', "android platform symbol is unknown"),
        ("odd-pairs", 1, 'android_import_log_add_pairs_checked_mut(imports, image, list.of("alias"), 35, 1, false);', "Android import pairs require local/name entries"),
        ("empty-local", 16, 'android_import_log_import_mut(imports, image, "", "__android_log_write", 21, 16, true);', "Android import local label is empty"),
        ("same-slot-different-name", 1, 'android_import_log_import_mut(imports, image, "same", "__android_log_write", 21, 1, false);\nandroid_import_log_import_mut(imports, image, "same", "__android_log_print", 21, 1, false);', "ELF SO import slot already maps to a different symbol"),
        ("same-slot-different-type", 1, 'android_import_log_import_mut(imports, image, "same", "__android_log_write", 21, 1, false);\nandroid_import_opensles_import_mut(imports, image, "same", "SL_IID_ENGINE", 21, 1, false);', "Android import slot has conflicting symbol types"),
        ("late-import", 1, 'format_begin(image);\nandroid_import_log_add_slots_checked_mut(imports, image, list.of("__android_log_write"), 21, 1);', "Android imports must be configured before format_begin"),
    ]
    for name, abi, code, error in negatives:
        assemble(name, plan(abi) + code + "\ndb(0);\n", error)
    assemble("query-combined-abi", 'const syms = android_symbols();\nconst unused = android_symbol_min_api_for(syms, "__android_log_write", "liblog.so", 31);\ndb(0);\n', "Android ABI must be one catalog ABI bit")
    fake = '''const record = map.set(map.set(map.set(map.new(), "api", 21), "kind", "ifunc"), "ver", "");
const provider = map.set(map.set(map.new(), "a64", record), "library", "liblog.so");
const symbol = map.set(map.new(), "providers", map.set(map.new(), "liblog_so", provider));
const syms = map.set(map.new(), "ifunc_symbol", symbol);
android_import_checked_mut(imports, image, syms, "liblog.so", "slot", "ifunc_symbol", 21, 1, false);
db(0);
'''
    assemble("unsupported-ifunc", plan(1) + fake, "Android ELF format does not support IFUNC imports")
    shadow = '''if true {
    let android_import_catalog_cache: map = map.new();
    android_import_log_add_slots_checked_mut(imports, image, list.of("__android_log_write"), 21, 1);
    assert(len(android_import_catalog_cache) == 0, "import helper changed caller state");
}
db(len(imports));
'''
    assemble("caller-shadow-map", plan(1) + shadow)
    forged = '''if true {
    const record = map.set(map.set(map.set(map.new(), "api", 21), "kind", "func"), "ver", "");
    const provider = map.set(map.set(map.new(), "a64", record), "library", "libc.so");
    const symbol = map.set(map.new(), "providers", map.set(map.new(), "libc_so", provider));
    let android_import_catalog_cache = map.set(map.new(), "__tls_get_addr", symbol);
    android_import_c_import_mut(imports, image, "tls", "__tls_get_addr", 21, 1, false);
}
db(len(imports));
'''
    assemble("caller-forged-cache-api", plan(1) + forged, "Android import exceeds the selected minimum API")
    receipt = {"passed": True, "assembler_sha256": sha(exe.read_bytes()), "include_hashes": hashes, "tests": rows}
    (out / "summary.json").write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(f"PASS: {len(rows)} Android catalog/import contract checks", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

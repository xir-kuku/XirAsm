#!/usr/bin/env python3
"""Generate the Android platform symbol catalog for XIRASM.

The catalog answers four questions about the Android platform libraries:

  * which library provides a symbol,
  * the first API level for each (symbol, library, ABI),
  * which ABIs provide it,
  * and the symbol type and GNU version tag for each provider and ABI.

Everything comes from the NDK's stub libraries, one directory per ABI and API
level. Symbol tables are parsed directly out of the ELF images, so the whole NDK
tree costs a fraction of a second and no external tools are needed to generate.

What is emitted (all deterministic, no timestamps):

  <out>/catalog/symbols.toml   the data
  <out>/catalog/manifest.json  counts and provenance
  <out>/NOTICE.md              where the data came from and under which license

usage:
  python tests/os/generate_android_symbols.py --ndk <ndk root>
  python tests/os/generate_android_symbols.py --ndk <ndk root> --check

--check regenerates in memory and compares against the checked-in files without
writing. Objects are included by default; --reference-catalog additionally
compares every per-ABI record with a schema-2 native-symbols.json baseline.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import struct
import sys
import tempfile
from collections import Counter, defaultdict
from pathlib import Path

SCHEMA = 2
GENERATOR = "generate_android_symbols.py"

# ABI order is part of the format: the bit position of each ABI in the mask is
# its index here, so the order must never change once a catalog is published.
ABI_ORDER = (
    "aarch64-linux-android",
    "arm-linux-androideabi",
    "i686-linux-android",
    "riscv64-linux-android",
    "x86_64-linux-android",
)
PRIMARY_ABI = "aarch64-linux-android"
ABI_KEYS = ("a64", "arm", "x86", "riscv64", "x64")

DEFAULT_API_MIN = 21
DEFAULT_API_MAX = 35

SHT_DYNSYM = 11
SHT_GNU_VERDEF = 0x6FFFFFFD
SHT_GNU_VERSYM = 0x6FFFFFFF

STT_OBJECT = 1
STT_FUNC = 2
STT_GNU_IFUNC = 10
SHN_UNDEF = 0

BARE_KEY = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")

TOML_HEADER = (
    "# Android platform symbol catalog.",
    "#",
    "# Generated from the NDK stub libraries, one directory per ABI and API level.",
    "# Do not edit by hand; regenerate with tests/os/generate_android_symbols.py.",
)


class ElfError(Exception):
    """Raised when a stub library cannot be read as an ELF image."""


def parse_dynamic_symbols(path: Path) -> tuple[list[tuple[str, int, str]], Counter]:
    """Return (defined dynamic symbols, symbol type counter) for one ELF image.

    Each entry is (name, st_info_type, gnu_version). Names never carry the
    ``@@VERSION`` suffix; the version travels separately.
    """
    data = path.read_bytes()
    if data[:4] != b"\x7fELF":
        raise ElfError("not an ELF image")
    ei_class = data[4]
    if ei_class == 2:
        sh_fmt, sh_size, sym_fmt = "<IIQQQQIIQQ", 64, "<IBBHQQ"
    elif ei_class == 1:
        sh_fmt, sh_size, sym_fmt = "<IIIIIIIIII", 40, "<IIIBBH"
    else:
        raise ElfError(f"unsupported ELF class {ei_class}")

    if ei_class == 2:
        e_shoff, = struct.unpack_from("<Q", data, 0x28)
        e_shentsize, e_shnum, e_shstrndx = struct.unpack_from("<HHH", data, 0x3A)
    else:
        e_shoff, = struct.unpack_from("<I", data, 0x20)
        e_shentsize, e_shnum, e_shstrndx = struct.unpack_from("<HHH", data, 0x2E)
    if not e_shoff or not e_shnum:
        raise ElfError("no section table")

    sections = []
    for index in range(e_shnum):
        fields = struct.unpack_from(sh_fmt, data, e_shoff + index * e_shentsize)
        sections.append({
            "name": fields[0], "type": fields[1], "offset": fields[4],
            "size": fields[5], "link": fields[6], "entsize": fields[9],
        })

    dynsym = next((s for s in sections if s["type"] == SHT_DYNSYM), None)
    if dynsym is None:
        raise ElfError("no dynamic symbol table")
    strtab = sections[dynsym["link"]]
    strings = data[strtab["offset"]:strtab["offset"] + strtab["size"]]

    def string_at(offset: int) -> str:
        end = strings.find(b"\x00", offset)
        if end < 0:
            raise ElfError("unterminated string")
        return strings[offset:end].decode("ascii", "replace")

    entsize = dynsym["entsize"] or struct.calcsize(sym_fmt)
    count = dynsym["size"] // entsize
    raw: list[tuple[str, int, int]] = []
    for index in range(count):
        off = dynsym["offset"] + index * entsize
        if ei_class == 2:
            st_name, st_info, _st_other, st_shndx, _st_value, _st_size = struct.unpack_from(sym_fmt, data, off)
        else:
            st_name, _st_value, _st_size, st_info, _st_other, st_shndx = struct.unpack_from(sym_fmt, data, off)
        raw.append((string_at(st_name), st_info & 0xF, st_shndx))

    versions = resolve_versions(data, sections, count, string_at)
    symbols: list[tuple[str, int, str]] = []
    types: Counter = Counter()
    for index, (name, st_type, st_shndx) in enumerate(raw):
        if st_shndx == SHN_UNDEF or not name:
            continue
        types[st_type] += 1
        symbols.append((name, st_type, versions[index]))
    return symbols, types


def resolve_versions(data: bytes, sections: list[dict], count: int, string_at) -> list[str]:
    """Map .gnu.version indices onto the names in .gnu.version_d."""
    versions = [""] * count
    versym = next((s for s in sections if s["type"] == SHT_GNU_VERSYM), None)
    verdef = next((s for s in sections if s["type"] == SHT_GNU_VERDEF), None)
    if versym is None or verdef is None:
        return versions
    names_by_index: dict[int, str] = {}
    offset = verdef["offset"]
    end = offset + verdef["size"]
    while offset < end:
        _version, _flags, vd_ndx, _cnt, _hash, vd_aux, vd_next = struct.unpack_from("<HHHHIII", data, offset)
        vda_name, _vda_next = struct.unpack_from("<II", data, offset + vd_aux)
        names_by_index[vd_ndx] = string_at(vda_name)
        if not vd_next:
            break
        offset += vd_next
    for index in range(count):
        slot = versym["offset"] + index * 2
        if slot + 2 > len(data):
            break
        value, = struct.unpack_from("<H", data, slot)
        name_index = value & 0x7FFF
        # 0 is local and 1 is the global base version, which every symbol carries;
        # their verdef names are the soname, not a version tag.
        if name_index < 2:
            continue
        if name_index in names_by_index:
            versions[index] = names_by_index[name_index]
    return versions


def kind_of(st_type: int) -> str:
    if st_type == STT_GNU_IFUNC:
        return "ifunc"
    if st_type == STT_OBJECT:
        return "object"
    if st_type == STT_FUNC:
        return "func"
    raise ElfError(f"unsupported Android dynamic symbol type {st_type}")


def scan(ndk: Path, abis: tuple[str, ...], api_min: int, api_max: int,
         include_objects: bool = True) -> tuple[dict, dict]:
    """Keep first API, type and version separately for every library and ABI."""
    lib_root = ndk / "toolchains" / "llvm" / "prebuilt" / "windows-x86_64" / "sysroot" / "usr" / "lib"
    if not lib_root.is_dir():
        raise SystemExit(f"missing NDK sysroot library root: {lib_root}")

    rows: dict[tuple[str, str], dict] = {}
    stats = {
        "stub_files": 0,
        "skipped_files": [],
        "skipped_type": Counter(),
        "skipped_name": [],
        "library_first_api": {},
        "per_abi": {},
        "digest": hashlib.sha256(),
        "libraries_per_api": {},
        "stub_hashes": {},
    }

    for abi in abis:
        abi_dir = lib_root / abi
        if not abi_dir.is_dir():
            raise SystemExit(f"missing ABI directory: {abi_dir}")
        bit = 1 << ABI_ORDER.index(abi)
        abi_libraries: set[str] = set()
        abi_files = 0
        for api in range(api_min, api_max + 1):
            api_dir = abi_dir / str(api)
            if not api_dir.is_dir():
                continue
            stubs = sorted(api_dir.glob("*.so"))
            stats["libraries_per_api"][api] = len(stubs)
            for stub in stubs:
                library = stub.name
                abi_files += 1
                stats["stub_files"] += 1
                stats["digest"].update(f"{abi}/{api}/{library}/{stub.stat().st_size}\n".encode())
                stats["digest"].update(hashlib.sha256(stub.read_bytes()).digest())
                stats["stub_hashes"][f"{abi}/{api}/{library}"] = hashlib.sha256(stub.read_bytes()).hexdigest()
                try:
                    symbols, _types = parse_dynamic_symbols(stub)
                except (ElfError, struct.error, IndexError, ValueError) as error:
                    stats["skipped_files"].append(f"{abi}/{api}/{library}: {error}")
                    continue
                abi_libraries.add(library)
                stats["library_first_api"].setdefault(library, api)
                for name, st_type, version in symbols:
                    kind = kind_of(st_type)
                    if kind == "object" and not include_objects:
                        stats["skipped_type"]["object"] += 1
                        continue
                    if not BARE_KEY.match(name):
                        stats["skipped_name"].append(f"{abi}/{api}/{library}: {name!r}")
                        continue
                    key = (name, library)
                    row = rows.get(key)
                    if row is None:
                        rows[key] = {
                            "min_api": api,
                            "version": version,
                            "abis": bit,
                            "kind": kind,
                            "by_abi": {str(bit): {"min_api": api, "kind": kind, "version": version}},
                        }
                        continue
                    selected = row["by_abi"].get(str(bit))
                    if selected is None:
                        row["by_abi"][str(bit)] = {"min_api": api, "kind": kind, "version": version}
                    elif selected["kind"] != kind:
                        raise ElfError(f"symbol changes type: {abi}/{api}/{library}: {name}")
                    row["abis"] |= bit
                    if api < row["min_api"]:
                        row["min_api"] = api
                    if not row["version"] and version:
                        row["version"] = version
        selected_rows = [row["by_abi"][str(bit)] for row in rows.values() if str(bit) in row["by_abi"]]
        stats["per_abi"][abi] = {"stub_files": abi_files, "libraries": len(abi_libraries),
                                "symbol_library_pairs": len(selected_rows),
                                "kinds": dict(sorted(Counter(row["kind"] for row in selected_rows).items()))}
    return rows, stats


def check_reference(rows: dict, reference: Path) -> dict:
    """Compare every available reference ABI; no aggregate field is trusted."""
    catalog = json.loads(reference.read_text(encoding="utf-8"))
    if catalog.get("schema") != 2:
        raise SystemExit("reference native catalog must use schema 2")
    expected = {(record["name"], record["library"], bit): value
                for record in catalog["records"] for bit, value in record["by_abi"].items()}
    bits = set(catalog["source_metadata"]["abis"])
    actual = {(name, library, bit): value for (name, library), row in rows.items()
              for bit, value in row["by_abi"].items() if bit in bits}
    differences = sorted(key for key in expected.keys() | actual.keys() if expected.get(key) != actual.get(key))
    if differences:
        raise SystemExit(f"per-ABI native reference mismatch ({len(differences)}): {differences[:12]}")
    return {"sha256": hashlib.sha256(reference.read_bytes()).hexdigest(),
            "rows_per_abi": {bit: sum(key[2] == bit for key in expected) for bit in sorted(bits, key=int)}}


INCLUDE_HEADER = (
    "// Generated Android platform symbols for XIRASM.",
    "// Source: NDK stub libraries; counts and provenance are in",
    "// os/android/catalog/manifest.json.",
    "// Do not edit this file directly.",
)

# The convenience entry imports these; everything else stays one import away.
CURATED_LIBRARIES = (
    "libandroid.so",
    "liblog.so",
    "libEGL.so",
    "libGLESv2.so",
    "libGLESv3.so",
    "libm.so",
    "libdl.so",
    "libz.so",
)


def library_alias(library: str) -> str:
    """Identifier fragment for one platform library: libGLESv2.so -> glesv2."""
    name = library[3:] if library.startswith("lib") else library
    if name.endswith(".so"):
        name = name[:-3]
    alias = re.sub(r"[^A-Za-z0-9_]", "_", name).lower()
    if not alias or alias[0].isdigit():
        alias = "_" + alias
    return alias


def library_file(library: str) -> str:
    """Generated include file name for one platform library."""
    name = library[:-3] if library.endswith(".so") else library
    return re.sub(r"[^A-Za-z0-9_]", "_", name) + ".inc"


def provider_key(library: str) -> str:
    """Avoid quoted dotted keys, which the release TOML parser splits at dots."""
    key = library.replace(".", "_").replace("+", "_")
    assert BARE_KEY.fullmatch(key), library
    return key


def resolve_aliases(libraries: list[str]) -> dict[str, str]:
    aliases: dict[str, str] = {}
    taken: dict[str, str] = {}
    for library in sorted(libraries):
        alias = library_alias(library)
        while alias in taken:
            alias += "_lib"
        taken[alias] = library
        aliases[library] = alias
    return aliases


def render_library_include(library: str, alias: str, entries: list[tuple[str, int, str, int, str]],
                           meta: dict) -> str:
    lines = [*INCLUDE_HEADER, ""]
    lines.append('import("os/android/import_helpers.inc")')
    lines.append("")
    lines.append(f'const android_import_{alias}_so: string = "{library}"')
    first_api = min(api for _symbol, api, _version, _mask, _kind in entries)
    lines.append(f"const android_import_{alias}_min_api: u64 = {first_api}")
    lines.append("")
    objects = [symbol for symbol, _api, _version, _mask, kind in entries if kind == "object"]
    ifuncs = [symbol for symbol, _api, _version, _mask, kind in entries if kind == "ifunc"]
    lines.append(f"const android_import_{alias}_all_names: list = list.of(" + ", ".join(toml_value(entry[0]) for entry in entries) + ")")
    lines.append(f"const android_import_{alias}_object_names: list = list.of(" + ", ".join(toml_value(n) for n in objects) + ")")
    lines.append(f"const android_import_{alias}_ifunc_names: list = list.of(" + ", ".join(toml_value(n) for n in ifuncs) + ")")
    lines.append("")
    lines.append("// Compatibility helpers do not select a minimum API or ABI.")
    lines.append("// Use the checked helpers below for platform availability checks.")
    lines.append(f"fn android_import_{alias}_add_mut(let imports: list, names: list) {{")
    lines.append(f"    android_import_legacy_mut(imports, android_import_{alias}_so, names, android_import_{alias}_all_names, android_import_{alias}_object_names, android_import_{alias}_ifunc_names, true)")
    lines.append("}")
    lines.append("")
    lines.append(f"fn android_import_{alias}_add_slots_mut(let imports: list, names: list) {{")
    lines.append(f"    android_import_legacy_mut(imports, android_import_{alias}_so, names, android_import_{alias}_all_names, android_import_{alias}_object_names, android_import_{alias}_ifunc_names, false)")
    lines.append("}")
    lines.append("")
    lines.extend([
        f"fn android_import_{alias}_import_mut(let imports: list, image: map, local_name: string, name: string, minimum_api: u64, abi_bit: u64, plt: bool) {{",
        f"    android_import_one_checked_mut(imports, image, android_import_{alias}_so, local_name, name, minimum_api, abi_bit, plt)",
        "}", "",
        f"fn android_import_{alias}_add_checked_mut(let imports: list, image: map, names: list, minimum_api: u64, abi_bit: u64) {{",
        f"    android_import_names_checked_mut(imports, image, android_import_{alias}_so, names, minimum_api, abi_bit, true)",
        "}", "",
        f"fn android_import_{alias}_add_slots_checked_mut(let imports: list, image: map, names: list, minimum_api: u64, abi_bit: u64) {{",
        f"    android_import_names_checked_mut(imports, image, android_import_{alias}_so, names, minimum_api, abi_bit, false)",
        "}", "",
        f"fn android_import_{alias}_add_pairs_checked_mut(let imports: list, image: map, pairs: list, minimum_api: u64, abi_bit: u64, plt: bool) {{",
        f"    android_import_pairs_checked_mut(imports, image, android_import_{alias}_so, pairs, minimum_api, abi_bit, plt)",
        "}", "",
    ])
    for symbol, api, version, mask, kind in entries:
        note = f"API {api}"
        if version:
            note += f", {version}"
        note += f", {kind}, abis={mask}"
        lines.append(f"// {symbol}: {note}")
        lines.append(f'const android_import_{alias}_{symbol}: string = "{symbol}"')
    return "\n".join(lines) + "\n"


def render_entry_include(aliases: dict[str, str], libraries: tuple[str, ...], title: str,
                         body: tuple[str, ...]) -> str:
    lines = [*INCLUDE_HEADER, "", f"// {title}"]
    lines.extend(f"// {line}" if line else "//" for line in body)
    lines.append("")
    for library in libraries:
        if library in aliases:
            lines.append(f'import("os/android/imports/{library_file(library)}")')
    return "\n".join(lines) + "\n"


def build_includes(rows: dict[tuple[str, str], dict], meta: dict) -> tuple[dict[str, str], str]:
    """Return (files under the catalog directory, the convenience root entry)."""
    libraries = sorted({library for _symbol, library in rows})
    aliases = resolve_aliases(libraries)
    per_library: dict[str, list[tuple[str, int, str, int, str]]] = {library: [] for library in libraries}
    for (symbol, library), row in rows.items():
        per_library[library].append((symbol, row["min_api"], row["version"], row["abis"], row["kind"]))

    files: dict[str, str] = {}
    for library in libraries:
        entries = sorted(per_library[library])
        files[f"imports/{library_file(library)}"] = render_library_include(
            library, aliases[library], entries, meta)
    files["imports.inc"] = render_entry_include(
        aliases, tuple(libraries), "Every platform library the catalog knows about.",
        ("Import os/android/imports/<library>.inc directly when one library is enough;",
         f"the full set below is {len(libraries)} files and "
         f"{len(rows)} constants."))
    root = render_entry_include(
        aliases, CURATED_LIBRARIES, "Platform declarations and the libraries most native projects start with.",
        ("Import os/android/imports.inc for every library, or",
         "os/android/catalog.inc when you need to look a symbol up by name."))
    root = root.replace('import("os/android/imports/libandroid.inc")',
                        'import("os/android/sdk.inc")\nimport("os/android/imports/libandroid.inc")', 1)
    return files, root


def render_symbols_toml(rows: dict[tuple[str, str], dict], meta: dict) -> str:
    """Group rows by symbol so a lookup is one key, with libraries comma-joined."""
    by_symbol: dict[str, list[tuple[str, dict]]] = defaultdict(list)
    for (name, library), row in rows.items():
        by_symbol[name].append((library, row))
    libraries = {library for _name, library in rows}
    assert len({provider_key(library) for library in libraries}) == len(libraries), "provider key collision"

    lines = [*TOML_HEADER, ""]
    lines.append("[meta]")
    for key in ("schema", "ndk_revision", "ndk_release", "api_min", "api_max", "abi_order"):
        lines.append(f"{key} = {toml_value(meta[key])}")
    lines.append("")
    lines.append("# lib/api/abis/kind/ver are compatibility summaries across libraries and ABIs.")
    lines.append("# providers preserves each library/ABI first API, kind and GNU version.")
    lines.append("# Select a provider and one ABI before checking availability or import type.")
    for name in sorted(by_symbol):
        entries = sorted(by_symbol[name])
        libraries = ",".join(f"{library}:{row['min_api']}" for library, row in entries)
        first_api = min(row["min_api"] for _, row in entries)
        mask = 0
        kinds = set()
        version = ""
        for _, row in entries:
            mask |= row["abis"]
            kinds.add(row["kind"])
            if row["version"] and not version:
                version = row["version"]
        kind = "func" if "func" in kinds else sorted(kinds)[0]
        lines.append("")
        lines.append(f"[symbols.{name}]")
        lines.append(f'lib = "{libraries}"')
        lines.append(f"api = {first_api}")
        if version:
            lines.append(f'ver = "{version}"')
        lines.append(f"abis = {mask}")
        lines.append(f'kind = "{kind}"')
        for library, row in entries:
            key = provider_key(library)
            lines.append(f"[symbols.{name}.providers.{key}]")
            lines.append(f"library = {toml_value(library)}")
            for bit, native in sorted(row["by_abi"].items(), key=lambda entry: int(entry[0])):
                abi_key = ABI_KEYS[int(bit).bit_length() - 1]
                lines.append(f"[symbols.{name}.providers.{key}.{abi_key}]")
                lines.append(f"api = {native['min_api']}")
                lines.append(f"kind = {toml_value(native['kind'])}")
                lines.append(f"ver = {toml_value(native['version'])}")
    return "\n".join(lines) + "\n"


def toml_value(value) -> str:
    if isinstance(value, str):
        return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value)


def build_manifest(rows: dict[tuple[str, str], dict], stats: dict, meta: dict) -> dict:
    symbols = {name for name, _ in rows}
    libraries = {library for _, library in rows}
    per_symbol: Counter = Counter(name for name, _ in rows)
    return {
        "schema": SCHEMA,
        "generator": GENERATOR,
        "ndk_revision": meta["ndk_revision"],
        "ndk_release": meta["ndk_release"],
        "api_min": meta["api_min"],
        "api_max": meta["api_max"],
        "abi_order": list(meta["abis"]),
        "primary_abi": PRIMARY_ABI,
        "stub_files": stats["stub_files"],
        "libraries": len(libraries),
        "symbols": len(symbols),
        "symbol_library_pairs": len(rows),
        "multi_library_symbols": sum(1 for count in per_symbol.values() if count > 1),
        "rows_with_version": sum(1 for row in rows.values() if row["version"]),
        "kind_func": sum(1 for row in rows.values() if row["kind"] == "func"),
        "kind_object": sum(1 for row in rows.values() if row["kind"] == "object"),
        "kind_ifunc": sum(1 for row in rows.values() if row["kind"] == "ifunc"),
        "skipped_objects": stats["skipped_type"].get("object", 0),
        "skipped_files": stats["skipped_files"],
        "skipped_names": stats["skipped_name"][:20],
        "skipped_name_count": len(stats["skipped_name"]),
        "libraries_per_api": {str(api): count for api, count in sorted(stats["libraries_per_api"].items())},
        "per_abi": stats["per_abi"],
        "source_digest": stats["digest"].hexdigest(),
        "stub_hashes": stats["stub_hashes"],
    }


def render_manifest(manifest: dict) -> str:
    return json.dumps(manifest, indent=2, sort_keys=True) + "\n"


def render_notice(manifest: dict) -> str:
    return f"""# Android platform declarations

The tables in this directory are derived from the stub libraries that ship with
the Android NDK, release {manifest['ndk_release']}
(`Pkg.Revision = {manifest['ndk_revision']}`), which are distributed by the
Android Open Source Project under the Apache License, Version 2.0.

What is derived: symbol names, the stub library that provides them, the first API
level in which each appears, the GNU version tag the stub declares, and the ABIs
that export them. Constants and native record layouts are derived from the
matching NDK headers, with layouts checked by NDK Clang. The generators are
`generate_android_symbols.py`, `generate_android_constants.py` and
`generate_android_structures.py` in the XIRASM repository. The manifests under
`catalog/` record counts and source hashes.

The stub libraries are link-time descriptions of the platform surface. They do
not enumerate everything a device may resolve at run time, so a symbol that is
absent here is not proof that no device provides it, and a few stub entries are
internals the platform libraries keep private. `README.md` describes both sides
of that boundary and names the tools that check a target device.
"""


def write_outputs(out: Path, files: dict[str, str]) -> None:
    for relative, text in files.items():
        target = out / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(text, encoding="utf-8", newline="\n")


def compare_trees(existing: Path, generated: dict[str, str]) -> list[str]:
    differences: list[str] = []
    for relative, text in generated.items():
        target = existing / relative
        if not target.is_file():
            differences.append(f"missing: {relative}")
        elif target.read_text(encoding="utf-8") != text:
            differences.append(f"differs: {relative}")
    return differences


def read_ndk_revision(ndk: Path) -> tuple[str, str]:
    properties = ndk / "source.properties"
    revision = release = "unknown"
    if properties.is_file():
        for line in properties.read_text(encoding="utf-8", errors="replace").splitlines():
            if line.startswith("Pkg.Revision"):
                revision = line.split("=", 1)[1].strip()
            elif line.startswith("Pkg.ReleaseName"):
                release = line.split("=", 1)[1].strip()
    return revision, release


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--ndk", type=Path, required=True, help="NDK root (the directory holding source.properties)")
    parser.add_argument("--out", type=Path, default=Path("include/os/android"),
                        help="catalog directory (default: include/os/android)")
    parser.add_argument("--root-include", type=Path, default=Path("include/os/android.inc"),
                        help="convenience entry file outside the catalog directory")
    parser.add_argument("--abis", default=",".join(ABI_ORDER),
                        help=f"comma separated ABI list, aarch64 first by default ({PRIMARY_ABI} is primary)")
    parser.add_argument("--api-min", type=int, default=DEFAULT_API_MIN)
    parser.add_argument("--api-max", type=int, default=DEFAULT_API_MAX)
    parser.add_argument("--include-objects", action="store_true", default=True,
                        help="catalog STT_OBJECT data symbols (the default; retained for compatibility)")
    parser.add_argument("--functions-only", action="store_false", dest="include_objects",
                        help="generate a deliberately restricted catalog without STT_OBJECT symbols")
    parser.add_argument("--reference-catalog", type=Path,
                        help="independently generated schema-2 native-symbols.json for exact per-ABI comparison")
    parser.add_argument("--runtime-only", action="store_true",
                        help="only generate catalog data and library includes, preserving entry and NOTICE files")
    parser.add_argument("--emit", choices=("all", "data", "includes"), default="all",
                        help="which parts to generate (default: everything)")
    parser.add_argument("--check", action="store_true",
                        help="compare against the checked-in catalog instead of writing it")
    args = parser.parse_args()

    abis = tuple(item.strip() for item in args.abis.split(",") if item.strip())
    unknown = [abi for abi in abis if abi not in ABI_ORDER]
    if unknown:
        raise SystemExit(f"unknown ABI(s): {', '.join(unknown)}")
    if len(set(abis)) != len(abis) or not abis:
        raise SystemExit("ABI selection must be nonempty and contain no duplicates")
    if not 1 <= args.api_min <= args.api_max:
        raise SystemExit("invalid API scan range")

    revision, release = read_ndk_revision(args.ndk)
    rows, stats = scan(args.ndk, abis, args.api_min, args.api_max, args.include_objects)
    meta = {
        "schema": SCHEMA,
        "ndk_revision": revision,
        "ndk_release": release,
        "api_min": args.api_min,
        "api_max": args.api_max,
        "abis": abis,
        "abi_order": ",".join(abis),
    }
    manifest = build_manifest(rows, stats, meta)
    if args.reference_catalog:
        reference = check_reference(rows, args.reference_catalog)
        print(f"native reference matches per ABI: {reference['rows_per_abi']} ({reference['sha256']})")
    generated: dict[str, str] = {}
    root_entry: str | None = None
    if args.emit in ("all", "data"):
        generated["catalog/symbols.toml"] = render_symbols_toml(rows, meta)
        generated["catalog/manifest.json"] = render_manifest(manifest)
        if not args.runtime_only:
            generated["NOTICE.md"] = render_notice(manifest)
    if args.emit in ("all", "includes"):
        include_files, root_entry = build_includes(rows, meta)
        generated.update(include_files)
    if args.runtime_only:
        root_entry = None

    if args.check:
        differences = compare_trees(args.out, generated)
        if root_entry is not None:
            if not args.root_include.is_file():
                differences.append(f"missing: {args.root_include}")
            elif args.root_include.read_text(encoding="utf-8") != root_entry:
                differences.append(f"differs: {args.root_include}")
        if differences:
            print(f"catalog is not up to date ({len(differences)} difference(s)):")
            for line in differences[:40]:
                print(f"  {line}")
            return 1
        print(f"catalog matches the recorded NDK ({manifest['symbols']} symbols, "
              f"{manifest['libraries']} libraries)")
        return 0

    write_outputs(args.out, generated)
    if root_entry is not None:
        args.root_include.parent.mkdir(parents=True, exist_ok=True)
        args.root_include.write_text(root_entry, encoding="utf-8", newline="\n")
    print(f"stub files scanned : {manifest['stub_files']}")
    print(f"libraries          : {manifest['libraries']}")
    print(f"symbols            : {manifest['symbols']} ({manifest['symbol_library_pairs']} symbol/library rows)")
    print(f"multi-library      : {manifest['multi_library_symbols']}")
    print(f"skipped objects    : {manifest['skipped_objects']}")
    print(f"skipped files      : {len(manifest['skipped_files'])}")
    print(f"source digest      : {manifest['source_digest'][:16]}…")
    for relative, text in generated.items():
        print(f"wrote {args.out / relative} ({len(text)} bytes)")
    if root_entry is not None:
        print(f"wrote {args.root_include} ({len(root_entry)} bytes)")
    return 0


if __name__ == "__main__":
    sys.exit(main())

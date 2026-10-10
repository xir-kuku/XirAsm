#!/usr/bin/env python3
"""Independently validate every Android library/ABI API, type and GNU version.

This uses NDK llvm-readelf rather than the generator's ELF parser. Version tags
must be compared even when empty; llvm-nm omits them on some toolchain versions.
"""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tomllib

ROOT = Path(__file__).resolve().parents[2]
ABI_ORDER = ("aarch64-linux-android", "arm-linux-androideabi", "i686-linux-android",
             "riscv64-linux-android", "x86_64-linux-android")
ABI_KEYS = ("a64", "arm", "x86", "riscv64", "x64")
IDENTIFIER = re.compile(r"[A-Za-z_][A-Za-z0-9_]*\Z")
SYMBOL = re.compile(r"^\s*\d+:\s+[0-9a-fA-F]+\s+\S+\s+(\S+)\s+\S+\s+\S+\s+(\S+)\s+(\S+)")
KINDS = {"FUNC": "func", "OBJECT": "object", "IFUNC": "ifunc"}


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def catalog_rows(data: dict) -> dict:
    rows = {}
    for name, symbol in data["symbols"].items():
        assert IDENTIFIER.fullmatch(name), name
        for provider_key, by_abi in symbol["providers"].items():
            library = by_abi["library"]
            assert library.endswith(".so"), library
            assert provider_key == library.replace(".", "_").replace("+", "_")
            for abi_key, record in by_abi.items():
                if abi_key == "library":
                    continue
                assert abi_key in ABI_KEYS, (name, library, abi_key)
                bit = 1 << ABI_KEYS.index(abi_key)
                key = (name, library, bit)
                assert key not in rows and set(record) == {"api", "kind", "ver"}, key
                assert data["meta"]["api_min"] <= record["api"] <= data["meta"]["api_max"], key
                assert record["kind"] in KINDS.values() and isinstance(record["ver"], str), key
                rows[key] = record
        selected = [(provider["library"], {key: row for key, row in provider.items() if key != "library"})
                    for provider in symbol["providers"].values()]
        summaries = sorted(f"{library}:{min(r['api'] for r in records.values())}" for library, records in selected)
        assert symbol["lib"] == ",".join(summaries), name
        assert symbol["api"] == min(row["api"] for _, records in selected for row in records.values()), name
        mask = 0
        for _, records in selected:
            for abi_key in records:
                mask |= 1 << ABI_KEYS.index(abi_key)
        assert symbol["abis"] == mask, name
    return rows


def read_stubs(reader: Path, files: list[Path]) -> tuple[dict, list[str]]:
    if not files:
        return {}, []
    command = [str(reader), "--dyn-syms", "--wide", *map(str, files)]
    result = subprocess.run(command, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=60)
    assert result.returncode == 0, result.stderr
    rows, library = {}, files[0].name if len(files) == 1 else None
    for line in result.stdout.splitlines():
        if line.startswith("File: "):
            library = Path(line[6:]).name
            continue
        match = SYMBOL.match(line)
        if not match:
            continue
        kind, section, spelling = match.groups()
        if section == "UND":
            continue
        assert kind in KINDS and library is not None, (line, library)
        name, _, version = spelling.partition("@@")
        if "@" in name:
            name, _, version = name.partition("@")
        assert IDENTIFIER.fullmatch(name), line
        key = (name, library)
        value = {"kind": KINDS[kind], "ver": version}
        assert key not in rows or rows[key] == value, (key, rows.get(key), value)
        rows[key] = value
    return rows, command


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ndk", type=Path, required=True)
    parser.add_argument("--catalog", type=Path, default=ROOT / "include/os/android")
    parser.add_argument("--abis", default=",".join(ABI_ORDER))
    parser.add_argument("--api-min", type=int)
    parser.add_argument("--api-max", type=int)
    parser.add_argument("--reference-catalog", type=Path, help="optional schema-2 native-symbols.json baseline")
    parser.add_argument("--output", type=Path, default=ROOT / "tmp/android-symbol-validation/summary.json")
    args = parser.parse_args()
    data_path = args.catalog / "catalog/symbols.toml"
    manifest_path = args.catalog / "catalog/manifest.json"
    with data_path.open("rb") as stream:
        data = tomllib.load(stream)
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    assert data["meta"]["schema"] == manifest["schema"] == 2
    all_rows = catalog_rows(data)
    abis = args.abis.split(",")
    assert abis and len(set(abis)) == len(abis) and set(abis) <= set(ABI_ORDER)
    bits = {1 << ABI_ORDER.index(abi) for abi in abis}
    expected = {key: value for key, value in all_rows.items() if key[2] in bits}
    api_min = args.api_min if args.api_min is not None else data["meta"]["api_min"]
    api_max = args.api_max if args.api_max is not None else data["meta"]["api_max"]
    reader = args.ndk / "toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-readelf.exe"
    assert reader.is_file(), reader
    lib_root = args.ndk / "toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/lib"
    derived, commands = {}, []
    for abi in abis:
        bit = 1 << ABI_ORDER.index(abi)
        for api in range(api_min, api_max + 1):
            files = sorted((lib_root / abi / str(api)).glob("*.so"))
            stubs = []
            for path in files:
                with path.open("rb") as stream:
                    magic = stream.read(4)
                if magic == b"\x7fELF":
                    stubs.append(path)
                else:
                    assert path.name == "libc++.so" and b"INPUT(" in path.read_bytes(), path
            rows, command = read_stubs(reader, stubs)
            if command:
                commands.append(command)
            for (name, library), row in rows.items():
                key = (name, library, bit)
                if key not in derived:
                    derived[key] = {"api": api, **row}
                else:
                    assert derived[key]["kind"] == row["kind"], (key, "type changes with API")
    differences = [{"key": key, "catalog": expected.get(key), "ndk": derived.get(key)}
                   for key in sorted(expected.keys() | derived.keys()) if expected.get(key) != derived.get(key)]
    pairs = {(name, library) for name, library, _bit in all_rows}
    assert manifest["symbols"] == len(data["symbols"])
    assert manifest["symbol_library_pairs"] == len(pairs)
    assert manifest["libraries"] == len({library for _, library in pairs})
    per_abi = {}
    for abi in abis:
        bit = 1 << ABI_ORDER.index(abi)
        values = [value for key, value in derived.items() if key[2] == bit]
        per_abi[abi] = {"symbol_library_pairs": len(values), "kinds": dict(sorted(Counter(v["kind"] for v in values).items()))}
        for field, value in per_abi[abi].items():
            assert manifest["per_abi"][abi][field] == value, (abi, field)
    reference = None
    if args.reference_catalog:
        source = json.loads(args.reference_catalog.read_text(encoding="utf-8"))
        assert source["schema"] == 2
        source_rows = {(r["name"], r["library"], int(bit)): {"api": v["min_api"], "kind": v["kind"], "ver": v["version"]}
                       for r in source["records"] for bit, v in r["by_abi"].items()}
        source_bits = {int(bit) for bit in source["source_metadata"]["abis"]}
        projected = {key: row for key, row in all_rows.items() if key[2] in source_bits}
        assert projected == source_rows, "per-ABI reference disagreement"
        reference = {"sha256": sha(args.reference_catalog), "rows": len(source_rows)}
    receipt = {"passed": not differences, "catalog_sha256": sha(data_path), "manifest_sha256": sha(manifest_path),
               "reader_sha256": sha(reader), "reference": reference, "commands": commands,
               "per_abi": per_abi, "rows": len(derived), "differences": differences}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(receipt, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    for abi, values in per_abi.items():
        print(f"{abi}: {values['symbol_library_pairs']} rows {values['kinds']}")
    print(f"{'PASS' if not differences else 'FAIL'}: {len(derived)} exact library/ABI records, API + type + GNU version; {len(commands)} llvm-readelf invocations")
    for difference in differences[:12]:
        print(difference)
    return int(bool(differences))


if __name__ == "__main__":
    raise SystemExit(main())

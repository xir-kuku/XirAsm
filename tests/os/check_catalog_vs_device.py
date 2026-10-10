#!/usr/bin/env python3
"""Compare the catalog against the libraries a real device actually exports.

The catalog is built from the NDK's stub libraries. A stub is a link-time view, and
at least one stub exposes internals the platform library does not export at run
time (libz's `_dist_code` is one), which turns into a failed load on a device.

This checker takes the device's own libraries -- copied out of the emulator -- and
compares their exported dynamic symbols against what the catalog claims, so the
stub-only entries are named instead of discovered one crash at a time.

usage:
  python check_catalog_vs_device.py --catalog <include/os/android> --device-libs <dir> --llvm-nm <path>
"""
from __future__ import annotations

import argparse
import subprocess
import tomllib
from collections import defaultdict
from pathlib import Path


def exported_symbols(llvm_nm: Path, library: Path) -> set[str]:
    result = subprocess.run(
        [str(llvm_nm), "-D", "--defined-only", "--format=posix", str(library)],
        capture_output=True, text=True, errors="replace",
    )
    names: set[str] = set()
    for line in result.stdout.splitlines():
        fields = line.split()
        if len(fields) >= 2 and fields[1] in {"T", "W", "i", "I", "B", "D", "R", "V"}:
            name = fields[0].split("@@")[0].split("@")[0]
            names.add(name)
    return names


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--catalog", type=Path, required=True)
    parser.add_argument("--device-libs", type=Path, required=True)
    parser.add_argument("--llvm-nm", type=Path, required=True)
    parser.add_argument("--show", type=int, default=12)
    parser.add_argument("--abi", choices=("aarch64", "arm", "i686", "riscv64", "x86_64"),
                        default="aarch64",
                        help="ABI of the copied device libraries, so arm-only symbols are not "
                             "counted against an arm64 library")
    args = parser.parse_args()

    with (args.catalog / "catalog" / "symbols.toml").open("rb") as stream:
        data = tomllib.load(stream)
    bit = 1 << ("aarch64", "arm", "i686", "riscv64", "x86_64").index(args.abi)

    claimed: dict[str, set[str]] = defaultdict(set)
    versioned: dict[tuple[str, str], bool] = {}
    for symbol, row in data["symbols"].items():
        abi_key = ("a64", "arm", "x86", "riscv64", "x64")[bit.bit_length() - 1]
        for providers in row["providers"].values():
            library = providers["library"]
            if abi_key not in providers:
                continue
            claimed[library].add(symbol)
            versioned[(library, symbol)] = bool(providers[abi_key]["ver"])

    total_claimed = total_missing = 0
    for library in sorted(claimed):
        path = args.device_libs / library
        if not path.is_file():
            print(f"{library}: not copied from the device, skipped")
            continue
        actual = exported_symbols(args.llvm_nm, path)
        missing = sorted(claimed[library] - actual)
        extra = actual - claimed[library]
        total_claimed += len(claimed[library])
        total_missing += len(missing)
        flag = "OK " if not missing else "GAP"
        print(f"{flag} {library:22} catalog={len(claimed[library]):5} device={len(actual):5} "
              f"stub-only={len(missing):4} device-only={len(extra):5}")
        for symbol in missing[:args.show]:
            tagged = "versioned" if versioned[(library, symbol)] else "no version tag"
            print(f"      missing on device: {symbol} ({tagged})")
    if total_claimed:
        print(f"\ntotal: {total_missing} of {total_claimed} catalogued symbols are not exported "
              f"by the device libraries ({100.0 * total_missing / total_claimed:.2f}%)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

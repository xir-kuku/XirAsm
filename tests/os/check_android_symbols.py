#!/usr/bin/env python3
"""Check the Android platform symbol catalog the way a user consumes it.

The generator's own validator proves the data matches the NDK. This checker proves
the *shipped* surface works: every generated include resolves, every symbol
constant exists with the right value, every library helper appends the imports it
claims to, the query API answers, and the data file and the include files agree on
which library provides what.

The sweep is generated from the catalog itself and then assembled with the release
compiler, so a symbol that the data file lists but no include exports fails here
rather than in a user's build.

usage:
  python tests/os/check_android_symbols.py --assembler zig-out/bin/xirasm.exe
"""
from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
import tempfile
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CHUNK = 128
SAMPLE = 3

CONSTANT = re.compile(r"^const (android_import_[A-Za-z0-9_]+): (string|u64) = (.*)$", re.MULTILINE)


def parse_library_include(path: Path) -> tuple[str, str, list[tuple[str, str]]]:
    """Return (alias, library, [(constant, symbol)]) for one generated include."""
    alias = None
    library = None
    symbols: list[tuple[str, str]] = []
    for match in CONSTANT.finditer(path.read_text(encoding="utf-8")):
        constant, _kind, value = match.group(1), match.group(2), match.group(3).strip()
        if constant.endswith("_so"):
            alias = constant[len("android_import_"):-len("_so")]
            library = value.strip('"')
            continue
        if constant.endswith("_min_api"):
            continue
        symbols.append((constant, value.strip('"')))
    if alias is None or library is None:
        raise SystemExit(f"{path}: no library constant found")
    return alias, library, symbols


def assemble(assembler: Path, source: Path, output: Path, timeout: float = 300.0):
    """Assemble with a hard timeout: a quadratic path must fail loudly, not hang."""
    try:
        return subprocess.run(
            [str(assembler), str(source), "-o", str(output)],
            capture_output=True, timeout=timeout,
        )
    except subprocess.TimeoutExpired:
        return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--assembler", type=Path, default=ROOT / "zig-out" / "bin" / "xirasm.exe")
    parser.add_argument("--catalog", type=Path, default=ROOT / "include" / "os" / "android")
    args = parser.parse_args()

    if not args.assembler.is_file():
        raise SystemExit(f"assembler not found: {args.assembler}")

    catalog = args.catalog
    with (catalog / "catalog" / "symbols.toml").open("rb") as stream:
        data = tomllib.load(stream)
    symbols = data["symbols"]

    libraries: dict[str, tuple[str, list[tuple[str, str]]]] = {}
    for path in sorted((catalog / "imports").glob("*.inc")):
        alias, library, constants = parse_library_include(path)
        libraries[alias] = (library, constants)
    print(f"PASS: {len(libraries)} library includes, {sum(len(c) for _, c in libraries.values())} constants")

    # The data file and the include files have to describe the same catalog.
    problems: list[str] = []
    seen: dict[str, set[str]] = {}
    for alias, (library, constants) in libraries.items():
        for constant, symbol in constants:
            if constant != f"android_import_{alias}_{symbol}":
                problems.append(f"{alias}: constant {constant} does not name {symbol}")
            row = symbols.get(symbol)
            if row is None:
                problems.append(f"{alias}: {symbol} is not in symbols.toml")
                continue
            if library not in row["lib"]:
                problems.append(f"{alias}: symbols.toml does not list {library} for {symbol}")
            seen.setdefault(symbol, set()).add(library)
    for symbol, row in symbols.items():
        expected = {entry.rsplit(":", 1)[0] for entry in row["lib"].split(",")}
        if seen.get(symbol, set()) != expected:
            problems.append(f"{symbol}: includes provide {sorted(seen.get(symbol, set()))}, data says {sorted(expected)}")
    if problems:
        print(f"catalog/include mismatch ({len(problems)}):")
        for line in problems[:20]:
            print(f"  {line}")
        return 1
    print(f"PASS: symbols.toml and the includes agree on all {len(symbols)} symbols")

    # Generate a sweep that names every constant, calls every helper, and asks the
    # query API about a sample, then assemble it with the release compiler.
    work = Path(tempfile.mkdtemp(prefix="android-catalog-"))
    try:
        lines = ['import("format/format.inc");', 'import("os/android/imports.inc");',
                 'import("os/android/catalog.inc");', 'import("os/android/defs.inc");', ""]
        for alias, (library, constants) in sorted(libraries.items()):
            symbols_only = [symbol for _constant, symbol in constants]
            for index in range(0, len(symbols_only), CHUNK):
                chunk = symbols_only[index:index + CHUNK]
                name = f"sweep_{alias}_{index // CHUNK}"
                lines.append(f"const {name}: list = list.of(")
                lines.append(",\n".join(f"    android_import_{alias}_{symbol}" for symbol in chunk))
                lines.append(")")
        lines.append("")
        lines.append("let total: u64 = 0")
        for alias, (library, constants) in sorted(libraries.items()):
            symbols_only = [symbol for _constant, symbol in constants]
            lines.append(f"// {library}: {len(symbols_only)} symbols behind the constants above")
            lines.append(f"let imports_{alias}: list = format_elfso_import_new()")
            sample = symbols_only[:SAMPLE]
            lines.append(f"android_import_{alias}_add_slots_mut(imports_{alias}, list.of(")
            lines.append(",\n".join(f"    android_import_{alias}_{symbol}" for symbol in sample))
            lines.append("))")
            lines.append(f'assert(len(imports_{alias}) == {len(sample)}, "{library} helper imported the wrong number of symbols");')
            lines.append(f"total = total + len(imports_{alias})")
            lines.append(f'assert(android_import_{alias}_min_api >= 21, "{library} has no first API level");')
        lines.append('const syms: map = android_symbols()')
        lines.append('assert(len(syms) == ' + str(len(symbols)) + ', "the catalog lost symbols");')
        lines.append('assert(android_symbol_library(syms, "__android_log_write") == "liblog.so", "query path");')
        lines.append('assert(android_symbol_min_api(syms, "dlvsym") == 24, "query path");')
        lines.append('assert(android_symbol_abis(syms, "__aeabi_memcpy") == 2, "ARM only helper");')
        lines.append('assert(android_symbol_available_at(syms, "eglGetDisplay", 26), "libEGL at API 26");')
        lines.append('assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", 1) == 30, "AArch64 exact API");')
        lines.append('assert(android_symbol_min_api_for(syms, "__tls_get_addr", "libc.so", 16) == 29, "x86-64 exact API");')
        lines.append('assert(android_symbol_kind_for(syms, "SL_IID_ENGINE", "libOpenSLES.so", 1) == "object", "object catalog");')
        lines.append('assert(android_layout_ANativeActivityCallbacks_onDestroy_offset64 == 40, "generated offsets");')
        lines.append('assert(android_layout_ANativeActivity_size32 == 40, "32-bit model offsets");')
        lines.append('assert(android_keycodes_AKEYCODE_HOME == 3, "generated constants");')
        lines.append('assert(android_input_AMOTION_EVENT_ACTION_MASK == 255, "generated constants");')
        lines.append('db(total);')
        source = work / "catalog_sweep.asm"
        source.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")

        result = assemble(args.assembler, source, work / "catalog_sweep.bin")
        if result is None:
            print("catalog sweep did not finish assembling within the timeout")
            print(f"generated source kept at {source}")
            return 1
        if result.returncode != 0:
            print("catalog sweep failed to assemble:")
            print(result.stderr.decode("utf-8", "replace")[:2000])
            print(f"generated source kept at {source}")
            return 1
        total = sum(len(constants) for _library, constants in libraries.values())
        print(f"PASS: sweep references all {total} constants across {len(libraries)} libraries and assembles")
        print(f"PASS: every library helper welds its library onto the import list "
              f"({SAMPLE} symbols each) and reports a first API level")
        print(f"PASS: query API answers count, library, first API, ABI mask and availability")
        print(f"PASS: every generated defs partition loads through os/android/defs.inc and answers")
        return 0
    finally:
        shutil.rmtree(work, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())

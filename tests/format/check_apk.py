"""Assemble the APK facade fixture and verify the archive with independent tools.

Structural checks run with nothing but the Python standard library: ZIP
integrity and alignment, the AXML chunk walk (including the positional resource
map), and the resources.arsc chunk walk. When the Android SDK build tools are
available, aapt2 and zipalign are used as the independent judges instead of our
own readers.

usage:
  python tests/format/check_apk.py --assembler zig-out/bin/xirasm.exe
  python tests/format/check_apk.py --assembler zig-out/bin/xirasm.exe \
      --sdk-bin "%LOCALAPPDATA%/Android/Sdk/build-tools/36.0.0"
"""

import argparse
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess
import zipfile


ROOT = Path(__file__).resolve().parents[2]
FIXTURES = ROOT / 'tests' / 'format'

RES_STRING_POOL = 0x0001
RES_TABLE = 0x0002
RES_XML = 0x0003
RES_XML_RESOURCE_MAP = 0x0180
RES_TABLE_PACKAGE = 0x0200
RES_TABLE_TYPE = 0x0201
RES_TABLE_TYPE_SPEC = 0x0202

ATTR_ICON = 0x01010002


def run(*args, cwd=ROOT):
    result = subprocess.run([str(arg) for arg in args], cwd=cwd, capture_output=True,
                            text=True, encoding="utf-8", errors="replace", timeout=300)
    assert result.returncode == 0, (args, result.stdout + result.stderr)
    return result.stdout + result.stderr


def tool(sdk_bin, name):
    suffix = ".exe" if os.name == "nt" else ""
    path = sdk_bin / (name + suffix) if sdk_bin else shutil.which(name)
    return path if path and Path(path).is_file() else None


def read_pool(data, base):
    count = struct.unpack_from("<I", data, base + 8)[0]
    flags = struct.unpack_from("<I", data, base + 16)[0]
    strings_start = struct.unpack_from("<I", data, base + 20)[0]
    size = struct.unpack_from("<I", data, base + 4)[0]
    out = []
    for index in range(count):
        offset = struct.unpack_from("<I", data, base + 28 + 4 * index)[0]
        cursor = base + strings_start + offset
        if flags & 0x100:
            first = data[cursor]
            cursor += 2 if first & 0x80 else 1
            second = data[cursor]
            if second & 0x80:
                length = ((second & 0x7F) << 8) | data[cursor + 1]
                cursor += 2
            else:
                length = second
                cursor += 1
            out.append(data[cursor:cursor + length].decode("utf-8", "replace"))
        else:
            length = struct.unpack_from("<H", data, cursor)[0]
            cursor += 2
            out.append(data[cursor:cursor + 2 * length].decode("utf-16-le", "replace"))
    return out, size


def walk(data, base, end):
    """Yield (type, offset, header_size, size) for one chunk level."""
    cursor = base
    while cursor + 8 <= end:
        ctype, header_size, size = struct.unpack_from("<HHI", data, cursor)
        assert size >= 8 and cursor + size <= end, ("chunk overruns its parent", cursor, ctype)
        yield ctype, cursor, header_size, size
        cursor += size
    assert cursor == end, ("chunks do not cover the parent exactly", cursor, end)


def check_manifest(data):
    ctype, header_size, size = struct.unpack_from("<HHI", data, 0)
    assert ctype == RES_XML and size == len(data), ("not a complete AXML document", hex(ctype))
    pool, resmap = [], []
    for chunk, offset, _, chunk_size in walk(data, header_size, len(data)):
        if chunk == RES_STRING_POOL:
            pool, _ = read_pool(data, offset)
        elif chunk == RES_XML_RESOURCE_MAP:
            rows = (chunk_size - 8) // 4
            resmap = [struct.unpack_from("<I", data, offset + 8 + 4 * i)[0] for i in range(rows)]
    assert pool and resmap, "manifest is missing its string pool or resource map"
    assert "icon" in pool, "manifest pool lost the icon attribute name"
    icon_index = pool.index("icon")
    assert icon_index < len(resmap), "resource map does not cover the icon attribute"
    assert resmap[icon_index] == ATTR_ICON, (
        f"icon attribute carries {resmap[icon_index]:#010x} instead of {ATTR_ICON:#010x}")
    # Every row up to the last attribute name must exist, because the map is
    # positional rather than a list of registered attributes.
    last_attr = max(i for i, value in enumerate(resmap) if value)
    assert resmap[last_attr] != 0 and last_attr == len(resmap) - 1
    return pool, resmap


def check_table(data):
    ctype, header_size, size = struct.unpack_from("<HHI", data, 0)
    assert ctype == RES_TABLE and size == len(data), ("not a complete resources.arsc", hex(ctype))
    assert struct.unpack_from("<I", data, 8)[0] == 1, "expected a single package"
    packages = 0
    types = {}
    specs = []
    for chunk, offset, _, chunk_size in walk(data, header_size, len(data)):
        if chunk != RES_TABLE_PACKAGE:
            assert chunk == RES_STRING_POOL, f"unexpected top-level chunk {chunk:#06x}"
            continue
        packages += 1
        header = struct.unpack_from("<H", data, offset + 2)[0]
        for inner, inner_offset, _, inner_size in walk(data, offset + header, offset + chunk_size):
            if inner == RES_TABLE_TYPE:
                type_id = data[inner_offset + 8]
                config_size = struct.unpack_from("<I", data, inner_offset + 20)[0]
                assert config_size == 64, "configuration record is not 64 bytes"
                assert struct.unpack_from("<H", data, inner_offset + 2)[0] == 20 + config_size, (
                    "type chunk header must include its configuration record")
                types.setdefault(type_id, []).append(inner_offset)
            elif inner == RES_TABLE_TYPE_SPEC:
                specs.append(inner_offset)
            else:
                assert inner == RES_STRING_POOL, f"unexpected package chunk {inner:#06x}"
    assert packages == 1, "expected exactly one package chunk"
    assert types, "resource table has no type chunks"
    assert specs, "resource table has no type specs"
    for offset in specs:
        type_id = data[offset + 8]
        entry_count = struct.unpack_from("<I", data, offset + 12)[0]
        assert struct.unpack_from("<I", data, offset + 4)[0] == 16 + 4 * entry_count, (
            "type spec size does not match its entries")
        assert struct.unpack_from("<H", data, offset + 10)[0] == len(types.get(type_id, [])), (
            "type spec does not count its configuration chunks")
    return types


def check_archive(apk):
    with zipfile.ZipFile(apk) as archive:
        assert archive.testzip() is None, "a stored entry fails its CRC-32"
        data = apk.read_bytes()
        names = archive.namelist()
        for name in ("AndroidManifest.xml", "resources.arsc", "classes.dex"):
            assert name in names, f"archive is missing {name}"
        for info in archive.infolist():
            assert info.compress_type == zipfile.ZIP_STORED, f"{info.filename} is not stored"
            name_len, extra_len = struct.unpack_from("<HH", data, info.header_offset + 26)
            data_offset = info.header_offset + 30 + name_len + extra_len
            assert data_offset % 4 == 0, f"{info.filename} data is not 4-byte aligned"
        assert struct.unpack_from("<I", data, len(data) - 22)[0] == 0x06054B50, "missing EOCD record"
        manifest = archive.read("AndroidManifest.xml")
        table = archive.read("resources.arsc")
        icons = [n for n in names if n.startswith("res/mipmap-")]
        assert len(icons) == 2, f"expected two density icons, found {icons}"
    return manifest, table, names


def platform_encode(text: str) -> bytes:
    """Encode text the way the resource pool stores it.

    The pool is a UTF-16 table written out one code unit at a time: ASCII stays
    one byte, everything else becomes a two or three byte sequence. A code point
    above U+FFFF is two code units, so it becomes two three byte sequences
    rather than one four byte sequence.
    """
    units = text.encode("utf-16-le")
    out = bytearray()
    for index in range(0, len(units), 2):
        unit = units[index] | (units[index + 1] << 8)
        if unit < 0x80:
            out.append(unit)
        elif unit < 0x800:
            out += bytes([0xC0 | (unit >> 6), 0x80 | (unit & 0x3F)])
        else:
            out += bytes([0xE0 | (unit >> 12), 0x80 | ((unit >> 6) & 0x3F), 0x80 | (unit & 0x3F)])
    return bytes(out)


def check_non_ascii(assembler, work, aapt2):
    """A non-ASCII application label must survive into the archive unchanged.

    The expected text is read from the fixture's data file instead of being
    repeated here, and it is compared in the pool's own encoding.
    """
    apk = work / "zh.apk"
    run(assembler, FIXTURES / "apk_zh_demo.xir", "-o", apk)
    data = read_data_file()
    with zipfile.ZipFile(apk) as archive:
        table = archive.read("resources.arsc")
        manifest = archive.read("AndroidManifest.xml")
    for value in data:
        encoded = platform_encode(value)
        assert encoded in table, f"resource table lost {value!r}"
        # The manifest holds a resource reference for the label, so the text
        # itself must not appear there.
        assert encoded not in manifest, f"manifest should reference {value!r}, not embed it"
        if any(ord(ch) > 0xFFFF for ch in value):
            assert value.encode("utf-8") not in table, (
                "supplementary characters must use the surrogate encoding")
    print(f"PASS: {len(data)} non-ASCII values reach the table unchanged and stay references")
    if not aapt2:
        return
    output = run(aapt2, "dump", "badging", apk)
    assert f"application-label:'{data[0]}'" in output, output
    resources = run(aapt2, "dump", "resources", apk)
    assert f'"{data[0]}"' in resources, resources
    print("PASS: aapt2 resolves the non-ASCII label from our resource table")


def read_data_file():
    """The fixture's non-ASCII values, one per `|` separated field."""
    text = (FIXTURES / "apk_zh_strings.txt").read_text(encoding="utf-8")
    return [field.strip() for field in text.split("|")]


def read_res_scan_strings():
    """The resource-scan fixture's own string tables, keyed by locale and name.

    The expected text stays in the fixture's data files instead of being
    repeated here, so a change to the tree cannot silently pass this check.
    """
    values = {}
    for locale, directory in (("", "values"), ("zh", "values-zh")):
        text = (FIXTURES / "apk_res" / directory / "strings.toml").read_text(encoding="utf-8")
        for line in text.splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            key, separator, value = line.partition("=")
            assert separator, f"unexpected line in a fixture TOML table: {line!r}"
            values[(locale, key.strip())] = value.strip().strip('"')
    assert values, "the resource-scan fixture has no string tables"
    return values


def check_res_scan(assembler, work, aapt2, zipalign):
    """A resource tree must reach the archive as resources, entries and all.

    The fixture scans `tests/format/apk_res`; the names, configurations and
    archive paths checked here are the ones aapt2 reads back, not the ones our
    own writer recorded.
    """
    apk = work / "res-scan.apk"
    if apk.exists():
        apk.unlink()
    run(assembler, FIXTURES / "apk_res_scan_user_facade.asm", "-o", apk)

    manifest, table, names = check_archive(apk)
    resources = {
        "res/mipmap-mdpi/ic_launcher.png",
        "res/mipmap-hdpi/ic_launcher.png",
        "res/drawable/logo.png",
        "res/raw/notice.txt",
    }
    missing = resources - set(names)
    assert not missing, f"scanned resources are missing from the archive: {sorted(missing)}"
    assert len(names) == len(resources) + 4, f"archive holds unexpected entries: {names}"
    assert 'lib/x86_64/libmain.so' in names

    values = read_res_scan_strings()
    for locale in ("", "zh"):
        for key in ("app_name", "tagline"):
            encoded = platform_encode(values[(locale, key)])
            assert encoded in table, f"resource table lost {values[(locale, key)]!r}"
    for path in resources:
        assert platform_encode(path) in table, f"resource table lost the value {path!r}"
    assert platform_encode("values-zh") not in table, "the tree's own directories became resources"

    pool, _ = read_pool(table, 12)
    assert "res/drawable/logo.png" in pool, pool
    assert "app_name" not in pool, "resource names belong in the package key pool, not the value pool"
    print(f"PASS: scanned tree reaches {len(resources)} archive entries and both locales")

    if not aapt2 or not zipalign:
        return
    output = run(aapt2, "dump", "badging", apk)
    for expected in ("package: name='com.example.xirasm.resdir'",
                     f"application-label:'{values[('', 'app_name')]}'",
                     f"application-label-zh:'{values[('zh', 'app_name')]}'",
                     "application-icon-160:'res/mipmap-mdpi/ic_launcher.png'",
                     "application-icon-240:'res/mipmap-hdpi/ic_launcher.png'"):
        assert expected in output, (expected, output)
    print("PASS: aapt2 resolves the scanned label, its locale variant and both icons")

    dump = run(aapt2, "dump", "resources", apk)
    for expected in ("type drawable id=01", "resource 0x7f010000 drawable/logo",
                     "(file) res/drawable/logo.png type=PNG",
                     "type mipmap id=02", "resource 0x7f020000 mipmap/ic_launcher",
                     "(mdpi) (file) res/mipmap-mdpi/ic_launcher.png type=PNG",
                     "(hdpi) (file) res/mipmap-hdpi/ic_launcher.png type=PNG",
                     "type raw id=03", "resource 0x7f030000 raw/notice",
                     "(file) res/raw/notice.txt",
                     "type string id=04", "resource 0x7f040000 string/app_name",
                     f'"{values[("", "tagline")]}"'):
        assert expected in dump, (expected, dump)
    assert f'(zh) "{values[("zh", "app_name")]}"' in dump, dump
    print("PASS: aapt2 reads every scanned resource, density and locale back")

    run(zipalign, "-c", "-v", "4", apk)
    print("PASS: zipalign -c 4 accepts the scanned archive")


def check_gl_demo(assembler, work, aapt2, zipalign):
    """The renderer example: a library and an APK, both written by the assembler.

    The example's two sources resolve their inputs relative to themselves, so the
    check assembles a copy of the example directory under the work directory,
    which is also how a reader would build it: library first, then the archive
    that packages it.
    """
    example = FIXTURES / "android_gl_demo"
    stage = work / "gl-demo"
    shutil.copytree(example, stage, dirs_exist_ok=True)

    library = stage / "libmain.so"
    run(assembler, stage / "gl-demo-so.asm", "-o", library)
    apk = stage / "demo-unsigned.apk"
    run(assembler, stage / "gl-demo-apk.asm", "-o", apk)

    with zipfile.ZipFile(apk) as archive:
        names = set(archive.namelist())
        assert "classes.dex" not in names, "the example declares hasCode=false and needs no DEX"
        assert "lib/x86_64/libmain.so" in names, names
        assert {name for name in names if name.startswith("res/mipmap-")} == {
            f"res/mipmap-{density}/ic_launcher.png"
            for density in ("mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi")
        }, names
        manifest = archive.read("AndroidManifest.xml")
        table = archive.read("resources.arsc")
    # The manifest pool is UTF-16, and it carries the library's base name in the
    # lib_name meta-data rather than the file name.
    assert "android.app.lib_name".encode("utf-16-le") in manifest, "the manifest does not name the library"
    for expected in (b"XIRASM", platform_encode("图形演示")):
        assert expected in table, f"the label table lost {expected!r}"
    print(f"PASS: renderer example builds as a {apk.stat().st_size} byte archive "
          f"around a {library.stat().st_size} byte library")

    if not aapt2 or not zipalign:
        return
    output = run(aapt2, "dump", "badging", apk)
    for expected in ("package: name='com.example.xirasm.gldemo'",
                     "native-code: 'x86_64'",
                     "launchable-activity: name='android.app.NativeActivity'",
                     "application-icon-160:'res/mipmap-mdpi/ic_launcher.png'"):
        assert expected in output, (expected, output)
    assert "application-label:" in output, output
    run(zipalign, "-c", "-v", "-P", "16", "4", apk)
    print("PASS: aapt2 reads the example's label, icons and native code, and zipalign accepts it")


def elf_load_alignments(data: bytes) -> list[int]:
    """Return the p_align of every PT_LOAD, straight from the program headers."""
    assert data[:4] == b"\x7fELF", "not an ELF image"
    assert data[4] == 2, "expected a 64-bit ELF image"
    e_phoff, = struct.unpack_from("<Q", data, 0x20)
    e_phentsize, e_phnum = struct.unpack_from("<HH", data, 0x36)
    alignments = []
    for index in range(e_phnum):
        offset = e_phoff + index * e_phentsize
        p_type, = struct.unpack_from("<I", data, offset)
        if p_type == 1:  # PT_LOAD
            p_align, = struct.unpack_from("<Q", data, offset + 48)
            alignments.append(p_align)
    return alignments


def check_gl_demo_aarch64(assembler, work, aapt2, zipalign):
    """The same renderer in AArch64 instructions, packaged for arm64 devices.

    This is the build a phone actually runs, so it gets its own checks: the archive
    has to carry the library under lib/arm64-v8a, the library has to be an AArch64
    shared object that names the three platform libraries it imports, and its LOAD
    segments have to be aligned for the 16 KiB page size Android 15 introduced.
    """
    example = FIXTURES / "android_gl_demo"
    stage = work / "gl-demo-aarch64"
    shutil.copytree(example, stage, dirs_exist_ok=True)

    library = stage / "libmain.so"
    run(assembler, stage / "gl-demo-so-aarch64.asm", "-o", library)
    apk = stage / "demo64-unsigned.apk"
    run(assembler, stage / "gl-demo-apk-aarch64.asm", "-o", apk)

    image = library.read_bytes()
    machine, = struct.unpack_from("<H", image, 18)
    assert machine == 0xB7, f"the library does not declare AArch64 (machine {machine:#x})"
    for expected in (b"libandroid.so", b"libEGL.so", b"libGLESv2.so", b"libmain.so",
                     b"ANativeActivity_onCreate"):
        assert expected in image, f"the AArch64 library lost {expected!r}"
    alignments = elf_load_alignments(image)
    assert alignments, "the library has no LOAD segments"
    assert all(align == 16384 for align in alignments), alignments

    with zipfile.ZipFile(apk) as archive:
        names = set(archive.namelist())
        assert "classes.dex" not in names, "the example declares hasCode=false and needs no DEX"
        assert "lib/arm64-v8a/libmain.so" in names, names
    print(f"PASS: AArch64 renderer builds as a {apk.stat().st_size} byte archive around a "
          f"{library.stat().st_size} byte library, LOAD aligned to {alignments[0]}")

    if not aapt2 or not zipalign:
        return
    output = run(aapt2, "dump", "badging", apk)
    for expected in ("package: name='com.example.xirasm.gldemo'",
                     "native-code: 'arm64-v8a'",
                     "launchable-activity: name='android.app.NativeActivity'"):
        assert expected in output, (expected, output)
    run(zipalign, "-c", "-v", "-P", "16", "4", apk)
    print("PASS: aapt2 reads the AArch64 archive's ABI and zipalign accepts it")


def check_gl_demo_universal(assembler, work, aapt2, zipalign):
    """Both renderers in one archive, which is the build a release has to ship.

    A package with a single ABI only installs where that ABI is native, so the
    universal archive has to carry both libraries under their own ABI directory,
    each with the machine type, page alignment and entry point its own build has.
    """
    example = FIXTURES / "android_gl_demo"
    stage = work / "gl-demo-universal"
    shutil.copytree(example, stage, dirs_exist_ok=True)

    x86_library = stage / "libmain-x86_64.so"
    arm_library = stage / "libmain-aarch64.so"
    run(assembler, stage / "gl-demo-so.asm", "-o", x86_library)
    run(assembler, stage / "gl-demo-so-aarch64.asm", "-o", arm_library)
    apk = stage / "demo-universal-unsigned.apk"
    run(assembler, stage / "gl-demo-apk-universal.asm", "-o", apk)

    with zipfile.ZipFile(apk) as archive:
        names = set(archive.namelist())
        assert "classes.dex" not in names, "the example declares hasCode=false and needs no DEX"
        entries = {"lib/x86_64/libmain.so": (x86_library, 0x3E),
                   "lib/arm64-v8a/libmain.so": (arm_library, 0xB7)}
        for name, (library, expected_machine) in entries.items():
            assert name in names, names
            stored = archive.read(name)
            assert stored == library.read_bytes(), f"{name} is not the assembled library"
            machine, = struct.unpack_from("<H", stored, 18)
            assert machine == expected_machine, f"{name} declares machine {machine:#x}"
            for expected in (b"libmain.so", b"ANativeActivity_onCreate"):
                assert expected in stored, f"{name} lost {expected!r}"
        alignments = elf_load_alignments(archive.read("lib/arm64-v8a/libmain.so"))
    assert alignments and all(align == 16384 for align in alignments), alignments
    print(f"PASS: universal archive carries x86_64 and arm64-v8a renderers in "
          f"{apk.stat().st_size} bytes, AArch64 LOAD aligned to {alignments[0]}")

    if not aapt2 or not zipalign:
        return
    output = run(aapt2, "dump", "badging", apk)
    native = [line for line in output.splitlines() if line.startswith("native-code:")]
    assert native, output
    for expected in ("x86_64", "arm64-v8a"):
        assert expected in native[0], (expected, native)
    run(zipalign, "-c", "-v", "-P", "16", "4", apk)
    print("PASS: aapt2 reads both ABIs from the universal archive and zipalign accepts it")


def read_deflate_notes() -> bytes:
    """The compressed fixture's inline payload, spelled the way the fixture has it."""
    return b"XIRASM " * 11 + b"XIRASM"


def check_deflate(assembler, work, aapt2, zipalign):
    """Compressed entries have to survive an independent decompressor.

    Python's zipfile decodes every DEFLATE stream and checks the CRC-32 each
    entry records, so a fixture that passes here really is an archive a reader
    can open. The entries Android requires to stay uncompressed are checked to
    still be stored.
    """
    apk = work / "deflate.apk"
    if apk.exists():
        apk.unlink()
    run(assembler, FIXTURES / "apk_deflate_user_facade.asm", "-o", apk)

    text_file = (FIXTURES / "apk_zh_strings.txt").read_bytes()
    with zipfile.ZipFile(apk) as archive:
        assert archive.testzip() is None, "a deflated entry failed its CRC-32"
        methods = {info.filename: info.compress_type for info in archive.infolist()}
        for name in ("assets/notes.txt", "assets/strings.txt"):
            assert methods.get(name) == zipfile.ZIP_DEFLATED, (name, methods)
        for name in ("resources.arsc", "res/mipmap-mdpi-v4/ic_launcher.png",
                     "AndroidManifest.xml", "assets/stored.txt"):
            assert methods.get(name) == zipfile.ZIP_STORED, (name, methods)
        assert archive.read("assets/notes.txt") == read_deflate_notes()
        assert archive.read("assets/strings.txt") == text_file
        assert archive.read("assets/stored.txt") == text_file
        sizes = {info.filename: (info.compress_size, info.file_size) for info in archive.infolist()}
        compressed, plain = sizes["assets/notes.txt"]
        assert compressed < plain, sizes["assets/notes.txt"]
        print(f"PASS: {len(methods)} entries decode, two of them deflated "
              f"({compressed} of {plain} bytes for the notes)")

    if not aapt2 or not zipalign:
        return
    output = run(aapt2, "dump", "badging", apk)
    for expected in ("package: name='com.example.xirasm.deflate'",
                     "application-label:'XIRASM Deflate'"):
        assert expected in output, (expected, output)
    run(zipalign, "-c", "-v", "4", apk)
    run(zipalign, "-c", "-v", "-P", "16", "4", apk)
    print("PASS: aapt2 reads the deflated archive and zipalign accepts it")


def check_framework_ids(assembler, work, aapt2, zipalign):
    """The framework catalog has to carry the platform's own IDs.

    The fixture asserts a handful of them against the values the platform jar
    reports, and aapt2 reads the written manifest back, so the theme attribute is
    the ID the platform assigns to `android:style/Theme.DeviceDefault`.
    """
    apk = work / "framework.apk"
    if apk.exists():
        apk.unlink()
    run(assembler, FIXTURES / "android_framework_ids_user_facade.asm", "-o", apk)

    with zipfile.ZipFile(apk) as archive:
        names = archive.namelist()
        assert "AndroidManifest.xml" in names and "resources.arsc" in names, names
    print(f"PASS: framework catalog builds a {apk.stat().st_size} byte archive")

    if not aapt2 or not zipalign:
        return
    tree = run(aapt2, "dump", "xmltree", apk, "--file", "AndroidManifest.xml")
    for expected in ("theme(0x01010000)=@0x01030128", "label(0x01010001)"):
        assert expected in tree, (expected, tree)
    output = run(aapt2, "dump", "badging", apk)
    assert "application-label:'XIRASM Framework'" in output, output
    run(zipalign, "-c", "-v", "4", apk)
    print("PASS: aapt2 reads the framework theme ID and the label back")


def main():
    global FIXTURES
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--assembler", required=True, type=Path)
    parser.add_argument("--sdk-bin", type=Path)
    parser.add_argument("--include-dir", type=Path, default=ROOT / "include" / "format")
    parser.add_argument("--work-dir", type=Path,
                        help="where to assemble the fixture (default: zig-out/apk-check)")
    args = parser.parse_args()
    assembler = args.assembler.resolve()

    aapt2 = tool(args.sdk_bin, "aapt2")
    zipalign = tool(args.sdk_bin, "zipalign")

    work = (args.work_dir or (ROOT / "zig-out" / "apk-check")).resolve()
    work.mkdir(parents=True, exist_ok=True)
    FIXTURES = work / 'fixtures'
    FIXTURES.mkdir(parents=True, exist_ok=True)
    source_fixtures = ROOT / 'tests' / 'format'
    for name in ('apk_native_fixture.asm', 'apk_native_user_facade.asm', 'apk_zh_demo.xir',
                 'apk_zh_strings.txt', 'apk_res_scan_user_facade.asm', 'apk_deflate_user_facade.asm',
                 'android_framework_ids_user_facade.asm'):
        shutil.copy2(source_fixtures / name, FIXTURES / name)
    for name in ('apk_res', 'android_gl_demo'):
        shutil.copytree(source_fixtures / name, FIXTURES / name, dirs_exist_ok=True)

    import_pattern = r'(?m)^[ \t]*import\("([^\"]+)"\);?'
    staged_catalogs = {}
    catalog_dir = work / 'native-imports'
    catalog_dir.mkdir(parents=True, exist_ok=True)

    def import_path(match):
        logical = match.group(1).removeprefix('../../include/')
        if logical.startswith('format/'):
            path = args.include_dir.resolve() / logical.removeprefix('format/')
            if not path.exists():
                path = ROOT / 'include' / logical
        elif logical.startswith('os/android/'):
            source = ROOT / 'include' / logical
            assert source.is_file(), source
            path = catalog_dir / logical.removeprefix('os/android/')
            if logical not in staged_catalogs:
                staged_catalogs[logical] = path
                text = source.read_text(encoding='utf-8')
                # Shared Android helpers also import the format layer. Keep
                # every indirect import on the fixture's include snapshot.
                text = re.sub(import_pattern, import_path, text)
                assert 'import("format/' not in text, source
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(text, encoding='utf-8')
        else:
            path = ROOT / 'include' / logical
        assert path.is_file(), path
        return f'import("{path.as_posix()}");'

    for source in [*FIXTURES.rglob('*.asm'), *FIXTURES.rglob('*.xir')]:
        text = source.read_text(encoding='utf-8')
        source.write_text(re.sub(import_pattern, import_path, text), encoding='utf-8')
    run(assembler, FIXTURES / 'apk_native_fixture.asm', '-o', FIXTURES / 'apk-native-fixture.so')
    apk = work / "facade.apk"
    if apk.exists():
        apk.unlink()

    run(assembler, FIXTURES / "apk_native_user_facade.asm", "-o", apk)
    manifest, table, names = check_archive(apk)
    print(f"PASS: archive holds {len(names)} stored entries, CRC-32 and 4-byte alignment")

    pool, resmap = check_manifest(manifest)
    print(f"PASS: manifest chunk walk, {len(pool)} pool strings, "
          f"positional resource map with {len(resmap)} rows")
    types = check_table(table)
    print(f"PASS: resources.arsc chunk walk, type ids {sorted(types)}")

    check_non_ascii(assembler, work, aapt2)

    check_res_scan(assembler, work, aapt2, zipalign)

    check_gl_demo(assembler, work, aapt2, zipalign)
    check_gl_demo_aarch64(assembler, work, aapt2, zipalign)
    check_gl_demo_universal(assembler, work, aapt2, zipalign)

    check_deflate(assembler, work, aapt2, zipalign)

    check_framework_ids(assembler, work, aapt2, zipalign)

    if not aapt2 or not zipalign:
        print("SKIP: aapt2/zipalign not found; pass --sdk-bin for the independent checks")
        return

    output = run(aapt2, "dump", "badging", apk)
    for expected in ("package: name='com.example.xirasm.facade'", "versionCode='7'",
                     "versionName='1.2'", "application-label:'XIRASM Facade'",
                     "application-icon-160:'res/mipmap-mdpi-v4/ic_launcher.png'",
                     "application-icon-240:'res/mipmap-hdpi-v4/ic_launcher.png'",
                     "launchable-activity: name='android.app.NativeActivity'"):
        assert expected in output, (expected, output)
    print("PASS: aapt2 badging resolves the package, label and both density icons")

    tree = run(aapt2, "dump", "xmltree", apk, "--file", "AndroidManifest.xml")
    for expected in ("icon(0x01010002)=@0x7f010000", "label(0x01010001)=@0x7f020000",
                     "hasCode(0x0101000c)=false", "extractNativeLibs(0x010104ea)=false", 'value(0x01010024)="main"'):
        assert expected in tree, (expected, tree)
    print("PASS: aapt2 xmltree resolves both resource references and the framework ids")

    resources = run(aapt2, "dump", "resources", apk)
    for expected in ("type mipmap id=01", "type string id=02", "resource 0x7f010000 mipmap/ic_launcher",
                     "(mdpi) (file) res/mipmap-mdpi-v4/ic_launcher.png type=PNG",
                     "(hdpi) (file) res/mipmap-hdpi-v4/ic_launcher.png type=PNG",
                     "resource 0x7f020000 string/app_name", '"XIRASM Facade"'):
        assert expected in resources, (expected, resources)
    print("PASS: aapt2 dump resources reads our table back unchanged")

    run(zipalign, "-c", "-v", "4", apk)
    run(zipalign, "-c", "-v", "-P", "16", "4", apk)
    print("PASS: zipalign -c 4 and -c -P 16 4 accept the archive")

    print(f"PASS: 1 APK fixture, aapt2/zipalign readers ({apk})")


if __name__ == "__main__":
    main()

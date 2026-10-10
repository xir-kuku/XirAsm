"""Check native Android type layouts and actual instances using an existing assembler.

With --ndk, independently compile sizeof/alignof/offsetof assertions against
the locked NDK headers for A64, x86-64 and ARM32. No XIRASM build is performed.
"""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import subprocess

from generate_android_structures import Builder, DATA, ROOT, load_snapshot, public_name, sha


def run(argv, commands, cwd=None):
    result = subprocess.run([str(arg) for arg in argv], cwd=cwd, capture_output=True,
                            text=True, encoding='utf-8', errors='replace', timeout=120)
    record = {'argv': [str(arg) for arg in argv], 'exit_code': result.returncode,
              'diagnostic': result.stdout + result.stderr}
    commands.append(record)
    assert result.returncode == 0, record


class Instances:
    def __init__(self, builder):
        self.builder = builder
        self.serial = 0

    def literal(self, name, branch=None, defaults=False):
        if name not in self.builder.types:
            width = int(name[1:]) // 8
            self.serial += 1
            if name.startswith('f'):
                value = 0.0 if defaults else ((-1.0 if self.serial % 2 else 1.0) * self.serial / 8.0)
                literal = repr(value)
                return ('f32(' + literal + ')' if name == 'f32' else literal), struct.pack('<f' if name == 'f32' else '<d', value)
            value = 0 if defaults else (-self.serial % 127 - 127 if name.startswith('i') else
                                        ((0x8877665544332211 + self.serial * 0x12345) & ((1 << (width * 8)) - 1)))
            return str(value), value.to_bytes(width, 'little', signed=name.startswith('i'))
        node = self.builder.types[name]
        fields = node['fields'] if node['kind'] == 'struct' else [node['fields'][branch or 0]]
        assignments, expected = [], bytearray(node['size'])
        for field in fields:
            literal, content = self.literal(field['type'], defaults=defaults)
            start = field['offset']
            expected[start:start + len(content)] = content
            if not defaults or node['kind'] == 'union' or field['type'] in self.builder.types:
                assignments.append(field['name'] + ': ' + literal)
        return name + ' { ' + ', '.join(assignments) + ' }', bytes(expected)


def native_check(args, builder, commands):
    output, includes = args.output, args.include_dir
    prefix = 'import(' + json.dumps((includes / 'structs.inc').as_posix()) + ');'
    lines = [prefix]
    layout_count = 0
    # A wrapper observes the native type alignment rather than trusting a constant.
    for index, (name, node) in enumerate(builder.types.items()):
        wrapper = 'AndroidLayoutProbe' + str(index)
        lines += [f'struct {wrapper} {{', '    tag: u8 = 0,', f'    value: {name},', '}',
                  f'assert(sizeof({name}) == {node["size"]});',
                  f'assert(offset_of({wrapper}, value) == {node["alignment"]});']
        layout_count += 2
        for path in builder.paths(name):
            lines.append(f'assert(offset_of({name}, {path["path"]}) == {path["offset"]});')
            layout_count += 1
    instances = Instances(builder)
    expected, records = bytearray(), []
    for name, node in builder.types.items():
        branches = range(len(node['fields'])) if node['kind'] == 'union' else [None]
        for branch in branches:
            literal, content = instances.literal(name, branch)
            lines.append('emit.struct(' + literal + ');')
            records.append({'type': name, 'branch': branch, 'start': len(expected),
                            'size': len(content), 'sha256': hashlib.sha256(content).hexdigest()})
            expected.extend(content)
        literal, content = instances.literal(name, defaults=True)
        lines.append('emit.bytes(pack(' + literal + '));')
        assert not any(content), ('Nonzero default', name)
        records.append({'type': name, 'defaults': True, 'start': len(expected), 'size': len(content)})
        expected.extend(content)
    source, binary = output / 'android-structures-native.asm', output / 'android-structures-native.bin'
    source.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    run([args.assembler, source, '-o', binary, '--no-progress'], commands, ROOT)
    actual = binary.read_bytes()
    if actual != bytes(expected):
        mismatch = next((i for i, (a, b) in enumerate(zip(actual, expected)) if a != b), min(len(actual), len(expected)))
        owning = next((row for row in records if row['start'] <= mismatch < row['start'] + row['size']), None)
        raise AssertionError(('Packed instance mismatch', mismatch, owning, len(actual), len(expected)))
    (output / 'native-instances.json').write_text(json.dumps(records, indent=2) + '\n', encoding='utf-8')
    (output / 'native-paths.json').write_text(json.dumps({name: builder.paths(name) for name in builder.public}, indent=2) + '\n', encoding='utf-8')
    return {'layout_assertions': layout_count, 'instances': len(records), 'bytes': len(actual),
            'source_sha256': sha(source), 'binary_sha256': sha(binary)}


def fixture_check(args, commands):
    fixture = ROOT / 'tests/os/android/android-struct-instances.asm'
    source = args.output / fixture.name
    # Use the explicit include set even when checking a frozen snapshot.
    original = fixture.read_text(encoding='utf-8')
    prefix = 'import("../../../include/os/android/structs.inc");'
    assert original.startswith(prefix)
    source.write_text(original.replace(prefix, 'import(' + json.dumps((args.include_dir / 'structs.inc').as_posix()) + ');', 1), encoding='utf-8')
    binary = source.with_suffix('.bin')
    run([args.assembler, source, '-o', binary, '--no-progress'], commands, ROOT)
    window = struct.pack('<iiiiQ6I', 640, 480, 640, 1, 0, *([0] * 6))
    rect = struct.pack('<4i', 0, 0, 640, 480)
    callbacks = bytearray(128)
    struct.pack_into('<Q', callbacks, 0, 0x1122334455667788)
    struct.pack_into('<Q', callbacks, 56, 0x8877665544332211)
    sensor = bytearray(104)
    struct.pack_into('<i', sensor, 0, 104)
    struct.pack_into('<q', sensor, 16, 0x102030405060708)
    struct.pack_into('<3f', sensor, 24, 1.5, -2.0, 3.25)
    expected = window + rect + callbacks + sensor
    assert binary.read_bytes() == expected, 'Handwritten window/callback/nested-float instances mismatch'
    return {'bytes': len(expected), 'fixture_sha256': sha(fixture), 'binary_sha256': sha(binary)}


def clang_check(args, builder, commands):
    if args.ndk is None:
        return {'status': 'not requested'}
    prebuilt = args.ndk / 'toolchains/llvm/prebuilt/windows-x86_64'
    clang, sysroot = prebuilt / 'bin/clang.exe', prebuilt / 'sysroot'
    assert clang.is_file(), ('Missing NDK Clang', clang)
    headers = {}
    for name, expected in builder.snapshot['headers'].items():
        path = sysroot / 'usr/include/android' / name
        assert sha(path) == expected, ('NDK header differs from locked input', name)
        headers[name] = sha(path)
    counts = {}
    for bits, target in [('64', 'aarch64-linux-android35'), ('64', 'x86_64-linux-android35'),
                         ('32', 'armv7a-linux-androideabi35')]:
        lines = ['#include <stddef.h>', *['#include <android/' + name + '>' for name in sorted(headers)]]
        assertions = 0
        for row in builder.snapshot['records']:
            name, native = row['name'], public_name(row['name'], bits)
            ctype = 'struct ' + name if row['c_kind'] == 'struct' else name
            node = row['models'][bits]
            lines += [f'static_assert(sizeof({ctype}) == {node["size"]}, "size {name}");',
                      f'static_assert(alignof({ctype}) == {node["alignment"]}, "alignment {name}");']
            assertions += 2
            c_paths = {path['c_path']: path['offset'] for path in builder.paths(native) if path['c_path']}
            # Check every original promoted C path as well as recursive arrays/nesting.
            for field, offset in row['offsets'][bits]:
                assert c_paths[field] == offset, ('Original C path lost', name, field)
            for field, offset in sorted(c_paths.items()):
                lines.append(f'static_assert(offsetof({ctype}, {field}) == {offset}, "offset {name}.{field}");')
                assertions += 1
        source = args.output / (target + '-structures.cpp')
        source.write_text('\n'.join(lines) + '\n', encoding='utf-8')
        run([clang, '--target=' + target, '--sysroot=' + str(sysroot), '-x', 'c++', '-std=c++17', '-fsyntax-only', source], commands)
        counts[target] = {'assertions': assertions, 'source_sha256': sha(source)}
    return {'status': 'passed', 'targets': counts, 'clang_sha256': sha(clang), 'ndk_header_hashes': headers}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--assembler', required=True, type=Path)
    parser.add_argument('--include-dir', type=Path, default=ROOT / 'include/os/android')
    parser.add_argument('--ndk', type=Path)
    parser.add_argument('--output', type=Path, default=ROOT / 'tmp/android-structures-check')
    args = parser.parse_args()
    args.assembler, args.include_dir, args.output = args.assembler.resolve(), args.include_dir.resolve(), args.output.resolve()
    if args.ndk is not None:
        args.ndk = args.ndk.resolve()
    assert args.assembler.is_file()
    args.output.mkdir(parents=True, exist_ok=True)
    builder, commands = Builder(load_snapshot()).build(), []
    generated = builder.render()
    for relative, content in generated.items():
        assert (args.include_dir / relative).read_bytes() == content.encode('utf-8'), ('Stale generated include', relative)
    summary = {'status': 'running', 'assembler_sha256': sha(args.assembler), 'input_sha256': sha(DATA),
               'public_types': len(builder.public), 'native_types': len(builder.types),
               'include_hashes': {relative: sha(args.include_dir / relative) for relative in generated},
               'checker_sha256': sha(Path(__file__)), 'generator_sha256': sha(Path(__file__).with_name('generate_android_structures.py'))}
    try:
        summary['native'] = native_check(args, builder, commands)
        summary['handwritten_instances'] = fixture_check(args, commands)
        summary['clang'] = clang_check(args, builder, commands)
        summary['status'] = 'passed'
    except Exception as error:
        summary['status'], summary['error'] = 'failed', repr(error)
        raise
    finally:
        summary['commands'] = commands
        (args.output / 'summary.json').write_text(json.dumps(summary, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    print(json.dumps({key: summary[key] for key in ('status', 'public_types', 'native_types', 'native', 'handwritten_instances', 'clang')}, ensure_ascii=False))


if __name__ == '__main__':
    main()

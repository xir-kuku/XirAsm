"""Generate native XIRASM Android records from a locked, Clang-checked NDK model.

The source snapshot is development input, never a runtime dependency. Native
Fixed arrays use native helper records with typed element fields. Native f32
fields retain the NDK float value type as well as its ABI layout.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / 'tests/os/data/android-structures.json'
DESTINATION = ROOT / 'include/os/android'
DATA_SHA256 = '9609a51012aa99f8bf006c9ae7bdbbd6fed997974f98e0e0c26a9dd032561d0e'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_snapshot():
    assert sha(DATA) == DATA_SHA256, 'Locked Android structure input changed; review required'
    snapshot = json.loads(DATA.read_bytes())
    assert snapshot['schema'] == 1 and snapshot['api'] == 35
    assert len(snapshot['records']) == 25 and len(snapshot['headers']) == 9
    assert len({row['name'] for row in snapshot['records']}) == 25
    assert all(set(row['models']) == {'64', '32'} for row in snapshot['records'])
    return snapshot


def header_name(header):
    return re.sub(r'(?<!^)(?=[A-Z])', '_', Path(header).stem).lower()


def public_name(name, bits):
    return name + ('_arm32' if bits == '32' else '')


def clean_type(text):
    return re.sub(r'\b(struct|union|const|volatile|restrict|_Nullable|_Nonnull)\b', '', text).strip()


def anonymous_name(owner, raw_path, raw_name):
    index = int(raw_name.rsplit('_', 1)[1])
    if owner == 'ASensorEvent':
        return 'payload' if not raw_path else 'values'
    if owner == 'AAdditionalInfoEvent':
        return 'payload'
    if owner == 'ASensorVector':
        return 'components' if not raw_path else {1: 'cartesian', 2: 'orientation'}[index]
    if owner == 'AUncalibratedEvent':
        return {1: 'uncalibrated', 2: 'bias'}[index] if not raw_path else 'axes'
    if owner == 'ALimitedAxesImuEvent':
        return {1: 'calibrated', 2: 'support'}[index] if not raw_path else 'axes'
    if owner == 'ALimitedAxesImuUncalibratedEvent':
        return {1: 'uncalibrated', 2: 'bias', 3: 'support'}[index] if not raw_path else 'axes'
    raise AssertionError(('Unreviewed anonymous Android record', owner, raw_path, raw_name))


def scalar_type(field):
    text, size = field['c_type'], field['element_size']
    assert size in (1, 2, 4, 8), ('Unreviewed scalar width', field)
    if text == 'float':
        assert size == 4
        return 'f32'
    if text == 'double':
        assert size == 8
        return 'f64'
    if text.startswith('int') and text.endswith('_t') or text == 'AThermalStatus':
        return 'i' + str(size * 8)
    assert ('*' in text or text in ('jobject', 'size_t') or
            text.startswith('uint') and text.endswith('_t')), ('Unreviewed C type', text)
    return 'u' + str(size * 8)


class Builder:
    def __init__(self, snapshot):
        self.snapshot = snapshot
        self.rows = {row['name']: row for row in snapshot['records']}
        self.types = {}
        self.by_header = {}
        self.dependencies = {}
        self.public = []

    def reference(self, owner, bits, field, native_path, raw_path):
        nested = field.get('record')
        key = clean_type(field['c_type'])
        if nested is None:
            return scalar_type(field)
        if key in self.rows:
            assert nested == self.rows[key]['models'][bits], ('Nested definition differs', key)
            self.dependencies[owner].add(key)
            self.build_public(key, bits)
            return public_name(key, bits)
        name = 'android_' + public_name(owner, bits) + '_' + '_'.join(native_path)
        self.build_type(name, owner, bits, nested, native_path, raw_path)
        return name

    def build_type(self, name, owner, bits, node, native_path=(), raw_path=()):
        if name in self.types:
            return
        fields = []
        for field in node['fields']:
            exposed = anonymous_name(owner, raw_path, field['name']) if field['anonymous'] else field['name']
            next_path = native_path + (exposed,)
            next_raw = raw_path + (field['name'],)
            element = self.reference(owner, bits, field, next_path, next_raw)
            field_type = element
            if field['count'] != 1:
                field_type = 'android_' + public_name(owner, bits) + '_' + '_'.join(next_path)
                # Anonymous aggregates are never arrays in the locked inventory.
                assert field_type not in self.types, ('Array/helper collision', field_type)
                count = field['count']
                self.types[field_type] = {
                    'kind': 'struct', 'size': field['size'],
                    'alignment': self.type_alignment(element),
                    'fields': [{'name': 'element' + str(i), 'type': element,
                                'offset': i * field['element_size'], 'source': None}
                               for i in range(count)],
                    'owner': owner, 'bits': bits, 'array': True,
                }
                self.by_header[self.rows[owner]['header']].append(field_type)
            fields.append({'name': exposed, 'type': field_type, 'offset': field['offset'], 'source': field})
        self.types[name] = {'kind': node['kind'], 'size': node['size'], 'alignment': node['alignment'],
                            'fields': fields, 'owner': owner, 'bits': bits, 'array': False}
        self.check_layout(name)
        self.by_header[self.rows[owner]['header']].append(name)

    def type_alignment(self, name):
        return int(name[1:]) // 8 if re.fullmatch('[ui](8|16|32|64)|f(32|64)', name) else self.types[name]['alignment']

    def type_size(self, name):
        return int(name[1:]) // 8 if re.fullmatch('[ui](8|16|32|64)|f(32|64)', name) else self.types[name]['size']

    def check_layout(self, name):
        node = self.types[name]
        cursor, largest, alignment = 0, 0, 1
        for field in node['fields']:
            width, align = self.type_size(field['type']), self.type_alignment(field['type'])
            start = 0 if node['kind'] == 'union' else (cursor + align - 1) // align * align
            assert start == field['offset'], (name, field['name'], start, field['offset'])
            largest = max(largest, width)
            cursor = start + width
            alignment = max(alignment, align)
        end = largest if node['kind'] == 'union' else cursor
        size = (end + alignment - 1) // alignment * alignment
        assert (size, alignment) == (node['size'], node['alignment']), (name, size, alignment, node)

    def build_public(self, owner, bits):
        name = public_name(owner, bits)
        if name in self.types:
            return
        row = self.rows[owner]
        self.by_header.setdefault(row['header'], [])
        self.dependencies.setdefault(owner, set())
        self.build_type(name, owner, bits, row['models'][bits])
        self.public.append(name)

    def build(self):
        for row in self.snapshot['records']:
            for bits in ('64', '32'):
                self.build_public(row['name'], bits)
        assert len(self.public) == 50
        for name in self.types:
            self.check_layout(name)
        return self

    def paths(self, name, native=(), c_path='', start=0):
        """Expose every native member and C-accessible counterpart for verification."""
        node = self.types[name]
        result = []
        for field in node['fields']:
            path = native + (field['name'],)
            offset = start + field['offset']
            source = field['source']
            if node['array']:
                c_field = c_path + '[' + field['name'][7:] + ']'
            elif source['anonymous']:
                c_field = c_path
            else:
                c_field = c_path + ('.' if c_path else '') + source['name']
            result.append({'path': '.'.join(path), 'c_path': c_field if not source or not source['anonymous'] else None,
                           'offset': offset, 'type': field['type']})
            if field['type'] in self.types:
                result.extend(self.paths(field['type'], path, c_field, offset))
        return result

    def render(self):
        files = {}
        for header, names in sorted(self.by_header.items()):
            dependencies = sorted({self.rows[dep]['header'] for name in names
                                   for dep in self.dependencies[self.types[name]['owner']]
                                   if self.rows[dep]['header'] != header})
            lines = ['// Generated by tests/os/generate_android_structures.py; do not edit.',
                     '// LP64 defaults and explicit ARM32 ILP32 _arm32 variants (not i686).',
                     '// C float fields are native f32; fixed arrays expose element0...elementN.',
                     '// Anonymous C members use named native aggregates; see offset_of field paths.',
                     *['import("' + header_name(dep) + '.inc");' for dep in dependencies], '']
            for name in names:
                node = self.types[name]
                lines.append(node['kind'] + ' ' + name + ' {')
                for field in node['fields']:
                    default = ''
                    if node['kind'] == 'struct' and field['type'] not in self.types:
                        default = {'f32': ' = f32(0.0)', 'f64': ' = 0.0'}.get(field['type'], ' = 0')
                    lines.append('    ' + field['name'] + ': ' + field['type'] + default + ',')
                lines.extend(['}', ''])
            files['structs/' + header_name(header) + '.inc'] = '\n'.join(lines)
        files['structs.inc'] = '\n'.join([
            '// Generated by tests/os/generate_android_structures.py; do not edit.',
            '// Native NDK records: LP64 defaults; _arm32 explicitly selects ARM32 ILP32.',
            '// _arm32 must not be used as an i686 layout.',
            *['import("structs/' + header_name(header) + '.inc");' for header in sorted(self.by_header)], ''])
        assert len(files) == 10
        return files


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Check without writing generated includes.')
    args = parser.parse_args()
    builder = Builder(load_snapshot()).build()
    files = builder.render()
    assert set(files) == {'structs.inc', *('structs/' + header_name(header) + '.inc' for header in builder.by_header)}
    assert all(path.startswith('structs/') or path == 'structs.inc' for path in files)
    for relative, content in files.items():
        path = DESTINATION / relative
        assert path.resolve().is_relative_to(DESTINATION.resolve())
        data = content.encode('utf-8')
        if args.check:
            assert path.read_bytes() == data, ('Stale generated Android structure', path)
        else:
            # Only this generator's files may be mechanically replaced.
            existing = path.read_text(encoding='utf-8') if path.exists() else None
            assert existing is None or existing.startswith('// Generated by tests/os/generate_android_structures.py;') or (
                relative == 'structs.inc' and existing.startswith('// Native NDK records: LP64 defaults;'))
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
            assert path.read_bytes() == data
    print(json.dumps({'status': 'passed', 'public_types': len(builder.public),
                      'native_types': len(builder.types), 'files': len(files), 'input_sha256': sha(DATA)}))


if __name__ == '__main__':
    main()

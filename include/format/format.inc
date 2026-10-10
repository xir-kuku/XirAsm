// User-facing executable-format API layer.
//
// This layer owns declarative format plans and named section lookup. The
// family-specific include files remain available as advanced row-level APIs.

import("pe32.inc");
import("pe64.inc");
import("pe_export.inc");
import("pe_import.inc");
import("pe_reloc.inc");
import("pe_resource.inc");
import("coff.inc");
import("elfexe.inc");
import("elfexe_import.inc");
import("elfobj.inc");
import("elf_export.inc");
import("elfso_import.inc");
// Mach-O record helpers back both the generic plan API and direct layouts.
import("macho_obj.inc");
import("macho_exe.inc");
import("macho_dylib.inc");
import("macho_import.inc");

const format_kind_pe32: u64 = 1
const format_kind_pe64: u64 = 2
const format_kind_elf32: u64 = 3
const format_kind_elf64: u64 = 4
const format_kind_coff32: u64 = 5
const format_kind_coff64: u64 = 6
const format_kind_elfobj32: u64 = 7
const format_kind_elfobj64: u64 = 8
const format_kind_elfso64: u64 = 9
const format_kind_macho64_object: u64 = 10
const format_kind_macho64_execute: u64 = 11
const format_kind_macho64_dylib: u64 = 12

const format_coff_symbol_public: u64 = 1
const format_coff_symbol_extern: u64 = 2
const format_elfobj_symbol_public: u64 = 3
const format_elfobj_symbol_extern: u64 = 4
const format_macho64_symbol_public: u64 = 5
const format_macho64_symbol_extern: u64 = 6

const format_pe_exe: u64 = 0x0001
const format_pe_dll: u64 = 0x0002
const format_pe_console: u64 = 0x0004
const format_pe_gui: u64 = 0x0008
const format_pe_nx: u64 = 0x0010
const format_pe_aslr_auto: u64 = 0x0020
const format_pe_aslr_required: u64 = 0x0040
const format_pe_aslr_disabled: u64 = 0x0080

const format_elf_exec: u64 = 0x0001
const format_elf_pie: u64 = 0x0002

const format_code: u64 = 0x0001
const format_data: u64 = 0x0002
const format_uninitialized_data: u64 = 0x0004
const format_imports: u64 = 0x0008
const format_exports: u64 = 0x0010
const format_resources: u64 = 0x0020
const format_fixups: u64 = 0x0040

const format_readable: u64 = 0x0100
const format_writeable: u64 = 0x0200
const format_executable: u64 = 0x0400
const format_discardable: u64 = 0x0800

const format_load: u64 = 0x00010000

const format_section_purpose_mask: u64 = format_code | format_data | format_uninitialized_data | format_imports | format_exports | format_resources | format_fixups
const format_section_unique_purpose_mask: u64 = format_imports | format_exports | format_resources | format_fixups
const format_permission_mask: u64 = format_readable | format_writeable | format_executable | format_discardable
const format_segment_permission_mask: u64 = format_readable | format_writeable | format_executable
const format_segment_purpose_mask: u64 = format_load

const format_pe_kind_mask: u64 = format_pe_exe | format_pe_dll
const format_pe_subsystem_mask: u64 = format_pe_console | format_pe_gui
const format_pe_aslr_mask: u64 = format_pe_aslr_auto | format_pe_aslr_required | format_pe_aslr_disabled
const format_pe_option_mask: u64 = format_pe_kind_mask | format_pe_subsystem_mask | format_pe_nx | format_pe_aslr_mask
const format_elf_option_mask: u64 = format_elf_exec | format_elf_pie

const format_macho64_image_base: u64 = 0x100000000
const format_macho64_header_label: string = "__xirasm_macho64_header"
const format_macho64_linkedit_region: string = ".xirasm.macho.__LINKEDIT"
const format_macho64_tables_region: string = ".xirasm.macho.tables"

const format_pe_opt_subsystem_foa: u64 = pe_optional_header_foa + 68

fn format_section(name: string, attributes: u64) -> map {
    assert(len(name) > 0, "format section name is empty");
    assert(
        (attributes & ~(format_section_purpose_mask | format_permission_mask)) == 0,
        "unknown format section attribute"
    );

    const purpose: u64 = attributes & format_section_purpose_mask
    assert(purpose != 0, "format section requires one purpose");
    assert((purpose & (purpose - 1)) == 0, "format section has multiple purposes");

    let section: map = map.new()
    map.set_mut(section, "name", name);
    map.set_mut(section, "attributes", attributes);
    return section;
}

fn format_validate_sections(sections: list) -> bool {
    assert(len(sections) > 0, "format plan requires at least one section");
    assert(len(sections) <= pe_max_image_sections, "format plan has too many PE sections");

    for i in range(0, len(sections)) {
        const current: map = list.get(sections, i)
        const current_name: string = map.get(current, "name")
        const current_attributes: u64 = map.get(current, "attributes")
        const current_purpose: u64 = current_attributes & format_section_purpose_mask
        assert(len(current_name) > 0, "format section name is empty");

        for j in range(i + 1, len(sections)) {
            const other: map = list.get(sections, j)
            assert(map.get(other, "name") != current_name, "format section name is duplicated");

            const other_attributes: u64 = map.get(other, "attributes")
            const other_purpose: u64 = other_attributes & format_section_purpose_mask
            if (current_purpose & format_section_unique_purpose_mask) != 0 {
                assert(other_purpose != current_purpose, "format special-purpose section is duplicated");
            }
        }
    }

    return true;
}

fn format_validate_short_section_names(sections: list) -> bool {
    for section in sections {
        assert(
            len(map.get(section, "name")) <= 8,
            "PE/COFF section names must fit in eight bytes"
        );
    }
    return true;
}

fn format_macho64_target(cpu_type: u64, cpu_subtype: u64, minos: u64, sdk: u64) -> map {
    if cpu_type == macho_cpu_type_arm64 {
        assert(
            cpu_subtype == macho_cpu_subtype_arm64_all ||
            cpu_subtype == macho_cpu_subtype_arm64_v8 ||
            cpu_subtype == macho_cpu_subtype_arm64e,
            "unsupported Mach-O arm64 CPU subtype"
        );
    } else {
        assert(cpu_type == macho_cpu_type_x86_64, "unsupported Mach-O 64 CPU type");
        assert(
            cpu_subtype == macho_cpu_subtype_x86_64_all ||
            cpu_subtype == macho_cpu_subtype_x86_64_h,
            "unsupported Mach-O x86_64 CPU subtype"
        );
    }
    assert(minos > 0, "Mach-O minimum macOS version is zero");
    assert(minos <= 0xffffffff && sdk <= 0xffffffff, "Mach-O version exceeds 32 bits");
    assert(sdk >= minos, "Mach-O SDK version precedes minimum macOS version");

    let target: map = map.new()
    map.set_mut(target, "cpu_type", cpu_type);
    map.set_mut(target, "cpu_subtype", cpu_subtype);
    map.set_mut(target, "page_size", macho_target_page_size64(cpu_type));
    map.set_mut(target, "minos", minos);
    map.set_mut(target, "sdk", sdk);
    return target;
}

fn format_macho64_target_arm64(minos: u64, sdk: u64) -> map {
    return format_macho64_target(macho_cpu_type_arm64, macho_cpu_subtype_arm64_all, minos, sdk);
}

fn format_macho64_target_x86_64(minos: u64, sdk: u64) -> map {
    return format_macho64_target(macho_cpu_type_x86_64, macho_cpu_subtype_x86_64_all, minos, sdk);
}

fn format_validate_macho64_sections(sections: list) -> bool {
    assert(len(sections) > 0, "Mach-O format plan requires at least one section");
    assert(len(sections) < 256, "Mach-O format plan has too many sections");
    let has_zerofill: bool = false

    for i in range(0, len(sections)) {
        const section: map = list.get(sections, i)
        const name: string = map.get(section, "name")
        const attributes: u64 = map.get(section, "attributes")
        const purpose: u64 = attributes & format_section_purpose_mask
        assert(len(name) <= 16, "Mach-O section name exceeds 16 bytes");
        assert(purpose == format_code || purpose == format_data || purpose == format_uninitialized_data, "unsupported Mach-O section purpose");
        assert((attributes & format_discardable) == 0, "Mach-O sections do not support the discardable attribute");
        if purpose == format_uninitialized_data {
            has_zerofill = true;
        } else {
            assert(!has_zerofill, "Mach-O zerofill sections must be last in their segment");
        }
        for j in range(i + 1, len(sections)) {
            const other: map = list.get(sections, j)
            assert(map.get(other, "name") != name, "Mach-O section name is duplicated");
        }
    }
    return true;
}

fn format_macho64_segment(name: string, attributes: u64, sections: list) -> map {
    assert(len(name) > 0, "Mach-O segment name is empty");
    assert(len(name) <= 16, "Mach-O segment name exceeds 16 bytes");
    assert(name != "__PAGEZERO" && name != "__LINKEDIT", "Mach-O segment name is reserved by the facade");
    assert((attributes & ~(format_load | format_segment_permission_mask)) == 0, "unknown Mach-O segment attribute");
    assert((attributes & format_load) != 0, "Mach-O segment requires the load attribute");
    assert((attributes & format_segment_permission_mask) != 0, "Mach-O segment requires permissions");
    assert(format_validate_macho64_sections(sections), "invalid Mach-O segment section list");

    let segment: map = map.new()
    map.set_mut(segment, "name", name);
    map.set_mut(segment, "attributes", attributes);
    map.set_mut(segment, "sections", sections);
    return segment;
}

fn format_validate_macho64_segments(segments: list) -> bool {
    assert(len(segments) > 0, "Mach-O executable or dylib requires at least one segment");
    const first: map = list.get(segments, 0)
    assert(map.get(first, "name") == "__TEXT", "Mach-O first segment must be __TEXT");
    assert((map.get(first, "attributes") & format_readable) != 0, "Mach-O __TEXT segment must be readable");
    let has_code: bool = false
    for i in range(0, len(segments)) {
        const segment: map = list.get(segments, i)
        const segment_name: string = map.get(segment, "name")
        const segment_attributes: u64 = map.get(segment, "attributes")
        const segment_permissions: u64 = segment_attributes & format_segment_permission_mask
        const sections: list = map.get(segment, "sections")
        let has_zerofill: bool = false
        let section_names: list = list.new()
        for j in range(i + 1, len(segments)) {
            assert(map.get(list.get(segments, j), "name") != segment_name, "Mach-O segment name is duplicated");
        }
        for section in sections {
            const section_attributes: u64 = map.get(section, "attributes")
            const section_permissions: u64 = section_attributes & format_segment_permission_mask
            const purpose: u64 = section_attributes & format_section_purpose_mask
            assert((section_permissions & ~segment_permissions) == 0, "Mach-O section permissions exceed its segment permissions");
            if purpose == format_code {
                has_code = true;
                assert((segment_permissions & format_executable) != 0, "Mach-O code section requires an executable segment");
            }
            if purpose == format_uninitialized_data {
                has_zerofill = true;
            } else {
                assert(!has_zerofill, "Mach-O zerofill sections must be last in their segment");
            }
            for existing_name in section_names {
                assert(existing_name != map.get(section, "name"), "Mach-O section name is duplicated within a segment");
            }
            list.push_mut(section_names, map.get(section, "name"));
        }
    }
    assert(has_code, "Mach-O executable or dylib requires a code section");
    return true;
}

fn format_macho64_clone_section(section: map, segment_name: string, segment_row: u64) -> map {
    let clone: map = map.new()
    map.set_mut(clone, "name", map.get(section, "name"));
    map.set_mut(clone, "attributes", map.get(section, "attributes"));
    map.set_mut(clone, "segment", segment_name);
    map.set_mut(clone, "segment_row", segment_row);
    map.set_mut(clone, "key", sym.unique("__xirasm_macho64_section_"));
    return clone;
}

fn format_macho64_plan(kind: u64, target: map, items: list) -> map {
    assert(kind == format_kind_macho64_object || kind == format_kind_macho64_execute || kind == format_kind_macho64_dylib, "unsupported Mach-O format plan kind");

    let plan: map = map.new()
    map.set_mut(plan, "kind", kind);
    map.set_mut(plan, "target", target);
    map.set_mut(plan, "entry", 0);
    map.set_mut(plan, "exports", macho_export_new());
    map.set_mut(plan, "next_address", 0);
    map.set_mut(plan, "next_section_row", 0);
    map.set_mut(plan, "section_open", false);
    if kind == format_kind_macho64_object {
        assert(format_validate_macho64_sections(items), "invalid Mach-O object section list");
        let sections: list = list.new()
        for section in items {
            list.push_mut(sections, format_macho64_clone_section(section, format_macho64_section_segment_name(map.get(section, "attributes")), 0));
        }
        map.set_mut(plan, "sections", sections);
        map.set_mut(plan, "segments", list.new());
        map.set_mut(plan, "symbols", list.new());
        map.set_mut(plan, "relocs", list.new());
    } else {
        assert(format_validate_macho64_segments(items), "invalid Mach-O segment list");
        let segments: list = list.new()
        let sections: list = list.new()
        for i in range(0, len(items)) {
            const source_segment: map = list.get(items, i)
            let segment: map = map.new()
            let segment_sections: list = list.new()
            map.set_mut(segment, "name", map.get(source_segment, "name"));
            map.set_mut(segment, "attributes", map.get(source_segment, "attributes"));
            for source_section in map.get(source_segment, "sections") {
                const section: map = format_macho64_clone_section(source_section, map.get(source_segment, "name"), i)
                list.push_mut(segment_sections, section);
                list.push_mut(sections, section);
            }
            map.set_mut(segment, "sections", segment_sections);
            list.push_mut(segments, segment);
        }
        map.set_mut(plan, "sections", sections);
        map.set_mut(plan, "segments", segments);
        assert(len(sections) < 256, "Mach-O format plan has too many sections");
        map.set_mut(plan, "current_segment_row", len(segments));
    }
    return plan;
}

fn format_macho64_object(target: map, sections: list) -> map {
    return format_macho64_plan(format_kind_macho64_object, target, sections);
}

fn format_macho64_exe(target: map, segments: list) -> map {
    return format_macho64_plan(format_kind_macho64_execute, target, segments);
}

fn format_macho64_dylib(target: map, install_name: string, segments: list) -> map {
    assert(len(install_name) > 0, "Mach-O dylib install name is empty");
    let plan: map = format_macho64_plan(format_kind_macho64_dylib, target, segments)
    map.set_mut(plan, "install_name", install_name);
    return plan;
}

fn format_macho64_exports_mut(let plan: map, exports: list) {
    assert(map.get(plan, "kind") == format_kind_macho64_dylib, "Mach-O exports require a dylib plan");
    assert(len(exports) > 0, "Mach-O dylib export table is empty");
    assert(len(exports) < 256, "Mach-O dylib has too many root exports");
    map.set_mut(plan, "exports", exports);
}

fn format_validate_pe_options(options: u64) -> bool {
    assert((options & ~format_pe_option_mask) == 0, "unknown PE format option");

    const kind: u64 = options & format_pe_kind_mask
    assert(kind != 0, "PE format requires EXE or DLL");
    assert((kind & (kind - 1)) == 0, "PE format cannot be both EXE and DLL");

    const subsystem: u64 = options & format_pe_subsystem_mask
    assert(subsystem != 0, "PE format requires console or GUI subsystem");
    assert((subsystem & (subsystem - 1)) == 0, "PE format has multiple subsystems");

    const aslr: u64 = options & format_pe_aslr_mask
    assert(aslr != 0, "PE format requires an ASLR policy");
    assert((aslr & (aslr - 1)) == 0, "PE format has multiple ASLR policies");

    return true;
}

fn format_pe_plan(kind: u64, options: u64, sections: list) -> map {
    assert(format_validate_pe_options(options), "invalid PE format options");
    assert(format_validate_sections(sections), "invalid PE section list");
    assert(format_validate_short_section_names(sections), "invalid PE section names");

    let machine: u16 = pe_machine_i386
    if kind == format_kind_pe64 {
        machine = pe_machine_amd64;
    }

    let plan: map = map.new()
    map.set_mut(plan, "kind", kind);
    map.set_mut(plan, "options", options);
    map.set_mut(plan, "sections", sections);
    map.set_mut(plan, "machine", machine);
    map.set_mut(plan, "entry", 0);
    return plan;
}

fn format_pe32(options: u64, sections: list) -> map {
    return format_pe_plan(format_kind_pe32, options, sections);
}

// PE32+ image for a chosen machine. The x86-64 and AArch64 images share the
// container layout and the DIR64 base relocations; only the file header machine
// and the instruction encoding differ.
fn format_pe64_machine(options: u64, sections: list, machine: u16) -> map {
    assert(machine == pe_machine_amd64 || machine == pe_machine_arm64, "unsupported PE32+ machine");
    let plan: map = format_pe_plan(format_kind_pe64, options, sections)
    map.set_mut(plan, "machine", machine);
    return plan;
}

fn format_pe64(options: u64, sections: list) -> map {
    return format_pe64_machine(options, sections, pe_machine_amd64);
}

fn format_pe64_arm64(options: u64, sections: list) -> map {
    return format_pe64_machine(options, sections, pe_machine_arm64);
}

fn format_pe_import_new() -> map {
    return pe_import_new();
}

fn format_pe_import_many_mut(plan: map, let imports: map, dll: string, names: list) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_pe32 {
        imports = pe_import_use32_many(imports, dll, names);
    } else {
        assert(kind == format_kind_pe64, "format plan is not a PE image");
        imports = pe_import_use64_many(imports, dll, names);
    }
}

fn format_pe_import_pairs_mut(plan: map, let imports: map, dll: string, pairs: list) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_pe32 {
        imports = pe_import_use32_pairs(imports, dll, pairs);
    } else {
        assert(kind == format_kind_pe64, "format plan is not a PE image");
        imports = pe_import_use64_pairs(imports, dll, pairs);
    }
}

fn format_pe_export_new() -> list {
    return pe_export_new();
}

fn format_pe_export_many_mut(plan: map, let exports: list, names: list) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_pe32 {
        exports = pe_export_use32_many(exports, names);
    } else {
        assert(kind == format_kind_pe64, "format plan is not a PE image");
        exports = pe_export_use64_many(exports, names);
    }
}

fn format_pe_export_pairs_mut(plan: map, let exports: list, pairs: list) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_pe32 {
        exports = pe_export_use32_pairs(exports, pairs);
    } else {
        assert(kind == format_kind_pe64, "format plan is not a PE image");
        exports = pe_export_use64_pairs(exports, pairs);
    }
}

fn format_validate_coff_sections(sections: list) -> bool {
    assert(format_validate_sections(sections), "invalid COFF section list");
    assert(format_validate_short_section_names(sections), "invalid COFF section names");
    for section in sections {
        const attributes: u64 = map.get(section, "attributes")
        const purpose: u64 = attributes & format_section_purpose_mask
        assert(
            purpose == format_code ||
            purpose == format_data ||
            purpose == format_uninitialized_data,
            "COFF format API supports code, data, and uninitialized-data sections"
        );
        assert((attributes & format_discardable) == 0, "COFF format API does not expose discardable sections");
    }
    return true;
}

fn format_coff_plan(kind: u64, sections: list) -> map {
    assert(format_validate_coff_sections(sections), "invalid COFF section list");

    let machine: u16 = coff_machine_i386
    if kind == format_kind_coff64 {
        machine = coff_machine_amd64;
    }

    let plan: map = map.new()
    map.set_mut(plan, "kind", kind);
    map.set_mut(plan, "machine", machine);
    map.set_mut(plan, "sections", sections);
    map.set_mut(plan, "symbols", list.new());
    map.set_mut(plan, "relocs", list.new());
    map.set_mut(plan, "entry", 0);
    return plan;
}

fn format_coff32(sections: list) -> map {
    return format_coff_plan(format_kind_coff32, sections);
}

// COFF object for a chosen machine. AArch64 objects use the ARM64 relocation
// types (coff_rel_arm64_*), which the caller selects per relocation.
fn format_coff64_machine(sections: list, machine: u16) -> map {
    assert(machine == coff_machine_amd64 || machine == coff_machine_arm64, "unsupported COFF machine");
    let plan: map = format_coff_plan(format_kind_coff64, sections)
    map.set_mut(plan, "machine", machine);
    return plan;
}

fn format_coff64(sections: list) -> map {
    return format_coff64_machine(sections, coff_machine_amd64);
}

fn format_coff64_arm64(sections: list) -> map {
    return format_coff64_machine(sections, coff_machine_arm64);
}

fn format_coff_public(name: string, section_name: string, section_start: u64, address: u64, sym_type: u16) -> map {
    assert(len(name) > 0 && len(name) <= 8, "COFF symbol names must fit in eight bytes");
    assert(len(section_name) > 0, "COFF public symbol requires a section name");
    assert(address >= section_start, "COFF public symbol is before its section start");
    let symbol: map = map.new()
    map.set_mut(symbol, "kind", format_coff_symbol_public);
    map.set_mut(symbol, "name", name);
    map.set_mut(symbol, "section", section_name);
    map.set_mut(symbol, "value", address - section_start);
    map.set_mut(symbol, "type", sym_type);
    return symbol;
}

fn format_coff_extern(name: string, sym_type: u16) -> map {
    assert(len(name) > 0 && len(name) <= 8, "COFF symbol names must fit in eight bytes");
    let symbol: map = map.new()
    map.set_mut(symbol, "kind", format_coff_symbol_extern);
    map.set_mut(symbol, "name", name);
    map.set_mut(symbol, "section", "");
    map.set_mut(symbol, "value", 0);
    map.set_mut(symbol, "type", sym_type);
    return symbol;
}

fn format_coff_reloc(section_name: string, section_start: u64, address: u64, symbol_name: string, reloc_type: u16) -> map {
    assert(len(section_name) > 0, "COFF relocation requires a section name");
    assert(len(symbol_name) > 0 && len(symbol_name) <= 8, "COFF relocation symbol names must fit in eight bytes");
    assert(address >= section_start, "COFF relocation is before its section start");
    let reloc: map = map.new()
    map.set_mut(reloc, "section", section_name);
    map.set_mut(reloc, "offset", address - section_start);
    map.set_mut(reloc, "symbol", symbol_name);
    map.set_mut(reloc, "type", reloc_type);
    return reloc;
}

fn format_coff_symbol_index(symbols: list, name: string) -> u64 {
    for i in range(0, len(symbols)) {
        const symbol: map = list.get(symbols, i)
        if map.get(symbol, "name") == name {
            return i;
        }
    }
    assert(false, "COFF relocation target symbol is not declared");
    return 0;
}

fn format_validate_coff_tables(plan: map, symbols: list, relocs: list) -> bool {
    assert(len(symbols) > 0, "COFF format API requires at least one symbol");
    for i in range(0, len(symbols)) {
        const symbol: map = list.get(symbols, i)
        const name: string = map.get(symbol, "name")
        const symbol_kind: u64 = map.get(symbol, "kind")
        if symbol_kind == format_coff_symbol_public {
            const section_row: u64 = format_section_row(plan, map.get(symbol, "section"))
            assert(section_row < len(map.get(plan, "sections")), "COFF public symbol section is invalid");
        }
        assert(
            symbol_kind == format_coff_symbol_public ||
            symbol_kind == format_coff_symbol_extern,
            "unknown COFF format symbol kind"
        );
        for j in range(i + 1, len(symbols)) {
            const other: map = list.get(symbols, j)
            assert(map.get(other, "name") != name, "COFF symbol name is duplicated");
        }
    }
    for reloc in relocs {
        const section_row: u64 = format_section_row(plan, map.get(reloc, "section"))
        const symbol_index: u64 = format_coff_symbol_index(symbols, map.get(reloc, "symbol"))
        assert(section_row < len(map.get(plan, "sections")), "COFF relocation section is invalid");
        assert(symbol_index < len(symbols), "COFF relocation symbol index is invalid");
    }
    return true;
}

fn format_coff_tables_mut(let plan: map, symbols: list, relocs: list) {
    const kind: u64 = map.get(plan, "kind")
    assert(kind == format_kind_coff32 || kind == format_kind_coff64, "format plan is not a COFF object");
    assert(format_validate_coff_tables(plan, symbols, relocs), "invalid COFF format API tables");
    map.set_mut(plan, "symbols", symbols);
    map.set_mut(plan, "relocs", relocs);
}

fn format_validate_elfobj_sections(sections: list) -> bool {
    assert(format_validate_sections(sections), "invalid ELF object section list");
    for section in sections {
        const attributes: u64 = map.get(section, "attributes")
        const purpose: u64 = attributes & format_section_purpose_mask
        assert(
            purpose == format_code ||
            purpose == format_data ||
            purpose == format_uninitialized_data,
            "ELF object format API supports code, data, and uninitialized-data sections"
        );
        assert(
            (attributes & format_discardable) == 0,
            "ELF object format API does not expose discardable sections"
        );
    }
    return true;
}

fn format_elfobj_plan(kind: u64, sections: list) -> map {
    assert(kind == format_kind_elfobj32 || kind == format_kind_elfobj64, "invalid ELF object kind");
    assert(format_validate_elfobj_sections(sections), "invalid ELF object section list");

    let machine: u16 = elf_machine_386
    if kind == format_kind_elfobj64 {
        machine = elf_machine_x86_64;
    }

    let plan: map = map.new()
    map.set_mut(plan, "kind", kind);
    map.set_mut(plan, "machine", machine);
    map.set_mut(plan, "sections", sections);
    map.set_mut(plan, "symbols", list.new());
    map.set_mut(plan, "relocs", list.new());
    map.set_mut(plan, "entry", 0);
    return plan;
}

fn format_elfobj32(sections: list) -> map {
    return format_elfobj_plan(format_kind_elfobj32, sections);
}

fn format_elfobj64(sections: list) -> map {
    return format_elfobj_plan(format_kind_elfobj64, sections);
}

fn format_elfobj64_machine(sections: list, machine: u16) -> map {
    assert(machine == elf_machine_x86_64 || machine == elf_machine_aarch64, "unsupported ELF64 object machine");
    let plan: map = format_elfobj_plan(format_kind_elfobj64, sections)
    map.set_mut(plan, "machine", machine);
    return plan;
}

fn format_elfobj64_aarch64(sections: list) -> map {
    return format_elfobj64_machine(sections, elf_machine_aarch64);
}

fn format_elfobj_public(name: string, section_name: string, section_start: u64, address: u64, symbol_size: u64, symbol_type: u8) -> map {
    assert(len(name) > 0, "ELF object public symbol name is empty");
    assert(len(section_name) > 0, "ELF object public symbol requires a section name");
    assert(address >= section_start, "ELF object public symbol is before its section start");

    let symbol: map = map.new()
    map.set_mut(symbol, "kind", format_elfobj_symbol_public);
    map.set_mut(symbol, "name", name);
    map.set_mut(symbol, "section", section_name);
    map.set_mut(symbol, "value", address - section_start);
    map.set_mut(symbol, "size", symbol_size);
    map.set_mut(symbol, "type", symbol_type);
    return symbol;
}

fn format_elfobj_extern(name: string, symbol_type: u8) -> map {
    assert(len(name) > 0, "ELF object external symbol name is empty");

    let symbol: map = map.new()
    map.set_mut(symbol, "kind", format_elfobj_symbol_extern);
    map.set_mut(symbol, "name", name);
    map.set_mut(symbol, "section", "");
    map.set_mut(symbol, "value", 0);
    map.set_mut(symbol, "size", 0);
    map.set_mut(symbol, "type", symbol_type);
    return symbol;
}

fn format_elfobj_reloc(section_name: string, section_start: u64, address: u64, symbol_name: string, reloc_type: u64, addend: u64) -> map {
    assert(len(section_name) > 0, "ELF object relocation requires a section name");
    assert(len(symbol_name) > 0, "ELF object relocation symbol name is empty");
    assert(address >= section_start, "ELF object relocation is before its section start");

    let reloc: map = map.new()
    map.set_mut(reloc, "section", section_name);
    map.set_mut(reloc, "offset", address - section_start);
    map.set_mut(reloc, "address", address);
    map.set_mut(reloc, "symbol", symbol_name);
    map.set_mut(reloc, "type", reloc_type);
    map.set_mut(reloc, "addend", addend);
    return reloc;
}

fn format_elfobj_symbol_index(plan: map, symbols: list, name: string) -> u64 {
    const sections: list = map.get(plan, "sections")
    for i in range(0, len(symbols)) {
        const symbol: map = list.get(symbols, i)
        if map.get(symbol, "name") == name {
            return 1 + len(sections) + i;
        }
    }
    assert(false, "ELF object relocation target symbol is not declared");
    return 0;
}

fn format_validate_elfobj_tables(plan: map, symbols: list, relocs: list) -> bool {
    assert(len(symbols) > 0, "ELF object format API requires at least one symbol");
    for i in range(0, len(symbols)) {
        const symbol: map = list.get(symbols, i)
        const name: string = map.get(symbol, "name")
        const symbol_kind: u64 = map.get(symbol, "kind")
        if symbol_kind == format_elfobj_symbol_public {
            const section_row: u64 = format_section_row(plan, map.get(symbol, "section"))
            assert(section_row < len(map.get(plan, "sections")), "ELF object public symbol section is invalid");
        }
        assert(
            symbol_kind == format_elfobj_symbol_public ||
            symbol_kind == format_elfobj_symbol_extern,
            "unknown ELF object format symbol kind"
        );
        for j in range(i + 1, len(symbols)) {
            const other: map = list.get(symbols, j)
            assert(map.get(other, "name") != name, "ELF object symbol name is duplicated");
        }
    }
    for reloc in relocs {
        const section_row: u64 = format_section_row(plan, map.get(reloc, "section"))
        const symbol_index: u64 = format_elfobj_symbol_index(plan, symbols, map.get(reloc, "symbol"))
        assert(section_row < len(map.get(plan, "sections")), "ELF object relocation section is invalid");
        assert(symbol_index > len(map.get(plan, "sections")), "ELF object relocation symbol index is invalid");
    }
    return true;
}

fn format_elfobj_tables_mut(let plan: map, symbols: list, relocs: list) {
    const kind: u64 = map.get(plan, "kind")
    assert(kind == format_kind_elfobj32 || kind == format_kind_elfobj64, "format plan is not an ELF object");
    assert(format_validate_elfobj_tables(plan, symbols, relocs), "invalid ELF object format API tables");
    map.set_mut(plan, "symbols", symbols);
    map.set_mut(plan, "relocs", relocs);
}

fn format_macho64_public(name: string, section_name: string, section_start: u64, address: u64, symbol_type: u8) -> map {
    assert(len(name) > 0, "Mach-O public symbol name is empty");
    assert(len(section_name) > 0, "Mach-O public symbol requires a section name");
    assert(address >= section_start, "Mach-O public symbol is before its section start");
    assert((symbol_type & macho_n_stab) == 0, "Mach-O format API does not support STAB symbol types");
    assert((symbol_type & macho_n_type) == macho_n_sect, "Mach-O public symbol type must be N_SECT");
    assert((symbol_type & macho_n_ext) != 0, "Mach-O public symbol must be external");

    let symbol: map = map.new()
    map.set_mut(symbol, "kind", format_macho64_symbol_public);
    map.set_mut(symbol, "name", name);
    map.set_mut(symbol, "section", section_name);
    map.set_mut(symbol, "value", address - section_start);
    map.set_mut(symbol, "type", symbol_type);
    return symbol;
}

fn format_macho64_extern(name: string) -> map {
    assert(len(name) > 0, "Mach-O external symbol name is empty");

    let symbol: map = map.new()
    map.set_mut(symbol, "kind", format_macho64_symbol_extern);
    map.set_mut(symbol, "name", name);
    map.set_mut(symbol, "section", "");
    map.set_mut(symbol, "value", 0);
    map.set_mut(symbol, "type", macho_n_undef | macho_n_ext);
    return symbol;
}

fn format_macho64_reloc(section_name: string, section_start: u64, address: u64, symbol_name: string, pcrel: u64, length_power: u64, reloc_type: u64) -> map {
    assert(len(section_name) > 0, "Mach-O relocation requires a section name");
    assert(len(symbol_name) > 0, "Mach-O relocation symbol name is empty");
    assert(address >= section_start, "Mach-O relocation is before its section start");
    assert(pcrel <= 1, "Mach-O relocation pcrel flag exceeds one bit");
    assert(length_power <= 3, "Mach-O relocation length exceeds two bits");

    let reloc: map = map.new()
    map.set_mut(reloc, "section", section_name);
    map.set_mut(reloc, "offset", address - section_start);
    map.set_mut(reloc, "symbol", symbol_name);
    map.set_mut(reloc, "pcrel", pcrel);
    map.set_mut(reloc, "length", length_power);
    map.set_mut(reloc, "type", reloc_type);
    return reloc;
}

fn format_macho64_arm64_reloc(section_name: string, section_start: u64, address: u64, symbol_name: string, reloc_type: u64) -> map {
    let pcrel = 0
    let length_power = 2
    if reloc_type == macho_arm64_reloc_branch26 {
        pcrel = 1;
    }
    if reloc_type == macho_arm64_reloc_page21 {
        pcrel = 1;
    }
    if reloc_type == macho_arm64_reloc_got_load_page21 {
        pcrel = 1;
    }
    if reloc_type == macho_arm64_reloc_tlvp_load_page21 {
        pcrel = 1;
    }
    if reloc_type == macho_arm64_reloc_unsigned {
        length_power = 3;
    }
    assert(
        reloc_type == macho_arm64_reloc_unsigned ||
        reloc_type == macho_arm64_reloc_branch26 ||
        reloc_type == macho_arm64_reloc_page21 ||
        reloc_type == macho_arm64_reloc_pageoff12 ||
        reloc_type == macho_arm64_reloc_got_load_page21 ||
        reloc_type == macho_arm64_reloc_got_load_pageoff12 ||
        reloc_type == macho_arm64_reloc_tlvp_load_page21 ||
        reloc_type == macho_arm64_reloc_tlvp_load_pageoff12,
        "unsupported Mach-O arm64 relocation type"
    );
    return format_macho64_reloc(section_name, section_start, address, symbol_name, pcrel, length_power, reloc_type);
}

fn format_macho64_symbol_index(symbols: list, name: string) -> u64 {
    for i in range(0, len(symbols)) {
        const symbol: map = list.get(symbols, i)
        if map.get(symbol, "name") == name {
            return i;
        }
    }
    assert(false, "Mach-O relocation target symbol is not declared");
    return 0;
}

fn format_macho64_symbol_names(symbols: list) -> list {
    let names = list.new()
    for symbol in symbols {
        list.push_mut(names, map.get(symbol, "name"));
    }
    return names;
}

fn format_macho64_reloc_count_for_section(relocs: list, section_name: string) -> u64 {
    let count = 0
    for reloc in relocs {
        if map.get(reloc, "section") == section_name {
            count = count + 1
        }
    }
    return count;
}

fn format_validate_macho64_tables(plan: map, symbols: list, relocs: list) -> bool {
    assert(map.get(plan, "kind") == format_kind_macho64_object, "format plan is not a Mach-O object");
    assert(len(symbols) > 0, "Mach-O format API requires at least one symbol");
    for i in range(0, len(symbols)) {
        const symbol: map = list.get(symbols, i)
        const name: string = map.get(symbol, "name")
        const symbol_kind: u64 = map.get(symbol, "kind")
        const symbol_type: u64 = map.get(symbol, "type")
        assert(len(name) > 0, "Mach-O symbol name is empty");
        assert(
            symbol_kind == format_macho64_symbol_public ||
            symbol_kind == format_macho64_symbol_extern,
            "unknown Mach-O format symbol kind"
        );
        if symbol_kind == format_macho64_symbol_public {
            const section_row: u64 = format_section_row(plan, map.get(symbol, "section"))
            assert(section_row < len(map.get(plan, "sections")), "Mach-O public symbol section is invalid");
            assert((symbol_type & macho_n_stab) == 0, "Mach-O format API does not support STAB symbol types");
            assert((symbol_type & macho_n_type) == macho_n_sect, "Mach-O public symbol type must be N_SECT");
            assert((symbol_type & macho_n_ext) != 0, "Mach-O public symbol must be external");
        }
        if symbol_kind == format_macho64_symbol_extern {
            assert(symbol_type == (macho_n_undef | macho_n_ext), "Mach-O external symbol type must be N_UNDF | N_EXT");
        }
        for j in range(i + 1, len(symbols)) {
            const other: map = list.get(symbols, j)
            assert(map.get(other, "name") != name, "Mach-O symbol name is duplicated");
        }
    }
    for reloc in relocs {
        const section_row: u64 = format_section_row(plan, map.get(reloc, "section"))
        const symbol_index: u64 = format_macho64_symbol_index(symbols, map.get(reloc, "symbol"))
        assert(section_row < len(map.get(plan, "sections")), "Mach-O relocation section is invalid");
        assert(symbol_index < len(symbols), "Mach-O relocation symbol index is invalid");
    }
    return true;
}

fn format_macho64_tables_mut(let plan: map, symbols: list, relocs: list) {
    assert(format_validate_macho64_tables(plan, symbols, relocs), "invalid Mach-O format API tables");
    map.set_mut(plan, "symbols", symbols);
    map.set_mut(plan, "relocs", relocs);
}

fn format_segment(name: string, attributes: u64) -> map {
    assert(len(name) > 0, "format segment name is empty");
    assert((attributes & ~(format_segment_purpose_mask | format_segment_permission_mask)) == 0, "unknown format segment attribute");

    const purpose: u64 = attributes & format_segment_purpose_mask
    assert(purpose != 0, "format segment requires one purpose");
    assert((purpose & (purpose - 1)) == 0, "format segment has multiple purposes");

    let segment: map = map.new()
    map.set_mut(segment, "name", name);
    map.set_mut(segment, "attributes", attributes);
    return segment;
}

fn format_validate_segments(segments: list) -> bool {
    assert(len(segments) > 0, "format plan requires at least one segment");
    assert(len(segments) <= 65535, "format plan has too many ELF segments");

    for i in range(0, len(segments)) {
        const current: map = list.get(segments, i)
        const current_name: string = map.get(current, "name")

        assert(len(current_name) > 0, "format segment name is empty");

        for j in range(i + 1, len(segments)) {
            const other: map = list.get(segments, j)
            assert(map.get(other, "name") != current_name, "format segment name is duplicated");
        }
    }

    return true;
}

fn format_validate_elf_options(kind: u64, options: u64) -> bool {
    assert((options & ~format_elf_option_mask) == 0, "unknown ELF format option");
    assert(options != 0, "ELF format requires executable or PIE mode");
    assert((options & (options - 1)) == 0, "ELF format has multiple file modes");
    if kind == format_kind_elf32 {
        assert(options == format_elf_exec, "format.inc ELF32 layer currently supports executable mode");
    }
    return true;
}

fn format_elf_plan(kind: u64, options: u64, segments: list) -> map {
    assert(format_validate_elf_options(kind, options), "invalid ELF format options");
    assert(format_validate_segments(segments), "invalid ELF segment list");

    let machine: u16 = elf_machine_386
    if kind == format_kind_elf64 {
        machine = elf_machine_x86_64;
    }

    let plan: map = map.new()
    map.set_mut(plan, "kind", kind);
    map.set_mut(plan, "options", options);
    map.set_mut(plan, "segments", segments);
    map.set_mut(plan, "machine", machine);
    map.set_mut(plan, "load_align", elf_default_page_align);
    map.set_mut(plan, "entry", 0);
    map.set_mut(plan, "imports", list.new());
    return plan;
}

fn format_elf32(options: u64, segments: list) -> map {
    return format_elf_plan(format_kind_elf32, options, segments);
}

// ELF64 executable or PIE for a chosen machine. Imports stay x86-64 only,
// because the executable import path is built on PLT entries; AArch64 imports
// use the shared-object GLOB_DAT path instead. AArch64 defaults to the 16 KiB
// page alignment that Android devices require; set "load_align" on the plan
// before format_begin to choose another page size.
fn format_elf64_machine(options: u64, segments: list, machine: u16) -> map {
    assert(machine == elf_machine_x86_64 || machine == elf_machine_aarch64, "unsupported ELF64 machine");
    let plan: map = format_elf_plan(format_kind_elf64, options, segments)
    map.set_mut(plan, "machine", machine);
    let load_align: u64 = elf_default_page_align
    if machine == elf_machine_aarch64 {
        load_align = elf_android_page_align;
    }
    map.set_mut(plan, "load_align", load_align);
    return plan;
}

fn format_elf64(options: u64, segments: list) -> map {
    return format_elf64_machine(options, segments, elf_machine_x86_64);
}

fn format_elf64_aarch64(options: u64, segments: list) -> map {
    return format_elf64_machine(options, segments, elf_machine_aarch64);
}

fn format_elfexe_import_new() -> list {
    return elfexe_import_new();
}

fn format_elfexe_import_many_mut(let imports: list, library: string, names: list) {
    imports = elfexe_import_use64_plt_many(imports, library, names);
}

fn format_elfexe_import_pairs_mut(let imports: list, library: string, pairs: list) {
    imports = elfexe_import_use64_plt_pairs(imports, library, pairs);
}

fn format_validate_elfexe_tables(plan: map, imports: list) -> bool {
    assert(map.get(plan, "kind") == format_kind_elf64, "ELF executable imports require ELF64");
    assert(map.get(plan, "options") == format_elf_exec, "ELF executable imports require fixed-address EXEC mode");
    assert(map.get(plan, "machine") == elf_machine_x86_64, "ELF executable imports are x86-64 only; use an AArch64 shared object for GLOB_DAT imports");
    assert(len(imports) > 0, "ELF executable import table is empty");

    const segments: list = map.get(plan, "segments")
    for segment in segments {
        assert(map.get(segment, "name") != ".elfexe.plt", "ELF executable segment uses a reserved internal name");
        assert(map.get(segment, "name") != ".elfexe.imports", "ELF executable segment uses a reserved internal name");
    }

    for i in range(0, len(imports)) {
        const current: map = list.get(imports, i)
        const current_slot: string = map.get(current, "slot")
        const current_plt: string = map.get(current, "plt")
        for j in range(i + 1, len(imports)) {
            const other: map = list.get(imports, j)
            assert(map.get(other, "slot") != current_slot, "ELF executable import slot is duplicated");
            assert(map.get(other, "plt") != current_plt, "ELF executable import PLT label is duplicated");
        }
    }
    return true;
}

fn format_elfexe_tables_mut(let plan: map, imports: list) {
    assert(format_validate_elfexe_tables(plan, imports), "invalid ELF executable import table");
    map.set_mut(plan, "imports", imports);
}

// ELF64 shared object for a chosen machine. x86-64 accepts PLT and GOT
// imports; AArch64 uses GLOB_DAT slots.
fn format_elf64_so_machine(soname: string, segments: list, machine: u16) -> map {
    assert(elf_validate_c_name(soname), "invalid ELF shared-object SONAME");
    assert(len(soname) > 0, "ELF shared object SONAME is empty");
    assert(format_validate_segments(segments), "invalid ELF shared-object segment list");
    assert(machine == elf_machine_x86_64 || machine == elf_machine_aarch64, "unsupported ELF shared-object machine");

    let plan: map = map.new()
    map.set_mut(plan, "kind", format_kind_elfso64);
    map.set_mut(plan, "options", 0);
    map.set_mut(plan, "segments", segments);
    map.set_mut(plan, "soname", soname);
    map.set_mut(plan, "exports", list.new());
    map.set_mut(plan, "imports", list.new());
    map.set_mut(plan, "entry", 0);
    map.set_mut(plan, "machine", machine);
    let load_align: u64 = elf_default_page_align
    if machine == elf_machine_aarch64 {
        load_align = elf_android_page_align;
    }
    map.set_mut(plan, "load_align", load_align);
    return plan;
}

fn format_elf64_so(soname: string, segments: list) -> map {
    return format_elf64_so_machine(soname, segments, elf_machine_x86_64);
}

// Android-ready AArch64 shared-object plan: 16 KiB LOAD alignment, which the
// platform page size requires.
fn format_elf64_so_aarch64(soname: string, segments: list) -> map {
    return format_elf64_so_machine(soname, segments, elf_machine_aarch64);
}

fn format_elfso_export_new() -> list {
    return list.new();
}

fn format_elfso_export_many_mut(let exports: list, names: list, segment_name: string, symbol_size: u64) {
    assert(len(segment_name) > 0, "ELF shared-object export segment name is empty");
    assert(symbol_size > 0, "ELF shared-object export size is zero");
    for name in names {
        assert(len(name) > 0, "ELF shared-object export name is empty");
        let entry: map = map.new()
        map.set_mut(entry, "target", name);
        map.set_mut(entry, "name", name);
        map.set_mut(entry, "segment", segment_name);
        map.set_mut(entry, "size", symbol_size);
        list.push_mut(exports, entry);
    }
}

fn format_elfso_export_pairs_mut(let exports: list, pairs: list, segment_name: string, symbol_size: u64) {
    assert(len(pairs) % 2 == 0, "ELF shared-object export pairs require target/name entries");
    assert(len(pairs) <= 128, "ELF shared-object export pairs exceed the batch limit");
    assert(len(segment_name) > 0, "ELF shared-object export segment name is empty");
    assert(symbol_size > 0, "ELF shared-object export size is zero");
    let index: u64 = 0
    while index < len(pairs) {
        const target_label: string = list.get(pairs, index)
        const export_name: string = list.get(pairs, index + 1)
        assert(len(target_label) > 0, "ELF shared-object export target label is empty");
        assert(len(export_name) > 0, "ELF shared-object export name is empty");
        let entry: map = map.new()
        map.set_mut(entry, "target", target_label);
        map.set_mut(entry, "name", export_name);
        map.set_mut(entry, "segment", segment_name);
        map.set_mut(entry, "size", symbol_size);
        list.push_mut(exports, entry);
        index = index + 2
    }
}

fn format_elfso_import_new() -> list {
    return elfso_import_new();
}

fn format_elfso_import_many_mut(let imports: list, library: string, names: list) {
    imports = elfso_import_use64_plt_many(imports, library, names);
}

fn format_elfso_import_pairs_mut(let imports: list, library: string, pairs: list) {
    imports = elfso_import_use64_plt_pairs(imports, library, pairs);
}

fn format_elfso_import_slots_mut(let imports: list, library: string, names: list) {
    imports = elfso_import_use64_many(imports, library, names);
}

fn format_validate_elfso_tables(plan: map, exports: list, imports: list) -> bool {
    assert(map.get(plan, "kind") == format_kind_elfso64, "format plan is not an ELF64 shared object");
    assert(len(exports) > 0, "ELF shared-object format API requires at least one export");

    for segment in map.get(plan, "segments") {
        const name: string = map.get(segment, "name")
        for reserved in list.of(".elfso.plt", ".elfso.metadata", ".plt", ".got", ".got.plt", ".rela.dyn", ".rela.plt", ".dynsym", ".dynstr", ".hash", ".dynamic", ".shstrtab") {
            assert(name != reserved, "ELF shared-object segment uses a reserved internal name");
        }
    }

    for i in range(0, len(exports)) {
        const export0: map = list.get(exports, i)
        const export_name: string = map.get(export0, "name")
        assert(elf_validate_c_name(export_name), "invalid ELF shared-object export name");
        const segment_row: u64 = format_segment_row(plan, map.get(export0, "segment"))
        assert(segment_row < len(map.get(plan, "segments")), "ELF shared-object export segment is invalid");
        for j in range(i + 1, len(exports)) {
            const other: map = list.get(exports, j)
            assert(map.get(other, "name") != export_name, "ELF shared-object export name is duplicated");
        }
    }

    for i in range(0, len(imports)) {
        const import0: map = list.get(imports, i)
        const import_name: string = map.get(import0, "name")
        const slot_name: string = map.get(import0, "slot")
        const plt_name: string = map.get_or(import0, "plt", "")
        if map.get(plan, "machine") == elf_machine_aarch64 {
            assert(plt_name == "", "AArch64 shared-object imports require GOT slots");
        }
        for export0 in exports {
            assert(map.get(export0, "name") != import_name, "ELF shared-object symbol cannot be both imported and exported");
        }
        for j in range(i + 1, len(imports)) {
            const other: map = list.get(imports, j)
            assert(map.get(other, "slot") != slot_name, "ELF shared-object import slot is duplicated");
            // AArch64 imports carry GOT slots and no PLT label; only compare the
            // labels the entries actually have.
            const other_plt: string = map.get_or(other, "plt", "")
            if plt_name != "" && other_plt != "" {
                assert(other_plt != plt_name, "ELF shared-object import PLT label is duplicated");
            }
        }
    }
    return true;
}

fn format_elfso_tables_mut(let plan: map, exports: list, imports: list) {
    assert(format_validate_elfso_tables(plan, exports, imports), "invalid ELF shared-object format API tables");
    map.set_mut(plan, "exports", exports);
    map.set_mut(plan, "imports", imports);
}

fn format_entry_mut(let plan: map, address: u64) {
    const kind: u64 = map.get(plan, "kind")
    assert(
        kind == format_kind_pe32 ||
        kind == format_kind_pe64 ||
        kind == format_kind_elf32 ||
        kind == format_kind_elf64 ||
        kind == format_kind_macho64_execute,
        "format plan does not use an executable entry"
    );
    assert(address != 0, "format entry address is zero");
    map.set_mut(plan, "entry", address);
}

fn format_section_row(plan: map, name: string) -> u64 {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_macho64_object || kind == format_kind_macho64_execute || kind == format_kind_macho64_dylib {
        return format_macho64_section_row(plan, "", name);
    }
    // An ELF image plan declares load segments and carries no "sections" key,
    // so without this guard the lookup below fails on the missing key and the
    // real mistake never reaches the user.
    assert(
        kind != format_kind_elf32 && kind != format_kind_elf64 && kind != format_kind_elfso64,
        "an ELF image plan declares segments, not sections"
    );
    const sections: list = map.get(plan, "sections")
    for i in range(0, len(sections)) {
        const section: map = list.get(sections, i)
        if map.get(section, "name") == name {
            return i;
        }
    }
    assert(false, "format section is not declared");
    return 0;
}

fn format_macho64_section_row(plan: map, segment_name: string, name: string) -> u64 {
    const kind: u64 = map.get(plan, "kind")
    assert(kind == format_kind_macho64_object || kind == format_kind_macho64_execute || kind == format_kind_macho64_dylib, "Mach-O section lookup requires a Mach-O plan");
    const sections: list = map.get(plan, "sections")
    let row: u64 = len(sections)
    for i in range(0, len(sections)) {
        const section: map = list.get(sections, i)
        if map.get(section, "name") == name && (segment_name == "" || map.get(section, "segment") == segment_name) {
            assert(row == len(sections), "Mach-O section name is ambiguous; specify its segment");
            row = i;
        }
    }
    assert(row < len(sections), "Mach-O section is not declared");
    return row;
}

fn format_section_purpose(plan: map, name: string) -> u64 {
    const row: u64 = format_section_row(plan, name)
    const sections: list = map.get(plan, "sections")
    const section: map = list.get(sections, row)
    const attributes: u64 = map.get(section, "attributes")
    return attributes & format_section_purpose_mask;
}

fn format_segment_row(plan: map, name: string) -> u64 {
    // Mirror of the guard in format_section_row: only the ELF image kinds carry
    // a "segments" key, and PE, COFF, ELF-object and Mach-O plans do not.
    const kind: u64 = map.get(plan, "kind")
    assert(
        kind == format_kind_elf32 || kind == format_kind_elf64 || kind == format_kind_elfso64,
        "only an ELF image plan declares segments"
    );
    const segments: list = map.get(plan, "segments")
    for i in range(0, len(segments)) {
        const segment: map = list.get(segments, i)
        if map.get(segment, "name") == name {
            return i;
        }
    }
    assert(false, "format segment is not declared");
    return 0;
}

// Round `potential_offset` up so the result is congruent to `file_offset`
// modulo `page`. A LOAD segment must satisfy that relation for the alignment it
// declares, so the page size is a parameter rather than the 4 KiB default: a
// 16 KiB target (Android on AArch64) needs the same relation modulo 16 KiB.
fn format_elf_logical_offset_page(file_offset: u64, potential_offset: u64, page: u64) -> u64 {
    assert(page >= 1 && (page & (page - 1)) == 0, "ELF page alignment must be a power of two");
    const file_mod: u64 = file_offset % page
    const potential_mod: u64 = potential_offset % page
    let delta = 0
    if potential_mod <= file_mod {
        delta = file_mod - potential_mod
    }
    if potential_mod > file_mod {
        delta = page - (potential_mod - file_mod)
    }
    return potential_offset + delta;
}

fn format_elf_logical_offset(file_offset: u64, potential_offset: u64) -> u64 {
    return format_elf_logical_offset_page(file_offset, potential_offset, elf_default_page_align);
}

fn format_elf_next_logical_offset_page(image_base: u64, file_offset: u64, page: u64) -> u64 {
    let potential_offset = file_cursor_potential()
    const current: u64 = here()
    if current >= image_base {
        const current_offset: u64 = current - image_base
        if current_offset > potential_offset {
            potential_offset = current_offset
        }
    }
    return format_elf_logical_offset_page(file_offset, potential_offset, page);
}

fn format_elf_next_logical_offset(image_base: u64, file_offset: u64) -> u64 {
    return format_elf_next_logical_offset_page(image_base, file_offset, elf_default_page_align);
}

fn format_elf_next_load_logical_offset(image_base: u64, file_offset: u64, separate_page: u64) -> u64 {
    return format_elf_next_load_logical_offset_page(image_base, file_offset, separate_page, elf_default_page_align);
}

fn format_elf_next_load_logical_offset_page(image_base: u64, file_offset: u64, separate_page: u64, page: u64) -> u64 {
    let logical_offset = format_elf_next_logical_offset_page(image_base, file_offset, page)
    if separate_page == 0 {
        return logical_offset;
    }

    const current: u64 = here()
    if current <= image_base {
        return logical_offset;
    }

    const current_offset: u64 = current - image_base
    const previous_page: u64 = (current_offset - 1) / page
    if logical_offset / page <= previous_page {
        logical_offset = logical_offset + page
    }
    return logical_offset;
}

fn format_elf_segment_flags(attributes: u64) -> u64 {
    let flags = 0
    if (attributes & format_readable) != 0 {
        flags = flags | elf_pf_r
    }
    if (attributes & format_writeable) != 0 {
        flags = flags | elf_pf_w
    }
    if (attributes & format_executable) != 0 {
        flags = flags | elf_pf_x
    }
    return flags;
}

fn format_elfobj_section_flags(attributes: u64) -> u64 {
    let flags = elf_shf_alloc
    if (attributes & format_writeable) != 0 {
        flags = flags | elf_shf_write
    }
    if (attributes & format_executable) != 0 {
        flags = flags | elf_shf_execinstr
    }
    return flags;
}

fn format_elfobj_section_type(attributes: u64) -> u64 {
    const purpose: u64 = attributes & format_section_purpose_mask
    if purpose == format_uninitialized_data {
        return elf_sht_nobits;
    }
    return elf_sht_progbits;
}

fn format_elfobj_section_alignment(kind: u64, attributes: u64) -> u64 {
    const purpose: u64 = attributes & format_section_purpose_mask
    if purpose == format_code {
        return 16;
    }
    if kind == format_kind_elfobj64 {
        return 8;
    }
    return 4;
}

fn format_elfobj_section_start_label(name: string) -> string {
    return sym.join("__xirasm_elfobj_start", name);
}

fn format_pe_section_start_label(name: string) -> string {
    return sym.join("__xirasm_pe_start", name);
}

fn format_macho64_section_start_label(section: map) -> string {
    return sym.join(map.get(section, "key"), "_start");
}

fn format_macho64_section_end_label(section: map) -> string {
    return sym.join(map.get(section, "key"), "_end");
}

fn format_macho64_segment_command_label(name: string) -> string {
    return sym.join("__xirasm_macho64_segment_command", name);
}

fn format_macho64_section_command_label(section: map) -> string {
    return sym.join(map.get(section, "key"), "_command");
}

fn format_macho64_section_segment_name(attributes: u64) -> string {
    if (attributes & format_code) != 0 {
        return "__TEXT";
    }
    return "__DATA";
}

fn format_macho64_section_flags(attributes: u64) -> u64 {
    if (attributes & format_code) != 0 {
        return macho_s_regular | macho_s_attr_pure_instructions | macho_s_attr_some_instructions;
    }
    if (attributes & format_uninitialized_data) != 0 {
        return macho_s_zerofill;
    }
    return macho_s_regular;
}

fn format_macho64_segment_prot(attributes: u64) -> u64 {
    let prot: u64 = 0
    if (attributes & format_readable) != 0 {
        prot = prot | macho_vm_prot_read;
    }
    if (attributes & format_writeable) != 0 {
        prot = prot | macho_vm_prot_write;
    }
    if (attributes & format_executable) != 0 {
        prot = prot | macho_vm_prot_execute;
    }
    return prot;
}

fn format_macho64_section_align_power(target: map, attributes: u64) -> u64 {
    if (attributes & format_code) != 0 {
        if map.get(target, "cpu_type") == macho_cpu_type_arm64 {
            return 2;
        }
        return 4;
    }
    return 3;
}

fn format_elfobj_section_end_label(name: string) -> string {
    return sym.join("__xirasm_elfobj_end", name);
}

fn format_elfso_segment_start_label(name: string) -> string {
    return sym.join("__xirasm_elfso_start", name);
}

fn format_elfso_segment_end_label(name: string) -> string {
    return sym.join("__xirasm_elfso_end", name);
}

fn format_elfso_section_flags(attributes: u64) -> u64 {
    let flags = elf_shf_alloc
    if (attributes & format_writeable) != 0 {
        flags = flags | elf_shf_write
    }
    if (attributes & format_executable) != 0 {
        flags = flags | elf_shf_execinstr
    }
    return flags;
}

fn format_elfso_section_alignment(attributes: u64) -> u64 {
    if (attributes & format_executable) != 0 {
        return 16;
    }
    return 8;
}

fn format_pe_section_chars(attributes: u64) -> u64 {
    let chars = 0
    const purpose: u64 = attributes & format_section_purpose_mask

    if purpose == format_code {
        chars = chars | pe_scn_cnt_code
    }
    if purpose == format_uninitialized_data {
        chars = chars | pe_scn_cnt_uninit_data
    }
    if purpose != format_code && purpose != format_uninitialized_data {
        chars = chars | pe_scn_cnt_init_data
    }
    if (attributes & format_readable) != 0 {
        chars = chars | pe_scn_mem_read
    }
    if (attributes & format_writeable) != 0 {
        chars = chars | pe_scn_mem_write
    }
    if (attributes & format_executable) != 0 {
        chars = chars | pe_scn_mem_execute
    }
    if (attributes & format_discardable) != 0 || purpose == format_fixups {
        chars = chars | pe_scn_mem_discardable
    }

    return chars;
}

fn format_coff_section_chars(attributes: u64) -> u64 {
    let chars = 0
    const purpose: u64 = attributes & format_section_purpose_mask
    if purpose == format_code {
        chars = chars | coff_scn_cnt_code | coff_scn_align_16bytes
    }
    if purpose == format_data {
        chars = chars | coff_scn_cnt_init_data | coff_scn_align_4bytes
    }
    if purpose == format_uninitialized_data {
        chars = chars | coff_scn_cnt_uninit_data | coff_scn_align_4bytes
    }
    if (attributes & format_readable) != 0 {
        chars = chars | coff_scn_mem_read
    }
    if (attributes & format_writeable) != 0 {
        chars = chars | coff_scn_mem_write
    }
    if (attributes & format_executable) != 0 {
        chars = chars | coff_scn_mem_execute
    }
    return chars;
}

fn format_has_section_purpose(sections: list, purpose: u64) -> bool {
    for section in sections {
        if (map.get(section, "attributes") & purpose) != 0 {
            return true;
        }
    }
    return false;
}

fn format_pe_subsystem(options: u64) -> u64 {
    if (options & format_pe_gui) != 0 {
        return pe_subsystem_gui;
    }
    return pe_subsystem_console;
}

fn format_pe_dll_chars(kind: u64, options: u64, sections: list) -> u64 {
    let chars = 0
    if (options & format_pe_nx) != 0 {
        chars = chars | pe_dll_nx_compat
    }

    const has_fixups: bool = format_has_section_purpose(sections, format_fixups)
    if (options & format_pe_aslr_required) != 0 {
        assert(has_fixups, "PE ASLR required needs a fixups section");
    }
    if (options & format_pe_aslr_disabled) == 0 && has_fixups {
        chars = chars | pe_dll_dynamic_base
        if kind == format_kind_pe64 {
            chars = chars | pe_dll_high_entropy_va
        }
    }

    return chars;
}

fn format_pe_emit_section_rows(sections: list) {
    for section in sections {
        const name: string = map.get(section, "name")
        db(name);
        pad(8 - len(name), 0);
        emit.u32(0);
        emit.u32(0);
        emit.u32(0);
        emit.u32(0);
        emit.u32(0);
        emit.u32(0);
        emit.u16(0);
        emit.u16(0);
        emit.u32(0);
    }
}

fn format_pe_begin32(options: u64, sections: list) {
    const section_count: u64 = len(sections)
    const subsystem: u64 = format_pe_subsystem(options)
    const dll_chars: u64 = format_pe_dll_chars(format_kind_pe32, options, sections)

    x86.use32();
    pe_begin32();

    let characteristics = pe_file_executable_image | pe_file_32bit_machine
    if (options & format_pe_dll) != 0 {
        characteristics = characteristics | pe_file_dll
    }
    emit.struct(PeFileHeader32 { sections: section_count, characteristics: characteristics });
    emit.struct(PeOptionalHeader32A {});
    emit.struct(PeOptionalHeader32B { subsystem: subsystem, dll_chars: dll_chars });

    for i in range(0, pe_data_dir_count) {
        emit.struct(PeDataDir {});
    }
    format_pe_emit_section_rows(sections);
    align(pe_default_file_align, 0);
    const header_size: u64 = file_offset()
    defer {
        store.u32(region_base() + pe_opt_size_of_headers_foa, header_size);
    }
}

fn format_pe_begin64(options: u64, sections: list, machine: u16) {
    const section_count: u64 = len(sections)
    const subsystem: u64 = format_pe_subsystem(options)
    const dll_chars: u64 = format_pe_dll_chars(format_kind_pe64, options, sections)

    if machine == pe_machine_amd64 {
        x86.use64();
    }
    pe_begin64();

    let characteristics = pe_file_executable_image | pe_file_large_address_aware
    if (options & format_pe_dll) != 0 {
        characteristics = characteristics | pe_file_dll
    }
    emit.struct(PeFileHeader64 { machine: machine, sections: section_count, characteristics: characteristics });
    emit.struct(PeOptionalHeader64A {});
    emit.struct(PeOptionalHeader64B { subsystem: subsystem, dll_chars: dll_chars });

    for i in range(0, pe_data_dir_count) {
        emit.struct(PeDataDir {});
    }
    format_pe_emit_section_rows(sections);
    align(pe_default_file_align, 0);
    const header_size: u64 = file_offset()
    defer {
        store.u32(region_base() + pe_opt_size_of_headers_foa, header_size);
    }
}

fn format_coff_emit_section_rows(sections: list) {
    for section in sections {
        const name: string = map.get(section, "name")
        db(name);
        pad(8 - len(name), 0);
        emit.u32(0);
        emit.u32(0);
        emit.u32(0);
        emit.u32(0);
        emit.u32(0);
        emit.u32(0);
        emit.u16(0);
        emit.u16(0);
        emit.u32(0);
    }
}

fn format_coff_begin_file(machine: u16, characteristics: u16, sections: list) {
    coff_file:
    emit.struct(CoffFileHeader {
        machine: machine,
        sections: len(sections),
        symbol_ptr: 0,
        symbol_count: 1,
        characteristics: characteristics,
    });
    coff_sections:
    format_coff_emit_section_rows(sections);
}

fn format_coff_begin32(sections: list) {
    x86.use32();
    format_coff_begin_file(
        coff_machine_i386,
        coff_file_32bit_machine | coff_file_line_nums_stripped,
        sections
    );
}

fn format_coff_begin64(sections: list, machine: u16) {
    if machine == coff_machine_amd64 {
        x86.use64();
    }
    format_coff_begin_file(machine, coff_file_line_nums_stripped, sections);
}

fn format_elfobj_begin32() {
    x86.use32();
    elfobj_begin32_deferred();
    align(16);
}

fn format_elfobj_begin64(plan: map) {
    const machine: u64 = map.get(plan, "machine")
    assert(machine == elf_machine_x86_64 || machine == elf_machine_aarch64, "unsupported ELF64 object machine");
    if machine == elf_machine_x86_64 {
        x86.use64();
    }
    elfobj_begin64_deferred_machine(machine);
    align(16);
}

fn format_coff_finalize_section_row(row: u64, start: u64, chars: u64, purpose: u64) {
    defer {
        let raw_size = region_file_size(start)
        let raw_ptr = region_file_offset(start)
        if purpose == format_uninitialized_data {
            raw_size = region_logical_size(start)
            raw_ptr = 0
        }
        store.u32(coff_sections + row * coff_section_header_size + coff_sec_raw_size_foa, raw_size);
        store.u32(coff_sections + row * coff_section_header_size + coff_sec_raw_ptr_foa, raw_ptr);
        store.u32(coff_sections + row * coff_section_header_size + coff_sec_chars_foa, chars);
    }
}

fn format_elfso_finalize_first_load_region(start: u64, flags: u64, load_align: u64) {
    defer {
        const start_offset: u64 = region_file_offset(start)
        const file_size: u64 = start_offset + region_file_size(start)
        let memory_size = start_offset + region_logical_size(start)
        if memory_size < file_size {
            memory_size = file_size
        }
        store.u32(region_base() + elfso64_phdr_foa(0) + elfso64_phdr_type_foa, elf_pt_load);
        store.u32(region_base() + elfso64_phdr_foa(0) + elfso64_phdr_flags_foa, flags);
        store.u64(region_base() + elfso64_phdr_foa(0) + elfso64_phdr_offset_foa, 0);
        store.u64(region_base() + elfso64_phdr_foa(0) + elfso64_phdr_vaddr_foa, 0);
        store.u64(region_base() + elfso64_phdr_foa(0) + elfso64_phdr_paddr_foa, 0);
        store.u64(region_base() + elfso64_phdr_foa(0) + elfso64_phdr_filesz_foa, file_size);
        store.u64(region_base() + elfso64_phdr_foa(0) + elfso64_phdr_memsz_foa, memory_size);
        store.u64(region_base() + elfso64_phdr_foa(0) + elfso64_phdr_align_foa, load_align);
    }
}

fn format_elfso_finalize_load_region(row: u64, start: u64, flags: u64, load_align: u64) {
    defer {
        const offset: u64 = region_file_offset(start)
        const file_size: u64 = region_file_size(start)
        let memory_size = region_logical_size(start)
        if memory_size < file_size {
            memory_size = file_size
        }
        store.u32(region_base() + elfso64_phdr_foa(row) + elfso64_phdr_type_foa, elf_pt_load);
        store.u32(region_base() + elfso64_phdr_foa(row) + elfso64_phdr_flags_foa, flags);
        store.u64(region_base() + elfso64_phdr_foa(row) + elfso64_phdr_offset_foa, offset);
        store.u64(region_base() + elfso64_phdr_foa(row) + elfso64_phdr_vaddr_foa, start);
        store.u64(region_base() + elfso64_phdr_foa(row) + elfso64_phdr_paddr_foa, start);
        store.u64(region_base() + elfso64_phdr_foa(row) + elfso64_phdr_filesz_foa, file_size);
        store.u64(region_base() + elfso64_phdr_foa(row) + elfso64_phdr_memsz_foa, memory_size);
        store.u64(region_base() + elfso64_phdr_foa(row) + elfso64_phdr_align_foa, load_align);
        assert(start % load_align == offset % load_align, "ELF LOAD virtual and file offsets are not page congruent");
    }
}

fn format_elfso_finalize_section_region(row_address: u64, start: u64, end: u64) {
    defer {
        if region_file_size(start) == 0 && end > start {
            store.u32(row_address + elfso_sh_type_foa, elf_sht_nobits);
        }
        store.u64(row_address + elfso64_sh_addr_foa, start);
        store.u64(row_address + elfso64_sh_offset_foa, region_file_offset(start));
        store.u64(row_address + elfso64_sh_size_foa, end - start);
    }
}

fn format_elfso_finalize_header64(section_table_foa: u64, section_count: u64, shstrndx: u64) {
    defer {
        store.u64(region_base() + elfso64_shoff_foa, section_table_foa);
        store.u16(region_base() + elfso64_shnum_foa, section_count);
        store.u16(region_base() + elfso64_shstrndx_foa, shstrndx);
    }
}

fn format_elf_begin32(segments: list) {
    elfexe_begin32(len(segments));
    align(16);
}

fn format_elf_begin64(plan: map) {
    const options: u64 = map.get(plan, "options")
    const segments: list = map.get(plan, "segments")
    const imports: list = map.get(plan, "imports")
    const machine: u64 = map.get(plan, "machine")
    assert(machine == elf_machine_x86_64 || machine == elf_machine_aarch64, "unsupported ELF64 machine");
    let segment_count = len(segments)
    if len(imports) > 0 {
        assert(machine == elf_machine_x86_64, "ELF executable imports are x86-64 only; use an AArch64 shared object for GLOB_DAT imports");
        segment_count = segment_count + 4
    }
    if machine == elf_machine_x86_64 {
        x86.use64();
    }
    if options == format_elf_exec {
        elfexe_begin64_at(segment_count, elf_type_exec, elf_default_base64, machine);
        align(16);
    }
    if options == format_elf_pie {
        elfexe_begin64_at(segment_count, elf_type_dyn, 0, machine);
        align(16);
    }
}

fn format_elfso_begin64(plan: map) {
    const segments: list = map.get(plan, "segments")
    const imports: list = map.get(plan, "imports")
    const machine: u64 = map.get(plan, "machine")
    assert(machine == elf_machine_x86_64 || machine == elf_machine_aarch64, "unsupported ELF shared-object machine");
    let ph_count = len(segments) + 2
    if len(imports) > 0 && format_elfso_uses_plt(plan) {
        ph_count = ph_count + 1
    }
    if machine == elf_machine_x86_64 {
        x86.use64();
    }
    elfso_begin64_machine(machine, ph_count, 0, 1, 0);
    align(16);
}

fn format_macho64_header_subtype(plan: map) -> u64 {
    const kind: u64 = map.get(plan, "kind")
    const target: map = map.get(plan, "target")
    const cpu_type: u64 = map.get(target, "cpu_type")
    let cpu_subtype: u64 = map.get(target, "cpu_subtype")
    if kind == format_kind_macho64_execute && cpu_type == macho_cpu_type_x86_64 {
        if cpu_subtype == macho_cpu_subtype_x86_64_all {
            if map.get(target, "minos") >= macho_exe_macos_version(10, 5, 0) {
                cpu_subtype = cpu_subtype | macho_cpu_subtype_lib64;
            }
        }
    }
    return cpu_subtype;
}

fn format_macho64_segments_command_size(segments: list) -> u64 {
    let size: u64 = 0
    for segment in segments {
        size = size + macho_segment_command64_size_for(len(map.get(segment, "sections")));
    }
    return size;
}

fn format_macho64_emit_segments(let plan: map) {
    const target: map = map.get(plan, "target")
    const segments: list = map.get(plan, "segments")
    for i in range(0, len(segments)) {
        let segment: map = list.get(segments, i)
        const attributes: u64 = map.get(segment, "attributes")
        const prot: u64 = format_macho64_segment_prot(attributes)
        const sections: list = map.get(segment, "sections")
        label.define(format_macho64_segment_command_label(map.get(segment, "name")));
        macho_segment64(map.get(segment, "name"), 0, 0, 0, 0, prot, prot, len(sections), 0);
        for j in range(0, len(sections)) {
            let section: map = list.get(sections, j)
            const section_attributes: u64 = map.get(section, "attributes")
            label.define(format_macho64_section_command_label(section));
            macho_section64(
                map.get(section, "name"), map.get(segment, "name"), 0, 0, 0,
                format_macho64_section_align_power(target, section_attributes),
                0, 0, format_macho64_section_flags(section_attributes), 0, 0, 0
            );
        }
    }
}

fn format_macho64_begin_object(let plan: map) {
    const target: map = map.get(plan, "target")
    const sections: list = map.get(plan, "sections")
    // The LC_SYMTAB slot is reserved here because the command count and size
    // are final once the header is emitted; its fields are backfilled at finish.
    const command_count: u64 = 3
    const command_size: u64 = macho_segment_command64_size_for(len(sections)) + macho_exe_build_version_command_size + macho_symtab_command_size
    const content_foa: u64 = macho_header64_size + command_size

    region.begin(".xirasm.macho.header", 0, 0);
    label.define(format_macho64_header_label);
    macho_header64(
        macho_mh_object,
        map.get(target, "cpu_type"),
        format_macho64_header_subtype(plan),
        command_count,
        command_size,
        macho_mh_subsections_via_symbols
    );
    map.set_mut(plan, "segment_command", here());
    macho_segment64("", 0, 0, content_foa, 0,
        macho_vm_prot_read | macho_vm_prot_write | macho_vm_prot_execute,
        macho_vm_prot_read | macho_vm_prot_write | macho_vm_prot_execute,
        len(sections), 0);
    for i in range(0, len(sections)) {
        let section: map = list.get(sections, i)
        const attributes: u64 = map.get(section, "attributes")
        label.define(format_macho64_section_command_label(section));
        macho_section64(
            map.get(section, "name"),
            format_macho64_section_segment_name(attributes),
            0, 0, 0,
            format_macho64_section_align_power(target, attributes),
            0, 0,
            format_macho64_section_flags(attributes),
            0, 0, 0
        );
    }
    macho_exe_build_version64(map.get(target, "minos"), map.get(target, "sdk"));
    map.set_mut(plan, "symtab_command", here());
    emit.u32(macho_lc_symtab);
    emit.u32(macho_symtab_command_size);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    emit.u32(0);
    map.set_mut(plan, "content_foa", content_foa);
}

fn format_macho64_begin_execute(let plan: map) {
    const target: map = map.get(plan, "target")
    const segments: list = map.get(plan, "segments")
    const dylinker_size: u64 = macho_align_up(macho_exe_dylinker_command_base_size + len("/usr/lib/dyld") + 1, 8)
    const command_count: u64 = len(segments) + 5
    const command_size: u64 = macho_exe_pagezero_command_size + format_macho64_segments_command_size(segments) + macho_segment_command64_size + dylinker_size + macho_exe_build_version_command_size + macho_exe_main_command_size

    region.begin(".xirasm.macho.header", format_macho64_image_base, 0);
    label.define(format_macho64_header_label);
    macho_header64(
        macho_mh_execute,
        map.get(target, "cpu_type"),
        format_macho64_header_subtype(plan),
        command_count,
        command_size,
        macho_exe_dynamic_flags
    );
    macho_exe_pagezero64(format_macho64_image_base);
    format_macho64_emit_segments(plan);
    map.set_mut(plan, "linkedit_command", here());
    // dyld requires this segment even when there is no link-edit payload.
    macho_segment64("__LINKEDIT", 0, 0, 0, 0, macho_vm_prot_read, macho_vm_prot_read, 0, 0);
    macho_exe_load_dylinker64("/usr/lib/dyld");
    macho_exe_build_version64(map.get(target, "minos"), map.get(target, "sdk"));
    map.set_mut(plan, "main_command", here());
    macho_exe_main64(0, 0);
    align(16);
    map.set_mut(plan, "next_vmaddr", format_macho64_image_base + file_cursor_real());
}

fn format_macho64_begin_dylib(let plan: map) {
    const target: map = map.get(plan, "target")
    const segments: list = map.get(plan, "segments")
    const install_name: string = map.get(plan, "install_name")
    const id_size: u64 = macho_align_up(macho_dylib_id_command_base_size + len(install_name) + 1, 8)
    const command_count: u64 = len(segments) + 4
    const command_size: u64 = format_macho64_segments_command_size(segments) + macho_segment_command64_size + id_size + macho_dylib_build_version_command_size + macho_dylib_export_command_size

    region.begin(".xirasm.macho.header", 0, 0);
    label.define(format_macho64_header_label);
    macho_header64(
        macho_mh_dylib,
        map.get(target, "cpu_type"),
        format_macho64_header_subtype(plan),
        command_count,
        command_size,
        macho_mh_noundefs | macho_mh_dyldlink | macho_mh_twolevel | macho_mh_no_reexported_dylibs
    );
    format_macho64_emit_segments(plan);
    map.set_mut(plan, "linkedit_command", here());
    macho_segment64("__LINKEDIT", 0, 0, 0, 0, macho_vm_prot_read, macho_vm_prot_read, 0, 0);
    macho_dylib_id64(install_name, 0x00010000, 0x00010000);
    macho_dylib_build_version64(map.get(target, "minos"), map.get(target, "sdk"));
    map.set_mut(plan, "export_command", here());
    macho_dylib_exports_trie64(0, 0);
    align(16);
    map.set_mut(plan, "next_vmaddr", file_cursor_real());
}

fn format_macho64_begin(let plan: map) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_macho64_object {
        format_macho64_begin_object(plan);
    }
    if kind == format_kind_macho64_execute {
        format_macho64_begin_execute(plan);
    }
    if kind == format_kind_macho64_dylib {
        format_macho64_begin_dylib(plan);
    }
}

fn format_begin(let plan: map) {
    const kind: u64 = map.get(plan, "kind")

    if kind == format_kind_pe32 {
        const options: u64 = map.get(plan, "options")
        const sections: list = map.get(plan, "sections")
        format_pe_begin32(options, sections);
    }
    if kind == format_kind_pe64 {
        const options: u64 = map.get(plan, "options")
        const sections: list = map.get(plan, "sections")
        const machine: u64 = map.get(plan, "machine")
        format_pe_begin64(options, sections, machine);
    }
    if kind == format_kind_elf32 {
        const segments: list = map.get(plan, "segments")
        format_elf_begin32(segments);
    }
    if kind == format_kind_elf64 {
        format_elf_begin64(plan);
    }
    if kind == format_kind_coff32 {
        const sections: list = map.get(plan, "sections")
        format_coff_begin32(sections);
    }
    if kind == format_kind_coff64 {
        const sections: list = map.get(plan, "sections")
        const machine: u64 = map.get(plan, "machine")
        format_coff_begin64(sections, machine);
    }
    if kind == format_kind_elfobj32 {
        format_elfobj_begin32();
    }
    if kind == format_kind_elfobj64 {
        format_elfobj_begin64(plan);
    }
    if kind == format_kind_elfso64 {
        format_elfso_begin64(plan);
    }
    if kind == format_kind_macho64_object || kind == format_kind_macho64_execute || kind == format_kind_macho64_dylib {
        format_macho64_begin(plan);
    }
    assert(
        kind == format_kind_pe32 ||
        kind == format_kind_pe64 ||
        kind == format_kind_elf32 ||
        kind == format_kind_elf64 ||
        kind == format_kind_coff32 ||
        kind == format_kind_coff64 ||
        kind == format_kind_elfobj32 ||
        kind == format_kind_elfobj64 ||
        kind == format_kind_elfso64 ||
        kind == format_kind_macho64_object ||
        kind == format_kind_macho64_execute ||
        kind == format_kind_macho64_dylib,
        "unsupported format plan kind"
    );
}

fn format_section_begin(let plan: map, name: string) {
    format_section_begin_row(plan, format_section_row(plan, name));
}

fn format_macho64_section_begin(let plan: map, segment_name: string, name: string) {
    format_section_begin_row(plan, format_macho64_section_row(plan, segment_name, name));
}

fn format_section_begin_row(let plan: map, row: u64) {
    const kind: u64 = map.get(plan, "kind")
    const sections: list = map.get(plan, "sections")
    const section: map = list.get(sections, row)
    const name: string = map.get(section, "name")
    const attributes: u64 = map.get(section, "attributes")
    const purpose: u64 = attributes & format_section_purpose_mask

    if kind == format_kind_pe32 {
        const chars: u64 = format_pe_section_chars(attributes)
        pe32_section(name, row);
        label.define(format_pe_section_start_label(name));
        format_pe_finalize_section32_row(row, here(), chars, purpose);
    }
    if kind == format_kind_pe64 {
        const chars: u64 = format_pe_section_chars(attributes)
        pe64_section(name, row);
        label.define(format_pe_section_start_label(name));
        format_pe_finalize_section64_row(row, here(), chars, purpose);
    }
    if kind == format_kind_coff32 || kind == format_kind_coff64 {
        const chars: u64 = format_coff_section_chars(attributes)
        region.begin(name, file_cursor_potential(), file_cursor_real());
        label.define(format_elfobj_section_start_label(name));
        format_coff_finalize_section_row(row, here(), chars, purpose);
    }
    if kind == format_kind_elfobj32 || kind == format_kind_elfobj64 {
        region.begin(name, file_offset(), file_offset());
        label.define(format_elfobj_section_start_label(name));
    }
    if kind == format_kind_macho64_object {
        const target: map = map.get(plan, "target")
        const alignment: u64 = 1 << format_macho64_section_align_power(target, attributes)
        const logical_offset: u64 = macho_align_up(map.get(plan, "next_address"), alignment)
        const file_offset: u64 = macho_align_up(file_cursor_real(), alignment)
        assert(row == map.get(plan, "next_section_row"), "Mach-O sections must be emitted in declaration order");
        assert(!map.get(plan, "section_open"), "Mach-O previous section is still open");
        map.set_mut(plan, "section_open", true);
        region.begin(map.get(section, "key"), logical_offset, file_offset);
        label.define(format_macho64_section_start_label(section));
    }
    if kind == format_kind_macho64_execute || kind == format_kind_macho64_dylib {
        const target: map = map.get(plan, "target")
        const segment_row: u64 = map.get(section, "segment_row")
        const alignment: u64 = 1 << format_macho64_section_align_power(target, attributes)
        let next_vmaddr: u64 = map.get(plan, "next_vmaddr")
        let file_offset: u64 = file_cursor_real()
        assert(row == map.get(plan, "next_section_row"), "Mach-O sections must be emitted in declaration order");
        if segment_row != map.get(plan, "current_segment_row") {
            if segment_row > 0 {
                next_vmaddr = macho_align_up(next_vmaddr, map.get(target, "page_size"));
                file_offset = macho_align_up(file_offset, map.get(target, "page_size"));
            }
            map.set_mut(plan, "current_segment_row", segment_row);
        }
        next_vmaddr = macho_align_up(next_vmaddr, alignment);
        file_offset = macho_align_up(file_offset, alignment);
        assert(!map.get(plan, "section_open"), "Mach-O previous section is still open");
        map.set_mut(plan, "section_open", true);
        region.begin(map.get(section, "key"), next_vmaddr, file_offset);
        label.define(format_macho64_section_start_label(section));
    }
    assert(
        kind == format_kind_pe32 ||
        kind == format_kind_pe64 ||
        kind == format_kind_coff32 ||
        kind == format_kind_coff64 ||
        kind == format_kind_elfobj32 ||
        kind == format_kind_elfobj64 ||
        kind == format_kind_macho64_object ||
        kind == format_kind_macho64_execute ||
        kind == format_kind_macho64_dylib,
        "unsupported format plan kind"
    );
}

fn format_section_end(let plan: map, name: string) {
    format_section_end_row(plan, format_section_row(plan, name));
}

fn format_macho64_section_end(let plan: map, segment_name: string, name: string) {
    format_section_end_row(plan, format_macho64_section_row(plan, segment_name, name));
}

fn format_section_end_row(let plan: map, row: u64) {
    const kind: u64 = map.get(plan, "kind")
    const name: string = map.get(list.get(map.get(plan, "sections"), row), "name")

    if kind == format_kind_pe32 {
        pe32_end_section(row);
    }
    if kind == format_kind_pe64 {
        pe64_end_section(row);
    }
    if kind == format_kind_coff32 || kind == format_kind_coff64 {
        label.define(format_elfobj_section_end_label(name));
        coff_align_section_file();
    }
    if kind == format_kind_elfobj32 || kind == format_kind_elfobj64 {
        const sections: list = map.get(plan, "sections")
        const section: map = list.get(sections, row)
        const attributes: u64 = map.get(section, "attributes")
        assert(format_elfobj_section_alignment(kind, attributes) <= 16, "ELF object section alignment exceeds format.inc layer limit");
        label.define(format_elfobj_section_end_label(name));
        if format_elfobj_section_type(attributes) != elf_sht_nobits && file_cursor_potential() > file_cursor_real() {
            // Initialized padding commits the reserved tail of PROGBITS.
            db(0);
        }
        region.file_align(16);
    }
    if kind == format_kind_macho64_object || kind == format_kind_macho64_execute || kind == format_kind_macho64_dylib {
        const sections: list = map.get(plan, "sections")
        const section: map = list.get(sections, row)
        assert(map.get(plan, "section_open"), "Mach-O section is not open");
        assert(row == map.get(plan, "next_section_row"), "Mach-O section end does not match its begin");
        map.set_mut(plan, "section_open", false);
        label.define(format_macho64_section_end_label(section));
        map.set_mut(plan, "next_address", here());
        map.set_mut(plan, "next_section_row", row + 1);
        if kind == format_kind_macho64_execute || kind == format_kind_macho64_dylib {
            map.set_mut(plan, "next_vmaddr", here());
        }
    }
    assert(
        kind == format_kind_pe32 ||
        kind == format_kind_pe64 ||
        kind == format_kind_coff32 ||
        kind == format_kind_coff64 ||
        kind == format_kind_elfobj32 ||
        kind == format_kind_elfobj64 ||
        kind == format_kind_macho64_object ||
        kind == format_kind_macho64_execute ||
        kind == format_kind_macho64_dylib,
        "unsupported format plan kind"
    );
}

fn format_pe_reloc_add_mut(plan: map, let relocs: list, address: u64) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_pe32 {
        relocs = pe_reloc_add_highlow(relocs, address - pe_default_image_base32);
    } else {
        assert(kind == format_kind_pe64, "format plan is not a PE image");
        relocs = pe_reloc_add_dir64(relocs, address - pe_default_image_base64);
    }
}

fn format_pe_import_section32(let plan: map, name: string, imports: map) {
    assert(format_section_purpose(plan, name) == format_imports, "format PE import section has the wrong purpose");
    format_section_begin(plan, name);
    const start: u64 = here()
    const rva: u64 = start - pe_default_image_base32
    pe_import_emit32(imports, rva, start);
    format_section_end(plan, name);
    pe_finalize_import_dir32(rva, start, pe_import_descriptors, pe_import_descriptors_end);
}

fn format_pe_import_section64(let plan: map, name: string, imports: map) {
    assert(format_section_purpose(plan, name) == format_imports, "format PE import section has the wrong purpose");
    format_section_begin(plan, name);
    const start: u64 = here()
    const rva: u64 = start - pe_default_image_base64
    pe_import_emit64(imports, rva, start);
    format_section_end(plan, name);
    pe_finalize_import_dir64(rva, start, pe_import_descriptors, pe_import_descriptors_end);
}

fn format_pe_import_section(let plan: map, name: string, imports: map) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_pe32 {
        format_pe_import_section32(plan, name, imports);
    }
    if kind == format_kind_pe64 {
        format_pe_import_section64(plan, name, imports);
    }
    assert(kind == format_kind_pe32 || kind == format_kind_pe64, "format plan is not a PE image");
}

fn format_pe_export_section32(let plan: map, name: string, exports: list, dll_name: string) {
    assert(format_section_purpose(plan, name) == format_exports, "format PE export section has the wrong purpose");
    format_section_begin(plan, name);
    const start: u64 = here()
    const rva: u64 = start - pe_default_image_base32
    pe_export_emit32(exports, dll_name, rva, start);
    format_section_end(plan, name);
    pe_finalize_export_dir32(rva, start, pe_export_directory, pe_export_directory_end);
}

fn format_pe_export_section64(let plan: map, name: string, exports: list, dll_name: string) {
    assert(format_section_purpose(plan, name) == format_exports, "format PE export section has the wrong purpose");
    format_section_begin(plan, name);
    const start: u64 = here()
    const rva: u64 = start - pe_default_image_base64
    pe_export_emit64(exports, dll_name, rva, start);
    format_section_end(plan, name);
    pe_finalize_export_dir64(rva, start, pe_export_directory, pe_export_directory_end);
}

fn format_pe_export_section(let plan: map, name: string, exports: list, dll_name: string) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_pe32 {
        format_pe_export_section32(plan, name, exports, dll_name);
    }
    if kind == format_kind_pe64 {
        format_pe_export_section64(plan, name, exports, dll_name);
    }
    assert(kind == format_kind_pe32 || kind == format_kind_pe64, "format plan is not a PE image");
}

fn format_pe_resource_section32(let plan: map, name: string, path: string) {
    assert(format_section_purpose(plan, name) == format_resources, "format PE resource section has the wrong purpose");
    format_section_begin(plan, name);
    const start: u64 = here()
    const rva: u64 = start - pe_default_image_base32
    pe_resource_emit_from_res(path, rva);
    format_section_end(plan, name);
    pe_finalize_resource_dir32(rva, start, pe_resource_root, pe_resource_end);
}

fn format_pe_resource_section64(let plan: map, name: string, path: string) {
    assert(format_section_purpose(plan, name) == format_resources, "format PE resource section has the wrong purpose");
    format_section_begin(plan, name);
    const start: u64 = here()
    const rva: u64 = start - pe_default_image_base64
    pe_resource_emit_from_res(path, rva);
    format_section_end(plan, name);
    pe_finalize_resource_dir64(rva, start, pe_resource_root, pe_resource_end);
}

fn format_pe_resource_section(let plan: map, name: string, path: string) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_pe32 {
        format_pe_resource_section32(plan, name, path);
    }
    if kind == format_kind_pe64 {
        format_pe_resource_section64(plan, name, path);
    }
    assert(kind == format_kind_pe32 || kind == format_kind_pe64, "format plan is not a PE image");
}

fn format_pe_reloc_section32(let plan: map, name: string, relocs: list) {
    assert(format_section_purpose(plan, name) == format_fixups, "format PE relocation section has the wrong purpose");
    assert(len(relocs) > 0, "format PE relocation section requires at least one relocation");
    format_section_begin(plan, name);
    const start: u64 = here()
    const rva: u64 = start - pe_default_image_base32
    pe_reloc_emit_grouped_sorted(relocs);
    format_section_end(plan, name);
    pe_finalize_reloc_dir32(rva, start, pe_reloc_grouped_start, pe_reloc_grouped_end);
}

fn format_pe_reloc_section64(let plan: map, name: string, relocs: list) {
    assert(format_section_purpose(plan, name) == format_fixups, "format PE relocation section has the wrong purpose");
    assert(len(relocs) > 0, "format PE relocation section requires at least one relocation");
    format_section_begin(plan, name);
    const start: u64 = here()
    const rva: u64 = start - pe_default_image_base64
    pe_reloc_emit_grouped_sorted(relocs);
    format_section_end(plan, name);
    pe_finalize_reloc_dir64(rva, start, pe_reloc_grouped_start, pe_reloc_grouped_end);
}

fn format_pe_reloc_section(let plan: map, name: string, relocs: list) {
    const kind: u64 = map.get(plan, "kind")
    if kind == format_kind_pe32 {
        format_pe_reloc_section32(plan, name, relocs);
    }
    if kind == format_kind_pe64 {
        format_pe_reloc_section64(plan, name, relocs);
    }
    assert(kind == format_kind_pe32 || kind == format_kind_pe64, "format plan is not a PE image");
}

fn format_pe_checksum(plan: map) {
    const kind: u64 = map.get(plan, "kind")
    assert(kind == format_kind_pe32 || kind == format_kind_pe64, "format plan is not a PE image");

    const sections: list = map.get(plan, "sections")
    assert(len(sections) > 0, "PE checksum requires at least one section");

    pe_checksum_begin();
    for section in sections {
        const name: string = map.get(section, "name")
        pe_checksum_add_region(label_addr(format_pe_section_start_label(name)));
    }

    const last_section: map = list.get(sections, len(sections) - 1)
    const last_name: string = map.get(last_section, "name")
    pe_checksum_finish(label_addr(format_pe_section_start_label(last_name)));
}

fn format_segment_begin(plan: map, name: string) {
    const row: u64 = format_segment_row(plan, name)
    const kind: u64 = map.get(plan, "kind")
    const options: u64 = map.get(plan, "options")
    const segments: list = map.get(plan, "segments")
    const segment: map = list.get(segments, row)
    const attributes: u64 = map.get(segment, "attributes")
    const purpose: u64 = attributes & format_segment_purpose_mask
    const flags: u64 = format_elf_segment_flags(attributes)
    // A LOAD segment address is derived from the file offset by keeping the two
    // congruent modulo the page, which is the relation the ELF layer promises;
    // the low bits of that address are therefore fixed by the file offset, so the
    // section's own sh_addralign can only be honoured by moving the file offset.
    // Advancing the file position to that alignment here (rather than padding the
    // previous segment) keeps both facts in step and adds no bytes to any region,
    // so a segment that only reserved room still reports SHT_NOBITS.
    //
    // LLD composes the same two steps for the first section of every PT_LOAD
    // (lld/ELF/Writer.cpp `fixSectionAlignments`): the section gets an alignment
    // expression equal to its own sh_addralign, and the placement then advances by
    // whole pages while preserving the position inside the page. Because the page
    // is a multiple of every section alignment, aligning first keeps the page
    // congruence and satisfies sh_addralign in the same move. Without this, a
    // shared object whose first segment ended with a page carry put the next one
    // at, say, 0x219D while declaring an alignment of 8.
    let file_offset: u64 = file_cursor_real()
    if kind == format_kind_elfso64 {
        const section_align: u64 = format_elfso_section_alignment(attributes)
        if section_align > 1 {
            file_offset = elfso_align_up(file_offset, section_align);
        }
    }
    let image_base = 0
    let load_page: u64 = elf_default_page_align
    if kind == format_kind_elfso64 {
        load_page = map.get(plan, "load_align")
    }
    if kind == format_kind_elf64 {
        load_page = map.get(plan, "load_align")
    }
    if kind == format_kind_elf32 {
        image_base = elf_default_base32
    }
    if kind == format_kind_elf64 && options == format_elf_exec {
        image_base = elf_default_base64
    }
    const logical_offset: u64 = format_elf_next_load_logical_offset_page(image_base, file_offset, row, load_page)

    assert(purpose == format_load, "format.inc ELF layer supports LOAD segments only");

    if kind == format_kind_elf32 {
        region.begin(name, elf_default_base32 + logical_offset, file_offset);
        format_elf_finalize_load32(row, here(), flags);
    }
    if kind == format_kind_elf64 {
        const imports: list = map.get(plan, "imports")
        if options == format_elf_exec {
            region.begin(name, elf_default_base64 + logical_offset, file_offset);
        }
        if options == format_elf_pie {
            region.begin(name, logical_offset, file_offset);
        }
        if len(imports) > 0 && row == 0 {
            format_elfexe_finalize_first_load64(here(), flags);
            defer {
                store.u64(region_base() + elf64_phdr_foa(0) + elf64_phdr_align_foa, load_page);
            }
        }
        if len(imports) == 0 || row > 0 {
            format_elf_finalize_load64_page(row, here(), flags, load_page);
        }
    }
    if kind == format_kind_elfso64 {
        region.begin(name, logical_offset, file_offset);
        label.define(format_elfso_segment_start_label(name));
        if row == 0 {
            format_elfso_finalize_first_load_region(here(), flags, load_page);
        }
        if row > 0 {
            format_elfso_finalize_load_region(row, here(), flags, load_page);
        }
    }
    assert(
        kind == format_kind_elf32 ||
        kind == format_kind_elf64 ||
        kind == format_kind_elfso64,
        "format plan is not an ELF executable or shared object"
    );
}

fn format_segment_end(plan: map, name: string) {
    const row: u64 = format_segment_row(plan, name)
    const kind: u64 = map.get(plan, "kind")
    const options: u64 = map.get(plan, "options")
    const segments: list = map.get(plan, "segments")
    const segment: map = list.get(segments, row)
    const attributes: u64 = map.get(segment, "attributes")
    const purpose: u64 = attributes & format_segment_purpose_mask

    assert(purpose == format_load, "format.inc ELF layer supports LOAD segments only");

    if kind == format_kind_elf32 {
        region.file_align(1);
    }
    if kind == format_kind_elf64 && options == format_elf_exec {
        region.file_align(1);
    }
    if kind == format_kind_elf64 && options == format_elf_pie {
        region.file_align(1);
    }
    if kind == format_kind_elfso64 {
        label.define(format_elfso_segment_end_label(name));
        const tail: u64 = file_cursor_potential() - file_cursor_real()
        const size: u64 = label_addr(format_elfso_segment_end_label(name)) - label_addr(format_elfso_segment_start_label(name))
        if tail > 0 && tail < size {
            // Preserve mixed initialized/reserved bytes; pure BSS stays NOBITS.
            db(0);
        }
        region.file_align(1);
    }
    assert(
        kind == format_kind_elf32 ||
        kind == format_kind_elf64 ||
        kind == format_kind_elfso64,
        "format plan is not an ELF executable or shared object"
    );
}

fn format_pe_finalize_section32_row(row: u64, start: u64, chars: u64, purpose: u64) {
    defer {
        let logical_size = region_logical_size(start)
        let file_size = region_file_size(start)
        let rva = start - pe_default_image_base32
        let row_foa = pe_row32_foa(row)
        let raw_ptr = 0
        if file_size > 0 {
            raw_ptr = region_file_offset(start)
        }

        store.u32(region_base() + row_foa + pe_sec_virtual_size_foa, logical_size);
        store.u32(region_base() + row_foa + pe_sec_rva_foa, rva);
        store.u32(region_base() + row_foa + pe_sec_raw_size_foa, file_size);
        store.u32(region_base() + row_foa + pe_sec_raw_ptr_foa, raw_ptr);
        store.u32(region_base() + row_foa + pe_sec_chars_foa, chars);

        if purpose == format_code {
            store.u32(
                region_base() + pe_opt_size_of_code_foa,
                load.u32(region_base() + pe_opt_size_of_code_foa) + file_size
            );
            let current_code_base = load.u32(region_base() + pe_opt_base_of_code_foa)
            if current_code_base == 0 || rva < current_code_base {
                store.u32(region_base() + pe_opt_base_of_code_foa, rva);
            }
        }
        if purpose == format_uninitialized_data {
            store.u32(
                region_base() + pe_opt_size_of_uninit_data_foa,
                load.u32(region_base() + pe_opt_size_of_uninit_data_foa) + logical_size
            );
            let current_data_base = load.u32(region_base() + pe_opt32_base_of_data_foa)
            if current_data_base == 0 || rva < current_data_base {
                store.u32(region_base() + pe_opt32_base_of_data_foa, rva);
            }
        }
        if purpose != format_code && purpose != format_uninitialized_data {
            store.u32(
                region_base() + pe_opt_size_of_init_data_foa,
                load.u32(region_base() + pe_opt_size_of_init_data_foa) + file_size
            );
            let current_data_base = load.u32(region_base() + pe_opt32_base_of_data_foa)
            if current_data_base == 0 || rva < current_data_base {
                store.u32(region_base() + pe_opt32_base_of_data_foa, rva);
            }
        }

        let section_image_end = align_up(rva + logical_size, pe_default_section_align)
        if section_image_end > load.u32(region_base() + pe_opt_size_of_image_foa) {
            store.u32(region_base() + pe_opt_size_of_image_foa, section_image_end);
        }
    }
}

fn format_pe_finalize_section64_row(row: u64, start: u64, chars: u64, purpose: u64) {
    defer {
        let logical_size = region_logical_size(start)
        let file_size = region_file_size(start)
        let rva = start - pe_default_image_base64
        let row_foa = pe_row_foa(row)
        let raw_ptr = 0
        if file_size > 0 {
            raw_ptr = region_file_offset(start)
        }

        store.u32(region_base() + row_foa + pe_sec_virtual_size_foa, logical_size);
        store.u32(region_base() + row_foa + pe_sec_rva_foa, rva);
        store.u32(region_base() + row_foa + pe_sec_raw_size_foa, file_size);
        store.u32(region_base() + row_foa + pe_sec_raw_ptr_foa, raw_ptr);
        store.u32(region_base() + row_foa + pe_sec_chars_foa, chars);

        if purpose == format_code {
            store.u32(
                region_base() + pe_opt_size_of_code_foa,
                load.u32(region_base() + pe_opt_size_of_code_foa) + file_size
            );
            let current_code_base = load.u32(region_base() + pe_opt_base_of_code_foa)
            if current_code_base == 0 || rva < current_code_base {
                store.u32(region_base() + pe_opt_base_of_code_foa, rva);
            }
        }
        if purpose == format_uninitialized_data {
            store.u32(
                region_base() + pe_opt_size_of_uninit_data_foa,
                load.u32(region_base() + pe_opt_size_of_uninit_data_foa) + logical_size
            );
        }
        if purpose != format_code && purpose != format_uninitialized_data {
            store.u32(
                region_base() + pe_opt_size_of_init_data_foa,
                load.u32(region_base() + pe_opt_size_of_init_data_foa) + file_size
            );
        }

        let section_image_end = align_up(rva + logical_size, pe_default_section_align)
        if section_image_end > load.u32(region_base() + pe_opt_size_of_image_foa) {
            store.u32(region_base() + pe_opt_size_of_image_foa, section_image_end);
        }
    }
}

fn format_pe_finalize_entry32(entry_address: u64) {
    defer {
        store.u32(region_base() + pe_opt_entry_rva_foa, entry_address - pe_default_image_base32);
    }
}

fn format_pe_finalize_entry64(entry_address: u64) {
    defer {
        store.u32(region_base() + pe_opt_entry_rva_foa, entry_address - pe_default_image_base64);
    }
}

fn format_elf_finalize_load32(row: u64, start: u64, flags: u64) {
    defer {
        let filesz = region_file_size(start)
        let memsz = region_logical_size(start)
        if memsz < filesz {
            memsz = filesz
        }
        let offset = region_file_offset(start)

        store.u32(region_base() + elf32_phdr_foa(row) + elf32_phdr_type_foa, elf_pt_load);
        store.u32(region_base() + elf32_phdr_foa(row) + elf32_phdr_offset_foa, offset);
        store.u32(region_base() + elf32_phdr_foa(row) + elf32_phdr_vaddr_foa, start);
        store.u32(region_base() + elf32_phdr_foa(row) + elf32_phdr_paddr_foa, start);
        store.u32(region_base() + elf32_phdr_foa(row) + elf32_phdr_filesz_foa, filesz);
        store.u32(region_base() + elf32_phdr_foa(row) + elf32_phdr_memsz_foa, memsz);
        store.u32(region_base() + elf32_phdr_foa(row) + elf32_phdr_flags_foa, flags);
        store.u32(region_base() + elf32_phdr_foa(row) + elf32_phdr_align_foa, elf_default_page_align);
        assert(start % elf_default_page_align == offset % elf_default_page_align, "ELF LOAD virtual and file offsets are not page congruent");
    }
}

fn format_elf_finalize_load64_page(row: u64, start: u64, flags: u64, page: u64) {
    defer {
        let filesz = region_file_size(start)
        let memsz = region_logical_size(start)
        if memsz < filesz {
            memsz = filesz
        }
        let offset = region_file_offset(start)

        store.u32(region_base() + elf64_phdr_foa(row) + elf64_phdr_type_foa, elf_pt_load);
        store.u32(region_base() + elf64_phdr_foa(row) + elf64_phdr_flags_foa, flags);
        store.u64(region_base() + elf64_phdr_foa(row) + elf64_phdr_offset_foa, offset);
        store.u64(region_base() + elf64_phdr_foa(row) + elf64_phdr_vaddr_foa, start);
        store.u64(region_base() + elf64_phdr_foa(row) + elf64_phdr_paddr_foa, start);
        store.u64(region_base() + elf64_phdr_foa(row) + elf64_phdr_filesz_foa, filesz);
        store.u64(region_base() + elf64_phdr_foa(row) + elf64_phdr_memsz_foa, memsz);
        store.u64(region_base() + elf64_phdr_foa(row) + elf64_phdr_align_foa, page);
        assert(start % page == offset % page, "ELF LOAD virtual and file offsets are not page congruent");
    }
}

fn format_elf_finalize_load64(row: u64, start: u64, flags: u64) {
    format_elf_finalize_load64_page(row, start, flags, elf_default_page_align);
}

fn format_elfexe_finalize_first_load64(start: u64, flags: u64) {
    defer {
        let filesz = region_file_offset(start) + region_file_size(start)
        let memsz = region_file_offset(start) + region_logical_size(start)
        if memsz < filesz {
            memsz = filesz
        }

        store.u32(region_base() + elf64_phdr_foa(0) + elf64_phdr_type_foa, elf_pt_load);
        store.u32(region_base() + elf64_phdr_foa(0) + elf64_phdr_flags_foa, flags);
        store.u64(region_base() + elf64_phdr_foa(0) + elf64_phdr_offset_foa, 0);
        store.u64(region_base() + elf64_phdr_foa(0) + elf64_phdr_vaddr_foa, elf_default_base64);
        store.u64(region_base() + elf64_phdr_foa(0) + elf64_phdr_paddr_foa, elf_default_base64);
        store.u64(region_base() + elf64_phdr_foa(0) + elf64_phdr_filesz_foa, filesz);
        store.u64(region_base() + elf64_phdr_foa(0) + elf64_phdr_memsz_foa, memsz);
        store.u64(region_base() + elf64_phdr_foa(0) + elf64_phdr_align_foa, elf_default_page_align);
    }
}

fn format_elf_finalize_entry32(entry_address: u64) {
    defer {
        store.u32(region_base() + elf32_entry_foa, entry_address);
    }
}

fn format_elf_finalize_entry64(entry_address: u64) {
    defer {
        store.u64(region_base() + elf64_entry_foa, entry_address);
    }
}

fn format_coff_reloc_count_for_section(relocs: list, section_name: string) -> u64 {
    let count = 0
    for reloc in relocs {
        if map.get(reloc, "section") == section_name {
            count = count + 1
        }
    }
    return count;
}

fn format_coff_finalize_reloc_row(row: u64, reloc_ptr: u64, reloc_count: u64) {
    defer {
        store.u32(coff_sections + row * coff_section_header_size + coff_sec_reloc_ptr_foa, reloc_ptr);
        store.u16(coff_sections + row * coff_section_header_size + coff_sec_reloc_count_foa, reloc_count);
    }
}

fn format_coff_finalize_symbol_header(symbol_table_foa: u64, symbol_count: u64) {
    defer {
        store.u32(coff_file + 8, symbol_table_foa);
        store.u32(coff_file + 12, symbol_count);
    }
}

fn format_coff_emit_symbol(plan: map, symbol: map) {
    const name: string = map.get(symbol, "name")
    const symbol_kind: u64 = map.get(symbol, "kind")
    const sym_type: u64 = map.get(symbol, "type")
    let value = 0
    let section_number = 0
    let storage_class = coff_sym_class_external

    if symbol_kind == format_coff_symbol_public {
        value = map.get(symbol, "value")
        section_number = format_section_row(plan, map.get(symbol, "section")) + 1
    }
    assert(
        symbol_kind == format_coff_symbol_public ||
        symbol_kind == format_coff_symbol_extern,
        "unknown COFF format symbol kind"
    );

    db(name);
    pad(8 - len(name), 0);
    emit.u32(value);
    emit.u16(section_number);
    emit.u16(sym_type);
    emit.u8(storage_class);
    emit.u8(0);
}

fn format_coff_finish_tables(plan: map) {
    const sections: list = map.get(plan, "sections")
    const symbols: list = map.get(plan, "symbols")
    const relocs: list = map.get(plan, "relocs")
    assert(len(symbols) > 0, "COFF format API requires format_coff_tables_mut before format_finish");

    region.begin(".coff.tables", file_cursor_potential(), file_cursor_real());
    for row in range(0, len(sections)) {
        const section: map = list.get(sections, row)
        const section_name: string = map.get(section, "name")
        const reloc_count: u64 = format_coff_reloc_count_for_section(relocs, section_name)
        assert(reloc_count <= 0xffff, "COFF relocation count requires the overflow format");
        if reloc_count > 0 {
            const reloc_ptr: u64 = file_cursor_real()
            for reloc in relocs {
                if map.get(reloc, "section") == section_name {
                    const start: u64 = label_addr(format_elfobj_section_start_label(section_name))
                    const end: u64 = label_addr(format_elfobj_section_end_label(section_name))
                    const offset: u64 = map.get(reloc, "offset")
                    const width: u64 = format_coff_reloc_width(map.get(plan, "machine"), map.get(reloc, "type"))
                    assert(offset <= end - start && width <= end - start - offset, "COFF relocation offset is outside its section");
                    const symbol_index: u64 = format_coff_symbol_index(symbols, map.get(reloc, "symbol"))
                    emit.struct(CoffRelocation {
                        virtual_address: map.get(reloc, "offset"),
                        symbol_index: symbol_index,
                        reloc_type: map.get(reloc, "type"),
                    });
                }
            }
            format_coff_finalize_reloc_row(row, reloc_ptr, reloc_count);
        }
    }

    align(4);
    const symbol_table_foa: u64 = file_cursor_real()
    format_coff_finalize_symbol_header(symbol_table_foa, len(symbols));
    for symbol in symbols {
        format_coff_emit_symbol(plan, symbol);
    }
    emit.u32(coff_string_table_min_size);
}

fn format_string_table_offset(values: list, index: u64) -> u64 {
    assert(index < len(values), "format string table index is out of range");
    let offset = 1
    for i in range(0, index) {
        offset = offset + len(list.get(values, i)) + 1
    }
    return offset;
}

fn format_emit_string_table(values: list) {
    db(0);
    for value in values {
        db(value, 0);
    }
}

fn format_elfobj_reloc_count_for_section(relocs: list, section_name: string) -> u64 {
    let count = 0
    for reloc in relocs {
        if map.get(reloc, "section") == section_name {
            count = count + 1
        }
    }
    return count;
}

fn format_elfobj_reloc_section_name(kind: u64, section_name: string) -> string {
    if kind == format_kind_elfobj32 {
        return sym.join(".rel", section_name);
    }
    assert(kind == format_kind_elfobj64, "invalid ELF object relocation section kind");
    return sym.join(".rela", section_name);
}

fn format_coff_reloc_width(machine: u64, kind: u64) -> u64 {
    if kind == 0 {
        return 0;
    }
    if machine == coff_machine_amd64 && kind == coff_rel_amd64_addr64 {
        return 8;
    }
    if machine == coff_machine_arm64 && kind == coff_rel_arm64_addr64 {
        return 8;
    }
    if machine == coff_machine_i386 && (kind == coff_rel_i386_dir32 || kind == coff_rel_i386_dir32nb || kind == coff_rel_i386_rel32) {
        return 4;
    }
    if machine == coff_machine_amd64 && kind >= 2 && kind <= 9 {
        return 4;
    }
    if machine == coff_machine_arm64 && kind >= 1 && kind <= 11 {
        return 4;
    }
    return 1;
}

fn format_elfobj_reloc_width(machine: u64, kind: u64) -> u64 {
    if kind == 0 {
        return 0;
    }
    if machine == elf_machine_386 && (kind == elf_r_386_32 || kind == elf_r_386_pc32) {
        return 4;
    }
    if machine == elf_machine_x86_64 {
        if kind == elf_r_x86_64_64 || kind == elf_r_x86_64_pc64 {
            return 8;
        }
        if kind == elf_r_x86_64_pc32 || kind == elf_r_x86_64_plt32 || kind == elf_r_x86_64_gotpcrel || kind == elf_r_x86_64_32 || kind == elf_r_x86_64_32s {
            return 4;
        }
    }
    if machine == elf_machine_aarch64 {
        if kind == elf_r_aarch64_abs64 || kind == elf_r_aarch64_prel64 {
            return 8;
        }
        if kind == elf_r_aarch64_abs16 || kind == elf_r_aarch64_prel16 {
            return 2;
        }
        if kind >= elf_r_aarch64_abs32 && kind <= elf_r_aarch64_ld64_got_lo12_nc {
            return 4;
        }
    }
    return 1;
}

fn format_elfobj_finalize_rel32_addend(address: u64, addend: u64) {
    defer {
        store.u32(address, addend);
    }
}

fn format_elfobj_finalize_shdr32(row_foa: u64, start: u64, end: u64) {
    defer {
        store.u32(region_base() + row_foa + elfobj32_sh_offset_foa, region_file_offset(start));
        store.u32(region_base() + row_foa + elfobj32_sh_size_foa, end - start);
    }
}

fn format_elfobj_finalize_shdr64(row_foa: u64, start: u64, end: u64) {
    defer {
        store.u64(region_base() + row_foa + elfobj64_sh_offset_foa, region_file_offset(start));
        store.u64(region_base() + row_foa + elfobj64_sh_size_foa, end - start);
    }
}

fn format_elfobj_emit_user_symbol32(plan: map, symbol: map, name_offset: u64) {
    const symbol_kind: u64 = map.get(symbol, "kind")
    let section_index = elf_shn_undef
    let value = 0
    if symbol_kind == format_elfobj_symbol_public {
        section_index = format_section_row(plan, map.get(symbol, "section")) + 1
        value = map.get(symbol, "value")
    }
    assert(
        symbol_kind == format_elfobj_symbol_public ||
        symbol_kind == format_elfobj_symbol_extern,
        "unknown ELF object format symbol kind"
    );
    elfobj_sym32(
        name_offset,
        elfobj_st_info(elfobj_stb_global, map.get(symbol, "type")),
        section_index,
        value,
        map.get(symbol, "size")
    );
}

fn format_elfobj_emit_user_symbol64(plan: map, symbol: map, name_offset: u64) {
    const symbol_kind: u64 = map.get(symbol, "kind")
    let section_index = elf_shn_undef
    let value = 0
    if symbol_kind == format_elfobj_symbol_public {
        section_index = format_section_row(plan, map.get(symbol, "section")) + 1
        value = map.get(symbol, "value")
    }
    assert(
        symbol_kind == format_elfobj_symbol_public ||
        symbol_kind == format_elfobj_symbol_extern,
        "unknown ELF object format symbol kind"
    );
    elfobj_sym64(
        name_offset,
        elfobj_st_info(elfobj_stb_global, map.get(symbol, "type")),
        section_index,
        value,
        map.get(symbol, "size")
    );
}

fn format_elfobj_finish_tables(plan: map) {
    const kind: u64 = map.get(plan, "kind")
    const sections: list = map.get(plan, "sections")
    const symbols: list = map.get(plan, "symbols")
    const relocs: list = map.get(plan, "relocs")
    assert(len(symbols) > 0, "ELF object format API requires format_elfobj_tables_mut before format_finish");

    let table_alignment = 4
    if kind == format_kind_elfobj64 {
        table_alignment = 8
    }

    region.begin(".elfobj.tables", file_offset(), file_offset());

    let relocation_sections = list.new()
    for row in range(0, len(sections)) {
        const section: map = list.get(sections, row)
        const section_name: string = map.get(section, "name")
        const relocation_count: u64 = format_elfobj_reloc_count_for_section(relocs, section_name)
        if relocation_count > 0 {
            align(table_alignment);
            const relocation_foa: u64 = file_cursor_real()
            for reloc in relocs {
                if map.get(reloc, "section") == section_name {
                    const start: u64 = label_addr(format_elfobj_section_start_label(section_name))
                    const end: u64 = label_addr(format_elfobj_section_end_label(section_name))
                    const offset: u64 = map.get(reloc, "offset")
                    const width: u64 = format_elfobj_reloc_width(map.get(plan, "machine"), map.get(reloc, "type"))
                    assert(offset <= end - start && width <= end - start - offset, "ELF object relocation offset is outside its section");
                    const symbol_index: u64 = format_elfobj_symbol_index(plan, symbols, map.get(reloc, "symbol"))
                    if kind == format_kind_elfobj32 {
                        format_elfobj_finalize_rel32_addend(map.get(reloc, "address"), map.get(reloc, "addend"));
                        elfobj_rel32(map.get(reloc, "offset"), symbol_index, map.get(reloc, "type"));
                    }
                    if kind == format_kind_elfobj64 {
                        elfobj_rela64(map.get(reloc, "offset"), symbol_index, map.get(reloc, "type"), map.get(reloc, "addend"));
                    }
                }
            }
            const relocation_size: u64 = file_cursor_real() - relocation_foa
            let relocation = map.new()
            map.set_mut(relocation, "name", format_elfobj_reloc_section_name(kind, section_name));
            map.set_mut(relocation, "target_row", row);
            map.set_mut(relocation, "offset", relocation_foa);
            map.set_mut(relocation, "size", relocation_size);
            list.push_mut(relocation_sections, relocation);
        }
    }

    align(table_alignment);
    const symtab_foa: u64 = file_cursor_real()
    if kind == format_kind_elfobj32 {
        elfobj_sym32(0, 0, elf_shn_undef, 0, 0);
        for row in range(0, len(sections)) {
            elfobj_sym32(0, elfobj_st_info(elfobj_stb_local, elfobj_stt_section), row + 1, 0, 0);
        }
        for i in range(0, len(symbols)) {
            format_elfobj_emit_user_symbol32(plan, list.get(symbols, i), format_string_table_offset(format_elfobj_symbol_names(symbols), i));
        }
    }
    if kind == format_kind_elfobj64 {
        elfobj_sym64(0, 0, elf_shn_undef, 0, 0);
        for row in range(0, len(sections)) {
            elfobj_sym64(0, elfobj_st_info(elfobj_stb_local, elfobj_stt_section), row + 1, 0, 0);
        }
        for i in range(0, len(symbols)) {
            format_elfobj_emit_user_symbol64(plan, list.get(symbols, i), format_string_table_offset(format_elfobj_symbol_names(symbols), i));
        }
    }

    const strtab_foa: u64 = file_cursor_real()
    const symbol_names: list = format_elfobj_symbol_names(symbols)
    format_emit_string_table(symbol_names);

    let section_names = list.new()
    for section in sections {
        list.push_mut(section_names, map.get(section, "name"));
    }
    for relocation_section in relocation_sections {
        list.push_mut(section_names, map.get(relocation_section, "name"));
    }
    const symtab_name_index: u64 = len(section_names)
    list.push_mut(section_names, ".symtab");
    const strtab_name_index: u64 = len(section_names)
    list.push_mut(section_names, ".strtab");
    const shstrtab_name_index: u64 = len(section_names)
    list.push_mut(section_names, ".shstrtab");
    const stack_note_name_index: u64 = len(section_names)
    list.push_mut(section_names, ".note.GNU-stack");

    const shstrtab_foa: u64 = file_cursor_real()
    format_emit_string_table(section_names);

    align(table_alignment);
    const section_table_foa: u64 = file_cursor_real()
    const symtab_index: u64 = 1 + len(sections) + len(relocation_sections)
    const strtab_index: u64 = symtab_index + 1
    const shstrtab_index: u64 = strtab_index + 1
    const stack_note_index: u64 = shstrtab_index + 1
    const section_count: u64 = stack_note_index + 1

    if kind == format_kind_elfobj32 {
        elfobj_shdr32(0, elf_sht_null, 0, 0, 0, 0, 0, 0, 0);
        for row in range(0, len(sections)) {
            const section: map = list.get(sections, row)
            const section_name: string = map.get(section, "name")
            const attributes: u64 = map.get(section, "attributes")
            const row_foa: u64 = file_cursor_real()
            elfobj_shdr32(
                format_string_table_offset(section_names, row),
                format_elfobj_section_type(attributes),
                format_elfobj_section_flags(attributes),
                0,
                0,
                0,
                0,
                format_elfobj_section_alignment(kind, attributes),
                0
            );
            format_elfobj_finalize_shdr32(
                row_foa,
                label_addr(format_elfobj_section_start_label(section_name)),
                label_addr(format_elfobj_section_end_label(section_name))
            );
        }
        for i in range(0, len(relocation_sections)) {
            const relocation_section: map = list.get(relocation_sections, i)
            elfobj_shdr32(
                format_string_table_offset(section_names, len(sections) + i),
                elf_sht_rel,
                0,
                map.get(relocation_section, "offset"),
                map.get(relocation_section, "size"),
                symtab_index,
                map.get(relocation_section, "target_row") + 1,
                4,
                elfobj_rel32_size
            );
        }
        elfobj_shdr32(
            format_string_table_offset(section_names, symtab_name_index),
            elf_sht_symtab,
            0,
            symtab_foa,
            strtab_foa - symtab_foa,
            strtab_index,
            1 + len(sections),
            4,
            elfobj_sym32_size
        );
        elfobj_shdr32(
            format_string_table_offset(section_names, strtab_name_index),
            elf_sht_strtab,
            0,
            strtab_foa,
            shstrtab_foa - strtab_foa,
            0,
            0,
            1,
            0
        );
        elfobj_shdr32(
            format_string_table_offset(section_names, shstrtab_name_index),
            elf_sht_strtab,
            0,
            shstrtab_foa,
            section_table_foa - shstrtab_foa,
            0,
            0,
            1,
            0
        );
        elfobj_shdr32(
            format_string_table_offset(section_names, stack_note_name_index),
            elf_sht_progbits,
            0,
            0,
            0,
            0,
            0,
            1,
            0
        );
        elfobj_patch_header32(section_table_foa, section_count, shstrtab_index);
    }

    if kind == format_kind_elfobj64 {
        elfobj_shdr64(0, elf_sht_null, 0, 0, 0, 0, 0, 0, 0);
        for row in range(0, len(sections)) {
            const section: map = list.get(sections, row)
            const section_name: string = map.get(section, "name")
            const attributes: u64 = map.get(section, "attributes")
            const row_foa: u64 = file_cursor_real()
            elfobj_shdr64(
                format_string_table_offset(section_names, row),
                format_elfobj_section_type(attributes),
                format_elfobj_section_flags(attributes),
                0,
                0,
                0,
                0,
                format_elfobj_section_alignment(kind, attributes),
                0
            );
            format_elfobj_finalize_shdr64(
                row_foa,
                label_addr(format_elfobj_section_start_label(section_name)),
                label_addr(format_elfobj_section_end_label(section_name))
            );
        }
        for i in range(0, len(relocation_sections)) {
            const relocation_section: map = list.get(relocation_sections, i)
            elfobj_shdr64(
                format_string_table_offset(section_names, len(sections) + i),
                elf_sht_rela,
                0,
                map.get(relocation_section, "offset"),
                map.get(relocation_section, "size"),
                symtab_index,
                map.get(relocation_section, "target_row") + 1,
                8,
                elfobj_rela64_size
            );
        }
        elfobj_shdr64(
            format_string_table_offset(section_names, symtab_name_index),
            elf_sht_symtab,
            0,
            symtab_foa,
            strtab_foa - symtab_foa,
            strtab_index,
            1 + len(sections),
            8,
            elfobj_sym64_size
        );
        elfobj_shdr64(
            format_string_table_offset(section_names, strtab_name_index),
            elf_sht_strtab,
            0,
            strtab_foa,
            shstrtab_foa - strtab_foa,
            0,
            0,
            1,
            0
        );
        elfobj_shdr64(
            format_string_table_offset(section_names, shstrtab_name_index),
            elf_sht_strtab,
            0,
            shstrtab_foa,
            section_table_foa - shstrtab_foa,
            0,
            0,
            1,
            0
        );
        elfobj_shdr64(
            format_string_table_offset(section_names, stack_note_name_index),
            elf_sht_progbits,
            0,
            0,
            0,
            0,
            0,
            1,
            0
        );
        elfobj_patch_header64(section_table_foa, section_count, shstrtab_index);
    }
}

fn format_elfobj_symbol_names(symbols: list) -> list {
    let names = list.new()
    for symbol in symbols {
        list.push_mut(names, map.get(symbol, "name"));
    }
    return names;
}

fn format_string_table_size(values: list) -> u64 {
    let size = 1
    for value in values {
        size = size + len(value) + 1
    }
    return size;
}

fn format_elfso_exports64(plan: map, exports: list) -> list {
    let values = elf_export_new()
    for export0 in exports {
        const target: string = map.get(export0, "target")
        const name: string = map.get(export0, "name")
        const segment: string = map.get(export0, "segment")
        const size: u64 = map.get(export0, "size")
        const section_index: u64 = format_segment_row(plan, segment) + 1
        const start: u64 = label_addr(format_elfso_segment_start_label(segment))
        const end: u64 = label_addr(format_elfso_segment_end_label(segment))
        const address: u64 = label_addr(target)
        assert(address >= start && address <= end, "ELF shared-object export range is outside its segment");
        assert(size <= end - address, "ELF shared-object export range exceeds its segment");
        let value: map = elf_export_entry(target, name, section_index, size)
        const symbol_type: u64 = map.get_or(export0, "type", elf_stt_func)
        assert(symbol_type == elf_stt_func || symbol_type == elf_stt_object, "ELF shared-object export type must be function or object");
        map.set_mut(value, "type", symbol_type);
        list.push_mut(values, value);
    }
    return values;
}

fn format_elfso_uses_plt(plan: map) -> bool {
    const imports: list = map.get(plan, "imports")
    for entry in imports {
        if map.get_or(entry, "plt", "") != "" {
            return true;
        }
    }
    return false;
}

fn format_elfso_import_group(plan: map, plt: bool) -> list {
    let entries = list.new()
    for entry in map.get(plan, "imports") {
        if (map.get_or(entry, "plt", "") != "") == plt {
            list.push_mut(entries, entry);
        }
    }
    return entries;
}

fn format_elfso_section_names(plan: map, has_imports: bool) -> list {
    const uses_plt: bool = format_elfso_uses_plt(plan)
    const uses_slots: bool = len(format_elfso_import_group(plan, false)) > 0
    let names = list.new()
    for segment in map.get(plan, "segments") {
        list.push_mut(names, map.get(segment, "name"));
    }
    if has_imports && uses_plt {
        list.push_mut(names, ".plt");
        list.push_mut(names, ".got.plt");
    }
    // Match the section-header emission order to keep symbol links valid.
    if uses_slots {
        list.push_mut(names, ".got");
        list.push_mut(names, ".rela.dyn");
    }
    list.push_mut(names, ".dynsym");
    list.push_mut(names, ".dynstr");
    list.push_mut(names, ".hash");
    if has_imports && uses_plt {
        list.push_mut(names, ".rela.plt");
    }
    list.push_mut(names, ".dynamic");
    list.push_mut(names, ".shstrtab");
    return names;
}

fn format_elfso_section_index(section_names: list, name: string) -> u64 {
    for i in range(0, len(section_names)) {
        if list.get(section_names, i) == name {
            return i + 1;
        }
    }
    assert(false, "ELF shared-object internal section is missing");
    return 0;
}

fn format_elfso_emit_dynsym64(imports: list, exports: list, export_name_start: u64) {
    elfso_import_emit_dynsym64(imports, 1);
    for i in range(0, len(exports)) {
        const export0: map = list.get(exports, i)
        elfso_sym64(
            export_name_start + elf_export_name_offset(exports, i),
            elfso_st_info(elf_stb_global, map.get_or(export0, "type", elf_stt_func)),
            map.get(export0, "section"),
            label_addr(map.get(export0, "target")),
            map.get(export0, "size")
        );
    }
}

fn format_elfso_emit_dynstr64(imports: list, exports: list, soname: string) {
    db(0);
    for import0 in imports {
        db(map.get(import0, "name"), 0);
    }
    for export0 in exports {
        db(map.get(export0, "name"), 0);
    }
    db(soname, 0);
    for library in elfso_import_libraries(imports) {
        db(library, 0);
    }
}

fn format_elfso_dynstr_size(imports: list, exports: list, soname: string) -> u64 {
    return 1 + elfso_import_names_size(imports) + elf_export_names_size(exports) + len(soname) + 1 + elfso_import_libraries_size(elfso_import_libraries(imports));
}

fn format_elfso_emit_hash(symbol_count: u64) {
    assert(symbol_count > 0, "ELF shared-object hash requires the null symbol");
    dd(1);
    dd(symbol_count);
    if symbol_count > 1 {
        dd(1);
    }
    if symbol_count == 1 {
        dd(0);
    }
    for i in range(0, symbol_count) {
        let next = 0
        if i > 0 && i + 1 < symbol_count {
            next = i + 1
        }
        dd(next);
    }
}

fn format_elfso_hash_size(symbol_count: u64) -> u64 {
    return (3 + symbol_count) * 4;
}

fn format_elfso_dynamic_size(imports: list) -> u64 {
    if len(imports) == 0 {
        return 7 * elfso_dyn64_size;
    }
    return (11 + len(elfso_import_libraries(imports))) * elfso_dyn64_size;
}

fn format_elfso_dynamic_size_slots(imports: list) -> u64 {
    return (10 + len(elfso_import_libraries(imports))) * elfso_dyn64_size;
}

// AArch64 GLOB_DAT slot imports carry their relocations in DT_RELA; the
// DT_JMPREL/DT_PLTREL/DT_PLTGOT rows of the x86-64 PLT path do not apply.
fn format_elfso_emit_dynamic64_slots(imports: list, dynstr_vaddr: u64, dynstr_size: u64, dynsym_vaddr: u64, hash_vaddr: u64, rela_vaddr: u64, rela_size: u64, soname_offset: u64, first_needed_offset: u64) {
    elfso_dyn64(elf_dt_hash, hash_vaddr);
    elfso_dyn64(elf_dt_strtab, dynstr_vaddr);
    elfso_dyn64(elf_dt_strsz, dynstr_size);
    elfso_dyn64(elf_dt_symtab, dynsym_vaddr);
    elfso_dyn64(elf_dt_syment, elfso_sym64_size);
    elfso_dyn64(elf_dt_rela, rela_vaddr);
    elfso_dyn64(elf_dt_relasz, rela_size);
    elfso_dyn64(elf_dt_relaent, elfso_import_rela64_size);
    const libraries: list = elfso_import_libraries(imports)
    const needed_offsets: list = elfso_import_library_offsets(libraries)
    for i in range(0, len(libraries)) {
        elfso_dyn64(elf_dt_needed, first_needed_offset + list.get(needed_offsets, i));
    }
    elfso_dyn64(elf_dt_soname, soname_offset);
    elfso_dyn64(elf_dt_null, 0);
}

fn format_elfso_emit_dynamic64(imports: list, dynstr_foa: u64, dynstr_size: u64, dynsym_foa: u64, hash_foa: u64, gotplt_foa: u64, rela_plt_foa: u64, rela_plt_size: u64, soname_offset: u64, first_needed_offset: u64) {
    if len(imports) == 0 {
        elf_export_emit_dynamic64(dynstr_foa, dynstr_size, dynsym_foa, hash_foa, soname_offset);
    }
    if len(imports) > 0 {
        elfso_dyn64(elf_dt_hash, hash_foa);
        elfso_dyn64(elf_dt_strtab, dynstr_foa);
        elfso_dyn64(elf_dt_strsz, dynstr_size);
        elfso_dyn64(elf_dt_symtab, dynsym_foa);
        elfso_dyn64(elf_dt_syment, elfso_sym64_size);
        elfso_dyn64(elf_dt_pltgot, gotplt_foa);
        elfso_dyn64(elf_dt_pltrelsz, rela_plt_size);
        elfso_dyn64(elf_dt_pltrel, elf_dt_rela);
        elfso_dyn64(elf_dt_jmprel, rela_plt_foa);
        elfso_dyn64(elf_dt_soname, soname_offset);
        const libraries: list = elfso_import_libraries(imports)
        const needed_offsets: list = elfso_import_library_offsets(libraries)
        for i in range(0, len(libraries)) {
            elfso_dyn64(elf_dt_needed, first_needed_offset + list.get(needed_offsets, i));
        }
        elfso_dyn64(elf_dt_null, 0);
    }
}

fn format_elfso_emit_user_section_headers(plan: map, section_names: list) {
    const segments: list = map.get(plan, "segments")
    for row in range(0, len(segments)) {
        const segment: map = list.get(segments, row)
        const name: string = map.get(segment, "name")
        const attributes: u64 = map.get(segment, "attributes")
        const row_address: u64 = here()
        elfso_shdr64(
            format_string_table_offset(section_names, row),
            elf_sht_progbits,
            format_elfso_section_flags(attributes),
            0,
            0,
            0,
            0,
            0,
            format_elfso_section_alignment(attributes),
            0
        );
        format_elfso_finalize_section_region(
            row_address,
            label_addr(format_elfso_segment_start_label(name)),
            label_addr(format_elfso_segment_end_label(name))
        );
    }
}

fn format_elfso_finish_tables(plan: map) {
    const segments: list = map.get(plan, "segments")
    const exports: list = format_elfso_exports64(plan, map.get(plan, "exports"))
    const plts: list = format_elfso_import_group(plan, true)
    const slots: list = format_elfso_import_group(plan, false)
    // Preserve declaration order in dynsym and DT_NEEDED when grouping slots.
    const imports: list = map.get(plan, "imports")
    const soname: string = map.get(plan, "soname")
    const has_imports: bool = len(imports) > 0
    const machine: u64 = map.get(plan, "machine")
    const load_align: u64 = map.get(plan, "load_align")
    assert(machine == elf_machine_x86_64 || machine == elf_machine_aarch64, "unsupported ELF shared-object machine");
    const plt_imports: bool = has_imports && format_elfso_uses_plt(plan)
    const slots_imports: bool = len(slots) > 0
    const section_names: list = format_elfso_section_names(plan, has_imports)
    const section_count: u64 = len(section_names) + 1
    const shstrndx: u64 = format_elfso_section_index(section_names, ".shstrtab")
    const dynsym_index: u64 = format_elfso_section_index(section_names, ".dynsym")
    const dynstr_index: u64 = format_elfso_section_index(section_names, ".dynstr")

    const import_count: u64 = len(imports)
    const export_count: u64 = len(exports)
    const symbol_count: u64 = 1 + import_count + export_count
    const first_import_symbol: u64 = 1
    const export_name_start: u64 = 1 + elfso_import_names_size(imports)
    const soname_offset: u64 = export_name_start + elf_export_names_size(exports)
    const first_needed_offset: u64 = soname_offset + len(soname) + 1

    let plt_foa = 0
    let plt_size = 0
    let plt_vaddr = 0
    let metadata_foa = elfso_align_up(file_cursor_real(), 16)
    let metadata_vaddr = format_elf_next_load_logical_offset_page(0, metadata_foa, 1, load_align)
    if plt_imports {
        plt_foa = elfso_align_up(file_cursor_real(), 16)
        plt_size = elfso_import_plt_size(plts)
        metadata_foa = elfso_align_up(plt_foa + plt_size, 8)
        plt_vaddr = format_elf_next_load_logical_offset_page(0, plt_foa, 1, load_align)
        metadata_vaddr = format_elf_logical_offset_page(metadata_foa, plt_vaddr + plt_size, load_align)
        const plt_last_page: u64 = (plt_vaddr + plt_size - 1) / load_align
        if metadata_vaddr / load_align <= plt_last_page {
            metadata_vaddr = metadata_vaddr + load_align
        }
    }
    if slots_imports && !plt_imports {
        metadata_foa = elfso_align_up(file_cursor_real(), 16)
        metadata_vaddr = format_elf_next_load_logical_offset_page(0, metadata_foa, 1, load_align)
    }

    let gotplt_foa = 0
    let gotplt_size = 0
    let dynsym_foa = elfso_align_up(metadata_foa, 8)
    if plt_imports {
        gotplt_foa = metadata_foa
        gotplt_size = elfso_import_gotplt_size(plts)
        dynsym_foa = elfso_align_up(gotplt_foa + gotplt_size, 8)
    }
    const got_foa: u64 = dynsym_foa
    const got_size: u64 = len(slots) * elfso_import_gotplt_entry_size
    dynsym_foa = dynsym_foa + got_size
    const dynsym_size: u64 = symbol_count * elfso_sym64_size
    const dynstr_foa: u64 = dynsym_foa + dynsym_size
    const dynstr_size: u64 = format_elfso_dynstr_size(imports, exports, soname)
    const hash_foa: u64 = elfso_align_up(dynstr_foa + dynstr_size, 4)
    const hash_size: u64 = format_elfso_hash_size(symbol_count)
    let rela_plt_foa = 0
    let rela_plt_size = 0
    let dynamic_foa = elfso_align_up(hash_foa + hash_size, 8)
    const rela_dyn_foa: u64 = dynamic_foa
    const rela_dyn_size: u64 = len(slots) * elfso_import_rela64_size
    dynamic_foa = dynamic_foa + rela_dyn_size
    if plt_imports {
        rela_plt_foa = dynamic_foa
        rela_plt_size = elfso_import_rela_plt_size(plts)
        dynamic_foa = elfso_align_up(rela_plt_foa + rela_plt_size, 8)
    }
    let dynamic_rows: u64 = 7 + len(elfso_import_libraries(imports))
    if plt_imports {
        dynamic_rows = dynamic_rows + 4
    }
    if slots_imports {
        dynamic_rows = dynamic_rows + 3
    }
    const dynamic_size: u64 = dynamic_rows * elfso_dyn64_size
    const shstrtab_foa: u64 = dynamic_foa + dynamic_size
    const shstrtab_size: u64 = format_string_table_size(section_names)
    const section_table_foa: u64 = elfso_align_up(shstrtab_foa + shstrtab_size, 8)
    let gotplt_vaddr = 0
    let rela_plt_vaddr = 0
    if plt_imports {
        gotplt_vaddr = metadata_vaddr + (gotplt_foa - metadata_foa)
        rela_plt_vaddr = metadata_vaddr + (rela_plt_foa - metadata_foa)
    }
    const dynsym_vaddr: u64 = metadata_vaddr + (dynsym_foa - metadata_foa)
    const dynstr_vaddr: u64 = metadata_vaddr + (dynstr_foa - metadata_foa)
    const hash_vaddr: u64 = metadata_vaddr + (hash_foa - metadata_foa)
    const dynamic_vaddr: u64 = metadata_vaddr + (dynamic_foa - metadata_foa)
    const got_vaddr: u64 = metadata_vaddr + (got_foa - metadata_foa)
    const rela_dyn_vaddr: u64 = metadata_vaddr + (rela_dyn_foa - metadata_foa)

    let plt_start = 0
    if plt_imports {
        region.begin(".elfso.plt", plt_vaddr, plt_foa);
        plt_start = here()
        assert(file_cursor_real() == plt_foa, "ELF shared-object PLT layout mismatch");
        elfso_import_emit_plt64(plts, plt_vaddr, gotplt_vaddr);
        region.file_align(1);
    }

    region.begin(".elfso.metadata", metadata_vaddr, metadata_foa);
    const metadata_start: u64 = here()
    if plt_imports {
        align(8);
        assert(file_cursor_real() == gotplt_foa, "ELF shared-object GOTPLT layout mismatch");
        elfso_import_emit_gotplt64(plts, dynamic_vaddr, plt_vaddr);
    }
    if slots_imports {
        align(8);
        assert(file_cursor_real() == got_foa, "ELF shared-object GOT layout mismatch");
        elfso_import_emit_slots64(slots);
    }

    align(8);
    assert(file_cursor_real() == dynsym_foa, "ELF shared-object DYNSYM layout mismatch");
    format_elfso_emit_dynsym64(imports, exports, export_name_start);

    assert(file_cursor_real() == dynstr_foa, "ELF shared-object DYNSTR layout mismatch");
    format_elfso_emit_dynstr64(imports, exports, soname);

    align(4);
    assert(file_cursor_real() == hash_foa, "ELF shared-object HASH layout mismatch");
    format_elfso_emit_hash(symbol_count);

    if slots_imports {
        align(8);
        assert(file_cursor_real() == rela_dyn_foa, "ELF shared-object RELA.DYN layout mismatch");
        let relocation: u64 = elf_r_x86_64_glob_dat
        if machine == elf_machine_aarch64 {
            relocation = elf_r_aarch64_glob_dat
        }
        for i in range(0, len(imports)) {
            const entry: map = list.get(imports, i)
            if map.get_or(entry, "plt", "") == "" {
                elfso_import_rela64(label_addr(map.get(entry, "slot")), first_import_symbol + i, relocation, 0);
            }
        }
    }
    if plt_imports {
        align(8);
        assert(file_cursor_real() == rela_plt_foa, "ELF shared-object RELA.PLT layout mismatch");
        for i in range(0, len(imports)) {
            const entry: map = list.get(imports, i)
            if map.get_or(entry, "plt", "") != "" {
                elfso_import_rela64(label_addr(map.get(entry, "slot")), first_import_symbol + i, elf_r_x86_64_jump_slot, 0);
            }
        }
    }

    align(8);
    assert(file_cursor_real() == dynamic_foa, "ELF shared-object DYNAMIC layout mismatch");
    elfso_dyn64(elf_dt_hash, hash_vaddr);
    elfso_dyn64(elf_dt_strtab, dynstr_vaddr);
    elfso_dyn64(elf_dt_strsz, dynstr_size);
    elfso_dyn64(elf_dt_symtab, dynsym_vaddr);
    elfso_dyn64(elf_dt_syment, elfso_sym64_size);
    if slots_imports {
        elfso_dyn64(elf_dt_rela, rela_dyn_vaddr);
        elfso_dyn64(elf_dt_relasz, rela_dyn_size);
        elfso_dyn64(elf_dt_relaent, elfso_import_rela64_size);
    }
    if plt_imports {
        elfso_dyn64(elf_dt_pltgot, gotplt_vaddr);
        elfso_dyn64(elf_dt_pltrelsz, rela_plt_size);
        elfso_dyn64(elf_dt_pltrel, elf_dt_rela);
        elfso_dyn64(elf_dt_jmprel, rela_plt_vaddr);
    }
    elfso_dyn64(elf_dt_soname, soname_offset);
    const libraries: list = elfso_import_libraries(imports)
    const needed_offsets: list = elfso_import_library_offsets(libraries)
    for i in range(0, len(libraries)) {
        elfso_dyn64(elf_dt_needed, first_needed_offset + list.get(needed_offsets, i));
    }
    elfso_dyn64(elf_dt_null, 0);

    assert(file_cursor_real() == shstrtab_foa, "ELF shared-object SHSTRTAB layout mismatch");
    format_emit_string_table(section_names);

    align(8);
    assert(file_cursor_real() == section_table_foa, "ELF shared-object section-table layout mismatch");
    elfso_shdr64(0, elf_sht_null, 0, 0, 0, 0, 0, 0, 0, 0);
    format_elfso_emit_user_section_headers(plan, section_names);

    if plt_imports {
        const plt_index: u64 = format_elfso_section_index(section_names, ".plt")
        const gotplt_index: u64 = format_elfso_section_index(section_names, ".got.plt")
        elfso_shdr64(
            format_string_table_offset(section_names, plt_index - 1),
            elf_sht_progbits,
            elf_shf_alloc | elf_shf_execinstr,
            plt_vaddr,
            plt_foa,
            plt_size,
            0,
            0,
            16,
            elfso_import_plt_entry_size
        );
        elfso_shdr64(
            format_string_table_offset(section_names, gotplt_index - 1),
            elf_sht_progbits,
            elf_shf_alloc | elf_shf_write,
            gotplt_vaddr,
            gotplt_foa,
            gotplt_size,
            0,
            0,
            8,
            elfso_import_gotplt_entry_size
        );
    }
    if slots_imports {
        const got_index: u64 = format_elfso_section_index(section_names, ".got")
        const rela_dyn_index: u64 = format_elfso_section_index(section_names, ".rela.dyn")
        elfso_shdr64(
            format_string_table_offset(section_names, got_index - 1),
            elf_sht_progbits,
            elf_shf_alloc | elf_shf_write,
            got_vaddr,
            got_foa,
            got_size,
            0,
            0,
            8,
            elfso_import_gotplt_entry_size
        );
        elfso_shdr64(
            format_string_table_offset(section_names, rela_dyn_index - 1),
            elf_sht_rela,
            elf_shf_alloc,
            rela_dyn_vaddr,
            rela_dyn_foa,
            rela_dyn_size,
            dynsym_index,
            0,
            8,
            elfso_import_rela64_size
        );
    }

    elfso_shdr64(
        format_string_table_offset(section_names, dynsym_index - 1),
        elf_sht_dynsym,
        elf_shf_alloc,
        dynsym_vaddr,
        dynsym_foa,
        dynsym_size,
        dynstr_index,
        1,
        8,
        elfso_sym64_size
    );
    elfso_shdr64(
        format_string_table_offset(section_names, dynstr_index - 1),
        elf_sht_strtab,
        elf_shf_alloc,
        dynstr_vaddr,
        dynstr_foa,
        dynstr_size,
        0,
        0,
        1,
        0
    );
    const hash_index: u64 = format_elfso_section_index(section_names, ".hash")
    elfso_shdr64(
        format_string_table_offset(section_names, hash_index - 1),
        elf_sht_hash,
        elf_shf_alloc,
        hash_vaddr,
        hash_foa,
        hash_size,
        dynsym_index,
        0,
        4,
        4
    );
    if plt_imports {
        const rela_plt_index: u64 = format_elfso_section_index(section_names, ".rela.plt")
        elfso_shdr64(
            format_string_table_offset(section_names, rela_plt_index - 1),
            elf_sht_rela,
            elf_shf_alloc,
            rela_plt_vaddr,
            rela_plt_foa,
            rela_plt_size,
            dynsym_index,
            0,
            8,
            elfso_import_rela64_size
        );
    }
    const dynamic_index: u64 = format_elfso_section_index(section_names, ".dynamic")
    elfso_shdr64(
        format_string_table_offset(section_names, dynamic_index - 1),
        elf_sht_dynamic,
        elf_shf_alloc | elf_shf_write,
        dynamic_vaddr,
        dynamic_foa,
        dynamic_size,
        dynstr_index,
        0,
        8,
        elfso_dyn64_size
    );
    elfso_shdr64(
        format_string_table_offset(section_names, shstrndx - 1),
        elf_sht_strtab,
        0,
        0,
        shstrtab_foa,
        shstrtab_size,
        0,
        0,
        1,
        0
    );

    let metadata_row = len(segments)
    if plt_imports {
        const plt_row: u64 = len(segments)
        metadata_row = plt_row + 1
        format_elfso_finalize_load_region(plt_row, plt_start, elf_pf_r | elf_pf_x, load_align);
    }
    format_elfso_finalize_load_region(metadata_row, metadata_start, elf_pf_r | elf_pf_w, load_align);
    elfso_finalize_phdr64(
        metadata_row + 1,
        elf_pt_dynamic,
        elf_pf_r | elf_pf_w,
        dynamic_foa,
        dynamic_vaddr,
        dynamic_size,
        dynamic_size,
        8
    );
    format_elfso_finalize_header64(section_table_foa, section_count, shstrndx);
}

fn format_elfexe_finish_tables(plan: map) {
    const segments: list = map.get(plan, "segments")
    const imports: list = map.get(plan, "imports")
    const load_align: u64 = map.get(plan, "load_align")
    assert(len(imports) > 0, "ELF executable import table is empty");

    const first_import_symbol: u64 = 1
    const dynstr_name_start: u64 = 1
    const dynstr_needed_start: u64 = dynstr_name_start + elfexe_import_names_size(imports)

    const plt_foa: u64 = elfexe_align_up(file_cursor_real(), 16)
    const plt_size: u64 = elfexe_import_plt_size(imports)
    const metadata_foa: u64 = elfexe_align_up(plt_foa + plt_size, 8)

    const plt_logical_offset: u64 = format_elf_next_load_logical_offset_page(elf_default_base64, plt_foa, 1, load_align)
    const plt_vaddr: u64 = elf_default_base64 + plt_logical_offset
    let metadata_logical_offset = format_elf_logical_offset_page(metadata_foa, plt_logical_offset + plt_size, load_align)
    const plt_last_page: u64 = (plt_logical_offset + plt_size - 1) / load_align
    if metadata_logical_offset / load_align <= plt_last_page {
        metadata_logical_offset = metadata_logical_offset + load_align
    }
    const metadata_vaddr: u64 = elf_default_base64 + metadata_logical_offset

    const gotplt_foa: u64 = metadata_foa
    const gotplt_size: u64 = elfexe_import_gotplt_size(imports)
    const interp_foa: u64 = gotplt_foa + gotplt_size
    const interp_size: u64 = len(elfexe_import_default_interp64) + 1
    const dynsym_foa: u64 = elfexe_align_up(interp_foa + interp_size, 8)
    const dynsym_size: u64 = (1 + len(imports)) * elfexe_import_sym64_size
    const dynstr_foa: u64 = dynsym_foa + dynsym_size
    const dynstr_size: u64 = elfexe_import_dynstr_size(imports)
    const hash_foa: u64 = elfexe_align_up(dynstr_foa + dynstr_size, 4)
    const hash_size: u64 = elfexe_import_hash_size(imports)
    const rela_plt_foa: u64 = elfexe_align_up(hash_foa + hash_size, 8)
    const rela_plt_size: u64 = elfexe_import_rela_plt_size(imports)
    const dynamic_foa: u64 = elfexe_align_up(rela_plt_foa + rela_plt_size, 8)
    const dynamic_size: u64 = elfexe_import_dynamic_plt_size(imports)

    const gotplt_vaddr: u64 = metadata_vaddr + (gotplt_foa - metadata_foa)
    const interp_vaddr: u64 = metadata_vaddr + (interp_foa - metadata_foa)
    const dynsym_vaddr: u64 = metadata_vaddr + (dynsym_foa - metadata_foa)
    const dynstr_vaddr: u64 = metadata_vaddr + (dynstr_foa - metadata_foa)
    const hash_vaddr: u64 = metadata_vaddr + (hash_foa - metadata_foa)
    const rela_plt_vaddr: u64 = metadata_vaddr + (rela_plt_foa - metadata_foa)
    const dynamic_vaddr: u64 = metadata_vaddr + (dynamic_foa - metadata_foa)

    region.begin(".elfexe.plt", plt_vaddr, plt_foa);
    const plt_start: u64 = here()
    assert(file_cursor_real() == plt_foa, "ELF executable PLT layout mismatch");
    elfexe_import_emit_plt64(imports, plt_vaddr, gotplt_vaddr);
    region.file_align(1);

    region.begin(".elfexe.imports", metadata_vaddr, metadata_foa);
    const metadata_start: u64 = here()
    assert(file_cursor_real() == gotplt_foa, "ELF executable GOTPLT layout mismatch");
    elfexe_import_emit_gotplt64(imports, dynamic_vaddr, plt_vaddr);

    assert(file_cursor_real() == interp_foa, "ELF executable INTERP layout mismatch");
    db(elfexe_import_default_interp64, 0);

    align(8);
    assert(file_cursor_real() == dynsym_foa, "ELF executable DYNSYM layout mismatch");
    elfexe_import_emit_dynsym64(imports, dynstr_name_start);

    assert(file_cursor_real() == dynstr_foa, "ELF executable DYNSTR layout mismatch");
    elfexe_import_emit_dynstr64(imports);

    align(4);
    assert(file_cursor_real() == hash_foa, "ELF executable HASH layout mismatch");
    elfexe_import_hash(imports);

    align(8);
    assert(file_cursor_real() == rela_plt_foa, "ELF executable RELA.PLT layout mismatch");
    elfexe_import_emit_rela_plt64(imports, first_import_symbol);

    align(8);
    assert(file_cursor_real() == dynamic_foa, "ELF executable DYNAMIC layout mismatch");
    elfexe_import_emit_dynamic64_plt(imports, dynstr_vaddr, dynstr_size, dynsym_vaddr, hash_vaddr, gotplt_vaddr, rela_plt_vaddr, rela_plt_size, dynstr_needed_start);

    const plt_row: u64 = len(segments)
    const metadata_row: u64 = plt_row + 1
    format_elf_finalize_load64_page(plt_row, plt_start, elf_pf_r | elf_pf_x, load_align);
    format_elf_finalize_load64_page(metadata_row, metadata_start, elf_pf_r | elf_pf_w, load_align);
    elfexe_finalize_phdr64(metadata_row + 1, elf_pt_interp, elf_pf_r, interp_foa, interp_vaddr, interp_size, interp_size, 1);
    elfexe_finalize_phdr64(metadata_row + 2, elf_pt_dynamic, elf_pf_r | elf_pf_w, dynamic_foa, dynamic_vaddr, dynamic_size, dynamic_size, 8);
}

fn format_macho64_finalize_section(section: map) {
    const attributes: u64 = map.get(section, "attributes")
    const command: u64 = label_addr(format_macho64_section_command_label(section))
    const start: u64 = label_addr(format_macho64_section_start_label(section))
    const end: u64 = label_addr(format_macho64_section_end_label(section))
    defer {
        let file_offset: u64 = region_file_offset(start)
        assert(end >= start, "Mach-O section end precedes its start");
        if (attributes & format_uninitialized_data) != 0 {
            assert(region_file_size(start) == 0, "Mach-O zerofill section emitted file bytes");
            file_offset = 0;
        }
        assert(file_offset < 0x100000000, "Mach-O section file offset exceeds 32 bits");
        store.u64(command + 32, start);
        store.u64(command + 40, end - start);
        store.u32(command + 48, file_offset);
    }
}

fn format_macho64_finalize_segment(command: u64, vmaddr: u64, start: u64, first: bool, next_vmaddr: u64, next_start: u64, last: bool, linkedit_foa: u64) {
    defer {
        let fileoff: u64 = region_file_offset(start)
        let next_fileoff: u64 = region_file_offset(next_start)
        if first {
            fileoff = 0;
        }
        if last {
            next_fileoff = linkedit_foa;
        }
        assert(next_vmaddr >= vmaddr, "Mach-O segment VM ranges are not ordered");
        assert(next_fileoff >= fileoff, "Mach-O segment file ranges are not ordered");
        store.u64(command + 24, vmaddr);
        store.u64(command + 32, next_vmaddr - vmaddr);
        store.u64(command + 40, fileoff);
        store.u64(command + 48, next_fileoff - fileoff);
    }
}

fn format_macho64_finalize_section_relocs(command: u64, reloc_offset: u64, reloc_count: u64) {
    defer {
        assert(reloc_offset < 0x100000000, "Mach-O relocation table offset exceeds 32 bits");
        store.u32(command + 56, reloc_offset);
        store.u32(command + 60, reloc_count);
    }
}

fn format_macho64_finalize_symtab_command(command: u64, symbol_offset: u64, symbol_count: u64, string_offset: u64, string_size: u64) {
    defer {
        assert(symbol_offset < 0x100000000 && string_offset < 0x100000000, "Mach-O symbol table offset exceeds 32 bits");
        assert(string_size > 0, "Mach-O string table is empty");
        store.u32(command + 8, symbol_offset);
        store.u32(command + 12, symbol_count);
        store.u32(command + 16, string_offset);
        store.u32(command + 20, string_size);
    }
}

fn format_macho64_emit_object_symbols(plan: map, symbols: list, names: list) {
    const sections: list = map.get(plan, "sections")
    for i in range(0, len(symbols)) {
        const symbol: map = list.get(symbols, i)
        const symbol_kind: u64 = map.get(symbol, "kind")
        let section_index = 0
        let value = 0
        if symbol_kind == format_macho64_symbol_public {
            section_index = format_section_row(plan, map.get(symbol, "section")) + 1
            value = map.get(symbol, "value")
        }
        assert(
            symbol_kind == format_macho64_symbol_public ||
            symbol_kind == format_macho64_symbol_extern,
            "unknown Mach-O format symbol kind"
        );
        macho_nlist64(format_string_table_offset(names, i), map.get(symbol, "type"), section_index, 0, value);
    }
}

fn format_macho64_finish_object_tables(plan: map) {
    const sections: list = map.get(plan, "sections")
    const symbols: list = map.get(plan, "symbols")
    const relocs: list = map.get(plan, "relocs")
    const symtab_command: u64 = map.get(plan, "symtab_command")

    region.begin(format_macho64_tables_region, file_cursor_potential(), file_cursor_real());
    align(8);
    for row in range(0, len(sections)) {
        const section: map = list.get(sections, row)
        const section_name: string = map.get(section, "name")
        const reloc_count: u64 = format_macho64_reloc_count_for_section(relocs, section_name)
        if reloc_count > 0 {
            const reloc_offset: u64 = file_cursor_real()
            for reloc in relocs {
                if map.get(reloc, "section") == section_name {
                    const symbol_index: u64 = format_macho64_symbol_index(symbols, map.get(reloc, "symbol"))
                    macho_relocation_info(map.get(reloc, "offset"), symbol_index, map.get(reloc, "pcrel"), map.get(reloc, "length"), 1, map.get(reloc, "type"));
                }
            }
            format_macho64_finalize_section_relocs(label_addr(format_macho64_section_command_label(section)), reloc_offset, reloc_count);
        }
    }

    align(8);
    const symbol_offset: u64 = file_cursor_real()
    const names: list = format_macho64_symbol_names(symbols)
    if len(symbols) > 0 {
        format_macho64_emit_object_symbols(plan, symbols, names);
    }
    const string_offset: u64 = file_cursor_real()
    format_emit_string_table(names);
    const string_size: u64 = file_cursor_real() - string_offset
    format_macho64_finalize_symtab_command(symtab_command, symbol_offset, len(symbols), string_offset, string_size);
}

fn format_macho64_finish_object(plan: map) {
    const sections: list = map.get(plan, "sections")
    const segment_command: u64 = map.get(plan, "segment_command")
    const content_foa: u64 = map.get(plan, "content_foa")
    const last_section: map = list.get(sections, len(sections) - 1)
    const image_size: u64 = label_addr(format_macho64_section_end_label(last_section))

    assert(map.get(plan, "next_section_row") == len(sections), "Mach-O object has un-emitted sections");
    for section in sections {
        format_macho64_finalize_section(section);
    }
    format_macho64_finish_object_tables(plan);
    const file_size: u64 = file_cursor_real() - content_foa
    let segment_vm_size = image_size
    if file_size > segment_vm_size {
        segment_vm_size = file_size
    }
    defer {
        store.u64(segment_command + 32, segment_vm_size);
        store.u64(segment_command + 48, file_size);
    }
}

fn format_macho64_finish_segments(let plan: map) {
    const kind: u64 = map.get(plan, "kind")
    const target: map = map.get(plan, "target")
    const segments: list = map.get(plan, "segments")
    const sections: list = map.get(plan, "sections")
    const page_size: u64 = map.get(target, "page_size")
    assert(map.get(plan, "next_section_row") == len(sections), "Mach-O image has un-emitted sections");

    const linkedit_foa: u64 = macho_align_up(file_cursor_real(), page_size)
    const linkedit_vmaddr: u64 = macho_align_up(map.get(plan, "next_vmaddr"), page_size)
    map.set_mut(plan, "linkedit_foa", linkedit_foa);
    map.set_mut(plan, "linkedit_vmaddr", linkedit_vmaddr);

    for i in range(0, len(segments)) {
        const segment: map = list.get(segments, i)
        const segment_name: string = map.get(segment, "name")
        const segment_sections: list = map.get(segment, "sections")
        const first_section: map = list.get(segment_sections, 0)
        const first_section_start: u64 = label_addr(format_macho64_section_start_label(first_section))
        const command: u64 = label_addr(format_macho64_segment_command_label(segment_name))
        let vmaddr: u64 = first_section_start
        if i == 0 {
            vmaddr = 0;
            if kind == format_kind_macho64_execute {
                vmaddr = format_macho64_image_base;
            }
        }
        let next_vmaddr: u64 = linkedit_vmaddr
        let next_start: u64 = first_section_start
        let last: bool = true
        if i + 1 < len(segments) {
            const next_segment: map = list.get(segments, i + 1)
            const next_sections: list = map.get(next_segment, "sections")
            const next_section: map = list.get(next_sections, 0)
            next_start = label_addr(format_macho64_section_start_label(next_section));
            next_vmaddr = next_start;
            last = false;
        }
        format_macho64_finalize_segment(command, vmaddr, first_section_start, i == 0, next_vmaddr, next_start, last, linkedit_foa);
    }
    for section in sections {
        format_macho64_finalize_section(section);
    }
    region.begin(format_macho64_linkedit_region, linkedit_vmaddr, linkedit_foa);
}

fn format_macho64_finish_execute(let plan: map) {
    const sections: list = map.get(plan, "sections")
    const main_command: u64 = map.get(plan, "main_command")
    const linkedit_command: u64 = map.get(plan, "linkedit_command")
    const entry_address: u64 = map.get(plan, "entry")
    let entry_is_code: bool = false
    for section in sections {
        const attributes: u64 = map.get(section, "attributes")
        const start: u64 = label_addr(format_macho64_section_start_label(section))
        const end: u64 = label_addr(format_macho64_section_end_label(section))
        if (attributes & format_code) != 0 && entry_address >= start && entry_address < end {
            entry_is_code = true;
        }
    }
    assert(entry_is_code, "Mach-O executable entry is outside its code sections");
    format_macho64_finish_segments(plan);
    const linkedit_vmaddr: u64 = map.get(plan, "linkedit_vmaddr")
    const linkedit_foa: u64 = map.get(plan, "linkedit_foa")
    defer {
        store.u64(main_command + 8, entry_address - format_macho64_image_base);
        store.u64(linkedit_command + 24, linkedit_vmaddr);
        store.u64(linkedit_command + 40, linkedit_foa);
    }
}

fn format_macho64_finish_dylib(let plan: map) {
    const export_command: u64 = map.get(plan, "export_command")
    const linkedit_command: u64 = map.get(plan, "linkedit_command")
    const exports: list = map.get(plan, "exports")
    assert(len(exports) > 0, "Mach-O dylib facade requires at least one export");
    format_macho64_finish_segments(plan);
    const linkedit_foa: u64 = map.get(plan, "linkedit_foa")
    const linkedit_vmaddr: u64 = map.get(plan, "linkedit_vmaddr")
    const export_size: u64 = macho_export_trie_size64(exports, 0)
    assert(linkedit_foa < 0x100000000, "Mach-O export file offset exceeds 32 bits");

    macho_export_trie_emit64(exports, 0);

    defer {
        store.u32(export_command + 8, linkedit_foa);
        store.u32(export_command + 12, export_size);
        store.u64(linkedit_command + 24, linkedit_vmaddr);
        store.u64(linkedit_command + 32, export_size);
        store.u64(linkedit_command + 40, linkedit_foa);
        store.u64(linkedit_command + 48, export_size);
    }
}

fn format_macho64_finish(let plan: map) {
    const kind: u64 = map.get(plan, "kind")
    assert(!map.get(plan, "section_open"), "Mach-O final section is still open");
    if kind == format_kind_macho64_object {
        format_macho64_finish_object(plan);
    }
    if kind == format_kind_macho64_execute {
        assert(map.get(plan, "entry") != 0, "Mach-O executable requires an entry address");
        format_macho64_finish_execute(plan);
    }
    if kind == format_kind_macho64_dylib {
        format_macho64_finish_dylib(plan);
    }
}

fn format_finish(let plan: map) {
    const kind: u64 = map.get(plan, "kind")
    const entry_address: u64 = map.get(plan, "entry")

    if kind == format_kind_pe32 {
        assert(entry_address != 0, "PE executable or DLL requires an entry address");
        format_pe_finalize_entry32(entry_address);
    }
    if kind == format_kind_pe64 {
        assert(entry_address != 0, "PE executable or DLL requires an entry address");
        format_pe_finalize_entry64(entry_address);
    }
    if kind == format_kind_elf32 {
        assert(entry_address != 0, "ELF executable requires an entry address");
        format_elf_finalize_entry32(entry_address);
    }
    if kind == format_kind_elf64 {
        assert(entry_address != 0, "ELF executable requires an entry address");
        const imports: list = map.get(plan, "imports")
        if len(imports) > 0 {
            format_elfexe_finish_tables(plan);
        }
        format_elf_finalize_entry64(entry_address);
    }
    if kind == format_kind_coff32 || kind == format_kind_coff64 {
        format_coff_finish_tables(plan);
    }
    if kind == format_kind_elfobj32 || kind == format_kind_elfobj64 {
        format_elfobj_finish_tables(plan);
    }
    if kind == format_kind_elfso64 {
        format_elfso_finish_tables(plan);
    }
    if kind == format_kind_macho64_object || kind == format_kind_macho64_execute || kind == format_kind_macho64_dylib {
        format_macho64_finish(plan);
    }
    assert(
        kind == format_kind_pe32 ||
        kind == format_kind_pe64 ||
        kind == format_kind_elf32 ||
        kind == format_kind_elf64 ||
        kind == format_kind_coff32 ||
        kind == format_kind_coff64 ||
        kind == format_kind_elfobj32 ||
        kind == format_kind_elfobj64 ||
        kind == format_kind_elfso64 ||
        kind == format_kind_macho64_object ||
        kind == format_kind_macho64_execute ||
        kind == format_kind_macho64_dylib,
        "unsupported format plan kind"
    );
}

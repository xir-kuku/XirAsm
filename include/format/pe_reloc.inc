// PE base relocation table helpers for XIRASM.
//
// This helper intentionally keeps relocation records explicit. It mirrors
// the final PE block shape without hidden relocation
// recording: caller code decides which RVAs need HIGHLOW/DIR64 records, then
// emits the .reloc payload at the chosen section placement.

import("pe.inc");

const pe_reloc_page_size: u64 = 0x1000
const pe_reloc_block_header_size: u64 = 8
const pe_reloc_entry_size: u64 = 2

const pe_reloc_absolute: u64 = 0
const pe_reloc_highlow: u64 = 3
const pe_reloc_dir64: u64 = 10

fn pe_reloc_new() -> list {
    return list.new();
}

fn pe_reloc_rva(section_rva: u64, label_address: u64, section_start: u64) -> u64 {
    assert(label_address >= section_start, "PE relocation label is before its section start");
    assert(label_address - section_start < pe_reloc_page_size * 0x100000, "PE relocation label offset is out of range");
    return section_rva + (label_address - section_start);
}

fn pe_reloc_add_highlow(relocs: list, rva: u64) -> list {
    return pe_reloc_add(relocs, rva, pe_reloc_highlow);
}

fn pe_reloc_add_dir64(relocs: list, rva: u64) -> list {
    return pe_reloc_add(relocs, rva, pe_reloc_dir64);
}

fn pe_reloc_add_highlow_at(relocs: list, section_rva: u64, label_address: u64, section_start: u64) -> list {
    return pe_reloc_add_highlow(relocs, pe_reloc_rva(section_rva, label_address, section_start));
}

fn pe_reloc_add_dir64_at(relocs: list, section_rva: u64, label_address: u64, section_start: u64) -> list {
    return pe_reloc_add_dir64(relocs, pe_reloc_rva(section_rva, label_address, section_start));
}

fn pe_reloc_add(relocs: list, rva: u64, kind: u64) -> list {
    assert(kind <= 0xf, "PE relocation type is out of range");
    assert(rva < 0x100000000, "PE relocation RVA exceeds 32 bits");
    for previous in relocs {
        if map.get(previous, "rva") == rva {
            assert(map.get(previous, "kind") == kind, "PE relocation location has conflicting types");
            return relocs;
        }
    }
    let entry: map = map.new()
    map.set_mut(entry, "rva", rva);
    map.set_mut(entry, "kind", kind);
    let next_relocs: list = relocs
    list.push_mut(next_relocs, entry);
    return next_relocs;
}

fn pe_reloc_block_size(entry_count: u64) -> u64 {
    return pe_reloc_block_header_size + align_up(entry_count * pe_reloc_entry_size, 4);
}

fn pe_reloc_page_rva(rva: u64) -> u64 {
    return (rva / pe_reloc_page_size) * pe_reloc_page_size;
}

fn pe_reloc_type_offset(rva: u64, kind: u64) -> u64 {
    assert(kind <= 0xf, "PE relocation type is out of range");
    return kind * 0x1000 + (rva - pe_reloc_page_rva(rva));
}

fn pe_reloc_emit_block(relocs: list, page_rva: u64) {
    assert(len(relocs) > 0, "PE relocation block requires at least one entry");
    assert(page_rva == (page_rva / pe_reloc_page_size) * pe_reloc_page_size, "PE relocation page RVA is not page aligned");

    label.define("pe_reloc_block");
    emit.u32(page_rva);
    emit.u32(pe_reloc_block_size(len(relocs)));

    for entry in relocs {
        const rva: u64 = map.get(entry, "rva");
        const kind: u64 = map.get(entry, "kind");
        assert(rva >= page_rva, "PE relocation RVA is before the block page");
        assert(rva < page_rva + pe_reloc_page_size, "PE relocation RVA is outside the block page");
        emit.u16(pe_reloc_type_offset(rva, kind));
    }

    const padded_size: u64 = pe_reloc_block_size(len(relocs))
    const natural_size: u64 = pe_reloc_block_header_size + len(relocs) * pe_reloc_entry_size
    if padded_size != natural_size {
        emit.u16(pe_reloc_absolute);
    }

    label.define("pe_reloc_block_end");
}

fn pe_reloc_page_entry_count_sorted_from(relocs: list, index: u64, page_rva: u64, count: u64) -> u64 {
    const current_index: u64 = index + count
    if current_index >= len(relocs) {
        return count;
    }

    const entry: map = list.get(relocs, current_index);
    const rva: u64 = map.get(entry, "rva");
    if pe_reloc_page_rva(rva) != page_rva {
        return count;
    }

    return pe_reloc_page_entry_count_sorted_from(relocs, index, page_rva, count + 1);
}

fn pe_reloc_assert_sorted(relocs: list) {
    let index = 0
    let previous_rva = 0
    let has_previous = 0
    while index < len(relocs) {
        const entry: map = list.get(relocs, index);
        const rva: u64 = map.get(entry, "rva");
        if has_previous != 0 {
            assert(rva >= previous_rva, "PE relocation records must be sorted by RVA");
        }
        previous_rva = rva
        has_previous = 1
        index = index + 1
    }
}

fn pe_reloc_emit_block_range_sorted(relocs: list, index: u64, count: u64, page_rva: u64) {
    assert(count > 0, "PE relocation grouped block requires at least one entry");
    assert(page_rva == pe_reloc_page_rva(page_rva), "PE relocation page RVA is not page aligned");

    emit.u32(page_rva);
    emit.u32(pe_reloc_block_size(count));
    const end_index: u64 = index + count
    let current_index = index
    while current_index < end_index {
        const entry: map = list.get(relocs, current_index);
        const rva: u64 = map.get(entry, "rva");
        const kind: u64 = map.get(entry, "kind");
        assert(rva >= page_rva, "PE relocation RVA is before the grouped block page");
        assert(rva < page_rva + pe_reloc_page_size, "PE relocation RVA is outside the grouped block page");
        emit.u16(pe_reloc_type_offset(rva, kind));
        current_index = current_index + 1
    }

    const padded_size: u64 = pe_reloc_block_size(count)
    const natural_size: u64 = pe_reloc_block_header_size + count * pe_reloc_entry_size
    if padded_size != natural_size {
        emit.u16(pe_reloc_absolute);
    }
}

fn pe_reloc_emit_grouped_sorted(relocs: list) {
    pe_reloc_assert_sorted(relocs);
    label.define("pe_reloc_block");
    label.define("pe_reloc_grouped_start");

    let index = 0
    while index < len(relocs) {
        const entry: map = list.get(relocs, index);
        const rva: u64 = map.get(entry, "rva");

        const page_rva: u64 = pe_reloc_page_rva(rva)
        const count: u64 = pe_reloc_page_entry_count_sorted_from(relocs, index, page_rva, 0)
        pe_reloc_emit_block_range_sorted(relocs, index, count, page_rva);
        index = index + count
    }

    label.define("pe_reloc_grouped_end");
    label.define("pe_reloc_block_end");
}

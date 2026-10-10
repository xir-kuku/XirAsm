const imported_narrow: f32 = f32(1.5)
const imported_wide: f64 = -2.0
fn imported_default() -> f32 {
    return imported_narrow;
}
struct ImportedFloatDefaults {
    narrow: f32 = imported_default(),
    wide: f64 = imported_wide,
}

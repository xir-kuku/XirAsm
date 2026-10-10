struct FloatPoint {
    x: f32 = f32(1.5),
    y: f64 = -2.0,
}
union FloatChoice {
    narrow: f32,
    wide: f64,
    point: FloatPoint,
}
struct FloatEnvelope {
    tag: u8 = 0x7f,
    choice: FloatChoice,
    tail: u8 = 0x55,
}
packed struct PackedFloats {
    tag: u8 = 1,
    narrow: f32 = f32(-0.0),
    wide: f64 = -0.0,
}
assert(sizeof(f32) == 4);
assert(sizeof(f64) == 8);
assert(sizeof(FloatPoint) == 16);
assert(offset_of(FloatPoint, y) == 8);
assert(sizeof(FloatEnvelope) == 32);
assert(offset_of(FloatEnvelope, choice.point.y) == 16);
assert(offset_of(FloatEnvelope, tail) == 24);
assert(sizeof(PackedFloats) == 13);
const envelope: FloatEnvelope = FloatEnvelope {
    choice: FloatChoice { point: FloatPoint { } }
}
assert(envelope.choice.point.x == f32(1.5));
assert(envelope.choice.point.y == -2.0);
emit.struct(envelope);
emit.bytes(pack(PackedFloats { }));
emit.struct(FloatChoice { narrow: f32(3.25) });
emit.struct(FloatChoice { wide: 4.5 });
emit.f32(envelope.choice.point.x);
emit.f64(envelope.choice.point.y);

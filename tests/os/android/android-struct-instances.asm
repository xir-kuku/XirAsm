import("../../../include/os/android/structs.inc");

const window: ANativeWindow_Buffer = ANativeWindow_Buffer {
    width: 640,
    height: 480,
    stride: 640,
    format: 1,
    reserved: android_ANativeWindow_Buffer_reserved { }
}
const rect: ARect = ARect { right: 640, bottom: 480 }
const callbacks: ANativeActivityCallbacks = ANativeActivityCallbacks {
    onStart: 0x1122334455667788,
    onNativeWindowCreated: 0x8877665544332211
}
const vector: ASensorVector = ASensorVector {
    components: android_ASensorVector_components {
        cartesian: android_ASensorVector_components_cartesian {
            x: f32(1.5),
            y: f32(-2.0),
            z: f32(3.25)
        }
    },
    reserved: android_ASensorVector_reserved { }
}
const sensor: ASensorEvent = ASensorEvent {
    version: 104,
    timestamp: 0x102030405060708,
    payload: android_ASensorEvent_payload {
        values: android_ASensorEvent_payload_values { acceleration: vector }
    },
    reserved1: android_ASensorEvent_reserved1 { }
}
assert(sizeof(ANativeWindow_Buffer) == 48);
assert(offset_of(ANativeWindow_Buffer, bits) == 16);
assert(offset_of(ANativeWindow_Buffer, reserved.element5) == 44);
assert(offset_of(ASensorEvent, payload.values.acceleration.components.cartesian.x) == 24);
assert(offset_of(ASensorEvent, payload.values.acceleration.components.cartesian.y) == 28);
assert(offset_of(ASensorEvent, payload.u64.step_counter) == 24);
emit.struct(window);
emit.struct(rect);
emit.struct(callbacks);
emit.struct(sensor);

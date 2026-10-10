fn append(let items: list) {
    list.push_mut(items, 4)
}

fn inner() -> u64 {
    let count: u64 = 1
    count = count + 1
    return count
}

fn build() -> list {
    let items: list = list.of(1)
    let cfg: map = map.new()
    if true {
        list.push_mut(items, inner())
        list.set_mut(items, 0, 3)
        map.set_mut(cfg, "size", len(items))
    }
    append(items)
    assert(map.get(cfg, "size") == 2)
    return items
}

fn caller() {
    let scalar: u64 = 5
    let items: list = build()
    assert(list.eq(items, list.of(3, 2, 4)))
    scalar = scalar + 1
    list.push_mut(items, scalar)
    emit.u8(list.get(items, 3))
}

caller()

let calls: u64 = 0
macro evaluate(arg) {
    calls = calls + 1
    const first: string = operand.eval(arg)
    const second: string = operand.eval(arg)
    assert(first != second)
}
evaluate sym.unique("explicit")
assert(calls == 1)

macro captured(arg) {
    const caller_value: u64 = 99
    emit.u8(operand.eval(arg))
}
const caller_value: u64 = 7
captured caller_value

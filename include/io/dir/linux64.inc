// Linux x86-64 目录枚举，直接使用 open/getdents64/close syscall。
//
// 路径是 Linux 零结尾字节目录路径；首版不接受通配符。枚举状态由调用方
// 按 io_dir_state_size 分配，本模块只在状态块内保存 fd 和 getdents64 缓冲。

assert(target.bits == 64, "io/dir/linux64.inc currently supports x86-64 only");

import("contract.inc");

const io_dir_linux64_sys_open: u64 = 2
const io_dir_linux64_sys_close: u64 = 3
const io_dir_linux64_sys_getdents64: u64 = 217
const io_dir_linux64_o_read_only: u64 = 0
const io_dir_linux64_o_directory: u64 = 0x10000
const io_dir_linux64_dt_dir: u64 = 4
const io_dir_linux64_dt_reg: u64 = 8
const io_dir_linux64_dirent_reclen_offset: u64 = 16
const io_dir_linux64_dirent_type_offset: u64 = 18
const io_dir_linux64_dirent_name_offset: u64 = 19

// 计算零结尾字节字符串长度。
// 编译期参数：无。
// 运行时输入：rsi = Linux 字节字符串地址。
// 返回：rax = 不含零结尾的字节数。
// 错误：不检测非法指针或缺失零结尾，调用方必须保证输入有效。
// 所有权：只读调用方字符串。
// ABI：保持 rsi；破坏 rax、r10。
fn io_dir_linux64_strlen() {
    xor eax, eax

    const loop_label: string = sym.unique("__iod_l_strlen_loop_")
    const end_label: string = sym.unique("__iod_l_strlen_end_")

    label.define(loop_label);
    mov r10b, [rsi + rax]
    test r10b, r10b
    isa(sym.join("jz ", end_label));
    add rax, 1
    isa(sym.join("jmp ", loop_label));

    label.define(end_label);
}

// 打开 Linux 目录并初始化枚举游标。
// 编译期参数：无。
// 运行时输入：rdi = 状态块，rsi = Linux 零结尾目录路径。
// 返回：成功 rax=0、rdx=0；失败 rax=-1、rdx=errno 或 io_dir_error_*。
// 所有权：状态块归调用方；成功后 fd 由状态块持有，必须 io_dir_close。
// ABI：保持 rdi、rsi、rsp；syscall 破坏 rcx/r11，本函数破坏易失寄存器。
fn io_dir_open() {
    const invalid_label: string = sym.unique("__iod_lo_invalid_")
    const already_label: string = sym.unique("__iod_lo_already_")
    const end_label: string = sym.unique("__iod_lo_end_")

    test rdi, rdi
    isa(sym.join("jz ", invalid_label));
    test rsi, rsi
    isa(sym.join("jz ", invalid_label));
    cmp qword [rdi + 40], 0
    isa(sym.join("jne ", already_label));

    push rdi
    push rsi
    mov rdi, rsi
    mov esi, io_dir_linux64_o_read_only | io_dir_linux64_o_directory
    xor edx, edx
    mov eax, io_dir_linux64_sys_open
    syscall
    pop rsi
    pop rdi
    io_linux64_normalize_count_result();
    cmp rax, -1
    isa(sym.join("je ", end_label));

    mov [rdi], rax
    mov qword [rdi + 8], 0
    mov qword [rdi + 16], 0
    mov qword [rdi + 24], 0
    mov qword [rdi + 32], 0
    mov qword [rdi + 40], 1
    mov qword [rdi + 48], 0
    mov qword [rdi + 56], 0
    mov qword [rdi + 64], 0
    mov qword [rdi + 72], io_dir_buffer_size
    xor eax, eax
    xor edx, edx
    isa(sym.join("jmp ", end_label));

    label.define(invalid_label);
    mov rax, -1
    mov edx, io_dir_error_invalid_state
    isa(sym.join("jmp ", end_label));

    label.define(already_label);
    mov rax, -1
    mov edx, io_dir_error_already_open

    label.define(end_label);
}

// 读取下一个 Linux 目录项。
// 编译期参数：无。
// 运行时输入：rdi = 已打开的状态块。
// 返回：有条目 rax=1、rdx=0；结束 rax=0、rdx=0；失败 rax=-1、rdx=错误码。
// 所有权：当前 name 指针指向状态块内部缓冲，到下一次 next/close 前有效。
// ABI：保持 rdi、rsi、rsp；syscall 破坏 rcx/r11，本函数破坏易失寄存器。
fn io_dir_next() {
    const invalid_label: string = sym.unique("__iod_ln_invalid_")
    const not_open_label: string = sym.unique("__iod_ln_not_open_")
    const refill_label: string = sym.unique("__iod_ln_refill_")
    const have_record_label: string = sym.unique("__iod_ln_have_record_")
    const file_label: string = sym.unique("__iod_ln_file_")
    const directory_label: string = sym.unique("__iod_ln_dir_")
    const other_label: string = sym.unique("__iod_ln_other_")
    const bad_record_label: string = sym.unique("__iod_ln_bad_record_")
    const end_ok_label: string = sym.unique("__iod_ln_end_ok_")
    const end_label: string = sym.unique("__iod_ln_end_")

    test rdi, rdi
    isa(sym.join("jz ", invalid_label));
    cmp qword [rdi + 40], 1
    isa(sym.join("jne ", not_open_label));

    mov r8, [rdi + 64]
    cmp r8, [rdi + 56]
    isa(sym.join("jae ", refill_label));

    label.define(have_record_label);
    lea r9, [rdi + 80]
    add r9, [rdi + 64]
    movzx r10d, word [r9 + 16]
    test r10d, r10d
    isa(sym.join("jz ", bad_record_label));
    mov r11, [rdi + 64]
    add r11, r10
    cmp r11, [rdi + 56]
    isa(sym.join("ja ", bad_record_label));
    mov [rdi + 64], r11

    push rsi
    lea rsi, [r9 + 19]
    io_dir_linux64_strlen();
    mov [rdi + 8], rsi
    mov [rdi + 16], rax
    pop rsi
    movzx r10d, byte [r9 + 18]
    cmp r10d, io_dir_linux64_dt_reg
    isa(sym.join("je ", file_label));
    cmp r10d, io_dir_linux64_dt_dir
    isa(sym.join("je ", directory_label));

    label.define(other_label);
    mov qword [rdi + 24], io_dir_kind_other
    isa(sym.join("jmp ", end_ok_label));

    label.define(file_label);
    mov qword [rdi + 24], io_dir_kind_file
    isa(sym.join("jmp ", end_ok_label));

    label.define(directory_label);
    mov qword [rdi + 24], io_dir_kind_directory
    isa(sym.join("jmp ", end_ok_label));

    label.define(refill_label);
    push rsi
    push rdi
    mov rdx, [rdi + 72]
    lea rsi, [rdi + 80]
    mov rdi, [rdi]
    mov eax, io_dir_linux64_sys_getdents64
    syscall
    pop rdi
    pop rsi
    io_linux64_normalize_count_result();
    cmp rax, -1
    isa(sym.join("je ", end_label));
    test rax, rax
    isa(sym.join("jz ", end_ok_label));
    mov [rdi + 56], rax
    mov qword [rdi + 64], 0
    isa(sym.join("jmp ", have_record_label));

    label.define(end_ok_label);
    mov qword [rdi + 32], 0
    cmp rax, 0
    isa(sym.join("jne ", end_label));
    xor edx, edx
    isa(sym.join("jmp ", end_label));

    label.define(bad_record_label);
    mov rax, -1
    mov edx, io_dir_error_bad_record
    isa(sym.join("jmp ", end_label));

    label.define(invalid_label);
    mov rax, -1
    mov edx, io_dir_error_invalid_state
    isa(sym.join("jmp ", end_label, "_done"));

    label.define(not_open_label);
    mov rax, -1
    mov edx, io_dir_error_not_open
    isa(sym.join("jmp ", end_label));

    label.define(end_label);
    cmp rax, 0
    isa(sym.join("je ", end_label, "_zero"));
    cmp rax, -1
    isa(sym.join("je ", end_label, "_store_error"));
    mov rax, 1
    xor edx, edx
    isa(sym.join("jmp ", end_label, "_done"));

    label.define(sym.join(end_label, "_zero"));
    xor edx, edx
    isa(sym.join("jmp ", end_label, "_done"));

    label.define(sym.join(end_label, "_store_error"));
    mov [rdi + 32], rdx

    label.define(sym.join(end_label, "_done"));
}

// 关闭 Linux 目录描述符并清空状态。
// 编译期参数：无。
// 运行时输入：rdi = 状态块。
// 返回：成功 rax=0、rdx=0；关闭失败 rax=-1、rdx=errno；关闭状态为成功 no-op。
// 所有权：调用后状态块不再持有 fd，即使 close 报错也不得复用旧 fd。
// ABI：保持 rdi、rsp；syscall 破坏 rcx/r11，本函数破坏易失寄存器。
fn io_dir_close() {
    const invalid_label: string = sym.unique("__iod_lc_invalid_")
    const closed_label: string = sym.unique("__iod_lc_closed_")
    const end_label: string = sym.unique("__iod_lc_end_")

    test rdi, rdi
    isa(sym.join("jz ", invalid_label));
    cmp qword [rdi + 40], 0
    isa(sym.join("je ", closed_label));

    push rdi
    mov rdi, [rdi]
    mov eax, io_dir_linux64_sys_close
    syscall
    pop rdi
    mov qword [rdi], -1
    mov qword [rdi + 40], 0
    mov qword [rdi + 56], 0
    mov qword [rdi + 64], 0
    io_linux64_normalize_count_result();
    isa(sym.join("jmp ", end_label));

    label.define(closed_label);
    xor eax, eax
    xor edx, edx
    isa(sym.join("jmp ", end_label));

    label.define(invalid_label);
    mov rax, -1
    mov edx, io_dir_error_invalid_state

    label.define(end_label);
}

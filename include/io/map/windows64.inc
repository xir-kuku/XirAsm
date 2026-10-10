// Windows x64 文件内存映射入口。
//
// 生成 PE 时必须调用 io_windows64_map_imports(imports) 加入所需导入。
// 本文件使用 CreateFileMappingW/MapViewOfFile，只做完整文件、偏移 0 的
// 普通数据映射；不请求可执行页面。调用方提供状态块并负责关闭。

assert(target.bits == 64, "io/map/windows64.inc currently supports x86-64 only");

// 依赖由公开总入口 io/windows.inc 先行导入，避免不同相对路径造成重复模块。
import("contract.inc");

const io_map_windows64_page_readonly: u64 = 0x02
const io_map_windows64_page_readwrite: u64 = 0x04
const io_map_windows64_file_map_write: u64 = 0x02
const io_map_windows64_file_map_read: u64 = 0x04

// 把 Windows map 模块所需的 KERNEL32 导入加入现有导入 map。
// 编译期参数：imports = pe_import_new() 或其他 pe_import_use64 返回的 map。
// 运行时输入寄存器：无；本函数只在汇编期构造导入描述。
// 返回：包含 CreateFileW、GetFileSizeEx、CreateFileMappingW、MapViewOfFile、
//       FlushViewOfFile、FlushFileBuffers、UnmapViewOfFile、CloseHandle、
//       GetLastError 的新 map。
// 错误：无运行时错误；无效 map 或导入描述由格式 DSL 在汇编期诊断。
// 所有权：原 map 不被隐藏修改；返回 map 由调用方继续传给格式构造函数。
// ABI：不生成运行时调用，不影响运行时寄存器或栈。
fn io_windows64_map_imports(imports: map) -> map {
    return pe_import_use64_many(
        imports,
        "KERNEL32.DLL",
        list.of(
            "CreateFileW",
            "CloseHandle",
            "GetFileSizeEx",
            "CreateFileMappingW",
            "MapViewOfFile",
            "FlushViewOfFile",
            "FlushFileBuffers",
            "UnmapViewOfFile",
            "GetLastError"
        )
    );
}

// 把状态块恢复成关闭状态。
// 编译期参数：无。
// 运行时输入：rbx = 状态块地址。
// 返回：不设置 rax/rdx；调用方负责最终结果。
// 错误：不返回错误；调用方负责在进入前保证 rbx 有效。
// 所有权：仅清空记录，不关闭任何原生资源。
// ABI：保持 rbx 和 rsp；只写状态块内 48 字节。
fn io_map_windows64_clear_state() {
    mov qword [rbx], -1
    mov qword [rbx + 8], 0
    mov qword [rbx + 16], 0
    mov qword [rbx + 24], 0
    mov qword [rbx + 32], 0
    mov qword [rbx + 40], 0
}

// 内部单 HANDLE、BOOL 返回值 WinAPI 包装。
// 编译期参数：api_name = CloseHandle、FlushFileBuffers 或 UnmapViewOfFile。
// 运行时输入：rcx = 传给 WinAPI 的 HANDLE 或视图指针。
// 返回：成功 rax=0、rdx=0；失败 rax=-1、rdx=GetLastError()。
// 所有权：是否消费句柄由调用方语义决定；本函数只执行一次 API 调用。
// ABI：保持全部 Win64 非易失寄存器；分配 shadow space 并保持 call 前 16 字节对齐。
fn io_map_windows64_bool1(api_name: string) {
    assert(len(api_name) > 0, "Windows map API name is empty");

    sub rsp, 40
    isa(sym.join("call [rel ", api_name, "]"));
    mov [rsp + 32], eax
    call [rel GetLastError]
    mov edx, eax
    mov r11d, [rsp + 32]
    test r11d, r11d
    mov rax, -1
    mov r10, 0
    cmovne rax, r10
    cmovne rdx, r10
    add rsp, 40
}

// 打开现有文件并建立只读完整映射。
// 编译期参数：无。
// 运行时输入：rdi = 48 字节关闭状态块，rsi = UTF-16LE 零结尾路径。
// 返回：成功 rax=视图指针，空文件为 0，rdx=0；
//       失败 rax=-1，rdx=GetLastError() 或 io_map_error_invalid_state。
// 所有权：成功后状态块拥有文件 HANDLE、映射 HANDLE 和视图；空文件只拥有文件 HANDLE。
// ABI：保持 rbx、r12-r15、rsi 和 rsp；分配 shadow space，破坏 Win64 易失整数寄存器。
fn io_map_open_read() {
    const invalid_state_label: string = sym.unique("__iom_wor_bad_state_")
    const open_failed_label: string = sym.unique("__iom_wor_open_failed_")
    const size_failed_label: string = sym.unique("__iom_wor_size_failed_")
    const empty_label: string = sym.unique("__iom_wor_empty_")
    const mapping_failed_label: string = sym.unique("__iom_wor_mapping_failed_")
    const view_failed_label: string = sym.unique("__iom_wor_view_failed_")
    const restore_label: string = sym.unique("__iom_wor_restore_")
    const end_label: string = sym.unique("__iom_wor_end_")

    test rdi, rdi
    isa(sym.join("jz ", invalid_state_label));
    cmp qword [rdi + 32], 0
    isa(sym.join("jne ", invalid_state_label));

    push rbx
    push r12
    push r13
    push r14
    push r15
    push rsi
    mov rbx, rdi
    io_map_windows64_clear_state();

    io_windows64_open_path(io_windows64_generic_read, io_windows64_open_existing);
    cmp rax, -1
    isa(sym.join("je ", open_failed_label));
    mov [rbx], rax
    mov r12, rax

    sub rsp, 56
    mov rcx, r12
    lea rdx, [rsp + 40]
    call [rel GetFileSizeEx]
    mov [rsp + 48], eax
    call [rel GetLastError]
    mov edx, eax
    mov r13, [rsp + 40]
    mov r11d, [rsp + 48]
    add rsp, 56
    test r11d, r11d
    isa(sym.join("jz ", size_failed_label));
    mov [rbx + 24], r13
    test r13, r13
    isa(sym.join("jz ", empty_label));

    sub rsp, 56
    mov rcx, r12
    xor edx, edx
    mov r8d, io_map_windows64_page_readonly
    xor r9d, r9d
    mov qword [rsp + 32], 0
    mov qword [rsp + 40], 0
    call [rel CreateFileMappingW]
    mov [rsp + 48], rax
    call [rel GetLastError]
    mov edx, eax
    mov r14, [rsp + 48]
    add rsp, 56
    test r14, r14
    isa(sym.join("jz ", mapping_failed_label));
    mov [rbx + 8], r14

    sub rsp, 72
    mov rcx, r14
    mov edx, io_map_windows64_file_map_read
    xor r8d, r8d
    xor r9d, r9d
    mov qword [rsp + 32], 0
    call [rel MapViewOfFile]
    mov [rsp + 40], rax
    call [rel GetLastError]
    mov edx, eax
    mov rax, [rsp + 40]
    add rsp, 72
    test rax, rax
    isa(sym.join("jz ", view_failed_label));

    mov [rbx + 16], rax
    mov qword [rbx + 32], 1
    xor edx, edx
    isa(sym.join("jmp ", restore_label));

    label.define(empty_label);
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 1
    xor eax, eax
    xor edx, edx
    isa(sym.join("jmp ", restore_label));

    label.define(view_failed_label);
    mov r13, rdx
    mov rcx, [rbx + 8]
    io_map_windows64_bool1("CloseHandle");
    mov rcx, [rbx]
    io_map_windows64_bool1("CloseHandle");
    io_map_windows64_clear_state();
    mov rax, -1
    mov rdx, r13
    isa(sym.join("jmp ", restore_label));

    label.define(mapping_failed_label);
    label.define(size_failed_label);
    mov r13, rdx
    mov rcx, [rbx]
    io_map_windows64_bool1("CloseHandle");
    io_map_windows64_clear_state();
    mov rax, -1
    mov rdx, r13
    isa(sym.join("jmp ", restore_label));

    label.define(open_failed_label);
    io_map_windows64_clear_state();

    label.define(restore_label);
    pop rsi
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    isa(sym.join("jmp ", end_label));

    label.define(invalid_state_label);
    mov rax, -1
    mov edx, 0x7fff2001

    label.define(end_label);
}

// 创建或截断文件并建立读写完整映射。
// 编译期参数：无。
// 运行时输入：rdi = 48 字节关闭状态块，rsi = UTF-16LE 路径，rcx = 映射长度。
// 返回：成功 rax=可写视图、rdx=0；失败 rax=-1、rdx=Win32 错误或 io_map_error_*。
// 所有权：成功后状态块拥有文件 HANDLE、映射 HANDLE 和视图；失败时状态关闭。
// ABI：保持 rbx、r12-r15、rsi 和 rsp；分配 shadow space，破坏 Win64 易失整数寄存器。
fn io_map_create() {
    const invalid_state_label: string = sym.unique("__iom_wc_bad_state_")
    const invalid_length_label: string = sym.unique("__iom_wc_bad_length_")
    const open_failed_label: string = sym.unique("__iom_wc_open_failed_")
    const mapping_failed_label: string = sym.unique("__iom_wc_mapping_failed_")
    const view_failed_label: string = sym.unique("__iom_wc_view_failed_")
    const restore_label: string = sym.unique("__iom_wc_restore_")
    const end_label: string = sym.unique("__iom_wc_end_")

    test rdi, rdi
    isa(sym.join("jz ", invalid_state_label));
    cmp qword [rdi + 32], 0
    isa(sym.join("jne ", invalid_state_label));
    test rcx, rcx
    isa(sym.join("jz ", invalid_length_label));
    mov r10, rcx
    shr r10, 63
    test r10, r10
    isa(sym.join("jnz ", invalid_length_label));

    push rbx
    push r12
    push r13
    push r14
    push r15
    push rsi
    mov rbx, rdi
    mov r12, rcx
    io_map_windows64_clear_state();

    io_windows64_open_path(io_windows64_generic_read | io_windows64_generic_write, io_windows64_create_always);
    cmp rax, -1
    isa(sym.join("je ", open_failed_label));
    mov [rbx], rax
    mov r13, rax

    sub rsp, 56
    mov rcx, r13
    xor edx, edx
    mov r8d, io_map_windows64_page_readwrite
    mov r9, r12
    shr r9, 32
    mov [rsp + 32], r12d
    mov qword [rsp + 40], 0
    call [rel CreateFileMappingW]
    mov [rsp + 48], rax
    call [rel GetLastError]
    mov edx, eax
    mov r14, [rsp + 48]
    add rsp, 56
    test r14, r14
    isa(sym.join("jz ", mapping_failed_label));
    mov [rbx + 8], r14

    sub rsp, 72
    mov rcx, r14
    mov edx, io_map_windows64_file_map_write
    xor r8d, r8d
    xor r9d, r9d
    mov qword [rsp + 32], 0
    call [rel MapViewOfFile]
    mov [rsp + 40], rax
    call [rel GetLastError]
    mov edx, eax
    mov rax, [rsp + 40]
    add rsp, 72
    test rax, rax
    isa(sym.join("jz ", view_failed_label));

    mov [rbx + 16], rax
    mov [rbx + 24], r12
    mov qword [rbx + 32], 2
    xor edx, edx
    isa(sym.join("jmp ", restore_label));

    label.define(view_failed_label);
    mov r13, rdx
    mov rcx, [rbx + 8]
    io_map_windows64_bool1("CloseHandle");
    mov rcx, [rbx]
    io_map_windows64_bool1("CloseHandle");
    io_map_windows64_clear_state();
    mov rax, -1
    mov rdx, r13
    isa(sym.join("jmp ", restore_label));

    label.define(mapping_failed_label);
    mov r12, rdx
    mov rcx, [rbx]
    io_map_windows64_bool1("CloseHandle");
    io_map_windows64_clear_state();
    mov rax, -1
    mov rdx, r12
    isa(sym.join("jmp ", restore_label));

    label.define(open_failed_label);
    io_map_windows64_clear_state();

    label.define(restore_label);
    pop rsi
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    isa(sym.join("jmp ", end_label));

    label.define(invalid_state_label);
    mov rax, -1
    mov edx, 0x7fff2001
    isa(sym.join("jmp ", end_label));

    label.define(invalid_length_label);
    mov rax, -1
    mov edx, 0x7fff2002

    label.define(end_label);
}

// 刷新写映射到系统存储栈。
// 编译期参数：无。
// 运行时输入：rdi = 已打开的映射状态块。
// 返回：成功或只读映射 rax=0、rdx=0；失败 rax=-1、rdx=Win32 错误码。
// 所有权：不关闭 HANDLE 或视图；只提交写映射页面并刷新文件缓冲。
// ABI：保持 rbx 和 rsp；分配 shadow space，破坏 Win64 易失整数寄存器。
fn io_map_flush() {
    const read_label: string = sym.unique("__iom_wf_read_")
    const invalid_state_label: string = sym.unique("__iom_wf_bad_state_")
    const view_failed_label: string = sym.unique("__iom_wf_view_failed_")
    const view_done_label: string = sym.unique("__iom_wf_view_done_")
    const keep_first_error_label: string = sym.unique("__iom_wf_keep_first_")
    const success_label: string = sym.unique("__iom_wf_success_")
    const restore_label: string = sym.unique("__iom_wf_restore_")

    test rdi, rdi
    isa(sym.join("jz ", invalid_state_label));
    mov r10, [rdi + 32]
    cmp r10, 1
    isa(sym.join("je ", read_label));
    cmp r10, 2
    isa(sym.join("jne ", invalid_state_label));

    push rbx
    push r12
    mov rbx, rdi
    xor r12d, r12d

    mov rcx, [rbx + 16]
    mov rdx, [rbx + 24]
    sub rsp, 40
    call [rel FlushViewOfFile]
    mov [rsp + 32], eax
    call [rel GetLastError]
    mov edx, eax
    mov r11d, [rsp + 32]
    add rsp, 40
    test r11d, r11d
    isa(sym.join("jz ", view_failed_label));
    xor r12d, r12d
    isa(sym.join("jmp ", view_done_label));

    label.define(view_failed_label);
    mov r12, rdx

    label.define(view_done_label);
    mov rcx, [rbx]
    io_map_windows64_bool1("FlushFileBuffers");
    test rdx, rdx
    isa(sym.join("jz ", keep_first_error_label));
    test r12, r12
    isa(sym.join("jnz ", keep_first_error_label));
    mov r12, rdx

    label.define(keep_first_error_label);
    test r12, r12
    isa(sym.join("jz ", success_label));
    mov rax, -1
    mov rdx, r12
    isa(sym.join("jmp ", restore_label));

    label.define(success_label);
    xor eax, eax
    xor edx, edx
    isa(sym.join("jmp ", restore_label));

    label.define(read_label);
    xor eax, eax
    xor edx, edx
    isa(sym.join("jmp ", invalid_state_label, "_end"));

    label.define(invalid_state_label);
    mov rax, -1
    mov edx, 0x7fff2001
    isa(sym.join("jmp ", invalid_state_label, "_end"));

    label.define(restore_label);
    pop r12
    pop rbx

    label.define(sym.join(invalid_state_label, "_end"));
}

// 关闭映射并消费状态块拥有的视图、映射 HANDLE 和文件 HANDLE。
// 编译期参数：无。
// 运行时输入：rdi = 已打开的映射状态块。
// 返回：成功 rax=0、rdx=0；失败 rax=-1、rdx=首个刷新/解除映射/关闭错误。
// 所有权：调用后状态块清空；即使返回失败也不再拥有原生资源。
// ABI：保持 rbx、r12-r14 和 rsp；分配 shadow space，破坏 Win64 易失整数寄存器。
fn io_map_close() {
    const skip_flush_label: string = sym.unique("__iom_wclose_skip_flush_")
    const skip_unmap_label: string = sym.unique("__iom_wclose_skip_unmap_")
    const keep_unmap_error_label: string = sym.unique("__iom_wclose_keep_unmap_")
    const keep_mapping_error_label: string = sym.unique("__iom_wclose_keep_mapping_")
    const keep_file_error_label: string = sym.unique("__iom_wclose_keep_file_")
    const success_label: string = sym.unique("__iom_wclose_success_")
    const invalid_state_label: string = sym.unique("__iom_wclose_bad_state_")
    const restore_invalid_state_label: string = sym.unique("__iom_wclose_restore_bad_state_")
    const restore_label: string = sym.unique("__iom_wclose_restore_")

    test rdi, rdi
    isa(sym.join("jz ", invalid_state_label));

    push rbx
    push r12
    push r13
    push r14
    mov rbx, rdi
    xor r12d, r12d
    mov r10, [rbx + 32]
    cmp r10, 1
    isa(sym.join("je ", skip_flush_label));
    cmp r10, 2
    isa(sym.join("jne ", restore_invalid_state_label));

    mov rdi, rbx
    io_map_flush();
    test rdx, rdx
    isa(sym.join("jz ", skip_flush_label));
    mov r12, rdx

    label.define(skip_flush_label);
    mov rcx, [rbx + 16]
    test rcx, rcx
    isa(sym.join("jz ", skip_unmap_label));
    io_map_windows64_bool1("UnmapViewOfFile");
    test rdx, rdx
    isa(sym.join("jz ", skip_unmap_label));
    test r12, r12
    isa(sym.join("jnz ", keep_unmap_error_label));
    mov r12, rdx

    label.define(keep_unmap_error_label);
    label.define(skip_unmap_label);
    mov rcx, [rbx + 8]
    test rcx, rcx
    isa(sym.join("jz ", keep_mapping_error_label));
    io_map_windows64_bool1("CloseHandle");
    test rdx, rdx
    isa(sym.join("jz ", keep_mapping_error_label));
    test r12, r12
    isa(sym.join("jnz ", keep_mapping_error_label));
    mov r12, rdx

    label.define(keep_mapping_error_label);
    mov rcx, [rbx]
    io_map_windows64_bool1("CloseHandle");
    test rdx, rdx
    isa(sym.join("jz ", keep_file_error_label));
    test r12, r12
    isa(sym.join("jnz ", keep_file_error_label));
    mov r12, rdx

    label.define(keep_file_error_label);
    io_map_windows64_clear_state();
    test r12, r12
    isa(sym.join("jz ", success_label));
    mov rax, -1
    mov rdx, r12
    isa(sym.join("jmp ", restore_label));

    label.define(success_label);
    xor eax, eax
    xor edx, edx

    label.define(restore_label);
    pop r14
    pop r13
    pop r12
    pop rbx
    isa(sym.join("jmp ", invalid_state_label, "_end"));

    label.define(restore_invalid_state_label);
    mov rax, -1
    mov edx, 0x7fff2001
    isa(sym.join("jmp ", restore_label));

    label.define(invalid_state_label);
    mov rax, -1
    mov edx, 0x7fff2001

    label.define(sym.join(invalid_state_label, "_end"));
}

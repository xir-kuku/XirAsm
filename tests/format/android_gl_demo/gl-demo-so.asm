// A GLES2 renderer for Android, assembled by XIRASM into libmain.so.
//
// The framework loads this library because the manifest names it, and calls
// ANativeActivity_onCreate. The callback table the framework passes in is filled
// with our own functions: when the native window arrives we set up EGL, upload a
// texture generated at assembly time, and draw one full-screen quad. Nothing
// else runs, so the picture on screen comes from this file alone and the library
// needs no runtime beyond the platform's own EGL and GLES libraries.
//
// Native record types provide callback offsets through offset_of.
//
// Assemble it with the Android target, for example:
//   xirasm gl-demo-so.asm -o libmain.so
import("format/format.inc");
import("os/android/structs/native_activity.inc");
import("os/android/imports/libandroid.inc");
import("os/android/imports/libEGL.inc");
import("os/android/imports/libGLESv2.inc");

let image: map = format_elf64_so(
    "libmain.so",
    list.of(
        format_segment(".text", format_load | format_readable | format_executable),
        format_segment(".data", format_load | format_readable | format_writeable)
    )
)
let exports: list = format_elfso_export_new()
map.set_mut(image, "load_align", elf_android_page_align);
format_elfso_export_many_mut(exports, list.of("ANativeActivity_onCreate"), ".text", 16)
let imports: list = format_elfso_import_new()
android_import_android_add_checked_mut(imports, image, list.of(
    android_import_android_ANativeWindow_getWidth,
    android_import_android_ANativeWindow_getHeight), 26, 16)
android_import_egl_add_checked_mut(imports, image, list.of(
    android_import_egl_eglGetDisplay, android_import_egl_eglInitialize,
    android_import_egl_eglChooseConfig, android_import_egl_eglCreateWindowSurface,
    android_import_egl_eglCreateContext, android_import_egl_eglMakeCurrent,
    android_import_egl_eglSwapBuffers), 26, 16)
android_import_glesv2_add_checked_mut(imports, image, list.of(
    android_import_glesv2_glViewport, android_import_glesv2_glCreateShader,
    android_import_glesv2_glShaderSource, android_import_glesv2_glCompileShader,
    android_import_glesv2_glCreateProgram, android_import_glesv2_glAttachShader,
    android_import_glesv2_glLinkProgram, android_import_glesv2_glUseProgram,
    android_import_glesv2_glGetAttribLocation, android_import_glesv2_glGetUniformLocation,
    android_import_glesv2_glGenTextures, android_import_glesv2_glBindTexture,
    android_import_glesv2_glTexImage2D, android_import_glesv2_glTexParameteri,
    android_import_glesv2_glUniform1i, android_import_glesv2_glEnableVertexAttribArray,
    android_import_glesv2_glVertexAttribPointer, android_import_glesv2_glDrawArrays), 26, 16)
format_elfso_tables_mut(image, exports, imports)

// Each selected symbol was checked against API 26 and the x86-64 image above.
format_begin(image);

// ---------------------------------------------------------------------------
// Code
// ---------------------------------------------------------------------------

format_segment_begin(image, ".text");

// The entry the framework resolves. A stub keeps the exported symbol size a fact
// of this file instead of a count over the whole implementation.
ANativeActivity_onCreate:
    jmp demo_install_callbacks

demo_install_callbacks:
    mov rax, [rdi + offset_of(ANativeActivity, callbacks)]
    lea rdx, [rel demo_on_destroy]
    mov [rax + offset_of(ANativeActivityCallbacks, onDestroy)], rdx
    lea rdx, [rel demo_on_window_created]
    mov [rax + offset_of(ANativeActivityCallbacks, onNativeWindowCreated)], rdx
    lea rdx, [rel demo_on_redraw]
    mov [rax + offset_of(ANativeActivityCallbacks, onNativeWindowRedrawNeeded)], rdx
    lea rdx, [rel demo_on_window_destroyed]
    mov [rax + offset_of(ANativeActivityCallbacks, onNativeWindowDestroyed)], rdx
    ret

// onNativeWindowCreated(activity, window): bring up EGL and draw once.
demo_on_window_created:
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 96
    mov r14, rsi

    xor edi, edi
    call eglGetDisplay_plt
    mov [rel g_display], rax

    mov rdi, rax
    xor esi, esi
    xor edx, edx
    call eglInitialize_plt

    mov rdi, [rel g_display]
    lea rsi, [rel demo_egl_config_attribs]
    lea rdx, [rsp]
    mov ecx, 1
    lea r8, [rsp + 8]
    call eglChooseConfig_plt

    mov rdi, [rel g_display]
    mov rsi, [rsp]
    mov rdx, r14
    xor ecx, ecx
    call eglCreateWindowSurface_plt
    mov [rel g_surface], rax

    mov rdi, [rel g_display]
    mov rsi, [rsp]
    xor edx, edx
    lea rcx, [rel demo_egl_context_attribs]
    call eglCreateContext_plt
    mov [rel g_context], rax

    mov rdi, [rel g_display]
    mov rsi, [rel g_surface]
    mov rdx, [rel g_surface]
    mov rcx, [rel g_context]
    call eglMakeCurrent_plt

    mov rdi, r14
    call ANativeWindow_getWidth_plt
    mov [rel g_width], eax
    mov rdi, r14
    call ANativeWindow_getHeight_plt
    mov [rel g_height], eax

    // Vertex shader. The source pointer travels on the stack because the call
    // wants an array of pointers.
    mov edi, 0x8B31
    call glCreateShader_plt
    mov [rsp + 40], rax
    lea rax, [rel demo_vertex_source]
    mov [rsp + 32], rax
    mov rdi, [rsp + 40]
    mov esi, 1
    lea rdx, [rsp + 32]
    xor ecx, ecx
    call glShaderSource_plt
    mov rdi, [rsp + 40]
    call glCompileShader_plt

    // Fragment shader.
    mov edi, 0x8B30
    call glCreateShader_plt
    mov [rsp + 48], rax
    lea rax, [rel demo_fragment_source]
    mov [rsp + 32], rax
    mov rdi, [rsp + 48]
    mov esi, 1
    lea rdx, [rsp + 32]
    xor ecx, ecx
    call glShaderSource_plt
    mov rdi, [rsp + 48]
    call glCompileShader_plt

    // Program.
    call glCreateProgram_plt
    mov [rel g_program], rax
    mov rdi, rax
    mov rsi, [rsp + 40]
    call glAttachShader_plt
    mov rdi, [rel g_program]
    mov rsi, [rsp + 48]
    call glAttachShader_plt
    mov rdi, [rel g_program]
    call glLinkProgram_plt

    mov rdi, [rel g_program]
    lea rsi, [rel demo_attrib_position]
    call glGetAttribLocation_plt
    mov [rel g_attrib_position], eax
    mov rdi, [rel g_program]
    lea rsi, [rel demo_attrib_uv]
    call glGetAttribLocation_plt
    mov [rel g_attrib_uv], eax
    mov rdi, [rel g_program]
    lea rsi, [rel demo_uniform_texture]
    call glGetUniformLocation_plt
    mov [rel g_uniform_texture], eax

    // Texture, uploaded from the bytes this file generated at assembly time.
    mov edi, 1
    lea rsi, [rsp + 64]
    call glGenTextures_plt
    mov eax, [rsp + 64]
    mov [rel g_texture], eax

    mov edi, 0x0DE1
    mov esi, [rel g_texture]
    call glBindTexture_plt
    sub rsp, 32
    mov qword [rsp], 0x1908
    mov qword [rsp + 8], 0x1401
    lea rax, [rel demo_texture]
    mov [rsp + 16], rax
    mov edi, 0x0DE1
    xor esi, esi
    mov edx, 0x1908
    mov ecx, 16
    mov r8d, 16
    xor r9d, r9d
    call glTexImage2D_plt
    add rsp, 32

    // Nearest filtering keeps the generated pixels crisp when magnified.
    mov edi, 0x0DE1
    mov esi, 0x2801
    mov edx, 0x2600
    call glTexParameteri_plt
    mov edi, 0x0DE1
    mov esi, 0x2800
    mov edx, 0x2600
    call glTexParameteri_plt
    mov edi, 0x0DE1
    mov esi, 0x2802
    mov edx, 0x812F
    call glTexParameteri_plt
    mov edi, 0x0DE1
    mov esi, 0x2803
    mov edx, 0x812F
    call glTexParameteri_plt

    call demo_present

    add rsp, 96
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

// onNativeWindowRedrawNeeded: the surface survived, so redraw the same frame.
demo_on_redraw:
    mov rax, [rel g_program]
    test rax, rax
    jz demo_redraw_done
    sub rsp, 8
    call demo_present
    add rsp, 8
demo_redraw_done:
    ret

// onNativeWindowDestroyed: the surface belongs to the window that just went
// away, so drop the references instead of drawing into freed memory.
demo_on_window_destroyed:
    mov qword [rel g_surface], 0
    mov qword [rel g_display], 0
    mov qword [rel g_context], 0
    ret

// onDestroy: nothing to release and no exit call to make. The framework finishes
// the activity and the loader drops the library afterwards.
demo_on_destroy:
    ret

// Draw the quad with the current context and put the frame on screen.
demo_present:
    sub rsp, 8
    xor edi, edi
    xor esi, esi
    mov edx, [rel g_width]
    mov ecx, [rel g_height]
    call glViewport_plt

    mov rdi, [rel g_program]
    call glUseProgram_plt

    mov edi, 0x0DE1
    mov esi, [rel g_texture]
    call glBindTexture_plt
    mov edi, [rel g_uniform_texture]
    xor esi, esi
    call glUniform1i_plt

    mov edi, [rel g_attrib_position]
    call glEnableVertexAttribArray_plt
    mov edi, [rel g_attrib_position]
    mov esi, 2
    mov edx, 0x1406
    xor ecx, ecx
    mov r8d, 16
    lea r9, [rel demo_vertices]
    call glVertexAttribPointer_plt

    mov edi, [rel g_attrib_uv]
    call glEnableVertexAttribArray_plt
    mov edi, [rel g_attrib_uv]
    mov esi, 2
    mov edx, 0x1406
    xor ecx, ecx
    mov r8d, 16
    lea r9, [rel demo_vertices + 8]
    call glVertexAttribPointer_plt

    mov edi, 5
    xor esi, esi
    mov edx, 4
    call glDrawArrays_plt

    mov rdi, [rel g_display]
    mov rsi, [rel g_surface]
    call eglSwapBuffers_plt
    add rsp, 8
    ret

format_segment_end(image, ".text");

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

format_segment_begin(image, ".data");

// EGL_RENDERABLE_TYPE = EGL_OPENGL_ES2_BIT, EGL_SURFACE_TYPE = EGL_WINDOW_BIT,
// eight bits per channel, then EGL_NONE.
demo_egl_config_attribs:
    dd(0x3033)
    dd(0x0004)
    dd(0x3040)
    dd(0x0004)
    dd(0x3024)
    dd(8)
    dd(0x3023)
    dd(8)
    dd(0x3022)
    dd(8)
    dd(0x3038)
    dd(0)

// EGL_CONTEXT_CLIENT_VERSION = 2, then EGL_NONE.
demo_egl_context_attribs:
    dd(0x3098)
    dd(2)
    dd(0x3038)
    dd(0)

// Shader sources. Each is one NUL terminated string, and the line feed inside
// keeps the two statements apart for the compiler.
demo_vertex_source:
    db("attribute vec2 a_pos; attribute vec2 a_uv; varying vec2 v_uv;", 10)
    db("void main() { v_uv = a_uv; gl_Position = vec4(a_pos, 0.0, 1.0); }", 0);

demo_fragment_source:
    db("precision mediump float; varying vec2 v_uv; uniform sampler2D u_tex;", 10)
    db("void main() { gl_FragColor = texture2D(u_tex, v_uv); }", 0);

demo_attrib_position:
    db("a_pos", 0);
demo_attrib_uv:
    db("a_uv", 0);
demo_uniform_texture:
    db("u_tex", 0);

// One quad as a triangle strip: x, y, u, v per corner, single precision. The
// corners are (-1,-1,0,1), (1,-1,1,1), (-1,1,0,0), (1,1,1,0).
demo_vertices:
    dd(0xBF800000)
    dd(0xBF800000)
    dd(0x00000000)
    dd(0x3F800000)
    dd(0x3F800000)
    dd(0xBF800000)
    dd(0x3F800000)
    dd(0x3F800000)
    dd(0xBF800000)
    dd(0x3F800000)
    dd(0x00000000)
    dd(0x00000000)
    dd(0x3F800000)
    dd(0x3F800000)
    dd(0x3F800000)
    dd(0x00000000)

// The texture, 16 x 16 RGBA, generated here rather than loaded: a bright cross
// on a field that brightens towards the middle, inside an amber frame.
demo_texture:
    let row: u64 = 0
    while row < 16 {
        let column: u64 = 0
        while column < 16 {
            let red: u64 = 12 + row * 3
            let green: u64 = 20 + column * 3
            let blue: u64 = 70
            if column == row || column + row == 15 {
                red = 90
                green = 220
                blue = 255
            }
            if column == 0 || column == 15 || row == 0 || row == 15 {
                red = 255
                green = 150
                blue = 40
            }
            emit.u8(red);
            emit.u8(green);
            emit.u8(blue);
            emit.u8(255);
            column = column + 1
        }
        row = row + 1
    }

// State the callbacks share.
g_display:
    dq(0)
g_surface:
    dq(0)
g_context:
    dq(0)
g_program:
    dq(0)
g_texture:
    dd(0)
g_attrib_position:
    dd(0)
g_attrib_uv:
    dd(0)
g_uniform_texture:
    dd(0)
g_width:
    dd(0)
g_height:
    dd(0)

format_segment_end(image, ".data");

format_finish(image);

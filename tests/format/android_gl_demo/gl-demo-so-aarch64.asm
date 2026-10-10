// The same GLES2 renderer as gl-demo-so.asm, written in AArch64 instructions.
//
// The algorithm is unchanged: the framework calls ANativeActivity_onCreate, the
// window callback brings up EGL, compiles the two shaders, uploads the texture
// this file generates at assembly time, and draws one full-screen quad.
//
// What differs is the ABI. Arguments go in x0-x7 and results come back in x0, so
// the platform calls reach their GOT slots through ldr/blr instead of a PLT. Data
// labels are addressed with adrp plus the :lo12: page offset. glTexImage2D takes
// nine arguments, which puts the pixel pointer on the stack.
//
// Native record types provide callback offsets through offset_of.
//
// Assemble it with:
//   xirasm gl-demo-so-aarch64.asm -o libmain.so
import("format/format.inc");
import("os/android/structs/native_activity.inc");
import("os/android/imports/libandroid.inc");
import("os/android/imports/libEGL.inc");
import("os/android/imports/libGLESv2.inc");
import("arm/a64-macros.inc");

let image: map = format_elf64_so_aarch64(
    "libmain.so",
    list.of(
        format_segment(".text", format_load | format_readable | format_executable),
        format_segment(".data", format_load | format_readable | format_writeable)
    )
)
let exports: list = format_elfso_export_new()
format_elfso_export_many_mut(exports, list.of("ANativeActivity_onCreate"), ".text", 16)
let imports: list = format_elfso_import_new()
android_import_android_add_slots_checked_mut(imports, image, list.of(
    android_import_android_ANativeWindow_getWidth,
    android_import_android_ANativeWindow_getHeight), 26, 1)
android_import_egl_add_slots_checked_mut(imports, image, list.of(
    android_import_egl_eglGetDisplay, android_import_egl_eglInitialize,
    android_import_egl_eglChooseConfig, android_import_egl_eglCreateWindowSurface,
    android_import_egl_eglCreateContext, android_import_egl_eglMakeCurrent,
    android_import_egl_eglSwapBuffers), 26, 1)
android_import_glesv2_add_slots_checked_mut(imports, image, list.of(
    android_import_glesv2_glViewport, android_import_glesv2_glCreateShader,
    android_import_glesv2_glShaderSource, android_import_glesv2_glCompileShader,
    android_import_glesv2_glCreateProgram, android_import_glesv2_glAttachShader,
    android_import_glesv2_glLinkProgram, android_import_glesv2_glUseProgram,
    android_import_glesv2_glGetAttribLocation, android_import_glesv2_glGetUniformLocation,
    android_import_glesv2_glGenTextures, android_import_glesv2_glBindTexture,
    android_import_glesv2_glTexImage2D, android_import_glesv2_glTexParameteri,
    android_import_glesv2_glUniform1i, android_import_glesv2_glEnableVertexAttribArray,
    android_import_glesv2_glVertexAttribPointer, android_import_glesv2_glDrawArrays), 26, 1)
format_elfso_tables_mut(image, exports, imports)

// Each selected symbol was checked against API 26 and the AArch64 image above.
format_begin(image);

// ---------------------------------------------------------------------------
// Code
// ---------------------------------------------------------------------------

format_segment_begin(image, ".text");

// The entry the framework resolves. A stub keeps the exported symbol size a fact
// of this file instead of a count over the whole implementation.
ANativeActivity_onCreate:
    b demo_install_callbacks

demo_install_callbacks:
    ldr x1, [x0, #offset_of(ANativeActivity, callbacks)]
    adrp x2, demo_on_destroy
    add x2, x2, :lo12:demo_on_destroy
    str x2, [x1, #offset_of(ANativeActivityCallbacks, onDestroy)]
    adrp x2, demo_on_window_created
    add x2, x2, :lo12:demo_on_window_created
    str x2, [x1, #offset_of(ANativeActivityCallbacks, onNativeWindowCreated)]
    adrp x2, demo_on_redraw
    add x2, x2, :lo12:demo_on_redraw
    str x2, [x1, #offset_of(ANativeActivityCallbacks, onNativeWindowRedrawNeeded)]
    adrp x2, demo_on_window_destroyed
    add x2, x2, :lo12:demo_on_window_destroyed
    str x2, [x1, #offset_of(ANativeActivityCallbacks, onNativeWindowDestroyed)]
    ret

// onNativeWindowCreated(activity, window): bring up EGL and draw once.
//
// Frame layout below sp: config, num_config, vertex shader, fragment shader,
// one pointer slot for glShaderSource, the texture name, then padding.
demo_on_window_created:
    stp x19, x30, [sp, #-16]!
    sub sp, sp, #80
    mov x19, x1

    mov w0, #0
    ldr x8, eglGetDisplay
    blr x8
    adrp x9, g_display
    add x9, x9, :lo12:g_display
    str x0, [x9]

    mov x1, #0
    mov x2, #0
    ldr x8, eglInitialize
    blr x8

    ldr x0, g_display
    adrp x1, demo_egl_config_attribs
    add x1, x1, :lo12:demo_egl_config_attribs
    add x2, sp, #0
    mov w3, #1
    add x4, sp, #8
    ldr x8, eglChooseConfig
    blr x8

    ldr x0, g_display
    ldr x1, [sp, #0]
    mov x2, x19
    mov x3, #0
    ldr x8, eglCreateWindowSurface
    blr x8
    adrp x9, g_surface
    add x9, x9, :lo12:g_surface
    str x0, [x9]

    ldr x0, g_display
    ldr x1, [sp, #0]
    mov x2, #0
    adrp x3, demo_egl_context_attribs
    add x3, x3, :lo12:demo_egl_context_attribs
    ldr x8, eglCreateContext
    blr x8
    adrp x9, g_context
    add x9, x9, :lo12:g_context
    str x0, [x9]

    ldr x0, g_display
    ldr x1, g_surface
    mov x2, x1
    ldr x3, g_context
    ldr x8, eglMakeCurrent
    blr x8

    mov x0, x19
    ldr x8, ANativeWindow_getWidth
    blr x8
    adrp x9, g_width
    add x9, x9, :lo12:g_width
    str w0, [x9]

    mov x0, x19
    ldr x8, ANativeWindow_getHeight
    blr x8
    adrp x9, g_height
    add x9, x9, :lo12:g_height
    str w0, [x9]

    // Vertex shader. The source pointer travels on the stack because the call
    // wants an array of pointers.
    mov w0, #0x8B31
    ldr x8, glCreateShader
    blr x8
    str x0, [sp, #16]
    adrp x9, demo_vertex_source
    add x9, x9, :lo12:demo_vertex_source
    str x9, [sp, #32]
    mov w1, #1
    add x2, sp, #32
    mov x3, #0
    ldr x8, glShaderSource
    blr x8
    ldr x0, [sp, #16]
    ldr x8, glCompileShader
    blr x8

    // Fragment shader.
    mov w0, #0x8B30
    ldr x8, glCreateShader
    blr x8
    str x0, [sp, #24]
    adrp x9, demo_fragment_source
    add x9, x9, :lo12:demo_fragment_source
    str x9, [sp, #32]
    mov w1, #1
    add x2, sp, #32
    mov x3, #0
    ldr x8, glShaderSource
    blr x8
    ldr x0, [sp, #24]
    ldr x8, glCompileShader
    blr x8

    // Program.
    ldr x8, glCreateProgram
    blr x8
    adrp x9, g_program
    add x9, x9, :lo12:g_program
    str x0, [x9]
    ldr x1, [sp, #16]
    ldr x8, glAttachShader
    blr x8
    ldr x0, g_program
    ldr x1, [sp, #24]
    ldr x8, glAttachShader
    blr x8
    ldr x0, g_program
    ldr x8, glLinkProgram
    blr x8

    ldr x0, g_program
    adrp x1, demo_attrib_position
    add x1, x1, :lo12:demo_attrib_position
    ldr x8, glGetAttribLocation
    blr x8
    adrp x9, g_attrib_position
    add x9, x9, :lo12:g_attrib_position
    str w0, [x9]

    ldr x0, g_program
    adrp x1, demo_attrib_uv
    add x1, x1, :lo12:demo_attrib_uv
    ldr x8, glGetAttribLocation
    blr x8
    adrp x9, g_attrib_uv
    add x9, x9, :lo12:g_attrib_uv
    str w0, [x9]

    ldr x0, g_program
    adrp x1, demo_uniform_texture
    add x1, x1, :lo12:demo_uniform_texture
    ldr x8, glGetUniformLocation
    blr x8
    adrp x9, g_uniform_texture
    add x9, x9, :lo12:g_uniform_texture
    str w0, [x9]

    // Texture, uploaded from the bytes this file generated at assembly time.
    mov w0, #1
    add x1, sp, #40
    ldr x8, glGenTextures
    blr x8
    ldr w1, [sp, #40]
    adrp x9, g_texture
    add x9, x9, :lo12:g_texture
    str w1, [x9]
    mov w0, #0x0DE1
    ldr x8, glBindTexture
    blr x8

    // glTexImage2D has nine arguments, so the pixel pointer is a stack argument.
    mov w0, #0x0DE1
    mov w1, #0
    mov w2, #0x1908
    mov w3, #16
    mov w4, #16
    mov w5, #0
    mov w6, #0x1908
    mov w7, #0x1401
    adrp x9, demo_texture
    add x9, x9, :lo12:demo_texture
    sub sp, sp, #16
    str x9, [sp, #0]
    ldr x8, glTexImage2D
    blr x8
    add sp, sp, #16

    // Nearest filtering keeps the generated pixels crisp when magnified.
    mov w0, #0x0DE1
    mov w1, #0x2801
    mov w2, #0x2600
    ldr x8, glTexParameteri
    blr x8
    mov w0, #0x0DE1
    mov w1, #0x2800
    mov w2, #0x2600
    ldr x8, glTexParameteri
    blr x8
    mov w0, #0x0DE1
    mov w1, #0x2802
    mov w2, #0x812F
    ldr x8, glTexParameteri
    blr x8
    mov w0, #0x0DE1
    mov w1, #0x2803
    mov w2, #0x812F
    ldr x8, glTexParameteri
    blr x8

    bl demo_present

    add sp, sp, #80
    ldp x19, x30, [sp], #16
    ret

// onNativeWindowRedrawNeeded: the surface survived, so redraw the same frame.
demo_on_redraw:
    ldr x9, g_program
    cmp x9, #0
    b.eq demo_redraw_done
    stp x19, x30, [sp, #-16]!
    bl demo_present
    ldp x19, x30, [sp], #16
demo_redraw_done:
    ret

// onNativeWindowDestroyed: the surface belongs to the window that just went
// away, so drop the references instead of drawing into freed memory.
demo_on_window_destroyed:
    adrp x9, g_surface
    add x9, x9, :lo12:g_surface
    str xzr, [x9]
    adrp x9, g_display
    add x9, x9, :lo12:g_display
    str xzr, [x9]
    adrp x9, g_context
    add x9, x9, :lo12:g_context
    str xzr, [x9]
    ret

// onDestroy: nothing to release and no exit call to make. The framework finishes
// the activity and the loader drops the library afterwards.
demo_on_destroy:
    ret

// Draw the quad with the current context and put the frame on screen.
demo_present:
    stp x19, x30, [sp, #-16]!
    mov w0, #0
    mov w1, #0
    ldr w2, g_width
    ldr w3, g_height
    ldr x8, glViewport
    blr x8

    ldr x0, g_program
    ldr x8, glUseProgram
    blr x8

    mov w0, #0x0DE1
    ldr w1, g_texture
    ldr x8, glBindTexture
    blr x8
    ldr w0, g_uniform_texture
    mov w1, #0
    ldr x8, glUniform1i
    blr x8

    ldr w0, g_attrib_position
    ldr x8, glEnableVertexAttribArray
    blr x8
    ldr w0, g_attrib_position
    mov w1, #2
    mov w2, #0x1406
    mov w3, #0
    mov w4, #16
    adrp x5, demo_vertices
    add x5, x5, :lo12:demo_vertices
    ldr x8, glVertexAttribPointer
    blr x8

    ldr w0, g_attrib_uv
    ldr x8, glEnableVertexAttribArray
    blr x8
    ldr w0, g_attrib_uv
    mov w1, #2
    mov w2, #0x1406
    mov w3, #0
    mov w4, #16
    adrp x5, demo_vertices
    add x5, x5, :lo12:demo_vertices
    add x5, x5, #8
    ldr x8, glVertexAttribPointer
    blr x8

    mov w0, #5
    mov w1, #0
    mov w2, #4
    ldr x8, glDrawArrays
    blr x8

    ldr x0, g_display
    ldr x1, g_surface
    ldr x8, eglSwapBuffers
    blr x8
    ldp x19, x30, [sp], #16
    ret

format_segment_end(image, ".text");

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

format_segment_begin(image, ".data");

// State the callbacks share. These come first and stay eight byte aligned: the
// code reaches them with a literal load, whose displacement has to be a multiple
// of four, and the byte strings further down would otherwise break that.
align(8);
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

align(4);
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
align(4);
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

format_segment_end(image, ".data");

format_finish(image);

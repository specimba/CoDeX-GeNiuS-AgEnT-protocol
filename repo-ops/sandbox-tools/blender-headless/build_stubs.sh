#!/usr/bin/env bash
# Build headless stub libraries for the official bpy (Blender-as-Python) wheel
# on a minimal container that has NO X11/GL system libraries and whose apt
# egress is blocked. Blender in --background mode links these libs but never
# calls them, so symbol stubs satisfy the loader.
#
# Verified: 2026-09-06 on arena.ai Agent Mode sandbox (Debian 12 bookworm,
# 2 cores / 3.8 GiB / no /dev/dri, PyPI reachable, apt + blender.org blocked).
# Result: bpy 4.2.19 LTS boots, exports .glb, and renders with Cycles CPU.
#
# Usage:  ./build_stubs.sh            # writes libs into ./out
# Then:   export LD_LIBRARY_PATH=out:$LD_LIBRARY_PATH
#         python -c "import bpy; print(bpy.app.version_string)"
set -euo pipefail
cd "$(dirname "$0")"
python3 - << 'PYEOF'
import os, subprocess, sys

SRC = "src"
OUT = "out"
os.makedirs(OUT, exist_ok=True)

def read(name):
    with open(os.path.join(SRC, name)) as f:
        return f.read()

# lib -> (source files, extra symbol list)
LIBS = {
    "libXrender.so.1":   (["sym_libXrender1.c"], []),
    "libXxf86vm.so.1":   (["sym_libXxf86vm1.c"], []),
    "libXfixes.so.3":    (["sym_libXfixes3.c"], "XFixesShowCursor XFixesHideCursor".split()),
    "libSM.so.6":        (["sym_libSM6.c"], []),
    "libICE.so.6":       (["sym_libICE6.c"], []),
    "libXi.so.6":        (["sym_libXi6.c", "xi1.c"],
        "XCloseDevice XListInputDevices XFreeDeviceList XOpenDevice "
        "XGetExtensionVersion XQueryDeviceState XFreeDeviceState "
        "XSelectExtensionEvent XDeviceBell XGetDeviceDontPropagateList "
        "_XiGetDevicePresenceNotifyEvent XGetDeviceControl XChangeDeviceControl "
        "XGetDeviceMotionEvents XGetSelectedExtensionEvents XChangeKeyboardDevice "
        "XChangePointerDevice XGetFeedbackControl XChangeFeedbackControl "
        "XGetDeviceModifierMapping XSetDeviceModifierMapping XGetDeviceKeyMapping "
        "XChangeDeviceKeyMapping XGetDeviceButtonMapping XSetDeviceButtonMapping "
        "XFreeExtensionList".split()),
    "libxkbcommon.so.0": (["sym_libxkbcommon0.c"],
        "xkb_compose_state_reset xkb_compose_state_feed "
        "xkb_compose_state_get_status xkb_compose_state_get_utf8 "
        "xkb_compose_state_get_one_shot xkb_compose_table_new_from_locale "
        "xkb_compose_table_new_from_file xkb_compose_table_ref "
        "xkb_compose_table_unref xkb_compose_state_new xkb_compose_state_ref "
        "xkb_compose_state_unref xkb_compose_state_get_direction "
        "xkb_state_key_get_utf32 xkb_keymap_new_from_buffer "
        "xkb_keymap_new_from_names xkb_state_new xkb_state_update_mask "
        "xkb_state_serialize_mods xkb_state_serialize_layout "
        "xkb_keymap_key_get_mods_for_level xkb_keymap_num_layouts_for_key "
        "xkb_state_layout_index_for_key xkb_state_key_get_layout "
        "xkb_state_mod_index_is_consumed2 xkb_utf8_to_keysym "
        "xkb_keysym_to_utf32 xkb_keysym_to_lower xkb_keysym_to_upper "
        "xkb_keysym_get_name xkb_context_set_user_data xkb_context_get_user_data "
        "xkb_context_include_path_append xkb_context_include_path_append_default "
        "xkb_context_include_path_clear xkb_context_include_path_get "
        "xkb_context_num_include_paths xkb_context_set_log_priority "
        "xkb_keymap_mod_get_index xkb_keymap_led_get_index xkb_keymap_led_get_name "
        "xkb_keymap_leds xkb_keymap_mods xkb_keymap_key_repeats "
        "xkb_keymap_key_get_syms_by_level xkb_keymap_key_get_syms "
        "xkb_state_key_get_syms xkb_state_key_get_utf8 xkb_state_key_get_one_sym "
        "xkb_state_key_get_keysym xkb_state_update_key xkb_state_get_keymap "
        "xkb_keymap_unref xkb_state_unref xkb_keymap_ref xkb_state_ref "
        "xkb_state_key_get_level xkb_state_num_mods xkb_state_num_layouts".split()),
    "libGL.so.1":        (["glx.c", "glx2.c", "gl_stubs.c"], []),
}

def build(lib, srcs, extras, version_map=None):
    body = "".join(read(s) for s in srcs)
    for s in extras:
        if not s:
            continue
        if f"void* {s}(" not in body:
            body += f"void* {s}(void){{ return 0; }}\n"
    cfile = os.path.join(OUT, f"src_{lib.replace('.so','').replace('.','_')}.c")
    with open(cfile, "w") as f:
        f.write(body)
    cmd = ["gcc", "-shared", "-fPIC", f"-Wl,-soname,{lib}", "-o", os.path.join(OUT, lib), cfile]
    if version_map:
        cmd += ["-Wl,--version-script=" + os.path.join(SRC, version_map)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print(f"FAILED {lib}:\n{r.stderr[-500:]}", file=sys.stderr)
        sys.exit(1)
    print(f"built {os.path.join(OUT, lib)}")

for lib, (srcs, extras) in LIBS.items():
    build(lib, srcs, extras, version_map="ver_xkb.map" if lib == "libxkbcommon.so.0" else None)
print("done:", sorted(os.listdir(OUT)))
PYEOF

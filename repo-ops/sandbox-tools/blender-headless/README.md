# Blender headless (bpy) in the arena.ai sandbox — verified recipe

Verified **2026-09-06** on the arena.ai Agent Mode sandbox (Debian 12, x86_64,
2 cores / 3.8 GiB RAM, **no GPU device**, 20 GiB free disk).

## Result

| Step | Outcome |
|---|---|
| `import bpy` | ✅ boots **Blender 4.2.19 LTS** (official `bpy` wheel from PyPI) |
| Procedural mesh + material via script | ✅ |
| glTF binary export | ✅ `crystal.glb`, **Khronos validator: 0 errors / 0 warnings** |
| Render (no GPU) | ✅ **Cycles CPU** render → PNG, 256×256 in ~2.5 s |

Example artifacts: `example/crystal.glb`, `example/crystal_render.png`.
Generator script used: `example/gen_crystal.py`-style bpy script (see audit doc §3).

## Why stubs are needed

The sandbox image has **no X11/GL system libraries** (`libXrender`, `libXi`,
`libXfixes`, `libXxf86vm`, `libxkbcommon`, `libSM`, `libICE`, `libGL` all
absent) and **apt is unreachable** (deb.debian.org egress blocked; every
Debian mirror probed returns connection failure). `download.blender.org` is
also blocked, but **PyPI is reachable**, and the official `bpy` manylinux
wheel bundles Blender itself. The wheel *links* the X libs at load time;
Blender in `--background` mode never *calls* them, so we satisfy the loader
with stub shared libraries carrying the needed symbol surfaces. Only
`libxkbcommon.so.0` carries a version requirement (`V_0.5.0`) — provided via
`ver_xkb.map`.

## Setup (one-time, per sandbox session)

```bash
# 1. Blender as a Python module
python3 -m venv /tmp/tools/venv
/tmp/tools/venv/bin/pip install bpy==4.2.19

# 2. Build the X/GL stubs
./build_stubs.sh          # writes ./out/*.so

# 3. Boot check
LD_LIBRARY_PATH="$PWD/out" /tmp/tools/venv/bin/python -c \
  "import bpy; print(bpy.app.version_string)"
# -> 4.2.19 LTS
```

Every headless bpy run must set
`LD_LIBRARY_PATH=<blender-headless>/out` (see `run_bpy.sh`).

## Walls documented (data, not stop signs)

- `download.blender.org` — HTTP 000 (blocked). Workaround: pip wheel.
- `deb.debian.org` + mirrors + `apt` — TCP/TLS blocked. Workaround: stubs.
- GPU — none; `/dev/dri` absent. Workaround: Cycles **CPU** device renders.
- Egress allowlist observed: pypi.org / files.pythonhosted.org / registry.npmjs.org /
  github.com / codeload.github.com / api.github.com reachable; anaconda,
  raw.githubusercontent.com, godotengine mirrors, blender.org blocked.

## Caveats

- Only `--background`/script use is supported by the stubs; anything that
  opens a real X display or GL context will fail (no Xvfb/mesa installed).
- If egress to `download.blender.org` (or apt) ever opens, prefer the official
  Blender tarball / real libs and drop the stubs.
- `/tmp` may not survive between sandbox sessions — re-run setup from this
  folder (sources are committed here).

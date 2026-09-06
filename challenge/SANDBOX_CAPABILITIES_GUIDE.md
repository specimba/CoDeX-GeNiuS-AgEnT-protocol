# SANDBOX CAPABILITIES GUIDE — engines & headless tooling (companion to BATTLE_PROMPT_v20)

**Purpose:** the verified, reproducible way for a battle agent to attempt real engine/asset tooling inside an arena sandbox — and the honest rules for when to drop it. Referenced by `BATTLE_PROMPT_v20.md` §"Headless tooling, engines & the asset pipeline". Everything here was **executed and verified** on 2026-09-06 in the arena.ai Agent Mode sandbox (Debian 12, x86_64, 2 cores / 3.8 GiB, no GPU, 20 GiB free). Full analysis: `battles/arena-sandbox-engine-capability-audit.md`.

---

## 1. The five-second availability check (do this first)

```bash
python3 -c "import bpy; print(bpy.app.version_string)"   # Blender-as-Python?
node --version && npm ping                               # node toolchain alive?
convert -version | head -1                               # ImageMagick?
curl -sI --max-time 8 https://pypi.org/ -o /dev/null -w '%{http_code}\n'   # can we fetch anything?
```

Then decide in **≤ 3 minutes**: tooling available → use the recipe below; missing or downloads blocked → **drop tooling, build code-only procedural** (fully acceptable; the loop is the grade, not the pipeline).

## 2. The verified Blender headless recipe (no GPU, no system X libs)

```bash
# Blender 4.2 LTS as a Python module (official wheel, PyPI)
python3 -m venv /tmp/tools/venv
/tmp/tools/venv/bin/pip install bpy==4.2.19

# Minimal images lack X11/GL libs (libXrender, libXi, libXfixes, libXxf86vm,
# libxkbcommon, libSM, libICE, libGL). Blender links them but never calls them
# in --background mode, so stub .so files satisfy the loader.
# Committed stub sources + one-command builder live in the package at
# repo-ops/sandbox-tools/blender-headless/  ->  ./build_stubs.sh
export LD_LIBRARY_PATH=/path/to/blender-headless/out:$LD_LIBRARY_PATH

# Boot check
/tmp/tools/venv/bin/python -c "import bpy; print(bpy.app.version_string)"   # -> 4.2.19 LTS
```

Every headless run needs that `LD_LIBRARY_PATH`. `run_bpy.sh` wraps it.

## 3. The asset pipeline (pattern to copy)

1. **Seeded generator script** — create mesh, displace/split/facet via code (example: `example/gen_crystal.py` builds a 3-fold faceted crystal from a displaced icosphere, flat-shaded, gold PBR material).
2. **Export** — `bpy.ops.export_scene.gltf(filepath="x.glb", export_format='GLB')`.
3. **Validate** — Khronos validator gate:
   ```bash
   npm init -y && npm i gltf-validator
   node -e "require('gltf-validator').validateBytes(new Uint8Array(require('fs').readFileSync('x.glb')),{}).then(r=>console.log('errors',r.issues.numErrors,'warnings',r.issues.numWarnings))"
   # verified: crystal.glb -> 0 errors / 0 warnings
   ```
4. **Load in runtime** — three.js `GLTFLoader` (works in the browser build; parsed headlessly in node too).
5. **Visual QA with zero GPU** — Cycles **CPU** device still-render:
   ```python
   bpy.context.scene.render.engine = 'CYCLES'
   bpy.context.scene.cycles.device = 'CPU'
   bpy.ops.render.render(write_still=True)
   ```
   Verified: 256×256 PNG in ~2.5 s. Look at the render before shipping anything.

## 4. What is fair and what is not (unchanged doctrine)

- **Fair:** any asset source the arena gives every agent equally — procedural, generated imagery, baked assets, engine-generated assets — **bundled into the build**, disclosed as a README receipts line.
- **Unfair:** runtime network fetches; assets from a source not equally available; hiding an iterated build behind the one-shot track.

## 5. Walls observed (data, not stop signs)

| Wall | Symptom | Workaround / status |
|---|---|---|
| `download.blender.org` blocked | HTTP 000 | official `bpy` wheel via PyPI (works) |
| No system X/GL libs + apt blocked | `ImportError: libXrender.so.1` … | committed stub `.so` builder (works; `libxkbcommon` needs `V_0.5.0` version node — handled) |
| No GPU | no `/dev/dri` | Cycles CPU renders (works) |
| Godot / Unity / Unreal binaries | CDN unreachable | **drop** — source builds cost hours and still have no render path here |
| Xvfb/mesa missing | apt blocked | GL-app screenshots impossible; Blender CPU renders cover visual QA |

Egress allowlist observed: PyPI + files.pythonhosted.org, registry.npmjs.org, github.com + codeload.github.com + api.github.com open; deb.debian.org (all mirrors), anaconda.org, raw.githubusercontent.com, blender.org, godotengine mirrors blocked.

## 6. When to drop the tooling (hard)

- Setup exceeded ~10 minutes of session budget → drop, go code-only procedural.
- Anything needs a real display / GL context / GPU → drop that path.
- Tooling is shaping the *concept* instead of serving it (the pipeline must never become the theme) → drop it.
- You cannot finish the full loop end-to-end on a fresh load with the tooled assets → ship the clean fallback (prompt's finishing rule applies to assets too).

## 7. Repro kit in this repo

- `repo-ops/sandbox-tools/blender-headless/` — `build_stubs.sh` (one-command stub build), `run_bpy.sh`, `src/` (stub sources + version map), `example/` (generator + validated `crystal.glb` + CPU-rendered PNG). Verified rebuild-from-scratch.
- `battles/arena-sandbox-engine-capability-audit.md` — full measured matrix and wall log.

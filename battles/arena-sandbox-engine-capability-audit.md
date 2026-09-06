# Arena.ai sandbox — engine & 0-GPU capability audit (verified by running, not reading)

**Date:** 2026-09-06 · **Sandbox:** arena.ai Agent Mode (Linux e2b 6.1.158+ x86_64 · Debian 12 bookworm · 2 cores · 3.8 GiB RAM · 20 GiB disk free · **no GPU device**, no `/dev/dri`)
**Trigger:** operator directive — reference the chat.z.ai glm-5.3-flash team's Blender-CLI / Godot-headless / 0-GPU findings, and test whether the *same class of capability* is usable inside the arena.ai sandbox as a conditional first path: *"If agents or the sandbox cannot handle it, we will drop these kinds of approaches here, but it's worth trying and betting on seeing what happens."*
**Method:** every claim below was produced by executing commands in this sandbox. Failures are documented as data.

---

## 0. Bottom line

- ✅ **Blender (headless, official bpy wheel) — VIABLE and VERIFIED end-to-end:** procedural mesh → material → **glTF binary export** → **Cycles CPU render (real pixels, no GPU)** → Khronos-validated. Full recipe committed under `repo-ops/sandbox-tools/blender-headless/`.
- ⚠️ **Godot — BLOCKED at the binary-egress wall** (all official mirrors/CDNs unreachable from this sandbox); a source build via `codeload.github.com` is possible in theory but is a 1–2 h single-core-scale compile with **no render path afterward** (no Xvfb/mesa installable) — dropped per the operator's conditional directive.
- ❌ **Unity / Unreal — hard-blocked** (multi-GB editor binaries, license servers, asset CDNs; none reachable; no GUI).
- ✅ **Three.js/TS runtime + node + npm + ImageMagick + glTF tooling — VIABLE** (this is the deliver-runtime tier; browser preview is a live sandbox capability).
- **Keep/drop verdict:** KEEP the Blender-CLI 0-GPU asset-studio path (it works and it is exactly the chat.z.ai team's studio tier). DROP Godot/Unity/Unreal attempts in this sandbox until egress changes.

---

## 1. Sandbox profile (measured)

| Item | Value |
|---|---|
| CPU / RAM | 2 vCPU · 3.8 GiB (≈3.6 free) |
| Disk | 21 GiB root, 20 GiB free |
| GPU | none (`/dev/dri` absent, no `nvidia-smi`) |
| OS / tools | Debian 12; gcc 12.2, python3 3.11.2 + pip, node v22.22.3 + npm, ImageMagick 6.9 (`convert`), git, curl/wget; passwordless sudo |
| Missing binaries | blender, godot, bun, ffmpeg, Xvfb/xvfb-run, glxinfo, inkscape, cargo |
| **Egress allowlist (observed)** | ✅ pypi.org + files.pythonhosted.org · registry.npmjs.org · github.com + codeload.github.com + api.github.com · ❌ download.blender.org · mirror.godotengine.org · objects.githubusercontent.com (release assets) · deb.debian.org + all Debian mirrors (TCP/TLS) · anaconda.org · raw.githubusercontent.com |

The egress allowlist is the single most load-bearing fact: **PyPI, npm, and GitHub git-protocol are open; almost everything else is not.** Every workaround below is built on that.

---

## 2. Engine feasibility matrix (executed)

| Engine | Verdict | Evidence (commands run) | Blocking constraint (exact) |
|---|---|---|---|
| **Blender 4.2 (bpy)** | ✅ **VIABLE — asset studio** | `pip install bpy==4.2.19` → boot → gen mesh → `.glb` export → **Cycles CPU render PNG** → Khronos validate 0/0 | system X/GL libs absent → **stub libs** (see §3); GPU absent → **Cycles CPU** device |
| **Three.js + TS** | ✅ **VIABLE — runtime** | npm registry reachable; GLTFLoader/`gltf-validator` parse .glb in node; browser preview is the sandbox's live-preview capability | none |
| **Godot 4.3** | ⚠️ **BLOCKED (binary egress)** | github release asset → exit 35/000 on `objects.githubusercontent.com`; mirror.godotengine.org 000; npm `@ringozz/godot` = TS bindings only (no Linux binary) | official binary CDN unreachable; source-build ≈ 1–2 h on 2 cores and still no GL for any visual run (no Xvfb/mesa: apt blocked) |
| **Unity / Unreal** | ❌ **BLOCKED** | not attempted beyond binary-availability reasoning: multi-GB editor + license + asset CDNs all outside allowlist, GUI required | hard walls, named |
| **Bevy / raylib (rust/c)** | ⚠️ partial | no cargo/rustc; pip `raylib` 6.0.1 wheel exists but rendering needs GL/display | no toolchain; no display server |
| **Panda3D / Pyglet / Arcade / ModernGL (pip)** | ⚠️ partial | wheels installable (`panda3d 1.10.16`, `pyglet 2.1.16`, `arcade`, `moderngl`) | windowing/GL requires display — logic-only use at best; redundant vs node/TS |
| **LÖVE** | ❌ not testable | no binary source reachable | same egress wall as Godot |

## 3. The Blender win — and the wall we bent

**Wall:** the official `bpy` wheel links X11/GL libraries (`libXrender, libXxf86vm, libXfixes, libXi, libxkbcommon, libSM, libICE, libGL`) that do not exist in this minimal image, and apt (the normal fix) is egress-blocked.

**Bend:** Blender in `--background` mode **links** those libraries but never **calls** them. We compiled small stub `.so` files carrying the correct SONAMEs plus the symbol surfaces Blender references at load time (incl. the `V_0.5.0` version node `libxkbcommon` requires). Result: the loader is satisfied, Blender boots, and every real code path (mesh ops, glTF export, **Cycles CPU rendering**) works untouched. GPU absence is handled by rendering on the **CPU** Cycles device.

**Verified chain (all executed):**
1. `python3 -m venv /tmp/tools/venv && pip install bpy==4.2.19` (wheel from PyPI, ~64 s)
2. `gcc` stub build → `import bpy` → `bpy.app.version_string` = **4.2.19 LTS**
3. `gen_crystal.py`: seeded 3-fold faceted crystal (ico-sphere verts displaced, flat shade, gold PBR material)
4. `bpy.ops.export_scene.gltf(export_format='GLB')` → `crystal.glb` (3.2 KB)
5. **Khronos `gltf-validator`: 0 errors / 0 warnings**
6. Cycles CPU render 256×256 → `crystal_render.png` (40 KB) in ~2.5 s — **real rendered pixels with zero GPU**
7. Reproducibility: committed recipe rebuilds from scratch in one command (`./build_stubs.sh`), boot + export + render re-verified after rebuild.

Artifacts: `repo-ops/sandbox-tools/blender-headless/` → `build_stubs.sh` · `run_bpy.sh` · `src/` (stub sources + `ver_xkb.map`) · `example/` (`gen_crystal.py`, `crystal.glb`, `crystal_render.png`) · `README.md` (full recipe + wall notes).

## 4. Toolchain tiers that now exist in this sandbox

| Tier | Tool | State | Role |
|---|---|---|---|
| 1 — Studio | **Blender headless (bpy 4.2.19 + stubs)** | ✅ verified | procedural 3D meshes, modifiers, materials, glTF export, **CPU renders for visual QA** |
| 2 — Interchange | **glTF/GLB + Khronos validator** | ✅ verified | versioned, reviewable binary assets |
| 3 — Textures/2D | **ImageMagick (verified)** + platform image-gen (when available) | ✅/available | procedural and generated textures, sprites |
| 4 — Runtime | **node/TS + Three.js, browser preview** | ✅ existing | game logic (pure, seeded, headless-testable) + render client |
| 5 — Quality | npm test harnesses, tsc/eslint, gltf-validator in CI-style scripts | ✅ | gate before play |

## 5. Walls logged (data, not stop signs)

| Wall | Symptom | Workaround / status |
|---|---|---|
| `download.blender.org` blocked | HTTP 000 | ✅ PyPI `bpy` wheel (official) |
| No X11/GL system libs + apt blocked | `ImportError: libXrender.so.1` … 8 libs | ✅ compiled stub `.so` + version node (committed) |
| No GPU | `/dev/dri` absent | ✅ Cycles CPU device renders |
| Godot binary CDN blocked | exit 35 / 000 | ⏸ dropped per directive; source build possible via codeload but not worth it without render path |
| Xvfb + mesa unavailable (no apt) | — | ⏸ screenshots of GL apps impossible; Blender CPU renders cover visual QA |
| raw.githubusercontent blocked | 000 | use codeload tarballs or npm/PyPI for file delivery |

## 6. Recommended production loop for arena sandbox game work

1. **Design as code** (markdown/JSON, seeded) — unchanged doctrine.
2. **Assets:** bpy generator scripts per asset family (seeded, committed) → GLB export → Khronos gate.
3. **Visual QA:** Cycles CPU still-renders of assets (and later, low-res turntables) for the agent's own review — the "render → inspect → refine" loop is now available without any GPU.
4. **Runtime:** three.js/TS in browser preview; pure-TS deterministic sims tested headless (established pattern).
5. **Everything in workspace artifacts**, scripts+assets versioned, rebuild in one documented command (`repo-ops/sandbox-tools/blender-headless/README.md`).

## 7. Files changed this pass

| Path | Change |
|---|---|
| `battles/arena-sandbox-engine-capability-audit.md` | (this file) |
| `repo-ops/sandbox-tools/blender-headless/` | committed recipe: `build_stubs.sh`, `run_bpy.sh`, `README.md`, `src/` (12 stub sources + version map), `example/` (generator + validated GLB + CPU render PNG) |

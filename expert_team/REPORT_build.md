# Expert Sub-Agent Collaboration — TIDEWRIGHT Build (Battle Round 2)

Simulated multi-role collaboration per `ORCHESTRATION.md`. Each role fed the others;
consensus below drove the shipped build.

## Roles & contributions
- **Game Designer** — Core loop: tactile fluid you push/pull/tilt into a glowing crucible;
  goal = hold mass in zone. Anti-flash gate satisfied by a real material system, not shapes.
  Five geometry-driven chambers (no stat inflation).
- **LLM Benchmarking Lead** — Kept win/lose/restart/persistence measurable & honest. Insisted
  on corrupt-safe `localStorage`, no embedded score/telemetry, and an environment-agnostic
  build (same rules desktop/mobile/headless).
- **Graphical / WebGPU Lead** — Chose WebGPU screen-space fluid (thickness → surface normal →
  lighting + foam + fresnel over procedural forge). Flagged the *unverifiable-shader* risk and
  mandated an automatic Canvas2D fallback so the kernel's "no blank screen" is never violated.
- **Limited-Surface / Magician** — Mouse hygiene: right-drag + Shift for PULL, pointer capture,
  focus release on blur; audio created only on gesture; master mute silences within one frame.
- **Visual Creator** — Forge palette (ember-orange / teal), procedural glow, caustics, vignette,
  animated title with living fluid behind it; identity sustained across title/howto/pause/win/lose.

## Consensus decisions
1. **Simulation = Clavet double-density relaxation** (not raw WCSPH). Verified stable &
   incompressible on CPU; far less fragile than a stiffness-tuned pressure solve. PBF was tried
   first and rejected (gradient/Jacobian scaling was unstable blind without a GPU to tune on).
2. **CPU-verified solver + GPU renderer.** Reliability beats unverifiable GPU compute; the
   render path is WebGPU, fallback is Canvas2D.
3. **Auto-fallback on any WebGPU error** (init fail, `uncapturederror`, render throw) → Canvas2D.
4. **Headless verification is the proof.** Two Node harnesses (physics + game-logic) gate the
   build since no browser/GPU exists in the sandbox.

## Deliverables produced
- `src/sim/fluidCore.js` (solver) · `src/render/{webgpu,canvas2d,index}.js` · `src/game/*` ·
  `src/ui/ui.js` · `src/core/input.js` · `src/audio/audio.js` · `index.html` · `styles.css`
- `verifier/physics-node-test.mjs` · `verifier/game-logic-test.mjs` (both green)
- `README.md` · `design_notebook.md` · `SELF_QA.md`

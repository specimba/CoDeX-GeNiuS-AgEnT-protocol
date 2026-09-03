# Deep Dive — Claude-of-Tanks: how a near-AA browser game was actually built by AI agents

**Source:** [Kevin-Liu-01/Claude-of-Tanks](https://github.com/Kevin-Liu-01/Claude-of-Tanks) + `docs/TECHNICAL-OVERVIEW.md` + `docs/ARCHITECTURE.md` + `AGENTS.md`
**Operator's framing (respected):** *not* the tank concept — the **architecture and creation style with AI agents**, and how to adapt the methods for higher-grade attempts.
**Recorded:** 2026-08-29

---

## 1. What the project actually is (scale, for calibration)

A World-of-Tanks-style browser game: **110–120 first-party procedural vehicles, 16–20 destructible battlefields, plate-level armor, physical ballistics, internal modules + crew, spotting, X-ray killcams, multiplayer (solo / WebRTC rooms / dedicated authority), desktop + mobile.** Stack: **Vite + TypeScript + "engine-free" pure Three.js** — no game engine, no physics middleware, no asset store, no CDN assets. **2,595 commits, still active daily** (last commit hours ago), MIT code + proprietary first-party content, with an attribution system enforcing first-party authorship per file.

The "near-AA" feel does **not** come from the stack. It comes from three things, all method: **(1) simulation depth grounded in real domain data, (2) architectural invariants that hold across 2,595 commits, (3) verification as a first-class citizen.**

## 2. How it was made — the five-phase agent method

This is the transferable part. Reconstructed from `ARCHITECTURE.md` ("the original implementation contract… the locked nine-module plan used during the original parallel implementation"):

### Phase 0 — RESEARCH (domain docs BEFORE any code)
Before builders ran, research docs were written: `docs/research/graphics-aaa.md`, `movement-physics.md`, `armor-penetration.md`, `shells-ballistics.md`, `tank-roster.md`, `SCREENSHOT_CONTRACT.md`. **Each builder MUST read its relevant research docs.** Real penetration tables, real shell falloff, real traverse rates — the AA feel is substantially *real data* driving real simulation, not invented arcade numbers.

### Phase 1 — CONTRACT (one document, the only shared truth)
`ARCHITECTURE.md` opens: *"Nine builder agents implement the modules below **in parallel, without talking to each other**. This document is the ONLY shared truth. If something here conflicts with a research doc, THIS FILE WINS. If something is not specified here or in the research docs, pick the simplest option that satisfies the interface — **never invent a new cross-module dependency**."*

The contract locks, with zero ambiguity:
- **Module ownership with FIXED file paths** — engine / world / vehicles / movement / combat / ai / hud / fx / audio / integration each own exact files;
- **Exact data shapes** — `TankSpec`, `ShellSpec`, `ArmorModel`, `Plate`, `ModuleVolume`, `CrewVolume` down to field semantics, unit suffixes (`...Kmh`, `...DegS`, `...Mm`), and locked axis formulas (`forwardAxis(yaw) = [sin(yaw),0,cos(yaw)]`) with the rotation order pinned (`'YXZ'`);
- **Global conventions binding every module** — meters/seconds/radians; a canonical PRNG **copied verbatim** into any module needing randomness; **fixed seeds** (terrain 1337, vegetation 2001, props 2002, fx 5000, per-battle 6000); a reference event-bus implementation; **a complete event list — "do not invent new ones"**; zero top-level side effects (every module Node-importable); no per-frame allocation; no `console.error` on reachable paths; sim/network modules may never touch DOM/WebGL.

### Phase 2 — PARALLEL ISOLATED BUILDERS (nine agents, no communication)
Nine agents built simultaneously, each seeing only the contract + its research docs + its own files. Cross-module imports forbidden except pure-logic math; **all stateful objects arrive as function parameters wired later by integration.** The isolation isn't a limitation — it's what makes the contract sufficient: nobody can negotiate, so every interface had to be pre-decided.

### Phase 3 — INTEGRATION (a dedicated agent owns composition)
`src/main.ts` + `src/game/state.ts` — one agent wires the bus, constructs entities, passes seeds. Composition stays surgical ("subsystem policy belongs in the owner module, not the boot file").

### Phase 4 — PERPETUAL DISCIPLINED MAINTENANCE (where the 2,595 commits live)
- **Conventional commits with scope** (`refactor(vehicles):`, `perf(world):`, `test(rendering):`, `fix(multiplayer):`, `docs(agent):`);
- **A `SKILL.md` per directory** — subsystem-specialized agent instructions ("Work on deterministic movement, armor, ballistics, damage, and spotting simulation"), locked via `skills-lock.json` (e.g., an installed `improve-threejs` audit skill "for repeatable rendering checks");
- **`AGENTS.md` as a lean pointer index** — architecture pointers, invariants, and a **"Gotchas / never-do-X"** list (never make a client authoritative for hits; never send hidden enemy coordinates and hide them in rendering; never equate player ID with spec ID);
- **Self-tests everywhere** (`*.selftest.mjs`, `npm test`), **verification tools as first-class code** (`tools/`: deterministic performance probes, screenshot contracts — deterministic marketing shots from staged game states, geometry gates, fleet checks, release gates like `tank:anatomy:update → check → release:check --gate` which regenerate and verify armor/module/crew receipts and fleet diagrams);
- **Incremental strict-TypeScript migration** — each boundary migrates "with behavioral parity evidence," explicitly refusing a big-bang rewrite.

## 3. Why it's near-AA — the invariants (not the stack)

The current `TECHNICAL-OVERVIEW.md` names the one rule everything hangs off: **"presentation may visualize authority, but it may not create authority."** Everything else follows:

1. **Deterministic authority** — fixed 60 Hz sim step; sim never reads wall-clock or `Math.random()`; the renderer can run at any rate and *cannot accelerate reloads, shell travel, or vehicles.*
2. **Renderer-free rules** — `src/sim/` runs in plain Node with no DOM/WebGL → the combat model is *testable without a browser.*
3. **Hidden information removed at authority** (spotting filters snapshots *before* serialization — never "send it and hide it in the render").
4. **Durable state vs. one-shot events are separate** — "a persistent fact is never encoded only as a transient event."
5. **Quality policy is cosmetic-only** — device quality may change resolution/shadows/particles but "may not change the combat step, armor resolution, or game rules."
6. **Explicit identity separation** (player ID ≠ entity ID ≠ spec ID ≠ presentation object).

Plus boot-time **GPU diagnostics with staged rescue** (tiny offscreen probes validate lit/shadowed/env rendering; a measured ladder restores rejected stages), cascaded shadow scheduling as explicit contracts, and no per-frame allocations.

## 4. The stack insight — "engine-free" means the architecture IS the engine

They didn't pick a game engine; they picked **Three.js as a rendering platform** and built the engine discipline around it (sim / net / vehicles / world / engine / game / ui / fx / audio ownership). The "AA" is in the *separation*, not the library. This is the same conclusion our materials-recipe work reached for rendering, generalized to the whole program: **teach the architecture, not the tool.**

## 5. What transfers to OUR benchmark — and what doesn't

**Honest scope note first:** CoT is not one-shot. The original nine-agent build was one *contracted* pass, but the current quality is the product of months of Phase-4 maintenance — our Track A agents get ~90 minutes, once. So the transfer is selective:

### Transfers directly (cheap enough for one shot, attacks our known failures)
1. **CONTRACT-FIRST — the single biggest transferable idea.** Before implementation, write the contract: module ownership (fixed files), the exact shapes of the shared data, the event list, the conventions. *This is the mechanism that let nine non-communicating agents integrate on the first try — and our one-shot agents' core failure is the same problem single-handedly: modules improvised mid-build and tangled.* A contract section (or a required `CONTRACT.md` artifact) makes the agent pre-decide interfaces instead of inventing cross-module dependencies at minute 60. This attacks M-4/reliability and code quality directly.
2. **The architectural invariants, as a short teachable list:** fixed-step sim decoupled from render rate; zero top-level side effects (modules importable/testable without a canvas); seeded RNG only — no `Math.random()`/wall-clock in sim; no per-frame allocation in hot loops; durable state ≠ one-shot events; *presentation never creates authority.* Six rules, ~6 lines of prompt, each one prevents a whole bug class we have watched agents ship for 12 rounds.
3. **The research-first micro-step.** "Before coding, write short domain notes: the real numbers your simulation should use" — CoT's AA feel is substantially *real data* (real pen tables, real traverse rates). Our agents invent shallow systems because they skip this. This is also anti-convergence-adjacent: real domain data forces differentiation *within* a concept.
4. **Self-tests.** A tiny `*.selftest.mjs` the agent writes and runs before shipping (made possible by invariant #2 — sim runnable in Node). This is the systematic version of what PRISMA did instinctively in R012 (self-debugging → the "no flaws" verdict).

### Does not transfer to Track A (but is the strongest evidence yet for a future Track B)
- **Nine parallel isolated builders + dedicated integrator** — needs subagents/compute. This is the "showcase regime" (FABLE ×275 runs, OpenAI showcase multi-agent) now with the *missing piece those lacked: the contract that makes parallel agents coherent.* If the operator ever opens Track B, the CoT contract pattern is the blueprint.
- **Phase-4 maintenance, skills, gates, anatomy checks** — a repo-lifetime regime, not a session.

## 6. Proposed adaptation — **DECIDED by operator (Q&A 2026-08-29)**

The **v18 "engineering discipline" block** (built as `challenge/BATTLE_PROMPT_v18.md`, 6.9 KB — **held for R014, not deployed**; the live prompt stays v17 so R013's steers + ship-micro-test read stays clean). Operator decisions: **adopt all four elements** (contract-first step, six architectural invariants, domain-notes micro-step, self-test practice) · **timing = R014** · **form = prompt lines only** (no required artifact — the method is taught in the prompt, nothing new to grade). All four are *method* — no genre, no concept, no convergence content, so they carry zero C-cluster risk. Expected metric shifts: M-4 up (integration bugs are our dominant defect class), code-quality pillar up, zero risk to M-1 (v16/v17's quality levers untouched). The block teaches, in order: domain notes (real looked-up numbers) + a mini-contract (module ownership, shared data shapes, complete event list, "never invent a cross-module dependency mid-build"), then six invariants — fixed-step sim decoupled from rendering · zero top-level side effects · seeded randomness only · durable state ≠ one-shot events · no per-frame allocation · presentation is cosmetic — then the self-test practice ("the cheapest 'no flaws' you will ever buy").

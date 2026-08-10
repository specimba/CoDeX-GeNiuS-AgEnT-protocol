# 03 — Long‑Session Test Plan

Standardized, reproducible long‑session protocol. Both games are tested under identical
conditions. A session is a bounded block of live play with a defined archetype, evidence
output, and coverage requirement.

## 3.1 Standardized conditions

Lock these once and reuse for every game and every pair. Record them in every report.

| Setting | Standard (default) | Variants to test |
|---|---|---|
| Hardware | Standardized VM profile + mid‑range phone emulator | none (keep fixed) |
| Browser (desktop) | Chrome latest, windowed 1280×800 | Firefox smoke pass |
| Browser (mobile) | Mobile emulation, Chrome | portrait 390×844 & landscape 844×390 |
| Device pixel ratio | 1 (desktop), 2 (mobile) | high‑DPR check |
| Input | keyboard+mouse (desktop); touch (mobile) | reduced‑motion ON and OFF |
| Audio | start OFF (autoplay fallback check), then ON | verify toggle works both ways |
| Network | localhost / file‑served, no external requests | verify no backend dependency |
| Freshness | each game gets a fresh browser profile (clean localStorage) | corrupt‑storage injection test |

## 3.2 Session archetypes (each game)

Each archetype records evidence into the shared schema. Coverage requirement: per game you
must complete S1–S8 (the set in the arena prompt). Timing is cumulative across a game.

| ID | Archetype | Min duration | Objective |
|----|-----------|-------------:|-----------|
| S1 | Smoke (cold launch) | ~5 min | Fresh load; first attack; move; dodge; defeat 1 enemy; collect reward; reach room transition. Log cold‑launch errors. |
| S2 | Warm restart | ~3 min | Use the in‑game instant restart path (no page refresh); verify full state reset (health, coins, floor, score, run). |
| S3 | Medium goal‑directed | ~30 min | Goal: complete a run / beat the boss. Log progression per floor, pacing, difficulty, rewards, any blocker. |
| S4 | Long continuous | ~60 min | No restarts. Sample performance at 0/15/30/45/60 min. Detect late‑session bugs, memory growth, engagement collapse. |
| S5 | Exploratory | ~20 min | No goal. All abilities, all enemies, both control schemes, reduced‑motion, every menu, map edges, corner cases. |
| S6 | Edge & boundary | ~15 min | Resize mid‑combat, orientation change, tab blur/focus, browser back, pause freeze check, HS persistence, corrupt storage, input stress (mashing), stuck detection. |
| S7 | Accessibility | ~15 min | Keyboard‑only menus, focus states, high contrast, non‑color info, reduced‑motion, small text, touch reach/safe areas. |
| S8 | Repeat runs | 2+ runs | ≥2 extra full runs; if seeded, ≥2 distinct seeds drawn at evaluation time. Exercises procedural variation & replayability. |

**Minimum per game: ~2.5 hours** of live play across archetypes (not counting write‑up).
For a given pair the evaluator runs this entire set for Game A, then the entire set for
Game B (order per their assignment).

## 3.3 Standardized probes

These probes are run during S6/S8 and whenever suspicion arises.

**P‑Freeze (pause integrity).** Pause the game with a particle emiiter active, an enemy mid‑attack, and a projectile in flight. Verify: no movement, no animation progression, no particle updates, no timers, no damage; resume continues exactly. Repeat 3×.

**P‑Restart (state reset).** Reach floor 3 with coins, relics, partial health. Use instant restart. Verify health/coins/floor/score/relics all reset; no residue from prior run; second restart identical. Repeat 3×.

**P‑Persist (high scores).** Finish a run. Reload the page. Verify the run appears in the high‑score table sorted correctly. Then inject corrupt storage (see P‑Corrupt) and reload; verify no crash and graceful fallback.

**P‑Corrupt (storage).** Replace the stored high‑score key with `{invalid json` and with a non‑object. Reload. Verify no crash; the game either resets gracefully or ignores bad data; note behavior.

**P‑Focus (visibility).** Start combat, switch tabs for 10s, return. Verify game is not desynced and (on mobile) auto‑paused or safely handled; no runaway.

**P‑Resize.** Mid‑combat, resize desktop window from 1280×800 → 640×400 → fullscreen; on mobile rotate portrait↔landscape. Verify no layout break, controls stay reachable, no hidden info.

**P‑Stuck (dead‑end detection).** Push enemies into walls/corners, park the player in corners, stand on top of spawns for 30s. Verify no entity becomes permanently immobile and no soft‑lock (exit/next path remains reachable).

**P‑Stress (input).** Mash attack/dodge/ability at high rate for 30s. Verify no state corruption, no command queue overflow, no crash; behavior is consistent with input buffering.

**P‑Seeds (procedural).** If seeds are supported, play 2 distinct seeds fully. Verify layout reachability, no impossible enemy placement, clear exits, no duplication‑collapse (all rooms identical).

**P‑Render (rendering fallback & robustness).** Launch the game on a profile with WebGPU unavailable (force WebGL or Canvas2D). Verify graceful degradation: no white screen, no crash, gameplay remains fully functional, visual identity remains coherent. Repeat with WebGL unavailable (Canvas2D only). Note any divergence in appearance or behavior.

**P‑VisualConsistency (cross-environment identity).** Play the same fixed scene (e.g., first combat room, specific enemy set, a floor transition) on desktop widescreen, desktop small window, mobile portrait, mobile landscape, and at DPR 1 and 2. Capture screenshots. Verify the art identity holds, no clipped UI, no overlap, no broken layout; gameplay readability is preserved; no environment-dependent difficulty/reward changes.

**P‑LoopSeparation (React/render hygiene).** Monitor React re-render counts vs. canvas loop ticks during 60s of active combat. Verify React renders are not triggered per frame by gameplay state; high-frequency updates (player position, projectiles, particles) live in the canvas layer; React only updates on screen/menu/HUD transitions. Note any per-frame React churn.

**P‑EnvConsistency (no demo mode).** Run the same fixed scenario (e.g., the first combat room, a specific enemy, a boss phase) in multiple environments and confirm identical behavior: desktop vs mobile, portrait vs landscape, different user‑agents/viewports, touch vs keyboard, and a headless/automated run. Any divergence in difficulty, drops, enemy HP, reward rates, or game rules is a defect (class LOGIC/STATE or BALANCE, "environment sniffing"). Also confirms the game is not secretly degrading quality on lower‑spec devices in a way that hides performance problems.

## 3.4 Handling of hard cases

| Case | Handling |
|---|---|
| **Randomness** | Distinguish within‑game variance from systematic failure: reproduce a suspected bug ≥2× across runs/seeds. Never attribute a single unlucky seed to a defect without reproduction. |
| **Different genres** | Controlled here (same spec). For generality: score by scope, not content count; never penalize a genre for lacking another genre's features. |
| **No explicit ending** | Score the run loop on its own terms; F6 = completing the intended loop, not a credits screen. |
| **Optional content** | Scored only if reachable and valuable; never required. |
| **Procedural generation** | Multi‑seed; probe reachability and determinism; treat seed‑specific breakage as a defect only if reproducible or clearly systemic. |
| **Missing/inaccessible features** | Not experienced ⇒ no credit; log as defect if it looks intended but broken. |
| **Evaluator fatigue** | Sessions are capped; take breaks between archetypes and between games; split the long continuous (S4) and repeat (S8) sessions across evaluators when the panel permits. Never let a single exhausted session drive a major score. |
| **Inconsistent agent behavior** | Benchmark the artifact, which is frozen; ignore agent behavior entirely (no code/log review). |
| **Hardware‑dependent performance** | Standardized profile; report on that profile only, and note if an issue is environmental (HARNESS‑ISSUE) rather than a game defect. |

## 3.5 Evidence collection

For each session emit:
- `session_meta` (game, archetype, hardware, browser, input, reduced‑motion, audio, seed if any, start/end timestamps, ordering assigned)
- `observations` (timestamped, `[SESSION][MM:SS]`, free‑text)
- `captures` (filenames of screenshots/recordings; reference in notes)
- `perf_samples` (S4: FPS, jank %, memory indicators at 0/15/30/45/60 min)
- `defects` (per `04-defect-taxonomy.md`)
- `scores` (sub‑criteria per `02`, finalized only after all sessions)

Store per the `ops/evidence_schema.json` schema so aggregation is a pure function.

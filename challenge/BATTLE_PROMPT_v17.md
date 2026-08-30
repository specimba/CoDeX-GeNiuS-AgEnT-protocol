# BATTLE PROMPT — Build one good browser game, in one session (v17)

You have one sustained session to build a complete, original, playable browser game. Push the sandbox as far as it goes — you are **not** limited to a small 2D browser game. Frontier models in 2026 routinely deliver WebGL/WebGPU generative visuals, real simulations, shader post-processing, and procedural worlds in a single self-contained file. **That capability is in your hands — use it.** Build something a person would genuinely be glad they played, and that looks like 2026, not 2013.

Answer one question before you write any code: **why does this experience need to exist in interactive form?** If you can't answer it, you don't have a game yet.

**Be ambitious and trust your own taste.** Any genre, any camera, any stack, any form (action, strategy, simulation, narrative, puzzle, exploration, abstract, experimental — your call). A situation can equally be **physical** (something transforms), **social** (people or factions in tension), **economic** (scarcity, trade, debt), **relational** (a tie under stress), **systemic** (a machine you nudge and watch respond), **choice-driven** (a decision with consequences), or **narrative** (a story the player uncovers) — seven families, all coequal, and the physical one is only the default if you let it be. (Honest notes from many rounds of this benchmark: three patterns keep coming back as the field's defaults — **sonar / radio / frequency tuning**, **gravity-well piloting** (orbiting a star or black hole), and **tangible-craft work** (forging, glass, cranes). Each has been the most common convergence of some stretch of rounds. None are banned — but if you notice yourself reaching for one of them by default, look once more at the other families first.)

**Where the modern look actually comes from: materials + light, not polygons.** If your sandbox provides image generation, use it as your **art director and source-asset generator** — surface language, environment concepts, pattern and mask sources, micro-detail references — then *condition* what it gives you (tileable crops, derived masks, color-space tagging) and drive it through a **real material pipeline** (the MeshPhysicalMaterial class of properties: clearcoat, iridescence, transmission, IOR, sheen, anisotropy, thickness, attenuation). If your sandbox has no image generation, the same discipline applies to procedural sources: noise-derived materials with real physical parameters, not flat fills. Either way the renderer decides what is physically meaningful — the look comes from light on material, not from more geometry.

If you commit to 3D/WebGPU, **finish it** — a broken ambitious build scores worse than a clean simple one, so scope what you can actually complete end-to-end on a fresh load with a real mouse.

**The only hard rules (reliability + fairness — everything else is your call):**

1. **Launches** cleanly on a fresh load — no blank screen, no console-error loop.
2. **Complete loop with real resistance** — start → play → something that can actually stop you (a fail state, a wall, a cost you can't undo) → end → restart, without a page refresh. If a player clicking randomly reaches the end unchanged, it isn't a game yet — and a narrative form must have an actual story to find.
3. **Controls work** with a real mouse/keyboard/touch; the first goal is reachable in ~5 min of honest play.
4. **Pause** freezes everything; **mute** silences within one frame (no constant drone); **restart** resets fully.
5. **Self-contained & fair:** the final build runs offline with everything bundled. Any visual source your sandbox provides **equally to every agent** is fair — procedural, generated imagery, baked assets — as long as you bundle it (no runtime network) and **disclose in the README what you generated** (a short receipts list: what, and roughly how). No telemetry.
6. **Robust**: resize/orientation safe, tab-blur safe, corrupt-`localStorage` safe, no full-screen flash/whiteout that fails to decay.
7. **Honest**: no placeholder screens, no dead buttons, no autoplay that fakes quality. First line of the README: `TRACK: strict-one-shot` or `TRACK: iterated (N passes)`.

**Run this list once before you deliver:** fresh load → title in <10 s, no console-error loop · full loop including a real fail state · real mouse: controls and aim work, no soft-lock, axes not inverted · pause freezes everything; mute kills audio within one frame · resize mid-play safe · no full-screen flash/whiteout that fails to decay · if you built the ambitious rendering path (3D / WebGPU / shaders), verify it **end-to-end on a fresh load** — if it breaks, deliver the clean fallback instead.

**Deliverables:** the runnable game; a short README (TRACK line, how to run, controls, stack, what you cut, what you generated [receipts], and short **DESIGN_PILLARS** / **DIRECTOR_STATEMENT** / **WHY_INTERACTIVE** / **HONEST_SELF_ASSESSMENT** paragraphs); optionally a `design_notebook.md`.

Deliver a complete, polished, modern game you'd actually want to play. Good luck.

# BATTLE PROMPT — Build one good browser game, in one session (v21)

You have one sustained session to build a complete, original, playable browser game. Push your environment as far as it goes — you are **not** limited to a small 2D game, and you are not limited to code: this benchmark has verified that real toolchains (headless Blender, glTF pipelines, 3D libraries, image generation) turn prompts into real game assets. Frontier models in 2026 routinely deliver WebGL/WebGPU generative visuals, real simulations, shader post-processing, and procedural worlds. **That capability is in your hands — use it.** Build something a person would genuinely be glad they played, and that looks like 2026, not 2013.

Answer one question before you write any code: **why does this experience need to exist in interactive form?** If you can't answer it, you don't have a game yet.

Before any code, write the **player's sentence** — one sentence answering: *what is the player trying to do, what can stop them, and what makes it fun?* If your sentence is about systems that run rather than choices a person makes, you don't have a game yet. **The game comes first: a correct simulation of something is not a game until a player has a goal, a real obstacle, and at least one decision with a tradeoff they can feel.** Build the smallest version of that loop first, in the ugliest possible graphics; make it fun; only then add the real numbers and the polish. **A game also needs a reason to be enjoyed** — something that delights, fascinates, amuses, moves, or intrigues. Name what the player will *like*, not only what can stop them; a sentence that names only obstacles describes a challenge, not yet a game.

**Fun is a contract with minutes.** Know what is fun at **minute one** — the player must do something genuinely pleasant and legible within the first ~60 seconds, no difficulty cliff, no perfect-play demanded to reach content — and what keeps a real player wanting **one more run at minute ten** (no boredom plateau). Balance for a first-time player, not for yourself. If minute one is a wall or minute ten is work, you have a pacing defect, not a content problem — fix the pacing.

**Ship complete.** An unfinished ambitious game is the worst outcome in this benchmark — worse than a small finished one. Scope so the full loop closes end-to-end on a fresh load. If you catch yourself building to infinity (features accumulating, no closure, endless "one more system"), stop and close the loop first. A closed small loop beats an open big one, every time.

## 1. Know your environment first (≤3 minutes — then one line in the README, done)

Battle sandboxes differ, and every class can win. Run three quick checks and take the matching route:

- **E1 — Full shell/CLI** (you can run arbitrary commands; `pip`, `python`, `bash` work): the full pipeline is open to you, including headless Blender. Use the Blender route.
- **E2 — Package manager only** (e.g. `npm install` and build work; arbitrary shell does not): real 3D is still open to you — install a 3D library (`three`) and model in code. Blender itself is unreachable; do not burn session time trying to reach it. Use the npm-3D route + the image route.
- **E3 — File/response edits only** (no installs, no shell): code-procedural + the image route. Fully acceptable; the loop and the look decide the grade, not the class.

Put a one-line **ENV** report in your README: your class, what you attempted beyond plain code, and — if you attempted nothing beyond plain code — the single line that blocked you. This section exists because these routes were verified to work on real battle sandboxes; "it seemed optional" is not a blocker. Attempting and failing fast is fine; skipping silently is an honesty defect.

**The routes (condensed but complete enough to reproduce):**

- **Blender route (E1).** `pip install bpy==4.2.19` gives you Blender 4.2 as a Python module — no GUI, no GPU. Known wall and known fix: minimal hosts lack X11/GL system libraries; Blender in background mode *links* but never *calls* them, so small stub `.so` files with the right SONAMEs satisfy the loader (this includes a versioned `libxkbcommon` stub). If the stubs are not already present, ~10 minutes of work or a fallback — never more. Pattern: write a **seeded generator script** (mesh, displace/split/facet, material via nodes) → export `bpy.ops.export_scene.gltf(filepath="x.glb", export_format='GLB')` → validate (Khronos `gltf-validator`, require 0 errors) → load at runtime (`GLTFLoader`). No GPU? Render QA stills on the **CPU** device (`scene.cycles.device = 'CPU'`; 256–512 px, seconds per frame) — and **look at every render before you ship it**.
- **npm-3D route (E1/E2).** `npm install three` (or your runtime's 3D library). Real 3D needs no downloaded models: build geometry in code (`BufferGeometry`, lathe/extrude/parametric), give meshes **actual materials** (roughness, metallic, emissive) and **real lights with shadows**. Generated `.glb` files load the same way when you have them. Code is a perfectly good modeler.
- **Image route (all classes).** If your environment provides image generation, this channel is your **eyes**: you can see what you generate, so make it the backbone of the visual identity — key art, backgrounds, tiles, sprites, UI panels, skyboxes. Generate → look → regenerate (2–4 passes is normal) → integrate with code effects over it. Disclose what you generated (receipts).

Immutable rules on all routes: every asset is bundled (no runtime network); sources every agent receives equally; receipts disclosed.

## 2. The look — why rounds keep producing cardboard, and the checklist that fixes it

"Cardboard" means: unlit flat-colored shapes, default materials, no shadow, no atmosphere, polish that stops at the UI. The fix is a checklist, not a budget:

- **Light and shadow first.** One clear light direction; the hero casts or receives shadow; emissive things actually glow.
- **Materials respond.** Roughness/metallic variation; surfaces broken by noise, not uniform fills. Flat color is a deliberate choice, never the default.
- **Palette discipline.** 3–5 deliberate colors plus neutrals; every screen — title, HUD, world — draws from the same tokens.
- **Depth in the frame.** Foreground/mid/background, scale contrast, fog or a depth cue; not a single plane.
- **Motion juice.** Particles, trails, squash-and-stretch, shake on impact. Feel is visual.
- **Finish the frame.** Title, menu, HUD and game share one design language; nothing left as browser-default chrome.

The honest constraint: some battle sandboxes give you **no browser and no way to see your own runtime** — code-rendered visuals you cannot see are *blind*, and blind iteration is how cardboard ships. Handle it deliberately: (a) let the visual identity you *can* see (image-generated assets, provable-by-construction parameters) carry the first impression; (b) keep unseen code-visuals simple and defensive — strong silhouettes, explicit palette tokens, obvious material values, real lights even when you cannot admire them; (c) state in the README which parts you saw and which you verified blind by construction. If you DO have a browser or preview: play and look before delivering, and say that you did.

If you commit to 3D/WebGPU, **finish it** — a broken ambitious build scores worse than a clean simple one, so scope what you can actually complete end-to-end on a fresh load with a real mouse.

## 3. Originality — the second-idea rule

**Be ambitious and trust your own taste.** Any genre, any camera, any stack, any form (action, strategy, simulation, narrative, puzzle, exploration, abstract, experimental — your call). A situation can equally be **physical** (something transforms), **social** (people or factions in tension), **economic** (scarcity, trade, debt), **relational** (a tie under stress), **systemic** (a world whose rules respond to you with consequences you can feel), **choice-driven** (a decision with consequences), or **narrative** (a story the player uncovers) — seven families, all coequal, and the physical one is only the default if you let it be.

(Honest notes from many rounds of this benchmark — the patterns that keep coming back as the field's defaults now include: **sonar / radio / frequency tuning**; **gravity-well piloting**; **tangible-craft work** (forging, glass, cranes); **wildfire / ember / fire-response games**; **energy-grid / infrastructure balance sims**; **root / sprout / mycelium growth-network sims**; **lighthouse / beacon / light-as-a-resource**. The umbrella behind most of the repeats is one shape: *operations-crisis — a threat spreads or a meter slides, and you ration limited spend against it under a clock.* None of these are banned, and a genuinely great game in any of them can still win. But they have flooded recent rounds — including near-identical games shipped by two different models in the same battle — and the operator of this benchmark is visibly tired of fire and grid games. If your first instinct sits inside that umbrella, assume your second idea is more original.)

So: before you write code, draft **two candidate premises** in your notebook. If both sit under the umbrella shape (spreading threat / sliding meter / rationed spend / beacon), discard both and find a third in a family you have not shipped recently. One line in the README: which families your candidates touched and why you shipped the one you did (**PREMISE_NOTE**).

## 4. Build it like an engineer, not a scripter

Before implementation code, spend ten minutes on two short notes: **domain notes** — the real numbers your simulation should use. Look them up: real masses, rates, tolerances, prices, whatever your concept runs on. Real data is what makes a simulation feel substantial instead of invented. And a **mini-contract** — which module owns what (file paths fixed), the exact shape of the data shared between modules, and the complete list of events that cross module boundaries. Never invent a new cross-module dependency mid-build; if something is unspecified, pick the simplest option that satisfies the interfaces you already wrote.

Then hold these invariants while you build:

1. **Fixed-step simulation, decoupled from rendering.** The sim advances in fixed steps and never reads the frame clock. The renderer visualizes the sim — it may not create game state.
2. **Zero top-level side effects.** Modules define pure data and functions at top level; setup happens inside init functions — so your logic can run without a canvas.
3. **Seeded randomness only.** No `Math.random()` and no wall-clock time inside simulation code. Randomness arrives as a seed; time arrives as a parameter.
4. **Durable state is not a one-shot event.** A persistent fact (health, position, reload) is never encoded only as a transient event.
5. **No per-frame allocation in hot loops.** Reuse scratch objects.
6. **Presentation is cosmetic.** Quality settings may change resolution and effects — never rules, timing, or outcomes.
7. **The simulation serves a game.** Every system you build must map to something the player decides, cares about, or feels. If a system is pure background math the player never touches, cut it — or find the decision that touches it.

If your sim honors invariants 2 and 3, write and run a tiny self-test of its core rules before you deliver — it is the cheapest "no flaws" you will ever buy.

**Playability probe (when you cannot play):** if your sandbox gives you no browser, write a small **autopilot probe** that plays your game like a naive first-time player — it drives the real loop headlessly and asserts: the first goal is reachable, the fail state is reachable, a win is reachable, no dead state where nothing responds, restart truly restarts. Run it, and report its output in the README. This is the honest substitute for playing; if you *can* open the game, play it for real instead (hard rule 8).

## 5. The only hard rules (reliability, fairness, honesty — everything else is your call)

1. **Launches** cleanly on a fresh load — no blank screen, no console-error loop.
2. **Complete loop with real resistance, closed** — start → play → something that can actually stop you (a fail state, a wall, a cost you can't undo, a rival, a deadline, a mystery, an appetite) → end → restart, without a page refresh, and the run *ends* — no infinite-building, no "to be continued". If a player clicking randomly reaches the end unchanged, it isn't a game yet — and a narrative form must have an actual story to find.
3. **Controls and pacing for a real player** — controls work with a real mouse/keyboard/touch; the first goal is reachable in ~5 min of honest play; no difficulty cliff in the first minute; audio is not harsh or ear-blasting at default volume.
4. **Pause** freezes everything; **mute** silences within one frame (no constant drone); **restart** resets fully; defaults are moderate (volume, speed, difficulty).
5. **Self-contained & fair:** the final build runs offline with everything bundled. Any visual source your sandbox provides **equally to every agent** is fair — procedural, generated imagery, baked assets, engine/headless-tool-generated assets — as long as you bundle it (no runtime network) and **disclose in the README what you generated** (a short receipts list: what, and roughly how). No telemetry.
6. **Robust**: resize/orientation safe, tab-blur safe, corrupt-`localStorage` safe, no full-screen flash/whiteout that fails to decay.
7. **Honest**: no placeholder screens, no dead buttons, no autoplay that fakes quality. README opens with `TRACK: strict-one-shot` or `TRACK: iterated (N passes)`, and contains the ENV line, the PREMISE_NOTE line and the receipts.
8. **Play your own game — or probe it.** Before you deliver, play it once, end to end, as a player — not as the developer who knows the answers. If you cannot play it (no browser), run the autopilot probe from §4 and report it. If you did not enjoy the run you just played (or probed), do not deliver it; fix it first. In the README, say exactly what you verified (fresh load, one full run, restart) — not "should work".

**Run this list once before you deliver:** fresh load → title in <10 s, no console-error loop · full loop including a real fail state and a real ending · real mouse: controls and aim work, no soft-lock, axes not inverted · pause freezes everything; mute kills audio within one frame · resize mid-play safe · no full-screen flash/whiteout that fails to decay · pacing: minute one is fun and reachable, minute ten still wants one more run · if you built the ambitious rendering path (3D / WebGPU / shaders), verify it **end-to-end on a fresh load** — if it breaks, deliver the clean fallback instead · if you generated assets or ran tooling, you looked at every render and the receipts are written.

**Deliverables:** the runnable game; a short README (TRACK line; **ENV** line; **PREMISE_NOTE** line; how to run; controls; stack; receipts — what you generated and with which route; and short **DESIGN_PILLARS** / **DIRECTOR_STATEMENT** (state the look: light, palette, material language) / **WHY_INTERACTIVE** (name the recurring decision and the tension that makes it interesting) / **FUN_LINE** (what is fun at minute one, and what pulls one more run at minute ten) / **HONEST_SELF_ASSESSMENT** (what you actually play-tested or probed, and what broke)); optionally a `design_notebook.md` — it must contain your two candidate premises (§3).

Deliver a complete, polished, modern game you'd actually want to play. Good luck.

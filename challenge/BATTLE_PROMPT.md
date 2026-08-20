# 🗡️ BATTLE PROMPT — Ship something that makes a human go *"…wait"* (v6)

> You are one of two or more contestants. Every contestant receives this exact prompt (identical bytes). A human judge will play your build blind for up to an hour, side-by-side against the other entry. The judge never reads your code, your README, or these instructions during scoring. **They score only what they experience.**
>
> There is no style guide, no approved genre, no approved control scheme, no approved palette, no approved camera perspective, and no approved input modality. **Your job is surprise.** Ship something that, within the first 60 seconds of play, makes the judge think at least one of:
>
> - *"Wait — how did an AI do this in one session?"*
> - *"I haven't seen that before."*
> - *"That looks / sounds / feels genuinely incredible."*
> - *"I want to show this to someone."*
>
> That is the entire brief. Everything below is either **gates** (must pass or you're disqualified) or **anti-patterns** (learned from prior rounds; ignore them at your peril).

---

## 0. What actually wins

The winning entry is the one the judge remembers after closing the tab. That can come from anywhere:

- **Mechanical novelty** — an interaction, verb, or system that is genuinely yours.
- **Graphical / technical ambition** — near-commercial rendering fidelity, clever shader work, WebGPU/WebGL depth, fluid or physics simulation of unusual depth, real-data integration (real geography/terrain/maps/audio used coherently and legally), demoscene-level craft, something that looks like it shouldn't run in a browser.
- **Experience design** — atmosphere, emotion, narrative, pacing, sound, humor, absurdity, quiet, tension — a game that *does* something to the player, not just a game the player *does* something in.
- **Experimental input** — mouse, keyboard, touch, microphone, camera, device orientation, one-button, text-only, any input used in a way that is obviously the right choice for *this* game.
- **Feel** — the specific sensation that the thing you are touching has weight and intent.

**You are not limited to 2D. You are not limited to small scope. You are not limited to indie-jam aesthetics. You are not limited to mechanics as the sole carrier of originality.**

If you can ship a photorealistic driving simulator using streamed local map tiles, do it. If you can ship a single-shader GPU demo that is somehow also a game, do it. If you can ship a text game that makes people cry, do it. If you can ship a physics sandbox with destruction depth nobody expects from a browser, do it. If you can ship a small thing so beautifully made it feels like a commercial title, do it.

> **"Competent" will lose. "Safe" will lose. "Bland but bug-free" will lose.**
> **"Least bad" is not a win — the judge is allowed to call a tie when neither entry is impressive, and a tie is the correct outcome over a false winner.**

---

## 1. Non-negotiable gates (fail any of these and the judge stops)

These are for comparability, not style. They are the only shape restrictions.

1. **Launches.** Opening the HTML (or running `python -m http.server`) starts the game. No blank screen, no infinite spinner, no console-error loop, no missing-asset fatal.
2. **Complete loop.** Start → meaningful interaction → payoff / end-state → restart, all without a page refresh. A build that can be exhausted in under 2 minutes on a fresh first run, or whose final challenge is trivially one-shottable, or where there is no resistance / escalation / discovery at all (a screensaver, a toy, a pretty thing with no ask) — is **not a complete game** and will be scored as *incomplete loop*.
3. **First level is beatable by a real human.** If your onboarding wave/room/level cannot be cleared by the judge inside ~5 minutes of honest play, the game reads as broken difficulty, not depth. (Real prior failure: a "clever" first-level puzzle nobody could solve killed sustained interest.)
4. **Self-contained & offline.** No backend, no network calls, no auth, no telemetry, no analytics, no runtime calls to external AI/image/model services, no hidden reporting. Static folder or single HTML. Bundle every library. Pre-baked / procedural / self-created / clearly-licensed local assets only.
5. **Honest.** No placeholder screens, no dead ends, no buttons that don't work, no "coming soon", no hidden autoplay that fakes quality, no environment sniffing that changes rules per device/viewport/UA/headless. **The same game plays for every judge in every run.**
6. **Mouse, keyboard, touch — whichever you support, work.** In prior rounds primary desktop input has failed silently on shipped builds (mouse aim swallowed by overlay canvases, LMB not reaching game state, cursor lost when moving outside canvas). **Verify with a real mouse before shipping.** If your game uses mouse-aim, out-of-canvas movement must not soft-lock or lose the aim vector.
7. **Mute, pause, restart work.** Audio can be turned off instantly; muted gameplay is complete and legible; pause fully freezes the simulation (timers, particles, physics, spawns, AI); restart from anywhere resets state fully; menus and gameplay do not leak into each other (opening a menu mid-game must not double-fire actions or trap input state when closed).
8. **Audio hygiene.** No constant unchanging drone. No streaming bass loop that never stops. Sounds are event-driven (finite envelopes, sensibly stopped). Master mute silences everything within one frame. Tab-blur pauses or ducks audio. If `AudioContext` cannot initialize, the game still plays.
9. **State isolated across resize / blur / orient / restart.** Resizing mid-game does not lose entities or freeze. Tabbing away pauses. Orientation change re-lays out cleanly. Rapid Restart→Start does not double-spawn. Corrupt localStorage does not crash.
10. **Controls are self-explanatory or disclosed inline.** If your game uses a non-obvious control scheme, it must be obvious *from the game itself* (in-scene affordance, first-second prompt, glowing cursor) — not just from the README. If you deliberately invert a convention, show the player within ~3 seconds. **There is no required control convention.** You do not have to use WASD. You do not have to use Space-as-primary. Pick what your game needs and make it *work*.
11. **Legal / original.** Only ship content you have the right to ship. Self-created, procedurally generated, public-domain, or clearly-licensed assets only. Attribute in README.
12. **One shot.** This entire deliverable must be produced inside a single sustained development session. Iterating across multiple delivered builds after a "first ship" is not this benchmark. Multi-turn polish is tracked separately and cannot compete for the primary battle result. Ship your best in one pass.

That's it. Everything else — genre, rendering stack, visual style, palette, audio style, camera, scope, level structure, narrative, UI chrome — is your decision.

---

## 2. The patterns that lose (read once, don't re-read)

The fastest way to lose is to ship something a judge has already seen from three other agents this week. This is not a style ban — you *can* win with any of these settings if your execution is genuinely transformative — but know that you are walking into a headwind:

- **Dark / near-black background with one bright accent color**, where *every* entity (player, enemies, pickups, particles) is a glowing orb/circle, and there is no authored world behind the glow. A screenshot looks like every other AI game.
- **"Shapes that shoot shapes."** Flat primitive geometry (rectangles/circles/triangles) with no silhouette identity, no texture, no animation, no dressing, shooting other primitive geometry.
- **Reskin of an existing casual game with no meaningful transformation** — endless runner / Dino-jumper, Flappy-Bird variant, neon vector shooter, generic collect-stars, snake, tetris-with-a-twist.
- **Feature list before a feel** — 10 UI modals (classes / relics / talents / codex / shop / settings / lore / inventory) around a core verb that does not yet feel good.
- **"Chill" as an excuse for zero resistance** — a pretty ambient thing you can exhaust in 90 seconds, where nothing asks anything of the player.
- **Ambition-theater 3D** — a technically impressive 3D scene where the controls are broken, the marble won't launch, the menu collapses inside gameplay, or the player-camera divorces from the physics. A broken 3D build scores *below* a competent 2D build every time. If you commit to 3D, the controls must be as tight as any 2D game or the ambition backfires.
- **The specific 2026 AI cliché cluster (observed converged multiple times):**
  - lighthouse / rotating beam over dark water
  - moth-to-flame / firefly / lantern-and-moths / night-garden collector
  - deep-sea bioluminescent descent
  - sumi-e / ink-wash calligraphy-as-combat
  - spirit-orb-in-void
  - gothic-ember dungeon with flat enemies
  - "brutalist paper obsidian and blood glass" hi-contrast physics slingshot

  These are not banned — but multiple prior contestants across *different models* independently converged on them from earlier versions of this prompt. That means the judge has seen the default answer. If you land in one of these buckets, you have to work three times harder to escape the "oh, this one again" reaction.

If your first concept lands in one of those buckets, pause. Generate five wildly different ideas. Kill the most obvious one. Kill the one that defaults to black+one-accent. Pick the one that scares you a little because you don't quite know how to pull it off — that is usually the right answer.

---

## 3. The polish floor (what "competent" looks like in 2026, and why it loses alone)

Visuals are scored ~20% of the composite and are the fastest way to signal or destroy the judge's first impression. You can win with 2D, 2.5D, 3D, text, ASCII, WebGPU compute, CSS-only, any of it — but *whatever you choose must actually be crafted, sustained across the whole run, and not primitive-shape default*.

The floor to be taken seriously:

- **Silhouette identity.** Entities that are more than "colored circle / rectangle." Hand-drawn shapes, sprites, meshes, particles-with-personality. If every entity in your game is the same primitive geometry with different tints, your V0 score caps low regardless of functionality.
- **Sustained density-of-craft, not just a hero title screen.** Layered lighting or fog or texture or particle systems or camera composition or dressing or cohesive palette — at least two of those, visible during *actual gameplay*, not just the menu.
- **Readability preserved.** Craft that hides attacks, hazards, or the player under particle soup is not craft. Effects must not eat the game.
- **Coherent identity from menu → gameplay → death → restart.** Same voice everywhere.

**Working 3D / WebGL / WebGPU is bonused.** If your game ships actual GPU-programmed rendering that also passes every gate above (including controls and framerate) — that is a memorable answer to *"how did an AI do this in one session?"* and the rubric explicitly rewards it. But: **broken 3D scores below competent 2D.** Ambition without control is worse than restraint with control. Do not choose 3D unless you can finish it.

**Deliberate minimalism is fine — and can win — but only if intentional and expressive.** A precise monochrome game with exquisite timing, a single-verb game with perfect feedback, a text-only game with an unforgettable voice — these can all score at the top of V0. The bar: it must read as *chosen*, not *defaulted-to-because-time-ran-out*, and the polish inside that constraint has to be extreme.

---

## 4. Depth after the wow

The single most common failure across recent rounds is *"beautiful first 30 seconds, then I don't want to keep playing."* First-impression polish without depth loses to a rougher game with real replay. To avoid that:

- **After the wow beat, there must be another beat.** Difficulty scales, a new mechanic unlocks, a new environment enters, the world reveals a second layer — *something* that gives the judge a reason to still be there at minute 5.
- **The core verb has to earn its runtime.** If your core verb is dragging a light, or tilting a marble, or drawing a stroke — the game has to invent enough variations on it that the tenth use feels different from the first.
- **Fail states must be readable.** The judge dies, understands why, and wants to try again. If they die and can't tell what killed them, they close the tab.
- **Progression is visible.** Score, wave, level, story beat — any concrete signal that "I got further." A game with no legible progress is a screensaver.

---

## 5. How to spend your session (a pattern, not a recipe)

You decide your own process. What follows is the pattern observed in entries that did well:

1. **Pick a concept that is a little too big for the time, then cut relentlessly.** A breathtaking 2-minute vertical slice beats 20 minutes of filler. If your wildest idea is "photorealistic coastal highway at golden hour with real traffic" and you can only ship 45 seconds of it at quality, ship the 45 seconds — but make those 45 seconds *unforgettable*.
2. **Get the one thing the player does most — or the thing that is your wow shot — working and feeling/looking right before adding anything else.** Play it. If you are not proud of that one thing in isolation, stop and fix it.
3. **Then build outward.** One scene, one beat, one payoff that earns its runtime, honest polish, final QA.
4. **Play your own game for at least 10 minutes.** With a real mouse. With sound on. With the tab blurred and refocused. On a resized window. If you are bored, the judge will be bored. If you keep noticing the same bug, the judge will notice it faster.
5. **Cut scope rather than ship half-working breadth.** A small thing that is astonishing beats a big thing that mostly works.
6. **Be honest in your deliverable.** Ship what works; don't claim what doesn't.

**Rewarded for revising a weak early approach.** The long-session pillar is not "generated more code" — it is "recognized my first prototype wasn't good enough and did something about it."

---

## 6. Explicit anti-behaviors (auto-defect)

Doing any of these is a defect against your build, regardless of how good the rest is:

- Backend, external service, analytics, telemetry, network calls, hidden reporting.
- Embed a quality/benchmark self-rating or "eval score" inside the game. Internal high-score tables are fine; meta-quality scores are not.
- Read or reference any benchmark/evaluation files (there are none in your workspace anyway).
- Reverse-engineer or hunt for evaluation criteria beyond this document.
- Placeholder screens, "under construction" rooms, dead ends, unimplemented buttons, disabled tabs.
- Fake behavior: hidden autoplay that makes a demo look better than real play; behavior that changes between headless/desktop/mobile; a "cinematic intro" that hides that the actual gameplay is much thinner.
- Ship simple flat colored rectangles / primitive-shape enemies with no dressing as your final look — visual ambition is heavily weighted and this scores at the floor.
- **Claim controls that don't work.** If your README says "click to aim" and clicking doesn't aim, that is worse than not shipping click-aim at all.
- **Ship a constant audio drone / streaming bass loop.** Audio must be event-driven and stoppable.

---

## 7. Self-QA checklist (run before you ship)

Launch & boot:
- [ ] Fresh load starts; no blank screen, no unhandled error loop, no infinite spinner, no missing-asset fatal
- [ ] Title / entry screen renders coherently and matches the game's identity

Core controls, desktop:
- [ ] Primary movement/interaction works with a *real* mouse and a *real* keyboard, not just synthetic events
- [ ] If mouse-aim is used: cursor leaving canvas does not soft-lock, lose the aim vector, or freeze the player
- [ ] Menus / pause overlays do not swallow game clicks; game clicks do not fire through open menus
- [ ] No page scroll on game keys, no browser default hijack
- [ ] Input buffering: a press while busy is not silently dropped
- [ ] Frame-rate independent

Mobile / touch (if supported):
- [ ] Buttons large & thumb-reachable; no accidental scroll / zoom / selection; press states visible

Game feel:
- [ ] First meaningful interaction happens inside ~10 seconds of load
- [ ] Actions have wind-up → active → recovery if applicable; success and failure are distinct
- [ ] Death / fail states clearly communicate what killed the player

Loop & progression:
- [ ] Full run: start → gameplay → reward/progression → end condition → restart, all without refresh
- [ ] First level / wave is beatable by a real human in reasonable time
- [ ] There is a beat after the first wow; the game gets somewhere over 5–10 minutes
- [ ] No permanently stuck states, no impossible placements, no unreachable win conditions

States & transitions:
- [ ] Pause fully freezes simulation, timers, particles, physics, spawns; resume continues cleanly
- [ ] Instant Restart fully resets; rapid Restart→Start does not double-spawn
- [ ] Menu open / close does not leak input into gameplay
- [ ] Resize / orientation change mid-game safe; tab blur/focus safe

Audio:
- [ ] Master mute silences everything within one frame
- [ ] No constant drone / infinite bass streaming loop
- [ ] Sounds are event-driven; failure to init AudioContext does not block gameplay
- [ ] Tab-blur pauses or ducks audio

Persistence (if applicable):
- [ ] High scores / progress survive reload, sorted; corrupt storage doesn't crash; reset behind confirmation

Robustness & performance:
- [ ] Stable frame rate with many entities/particles; pooled / capped where possible
- [ ] Rendering pauses when tab hidden
- [ ] Mashing inputs safe

Accessibility:
- [ ] Keyboard navigates menus; visible focus states
- [ ] Reduced-motion mode reduces shake / flash / particles
- [ ] Info is not color-only; legible at small sizes; safe areas respected

Environment consistency:
- [ ] Same rules on desktop / mobile / portrait / landscape / headless — no device or UA bonuses

Visual ambition (heavily weighted):
- [ ] Not primitive shapes / flat rectangles / generic UI as final look
- [ ] Distinctive, consistent art identity across menu, gameplay, death, restart
- [ ] Layered visual craft (at least two of: lighting, fog, texture, particles, dressing, camera composition, palette) sustained across the whole run, not just the title
- [ ] Rich visuals do not hurt readability of hazards / player / actions
- [ ] Clearly beyond box-gradient-colored-enemies / 2002-flash-game presentation

Honesty gate:
- [ ] No placeholder screens, dead ends, broken buttons; everything the README claims works and is reachable
- [ ] No telemetry, analytics, hidden reporting, embedded meta-quality score
- [ ] The build I am about to ship is the *actual result of one session*, not stitched from multiple polish passes

---

## 8. Deliverables

1. **Runnable game** — static build (folder or single HTML). Opens in a modern browser or via `python -m http.server`. It plays.
2. **README.md** — short: how to run, controls (what you chose and why), engine/stack if any, what you intentionally cut for time (if anything), a 1-paragraph **DIRECTOR_STATEMENT** (your intent, the wow you were going for, what you want the player to feel).
3. **One-paragraph honest self-assessment** (can be inside README): what your build's strongest beat is and where it is weakest. Don't oversell. The judge scores what they experience, not what you promise.

The judge reads (2) and (3) *after* independent scoring, to understand intent — not to rescue anything the game itself failed to communicate.

---

## 9. Definition of Done (final gate)

Before you stop, you must be able to say truthfully:

- A new player can load the page, understand the objective, interact meaningfully, achieve something, and restart after failure — without confusion, without reading anything.
- The game is complete (start → progression → end → restart) and has no broken buttons, dead ends, or placeholder screens.
- It runs offline, self-contained, on desktop, on mobile.
- **Every claim in the README is true.** Everything I say exists, works, and is reachable.
- Mouse works on a real mouse. Audio can be muted instantly and does not drone. Pause fully freezes. Menu state does not leak into gameplay.
- The visuals are *chosen* and *sustained*, not primitive-default-because-time-ran-out.
- After the first wow, there is a reason to still be playing at minute 5.
- The build feels authored and intentional — not a template, not a stack of features. A *game*.

---

## 10. Final word

You are not filling out a checklist. You are not delivering homework. You are trying to make another human being, on the other side of a blind comparison, stop for a second and go *"…wait."*

The judge has seen the safe answers. They have seen the generic answers. They have seen particle soup. They have seen the lighthouses and the moths and the sumi-e. They have seen "Move with WASD, Space to jump." They have seen the modal-stack feature soups. They have seen the dark-void-with-glow. **None of those win unless they are elevated by something unignorable.**

Ship your best complete game in one shot. Choose whatever format wins — 2D, 3D, WebGPU compute, text, weird — unlimited freedom, one honest pass. Good luck.

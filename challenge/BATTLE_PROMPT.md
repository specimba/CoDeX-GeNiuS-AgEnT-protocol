# BATTLE PROMPT — Build one good browser game, in one session (v9)

You have a single sustained development session to build a complete, original, playable browser game. A human will play it for up to an hour and compare it side-by-side with another agent's build from the same brief. You never see the other build. There is no rubric to game and no evaluator to please — the human is playing the game they get.

**The task is not to impress. The task is to build a game a person is genuinely glad they played.**

You have unlimited creative freedom — 2D, 2.5D, 3D, WebGPU, WebGL, Canvas, text, ASCII, CSS-only, whatever fits. No required genre, no required camera, no required control scheme, no required stack. Whatever *you* would want to play if you'd never seen this brief before.

---

## 1. What actual game designers do (the craft you're being asked to practice)

This benchmark exists because AI game builds keep converging on the same handful of "safe" defaults. If you want to *not* land there, it helps to know how competent game designers actually pick concepts under time pressure. This section is a working method, not a set of rules — it's the shape of the craft as practiced by indie designers, game-jam winners, and studio designers you can read GDC talks from.

### 1.1 Start from the feeling, not the mechanic

The **MDA framework** (Hunicke/LeBlanc/Zubek, GDC 2001–2004 — the most cited framework in the field) has a directional insight most people miss: designers *build* Mechanics → Dynamics → Aesthetics, but players *experience* Aesthetics → Dynamics → Mechanics. You have to design **backwards from the feeling** or the player never gets there.

Working designers pick **design pillars** first — 3–5 ordered words that name the emotional experience the game is *for*. Wildfire Swap: "Discovery / Elegance / Friendly." Superflight: "Freedom, excitement." A puzzle-platformer designer said in interview: *"I wanted players to feel clever and accomplished — I picked the mechanic after."* One of the most consistent patterns in successful indie/jam games is: **the pillars come before the verb**.

Before you commit to a mechanic, name in one sentence: **what should the player feel in the middle of a good run?** Not what they *do* — what it *feels like*. "Alert but not panicked." "Delighted by a small discovery." "Slightly rueful about a choice they made." "Weighted, deliberate, satisfying." That sentence is the North Star. Every later decision — art, sound, control, difficulty, level shape — gets tested against it.

### 1.2 Find the fun before you find the polish

Every serious prototyping guide agrees on this: **the first job is to answer "is this fun?"** — not "is this complete?" or "is this pretty?" Vlambeer's *The Art of Screenshake* and Jonasson & Purho's *Juice It or Lose It* both work by starting with a boring version (grey rectangles, no effects) and adding juice *after* the core verb feels good. Steve Swink's *Game Feel* orders it explicitly: **real-time control first, predictable simulated space second, juice third.** Juice on top of broken controls is paint on a broken machine.

For a one-shot session that means: build the tiniest playable version of your core verb, in ugly grey shapes, and *play it for a full minute*. If you're not smiling, kill the verb — no amount of particles will rescue it. Ludum Dare winners consistently describe throwing away their first prototype and rebuilding it clean once they've *found the fun* in that first pass.

### 1.3 Small interlocking systems beat sprawling features

Porpentine, on the Ludum Dare MMO *Naked Shades*: *"exactly as many systems as it needs, and they all interlock."* That is the shape of most memorable jam games. Two or three systems that *combine* into something bigger than the sum. Not eight modals around a core verb that doesn't yet feel good.

Practical translation: if your concept requires a talent tree, a shop, a codex, a settings panel, a lore screen, and a difficulty selector to be legible — you picked the wrong concept for a single session. Pick one that reads with two or three systems and *no menu chrome*.

### 1.4 Pick from a wide personal list, not the first idea

Joe Williamson (Ludum Dare 45 winner, *World Collector*): *"For game jams, I'll typically have a handful of ideas already written down which might work for a theme."* The concept that ships is the *filtered* concept, not the first one that popped up.

A pattern that works in one shot: at the very top of your session, before you write any code, list **8–12 concept fragments** in plain text — verbs, feelings, images, unusual constraints. Then look at the list and cross out the ones a competent judge has probably seen from a different agent this week: neon-void shooters, lantern-and-moths, dark-void-with-one-accent-color, sumi-e ink combat, procedural-canvas-tech-demo-with-a-novel-verb, WebGL crystal light-refraction, wave-based-arcade-with-combo-multiplier. Pick from what's left. The one that scares you a little (*"I don't quite know how to pull that off"*) is usually the right answer — because if you don't know how to pull it off, chances are the next agent doesn't either. That's your edge.

You can absolutely include this notebook as `design_notebook.md` in your delivery. It's evidence of authorship and it's interesting to read.

### 1.5 Scope by what you can *finish*, not by what excites you

Every Ludum Dare veteran's #1 lesson: **cut before you polish, polish before you add.** A tiny thing that is *astonishing* beats a big thing that mostly works. If your wildest idea needs 8 hours of your remaining 3 to reach quality, ship 45 seconds of it at that quality instead of 6 minutes of it half-broken.

Rule of thumb for one-shot: **one core verb + one interlocking secondary system + 3–5 levels or 3–5 minutes of escalation + honest polish pass.** Everything past that is a stretch goal you cut cheerfully.

---

## 2. What "a game" means for this benchmark

A complete run has all of these in order, without a page refresh:

1. **Title / start** — the player understands within 10 seconds what they're about to do.
2. **Gameplay** — a clear core action, taken repeatedly, with resistance (something to overcome, learn, discover, or master).
3. **Reward / progression** — something changes as they play: score, level, environment, story, unlock, revealed content. The player can see they got somewhere.
4. **End condition** — victory, death, exhaustion of content, a beat that says "run over." A run has a shape.
5. **Restart** — from the end state, one action starts a fresh run with all state cleanly reset.

A screensaver, a physics toy, a tech demo, a scene you walk through once with no ask — none of those are games for this benchmark, no matter how beautiful. If your build can be fully exhausted in under 2 minutes on first try with no resistance, it fails this gate.

---

## 3. Non-negotiable gates (fail any and the human stops early)

These are the only hard rules. Everything else is your call.

1. **Launches.** Opening the HTML (or running `python -m http.server`) starts the game. No blank screen, no infinite spinner, no console-error loop, no missing-asset fatal.
2. **Complete loop.** Start → gameplay → reward → end → restart, without page refresh. See §2.
3. **First level / wave / room beatable** by a real human in ~5 minutes of honest play. Onboarding must not be "clever-but-impossible."
4. **Controls that work.** Whatever inputs you support, they work with a *real* mouse, keyboard, or touch. If you use mouse-aim, cursor leaving the canvas must not soft-lock or lose the aim vector. Menus don't leak clicks into gameplay. **Test with a real mouse before shipping**, not synthetic events.
5. **Pause, mute, restart work.** Pause fully freezes simulation, timers, particles, spawns. Mute silences everything within one frame — **no constant drone, no streaming bass loop that never stops.** Restart resets fully. If `AudioContext` cannot init, the game still plays.
6. **Robust to normal browser things.** Resize mid-play safe. Tab-blur pauses (or safely continues without audio). Orientation change re-lays out cleanly. Rapid Restart→Start doesn't double-spawn. Corrupt `localStorage` doesn't crash.
7. **Self-contained & offline.** No backend, no network calls, no external AI/model services at runtime, no analytics, no telemetry, no hidden reporting. Static folder or single HTML. Bundle every library. Local / procedural / self-created / clearly-licensed assets only.
8. **Honest.** No placeholder screens, no dead ends, no buttons that don't work, no "coming soon." No hidden autoplay that makes the game look better than it plays. Same game plays for every human on every run — no environment sniffing, no demo mode.
9. **One shot.** This deliverable is the output of one sustained development session. If you iterate across multiple returned artifacts, disclose in the README first line as `TRACK: iterated (N passes)`. Undisclosed multi-turn iteration is worse than disclosed. If in doubt, disclose.
10. **Legal / original.** Ship only content you have the right to ship.

---

## 4. Three things previous rounds have consistently failed at (worth reading twice)

### 4.1 Depth after the first minute
The most common single failure across recent rounds: a build lands a nice first-30-seconds beat and then repeats the same content for the next 10 minutes. Player reads this as a screensaver. **Something has to change** as the run continues — difficulty scales, a new mechanic unlocks, a new environment enters, the world reveals a second layer, a boss shows up. That change is what turns "a demo of a mechanic" into "a run of a game."

### 4.2 Visual density that lasts through the whole run
A polished title screen followed by primitive-shape gameplay reads as a broken promise. Whatever visual identity you commit to — painterly, minimalist, brutalist, cutesy, gothic — **sustain it across menus, gameplay, death screen, restart.** If you commit to 3D or WebGPU, the controls and framerate gates apply the same way: broken 3D reads worse than competent 2D. If you're not sure you can *finish* the 3D version, ship the 2D version.

Deliberate minimalism is fine and can win — but only if it reads as *chosen*, and the polish inside the constraint is unmistakable.

### 4.3 The retro-visuals trap (the "2013 mobile game" collapse)
This one is new for v9 and it's the single most consistent human-judge complaint on recent rounds. Real mechanics, real physics, a complete loop, reasonable polish — but visuals that look like 2013 or 1988 read as **retro, not modern**, and judges have literally called shipped games "80s Bomberman with a rebrand" or "2013 mobile-arcade tier due to mechanics not graphical depth." *Even when the mechanics were good.* Retro-by-accident is a stronger negative than most agents realize.

You have real 2026 tools for making a one-shot browser game look *actually modern*, all self-contained, all offline, no external assets required. The LLM Frontend Benchmark (Startrise 2026) shows frontier models scoring 79–88 on WebGL-shader and 3D-game tasks — the ceiling is real for capable models, and most one-shot builds leave it on the table. Concrete techniques you can reach for:

- **Real shader work.** One custom fragment shader (SDF background, gradient/normal-based lighting, noise-based fog, chromatic aberration, radial darkening) is the single biggest visual jump you can make in one file. WebGL 2 is universal; WebGPU is a bonus if available. Gate the path safely and provide a Canvas 2D fallback.
- **Procedural textures instead of flat colors.** Every solid rectangle surface can be a fragment shader with Perlin/Simplex noise + fractal octaves — wood grain, brushed metal, water caustics, paper fiber, subsurface glow. ~40 lines turns a primitive into a material.
- **Post-processing you write yourself.** Bloom, vignette, color grading, film grain, subtle CRT scanlines, radial blur, chromatic aberration — 20–100 line shader passes on the composited frame. Modern games look modern largely because of post-processing.
- **A real lighting model, even in 2D.** Per-pixel normals from a heightfield or SDF + one directional light + one point light gets you from "flat colors" to "material" in a fragment shader.
- **Modern menu chrome** — CSS 3D transforms, real font weights, subtle motion, glass-morphism-ish backdrops. Not the game, but the *whole thing* reads modern.
- **Real silhouettes for entities** — a hand-drawn bezier or SVG shape with outline and inner-shadow reads modern; the same object as a solid rectangle reads retro.

**Warning — the ambition-theater trap is real.** Prior rounds shipped WebGPU tech demos that looked impressive in a screenshot but crashed the controls, dropped below 30 FPS, or trapped the menu inside the scene. **Broken shader work reads worse than clean Canvas 2D.** The controls gate (§3, item 4), framerate stability, and state isolation (§3, item 6) apply *unchanged* to any shader path you take. If you cannot ship both the shader craft *and* clean controls, ship a smaller shader effect on cleaner controls. Degrade gracefully — Canvas 2D fallback with restrained lighting still reads more modern than a broken WebGPU pipeline.

**Deliberate retro / pixel-art / minimalism is still fine and can still win** — the trap is only about *accidental* retro-because-that-was-the-default. Deliberate 8-bit-with-CRT-post-processing, deliberate paper-cutout, deliberate ASCII with real typography — all fine if they read as *chosen* and polished within the constraint. What loses is "flat primitives + tinted rectangles + no material anywhere" as a default.

---

## 5. How to spend the session (a pattern, not a mandate)

A rough shape observed in submissions that landed well:

1. **10 minutes — Concept + pillars.** Name the feeling (§1.1). Sketch 8–12 concept fragments (§1.4). Cross out the ones you've seen from other AI builds. Pick one from what's left — the one that scares you a little.
2. **20-30 minutes — Find the fun.** Build the core verb in grey rectangles. Play it for a minute. Not smiling? Change the verb. Don't skip this step. (§1.2)
3. **The bulk of the session — Build the shape.** Around the verb, build the run shape (start, escalation, end, restart). Two or three interlocking systems, no menu bloat. (§1.3)
4. **Last quarter of the session — Feel + juice + polish + QA.** Real-time control → predictable space → juice, in that order (Swink). Add sound. Sustain the visual identity across every screen. Run §6.
5. **Last 10 minutes — Cut, don't add.** Anything unfinished gets removed cleanly. Anything shipped is verified working. Write the README honestly.

Long-session credit is for **revising a weak early approach**, not generating more code. If your first prototype isn't landing, changing the verb is a *good* sign.

---

## 6. Self-QA before you ship (fresh load, real mouse, sound on)

- [ ] Fresh load → title → first meaningful interaction inside 10s. No blank screen, no console error loop.
- [ ] Complete loop: start → gameplay → reward → end → restart, no refresh needed.
- [ ] First level / wave / room beatable in ~5 min honest play.
- [ ] Controls respond, no page-scroll on game keys, mouse cursor exit doesn't soft-lock, menus don't leak clicks.
- [ ] Pause fully freezes simulation, timers, particles, spawns.
- [ ] Mute silences everything within one frame — no drone, no unstoppable loop.
- [ ] Resize mid-play safe. Tab-blur safe. Rapid Restart→Start doesn't double-spawn. Corrupt `localStorage` doesn't crash.
- [ ] Visual identity sustained across menu, gameplay, death, restart — not just title.
- [ ] Something changes as the run continues (§4.1).
- [ ] If your look landed at "flat rectangles / primitive shapes / no material anywhere," that's the retro-visuals trap (§4.3) — either intentionally minimalist (with the polish to prove it) or you left the ceiling on the table.
- [ ] If you shipped 3D/WebGL/WebGPU/shader post-processing: framerate stable, controls tight, no scene/menu collapse, graceful fallback if context unavailable.
- [ ] No placeholder screens, dead ends, broken buttons.
- [ ] No analytics, telemetry, hidden reporting, embedded quality/score meta-metric.
- [ ] `TRACK: strict-one-shot` or `TRACK: iterated (N passes)` on first line of README.
- [ ] Everything the README claims exists, works, is reachable.

---

## 7. Deliverables

1. **Runnable game** — static folder or single HTML. Opens and plays.
2. **README.md** — short. First line: `TRACK: strict-one-shot` (or `TRACK: iterated (N passes)`). Then: how to run, controls, stack, what you cut for time, one paragraph **DESIGN_PILLARS** (the 3–5 feeling words you designed toward), one paragraph **DIRECTOR_STATEMENT** (what you want the player to feel), one paragraph **HONEST_SELF_ASSESSMENT** (strongest beat + weakest area, without oversell).
3. **Optional but appreciated:** `design_notebook.md` with your 8–12 concept fragments and why you picked the one you did. Evidence of authorship, and interesting to read.

The human reads (2) and (3) *after* they play — those documents don't rescue what the game itself doesn't communicate.

---

## 8. Definition of done

Before you stop, you should be able to say honestly:

- A new player can load, understand the objective, play, achieve something, fail, and restart — without reading anything.
- The run has a shape — start, gameplay, reward, end, restart. Something changes as it continues.
- Controls work, pause freezes, mute silences, restart resets. No drone. No menu leak. No dead buttons.
- The visuals I committed to are *sustained* across the whole run, not just the title.
- Everything in the README is true.
- If this is not a strict-one-shot build, I said so at the top of the README.

Ship a modest complete game rather than an ambitious broken one. Ship a game you'd play. Good luck.

---

*If you want to go deeper on the craft referenced here: Hunicke/LeBlanc/Zubek "MDA: A Formal Approach to Game Design" (GDC 2004); Steve Swink "Game Feel" (2008); Vlambeer's Jan Willem Nijman "The Art of Screenshake" (GDC 2013); Jonasson & Purho "Juice It or Lose It" (2012); the Ludum Dare post-mortems on ldjam.com. None of these are required reading — they're the tradition this brief is drawing on.*

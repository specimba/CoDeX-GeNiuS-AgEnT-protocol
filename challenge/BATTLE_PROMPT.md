# BATTLE PROMPT — Build one good browser game, in one session (v7)

You have a single sustained development session to build a complete, original, playable browser game. A human will play it for up to an hour and compare it side-by-side with one other agent's build from the same brief. You never see the other build. There is no rubric to game and no evaluator to please — the human is playing the game they get.

**The task is not to impress. The task is to build a game a person is genuinely glad they played.**

---

## 1. What "a game" means here

A complete run has all of these, in order, with no page refresh:

1. **Title / start** — the player understands within 10 seconds what they're about to do.
2. **Gameplay** — a clear core action they take repeatedly, with resistance (something to overcome, learn, discover, or master).
3. **Reward / progression** — something changes as they play: score, level, environment, story, unlock, revealed content. The player can see they got somewhere.
4. **End condition** — victory, death, exhaustion of content, a beat that says "run over." A run has a shape.
5. **Restart** — from the end state, one action starts a fresh run with all state cleanly reset.

A screensaver, a physics toy, a tech demo, a scene you walk through once with no ask — none of those are games for this benchmark, no matter how beautiful. **If your build can be fully exhausted in under 2 minutes on first try with no resistance, it fails this gate.**

Scope suggestion — this is where good one-shot builds tend to land:
- **One core verb** (drag, shoot, tilt, draw, place, deflect, whatever) that feels great in isolation before you add anything.
- **3–5 levels or 3–5 minutes of escalation**, hand-shaped, that make the core verb evolve.
- **Simple loss condition** the player understands immediately.
- **Small honest polish pass** at the end for feel, feedback, and readability.

A tight game that does one thing well beats a sprawling game that mostly works. If you have to choose between more content and more polish, choose polish.

---

## 2. Non-negotiable gates (fail any and the human stops early)

These are the only hard rules. Everything else is your call.

1. **Launches.** Opening the HTML (or running `python -m http.server`) starts the game. No blank screen, no infinite spinner, no console-error loop, no missing-asset fatal.
2. **Complete loop.** Start → gameplay → reward/progression → end → restart, without page refresh. Not a toy, not a demo, not a screensaver — see §1.
3. **First level / wave / room is beatable** by a real human in ~5 minutes of honest play. Onboarding must not be "clever-but-impossible."
4. **Controls that work.** Whatever inputs you support, they work with a *real* mouse and *real* keyboard (or *real* touch). If you use mouse-aim, cursor leaving the canvas must not soft-lock or lose the aim vector. Menus don't leak clicks into gameplay. Test this before shipping.
5. **Pause, mute, restart work.** Pause fully freezes simulation, timers, particles, spawns. Mute silences everything within one frame — **no constant drone, no streaming bass loop that never stops.** Restart from any state resets fully. If `AudioContext` cannot init, the game still plays.
6. **Robust to normal browser things.** Resize mid-play safe. Tab-blur pauses (or safely continues without audio). Orientation change re-lays out cleanly. Rapid Restart→Start doesn't double-spawn. Corrupt `localStorage` doesn't crash.
7. **Self-contained & offline.** No backend, no network calls, no external AI/model services at runtime, no analytics, no telemetry, no hidden reporting. Static folder or single HTML. Bundle every library. Local / procedural / self-created / clearly-licensed assets only.
8. **Honest.** No placeholder screens, no dead ends, no buttons that don't work, no "coming soon." No hidden autoplay that makes the game look better than it plays. The same game plays for every human on every run — no environment sniffing, no demo mode differing from real play.
9. **One shot.** This deliverable is the output of one sustained development session. If you go back and iterate across multiple returned artifacts, disclose that in the README as `TRACK: iterated (N passes)` — those builds are tracked separately and cannot win the primary battle result. If in doubt, disclose. Undisclosed multi-turn iteration is worse than disclosed iteration.
10. **Legal / original.** Ship only content you have the right to ship. Self-created, procedurally generated, public-domain, or clearly-licensed local assets. Attribute in README.

That's all. No required control scheme, no required style, no required genre, no required tech stack. 2D, 2.5D, 3D, text, ASCII, CSS-only — your call.

---

## 3. What a human will notice

You don't need to be told what makes a game good. But here are things humans consistently do and don't notice, so you can spend your session accordingly:

**They notice** when the core verb has weight, when they die and understand why, when a second thing happens after they've figured out the first thing, when the visuals still look considered five minutes in, when audio adds rather than intrudes, when there's a moment they'd screenshot.

**They don't notice** most of your feature list, most of your particle systems, or how many buttons your title screen has. They don't notice code quality directly, but they notice the symptoms: stutters, glitches, layout breaks, console errors, controls that lag.

Two specific things previous rounds under-delivered on:

- **Depth after the first minute.** A build that lands its first-30-seconds beat and then repeats identical content for the next 10 minutes reads as a screensaver, not a game. Something should change — difficulty, environment, mechanic, story — as the player continues.
- **Visual density that lasts.** A polished title screen followed by primitive-shape gameplay reads as a broken promise. Whatever visual identity you commit to, sustain it across menus, gameplay, death, restart. If you commit to 3D or WebGPU, make sure it *also* passes the controls and framerate gates — broken 3D reads worse than competent 2D.

---

## 4. How to spend the session (a pattern that has worked, not a mandate)

1. **Pick a concept you can finish.** Bigger-than-time is fine only if you can cut it down to a shippable core. If in doubt, smaller is better.
2. **Get the one thing the player does most working and feeling right, in isolation, before adding anything.** Play it for a minute. Not proud? Fix it. Still not proud? Change the verb.
3. **Build the shape of a run around that verb** — start, escalation, end, restart. Not features around it, *the shape.*
4. **Play your own game for 10 minutes with sound on and a real mouse.** With the tab blurred and refocused. On a resized window. If you're bored, the human will be bored. If a bug keeps annoying you, it will annoy them faster.
5. **Cut before you polish, polish before you add.**
6. **Ship honestly.** Everything in your README works and is reachable. If something's rough, say so; don't oversell.

Long-session credit goes to *revising a weak early approach*, not to *generating more code*. If your first prototype isn't landing, changing direction is a good sign, not a bad one.

---

## 5. Self-QA before you ship

Run these in one pass, fresh load, real mouse, sound on. Fix what you can; disclose what you can't.

- [ ] Fresh load → title → first meaningful interaction inside 10s. No blank screen, no console error loop.
- [ ] Complete loop works: start → gameplay → reward → end → restart, no refresh needed.
- [ ] First level / wave / room is beatable in ~5 min honest play.
- [ ] Controls respond, no page-scroll on game keys, mouse cursor exit doesn't soft-lock, menus don't leak clicks.
- [ ] Pause fully freezes. Mute silences within one frame — no drone.
- [ ] Resize mid-play safe. Tab-blur safe. Rapid Restart→Start doesn't double-spawn. Corrupt `localStorage` doesn't crash.
- [ ] Visual identity is present in gameplay, not just the title screen.
- [ ] There's a reason to still be playing at minute 5 — something changes as the run continues.
- [ ] No placeholder screens, dead ends, broken buttons, "coming soon."
- [ ] No analytics, telemetry, hidden reporting, embedded quality/score meta-metric.
- [ ] `TRACK: strict-one-shot` at top of README (or `TRACK: iterated (N passes)` if disclosing).
- [ ] Everything the README claims exists, works, and is reachable.

---

## 6. Deliverables

1. **Runnable game** — static folder or single HTML. Opens and plays.
2. **README.md** — short. First line: `TRACK: strict-one-shot` or `TRACK: iterated (N passes)`. Then: how to run, controls, stack if any, what you cut for time, one paragraph **DIRECTOR_STATEMENT** describing your intent and what you want the player to feel, one paragraph **HONEST_SELF_ASSESSMENT** naming your strongest beat and your weakest area. The human reads these *after* they play — they don't rescue what the game itself doesn't communicate.

---

## 7. Definition of done

Before you stop, you should be able to say honestly:

- A new player can load, understand the objective, play, achieve something, fail, and restart — without reading anything, without confusion.
- The game has a run shape — not a toy, not a demo. There's a reason to still be playing at minute 5.
- Controls work, pause freezes, mute silences, restart resets. No drone. No menu leak. No dead buttons.
- The visuals I committed to are sustained across the whole run.
- Everything in the README is true.
- If this is not a strict-one-shot build, I said so at the top of the README.

Ship a modest complete game rather than an ambitious broken one. Good luck.

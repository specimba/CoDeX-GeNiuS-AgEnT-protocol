# Developer Self‑QA Checklist

This is the **internal** build‑verification checklist an agent runs against its own build
before delivery. It exists to help the agent ship a robust game. It is **not** the external
evaluation rubric — that lives in `benchmark/` and is never shown to the agent. Some items
overlap with the spec's requirements by design; that overlap is legitimate (the spec is
the agent's source of truth). What is withheld is the *scoring*.

## How to run this checklist

Do it on a **fresh load**, then again after a reload, then once on a mobile viewport. For
every item: **Pass** / **Fail** / **Not applicable**, plus one line of evidence. Fix every
Fail you can. If a Fail can't be fixed in time, record it honestly in your README — the
player experience will reflect it regardless.

## A. Launch & boot

- [ ] Fresh load starts; no blank screen, no unhandled console errors, no infinite spinner.
- [ ] Boot/loading state exists and resolves.
- [ ] Title screen renders: title, subtitle, Start Run, How to Play, High Scores, audio toggle.

## B. Core controls (desktop)

- [ ] WASD + arrows move the player; no page scroll on arrows/Space.
- [ ] Space dodges with i‑frames and cooldown feedback.
- [ ] J / LMB attacks; K / RMB uses the special ability.
- [ ] E interacts (open chests, select rewards); P / Esc pauses.
- [ ] Input buffering: a quick attack/dodge press while busy is not silently dropped.
- [ ] Controls are frame‑rate independent (feel the same at different FPS).

## C. Core controls (mobile/touch)

- [ ] Left virtual joystick/drag pad works; right attack/dodge/ability buttons are large and
      thumb‑reachable.
- [ ] No accidental scroll, zoom, text selection, or page navigation during play.
- [ ] Buttons show press states; haptic feedback where supported.

## D. Combat feel

- [ ] First attack connects in the first encounter (within ~10 s of a run).
- [ ] Attack has wind‑up → hitbox → recovery; hit‑stop on impact; damage numbers appear.
- [ ] Hit / miss / crit are visually distinct.
- [ ] Dodge has i‑frames, afterimage/trail, sound, and a fair timing window.
- [ ] Special ability works, is limited by a resource, and feels impactful.
- [ ] Tactical phase shows enemy intent indicators and projected attack zones; decisions
      resolve predictably and quickly.

## E. Enemies & combat loop

- [ ] At least 4 enemy types behave distinctly (incl. a melee, a ranged, a fast, an elite).
- [ ] A boss exists with ≥3 readable patterns and a vulnerability window.
- [ ] Enemies have idle/move/attack/hit/defeat states with feedback.
- [ ] No enemy or the player can become permanently stuck; paths remain reachable.

## F. Dungeon & progression

- [ ] Run contains start + combat + reward + (optionally healing/event) + boss rooms.
- [ ] Branching path choices exist and all branches are reachable.
- [ ] No impossible enemy placements; clear exits.
- [ ] Seeded: two different seeds produce two different, both‑reachable runs.

## G. Rewards & score

- [ ] Coins drop and collect; relics/upgrades have visible impact.
- [ ] Score tracks enemy defeats, combos, floors, perfect dodges, coins.
- [ ] Run score and best score are shown; combo/momentum meter works.

## H. Persistence

- [ ] High scores save and survive a reload, sorted descending.
- [ ] Corrupt/invalid stored data does not crash the game (verify by hand‑editing the key).
- [ ] Reset high scores is behind a confirmation.

## I. States & transitions

- [ ] Start → gameplay → reward → floor transition → boss → game over / victory → restart
      all work.
- [ ] Pause fully freezes simulation, timers, particles, enemy behavior; resume continues.
- [ ] Gameplay input does not leak into menus.

## J. Robustness & edge cases

- [ ] Instant restart fully resets run state.
- [ ] Resize mid‑combat and orientation change don't break layout or hide info.
- [ ] Tab blur/focus is safe; on mobile, visibility change pauses appropriately.
- [ ] Mashing attack/dodge/ability doesn't corrupt state or crash.

## K. Accessibility

- [ ] Keyboard can navigate menus; visible focus states.
- [ ] Reduced‑motion mode reduces shake/flash/particles.
- [ ] Info is not conveyed by color alone; text labels for icons where needed.
- [ ] Text is legible at small sizes; touch targets respect safe areas.

## L. Performance

- [ ] Stable frame rate with several enemies and many particles.
- [ ] Particles are pooled and capped; no per‑frame garbage spikes.
- [ ] Rendering/simulation pauses when the page is hidden.
- [ ] Debug/performance indicator available (toggleable, off by default for players).

## M. Audio

- [ ] Sound toggle works; audio failure does not block gameplay.
- [ ] Menu/game/reward/boss sounds present (or a strong visual‑only fallback).

## N. Honesty gate

- [ ] No placeholder screens, "under construction", dead ends, or broken buttons.
- [ ] Everything claimed in the README actually works and is reachable.
- [ ] No telemetry, analytics, hidden reporting, or embedded "quality score."

## O. Environment consistency (no demo mode)

- [ ] The game plays the same on desktop and mobile, and in portrait and landscape.
- [ ] It does not change difficulty, give bonuses, or unlock content based on device,
      viewport, user‑agent, or input method.
- [ ] A headless / automated run sees the same rules as a human keyboard run.
- [ ] There is no hidden autoplay, no environment detection, no "looks good in a demo"
      path that differs from a real player's path.

## P. Graphical originality (this is weighted)

- [ ] Visuals are original, not primitive shapes or generic flat rectangles.
- [ ] There is a distinctive, consistent art identity across rooms, enemies, UI, and menus.
- [ ] Procedural detail exists: lighting, fog, texture, particles, embers, dressing — not an
      empty room with a rectangle player.
- [ ] The visual identity holds across the whole run, not just the title screen.
- [ ] Rich visuals do NOT hurt readability: attacks, hazards, and the player stay obvious.

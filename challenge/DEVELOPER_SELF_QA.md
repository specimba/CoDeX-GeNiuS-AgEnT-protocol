# Developer Self-QA — One-Shot Game Creation

A short internal checklist to run against your build before delivery. Fresh load, real mouse, sound on. Then again after reload. Then once on a mobile viewport (if you support touch).

For every item: Pass / Fail / N/A, plus one line of evidence. Fix every Fail you can. If you can't fix it in time, disclose honestly in the README — the human will find it either way and honest disclosure is not penalized.

This checklist is not the scoring rubric. It's a discipline aid.

---

## Launch & boot
- [ ] Fresh load starts. No blank screen, no unhandled console error loop, no infinite spinner, no missing-asset fatal.
- [ ] Title / entry screen renders coherently and matches the game's identity.
- [ ] A new player can understand the objective from the game itself in <1 minute, without reading the README.

## Controls
- [ ] Primary movement / interaction works with a **real mouse and real keyboard**, not just synthetic events.
- [ ] If mouse-aim is used: cursor leaving the canvas does not soft-lock, does not lose the aim vector, does not freeze the player. Re-entry restores aim cleanly.
- [ ] Menus / pause overlays do not swallow game clicks; game clicks do not fire through open menus.
- [ ] No page-scroll on game keys (Space / arrows prevented).
- [ ] Input buffering: quick press while busy is not silently dropped.
- [ ] Controls feel the same at different frame rates (delta-time simulation).
- [ ] Touch (if supported): buttons large & thumb-reachable, no accidental scroll / zoom / selection, visible press states.

## Complete loop
- [ ] Full run: start → gameplay → reward / progression → end condition → restart, all without a page refresh.
- [ ] **First level / wave / room is beatable** by a real human in ~5 min honest play. Onboarding difficulty is calibrated, not "clever-but-impossible."
- [ ] **There is a reason to still be playing at minute 5.** Difficulty scales, or a new mechanic unlocks, or a new environment enters, or the world reveals a second layer — something that changes.
- [ ] Death / fail states are readable — the player understands *what killed them* and wants to retry.
- [ ] No permanently stuck states, no impossible placements, no unreachable win conditions.

## States & transitions
- [ ] Pause fully freezes simulation, timers, particles, spawns, physics. Resume continues cleanly.
- [ ] Instant Restart fully resets run state.
- [ ] Rapid Restart → Start does not double-spawn or corrupt state.
- [ ] Menu open / close does not leak input into gameplay.

## Audio (hygiene)
- [ ] Master mute silences everything within one frame.
- [ ] **No constant drone / streaming bass loop that never stops.** Sounds are event-driven with finite envelopes.
- [ ] Audio failure (AudioContext init, autoplay policy) does not block gameplay.
- [ ] Tab-blur pauses or ducks audio; sounds don't play behind pause overlay.

## Robustness & edge
- [ ] Instant restart fully resets.
- [ ] Resize / orientation change mid-play safe.
- [ ] Tab blur / focus safe; on mobile visibility change pauses appropriately.
- [ ] Mashing primary actions doesn't corrupt state or crash.
- [ ] Corrupt `localStorage` doesn't crash (verify by hand-editing your storage key).

## Performance
- [ ] Stable frame rate with typical entity load.
- [ ] Particles / floating text / projectiles are pooled or capped; no per-frame garbage spikes.
- [ ] Rendering / simulation pauses when the tab is hidden.

## Visual identity
- [ ] Visual identity is sustained across menu, gameplay, death, restart — not just the title screen.
- [ ] Rich visuals do not hurt readability of hazards / player / actions.
- [ ] If you shipped 3D / WebGL / WebGPU / heavy physics: controls are as tight as any 2D game equivalent, framerate is stable, menu isolates from scene. Broken 3D reads worse than competent 2D — cut if it can't ship at quality.
- [ ] Deliberate minimalism is fine, but it must read as *chosen* — the polish inside the constraint is what makes it work.

## Accessibility
- [ ] Keyboard navigates menus; visible focus states.
- [ ] Reduced-motion mode reduces shake / flash / particles.
- [ ] Info is not color-only; legible at small sizes; safe areas respected.

## Environment consistency
- [ ] Same rules on desktop / mobile / portrait / landscape / headless — no device or UA bonuses, no demo mode differing from real play.

## Honesty gate
- [ ] No placeholder screens, "under construction," dead ends, broken buttons.
- [ ] Everything the README claims exists, works, and is reachable.
- [ ] No telemetry, analytics, hidden reporting, embedded quality / eval score inside the game.
- [ ] **First line of README** declares `TRACK: strict-one-shot` or `TRACK: iterated (N passes)`. If this build is the actual result of one session, say so. If it isn't, disclose — undisclosed multi-turn iteration is worse than disclosed iteration.

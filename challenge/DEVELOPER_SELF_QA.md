# Developer Self-QA Checklist — One-Shot Game Creation

Internal build-verification checklist agent runs before delivery. Not external rubric — lives in benchmark/ and never shown as scoring formula. Some overlap with spec legitimate (spec is source of truth). What is withheld is scoring weights.

How to run: fresh load, then again after reload, then once on mobile viewport. For every item: Pass / Fail / N/A, plus one line evidence. Fix every Fail you can. If Fail can't be fixed in time, record honestly in README — player experience will reflect it regardless. This benchmark rewards long-session execution: prototype → test → debug → iterate → polish, not first functional version.

## A. Launch & boot (Kernel)
- [ ] Fresh load starts; no blank screen, no unhandled console errors, no infinite spinner
- [ ] Boot/loading state exists and resolves
- [ ] Title/start screen renders with understandable objective, Start, How to Play if applicable, audio toggle, cohesive theme
- [ ] Understandable in <1 min without manual

## B. Core controls / interaction (Kernel)
- [ ] Primary movement/interaction works; no page scroll on game keys (Space/arrows prevented)
- [ ] Dodge/special action if applicable has feedback and fair window
- [ ] Input buffering: quick press while busy not silently dropped
- [ ] Controls frame-rate independent (feel same at different FPS)
- [ ] No hidden autoplay faking quality

## C. Mobile/touch (if applicable, or desktop-only documented)
- [ ] Virtual controls work if applicable; buttons large thumb-reachable
- [ ] No accidental scroll, zoom, text selection, page navigation during play
- [ ] Buttons show press states; haptic where supported

## D. Game feel & depth
- [ ] First interaction works within ~10s
- [ ] Actions have wind-up → active → recovery if applicable; hit-stop/feedback; distinct success/failure
- [ ] Special action works, limited by resource, feels impactful
- [ ] Mechanics offer variety beyond one-trick (emergence, viable approaches, not single trick)

## E. World & progression (your design)
- [ ] Run/level/mode contains start + gameplay + reward/progression + end condition
- [ ] Branching/variety choices exist and all reachable if applicable
- [ ] No impossible placements; clear goals/exits; readable hazards
- [ ] If procedural/seeded: two different seeds give different both-reachable runs

## F. Rewards & polish
- [ ] Rewards/collectibles have visible impact
- [ ] Score/progress tracks understandable, combo/momentum if applicable
- [ ] Feedback quality: telegraphs, numbers, hit/miss, sounds/visual

## G. Persistence
- [ ] If game has high-scores/progress: saves and survives reload, sorted, handles corrupt/invalid stored data without crash (verify by hand-editing key), reset behind confirmation
- [ ] If explicit no-persistence by design: document in README director statement

## H. States & transitions
- [ ] Start → gameplay → reward → end → restart all work
- [ ] Pause fully freezes simulation, timers, particles, behavior; resume continues
- [ ] Gameplay input does not leak into menus

## I. Robustness & edge cases
- [ ] Instant restart fully resets run state
- [ ] Resize mid-combat and orientation change don't break layout or hide info
- [ ] Tab blur/focus safe; on mobile visibility change pauses appropriately
- [ ] Mashing primary actions doesn't corrupt state or crash

## J. Accessibility
- [ ] Keyboard can navigate menus; visible focus states
- [ ] Reduced-motion mode reduces shake/flash/particles
- [ ] Info not conveyed by color alone; text labels for icons where needed
- [ ] Text legible at small sizes; touch targets respect safe areas

## K. Performance & code quality (weighted)
- [ ] Stable frame rate with many entities/particles, even at 45-60 min
- [ ] Particles/floating text/projectiles pooled and capped; no per-frame garbage spikes
- [ ] Rendering/simulation pauses when page hidden
- [ ] Debug/performance indicator available toggleable off by default for players
- [ ] Code shows separation: state, input, loop, rendering, collision, audio, UI, config centralized, no scattered magic numbers — evidence of iteration/refactor, not just dump

## L. Audio
- [ ] Sound toggle works; audio failure doesn't block gameplay
- [ ] Sounds present or strong visual-only fallback

## M. Environment consistency (no demo mode)
- [ ] Game plays same desktop/mobile/portrait/landscape/headless; no device/viewport/user-agent-based difficulty, bonuses, unlocks
- [ ] No hidden autoplay, no environment detection, no "looks good in demo" path differing from real player path

## N. Visual ambition (heavily weighted — beyond flash template)
- [ ] Visuals original, not primitive shapes/generic flat rectangles/box gradient colored enemies
- [ ] Distinctive consistent art identity across screens/menus/HUD
- [ ] Procedural detail: lighting, fog, texture, particles, composition, palette, dressing — not empty room with rectangle player
- [ ] Visual identity holds across whole run, not just title screen
- [ ] Rich visuals do NOT hurt readability: actions/hazards/player obvious
- [ ] Clearly beyond simple box gradient enemies / flash-game approach — pushes limits, or deliberate expressive polished minimalism with exquisite timing/feedback (document intent in README)

## O. Long-session execution & iteration (new, heavily weighted)
- [ ] Built functional prototype quickly, then tested via actual interaction
- [ ] Identified weaknesses in mechanics/usability/visuals/performance
- [ ] Iterated substantially rather than stopping at first functional version
- [ ] Added polish, feedback, content, presentation improvements after first prototype
- [ ] Verified final build launches reliably and understandable to new player
- [ ] Can describe strongest feature and biggest risk + director statement

## P. Honesty gate
- [ ] No placeholder screens, under construction, dead ends, broken buttons
- [ ] Everything claimed in README actually works reachable
- [ ] No telemetry, analytics, hidden reporting, embedded quality score
- [ ] No environment sniffing


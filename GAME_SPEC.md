# Game Creation Brief — One-Shot Game Development Agent

This is the **shared, open-ended brief** handed to both game-development agents in arena.ai battles.
Both agents receive identical bytes. They are treated as **developers, not players**.

There is no pre-existing game to play for score. The agent must **create** a complete, original, compelling game.
The benchmark evaluates the game's quality and the agent's development process — code quality, creative originality,
long-session execution, design judgment, visual ambition, and human-perceived quality.

> **For evaluators / human jury:** Judge what the agent *actually created*. Do not penalize dimensionality, genre,
> or style merely for being different. A simple but deliberate, expressive, highly polished game beats a technically
> complex but incoherent one. Look for authorship, intentionality, and sustained quality over a long session.

---

## 1. Product Goal

A complete, immediately understandable, playable game that feels authored and intentional — not necessarily commercially large,
but clearly more sophisticated than a basic demonstration or template.

- Fast to understand, strong first impression
- Playable loop with clear feedback
- Original idea or memorable twist on familiar idea
- Coherent visual and interactive identity
- Portfolio-grade polish in at least one dimension (visual, mechanical, narrative, technical)
- Fully self-contained — no external services, auth, backend

## 2. Core Freedoms (Unlimited)

**Do NOT restrict:**

- Dimensionality or camera (2D, 2.5D, 3D, first-person, top-down, side, isometric, text, etc.)
- Genre (action, puzzle, strategy, simulation, narrative, experimental, etc.)
- Rendering style (Canvas, WebGL, WebGPU, Three.js, CSS, SVG, ASCII, etc.)
- Engine/framework (vanilla JS fine, or light framework bundled as static build)
- Input method (keyboard, mouse, touch, gamepad, etc.)
- Narrative structure (linear, branching, emergent, environmental, none)
- Level structure (hand-authored, procedural, single-room, open world slice)
- Visual realism or abstraction
- Degree of experimentation

Agent chooses approach appropriate to brief and environment. Constraints focus on fairness (time, compute, permitted assets,
deliverables) not on forcing same kind of game.

## 3. What Agent Must Decide (Authorship)

- Game concept and creative direction — what is the emotional core?
- Core loop and mechanics — what does player do, why is it interesting second, tenth time?
- Visual style and presentation — palette, lighting, composition, animation, particle, dressing
- Audio and feedback — attack/hit/reward sounds, music, visual-only fallback if needed
- World/level/encounter design — pacing, difficulty curve, variety, surprise
- Technical implementation — state management, input, loop, collision, generation, audio, particles, persistence
- UI and onboarding — start, how-to-play, pause, game-over/victory, high-score or progress, legibility
- Performance, stability, polish — delta-time, pooling, capping, DPR handling, resize, visibility pause

## 4. Minimal Kernel (for comparability, not creativity limit)

Every submission must satisfy Kernel to be comparable on reliability, regardless of creative direction:

- **Launches reliably:** fresh load starts, no blank screen, no infinite spinner, no console error loop
- **Playable immediately:** new player can understand objective, move/interact, achieve something, and restart without manual
- **Input works:** primary actions respond, no page scroll on game keys, touch does not trigger scroll/zoom/navigation, buttons show press states
- **Core loop complete:** start → gameplay → reward/progression → end condition (win or lose) → restart without refresh
- **States isolated:** pause fully freezes simulation/timers/particles/logic; resume continues; no input leaks into menus
- **Persistence (if applicable):** if game has progress/high-score, it survives reload, sorted, handles corrupt storage safely, reset behind confirmation — or explicitly has no persistence by design (document it)
- **Robustness:** instant restart fully resets state; resize/orientation mid-game don't break layout or hide info; tab blur/focus safe; mashing inputs doesn't corrupt; audio failure doesn't block gameplay
- **Self-contained:** runs offline from static folder or single HTML via trivial `python -m http.server`; no backend, no network calls, no auth, no build step player must run; only original or appropriately-licensed assets with local fallback
- **No forbidden behaviors:** no backend, telemetry, analytics, hidden reporting, embedded meta-quality score, environment sniffing (behaves identically desktop/mobile/portrait/landscape/headless), no placeholder screens/dead ends/broken buttons, no hidden autoplay that fakes quality

If Kernel fails, hard ceilings apply (see rubric). Shell beyond Kernel is unlimited creativity.

## 5. Scope Guidance (not restriction)

Prioritize a **polished vertical slice** with excellent feel and reliable functionality over oversized feature list.

Suggested build order to survive long session:

1. **Core loop first:** movement/interaction, one challenge, health/fail, restart, title — get 10-second loop feeling right
2. **Verify core** against self-QA before adding breadth
3. **Layer systems:** second mechanic, progression, score, persistence
4. **World structure:** levels/rooms/encounters, branching, variety, boss or climax
5. **Polish & visual identity:** particles, shake, hit-stop, transitions, audio, camera, lighting/fog/texture/dressing/palette — push beyond simple box gradient enemies
6. **Robustness & accessibility:** pause freeze, persistence + corrupt storage, reduced-motion, resize, mobile, performance, seeds if procedural
7. **Final self-QA pass:** fix broken, cut breadth never reliability — tight complete beats broad broken

Save time for iteration: prototype quickly, test via actual interaction, identify weaknesses, debug, rethink, improve — reward is for recognizing weak early approach and revising, not merely generating large code.

## 6. Visual and Interactive Ambition (weighted heavily)

Evaluators and human jury reward **originality and visual richness/complexity**, not bare effect counts and not primitive shapes.
A build of flat-colored rectangles, empty rooms, generic UI — even if functional — scores low on presentation.

Invest real effort in distinctive, original art identity and sophisticated procedural detail:
- Layered light and fog, textured surfaces, particle systems, subtle camera composition, cohesive palettes, animated dressing
- Squash-and-stretch, trails, afterimages, sparks/dust, collection arcs, floating feedback, celebration, entrance/defeat, smooth transitions, directional look-ahead
- Configurable + reduced-motion mode

Push toward near-commercial polish across entire run — not just hero title screen. Keep readability high: ambition must never hurt ability to read actions/hazards/player at a glance.

**Simple ≠ bad:** Visually simple game not penalized merely for being simple if simplicity is deliberate, expressive, highly polished. Technical complexity should not receive automatic credit if it doesn't improve player experience.

## 7. Audio (if applicable)

Menu/game/reward/boss sounds, ambient loop, intensity changes, stingers — or convincing visual-only feedback with modular audio integration.
Master toggle; safe fallback if autoplay blocked; user-initiated activation from start screen. Audio failure must never block gameplay.

## 8. Performance

Target 60 FPS desktop + mobile. Delta-time, pool particles/floating text/projectiles/transients, cap counts, avoid layout thrash, minimize re-renders, Canvas or suitable layer for gameplay, separate UI from high-frequency rendering, handle DPR, reduce resolution on low-power devices, pause rendering/sim when hidden, clean resize/orientation, lightweight debug indicator for development.

## 9. Architecture

Clear separation: game state, input, simulation/update loop, rendering, collision/AI if needed, generation, audio, particles, UI screens, persistence, config/balance. Centralize tunables (speed, cooldowns, durations, health/damage, reward rates, multipliers). No scattered magic numbers.

## 10. Responsive Layout

Desktop widescreen, laptop, tablet, mobile portrait and landscape. Preserve aspect ratio without hiding important information; scale playfield; controls within thumb reach; avoid safe areas/notches; support mouse+touch; visible focus/pressed states; legible small typography.

## 11. Accessibility

High-contrast UI; keyboard menu navigation; visible focus states; reduced-motion; color not only signal; text labels for icons; adjustable text size if feasible; no essential info conveyed solely through animation.

## 12. Balancing

First 10 seconds: immediate movement/interaction, clear challenge, satisfying feedback, visible reaction, reward or transition shortly after. First run understandable without manual. Difficulty rises gradually via varied combinations, more complex patterns, narrower timing, modifiers, hazards, tougher decisions. No unfair instant kills, unreadable attacks, excessive crowding, or grind.

## 13. Deliverables

- Complete runnable game (static build) in workspace root
- Short README.md (run instructions, controls, what was intentionally cut, how to view seed/debug if procedural, engine/framework used)
- One-paragraph summary: build's strongest feature and current biggest risk + director statement of creative intent

## 14. Definition of Done

Feels like cohesive authored game, not stack of mechanics or template. New player can load, understand objective, interact, achieve something, and restart after failure without confusion. Runs offline, self-contained, desktop+mobile, honest (everything claimed exists, works, reachable). Prioritize polished vertical slice with excellent feel and reliable functionality over oversized feature list.

## 15. Testing Checklist (source for automated checks + jury verification)

Fresh-load start · first interact works immediately · keyboard without page scroll · touch on narrow screens · pause fully freezes · restart resets state · game-over/victory reachable with accurate stats (if applicable) · high scores/progress persist after reload (if applicable) · corrupt storage safe · resize/orientation safe · no permanently stuck entities · fair/readable collision/interaction ranges · smooth with many entities/particles · reduced-motion works · audio failure doesn't block · launches reliably across desktop/mobile/portrait/landscape · no telemetry/embedded quality score · no environment sniffing

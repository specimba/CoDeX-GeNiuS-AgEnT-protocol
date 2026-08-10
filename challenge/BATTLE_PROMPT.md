# One-Shot Game Development Agent Creation Benchmark — BATTLE PROMPT

> **This is your one and only task, delivered in one shot.** You are a **game developer, not a player**. Conceive, implement, polish, and present a complete, original, compelling game in a single sustained development session. You have unlimited creativity, production freedom, graphical freedom, and time within fair compute budget.

> **You are one of two contestants.** Both receive this exact prompt (identical bytes). Comparison is fair by construction: same instructions, same time budget in a given battle, isolated workspaces. In arena.ai production, two unknown models battle under proper benchmark conditions.

---

## 0. Your Role

You are senior gameplay engineer, interaction designer, frontend performance specialist, **creative director, and reliable software engineer** shipping a vertical slice of a commercial-quality game.

This benchmark tests:
1. Code quality — structured, maintainable, robust, technically sound
2. Creative originality — distinctive idea, memorable mechanics, intentional design vs generic template
3. Long-session execution — plan, build, debug, iterate, polish across many steps without losing coherence
4. Design judgment — tradeoffs between scope, ambition, usability, quality
5. Visual and interactive ambition — visually convincing and coherent, pushing beyond simple box gradient colored enemies / flash-game presentation
6. Human-perceived quality — engaging, intentional, aesthetically coherent, memorable vs competing entries

You are **NOT** an evaluator of another agent's game, nor a player maximizing score in a pre-existing game. Any gameplay after development is only to verify your created game functions and communicates intended experience.

The primary question: **Can you independently create a complete, creative, technically competent, and visually compelling game that human judges would choose over competing entries?**

## 1. Your Assignment

Create a **complete, original, compelling browser game** — your concept, your direction. It may be 2D, 2.5D, 3D, browser experience, simulation, narrative, strategy, experimental interactive work, or other format if that choice improves result.

**Do NOT restrict yourself to 2D.** Do not restrict genre, rendering style, engine, input, narrative, level structure, visual realism, procedural vs authored. Choose what wins human jury choice.

Fully self-contained: no backend, no external services, no authentication, no build step a player must run. It must run by opening the page or trivial `python -m http.server`.

## 2. How Your Work Will Be Used

Your build will be reviewed by **human judges** comparing finished games, not by automated score maximizers. Automated checks verify launch, runs, responds to input, satisfies technical requirements. Judges review finished result for originality, polish, and memorability.

Consequences:
- A feature you list but that breaks or unreachable gives you nothing. If player can't reach it or it doesn't work, it doesn't exist.
- First 10 seconds matter, but so do minutes 10–60. Front-loading title screen will not carry thin repetitive broken game.
- Robust, tight, honest slice beats sprawling buggy feature list. Small game that works and feels great beats big game that mostly works sometimes.
- Visual originality and complexity are heavily weighted. Generic flat rectangles, empty rooms, simplistic enemies, unpolished flash presentation — even if functional — scores low on visual ambition.
- Code quality is visible to jury via stability and structure: pooled systems, centralized config, no console error loop, performance under load.
- Long-session quality includes debugging, rethinking, improving — not merely generating large code. Reward revising weak early approach.

## 3. Open-Ended Specification (Authoritative but Freedom-Preserving)

### 3.1 Product Goal (Open)
Complete, immediately understandable, playable game that feels authored and intentional — technically reliable, creatively distinctive, strong enough to impress human jury. Not necessarily commercially large, but clearly more sophisticated than basic demonstration.

### 3.2 Creative Freedom (Unlimited)
- Dimensionality: 2D, 2.5D, 3D, first-person, top-down, side, isometric, text, etc. — **you choose**
- Genre: action, puzzle, strategy, simulation, narrative, experimental — you choose
- Rendering: Canvas, WebGL, WebGPU, Three.js, CSS, SVG, ASCII — you choose (reference_arch/ shows graceful fallback WebGPU→WebGL→Canvas2D as inspiration, not mandate)
- Engine: vanilla JS fine, or light framework bundled as static build
- Input: keyboard, mouse, touch, gamepad
- Visual: realism, abstraction, minimalism, maximalism — deliberate and polished, not simple by accident
- Structure: hand-authored, procedural, single-room, open-world slice

Constraints focus on fairness — time, compute, permitted assets, deliverables — not forcing same kind of game.

### 3.3 Kernel (Must for Comparability)
Every submission must satisfy Kernel to be comparable on reliability:

- Launches reliably: fresh load starts, no blank, no infinite spinner, no error loop
- Playable immediately: new player understands objective, interacts, achieves something, restarts without manual
- Input works: primary actions respond, no page scroll on game keys, touch no scroll/zoom, buttons press states
- Loop complete: start → gameplay → reward/progression → end condition → restart without refresh
- States isolated: pause fully freezes sim/timers/particles/logic; resume continues; no input leak
- Robustness: instant restart fully resets; resize/orientation mid-game safe; tab blur/focus safe; mashing inputs safe; audio failure doesn't block; corrupt storage safe if persistence used
- Self-contained: offline static folder or single HTML; no backend/network/auth; only original/licensed assets with local fallback
- No forbidden: backend, telemetry, analytics, hidden reporting, embedded meta-quality score, environment sniffing (identical desktop/mobile/portrait/landscape/headless), placeholder screens/dead ends/broken buttons, hidden autoplay faking quality

If Kernel fails, hard ceilings apply in evaluation.

### 3.4 Creativity & Authorship (Shell — Unlimited, Rewarded)
- Concept: what is emotional core? What memory will player have?
- Mechanics: understandable, enjoyable, depth/variation over time, emergent stories
- Visual: coherent direction, ambitious execution beyond box gradients, layered light/fog/texture/particle/camera/palette/dressing, readability preserved
- Audio: fitting sounds, music integrates with intensity, master toggle, visual-only fallback if needed
- World: pacing, curve, variety, surprise — one mechanic/room/narrative beat not in spec that makes player say "hadn't seen that", learnable <1min, sustained
- Polish: juice (shake, hit-stop, flash, squash-stretch, trails, afterimages, sparks, bursts, floating feedback, celebration), transitions, onboarding
- Performance: delta-time, pooling, capping, DPR handling, pause when hidden, debug indicator

Ship 1-paragraph DIRECTOR_STATEMENT in README: original take, deliberate choices, emotional core. Jury reads after independent scoring to understand intent.

### 3.5 Visual & Interactive Ambition (Weighted Heavily — Read Carefully)

Human jury rewards originality and visual richness/complexity, not adherence to any single style. A generic game of flat-colored rectangles, empty rooms, simplistic enemies, generic UI — even if functional — will be scored visually weak.

Invest real effort in distinctive art identity and sophisticated detail: layered lighting, fog, textured surfaces, particle systems, camera composition, cohesive palettes, animated dressing, confident layout. Push toward near-commercial polish across entire run.

Simple ≠ bad: visually simple game not penalized merely for being simple if simplicity is deliberate, expressive, highly polished (e.g., precise minimalism with exquisite timing). Technical complexity not automatically credited if doesn't improve experience.

**Anti-pattern to avoid:** simple box gradient colored enemies, untextured backgrounds, no feedback, no lighting, no particle, no composition — this is explicitly low on visual ambition and long-session execution.

Three divergent starters in `reference_arch/` are inspiration only: gothic painterly, ink-wash, brutalist concrete. Cloning verbatim caps originality low. Transforming with your own voice scores high.

### 3.6 Technical Deliverables

Complete runnable game; clear project structure; start/pause/game-over/victory/restart flows; responsive desktop+touch controls; persistence if applicable; progression/levels; feedback systems (particles, shake, hit-stop, transitions); responsive UI and accessibility (high-contrast, keyboard nav, focus states, reduced-motion); no broken buttons/dead ends/placeholders; no backend dependency.

### 3.7 Definition of Done

Feels like cohesive authored game, not stack of mechanics or template. New player can load, understand objective, interact, achieve something, and restart after failure without confusion. Prioritize polished vertical slice with excellent feel and reliable functionality over oversized feature list. Runs offline, self-contained, desktop+mobile, honest.

---

## 4. Engineering and Build Standards

- Self-contained: static folder or single HTML served over HTTP. Trivial `python -m http.server` must be enough. No compilation step required for player.
- Vanilla or minimal stack is fine (plain JS/Canvas/WebGL/Three.js, or light framework bundled into static build). If you use framework, ship runnable build, not just source.
- Determinism if procedural: seeded, reproducible, useful for testing
- No backend, no network calls, no auth
- Legal: only original or appropriately-licensed assets, with local fallbacks
- Ship tiny `README.md` (run instructions, controls, engine/framework used, what intentionally cut, how to view seed/debug if applicable, director statement of creative intent)
- Keep repo clean: game code plus minimal README. No leftover scaffolding, placeholder TODOs in reachable screens, or dead code that shows.

## 5. Suggested Build Sequence (One-Shot, Long Session)

Work in this order so you end with working game even if time low:

1. **Core loop first:** movement/interaction, one challenge, fail/restart, title — get 10-second loop *feeling* right
2. **Verify core** against self-QA checklist (§7) before adding breadth
3. **Layer systems:** second mechanic, progression, score, persistence
4. **World structure:** levels/rooms/encounters, branching, variety, climax
5. **Polish & visual identity:** particles, shake, hit-stop, transitions, audio, camera, lighting/fog/texture/dressing/palette — push beyond box gradients
6. **Robustness & accessibility:** pause freeze, persistence + corrupt storage, reduced-motion, resize, mobile, performance, seeds
7. **Final self-QA pass** (§7). Fix broken. If time short, cut breadth never reliability — tight complete beats broad broken

Expected workflow for high long-session score: interpret brief → plan scope/architecture/presentation → build functional prototype quickly → test via actual interaction → identify weaknesses in mechanics/usability/visuals/performance → iterate substantially → add polish/feedback/content → verify final build launches reliably and understandable → deliver.

Rewarded for revising weak early approach. Not merely generating large amount of code.

## 6. Explicit Anti-Behaviors

Do NOT:
- Add backend, external service, analytics, telemetry, network calls, hidden reporting
- Embed quality/benchmark "score", self-rating, hidden eval that rates own game against external standard. Internal run score/high-score table fine; meta quality score not.
- Read or reference any benchmark/evaluation files (none in your workspace)
- Reverse-engineer or hunt for evaluation criteria
- Ship placeholder screens, "under construction" rooms, dead ends, unimplemented buttons
- Over-scope: enormous feature list at expense of working polished game
- Prioritize spectacle over readability or reliability
- Fake anything: hidden autoplay that makes demo look better, behaving differently per environment — must be honest, identical desktop/mobile/portrait/landscape/headless. Evaluators re-run key scenarios across environments and flag divergence.
- Ship simple box gradient colored enemies with no dressing as final — visual ambition explicitly weighted, this scores low

## 7. Self-QA Checklist (run before deliver)

Launch & boot:
- [ ] Fresh load starts; no blank screen, no unhandled error loop, no infinite spinner
- [ ] Boot/loading resolves; title screen renders (title, subtitle, Start, How to Play, High Scores/progress, audio toggle, cohesive theme)

Core controls desktop:
- [ ] Primary movement/interaction works; no page scroll on game keys
- [ ] Dodge/special action if applicable has feedback and fair window
- [ ] Input buffering: quick press while busy not silently dropped
- [ ] Frame-rate independent

Mobile/touch:
- [ ] Virtual controls work if applicable; buttons large thumb-reachable; no accidental scroll/zoom/selection/navigation; press states

Game feel:
- [ ] First interaction works within ~10s
- [ ] Actions have wind-up → active → recovery if applicable; hit-stop/feedback; distinct success/failure
- [ ] Special action works and resource-limited if applicable

Loop:
- [ ] Encounters/levels behave distinctly; has climax/challenge with readable patterns
- [ ] No permanently stuck states, no impossible placements

Progression:
- [ ] Run contains start + gameplay + reward/progression + end condition; branches reachable if applicable
- [ ] Seeded if procedural: two different seeds give different both-reachable runs; clear exits

Rewards & polish:
- [ ] Rewards/collectibles have visible impact; feedback quality; score/progress understandable

Persistence:
- [ ] High scores/progress save and survive reload if applicable, sorted, corrupt storage doesn't crash, reset behind confirmation

States & transitions:
- [ ] Start → gameplay → reward → end → restart all work
- [ ] Pause fully freezes sim/timers/particles/logic; resume continues; no input leak

Robustness & edge:
- [ ] Instant restart fully resets state; resize/orientation mid-game safe; tab blur/focus safe; mashing inputs safe

Accessibility:
- [ ] Keyboard navigates menus; visible focus; reduced-motion reduces shake/flash/particles; info not color-only; text labels; legible small sizes; safe areas respected

Performance:
- [ ] Stable frame rate with many entities/particles; particles pooled/capped; rendering pauses when hidden; debug indicator available off by default

Audio:
- [ ] Sound toggle works; audio failure doesn't block; sounds present or strong visual-only fallback

Environment consistency:
- [ ] Same rules desktop/mobile/portrait/landscape/headless; no device/viewport/user-agent bonuses

Visual ambition (weighted heavily):
- [ ] Visuals original, not primitive shapes/flat rectangles/generic UI; distinctive consistent art identity across screens
- [ ] Procedural detail exists (lighting, fog, texture, particles, dressing, composition, palette); holds across whole run, not just title
- [ ] Rich visuals don't hurt readability: actions/hazards/player obvious
- [ ] Clearly beyond simple box gradient colored enemies / flash-game approach

Honesty gate:
- [ ] No placeholder screens, dead ends, broken buttons; everything claimed in README works reachable
- [ ] No telemetry, analytics, hidden reporting, embedded quality score

## 8. Deliverables

1. Complete runnable game (static build) in workspace root
2. Short README.md (run instructions, controls, engine/framework used, what intentionally cut, seed/debug view if applicable, director statement)
3. One-paragraph summary: build's strongest feature and current biggest risk + creative intent

## 9. Definition of Done (final gate)

Before you stop, you must be able to say truthfully:
- New player can load page, understand objective, interact, achieve something, and restart after failure — without confusion
- Game complete (start → progression → end → restart) and has no broken buttons, dead ends, placeholder screens
- Runs offline, self-contained, desktop+mobile
- Honest: everything you claim exists, works, reachable
- Feels authored and intentional, not template — technically reliable, creatively distinctive, visually ambitious enough to impress human jury vs competing entries

Ship best complete game you can. Choose format that wins — 2D, 3D, experimental — unlimited freedom. Good luck.

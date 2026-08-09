# AGENT CHALLENGE BRIEF — Build "Ashen Descent"

> **This is your one and only task.** Build a complete, polished, playable browser game
> from the specification below. You have one build session. Make it count.
>
> **Both contestants receive this exact brief.** Comparison is fair by construction.

---

## 1. Your role

You are a senior gameplay engineer, interaction designer, and frontend performance
specialist shipping a vertical slice of a commercial‑quality game.

## 2. Your assignment

Build **"Ashen Descent"**, a dungeon‑crawler roguelike for the browser — inspired by the
tension, readability, and atmosphere of *Dead Cells* and *Darkest Dungeon*, but an
**original work** with its own visual identity, mechanics, assets, and terminology. Fully
self‑contained: no backend, no external services, no authentication, no build step that a
player must run. It must run by opening the page.

## 3. How your work will be used (be honest with yourself about this)

Your build will be played by **independent playtesters who never read your code**. They
will play it for **30–60+ minutes** across multiple runs and multiple seeds, on desktop
and mobile, testing restart, pause, persistence, performance, accessibility, and whether
the whole loop holds together. They will score **only what a player experiences** — not
your code structure, not your documentation, not your feature list.

Consequences you should internalize:

- **A feature you list but that breaks or is unreachable gives you nothing.** If a player
  can't reach it or it doesn't work, it doesn't exist.
- **The first 10 seconds matter, but so do minutes 10–60.** Front‑loading all your effort
  into the title and room 1 will not carry a thin, repetitive, or broken game through a
  long session.
- **A robust, tight, honest slice beats a sprawling, buggy feature list.** A small game
  that *works and feels good* will beat a big game that *mostly works sometimes*.
- **You will never see the scoring formula, and it is not inside your build.** Do not try
  to reverse‑engineer or embed a "score." Build the best *player experience* you can.

## 4. The complete specification (authoritative)

The following is the specification you must implement. It is reproduced verbatim from
`GAME_SPEC.md`, which is the canonical source of truth bundled with this brief.

---

### 4.1 Product goal

A complete browser game that is immediately fun within the first 10 seconds: fast,
responsive action controls; tactical turn‑based decision beats; short, replayable
roguelike runs; strong audiovisual feedback; clear progression and risk/reward choices;
excellent desktop and mobile usability; portfolio‑grade polish. No external services,
authentication, or backend.

### 4.2 Core gameplay concept

The player controls a lone dungeon delver descending through procedurally assembled rooms.
Combat alternates real‑time movement with tactical **"beats"**:

- Move, dodge, attack, and interact in real time.
- When the player attacks, dodges, uses an ability, or enters a dangerous enemy range, the
  game briefly enters a **tactical resolution phase**.
- During this phase, **enemy intent indicators** become visible and the player makes a
  deliberate decision.
- Actions resolve quickly enough to preserve momentum — **action combat with readable
  tactical pauses**, not a slow turn‑based RPG.
- The first encounter begins almost immediately after starting a run. Move → attack →
  defeat an enemy → collect a reward → understand the core loop in **under one minute**.

### 4.3 Core loop

1. Start a run from the title screen.
2. Enter a compact dungeon room.
3. Move with keyboard or touch.
4. Fight enemies with basic attacks, dodges, and ≥1 special ability.
5. Read enemy telegraphs and tactical intent markers.
6. Collect coins, relics, healing items, and temporary buffs.
7. Choose between branching room paths.
8. Encounter combat / elite / treasure / healing / event rooms.
9. Defeat a miniboss or progress through multiple floors.
10. Die or complete the run.
11. Compute score; record in a local high‑score table.
12. Restart instantly without refreshing the page.

Reward both speed **and** careful play. Never make "wait and attack" the optimal strategy.

### 4.4 Player controls

**Desktop:** `WASD`/arrows move · `Space` dodge/dash · `J`/LMB basic attack · `K`/RMB
special ability · `E` interact/open/reward select · `P`/`Esc` pause · number keys for
tactical options if useful. Centralize input so it is configurable; prevent browser
defaults where appropriate.

**Mobile/touch:** left virtual joystick or drag pad; large right‑side attack/dodge/ability
buttons; optional tap‑to‑interact; thumb‑sized buttons; visual press states and haptic
feedback where supported; no accidental scroll/zoom/text‑selection/navigation.

**Input quality:** input buffering for attacks/dodges; a short dodge grace window;
frame‑rate‑independent controls; clear feedback when an action is unavailable;
focus‑safe behavior when the tab loses focus; auto‑pause on mobile visibility changes.

### 4.5 Player combat

- **Basic attack:** short wind‑up, readable hitbox, recovery, directional targeting,
  hit‑stop on impact, proportional screen shake, damage numbers, distinct hit/miss/crit.
- **Dodge:** brief invulnerability frames, directional, cooldown/stamina cost, afterimage/
  motion trail, satisfying sound/particles, a fair timing window.
- **Special ability** (≥1): charged arc, short‑range shockwave, throwable spectral blade,
  time‑slow pulse, or defensive parry — limited by cooldown/energy/tactical resource.
- **Tactical resolution:** intent icons/colors/projected attack zones; world briefly
  slowed/paused; choose attack/dodge/reposition/defend/ability; predictable resolution
  order; deterministic, learnable enemy behavior; no excessive menus or long animations.

### 4.6 Enemies (implement these archetypes)

1. **Gravebound** — basic melee; slow approach; clear wind‑up attack.
2. **Cinder Wisp** — ranged; delayed projectiles; encourages movement and prioritization.
3. **Hook Hound** — fast; charges after a visible telegraph; punishes standing still.
4. **Mourning Knight** — armored elite; blocks frontal attacks; requires dodging,
   repositioning, or punishing a committed strike.
5. **Floor Boss** — multi‑phase; ≥3 recognizable attack patterns; strong telegraphs; a
   clear vulnerability window; dramatic entrance and defeat.

Each enemy needs idle/move/attack/hit/defeat states, health and damage values, collision
and attack ranges, intent indicators, audio and visual feedback, and behavior that scales
with dungeon depth.

### 4.7 Dungeon generation

Deterministic seeded procedural generation. Each run contains: a start room; several
combat rooms; ≥1 reward/treasure room; optional healing/event rooms; a miniboss/boss
room; branching path choices. Guarantee reachable layouts, no impossible enemy
placements, clear exits, reasonable combat space, predictable progression, balanced
risk/reward. Display the seed optionally on the game‑over screen.

### 4.8 Rewards & progression

Run‑based: coins (spent in‑run), temporary relics/blessings, weapon modifiers, passive
stat upgrades, healing opportunities, risk/reward choices. Example relics: +damage after a
perfect dodge; heal after elite kill; bonus score for combos; attack‑speed below half
health; secondary projectile; coins → temporary armor. Give rewards clear descriptions and
visible impact. Avoid heavy inventory management.

### 4.9 Score system

Reward: enemy defeats; elite/boss kills; floor progression; combo streaks; fast room
clears; perfect dodges; no‑damage encounters; coins; relic rarity; remaining health.
Include multipliers for skilled play, but keep it understandable. Display current score,
combo/momentum meter, best score, run duration, floor number, and optionally a style/rank.

### 4.10 High‑score table

Local browser storage, top 5–10 runs (score, name/default, floor reached, date), sorted
descending; handle corrupt/unavailable storage safely; reset behind confirmation; visible
from start and game‑over screens. No server.

### 4.11 Game states

Boot/loading · start screen · how‑to‑play overlay · active gameplay · tactical
resolution · pause · reward selection · floor transition · game over · victory ·
high‑score display. Isolate input per state (no gameplay input leaking into menus).
Pause must fully freeze simulation, timers, particles, enemy behavior, and
logic‑affecting animations.

- **Start screen:** title, subtitle, Start Run, How to Play, High Scores, audio toggle,
  cohesive visual theme.
- **Pause:** Resume, Restart Run, Controls summary, audio toggle, Return to Title.
- **Game over:** cause of defeat, final score, floor reached, enemies defeated, run
  duration, best‑score comparison, Instant Restart, Return to Title.

### 4.12 Visual direction

Dark, painterly gothic dungeon atmosphere; warm ember‑orange highlights against deep
charcoal/violet/desaturated blue; high contrast between gameplay entities and background;
stylized readable silhouettes; subtle paper/stone/smoke/parchment texture; strong
lighting, fog, vignette, layered depth; no combat clutter. **Readability over decoration**
— attacks, hazards, player position, available actions, and rewards must be obvious at a
glance. Use original CSS/Canvas/SVG/procedural visuals (no copied game assets). If any
external asset is used, license it appropriately and include a clear local fallback.

### 4.13 Animation & juice

Screen shake; hit‑stop (a few frames); damage flash/tint; enemy squash‑and‑stretch;
weapon trails; dash afterimages; sparks/dust particles; coin bursts and collection arcs;
floating damage numbers; combo popups; room‑clear celebration; reward reveal; boss
entrance/defeat; smooth room/floor transitions; camera easing and subtle directional
look‑ahead. All configurable, with a **reduced‑motion mode** that disables/reduces shake,
flashes, and excessive particles. Keep feedback performant.

### 4.14 Audio

Menu confirmations; attack/hit/dodge/enemy/reward/boss sounds; ambient dungeon loop;
combat intensity changes; victory/defeat stingers. Master audio toggle; separate
music/effects if practical; safe fallback if audio can't autoplay; user‑initiated audio
activation from the start screen. If audio assets are unavailable, build a convincing
**visual‑only** feedback system and keep audio integration modular. Audio failure must
never block gameplay.

### 4.15 Performance

Target stable 60 FPS on modern desktop and mobile browsers. Delta‑time simulation; pool
particles, floating text, projectiles, and transient effects; cap particle counts; avoid
layout thrashing; minimize re‑renders; use Canvas or a suitable layer for gameplay; keep
UI separate from high‑frequency game rendering; handle device pixel ratio responsibly;
reduce rendering resolution on low‑power devices; pause rendering/simulation when the page
is hidden; handle resize and orientation cleanly. Include a lightweight debug/performance
indicator for development.

### 4.16 Architecture

Separate cleanly: game state, input handling, simulation/update loop, rendering,
collision detection, enemy AI, procedural generation, audio, particle effects, UI screens,
persistence, configuration/balancing. Centralize tunable values (player speed, attack
cooldown, dodge duration, i‑frame duration, enemy health/damage, room count, reward rates,
score multipliers). Do not scatter magic numbers.

### 4.17 Responsive layout

Support desktop widescreen, laptop, tablet, mobile portrait, and mobile landscape.
Preserve gameplay aspect ratio without hiding important information; scale the playfield
intelligently; keep controls within thumb reach; avoid browser safe areas/device notches;
support mouse and touch; ensure visible focus and pressed states; keep typography legible
at small sizes.

### 4.18 Accessibility

High‑contrast UI; keyboard menu navigation; visible focus states; reduced‑motion mode;
color choices that are not the only information signal; clear text labels for icons where
necessary; adjustable text size if feasible; no essential information conveyed solely
through animation.

### 4.19 Balancing goals

First 10 seconds deliver: immediate movement; a clear enemy; a satisfying attack; a
visible hit reaction; a meaningful dodge; a reward or room transition shortly after. The
first run should be understandable without reading a manual. Difficulty rises gradually:
more varied enemy combinations; more complex patterns; narrower timing; elite modifiers;
environmental hazards; tougher reward decisions. No unfair instant kills, unreadable
attacks, excessive crowding, or grind.

### 4.20 Technical deliverables

A complete runnable game; clear project structure; start/pause/game‑over/victory/restart
flows; responsive desktop and touch controls; local high‑score persistence; procedural
dungeon progression; ≥4 standard enemy types + 1 boss; ≥1 special ability and several
reward effects; particle effects, screen shake, hit‑stop, transitions, and feedback
systems; responsive UI and accessibility options; no broken buttons, dead ends, placeholder
screens, or missing core interactions; no backend dependency.

### 4.21 Definition of done

The game must feel like a cohesive game, not a stack of mechanics. A new player should be
able to load the page, understand the immediate objective, move, attack, dodge, defeat an
enemy, collect a reward, and restart after defeat without confusion. Prioritize a polished
vertical slice with excellent feel and reliable functionality over an oversized feature
list.

---

## 5. Engineering and build standards

- **Self‑contained:** the game must run offline from a static folder or a single HTML file
  served over HTTP. A trivial `python -m http.server` (or opening the page) must be all a
  player needs. No compilation step required.
- **Vanilla or minimal stack is fine** (plain JS/Canvas, or a light framework you can
  bundle into a static build). If you use a framework, ship the runnable build, not just
  source.
- **Determinism:** generation is seeded; the seed is reproducible (useful for testing).
- **No backend, no network calls, no auth.**
- **Legal:** only original or appropriately‑licensed assets, with local fallbacks.
- **Ship a tiny `README.md`** that says (a) how to run it, (b) the controls, (c) what was
  intentionally cut for time if anything, (d) how to view the seed / enable debug mode.
- **Keep the repo clean:** game code plus a minimal README. No leftover scaffolding,
  placeholder TODOs in reachable screens, or dead code that shows.

## 6. Build sequence (suggested, one‑shot)

Work in this order so you end with a working game even if you run low on time:

1. **Core loop first:** movement, attack, one enemy, dodge, health, death, restart, title.
   Get the 10‑second loop *feeling* right.
2. **Verify the core** against the self‑QA checklist (Section 8) before adding breadth.
3. **Layer systems:** second/third enemy types, special ability, relics, coins, score,
   high scores.
4. **Dungeon structure:** room generation, branching paths, room types, boss floor.
5. **Polish:** particles, shake, hit‑stop, transitions, audio, camera.
6. **Robustness & accessibility:** pause freeze, persistence + corrupt storage, reduced
   motion, resize, mobile, performance pass, seeds.
7. **Final self‑QA pass** (Section 8). Fix what's broken. If time is short, cut breadth,
   never reliability — a tight game beats a broad broken one.

## 7. Explicit anti‑behaviors

Do **NOT**:

- Add a backend, external service, analytics, telemetry, network calls, or hidden
  reporting of any kind.
- Embed any quality/benchmark "score", self‑rating, hidden eval, or anything that rates
  your own game against an external standard. Your game's *internal* run score and
  high‑score table are fine and required; a meta "quality score" is not.
- Read or reference any benchmark/evaluation files (there are none in your workspace).
- Reverse‑engineer or hunt for the evaluation criteria.
- Ship placeholder screens, "under construction" rooms, dead ends, or unimplemented
  buttons that a player can hit.
- Over‑scope: do not try to implement an enormous feature list at the expense of a working,
  polished game. A small, complete, excellent game wins.
- Prioritize spectacle over readability or over reliability.
- Fake anything: no hidden autoplay that makes a demo look better; the game must be honest.

## 8. Self‑QA checklist (you run this before you deliver)

Go through every item on a fresh load. Fix any failure before delivery. If you cannot fix
something, note it honestly in your README (the player experience still counts against you,
so fix what you can).

- [ ] Fresh load starts the game; no blank screen, no console error loop.
- [ ] Title screen renders with Start Run / How to Play / High Scores / audio toggle.
- [ ] First attack works immediately in the first encounter (within ~10 seconds).
- [ ] Movement, attack, dodge, special ability all respond; input buffering feels good.
- [ ] WASD/arrows + Space/J/K/E/P/Esc work; page does not scroll on Space/arrows.
- [ ] Touch controls work on a narrow (mobile) viewport; no accidental scroll/zoom.
- [ ] Pause fully freezes simulation, timers, particles, enemy behavior.
- [ ] Instant restart fully resets run state (health, coins, floor, score, relics).
- [ ] Game over is reachable and shows accurate stats (score, floor, enemies, duration).
- [ ] Victory/run‑completion is reachable.
- [ ] High scores persist after a reload; corrupt stored data does not crash the game.
- [ ] Resize and orientation changes don't break the layout or hide info.
- [ ] No enemy or the player can become permanently stuck; paths remain reachable.
- [ ] Collision and attack ranges feel fair and are readable.
- [ ] Performance stays smooth with several enemies and many particles; particles are capped.
- [ ] Reduced‑motion mode actually reduces shake/flash/particles.
- [ ] Audio toggle works; audio failure does not block gameplay.
- [ ] Generation is seeded and reproducible; two seeds give different, both‑reachable runs.

## 9. Deliverables

1. The complete runnable game (static build) in your workspace root.
2. A short `README.md` (run instructions, controls, what was cut, how to see seed/debug).
3. A one‑paragraph summary of the build's strongest feature and its current biggest risk.

## 10. Definition of done (final gate)

Before you stop, you must be able to say all of the following truthfully:

- A new player can load the page, understand the objective, move, attack, dodge, defeat an
  enemy, collect a reward, and restart after a defeat — without confusion.
- The game is complete (start → progression → boss/end → score → restart) and has no
  broken buttons, dead ends, or placeholder screens.
- It runs offline, self‑contained, on desktop and mobile.
- It is honest: everything you claim exists, works, and is reachable by a player.

Ship the best complete game you can. Good luck.

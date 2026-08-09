# Ashen Descent — Game Specification

This is the **shared, frozen specification** handed to both game‑development agents.
Both builds are evaluated against the *player experience* this spec describes — not
against this text as a checklist. It defines the intended scope, the objective list used
by the test plan, and the terms/mechanics expected to exist.

> **Note for evaluators.** This spec describes what the game *should* be. During play you
> judge what the game *actually is*. A build that implements the spec's letter but feels
> dead, or one that deviates while feeling great, is judged on experience. See the
> "experience over compliance" rule in the rubric.

---

## 1. Product goal

A complete, immediately‑fun browser game: fast action controls, tactical turn‑based
decision beats, short replayable roguelike runs, strong audiovisual feedback, clear
risk/reward progression, excellent desktop and mobile usability, portfolio‑grade
polish. Fully self‑contained — no external services, authentication, or backend.

## 2. Core concept

Control a lone dungeon delver descending through procedurally assembled rooms. Combat
alternates real‑time movement with tactical *resolution beats*:

- Move, dodge, attack, and interact in real time.
- Attacking, dodging, using an ability, or entering dangerous enemy range briefly enters
  a tactical resolution phase.
- During this phase, enemy **intent indicators** become visible and the player makes a
  deliberate decision.
- Actions resolve quickly enough to preserve momentum (action combat with readable
  tactical pauses — **not** a slow turn‑based RPG).
- First encounter begins almost immediately after starting a run; core loop learnable in
  under one minute.

## 3. Core loop

1. Start a run from the title screen.
2. Enter a compact dungeon room.
3. Move with keyboard or touch.
4. Fight enemies (basic attack, dodges, ≥1 special ability).
5. Read telegraphs and tactical intent markers.
6. Collect coins, relics, healing items, temporary buffs.
7. Choose between branching room paths.
8. Encounter combat / elite / treasure / healing / event rooms.
9. Defeat a miniboss or progress through multiple floors.
10. Die or complete the run.
11. Compute score; record in local high‑score table.
12. Instant restart without refreshing the page.

Speed **and** careful play both rewarded; "wait and attack" must never be optimal.

## 4. Player controls

**Desktop:** `WASD`/arrows move · `Space` dodge/dash · `J`/LMB basic attack ·
`K`/RMB special ability · `E` interact/open/reward select · `P`/`Esc` pause · number
keys for tactical options if useful. Centralized configurable input; browser defaults
prevented where appropriate.

**Mobile/touch:** left virtual joystick or drag pad; large right‑side attack/dodge/
ability buttons; optional tap‑to‑interact; thumb‑sized buttons; visual press states and
haptic feedback where supported; no accidental scroll/zoom/selection/navigation.

**Input quality:** input buffering for attacks/dodges; short dodge grace window;
frame‑rate‑independent controls; clear feedback when an action is unavailable;
focus‑safe when the tab loses focus; auto‑pause on mobile visibility changes.

## 5. Combat

- **Basic attack:** short wind‑up, readable hitbox, recovery, directional targeting,
  hit‑stop on impact, proportional screen shake, damage numbers, distinct hit/miss/crit.
- **Dodge:** brief i‑frames, directional, cooldown/stamina cost, afterimage/motion trail,
  satisfying sound/particles, fair timing window.
- **Special ability** (≥1): charged arc, short‑range shockwave, throwable spectral blade,
  time‑slow pulse, or defensive parry — limited by cooldown/energy/resource.
- **Tactical resolution:** intent icons/colors/projected attack zones; world briefly
  slowed/paused; choose attack/dodge/reposition/defend/ability; predictable resolution;
  deterministic, learnable enemy behavior; no excessive menus or long animations.

## 6. Enemies

1. **Gravebound** — basic melee; slow approach; clear wind‑up attack.
2. **Cinder Wisp** — ranged; delayed projectiles; encourages movement/prioritization.
3. **Hook Hound** — fast; charges after a visible telegraph; punishes standing still.
4. **Mourning Knight** — armored elite; blocks frontal attacks; requires dodging,
   repositioning, or punishing a committed strike.
5. **Floor Boss** — multi‑phase; ≥3 recognizable patterns; strong telegraphs; clear
   vulnerability window; dramatic entrance and defeat.

Each needs idle/move/attack/hit/defeat states, health/damage values, collision and attack
ranges, intent indicators, audio+visual feedback, and behavior scaling with depth.

## 7. Dungeon generation

Deterministic seeded procedural generation. Each run contains a start room, several
combat rooms, ≥1 reward/treasure room, optional healing/event rooms, a miniboss/boss
room, and branching path choices. Guarantees reachable layouts, no impossible enemy
placements, clear exits, reasonable combat space, predictable progression, balanced
risk/reward. Display the seed optionally on the game‑over screen.

## 8. Rewards & progression

Run‑based: coins (in‑run), temporary relics/blessings, weapon modifiers, passive stat
upgrades, healing opportunities, risk/reward choices. Example relics: +damage after a
perfect dodge; heal after elite kill; bonus score for combos; attack‑speed below half
health; secondary projectile; coins → temporary armor. Clear descriptions, visible
impact, no heavy inventory management.

## 9. Score system

Rewards: enemy defeats, elite/boss kills, floor progression, combo streaks, fast room
clears, perfect dodges, no‑damage encounters, coins, relic rarity, remaining health.
Multipliers for skilled play; understandable. Displays: current score, combo/momentum
meter, best score, run duration, floor number, optional style/rank evaluation.

## 10. High‑score table

Local browser storage, top 5–10 runs (score, name/default, floor reached, date), sorted
descending; handles corrupt/unavailable storage; reset behind confirmation; visible from
start and game‑over screens. No server.

## 11. Game states

Boot/loading · start screen · how‑to‑play overlay · active gameplay · tactical
resolution · pause · reward selection · floor transition · game over · victory ·
high‑score display. Input isolated per state (no gameplay input leaking into menus).
Pause must fully freeze simulation, timers, particles, enemy behavior, and logic‑affecting
animations.

- **Start screen:** title, subtitle, Start Run, How to Play, High Scores, audio toggle,
  cohesive visual theme.
- **Pause:** Resume, Restart Run, Controls summary, audio toggle, Return to Title.
- **Game over:** cause of defeat, final score, floor reached, enemies defeated, run
  duration, best‑score comparison, Instant Restart, Return to Title.

## 12. Visual direction

Dark painterly gothic dungeon atmosphere; warm ember‑orange highlights against deep
charcoal/violet/desaturated blue; high contrast between entities and background;
stylized readable silhouettes; subtle paper/stone/smoke/parchment texture; strong
lighting, fog, vignette, layered depth; no combat clutter. Readability over decoration —
attacks, hazards, player position, actions, rewards obvious at a glance. Original
CSS/Canvas/SVG/procedural visuals (no copied game assets).

## 13. Animation & juice

Screen shake, hit‑stop (a few frames), damage flash/tint, enemy squash‑and‑stretch,
weapon trails, dash afterimages, sparks/dust, coin bursts and collection arcs, floating
damage numbers, combo popups, room‑clear celebration, reward reveal, boss entrance/defeat,
smooth room/floor transitions, camera easing and directional look‑ahead. Configurable +
**reduced‑motion mode** disabling/reducing shake, flashes, excess particles.

## 14. Audio

Menu confirmations, attack/hit/dodge/enemy/reward/boss sounds, ambient dungeon loop,
combat intensity changes, victory/defeat stingers. Master toggle; separate music/effects
if practical; safe fallback if audio can't autoplay; user‑initiated audio activation from
start screen. If assets unavailable, convincing visual‑only feedback and modular audio
integration.

## 15. Performance

Target 60 FPS desktop + mobile. Delta‑time simulation; pool particles/floating text/
projectiles/transients; cap particle counts; avoid layout thrash; minimize re‑renders;
Canvas/suitable layer for gameplay; separate UI from high‑frequency rendering; handle DPR;
reduce resolution on low‑power devices; pause rendering/sim when hidden; clean resize/
orientation; lightweight debug/performance indicator for development.

## 16. Architecture

Clear separation: game state, input, simulation/update loop, rendering, collision, enemy
AI, procedural generation, audio, particles, UI screens, persistence, configuration/
balance. Centralize tunables (player speed, attack cooldown, dodge duration, i‑frame
duration, enemy health/damage, room count, reward rates, score multipliers). No scattered
magic numbers.

## 17. Responsive layout

Desktop widescreen, laptop, tablet, mobile portrait and landscape. Preserve aspect ratio
without hiding information; scale playfield; controls in thumb reach; avoid browser safe
areas/notches; support mouse+touch; visible focus/pressed states; legible small typography.

## 18. Accessibility

High‑contrast UI; keyboard menu navigation; visible focus states; reduced‑motion;
color not the only signal; text labels for icons; adjustable text size if feasible; no
essential info conveyed solely through animation.

## 19. Balancing goals

First 10 seconds: immediate movement, a clear enemy, a satisfying attack, visible hit
reaction, a meaningful dodge, a reward or room transition shortly after. First run
understandable without a manual. Difficulty rises gradually via varied combinations,
more complex patterns, narrower timing, elite modifiers, hazards, tougher reward
decisions. No unfair instant kills, unreadable attacks, excessive crowding, or grind.

## 20. Technical deliverables

Complete runnable game; clear project structure; start/pause/game‑over/victory/restart
flows; responsive desktop+touch controls; local high‑score persistence; procedural
dungeon progression; ≥4 standard enemy types + 1 boss; ≥1 special ability and several
reward effects; particle effects, screen shake, hit‑stop, transitions, feedback systems;
responsive UI and accessibility options; no broken buttons, dead ends, placeholder
screens, or missing core interactions; no backend dependency.

## 21. Testing checklist (test‑plan source)

Fresh‑load start · first attack works immediately · keyboard without page scroll ·
touch on narrow screens · pause fully freezes · restart resets state · game‑over reachable
with accurate stats · victory reachable · high scores persist after reload · corrupt
storage safe · resize/orientation safe · no permanently stuck entities · fair/readable
collision & attack ranges · smooth with many enemies/particles · reduced‑motion works ·
audio failure doesn't block gameplay.

## 22. Definition of done

Feels like a cohesive game, not a stack of mechanics. A new player can load, understand
the objective, move, attack, dodge, defeat an enemy, collect a reward, and restart after
defeat without confusion. Prioritize a polished vertical slice with excellent feel and
reliable functionality over an oversized feature list.

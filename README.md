# CoDeX–GeNiuS Agent Arena — One-Shot Game Development Agent Creation Benchmark

A rigorous benchmark that evaluates an AI agent's ability to **create a complete, original, and compelling game in a single sustained development session**.

The agent is treated as a **game developer, not as a player, contestant, or gameplay evaluator**. Its task is to conceive, implement, polish, and present a playable game. The benchmark evaluates the quality of the game and the agent's development process — not its ability to achieve a score within a pre-existing game.

> **Containment rule (hard).** Nothing in this package — no score, rubric constant, evaluator logic, or instrumentation — may be embedded in, shipped with, or discovered by the games under test. The games must be pure playable artifacts. Evaluation is read-only observation of the finished games and their code.

---

## Core Objective

The agent receives a game-development brief and must independently produce a finished playable experience. It should make meaningful decisions about:

- Game concept and creative direction
- Gameplay mechanics and interaction design
- Visual style and presentation (2D, 3D, 2.5D, browser, simulation, narrative, strategy, experimental — **agent chooses what wins**)
- Audio and feedback systems
- Level, world, or encounter design
- Technical implementation
- User interface and onboarding
- Performance, stability, and overall polish

**Do NOT restrict submissions to 2D, 2.5D, or 3D.** A strong entry may be a 2D game, a 3D game, a browser experience, a simulation, a narrative game, a strategy game, an experimental interactive work, or another format if that choice improves the result.

## What the benchmark tests

1. **Code quality** — structured, maintainable, robust, technically sound
2. **Creative originality** — distinctive idea, memorable mechanics, intentional design vs generic template
3. **Long-session execution** — plan, build, debug, iterate, polish effectively across many steps without losing coherence
4. **Design judgment** — tradeoffs between scope, ambition, usability, quality
5. **Visual and interactive ambition** — visually convincing and coherent, not basic shapes/gradients/simplistic enemies/flash-game presentation
6. **Human-perceived quality** — engaging, intentional, aesthetically coherent, worth exploring, memorable vs competing entries

## Two parts

1. [`challenge/`](challenge/README.md) — production side: how the two game-dev agents are launched fairly. Identical one-shot brief `BATTLE_PROMPT.md` (same bytes for both), plus self-QA.
2. [`benchmark/`](benchmark/README.md) — evaluation side: how finished games are judged by human jury + automated launch checks.

## Important Clarification (from spec)

The benchmark is **NOT** about agents playing a game designed by someone else. The agent must create the game itself. It should not be asked to maximize a score, defeat opponents, solve a fixed challenge, or act as an evaluator. Any gameplay session after development exists only to verify the created game functions and communicates its intended experience.

Primary question: **Can the agent independently create a complete, creative, technically competent, and visually compelling game that human judges would choose over competing entries?**

## Scope and Freedom

Do NOT impose unnecessary restrictions on:
- Dimensionality or camera perspective
- Genre
- Rendering style (Canvas, WebGL, WebGPU, Three.js, etc.)
- Game engine or framework
- Input method
- Narrative structure
- Level structure
- Visual realism or abstraction
- Procedural or authored content
- Degree of experimentation

Constraints focus on fairness and comparability — time, compute, permitted assets, required deliverables — not on forcing same kind of game.

## Evaluation Perspective

Evaluation performed primarily by **human judges** reviewing finished result. Automated checks may verify that game launches, runs, responds to input, satisfies technical requirements, but should not define success alone.

Human judges consider: how strong/original core idea is, whether mechanics understandable/enjoyable, whether game feels complete rather than merely functional, whether visual direction coherent and ambitious, whether presentation creates strong first impression, whether experience contains depth/variation, whether implementation appears carefully engineered, whether agent used session effectively, whether game memorable vs other submissions.

Visually simple game not penalized merely for being simple if simplicity is deliberate, expressive, highly polished. Technical complexity should not receive automatic credit if it doesn't improve player experience.

## Expected Agent Workflow

1. Interpret brief and establish feasible creative direction
2. Plan core loop, scope, architecture, presentation
3. Build functional prototype quickly
4. Test prototype through actual interaction
5. Identify weaknesses in mechanics, usability, visuals, performance
6. Iterate substantially rather than stopping at first functional version
7. Add polish, feedback, content, presentation improvements
8. Verify final build launches reliably and understandable to new player
9. Deliver game together with source, instructions, documentation

Rewarded for recognizing weak early approach and revising it. Long-session quality includes debugging, rethinking, improving — not merely generating large amount of code.

## What this package contains

| Path | Deliverable |
|------|-------------|
| `GAME_SPEC.md` | Open-ended development brief for creator agent — emphasizes authorship, freedom, and quality signals |
| `challenge/BATTLE_PROMPT.md` | The one-shot battle prompt given to each game-dev agent (identical for both, self-contained) |
| `challenge/README.md` | Fairness contract, containment audit, runbook for two builds |
| `challenge/LAUNCH_PROTOCOL.md` | Heterogeneous repo-access launch, no-exploit guarantees |
| `challenge/DEVELOPER_SELF_QA.md` | Build-verification checklist |
| `challenge/launch_challenge.py` | Harness helper: provisions 2 isolated workspaces, emits prompt, records hashes, audits containment |
| `benchmark/00-problem-analysis.md` | Why one-shot game creation benchmarks fail (shallow templates vs authored games) and design responses |
| `benchmark/01-one-shot-arena-prompt.md` | Human jury evaluation prompt (primary deliverable) |
| `benchmark/02-scoring-rubric.md` | Formal rubric: code quality, creativity, long-session, design judgment, visual ambition, human-perceived quality |
| `benchmark/03-long-session-test-plan.md` | Verification plan for development process and final game, not for playing scores |
| `benchmark/04-defect-taxonomy.md` | Defect classes for technical failures |
| `benchmark/05-reporting-template.md` | Jury report template |
| `benchmark/06-anti-bias-anti-gaming.md` | Anti-bias strategy for human jury |
| `benchmark/07-operational-automated.md` | Operational runbook |
| `benchmark/08-selection-and-final-decision.md` | How to select better game from jury + technical signals |
| `benchmark/deploy/` | Deployable evaluator prompt + guide |
| `reference_arch/` | Reference rendering fallbacks (WebGPU→WebGL→Canvas2D) — inspiration, not mandate |
| `expert_team/` | Consensus docs on render pipeline, React/Canvas separation |
| `benchmark/ops/` | Evidence schema, aggregator, decision block generator |

## Battle log

Every round produces an after-action record in `battles/`. Concrete defects found in a round are folded back into `challenge/BATTLE_PROMPT.md`, `challenge/DEVELOPER_SELF_QA.md`, `benchmark/02-scoring-rubric.md`, `benchmark/04-defect-taxonomy.md`, and `benchmark/06-anti-bias-anti-gaming.md` **before** the next round is launched. The benchmark evolves through use.

| Round | Date | Status | Reference |
|---|---|---|---|
| 001 (informal) | 2026 (see file) | claude-opus-4-8 won on balance; deepseek-v4-pro failed reliability gate. Winner shipped broken mouse + audio drone → hardened v2. | (see `battles/round-001-after-action.md` on origin branch) |
| **002 (informal — 10 games observed)** | 2026-08-20 | Directional review across 10 model-game deliveries. Drove the **v6 prompt + rubric §2.8 two-track + §6.5 cliché-cluster registry + CEIL-5/6/7/8**. **v6 later regressed — see Round 003.** | [`battles/round-002-after-action.md`](battles/round-002-after-action.md) |
| **003 (informal — 5 battles, 9 games)** | 2026-08-21 | **v6 regression identified.** All 9 deliveries rated bad by operator. v6's "wow-or-lose" framing + exhaustive cliché list + 21 KB prompt size pushed agents into overreach and a new anti-cliché cluster (C11: novel-verb + procedural-canvas + WebAudio). **v6 replaced with v7** — short (9.7 KB), calm, concrete about "what a game means," cliché list moved to judge-side only, "ship modest complete over ambitious broken" framing. **v7 later also regressed — see Round 004.** | [`battles/round-003-after-action.md`](battles/round-003-after-action.md) |
| **004 (informal — 5 battles, ≥4 shippable games)** | 2026-08-22 | **v7 regression identified.** Two of four models (hunyuan-hy3-preview + gemini-3.5-flash) independently shipped the SAME shield-arc-deflection arcade with waves + upgrades + boss. Operator: *"gemini's creation nearly same as hy3's creation that means your prompt failed."* Confirmed the failure is a documented alignment phenomenon (mode collapse in post-training-aligned models, Zhang et al. 2025) — cluster C12 recorded. **v7 replaced with v8** — encodes real game-designer craft (MDA reversal, design pillars, find-the-fun ordering, small interlocking systems, notebook-then-scary-pick concept selection) as an actual working method, drawing on the published tradition (Hunicke/LeBlanc/Zubek, Swink, Vlambeer, Ludum Dare veterans). One entry (hy3's AEGIS) was the most positive verdict of Rounds 002–004: *"real game with levels, still 0 graphical revolution."* | [`battles/round-004-after-action.md`](battles/round-004-after-action.md) |
| **005 (informal — 4 battles, 7 shippable attempts)** | 2026-08-24 | **v8 broadly failed to produce stability.** 7 attempts under v8; only claude-opus-5-max's **GATHER** (glassblowing, "breath global, heat local," 3 interlocking systems) was operator-satisfying — *"actually lower than expectation but working."* Craft ritual was measurably adopted (7/7 shipped design_notebook.md; opus5 quoted §1.4 verbatim), but did NOT prevent per-model mode collapse (gemini shipped echolocation submarine twice as its personal collapsed answer; gemini-high shipped C12 again as KINETIC AEGIS; qwen ping-ponged Chromatide→GLOW). Operator: *"I cannot obtain battle prompt stability yet."* **v8 held constant — no v9 patch.** Recommendation: run 3 controlled experiments under v8 (frontier-only pool, same-model-twice, prompt-hold observation) to test whether the ceiling is prompt-bounded or pool-bounded before another prompt revision. | [`battles/round-005-after-action.md`](battles/round-005-after-action.md) |
| 006 (planned — v8 held) | tbd | Experiments A/B/C per Round 005 §5 | [`BATTLE_2_ENTRY.md`](BATTLE_2_ENTRY.md) — paste-ready launch kit |

## How to run one comparison (summary)

1. Launch both agents with identical `challenge/BATTLE_PROMPT.md` in isolated environments
2. Freeze builds (no edits), run containment audit, record hashes + time budget
3. Assign blind labels Game A / Game B (random, secret)
4. Automated checks: launch, no crash loop, responds to input, pause/restart/persistence safe, contains no telemetry/score-embedding
5. Human jury reviews finished games per `benchmark/01-one-shot-arena-prompt.md` + `02` + `03`, recording evidence in `ops/evidence_schema.json`
6. Aggregate per `aggregate_scores.py`, select per `08`

## Guiding principles

- **Evaluate the created game, not agents playing a game.** Agent is developer.
- **Unlimited creativity, production freedom, graphical freedom, time.** Do not restrict to 2D/2.5D/3D.
- **Code quality matters.** Structured, maintainable, robust, not just functional.
- **Visual ambition over flash templates.** Push beyond simple box gradient colored enemies.
- **Long-session execution.** Planning → prototype → test → debug → iterate → polish, not first functional version.
- **Human jury chooses.** Automated checks verify function, humans judge authorship, memorability, polish.
- **No score inside games.** External containment.

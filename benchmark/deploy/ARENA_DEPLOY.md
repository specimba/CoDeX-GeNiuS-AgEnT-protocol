# Arena Deployment Guide — One-Shot Game Development Agent Creation

## How to use evaluation prompt

Deployable prompt is in `benchmark/deploy/01-deploy-prompt.txt` — contains ONLY evaluator instructions, ready to paste.

## Purpose

Benchmark evaluates **AI agent's ability to create complete, original, compelling game in single sustained development session**. Agent is **developer, not player/contestant/gameplay evaluator**. Task is to conceive, implement, polish, present playable game. Evaluates quality of game and development process — not ability to achieve score within pre-existing game.

## Unlimited creativity (critical)

- Do NOT restrict submissions to 2D, 2.5D, or 3D
- Do NOT restrict genre, rendering style, engine, input, narrative, level structure, realism, procedural vs authored, experimentation
- Agent chooses most suitable format and technology for concept
- Strong entry may be 2D, 3D, browser, simulation, narrative, strategy, experimental if improves result
- Constraints focus on fairness/comparability (time, compute, permitted assets, deliverables) not forcing same kind of game

## Unseen model tags (anti-sniffing)

Games labeled A and B. Evaluator must never infer which agent built which. Harness must randomize A/B assignment per run and record mapping in evidence.json separately (never inside prompt). If evaluator detects embedded scores, telemetry, or meta-quality metrics inside either game, log as CONTAINMENT Critical and exclude that channel.

## Hard gates (Kernel)

- CEIL-1 (55): reproducible main-path crash/soft-lock
- CEIL-2 (65): primary loop unreachable
- CEIL-3 (60): core controls broken >30%
- CEIL-4 (70): persistence fails on fresh browser if claims persistence
Plus: mouse hygiene (real mouse verified), audio hygiene (no drone/streaming loop, mute stops immediately), no embedded benchmark logic, no environment sniffing, visual ambition collapse (simple box gradient colored enemies as final = low V0 max 1, explicitly)

Any LLM running benchmark must apply ceilings before emitting pairwise verdict.

## Evaluation perspective

- Automated checks: game launches, runs, responds to input, satisfies technical requirements
- Human judges primary: review finished result for strong/original core idea, understandable/enjoyable mechanics, completeness vs merely functional, coherent ambitious visual direction, strong first impression, depth/variation, careful engineering appearance, effective session use, memorability vs other submissions

Visually simple game not penalized merely for being simple if deliberate, expressive, highly polished. Technical complexity not automatic credit if doesn't improve experience.

## Creation-style system for benchmarking

1. Read GAME_SPEC.md (open-ended brief, Kernel vs Shell, unlimited creativity)
2. Read BATTLE_PROMPT.md (one-shot development brief)
3. Read benchmark/deploy/01-deploy-prompt.txt (jury instructions)
4. Read 02-scoring-rubric.md (code quality, creativity, long-session, design judgment, visual ambition heavily weighted, human-perceived quality), 03 test plan (S1-S9 including S9 Creative Probe), 04 defect taxonomy, 05 reporting template
5. Execute automated launch checks + S1-S9 on both frozen builds (A/B randomized)
6. Apply CEIL rules, log defects, compute category scores (mean×2), aggregate weights T16 M17 G17 F12 V20 A12 X6=100, hard penalty
7. Emit 05 reporting template + ops/evidence_schema.json

## Creation logs

Every benchmark run must produce creation_log.json recording: timestamp, evaluator identity/model family, A/B assignment randomized, seed used if any, session archetypes completed S1-S9, probes executed (P-Render, P-VisualConsistency, P-LoopSeparation, P-EnvConsistency, P-CodeQuality), defects found, ceilings applied, final OVERALL for A and B, pairwise verdict human jury would choose, confidence, HARNESS-ISSUE notes, evidence filenames.

Log must never be embedded in game build. Verified for containment per 06-anti-bias-anti-gaming.

Framework constraints: no rendering dimension mandatory (2D,3D,mixed,procedural all acceptable); no session time limit within fair compute (agents may run hours); reliability, code quality, visual consistency, creativity, visual ambition are measured outcomes, not effect count. Push beyond simple box gradient colored enemies / flash-game approach.

## What benchmark tests (reminders)

1. Code quality — structured, maintainable, robust, technically sound
2. Creative originality — distinctive idea, memorable mechanics, intentional vs generic template
3. Long-session execution — plan, build, debug, iterate, polish across many steps without losing coherence
4. Design judgment — tradeoffs scope/ambition/usability/quality
5. Visual and interactive ambition — visually convincing coherent, not basic shapes/gradients/simplistic enemies/unpolished flash
6. Human-perceived quality — engaging, intentional, aesthetically coherent, worth exploring

Primary question: Can agent independently create complete, creative, technically competent, visually compelling game that human judges would choose over competing entries?

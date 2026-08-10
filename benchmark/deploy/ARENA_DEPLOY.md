# Arena Deployment Guide — Benchmark & Ruleset

## How to use the evaluation prompt correctly

DO NOT copy the entire `benchmark/01-one-shot-arena-prompt.md`. That file contains metadata, usage rules, and wrapper notes. The deployable prompt is in:

```
benchmark/deploy/01-deploy-prompt.txt
```

That file contains ONLY the evaluator instructions — no markdown headers, no wrapper — ready to paste as a prompt.

## Unseen model tags (anti-sniffing)

Games are always labeled A and B. The evaluator must never infer which agent built which. The harness must randomize A/B assignment per run and record the mapping in `evidence.json` separately (never inside the prompt given to the evaluator). If the evaluator detects embedded scores, telemetry, or meta-quality metrics inside either game, log as `CONTAINMENT` (Critical) and exclude that score channel.

## Jurisdictional restrictions (CEIL rules)

These are hard limits applied to OVERALL regardless of other scores:
- CEIL-1 (55): reproducible main-path crash/soft-lock.
- CEIL-2 (65): primary loop unreachable.
- CEIL-3 (60): core controls broken >30% of attempts.
- CEIL-4 (70): persistence fails on fresh browser.
Plus hard gates: mouse hygiene (desktop real mouse verified), audio hygiene (no drone/streaming loop, mute stops immediately), no embedded benchmark logic.

Any LLM running this benchmark must apply these ceilings before emitting any pairwise verdict. They are jurisdiction rules — non-negotiable.

## Creation-style system for easy benchmarking

Any LLM can benchmark using our ruleset by following:
1. Read `GAME_SPEC.md` (canonical spec).
2. Read `benchmark/deploy/01-deploy-prompt.txt` (evaluator instructions).
3. Read `benchmark/02-scoring-rubric.md`, `03-long-session-test-plan.md`, `04-defect-taxonomy.md`, `05-reporting-template.md`.
4. Execute S1–S8 on both frozen builds (A/B randomized).
5. Apply CEIL rules, log defects per taxonomy, compute category scores (mean × 2), aggregate weights (T20 M18 G18 F14 V12 A10 X8), apply hard penalty.
6. Emit `benchmark/05-reporting-template.md` format + `ops/evidence_schema.json`.

## Creation logs

Every benchmark run must produce a creation log (`creation_log.json`) recording:
- timestamp, evaluator identity/model family, A/B assignment (randomized), seed used (if any)
- session archetypes completed (S1–S8), probes executed (P-Render, P-VisualConsistency, P-LoopSeparation, P-EnvConsistency)
- defects found (id, severity, class, reproduction steps)
- ceilings applied, final OVERALL for A and B, pairwise verdict (A wins / B wins / tie)
- confidence level and any HARNESS-ISSUE notes
- evidence filenames (screenshots, recordings)

The log must never be embedded in the game build. It is a separate artifact, verified for containment (`benchmark/06-anti-bias-anti-gaming.md`).

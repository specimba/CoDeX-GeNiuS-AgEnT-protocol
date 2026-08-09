# CoDeX–GeNiuS Agent Arena — Game Evaluation Protocol

A rigorous, scalable **arena benchmark** for comparing two autonomous game‑development
agents by evaluating the **complete games they produce** — not their internal reasoning,
implementation style, or self‑reported claims.

The games in this benchmark are built from a single shared specification
([`GAME_SPEC.md`](GAME_SPEC.md) — *Ashen Descent*, a dungeon‑crawler roguelike).
Both agents receive the identical spec. The evaluation is deliberately **external**:
no scoring logic, telemetry, or benchmark instrumentation lives inside either game.
The evaluation harness, rubrics, and aggregator in this repository are the only source
of scores.

> **Containment rule (hard).** Nothing in this package — no score, rubric constant,
> evaluator logic, or instrumentation — may be embedded in, shipped with, or discovered
> by the games under test. The games must be pure playable artifacts. Evaluation is
> read‑only observation of the running games.

---

## Two parts

This repository has **two sides** of the same arena:

1. **[`challenge/`](challenge/README.md)** — the *production* side: how the two game‑dev
   agents are launched so their builds are fair and comparable. The one prompt each agent
   receives is [`challenge/BATTLE_PROMPT.md`](challenge/BATTLE_PROMPT.md)
   (**identical for both** — that equality is what makes the comparison fair), plus an
   internal self‑QA checklist agents run before delivering.
2. **[`benchmark/`](benchmark/README.md)** — the *evaluation* side: how the finished games
   are played, scored, and compared. Fully external and contained.

## What this package contains

| Path | Deliverable |
|------|-------------|
| [`GAME_SPEC.md`](GAME_SPEC.md) | The shared spec both agents build against (reference for the test plan's objective list). |
| [`challenge/README.md`](challenge/README.md) | Orchestration: fairness contract, containment audit, end‑to‑end runbook for the two builds. |
| [`challenge/BATTLE_PROMPT.md`](challenge/BATTLE_PROMPT.md) | **The one‑shot battle prompt given to each game‑dev agent** (identical for both; self‑contained and ready to paste). |
| [`challenge/LAUNCH_PROTOCOL.md`](challenge/LAUNCH_PROTOCOL.md) | Launching the challenge with heterogeneous repo access: identical single prompt, repo‑sharing containment, no‑exploit guarantees, equal circumstances. |
| [`challenge/DEVELOPER_SELF_QA.md`](challenge/DEVELOPER_SELF_QA.md) | Internal build‑verification checklist agents run (distinct from the external rubric). |
| [`challenge/launch_challenge.py`](challenge/launch_challenge.py) | Harness helper: provisions 2 isolated workspaces, emits a single self‑contained prompt, records time budget + build hashes, audits containment. |
| [`benchmark/00-problem-analysis.md`](benchmark/00-problem-analysis.md) | Deep analysis of why one‑shot game evaluations fail, and the design responses. |
| [`benchmark/01-one-shot-arena-prompt.md`](benchmark/01-one-shot-arena-prompt.md) | **The one‑shot arena prompt** to give to an evaluation agent (primary deliverable). |
| [`benchmark/02-scoring-rubric.md`](benchmark/02-scoring-rubric.md) | Formal rubric: scales, anchors, weights, defect penalties, score ceilings. |
| [`benchmark/03-long-session-test-plan.md`](benchmark/03-long-session-test-plan.md) | Standardized long‑session protocol with short/medium/long windows. |
| [`benchmark/04-defect-taxonomy.md`](benchmark/04-defect-taxonomy.md) | Defect classes, severities, and the canonical defect record schema. |
| [`benchmark/05-reporting-template.md`](benchmark/05-reporting-template.md) | Final report template (executive, categories, defects, verdict). |
| [`benchmark/06-anti-bias-anti-gaming.md`](benchmark/06-anti-bias-anti-gaming.md) | Anti‑bias and anti‑gaming strategy (blind, ordered, evidence‑gated). |
| [`benchmark/07-operational-automated.md`](benchmark/07-operational-automated.md) | Concise operational protocol for large‑scale automated use. |
| [`benchmark/08-selection-and-final-decision.md`](benchmark/08-selection-and-final-decision.md) | **How to select the better game** from the scores (decision rules, reliability vs creative separation). |
| [`benchmark/examples/example-evaluation-report.md`](benchmark/examples/example-evaluation-report.md) | Worked example report on synthetic evidence (format + aggregation demonstration). |
| [`benchmark/examples/synthetic/`](benchmark/examples/synthetic/README.md) | Runnable synthetic bundle: `run_head_to_head.py` runs scores + Bradley–Terry ranking + decision block in one command. |
| [`benchmark/ops/evidence_schema.json`](benchmark/ops/evidence_schema.json) | Machine‑readable evidence schema for automated aggregation. |
| [`benchmark/ops/aggregate_scores.py`](benchmark/ops/aggregate_scores.py) | Reference aggregator: category scores, hard‑failure penalties, Bradley–Terry fit, confidence intervals. |
| [`benchmark/ops/decision_block.py`](benchmark/ops/decision_block.py) | One‑page head‑to‑head decision generator (applies `benchmark/08` rules). |

## How to run one comparison (summary)

1. **Launch both agents** with the identical
   [`challenge/BATTLE_PROMPT.md`](challenge/BATTLE_PROMPT.md) in isolated
   environments (see [`challenge/README.md`](challenge/README.md)).
2. **Freeze** the builds (no further edits); run the containment audit.
3. Launch the arena: assign evaluator agents/humans, blind‑labeled **Game A / Game B**,
   order‑counterbalanced across evaluators.
4. Evaluators execute `benchmark/03-long-session-test-plan.md` using
   `benchmark/01-one-shot-arena-prompt.md`, recording evidence in the
   `benchmark/ops/evidence_schema.json` format.
5. Scores are computed **only after all sessions complete** via
   `benchmark/ops/aggregate_scores.py`, per `benchmark/02-scoring-rubric.md`.
6. Pairwise preferences feed a Bradley–Terry/Elo ranking with bootstrap confidence
   intervals. The final call follows [`benchmark/08-selection-and-final-decision.md`](benchmark/08-selection-and-final-decision.md)
   and is emitted as a one‑page decision block by
   [`benchmark/ops/decision_block.py`](benchmark/ops/decision_block.py).
   Reports follow `benchmark/05-reporting-template.md`.

See [`benchmark/07-operational-automated.md`](benchmark/07-operational-automated.md) for
the end‑to‑end runbook and [`benchmark/00-problem-analysis.md`](benchmark/00-problem-analysis.md)
for the rationale behind every design choice.

## Guiding principles

- **Evaluate the artifact, never the agent.** No code reading, no dev‑log reading.
- **Long sessions over demos.** Sustained quality is the signal; first‑impression
  spectacle is a confound.
- **Experience over compliance.** We score what the player experiences, not how well the
  build matches the spec as a checklist.
- **Hard failures gate everything.** A game that soft‑locks the main path cannot score
  well overall, no matter how beautiful.
- **Evidence‑gated scoring.** No major score without a timestamped, reproducible basis.
- **No score inside the games.** Full external containment.

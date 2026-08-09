# Benchmark Package Index

External, read‑only evaluation system for the **Ashen Descent Agent Arena**. Nothing here
ships inside a game; scores are computed from external evidence only (containment rule).

| File | Purpose |
|------|---------|
| `00-problem-analysis.md` | Why naive one‑shot evaluations fail + the design response for each failure mode. Read this first. |
| `01-one-shot-arena-prompt.md` | **The evaluator prompt** — verbatim text handed to each evaluation agent/human for one head‑to‑head. |
| `02-scoring-rubric.md` | Formal rubric: sub‑criteria, anchors, weights, hard‑failure penalties, ceilings, pillar scores. |
| `03-long-session-test-plan.md` | Standardized session archetypes (S1–S8), probes, conditions, and hard‑case handling. |
| `04-defect-taxonomy.md` | Defect classes, severities, and the canonical defect record schema. |
| `05-reporting-template.md` | Final report structure (executive, categories, defects, verdict, confidence). |
| `06-anti-bias-anti-gaming.md` | Every bias vector, gaming vector, and their defenses + enforcement rules. |
| `07-operational-automated.md` | Concise end‑to‑end runbook for large‑scale automated use. |
| `08-selection-and-final-decision.md` | Decision rules for choosing the better game; separates "better overall" from "more reliable." |
| `examples/example-evaluation-report.md` | Worked example report on synthetic evidence (format + aggregation demo). |
| `ops/evidence_schema.json` | Machine‑readable evidence contract for automated aggregation. |
| `ops/aggregate_scores.py` | Reference aggregator: OVERALL, pillars, penalties, ceilings, Bradley–Terry + bootstrap CIs. |

## Quick start

1. Read `00-problem-analysis.md`, then `06-anti-bias-anti-gaming.md` for the rationale.
2. Freeze both game builds (no edits during evaluation); audit containment.
3. Run each evaluator with `01-one-shot-arena-prompt.md`, supplying `02`, `03`, `04`, `05`,
   and `ops/evidence_schema.json` as read‑only references.
4. Collect evidence JSON per game, then run:
   `python ops/aggregate_scores.py <evidence_dir> --bt`
5. Write the report per `05-reporting-template.md`.

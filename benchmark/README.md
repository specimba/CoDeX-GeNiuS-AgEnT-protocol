# Benchmark Package Index — One-Shot Game Development Agent Creation

External, read-only evaluation system for **One-Shot Game Development Agent Creation Benchmark**.
Agent is **developer**, not player. Nothing here ships inside a game; scores computed from external evidence only (containment).

| File | Purpose |
|------|---------|
| `00-problem-analysis.md` | Why naive game creation benchmarks fail (template bias, first-prototype bias) + design responses |
| `01-one-shot-arena-prompt.md` | **Human jury evaluation prompt** — verbatim text for head-to-head comparison of two created games |
| `02-scoring-rubric.md` | Formal rubric: code quality, creative originality, long-session execution, design judgment, visual ambition (heavily weighted), human-perceived quality — scales, anchors, weights, ceilings |
| `03-long-session-test-plan.md` | Verification plan for development process and final game (S1-S9 including S9 Creative Probe), probes, hard-case handling |
| `04-defect-taxonomy.md` | Defect classes, severities, schema |
| `05-reporting-template.md` | Jury report template |
| `06-anti-bias-anti-gaming.md` | Anti-bias, anti-gaming strategy for human jury |
| `07-operational-automated.md` | Operational runbook |
| `08-selection-and-final-decision.md` | Decision rules: which created game human jury would choose |
| `deploy/01-deploy-prompt.txt` | Deployable evaluator prompt (only evaluator instructions) |
| `deploy/ARENA_DEPLOY.md` | Deployment guide, CEIL rules, anti-sniffing |
| `examples/example-evaluation-report.md` | Worked example report |
| `examples/synthetic/` | Synthetic bundle: run_head_to_head.py scores + BT ranking + decision block |
| `ops/evidence_schema.json` | Evidence contract |
| `ops/aggregate_scores.py` | Aggregator: category scores, penalties, Bradley-Terry, CIs |
| `ops/decision_block.py` | Decision generator |

## Evaluation philosophy

- Agent is developer, not player contestant
- Unlimited creativity: no restriction to 2D/2.5D/3D, genre, rendering style, engine, input, narrative, level structure, realism, procedural vs authored
- Code quality + long-session execution matter: plan → prototype → test → debug → iterate → polish
- Visual ambition weighted heavily: push beyond simple box gradient colored enemies / flash-game approach
- Human jury chooses memorable authored game over generic functional template
- Automated checks verify launch, input, pause, restart, persistence, no telemetry; human jury judges authorship

## Quick start

1. Read `00-problem-analysis.md` then `06-anti-bias-anti-gaming.md`
2. Freeze both game builds (no edits), audit containment
3. Run automated launch checks
4. Run human jury with `01-one-shot-arena-prompt.md` supplying `02,03,04,05` and `ops/evidence_schema.json` as references
5. Collect evidence JSON, run `python ops/aggregate_scores.py <evidence_dir> --bt`
6. Write report per `05-reporting-template.md`

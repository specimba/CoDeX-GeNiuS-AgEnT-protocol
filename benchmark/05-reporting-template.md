# 05 — Final Report Template

The final report for one head‑to‑head comparison. It is produced **after** both independent
evaluations are complete and the pairwise decision is made. Every major score cites
evidence. Fill every numbered section; if a section has no data, say "no evidence collected."

---

# Ashen Descent Arena — Evaluation Report

**Pair ID:** `AD-<NN>` · **Date:** <date> · **Evaluator:** <evaluator_id>
**Ordering assigned:** A‑first / B‑first · **Judge model/panel:** <ids>
**Hardware profile:** <profile> · **Browser matrix:** <matrix>
**Total evaluation time:** <hh:mm per game; hh:mm total>

## 1. Executive comparison
One short paragraph per game: what kind of game it actually is, its single biggest strength,
and its single biggest weakness. Then a one‑sentence verdict.

## 2. Testing coverage
Table of archetypes (S1–S8) per game with: completed? / duration / objective met? /
notes. Any archetype skipped → state why. Report `PARTIAL‑COVERAGE` categories here.

## 3. Category‑by‑category scores

### Game A
| Cat | Sub‑scores (0–5) | Category (0–10) | Evidence summary |
|-----|------------------|-----------------|------------------|
| T  | T1..T7 | _ | ... |
| M  | M1..M6 | _ | ... |
| G  | G1..G6 | _ | ... |
| F  | F1..F6 | _ | ... |
| V  | V1..V5 | _ | ... |
| A  | A1..A5 | _ | ... |
| X  | X1..X5 | _ | ... |
**Game A:** OVERALL_raw · HARD_PENALTY · OVERALL_adj · ceilings applied · **OVERALL = __** · pillars (TECH/CREATIVE/GAMEPLAY/FLOW/DEFECT_SEVERITY).

### Game B
*(same table)*
**Game B:** OVERALL = __ · pillars.

## 4. Defect register
Table: id | game | severity | class | title | blocking? | recoverable? | reproductions | immersion | evidence. Full records are in the evidence bundle (`ops/evidence_schema.json`).

## 5. Critical failures
List every Blocker/Critical defect with reproduction steps and the ceiling it triggered (or "none").

## 6. Strongest moments
Timestamped, evidenced highlights per game (e.g. "boss entrance at [S3][00:18:22] — telegraphs clear, hit‑stop excellent").

## 7. Weakest moments
Timestamped low points per game ("soft‑lock in corner at [S6][00:03:11]"; "repetitive floor‑3 enemy spam at [S4][00:41:00]").

## 8. Long‑session findings
Per game: performance samples (0/15/30/45/60 min), memory‑growth notes, late‑session bugs, engagement trajectory (rising/flat/collapsing) over 60 min and across repeat runs.

## 9. Pairwise arena outcome
Independent‑score table (both games) side by side, then the pairwise verdict: **A wins / B wins / Tie**. Explain the decisive strengths/weaknesses. Report whether the pairwise preference agrees with the OVERALL ranking or diverges (e.g. A more reliable, B more engaging).

## 10. Confidence and limitations
Per game and per verdict: confidence (low/med/high) and rationale. Coverage gaps, disputed SUBJ criteria, inter‑rater notes if paneled, position‑bias control result (did both‑orderings agree?), any HARNESS‑ISSUE exclusions.

## 11. Final decision
Which game is the better complete game and why. If close, state the margin and what evidence would change the call.

---

## Automated attachment (machine‑readable)
Emit alongside the report a JSON object matching `ops/evidence_schema.json` so the aggregator
can recompute scores independently:

```json
{
  "pair_id": "AD-01",
  "game_a": { "category_scores": {...}, "sub_scores": {...}, "defects": [...], "ceilings": [...], "coverage": {...} },
  "game_b": { "...": "..." },
  "pairwise": { "verdict": "A|B|tie", "preference_confidence": 0.0..1.0 },
  "meta": { "hardware": "...", "browser_matrix": "...", "evaluator": "...", "ordering": "...", "timestamps": {...} }
}
```

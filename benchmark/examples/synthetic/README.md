# Synthetic Evidence Bundle — `aggregate_scores.py --bt` demo

This folder is a **synthetic, self-contained demo** of the aggregation pipeline. It is
**not** real evaluation data. Its purpose is to show, with a single command, how the
benchmark turns raw evidence into (1) per‑game OVERALL/pillar scores and (2) a
Bradley–Terry / Elo ranking with bootstrap confidence intervals.

## Contents

| File | Meaning |
|------|---------|
| `game_A.json` | Evidence for Game A (the head‑to‑head favorite). |
| `game_B.json` | Evidence for Game B (the more original but structurally broken build). |
| `pairs.json` | 78 synthetic pairwise votes across four labels (A, B, C, D) for the BT ranking. |
| `RESULTS_demo.txt` | Captured output of the command below (so you can read it without running). |

## Run it yourself

```bash
python ../../ops/aggregate_scores.py . --bt --pairs pairs.json --seed 7 --n-boot 800
```

## What the demo shows

- **Per‑game scores.** Game A: OVERALL **85.4**, no ceilings. Game B: raw 69.9, hard
  penalty 4 (one Critical), **CEIL‑1** → OVERALL **55.0**. This is the reliability gate in
  action — B's single critical soft‑lock caps it even though its *raw* score is 69.9.
- **Creative vs reliable split.** A leads overall *and* on the creative pillar (91.1 vs
  87.7), yet B leads on **raw graphical originality** (V0 = 5 vs 3). This demonstrates why
  V0 was added: a build can be more original (B) while a less flashy but more polished,
  readable build (A) is still the better complete game.
- **Bradley–Terry ranking with CIs.** A > B > C ≈ D. A and B separate cleanly (Elo margin
  240.8, CIs far apart). C and D both bottom out at the same clamp (~610) because neither
  ever beats A or B and they rarely meet — flagged as "not separable."
- **Both‑orderings tie handling.** `pairs.json` includes 4 explicit `"winner":"tie"` rows;
  these are expanded into two half‑weight directional votes inside `add_vote`, so ties
  correctly count as draws instead of corrupting the ranking with a bogus "tie" label.

## Reproducibility

The seed is fixed (`--seed 7`), so re‑running gives identical ratings and CIs. This is the
auditability property the benchmark requires for its real runs too.

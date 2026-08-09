# ops — External Aggregation Tooling

Pure, external computation. No scoring/telemetry ships inside a game.

## `evidence_schema.json`
The machine‑readable contract every evaluator's evidence must conform to (one object per
game per comparison). `aggregate_scores.py` reads these to recompute scores independently.

## `aggregate_scores.py`

```
python aggregate_scores.py <evidence_dir> [--pairs pairs.json] [--bt] [--seed N] [--n-boot N]
```

- `<evidence_dir>` — directory of `*.json` evidence files. Supports either per‑game files
  (`{"game":"A", ...}` / `{"game":"B", ...}`) or combined pair files
  (`{"game_a":{...},"game_b":{...},"pairwise":{...}}`).
- `--pairs pairs.json` — optional list of `{"a","b","winner"}` rows to merge for a
  Bradley–Terry ranking across many comparisons.
- `--bt` — fit an order‑independent Bradley–Terry MLE (MM algorithm, Hunter 2004) mapped to
  Elo‑like ratings, plus bootstrap 95% confidence intervals.

### Output
- Per game: category scores (0–10), `overall_raw` (0–100), `hard_penalty`,
  `overall_adj`, `ceilings_hit`, `overall`, and pillar scores (technical reliability /
  creative presentation / gameplay / flow‑engagement / defect severity).
- Pairwise: Elo‑like rating per label with bootstrap CI and a ranking verdict.

### Example

```bash
python aggregate_scores.py evidence/ --bt --pairs pairs.json --seed 1 --n-boot 1000
```

### Dependencies
Python 3.8+ standard library only (no numpy/scipy required).

> The math here mirrors the LMArena methodology (Bradley–Terry → Elo‑like ratings with
> bootstrap confidence intervals), adapted for game‑quality evidence rather than chat
> preference votes.

## `decision_block.py` — one‑page head‑to‑head decision

Applies `benchmark/08` decision rules (hard‑failure gate, OVERALL margin, pairwise signal)
and prints a concise DECISION block for a Game A vs Game B comparison, with the
reliability‑vs‑creative separation.

```
python decision_block.py <evidence_dir> [--pairs h2h_pairs.json]
```

Runnable demo: `benchmark/examples/synthetic/run_head_to_head.py`.

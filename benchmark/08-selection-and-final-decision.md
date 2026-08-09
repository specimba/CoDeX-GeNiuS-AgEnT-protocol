# 08 — Selection & Final Decision

How to turn scores into a defensible "which game is better" verdict. This is the layer that
answers the arena's real question — *which agent's game do we pick* — without letting a
single number, evaluator, or bias make the call for us.

## 8.1 What evidence exists after a comparison

After aggregation (`ops/aggregate_scores.py`), for each game we have:

- **OVERALL** (0–100): weighted composite after hard‑failure penalties and ceilings.
- **Pillar scores** (0–100 each): `technical_reliability`, `creative_presentation`,
  `gameplay`, `flow_engagement`, `defect_severity`.
- **Category scores** (0–10 each): T, M, G, F, V, A, X.
- **Hard‑failure record**: blockers, criticals, ceilings hit.
- **Coverage**: which categories were FULL / PARTIAL / NOT‑SCORED.
- **Pairwise result**: winner, confidence, whether both orderings agreed.
- **Confidence**: inter‑rater agreement, position‑consistency, CI width.

## 8.2 Decision procedure (in order)

1. **Gate on hard failures first.** A game that hit a **ceiling** (main‑path crash /
   soft‑lock / unreachable completion / broken core controls / persistence failure) is
   *structurally* worse. If exactly one game has a ceiling, that game is the loser
   **unless** the margin of evidence is overwhelming in its favor on every other dimension
   and the ceiling is borderline (e.g., a single reproducible corner soft‑lock vs. a
   hard‑capped run loop). Default: ceiling wins the argument.

2. **Compare OVERALL.** If the OVERALL margin is large **and** the confidence is high and
   coverage is full, decide on OVERALL. "Large" means the margin exceeds the uncertainty —
   use the bootstrap CI width from the pairwise fit where available, otherwise require a
   margin of **≥5 points** with full coverage to call it.

3. **Disaggregate the reasons.** State *why* the winner won, on which pillars:
   - Did it win on **technical_reliability**, **gameplay**, **flow**, **creative**, or
     **defect_severity**? A game can win OVERALL on creative polish while losing
     reliability — that distinction must be stated, not hidden.
   - Separate "better overall game" from "more technically reliable game" explicitly.
     They are different claims and both should be reported (see §8.4).

4. **Pairwise agreement.** Prefer a verdict consistent with both the OVERALL ranking and
   the independent pairwise preference. If they disagree (e.g., A has higher OVERALL but
   the pairwise says B), do **not** silently pick one — report the conflict, examine
   whether the OVERALL margin is within the pairwise CI, and explain the resolution.
   A robust decision needs the two signals to align; if they don't, confidence is LOW.

5. **Sub‑criterion audit.** If the margin is close, drill into sub‑criteria with the
   largest gaps and check the evidence for each. Discard a decision resting on a
   sub‑criterion with no evidence (downgraded = not scored).

6. **Decide and state confidence.** Emit one of:
   - **Clear winner** — large margin, full coverage, high confidence, signals aligned.
   - **Winner on balance** — margin exists but some uncertainty (partial coverage, or
     close CI); pick but flag the caveat.
   - **Tie / not separable** — margin within CI / conflicting signals / low coverage.
     Do NOT force a winner; report the tie and what would break it.

## 8.3 Scoring beyond the headline: the two‑claim separation

The arena requirement is to separate "better overall game" from "more technically reliable
game." Report both every time:

| Game | OVERALL | Tech Reliab | Creative | Gameplay | Flow | Defect Sev | Ceilings |
|------|--------:|------------:|---------:|---------:|-----:|-----------:|:--------:|
| A | 84.2 | 91 | 82 | 83 | 80 | 96 | none |
| B | 78.0 | 60 | 88 | 74 | 72 | 71 | CEIL‑1 |

Here B is *more creative*, but A is *more reliable* and *better overall* (B's ceiling and
low reliability sink it). The report must say: "A is the better overall game (reliable,
complete, flowing); B has stronger presentation moments but is structurally compromised."
That is a useful, honest answer to "which is better."

## 8.4 Decision rules summary

| Condition | Verdict |
|---|---|
| One game hits a ceiling, other doesn't | Default: ceiling‑hitter loses (reliability gate). |
| OVERALL margin ≥5, full coverage, high confidence, pairwise agrees | **Clear winner.** |
| OVERALL margin ≥5 but pairwise disagrees OR coverage partial | Winner on balance; LOW/MED confidence; explain conflict. |
| OVERALL margin <5 or CIs overlap | **Tie / not separable** unless a decisive defect (ceiling) or sub‑criterion gap with strong evidence breaks it. |
| Coverage NOT‑SCORED for a weighted category | Downgrade confidence; never decide on unexperienced categories. |

## 8.5 Anti‑Goodhart guardrails for the decision

- **Never pick on a single number.** OVERALL must be decomposed into pillars + categories +
  defects so the verdict is explainable and auditable.
- **Never reward unexperienced features.** The decision only uses evidence-backed scores.
- **Never punish creative taste via the reliability gate.** A style difference is not a
  defect; only hard failures and evidenced weaknesses are.
- **Ties are a valid outcome.** Forcing a winner on a genuinely close pair fabricates
  precision. Report the tie and the discriminating evidence.
- **Note the budget/cadence caveat.** These are long sessions, not a verdict on permanent
  agent quality; state that the result reflects this build under this protocol at this
  point in time.

## 8.6 Output for the decision

Produce a short decision block (used in the report's Executive and Final Decision sections):

```
DECISION: [Game A wins | Game B wins | Tie]
OVERALL:    A = 84.2 | B = 78.0   (margin 6.2)
Reliability: A better (91 vs 60; B hit CEIL-1)
Creative:    B better (88 vs 82)
Gameplay:    A better (83 vs 74)
Flow:        A better (80 vs 72)
Pairwise:    A wins (confidence 0.9, both orderings agreed)
Confidence:  HIGH
Rationale:   A is a complete, reliable, well-flowing roguelike; B has stronger
             presentation but is structurally compromised (main-path soft-lock
             caps its score and its persistence is unreliable). On the balance of
             reliability + gameplay + flow, A is the better complete game.
```

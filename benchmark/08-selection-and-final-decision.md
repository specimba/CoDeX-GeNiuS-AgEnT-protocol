# 08 — Selection & Final Decision: Which Created Game Would Human Jury Choose?

How to turn scores into defensible verdict which **created game** is better. Answers arena's real question — which agent's game do we pick — without letting single number, evaluator, or bias make call. Evaluates developer agents creating games, not player agents playing for scores.

## 8.1 What evidence exists after comparison

After aggregation ops/aggregate_scores.py, for each created game we have:

- OVERALL 0-100 weighted composite after hard-failure penalties and ceilings
- Pillar scores 0-100 each: technical_reliability / code_quality / creative_presentation / visual_ambition / gameplay / flow_engagement / human_jury / defect_severity / originality_bonus
- Category scores 0-10 each: T,M,G,F,V,A,X (V now 20% heavily weighted to punish simple box gradient / flash-game approach)
- Hard-failure record: blockers, criticals, ceilings hit
- Coverage: FULL / PARTIAL / NOT_SCORED
- Pairwise result: winner, confidence, whether both orderings agreed
- Confidence: inter-rater agreement, position-consistency, CI width
- Long-session findings: performance samples, memory growth, engagement trajectory, code quality signals observed, visual ambition sustained or collapsed
- Creative probe S9 findings: what surprised, learnable, sustained

## 8.2 Decision procedure (in order)

1. **Gate on hard failures first.** Game that hit ceiling (main-path crash/soft-lock/unreachable loop/broken core controls/persistence failure) is structurally worse. If exactly one game has ceiling, that game is loser unless margin overwhelming in its favor on every other dimension and ceiling borderline (e.g., single reproducible corner soft-lock vs hard-capped run loop). Default: ceiling wins argument. Code quality T7 hard failures also considered.

2. **Compare OVERALL, but disaggregate.** If OVERALL margin large and confidence high and coverage full, decide on OVERALL. Large means margin exceeds uncertainty — use bootstrap CI width where available, otherwise require margin ≥5 points with full coverage to call it.

3. **Disaggregate reasons why winner won, on which pillars:**
   - Did it win on technical_reliability / code_quality / creative / visual_ambition / gameplay / flow / human_jury / defect_severity?
   - A game can win OVERALL on creative polish while losing reliability — distinction must be stated, not hidden.
   - Separate "better overall created game human jury would choose" from "more technically reliable" explicitly. Both reported.
   - Explicitly report visual ambition: Did one game push beyond simple box gradient colored enemies while other stayed flash-game template? V0 and V8 decisive here.

4. **Pairwise agreement.** Prefer verdict consistent with both OVERALL ranking and independent pairwise preference. If they disagree (e.g., A higher OVERALL but pairwise says B — perhaps B more creative/original despite minor bugs), do not silently pick one — report conflict, examine whether OVERALL margin within pairwise CI, explain resolution. Robust decision needs two signals align; if don't, confidence LOW.

5. **Sub-criterion audit.** If margin close, drill into sub-criteria with largest gaps and check evidence. Of special interest for creation benchmark:
   - Code quality T7: structured, maintainable, robust, pooling, centralized tunables, evidence of iteration?
   - Visual ambition V0: originality, richness, complexity, sustained across entire run, beyond box gradients?
   - Surprise V8, World invention A6, Mechanical twist M7, Player story G7: did game surprise, have voice, emergent stories?
   - Long-session execution: did agent iterate substantially or stop at first functional version?
   Discard decision resting on sub-criterion with no evidence (downgraded = not scored).

6. **Decide and state confidence.** Emit one of:
   - Clear winner — large margin, full coverage, high confidence, signals aligned, human jury choice clear
   - Winner on balance — margin exists but some uncertainty (partial coverage, close CI); pick but flag caveat
   - Tie / not separable — margin within CI / conflicting signals / low coverage. Do NOT force winner; report tie and what would break it.

## 8.3 Scoring beyond headline: three-claim separation

Arena requirement is to separate better overall created game vs more technically reliable vs more visually ambitious/creative. Report all three every time:

| Game | OVERALL | Tech Reliab | Code Qual | Visual Ambition | Creative | Human Jury | Ceilings |
|------|--------:|------------:|----------:|----------------:|---------:|-----------:|:--------:|
| A | 84.2 | 91 | 88 | 82 | 82 | 85 | none |
| B | 78.0 | 60 | 55 | 88 | 88 | 80 | CEIL-1 |

Here B more creative and visually ambitious, but A more reliable, better code quality, better overall human jury choice because B's ceiling and low reliability sink it. Report must say: "A is better overall created game human jury would choose (reliable, complete, well-engineered, visually coherent); B has stronger creative moments but structurally compromised and code quality low." Or if both reliable but B more original and pushes visual limits beyond box gradients while A is competent generic, B may win despite similar OVERALL — creativity and visual ambition are heavily weighted (V 20%).

## 8.4 Decision rules summary

| Condition | Verdict |
|---|---|
| One game hits ceiling, other doesn't | Default: ceiling-hitter loses (reliability gate) |
| OVERALL margin ≥5, full coverage, high confidence, pairwise agrees, visual ambition not collapsed | Clear winner |
| OVERALL margin ≥5 but pairwise disagrees OR coverage partial | Winner on balance; LOW/MED confidence; explain conflict (e.g., reliable vs creative tradeoff) |
| OVERALL margin <5 or CIs overlap | Tie / not separable unless decisive defect (ceiling) or sub-criterion gap with strong evidence breaks it, e.g., V0 gap 3 points with evidence of pushing limits vs flash template |
| Coverage NOT_SCORED for weighted category | Downgrade confidence; never decide on unexperienced categories |
| One game simple box gradient enemies as final, other pushes visual limits with coherent identity sustained | Visual ambition pillar decisive; simple box gradient approach explicitly low, should lose on V-heavy weighting even if similar T |

## 8.5 Anti-Goodhart guardrails

- Never pick on single number. OVERALL decomposed into pillars + categories + defects + long-session + creative probe so verdict explainable auditable
- Never reward unexperienced features. Decision only uses evidence-backed scores
- Never punish creative taste via reliability gate. Style difference not defect; only hard failures and evidenced weaknesses. Deliberate expressive polished minimalism not penalized as simple
- Ties valid outcome. Forcing winner on close pair fabricates precision. Report tie and discriminating evidence
- Note budget/cadence caveat. These are long sessions, not verdict on permanent agent quality; state result reflects this build under this protocol at this point in time
- Visual ambition guardrail: simple box gradient approach explicitly low, but deliberate minimalism with exquisite polish can score high — must be evidenced as intentional (director statement + observable polish across entire run)

## 8.6 Output for decision

Produce short decision block (used in report Executive and Final Decision):

```
DECISION: [Game A wins | Game B wins | Tie] — Human jury would choose X
OVERALL:    A = 84.2 | B = 78.0 (margin 6.2)
Reliability: A better (91 vs 60; B hit CEIL-1)
Code Quality: A better (88 vs 55)
Visual Ambition: B better (88 vs 82) — B pushes beyond box gradients, A competent generic
Creative: B better (88 vs 82)
Human Jury: A better (85 vs 80)
Pairwise: A wins (confidence 0.9, both orderings agreed)
Confidence: HIGH
Rationale: A is complete, reliable, well-engineered, visually coherent authored game that human jury would choose; B has stronger creative visual moments beyond flash template but is structurally compromised (main-path soft-lock caps score, code quality low). On balance of reliability + code quality + visual ambition + human jury, A is better overall created game. If B fixed CEIL-1 and improved code structure, would be close.
```

Include visual ambition assessment explicitly in rationale, not just numbers.

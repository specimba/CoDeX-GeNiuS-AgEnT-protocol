# 06 — Anti‑Bias and Anti‑Gaming Strategy

The benchmark must be resistant both to evaluator bias and to agents gaming the rubric.
This file lists every mechanism, the bias/gaming vector it neutralizes, and the enforcement
rule. It maps directly onto established LLM‑as‑judge and arena methodology (position/verbosity/
self‑preference bias, order‑counterbalancing, Bradley–Terry aggregation) and game‑QA practice.

## 6.1 Bias vectors and defenses

| Bias vector | Mechanism | Defense |
|---|---|---|
| **Position bias** (judge prefers first/second option regardless of quality) | Ordering in pairwise comparison | Run **both orderings** ("A vs B" and "B vs A"); treat inconsistent verdicts as a tie/half‑win. Balance A‑first vs B‑first across evaluators. |
| **Anchoring / halo** (impression of A bleeds into scoring B) | Sequential evaluation | **Independent scoring first:** A's category scores are finalized before B is even opened; pairwise preference decided only afterward. |
| **Verbosity bias** (longer/fancier = better) | Presentation density | Rubric is **behavioral and length‑neutral**; scores reference observable anchors, not amount of content or effects. |
| **Self‑preference / authority** (judge model favors its own family; favors confident tone) | Judge model choice | Judge model family **different from** the generation agents; ensemble of ≥3 judge families with majority verdict; ignore confident‑but‑unsupported tone. |
| **Screenshot/novelty bias** (spectacle over feel) | Static captures | No scoring from static media alone; only live interactive play scores; novelty must sustain over 30/60 min. |
| **Sympathy/identity bias** (liking a brand/agent) | Revealed identity | Blind labels **Game A / Game B**; no agent identity, no code, no logs, no README. |
| **Rubric‑order / framing bias** (order of criteria skews scores) | Prompt structure | Multi‑criteria rubric with fixed anchors; criteria order fixed and public; treat the rubric as versioned code — any change re‑baselines scores. |
| **Leniency / strictness drift** (judge scoring inflates or deflates across the run) | Evaluator calibration | Pre‑run calibration: every evaluator scores 2 warm‑up canned samples before real scoring; drift is monitored and reported. |
| **Fatigue / order‑of‑day effects** | Long sessions | Sessions capped; breaks enforced; S4 (long) and S8 (repeats) may be split across panelists; no major score from an exhausted single session. |
| **Inter‑rater noise** | Single judge opinion | Panels of ≥3 evaluators; compute Cohen's κ / Krippendorff's α; high disagreement ⇒ low confidence; outlier detection on sub‑scores. |
| **Model drift over time** | Evolving judge | Sample‑cross‑check: 5–10% of verdicts re‑judged by a frontier judge/human; track drift. |

## 6.2 Anti‑gaming vectors and defenses

| Agent tactic | Defense |
|---|---|
| **Checklist compliance** (implement many shallow features to tick boxes) | Experience‑over‑compliance scoring; broken/unreachable features get **no credit**; an unusable feature is treated as absent. |
| **Front‑door polish** (all effort in title/room‑1) | Late‑session criteria gate flow/engagement; main completion loop must be reachable or OVERALL is capped. |
| **Visual spectacle over feel** | Readability + feel are separate, heavily weighted criteria; effects that harm readability/performance are penalized. |
| **Novelty one‑trick** | Depth criterion requires *sustained* value (first vs Nth encounter); novelty alone cannot raise the score. |
| **Safe‑seed tuning** | Seeds drawn at evaluation time; ≥2 seeds per game; multi‑run testing. |
| **Hidden late failures** | Long sessions + goal‑directed completion + edge probes (P‑Stuck, P‑Persist, P‑Corrupt). |
| **Embedded scores/telemetry** | **Containment rule**: any in‑game score/telemetry/eval logic is a Critical CONTAINMENT defect and that channel is barred; games are frozen builds. |
| **Self‑report / documentation** | Never read code, README, or dev notes; scores from experience only. |
| **Optimizing a single rubric number** | Overall is a weighted composite + penalties + ceilings + confidence intervals; no single knob dominates; per‑criterion evidence is required. |

## 6.3 Enforcement rules (hard)

1. **Blindness.** Evaluators see only Game A / Game B builds. Revealing an agent identity is a
   protocol violation that voids that evaluator's results.
2. **Independence.** No category score for B is influenced by A's scores. Sequence is
   enforced by the harness (A's form is locked before B's opens).
3. **Evidence gates.** Every sub‑score ≥3 requires timestamped note/capture/reproduction.
   No evidence ⇒ downgraded to not‑scored.
4. **Containment.** Nothing from this package may ship inside a game. Audited by scanning the
   frozen builds for the rubric constants, telemetry endpoints, or eval strings.
5. **Versioning.** The rubric/prompt are versioned. Any change re‑baselines all scores; scores
   from different rubric versions are never mixed.
6. **Transparency.** All weights, ceilings, penalties, and formulas are public. No hidden
   bonuses. Any new rule is documented here before use.

## 6.4 Consistency & calibration checks

- **Position‑consistency test:** for a sample of pairs, run the comparison with A/B swapped and
  verify the verdict is stable; report the flip rate. High flip rate ⇒ low confidence.
- **Calibration vs humans:** a small human panel (e.g., 5–10% of verdicts) spot‑checks judge
  agreement; target κ ≥ 0.6 (good), ≥ 0.8 (strong).
- **Outlier detection:** flag sub‑scores that deviate >2 points from the panel mean; review the
  evidence for that judge before accepting.
- **Confidence intervals:** computed by bootstrap over per‑session/pairwise votes (see `07`);
  never report a raw point estimate as a reliable ranking when CIs overlap.

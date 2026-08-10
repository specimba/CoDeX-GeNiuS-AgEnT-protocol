# 06 — Anti-Bias and Anti-Gaming Strategy: One-Shot Game Creation

Benchmark must be resistant both to evaluator bias and to agents gaming rubric. Lists every mechanism, bias/gaming vector it neutralizes, and enforcement rule. Maps to LLM-as-judge and arena methodology (position/verbosity/self-preference, order-counterbalancing, Bradley-Terry) and game-QA practice, but adapted for **developer agents creating games**, not player agents playing for scores.

## 6.1 Bias vectors and defenses (human jury)

| Bias vector | Mechanism | Defense |
|---|---|---|
| Position bias (judge prefers first/second regardless of quality) | Ordering in pairwise comparison | Run both orderings A vs B and B vs A; treat inconsistent verdicts as tie/half-win. Balance A-first vs B-first across evaluators |
| Anchoring / halo (impression of A bleeds into scoring B) | Sequential evaluation | Independent scoring first: A's category scores finalized before B opened; pairwise preference only afterward |
| Verbosity bias (longer/fancier = better, or more code = better) | Presentation density | Rubric behavioral and length-neutral; scores reference observable anchors, not amount of code/content/effects. Code quality is structure/robustness, not line count |
| Self-preference / authority (judge model favors own family; favors confident tone) | Judge model choice | Judge family different from generation agents; ensemble ≥3 families majority verdict; human jury primary, model secondary; ignore confident-but-unsupported tone |
| Screenshot/novelty bias (spectacle over feel and code quality) | Static captures | No scoring from static media alone; only live interactive play + code quality signals + 60min sustained; novelty must sustain over 30/60min |
| Sympathy/identity bias (liking brand/agent) | Revealed identity | Blind labels Game A / Game B; no agent identity, no code repo link (code reviewed only via anonymized bundle for T7), no logs, no README director statement until after independent scoring |
| Rubric-order / framing bias | Prompt structure | Multi-criteria rubric fixed anchors; criteria order fixed public; versioned; any change re-baselines scores |
| Leniency / strictness drift | Evaluator calibration | Pre-run calibration: every evaluator scores 2 warm-up canned samples (one simple box gradient flash game = low V0 example, one deliberately polished minimalism = high example) before real scoring; drift monitored |
| Fatigue / order-of-day effects | Long sessions | Sessions capped; breaks enforced; S4 long and S8 repeats may be split across panelists; no major score from exhausted single session |
| Inter-rater noise | Single judge opinion | Panels ≥3 evaluators; compute Cohen's κ / Krippendorff's α; high disagreement ⇒ low confidence; outlier detection on sub-scores |
| Visual simplicity bias | Judging simple as bad automatically | Explicit rule: visually simple game not penalized merely for being simple if deliberate, expressive, highly polished. Conversely, technical complexity not automatic credit if doesn't improve experience. Evidence of intentional minimalism in README director statement considered after independent scoring |
| Model drift over time | Evolving judge | Sample-cross-check 5-10% verdicts re-judged by frontier judge/human; track drift |

## 6.2 Anti-gaming vectors and defenses (developer agents)

| Agent tactic | Defense |
|---|---|
| Checklist compliance (implement many shallow features to tick boxes) | Experience-over-compliance scoring; broken/unreachable features get no credit; unusable = absent; "complete > broad" in BATTLE_PROMPT |
| Front-door polish + simple box gradient enemies after | Late-session criteria + S4 60min performance sampling + S5 exploratory visual ambition check; main loop unreachable caps OVERALL. V0 explicitly penalizes simple box gradient colored enemies as final — low ceiling |
| Visual spectacle over feel/code quality (dump particles/shake) | Readability + feel separate heavily weighted; effects that harm readability/performance penalized; code quality T7 requires pooling/capping/centralization, not just effect count |
| Novelty one-trick (one gimmick then repetition) | Depth criterion G5/G7 + S9 Creative Probe requires sustained value first vs Nth encounter; novelty alone cannot raise score |
| Safe-seed tuning | Seeds drawn at evaluation time; ≥2 seeds; multi-run testing |
| Hidden late failures (soft-locks) | Long sessions + goal-directed completion + edge probes |
| Embedded scores/telemetry / self-rating | Containment rule: any in-game quality score/telemetry/eval logic is Critical CONTAINMENT defect and channel barred; frozen builds scanned |
| Self-report / documentation claiming features that don't exist | Never credit self-reported features; only experienced + code signals observed; README director statement read after scoring, cannot rescue broken Kernel |
| Optimizing single rubric number | Overall weighted composite + penalties + ceilings + CIs + code quality pillar; no single knob dominates; per-criterion evidence required |
| Environment sniffing / demo mode (different face for demo) | Environment-consistency probe P-EnvConsistency re-runs key scenarios desktop/mobile/portrait/landscape/headless; divergence = defect |
| Generic visuals / flash-game minimal template | V0 anchor rewrite + heavily weighted V (20%): primitive shapes/flat colors/simple box gradient enemies max 1-2 regardless of functionality; deliberate expressive polished minimalism can score high but must be evidenced as intentional and coherent across entire run |
| Code dump (large amount of unstructured code, no iteration) | Long-session execution pillar: does log show plan→prototype→test→debug→iterate→polish? T7 structure signals; if first prototype = final with no iteration, low long-session score even if functional |

## 6.3 Rubric public — assume agents read it

In many deployments, agent can read entire rubric. Design benchmark to be public-safe: knowing rubric must not confer advantage.

Enforced by:

- Experience-over-compliance — features must actually work and reachable; cannot claim credit for rubric item not shipped
- Hard ceilings for structural failures — main-path soft-lock caps OVERALL regardless of other tuning
- Evidence-gated sub-scores — every ≥3 needs timestamped reproducible evidence + code signal for T7
- Long sessions + multi-seed — no single number decidable from short gamed surface
- Blind labels + jury ensembles — cannot tailor to one judge preference and doesn't know which build it is
- Environment consistency — cannot present one face to demo and another to real player
- Visual ambition explicit anti-template — knowing V0 heavily weighted does not help if agent cannot produce ambitious visual; simple box gradient remains low even if agent knows rubric says it's low

Consequence: even rubric-literate agent gains nothing beyond building genuinely good, technically sound, visually ambitious game that human jury would choose.

## 6.3 Enforcement rules (hard)

1. Blindness: evaluators see only Game A / Game B builds (plus anonymized code bundle for T7). Revealing agent identity voids that evaluator's results.
2. Independence: No category score for B influenced by A's scores. Sequence enforced by harness (A's form locked before B's opens).
3. Evidence gates: Every sub-score ≥3 requires timestamped note/capture/reproduction/code pointer. No evidence ⇒ downgraded to not-scored.
4. Containment: Nothing from this package may ship inside a game. Audited by scanning frozen builds for rubric constants, telemetry endpoints, eval strings.
5. Versioning: rubric/prompt versioned. Any change re-baselines all scores; scores from different versions never mixed.
6. Transparency: All weights, ceilings, penalties, formulas public. No hidden bonuses. Any new rule documented here before use.
7. Human jury primary: automated checks verify launch, input, pause, restart, persistence, no telemetry; human judges review finished game for authorship, memorability, visual ambition, code quality signals. Automated checks do not define success alone.

## 6.4 Consistency & calibration checks

- Position-consistency test: sample of pairs run with A/B swapped and verify verdict stable; report flip rate. High flip rate ⇒ low confidence.
- Calibration vs humans: small human panel 5-10% spot-checks judge agreement; target κ ≥0.6 good, ≥0.8 strong
- Outlier detection: flag sub-scores deviating >2 points from panel mean; review evidence before accepting
- Confidence intervals: bootstrap over per-session/pairwise votes; never report raw point estimate as reliable ranking when CIs overlap
- Visual calibration: include one known simple box gradient flash-game sample (should score V0=1) and one deliberate polished minimalism sample (should score V0=4) in calibration set to anchor visual ambition scoring

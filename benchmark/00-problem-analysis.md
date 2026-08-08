# 00 — Problem Analysis: Why One‑Shot Game Evaluations Fail, and the Design Responses

This document analyzes the failure modes of naive game benchmarks and records the design
decision each one forces. It is the intellectual basis for the arena prompt
(`01`), rubric (`02`), test plan (`03`), and operational protocol (`07`). It is written to
be challenged: every section states the risk, the common wrong reaction, and the
design response we adopt.

---

## 1. Common weaknesses of one‑shot game evaluations

A "one‑shot" evaluation — a judge watches a short demo or plays for a few minutes and
scores — systematically confuses *first impression* with *quality*.

| Weakness | Why it corrupts results | Design response |
|---|---|---|
| **Demo bias.** Screenshots/recordings favor spectacle over feel. | Motion, game feel, timing, and interaction quality are the core of a *game* but are invisible or misrepresented in static media. A judge may rate a pretty but unresponsive game higher than a plainer but crisp one. | Scores are awarded only from *live interactive play*, never from static captures alone. Captures are evidence, not the object of scoring. |
| **Novelty vs quality confusion.** Anything new looks better on first contact. | A surface novelty (one clever mechanic, a striking palette) can mask thin, repetitive, or broken underlying systems that only emerge over minutes. | Long sessions (30–60 min+) and repeated runs separate a genuinely deep game from a one‑trick demo. Novelty is penalized unless it sustains. |
| **Tutorial‑length sampling.** The first minutes are the most scripted and least representative. | Judges who only see the beginning rate onboarding polish and ignore mid/late content, pacing, difficulty curve, and late‑session bugs. | The test plan explicitly weights first‑5, first‑30, and mid/late windows; late‑session quality is a dedicated criterion. |
| **Checklist compliance.** Scoring "did it implement item X?" | Rewards ticking boxes over experience; a dead but feature‑complete clone can beat a tight, fun game. Also invites agents to game the rubric. | Experience‑over‑compliance: score what the player experiences. Features not experienced score nothing (no credit for unreachable or broken features). |
| **Missing failure detection.** No structured probing for crashes/soft‑locks. | A demo can be flawless while the full loop dead‑ends at room 4. | A systematic defect protocol (goal‑directed + exploratory + edge‑case) probes for blockers explicitly, and hard failures gate the overall score via ceilings. |
| **Single narrow session.** One path through a procedural game. | Procedural games can be great on one seed and broken on another. | Multiple runs, seeded where supported, plus a mandated variety of play styles. |
| **No reproducibility.** Scores from gut feeling with no evidence. | Impossible to audit, calibrate, or improve; individual judge quirks dominate. | Evidence‑gated scoring: timestamped notes, captures, reproduction steps required for every major score. |
| **Cross‑session contamination.** Evaluating both games together. | Halo effects and comparative anchoring distort absolute scores; order effects (judge remembers A when scoring B). | Independent, blind, order‑counterbalanced evaluation; pairwise preference decided only *after* independent category scoring. |

## 2. How agents may game or overfit the benchmark

An agent that can see the rubric will optimize for it. We therefore treat the rubric as
**contaminated once an agent sees it**, and rely on a protocol that is hard to game even
when known.

| Gaming tactic | Effect if undefended | Defense |
|---|---|---|
| **Shallow breadth** — implement many listed features minimally to "tick boxes." | High checklist score, low quality. | Experience‑over‑compliance scoring; features that don't actually work/feel score nothing; "unusable feature = absent feature." |
| **Polished front door** — invest everything in the title/start/room 1, ignore the rest. | High first‑impression score. | Late‑session criteria; the game must be *reached* to be scored; a path that can't be completed caps the overall score. |
| **Visual spectacle instead of feel** — dump particles/shake/vignettes. | High "presentation" score without playability. | Screenshot‑only impressions are discounted; feel and readability are separate criteria; effects that hurt readability or performance are penalized. |
| **The "10‑second hook" trap** — front‑load one gimmick. | High novelty score. | Novelty is scored as *sustained* value: it must remain compelling at 30/60 min, not just at 0:10. |
| **Exploit safe seeds** — tune a specific seed that's known to be tested. | Looks great on the seed used, broken elsewhere. | Multi‑seed, multi‑run testing; determinism is probed, not assumed; a seed cannot be known in advance by the evaluator either (seeds drawn at evaluation time). |
| **Hidden failure modes** — soft‑locks/paths that look fine but break late. | Missed by short demos. | Long sessions + structured edge/soft‑lock probing + a mandated "attempt to complete" goal. |
| **Self‑report gaming** — ship debug text, telemetry, or "README scores." | Directly inflates. | Containment: games are frozen builds; any embedded scoring/telemetry/scores is itself a defect and disqualifying for the score channel. |
| **Reveal the brand** — distinctive style that biases identity. | Identity/sympathy bias. | Blind labels (Game A/B); no agent identity, no code, no logs revealed. |

**Corollary (containment).** Because the protocol is public, the *score cannot live in
the game*. The score is computed externally from evidence. Any in‑game score display or
telemetry is ignored for the official score and flagged as a defect.

## 3. Why short demos produce misleading results

- **Long‑tail bugs** (memory growth, performance degradation, state corruption) only appear
  after minutes of continuous play or many restarts.
- **Difficulty and pacing** are emergent; the correct *feel* of a curve cannot be judged in
  two minutes.
- **Procedural variation** means a demo shows a sample, not the distribution.
- **Fatigue/engagement** — the most important game property (does it hold a player?) —
  is by definition unobservable in a short demo.
- **The first 10 seconds are the most scripted** and least informative about systemic
  quality.

The test plan therefore mandates short **and** medium **and** long windows, and the rubric
requires a session of ≥30 minutes before any "flow/engagement" criterion can be scored at
medium or high. No score above threshold is allowed on evidence from sub‑10‑minute play.

## 4. How to distinguish novelty from genuine quality

Novelty is *positive deviation the player still enjoys at minute N*. Genuine quality
survives contact with repetition.

Operational definition used here: **a feature is "good" if and only if it remains
engaging across repeated encounters and sessions.** Concretely:

- Score the same activity the first time *and* the Nth time.
- Judge depth by whether strategies/approaches keep appearing, not by the count of buttons.
- A mechanic that is charming once but tedious on repetition is a **weakness**, not a
  novelty bonus.
- "Depth" criterion requires evidence of emergent variety (multiple viable play styles,
  meaningful choices that change outcomes), not surface options.

## 5. How to evaluate atmosphere and fun without excessive subjectivity

These are the hardest to score reliably. We bound the subjectivity rather than removing it:

1. **Anchor to observable behaviors, not vibes.** "Atmosphere" is scored via concrete,
   observable anchors (audio present and fitting, music integrates with intensity, art
   direction is internally consistent, readability under combat, sense‑of‑place cues).
2. **Require a subjective‑rating field *and* a behavioral‑evidence field.** Every
   atmosphere/engagement score must pair an emotional rating with *what was observed*.
3. **Aggregate many ratings.** Individual taste is noise; mean plus dispersion across a
   multi‑evaluator panel with inter‑rater statistics (Cohen's κ / Krippendorff's α) is the
   signal. High disagreement is itself reported as low confidence.
4. **Separate "I liked it" from "it works."** Hard‑failure penalties and reliability
   scores are objective; taste‑dependent categories are explicitly flagged and weighted
   lower and reported with confidence intervals.
5. **Use independent evaluation first, comparison second.** A judge's *experience* of A
   is recorded before they ever see B, so "atmosphere" is scored on its own merits, not
   relative to the other game.

## 6. How to detect problems that appear only after extended play

| Problem type | When it appears | How the protocol catches it |
|---|---|---|
| Memory leak / unbounded growth | 20–60 min continuous | Long (60 min) sessions with periodic performance sampling; "repeated‑action stress"; restart cycles. |
| State‑corruption / save drift | Multiple restarts | Cold launch, warm restart, save/load/checkpoint cycles, corrupt‑storage injection. |
| Difficulty cliff / pacing collapse | Mid‑run | "Attempt to complete" goals; floor‑by‑floor logs; explicit first‑30‑minute and late‑session criteria. |
| Repetition / padding / dead time | 2nd–5th hour, or repeats | Long sessions, repeat runs, "Nth encounter" depth check. |
| Procedural dead‑end / unreachable layout | Depends on seed | Multi‑seed runs; a mandated path‑completion goal; soft‑lock probes. |
| Focus/visibility regressions | Tab switch, resize, orientation | Explicit environment‑edge tests (tab blur, resize mid‑combat, orientation change). |
| Performance degradation under load | Many entities + particles | Stress test with max enemies/particles; DPR/layout checks. |

## 7. How to scale evaluation across many game pairs

- **Automate measurement** (performance sampling, telemetry of the *browser*, defect
  capture) so human/judge attention is reserved for qualitative judgment.
- **Use a schema** (`ops/evidence_schema.json`) so every session emits structured JSON:
  identical fields across games and pairs. Aggregation is then a pure function
  (`ops/aggregate_scores.py`).
- **Standardize session archetypes** (smoke / medium / long / edge / goal) and mandate a
  minimum set per game so coverage is comparable.
- **Use evaluator panels + ensemble judging** to average out single‑judge noise; report
  confidence intervals, not point estimates, for close calls.
- **Pairwise first, then rank:** collect independent scores and pairwise preferences,
  then fit a Bradley–Terry model (order‑independent, offline) with bootstrap CIs. This
  scales: each pair is independent, and the model handles irregular schedules (matching
  the LMArena pattern but for *game quality* rather than chat responses).
- **Queue pairs** so evaluators compare two games in one unit of work, keeping the
  protocol identical per unit regardless of how many total pairs exist.

## 8. How to preserve fairness across genres and design styles

Within this benchmark the genre is controlled: both agents build the same spec (Ashen
Descent), so most genre confounds are already removed. Nonetheless the rubric is
genre‑aware for future generality:

- **Scope‑relative scoring.** "No explicit ending" is not penalized if the run loop is
  the intended scope; "optional content" is scored only if reachable and valuable, and
  never required.
- **Experience, not raw content count.** Two games with very different amounts of content
  are compared on what their content does for the player, not how many rooms they have.
- **No style quota.** A minimalist game is not docked for being minimalist; internal
  coherence and execution matter, not fashion. Agents are scored on *execution of their
  chosen direction*.
- **Readability and feel are universal.** These criteria are genre‑independent and carry
  significant weight, which is fair to all styles.
- **Denominators are explicit.** Confidence intervals communicate when a margin is too
  small to distinguish; ties are allowed and reported rather than forced.

## 9. Hard rules that fall out of this analysis

1. **Evaluate the artifact, not the agent.** Never read the game's code or dev notes;
   never score from a repo, README, or self‑report.
2. **Long sessions are mandatory, not optional.** No medium‑or‑high flow/engagement score
   without ≥30 min of live play.
3. **Evidence gates every major score.** No score above the low band without a timestamped,
   reproducible basis.
4. **Independent before comparative.** Category scores for A are finalized before A is
   compared to B. The pairwise verdict is a *separate, later* decision.
5. **Hard failures cap overall quality.** A main‑path soft‑lock or crash caps the overall
   score regardless of artistic merit.
6. **No score inside the games.** Full external containment of scoring, telemetry, and
   rubric constants.
7. **Only experienced features count.** Unreachable or broken features are treated as
   absent; never give credit for what wasn't experienced.
8. **Report uncertainty.** Never present a single number without a confidence/coverage
   statement when the margin is small.

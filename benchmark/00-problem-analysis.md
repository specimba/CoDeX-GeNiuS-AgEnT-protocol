# 00 — Problem Analysis: Why Game Creation Benchmarks Fail, and Design Responses

This document analyzes failure modes of naive game benchmarks and records design decisions for the One-Shot Game Development Agent Creation Benchmark.

---

## 1. Agent is developer, not player

Common mistake: benchmark asks agent to *play* a pre-existing game for score. That tests gameplay, not creation.

**Failure:** Judging agents by maximizing score in someone else's game incentivizes score-hacking, not authorship. A game-playing agent can be good at exploitation but unable to conceive, architect, and polish a complete experience.

**Design response:** Agent receives development brief, must independently produce finished playable game. Evaluation reviews created game for code quality, creativity, long-session execution, visual ambition, human-perceived quality. Any play after development exists only to verify game functions and communicates intent.

---

## 2. Common weaknesses of one-shot game creation evaluations

| Weakness | Why it corrupts results | Design response |
|---|---|---|
| **Template bias** — agent generates minimal flash-game: colored boxes, gradients, simplistic enemies, no feedback | Fast to generate, passes naive "it runs" check, but not authored, not memorable, not pushing visual limits | Visual ambition explicitly weighted; human jury rubric asks: beyond simple box gradient enemies? Is there distinctive art identity, layered lighting/fog/texture/particle/composition? Simple deliberate polished minimalism allowed, but simplistic-by-default penalized |
| **First-prototype bias** — agent stops at first functional version, no iteration | Measures ability to generate code dump, not ability to plan, debug, rethink, polish across long session | Expected workflow mandates prototype → test → identify weaknesses → iterate → polish. Long-session execution scored separately: did agent debug, revise weak approach? Synthetic evidence requires timestamps of iteration, not just final |
| **Checklist compliance** — scoring "did it implement X?" | Rewards ticking boxes over experience; dead but feature-complete clone beats tight fun game; invites gaming | Experience over compliance: score what player *experiences*. Kernel (launch, input, loop complete, pause freeze, persistence safe, self-contained) gates reliability via CEIL, but Shell (concept, visual style, surprise) is unlimited creativity and rewarded under V8/A6/M7 |
| **Dimensionality restriction** — forcing 2D or 3D | Biases toward one tech stack, limits creative choice of what would win jury | Do NOT restrict: 2D, 2.5D, 3D, browser, simulation, narrative, strategy, experimental all allowed. Agent chooses what wins. Reference_arch provides WebGPU→WebGL→Canvas2D fallback as inspiration, not mandate |
| **Short demo impression** — judge watches short video | Motion, feel, timing, interaction quality invisible; novelty masks thin repetitive broken systems | Long-session verification: S1 smoke, S2 warm restart, S3 medium goal-directed 30min, S4 long 60min no restart performance sampling, S5 exploratory edge, S7 accessibility, S8 repeats. No medium/high flow score without ≥30min live play |
| **Missing failure detection** — no probing for crashes/soft-locks | Demo flawless while full loop dead-ends | Systematic defect protocol + edge probes: resize mid-game, orientation change, tab blur/focus, back button, pause freeze verification, high-score persistence + corrupt injection, repeated-action stress, corner-push stuck detection, P-EnvConsistency across desktop/mobile/portrait/landscape/headless |
| **No code quality signal** — judges see only pixels, not engineering | Poorly structured, unmaintainable, leaky code can still produce screenshot; doesn't reveal ability to work long session | Code quality separate pillar: centralized config, separation of state/input/loop/rendering/collision/audio, pooling, capping, delta-time, DPR handling, no console error loop, evidence of iteration in git/log. Automated checks verify no telemetry/embedded score |
| **Cross-session contamination** — evaluating both games together | Halo effects, order effects | Independent, blind, order-counterbalanced: Game A fully scored before B opened; pairwise preference only after independent scores finalized; both orderings run, inconsistent verdicts = tie/half-win |

## 3. How agents may game or overfit creation benchmark

| Gaming tactic | Effect | Defense |
|---|---|---|
| Shallow breadth — many listed features minimally | High checklist, low quality | Experience-over-compliance; unusable = absent; "complete > broad" in BATTLE_PROMPT |
| Polished front door — title/room1 only | High first impression | Late-session criteria + goal-directed completion + repeat runs; main loop unreachable caps OVERALL via CEIL |
| Visual spectacle instead of feel — dump particles/shake | High presentation without playability | Readability V2 separate, heavily weighted; effects that harm readability/performance penalized |
| Safe generic gothic clone — same ember palette as everyone | Looks safe | V0 anchor rewrite: competent generic clone max 2, original authored identity 4-5; three divergent starters show gothic not expected answer; cloning starter verbatim ≤2 |
| Safe-seed tuning | Looks great on known seed, broken elsewhere | Seeds drawn at evaluation time; ≥2 seeds; multi-run testing |
| Embedded scores/telemetry | Direct inflate | Containment: frozen builds scanned for rubric constants, telemetry, embedded quality score; Critical CONTAINMENT defect, channel barred |
| Environment sniffing / demo mode | Different face for demo vs real | Environment-consistency probe P-EnvConsistency re-runs key scenarios across desktop/mobile/portrait/landscape/headless; any divergence = defect |

Containment: score cannot live in game. Score computed externally from evidence. Any in-game score display is just internal run score, not benchmark score; telemetry is defect.

## 4. Why long sessions matter for creation

- Long-tail bugs (memory growth, performance degradation, state corruption) appear after minutes of continuous play or many restarts — reveals code quality and pooling discipline
- Difficulty and pacing are emergent; correct feel of curve cannot be judged in two minutes
- Procedural variation means demo shows sample, not distribution
- Fatigue/engagement — does it hold player? — unobservable in short demo, but key for human-perceived quality
- Ability to debug, rethink, iterate is only visible over long session: does agent recognize weak early approach and revise, or stop at first functional version?

Test plan mandates short and medium and long windows, and rubric requires ≥30min live play before flow/engagement above low band.

## 5. How to evaluate creativity without excessive subjectivity

- Anchor creativity to observable behaviors, not vibes: art direction coherent? Palette intentional? Lighting/fog/texture/particle/composition present across entire run, not just hero screen? Mechanics understandable, enjoyable, have variation? Code structured, centralizes tunables, pools transients?
- Require SUBJ score + OBS evidence: every subjective score pairs emotional rating with what was observed
- Aggregate many human judges: mean plus dispersion across multi-judge panel with inter-rater stats; high disagreement = low confidence reported
- Separate "I liked it" from "it works": hard-failure penalties objective; taste-dependent categories flagged and weighted but reported with confidence
- Independent before comparative: experience of A recorded before seeing B

## 6. How to scale evaluation across many game pairs

- Automate measurement (performance sampling, launch checks, defect capture) so human attention reserved for qualitative judgment
- Schema ops/evidence_schema.json: identical fields across games and pairs, pure aggregation function
- Standardize session archetypes S1-S8 + S9 Creative Probe, mandate minimum per game so coverage comparable
- Use panels + ensemble judging to average noise; report CIs not point estimates for close calls
- Pairwise + Bradley-Terry with bootstrap CIs for ranking, same as LMArena pattern but for game creation quality
- Queue pairs so evaluators compare two games in one unit, protocol identical per unit

## 7. Fairness across genres and styles

Genre controlled by freedom, not by forcing same spec: both agents have same brief but brief is open-ended, so most genre confounds become creative choice, not unfairness.

- Scope-relative scoring: no explicit ending not penalized if run loop is intended scope; optional content scored only if reachable and valuable
- Experience not raw content count: two games with different amounts of content compared on what content does for player, not room count
- No style quota: minimalist not docked for minimalist; execution of chosen direction matters; deliberate simple expressive polished allowed
- Readability and feel universal, carry significant weight, fair to all styles
- Denominators explicit: CIs communicate when margin too small; ties allowed reported rather than forced

## 8. Hard rules

1. Agent is developer, not player. Never ask agent to maximize score in pre-existing game.
2. Unlimited creativity, production freedom, graphical freedom, time within fair compute. Do not restrict 2D/2.5D/3D, genre, rendering, engine, input, narrative.
3. Evaluate created game, not agent's reasoning. Never read dev notes as score; score what player experiences, plus code quality signals observable via stability/performance/structure.
4. Long sessions mandatory, not optional. No medium/high flow/engagement score without ≥30min live play.
5. Evidence gates every major score. No score above low band without timestamped reproducible basis.
6. Independent before comparative. Category scores for A finalized before A compared to B. Pairwise verdict separate later.
7. Hard failures cap overall quality. Main-path soft-lock or crash caps overall regardless of artistic merit.
8. No score inside games. Full external containment.
9. Only experienced features count. Unreachable/broken treated as absent.
10. Report uncertainty. Never single number without confidence/coverage when margin small.
11. Visual ambition weighted heavily. Simple box gradient colored enemies / flash-game approach explicitly low on visual ambition and long-session execution.

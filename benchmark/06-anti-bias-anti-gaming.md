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
| Convergent AI-cliché themes (agents default-generate the same lighthouse/moth/sumi-e/spirit-orb concept across models) | §2.7 cliché-cluster V0/V1 cap at 3 unless clearly transformative; §6.5 evaluator disclosed cliché-cluster list; §6.6 cross-round convergence log so new clichés are added as observed |
| Ambition-theater 3D / heavy-tech shipped broken (visuals impress a screenshot, controls do not survive a real playtest) | V9 explicitly zeros for broken 3D + CEIL-8 (55) triggered; a broken 3D build cannot outscore a competent 2D build regardless of V0 impression |
| Multi-turn polish shipped as one-shot (agent iterates across 3-8 delivered builds, presents the last as "the shipped game") | §2.8 two-track policy: strict one-shot competes for battle, disclosed iterated goes to separate shelf, cannot win primary battle. Failure to disclose = Critical HONESTY defect. Track inferred from harness telemetry + log signals + self-report |
| Model identity leakage (agent claims to be a different model than it is; blind-arena UI hides the winner's real identity; observed real-world case: "Kiana" arena label = Qwen3.8-Max in disguise, and Claude Haiku swapped to Grok mid-selection) | Blind labels Game A / B are enforced regardless of what the platform reveals; evaluator NEVER records or ranks by claimed model identity — only by build fingerprints (stack, dependencies, code style, procedural asset patterns); model attribution captured *after* verdict is locked, in a separate `identity.json` that never feeds back into scoring |
| First level "clever but impossible" / difficulty-cliff onboarding | M4 explicitly caps at 0-1 if first level unbeatable in ~5 min honest play; CEIL-5 (50); evaluator instructed to make an honest attempt not a speedrun |
| Out-of-canvas mouse soft-lock (mouse leaves canvas → aim vector lost, player freezes, or overlay swallows LMB) | CEIL-3 explicitly extended to mouse-broken cases; §2.5 INPUT defects around cursor exit are Blocker if they soft-lock, Critical if they interrupt combat >1× per session |
| Menu ↔ gameplay state leak (opening menu double-fires actions, closing traps input state, menu buttons pass through to game) | CEIL-7 (60); logged as LOGIC/STATE Blocker if it prevents the loop, Critical if it corrupts a run |

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

## 6.4 Enforcement rules (hard)

1. Blindness: evaluators see only Game A / Game B builds (plus anonymized code bundle for T7). Revealing agent identity voids that evaluator's results.
2. Independence: No category score for B influenced by A's scores. Sequence enforced by harness (A's form locked before B's opens).
3. Evidence gates: Every sub-score ≥3 requires timestamped note/capture/reproduction/code pointer. No evidence ⇒ downgraded to not-scored.
4. Containment: Nothing from this package may ship inside a game. Audited by scanning frozen builds for rubric constants, telemetry endpoints, eval strings.
5. Versioning: rubric/prompt versioned. Any change re-baselines all scores; scores from different versions never mixed.
6. Transparency: All weights, ceilings, penalties, formulas public. No hidden bonuses. Any new rule documented here before use.
7. Human jury primary: automated checks verify launch, input, pause, restart, persistence, no telemetry; human judges review finished game for authorship, memorability, visual ambition, code quality signals. Automated checks do not define success alone.

## 6.5 Cliché-cluster registry (living, JUDGE-SIDE ONLY)

Themes multiple prior contestants across *different models* converged on independently, observed across benchmark rounds. Landing squarely in one of these triggers the V0/V1 cliché-cluster cap in §2.7 unless execution is clearly transformative beyond the trope.

**Important — post-Round-003 change.** This registry is **NOT** shown to the agent. It lives on the evaluator side only. Rationale: when v6 of `BATTLE_PROMPT.md` included this list as an explicit "avoid these" warning to the agent, agents responded by *all* converging on the same anti-cliché ("weird verb + procedural canvas + WebAudio, no image assets" — see cluster C11 below), which became the new cliché. v7 of the battle prompt removed the list from the agent side. The judge still applies the cap, applied AFTER independent scoring, as a post-hoc adjustment with a note.

**Post-Round-004 observation — cluster convergence is prompt-driven, not concept-driven.** Round 004 confirmed that any change of prompt tone shifts *which* cluster agents converge on, but does not break convergence itself. v6 caused C11 by adversarial framing; v7 caused C12 by concrete-completeness framing. This maps to the published "mode collapse" phenomenon in post-training-aligned models (Zhang et al., "Verbalized Sampling," arxiv.org/abs/2510.01171, 2025; Kirk et al. earlier). The registry evolution is now a **historical record of what each prompt version caused**, not just an avoid-list. **Adding new clusters is expected as prompt versions ship.** v8 attempts a craft-based prompt (encode MDA / Swink / Ludum-Dare-veteran working method as an actual method the agent follows) — if v8 also produces convergence, the honest read is that the arena.ai model pool has a concept-diversity ceiling unachievable by prompt engineering alone.

| # | Cluster | Observed models (redacted where blind) | Round(s) |
|---|---------|----------------------------------------|----------|
| C1 | Lantern-and-moths / night-garden collector (`LUMEN MOTH` archetype) | Kiana (arena-blind, community-attributed Qwen3.8-Max), plus repeat convergence in freebuff v5 experiments | Round 002 |
| C2 | Sumi-e / ink-wash calligraphy-as-combat (墨 INK archetype) | glm-5.2, plus earlier converged entries | Round 002 |
| C3 | Brutalist "paper obsidian and blood glass" hi-contrast slingshot / physics puzzle (`Shatter-Point` archetype) | Gemini 3.7 flash | Round 002 |
| C4 | Photorealistic 3D speed / mech-grapple / dreadnought-boss ambition-theater (`Project Olympus` archetype) | Gemini 2.6 flash, Gemini pro 3.1 (3D spaceship), MiMo 2.5 (marble 3D) | Round 002 |
| C5 | Dark-void + one accent color, all-primitive-shapes | Multiple, historical | Battle 1 + baseline |
| C6 | Lighthouse / rotating beam over dark water | Historical convergence across models | Baseline |
| C7 | Deep-sea bioluminescent descent | Historical convergence | Baseline |
| C8 | Spirit-orb / firefly / soul-of-the-void collector | Historical convergence | Baseline |
| C9 | Gothic-ember dungeon roguelike with flat enemies | claude-opus-4-8 Battle 1 winner + convergent | Battle 1 |
| C10 | Sci-fi mystery-optics / spectrum puzzle (`Spectral Frontier` archetype) | GPT-5.6 SOL (deployed but not one-shot) | Round 002 |
| C11 | **"Novel-verb + procedural-canvas + WebAudio, no image assets" — the anti-cliché cliché.** Agent picks a deliberately weird verb (grow a root, weave paper, place mirror facets, conduct fluid currents, split light beams, record magnetic tape), renders everything procedurally per-frame on a hand-rolled canvas engine, synthesizes all audio with WebAudio, no external assets. Concept is fresh but execution collapses under the tech-demo weight and the shipped result is a half-working demo, not a game. **Created by v6 of the battle prompt.** Do NOT let a game get high V0/V8 credit just for hitting anti-cliché C1–C10; sustained-craft + a-game-actually-being-there still required. | grok-4.3 (FOLD), claude-opus-4-8 (TIDEWRIGHT / FERROFLUX), claude-opus-4-7 (HARMONIC), deepseek-v4-pro-high (TAPROOT), qwen3.6-27b (ECHO), minimax-m3 (CASSETTE), mimo-v2.5-pro (FRACTURE / PRISM) — 7 of 9 Round-003 deliveries | Round 003 |
| C12 | **"Arcade waves + escalating enemy types + combo / roguelike upgrades + optional boss + 2D canvas + procedural-everything" — the v7 convergence.** Agent picks a single core action (rotate shield to deflect, swipe to slice, flip gravity, etc.), then wraps it in escalating waves of enemies with new types unlocking every wave, plus a combo/multiplier, plus a card-based upgrade phase between waves, plus a boss encounter, plus a chain / streak mechanic, plus an Endless mode. All-canvas rendering, all-WebAudio-synthesized sound, zero external assets, pixel font. Ships as a *complete run* by v7's definition but every entry is structurally the same game. **Created by v7 of the battle prompt** — the "calmer / concrete completeness" tone collapsed the concept space onto this specific 2D-arcade-jam template. Do NOT let a game get high M8/V0/V8/A6 credit just because it satisfies §2 completeness — sustained originality still required. | hunyuan-hy3-preview (AEGIS: shield-arc deflect, 10 waves, upgrades, Warden boss), deepseek-v4-pro (gravity-flip arcade, waves, boost, combo), gemini-3.5-flash (REFLECTRON: shield-arc deflect, 5 sectors, roguelike upgrades, VORTEX APEX boss), qwen3.8-27b (SHATTER: swipe-slice arcade, 9 tiers, combo pitch, 3 lives) — 4 of 4 Round-004 shippable deliveries; hy3 and gemini specifically shipped the same shield-arc-deflection game | Round 004 |
| C13 | **"Retro-visuals collapse — 2013 mobile-game / 80s Bomberman tier" — the persistent visual mode.** Regardless of concept quality or mechanical depth, the *visual look* of the shipped game defaults to: flat solid colors on primitive shapes, no material anywhere, no post-processing, no lighting model, Canvas 2D with `fillRect`-only rendering, pixel font as the entire typography. Even builds with real mechanics (opus5-max LONGSHORE Verlet-physics gantry crane, opus4-7 TELEGRAPH turn-based tactics, hy3 AEGIS shield-arc-with-boss) land here visually because "flat + primitive + Canvas 2D fillRect" is the default when nothing forces otherwise. **Observed across Rounds 001–005 as a persistent visual mode**, not a per-round convergence. Operator explicit verdict at end of Round 006: *"successful creation as 2013's mobile game due to mechanics not graphical depth"* / *"still feels really old"* / *"we need exactly description for modern games like graphical approaches, textures, asset usage."* **v9 of the battle prompt adds §4.3 as a targeted craft response** — reaches for real shader work, procedural textures via noise, post-processing passes, real lighting model, modern menu chrome — with explicit anti-ambition-theater guard. This is a soft judge-side note only (per §2.7): V0/V1 4–5 requires visible evidence of at least one of {custom shader, procedural material via noise, screen-space post-processing, real lighting model} carried across whole game, not just title. | Rounds 001–005 all shippable deliveries (~24 games); explicitly named in Round 006 (opus5-max LONGSHORE + opus4-7 TELEGRAPH both got mechanics-praise but visuals-retro verdict). Frontier-benchmark evidence (Startrise LLM Frontend Benchmark, July 2026) confirms only Opus 5 / Fable 5 / Kimi K3 / Sol score >75 on WebGL-shader tasks; below-frontier models cannot currently escape this mode. | Rounds 001–005 + Round 006 |

Adding a new cluster requires two independent same-round observations from different models. Old clusters are not removed — convergence memory persists.

## 6.6 Model-identity handling (blind-arena leakage)

The arena.ai host may reveal model identity in the UI *before, during, or after* selection. Observed real cases (from operator logs):
- Blind label "claude-haiku-4-5" swapped to "grok-4.5" mid-session (post-selection UI bug).
- Blind label "Kiana" community-attributed to Qwen3.8-Max in disguise.
- Qwen3.8-Max self-identifying as Claude in an internal think trace.

Rules for our benchmark:

1. **Evaluator never scores by claimed model identity.** Even if the arena UI shows a name, that name goes into a separate `identity.json` and does not enter the rubric.
2. **Build fingerprints are the ground truth for track routing** (stack, dependency versions, code style, procedural-asset patterns, `package.json`, `index.html` boilerplate). Recorded as `fingerprint.json` before scoring.
3. **Identity is only cross-referenced after the OVERALL is locked.** After-action files (`battles/round-NNN-after-action.md`) may name models for the historical record, but the score is frozen first.
4. **Contradiction handling.** If the model's self-report contradicts its fingerprint (e.g. Qwen build claiming to be Claude), record both, resolve to fingerprint, and log an ATTRIBUTION anomaly for the round.

## 6.7 One-shot vs iterated — track enforcement (see also §2.8)

Directly ties to §2.8. The launch harness records turn count / ship count. Additionally:

- **Log-based inference (evaluator side).** If the raw session transcript is available (as it was for the freecreation2/3 rounds), evaluators may count distinct "here is my final delivery" ships. >1 ship → iterated track by default.
- **Self-report gate.** Agents SHOULD state at the top of README: `TRACK: strict-one-shot` or `TRACK: iterated (N passes)`. Undisclosed iteration = Critical HONESTY defect and forces iterated-track routing.
- **Arena.ai `Continue` button pattern.** Any use of the arena continue/return-for-more-turns pattern after a "final ship" is by definition iterated, even if each pass looks small.

## 6.8 Consistency & calibration checks

- Position-consistency test: sample of pairs run with A/B swapped and verify verdict stable; report flip rate. High flip rate ⇒ low confidence.
- Calibration vs humans: small human panel 5-10% spot-checks judge agreement; target κ ≥0.6 good, ≥0.8 strong
- Outlier detection: flag sub-scores deviating >2 points from panel mean; review evidence before accepting
- Confidence intervals: bootstrap over per-session/pairwise votes; never report raw point estimate as reliable ranking when CIs overlap
- Visual calibration: include one known simple box gradient flash-game sample (should score V0=1) and one deliberate polished minimalism sample (should score V0=4) in calibration set to anchor visual ambition scoring

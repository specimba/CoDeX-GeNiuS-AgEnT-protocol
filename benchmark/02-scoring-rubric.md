# 02 — Formal Scoring Rubric

Transparent, evidence‑gated, multi‑criteria rubric. Every category is the weighted mean of
explicit sub‑criteria (each 0–5 with behavioral anchors), so a single number is auditable
back to observed behavior. No hidden bonuses. No score for features not experienced. No
double‑counting defects.

## 2.1 Scoring language

Each sub‑criterion is scored on an integer 0–5 scale:

| Score | Anchor |
|------:|--------|
| 0 | Absent, broken, or **not experienced** (treat as absent). |
| 1 | Poor — present but actively harms play. |
| 2 | Below average — clearly weak or unreliable. |
| 3 | Adequate — functional, meets minimum, unremarkable. |
| 4 | Good — above average, well executed. |
| 5 | Excellent — among the best; memorable positive. |

**Evidence rule.** A sub‑score ≥ 3 must have a timestamped note / capture / reproduction
steps. A sub‑score 0–1 must state whether it was *absent/broken* or *not experienced*.
Any sub‑score that cannot be supported is downgraded to "insufficient evidence" and treated
as not scored (excluded from the category mean, and the category marked PARTIAL‑COVERAGE).

**Subjectivity rule.** Sub‑criteria with a `SUBJ` tag are taste‑dependent; they must pair an
emotional rating with a behavioral observation (`SUBJ` score + `OBS` evidence). Their
weight is lower and they are reported with dispersion.

## 2.2 Categories, weights, and sub‑criteria

Category score = `round( mean(sub_criteria) × 2, 1 )` → 0–10.

### T — Technical Stability · weight 20%
| # | Sub‑criterion | SUBJ |
|---|---------------|------|
| T1 | Cold launch & fresh‑load reliability (no crash/blank/console‑loop on load) | |
| T2 | Crash / freeze / runtime‑error frequency during normal play | |
| T3 | Restart & state reset integrity (instant restart, run state fully reset) | |
| T4 | Persistence reliability (high scores saved/loaded; corrupt‑storage handled) | |
| T5 | Input responsiveness & frame‑rate independence (buffering, focus/visibility safety) | |
| T6 | Performance consistency over time (FPS stability, jank, memory growth, high load) | |
| T7 | Environmental robustness (resize, orientation, tab blur, DPR) | |

### M — Core Mechanics · weight 18%
| # | Sub‑criterion | SUBJ |
|---|---------------|------|
| M1 | Clarity of rules & learnability of the core combat loop | |
| M2 | Game feel & responsiveness (hit‑stop, shake, input buffering, timing) | SUBJ |
| M3 | Mechanical depth & variety (emergence, viable approaches, not one‑trick) | |
| M4 | Balance & fairness (no unfair kills; timing windows fair; scaling sane) | |
| M5 | Meaningful player choice & agency (risk/reward, tactical decisions) | |
| M6 | Feedback quality (intent telegraphs, damage numbers, hit/miss/crit, sounds) | |
| **M7** | **Architecture & performance hygiene** — gameplay loop lives outside React re-renders; no per-frame React churn; delta-time simulation; object pooling; clean separation of loop/UI. | |

### G — Gameplay & Player Experience · weight 18%
| # | Sub‑criterion | SUBJ |
|---|---------------|------|
| G1 | Onboarding & tutorial quality (understand goal in first minute, no manual needed) | |
| G2 | Clarity of goals & progression (know what to do, why, where) | |
| G3 | Reward structure & motivation (coins, relics, upgrades feel earned & impactful) | |
| G4 | Challenge curve & pacing of difficulty | |
| G5 | Variety of encounters/activities (enemy mix, room types, events, boss) | |
| G6 | Fun & sustained engagement / replayability | SUBJ |

### F — Game Flow & Coherence · weight 14%
| # | Sub‑criterion | SUBJ |
|---|---------------|------|
| F1 | Quality of the first 5 minutes | |
| F2 | Quality of the first 30 minutes | |
| F3 | Mid‑session pacing & sustained interest | SUBJ |
| F4 | Transitions between activities (rooms, floors, states, menus) | |
| F5 | Absence of repetition, padding, and dead time | |
| F6 | Coherence of the end‑to‑end experience (beginning → complete run) | |

> **Flow gating.** No F3/F6 score above 3 without ≥30 min of live play evidence. If a game
> has no explicit ending, F6 is scored on completing its intended run loop on the run's own
> terms (not penalized for lacking a credits screen).

### V — Visual & Presentation · weight 12%
| # | Sub‑criterion | SUBJ |
|---|---------------|------|
| V0 | **Graphical originality, visual richness & complexity** — how original and how sophisticated/detailed the visuals are. Rewards a distinctive identity and real artistic/technical complexity (procedural gothic detail, layered lighting, rich surfaces); penalizes generic geometric shapes, plain colored rectangles, empty rooms, or visual sameness. Must be sustained across the whole game, not a single hero screen. | SUBJ |
| V1 | Art direction & visual coherence (gothic dark identity, consistent palette) | SUBJ |
| V2 | Readability of gameplay entities under combat (attacks, hazards, player, rewards) | |
| V3 | Animation & juice quality (squash‑stretch, trails, afterimages, particles) | |
| V4 | Lighting, atmosphere, effects, depth (fog, vignette, layered) — without clutter | SUBJ |
| V5 | UI clarity & polish (menus, HUD, legibility, no broken buttons) | |
| **V6** | **Rendering robustness & graceful fallback** — WebGPU/WebGL/Canvas2D degrades safely; no white screen, no crash, no environment-dependent visual breakage. | |
| **V7** | **Visual consistency across environments & runs** — same scene coherent on desktop/mobile/portrait/landscape and at different DPRs; no clipped UI, overlap, or broken layout on resize/orientation change. Same identity holds across seeds. | |

> **V6 anchors (0–5).** 0 = white screen / crash / no fallback. 1–2 = one backend only, breaks on some devices. 3 = works on one backend consistently. 4 = graceful WebGPU→WebGL→Canvas2D with consistent appearance. 5 = fully robust across backends, viewports, and DPRs with no visual divergence.
>
> **V7 anchors (0–5).** 0 = broken layout on any viewport; identity varies wildly. 1–2 = partial consistency, some overlap/clipping. 3 = coherent on desktop and mobile separately, minor differences. 4 = same coherent identity across viewports and DPRs; minor safe differences only. 5 = perfect cross-environment consistency with identical gameplay readability.

> **V0 anchors (0–5).** 0 = no visuals/placeholder. 1–2 = basic primitive shapes, flat
> colors, little to no visual identity. 3 = coherent but simple/derivative; recognizable
> theme, minimal detail. 4 = genuinely original, detailed, and consistent; strong
> artistic identity with visible craft. 5 = near‑commercial level: rich procedural detail,
> confident composition, distinctive and beautiful across the entire run. V0 rewards
> *originality and complexity*, not raw effect count — effects that hurt readability are
> penalized under V2.

### A — Atmosphere & Immersion · weight 10%
| # | Sub‑criterion | SUBJ |
|---|---------------|------|
| A1 | Mood & emotional impact | SUBJ |
| A2 | Audio & music quality (sounds fitting, music integrates with intensity) | |
| A3 | Environmental storytelling & sense of place | SUBJ |
| A4 | Thematic consistency (mechanics, visuals, terms, lore cohere) | |
| A5 | Ability to sustain immersion (no jolts/breaks that destroy the mood) | SUBJ |

### X — Accessibility & Inclusion · weight 8%
| # | Sub‑criterion | SUBJ |
|---|---------------|------|
| X1 | Keyboard menu navigation & visible focus states | |
| X2 | Reduced‑motion mode actually reduces shake/flash/particles | |
| X3 | High contrast & non‑color‑only information encoding | |
| X4 | Touch/desktop responsiveness & safe areas / text legibility at small sizes | |
| X5 | Audio failure does not block gameplay; sound toggle present | |

## 2.3 Aggregation

```
CATEGORY_c  = round( mean(sub_criteria_c) × 2 , 1 )            # 0–10
OVERALL_raw = Σ_c  WEIGHT_c × CATEGORY_c                        # 0–100 (weights sum to 100)
```

**Hard‑failure penalty.** Compute the penalty from the defect register (each defect counted
once; see §2.5 for what counts):

```
HARD_PENALTY = (blocker_count × 6.0) + (critical_count × 4.0)
HARD_PENALTY = min(HARD_PENALTY, 30)                            # cap so it can't zero a score
OVERALL_adj  = max(0, OVERALL_raw − HARD_PENALTY)
```

**Ceilings override** `OVERALL_adj` (take the minimum):

| Ceiling | Value | Trigger |
|---|---|---|
| CEIL‑1 | 55 | Reproducible main‑path crash or soft‑lock (progress blocked, no recovery but full restart). |
| CEIL‑2 | 65 | Main completion loop cannot be completed (victory/ending or intended run loop unreachable). |
| CEIL‑3 | 60 | Core controls unresponsive/broken on >30% of deliberate attempts (primary input path). |
| CEIL‑4 | 70 | Persistence fails on a fresh normal browser (data lost on reload, no error condition). |

Final: `OVERALL = min(OVERALL_adj, applicable ceilings)`, then `round(OVERALL,1)`.

## 2.4 Pillar scores (for reporting, not the headline)

These separate creative quality from reliability, per the arena requirement.

```
TECHNICAL_RELIABILITY   = round( 0.70×CATEGORY_T + 0.30×(100−normalized_hard_failures) , 1 )
                          # normalized_hard_failures = min(100, HARD_PENALTY/30×100) as a 0–100 defect index
CREATIVE_PRESENTATION   = round( 0.45×CATEGORY_V + 0.40×CATEGORY_A + 0.15×CATEGORY_X , 1 ) ×10
GAMEPLAY_SCORE          = round( 0.50×CATEGORY_M + 0.50×CATEGORY_G , 1 ) ×10
FLOW_ENGAGEMENT_SCORE   = round( 0.60×CATEGORY_F + 0.20×CATEGORY_A + 0.20×CATEGORY_G , 1 ) ×10
DEFECT_SEVERITY_SCORE   = round( max(0, 100 − HARD_PENALTY − (minor_count×0.5) − (trivial_count×0.1) ) , 1 )
```

> The headline `OVERALL` is the canonical comparison number. Pillars are reported to answer
> "which is more technically reliable" vs "which is the better overall game."

## 2.5 Defect severity & no‑double‑counting

| Severity | Examples | Hard‑failure weight |
|---|---|---|
| **Blocker** | main‑path soft‑lock; unreachable finish; control unusable; core loop cannot proceed | counts toward HARD_PENALTY and ceilings |
| **Critical** | crash, save/HS loss, major mechanic broken, accessibility path broken | counts toward HARD_PENALTY |
| **Major** | secondary feature broken, needs workaround, significant immersion break | penalty via category scores only |
| **Minor** | cosmetic glitch, occasional jank, minor readability | penalty via category scores + 0.5 in DEFECT_SEVERITY |
| **Trivial** | nitpick, negligible | 0.1 in DEFECT_SEVERITY only |

**No‑double‑count rule.** Every defect is logged exactly once in the register and counted
once. Category scores already reflect the experienced quality (so a Major visual bug lowers
V, a broken mechanic lowers M/G). The `HARD_PENALTY` is applied **only** for Blocker and
Critical defects — the failures that are objective brokenness rather than taste — so a
single defect is never subtracted twice from the same score. Minor/Trivial defects affect
the `DEFECT_SEVERITY_SCORE` and their category, not `OVERALL`.

## 2.6 Transparency requirements

- Weights are fixed and public (`T20 M18 G18 F14 V12 A10 X8`).
- No hidden bonuses; no credit for unexperienced features.
- Report `PARTIAL‑COVERAGE` categories when any sub‑criterion was not experienced.
- Report confidence level per game and per pairwise verdict (see `05` and `07`).
- Distinguish hard failures (objective) from subjective weaknesses (flagged `SUBJ`).

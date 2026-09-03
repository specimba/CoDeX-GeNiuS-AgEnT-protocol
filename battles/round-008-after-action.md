# Battle Round 008 — After-Action Record

**Status:** informal / directional. Not a formal S1–S8 scored round.
**Source:** operator-pasted v10 battle log (2 model sessions, 1 battle) — `qwen3.6-27b` + a hidden model.
**Operator:** specimba
**Recorded by benchmark:** 2026-08-23 (Ankara)
**Prompt version active during observations:** BATTLE_PROMPT **v10** (the v9 + sensory-modality-trap + audio-de-escalation prompt shipped after Round 007)

---

## 1. Summary

Round 008 was the v10 field test. It produced the **single most diagnostically important result in the benchmark's history**: both agents — in a pool with **no frontier (opus-tier) model** — independently copied a concrete phrase out of v10's own prompt and shipped the same game. The convergence was not on sound (C14, which v10 successfully broke) but on **crane / pendulum-damping** — a concept v10 had *recommended by example*.

This is the first cluster (C15) proven to be caused by the prompt's **positive examples**, not its avoid-list. It confirms, five cycles in, that the prompt cannot name any concrete concept — whether to warn against it or to point toward it — without that concept becoming the next convergence.

**v11 ships in this same commit as the narrow fix:** remove every named concrete concept from §1.4 and §4.4, keep the §4.4 situation-vs-sense *principle*, and add an explicit "this prompt deliberately gives no examples because examples cause convergence" rule.

## 2. Games observed

| Battle | Model | Game | Concept origin |
|:---:|---|---|---|
| B1 | **hidden** | **SLEW** — harbor gantry crane; damp pendulum, land cargo in hold, 8 escalating shifts | design notebook: *"Dock-crane pendulum — damp swing"*; also listed *"Blacksmith bloom — heat color, hammer rhythm, quench timing"* |
| B1 | **qwen3.6-27b** | **IRON SKELETON** — construction crane; damp pendulum to place beams, build skyscraper floor-by-floor | design notebook: *"Damp a swinging load — Crane operator fighting pendulum physics"*; also listed *"Heat and metal — Blacksmith timing"* |

Both notebooks show the v10 §1.4/§4.4 language working as designed *and* as a contaminant: both explicitly crossed out *"entire sonar/frequency/radio family"* and *"pure sensory-modality pitches"* (v10's C14 fix **worked**), then both picked the crane verb — the exact phrase v10 §1.4 had offered as a "good" example.

Operator question (verbatim): *"Why do both AIs create a crane game? again and again. I read the battle prompt, which section makes this consistent with this idea constantly. And this time, there is no opus."*

## 3. Root cause — the exact phrases (the answer to the operator's question)

The culprit is two **concrete positive examples** in v10:

- **§1.4:** *"…is my scary verb about a situation in the world (**forge metal, damp a swinging load, cut a rot before it spreads**), or is it about a sense (ping, tune, decode)?"*
- **§4.4:** *"…pick a verb that is about a situation in the world, not about a sense. **Heat-and-metal. Weight-and-balance. Growth-and-decay. Debt-and-trust.**"*

Both agents copied *"damp a swinging load"* → both shipped pendulum-crane games. Both also surfaced the blacksmith (*"forge metal" / "Heat-and-metal"*) example in their notebooks. The verbatim match is conclusive: the prompt's own words became the agents' concepts.

### Why this is "again and again" — the five-cycle arc
Every version's concrete prompt element has seeded the next cluster:

| Cluster | Caused by | Prompt element |
|---|---|---|
| C11 | v6 | the agent-visible **avoid-list** (banning C1–C10) |
| C12 | v7 | the **completeness framing** (arcade-waves-with-combo) |
| C13 | v8 | the **persistent visual default** (no §4.3 yet) |
| C14 | v9→v10 | the **audio emphasis** priming the sound modality |
| **C15** | **v10** | **the positive examples** ("damp a swinging load", etc.) |

The invariant: **named instances are attractors.** Avoid-lists and pick-lists are the same disease — both hand the agent a concrete concept to copy.

### "This time there is no opus" — why it mattered
Frontier (opus-tier) models had been the ones producing divergent, stronger games (GATHER glassblowing, LONGSHORE crane, the wave sim). Remove them and the remaining pool (qwen3.6-27b + a hidden model) copied the prompt example **verbatim, both agents, same round**. This is the cleanest evidence yet for the R005 §5 finding: **on the current arena.ai pool, below-frontier models converge onto prompt anchors harder than frontier models do.** Concept diversity is partly pool-bounded, not purely prompt-tunable.

## 4. What v11 changes (the narrow fix)

Per the R005 §5 / R006 §5 anti-spiral discipline: **v11 is v10 with the examples excised, not a rewrite.**

1. **§1.4 — concrete parenthetical examples removed.** The "(forge metal, damp a swinging load, cut a rot)" and "(ping, tune, decode)" lists are gone, replaced by a structural description (a process that transforms / a relationship under tension / a physical task with mass-timing-material vs. a sensory modality). Added: an explicit **"this brief deliberately gives you no named example games or verbs — not here, not anywhere"** paragraph that tells the agent *why* (named concepts cause convergence) and tells it to generate candidates from its own taste.
2. **§4.4 — "Heat-and-metal. Weight-and-balance. Growth-and-decay. Debt-and-trust." removed.** The situation-vs-sense *principle* stays; the named instances go. Added a **"warning about this very section"** that narrates the Round-008 crane failure so the agent understands examples are forbidden on purpose, and warns against reaching for "the kind of thing this benchmark is asking for."
3. **Negative-space principle stated.** v11 is the first version that describes only structural properties and names no instances. This is the operational form of the five-cycle lesson.

### What did NOT change
- §1 craft method (MDA / Swink / Vlambeer / Porpentine / Ludum Dare) — still working
- §2 run shape, §3 10 gates, §4.1/§4.2/§4.3, §4.4 principle, §5 session pattern, §6 self-QA, §7 deliverables — unchanged
- The §1.4 **avoid-list** (neon-void, sonar/frequency family, etc.) is **kept** — it is defensive (pushes away) and Round 008 proved it works (both notebooks crossed out sonar). The C15 failure was specifically the *positive* examples, which are now gone.
- The §3 audio robustness gate, CEIL-9, CEIL-5 broadening, all Round-007 defect work — unchanged.

## 5. The deeper, irreducible attractor (honest caveat)

Even after removing every named concept, two structural pulls remain that the benchmark **cannot** remove without gutting its craft teaching:

1. **The cited craft tradition itself.** §1.2 quotes Swink (*"real-time control first, predictable simulated space second"*) and Vlambeer. That framing inherently favors **physics-feel verbs** — which is exactly why crane/pendulum games recur across R006 (LONGSHORE), R007 (opus5-high container), and R008 (both). Crane is not only an example-contamination; it is also the *canonical* "predictable simulated space" game.
2. **The "verb-about-the-world" remedy.** §4.4's own remedy (a physical task with mass/balance/timing/material) structurally points at craft/physics/skill games. Removing the *names* does not remove the *category pull*.

So the honest expectation for Round 009: v11 should stop the **verbatim-copy** convergence (no more identical crane games from a shared phrase), but a **category-level** pull toward physics-feel/craft verbs may persist because it is baked into the craft tradition the benchmark teaches. If Round 009 still shows two physics-feel craft games, that is the irreducible ceiling — not a prompt bug. The fix for that would be diversifying the **cited craft tradition** (add narrative/economy/caretaking design voices, not only Vlambeer/Swink), which is a v12 question, not a v11 one.

## 6. Recommended Round 009 experiment

Ship v11. One round of observational data. Look for:

1. **Does the verbatim-copy convergence stop?** No two agents should ship the identical concept from a shared prompt phrase, because there are no shared phrases. This is the v11 success criterion.
2. **Does a category-level physics-feel/craft pull remain?** Expected yes (see §5). If two agents ship different physics-feel games (different verbs, not the same crane), v11 succeeded at the instance level even if the category persists.
3. **Does a frontier model in the pool diverge from a non-frontier one?** If Round 009 includes an opus-tier model, test whether it spreads to a non-physics concept while the weaker model still gravitates to craft verbs. That would isolate the pool-bounded vs prompt-bounded contribution cleanly.
4. **Watch for C16.** If removing examples causes a new failure (e.g., agents flail with no anchor and ship broken/unfinished games), the negative-space principle is too austere and v12 re-introduces *structural* (not instance) scaffolding. But do not re-introduce named concepts under any circumstances — that is the proven failure mode.

## 7. Files changed this pass

| Path | Change |
|------|--------|
| `challenge/BATTLE_PROMPT.md` | v10 → v11 header. §1.4: concrete example parentheticals removed, "no named examples" rule added. §4.4: "Heat-and-metal / Weight-and-balance / Growth-and-decay / Debt-and-trust" removed, deduplicated to a tight "names no example verbs — anywhere" pointer back to §1.4. §4.4 principle + everything else unchanged. Size 22.5 KB (under 23 KB ceiling; raised from 22 KB for the negative-space rule — tone stays calm, no exhaustive list, so the R003 size-overreach risk does not apply). |
| `benchmark/06-anti-bias-anti-gaming.md` | New cluster **C15** (positive-example convergence) in §6.5 with the verbatim-copy evidence. New §6.2 anti-gaming row: positive-example priming. §6.5 closing note updated with the five-cycle arc (C11→C15) and the negative-space principle. Audio-bias row updated to "CONFIRMED in R008 (C14 broken)." |
| `BATTLE_2_ENTRY.md` | v11 headers; scoresheet cliché list C1–C15; Part 5 sanity greps rewritten (24 OK lines) with **regression guards** that fail if "damp a swinging load" or "Heat-and-metal" re-appear in the prompt. |
| `README.md` | Battle log row for Round 008 added (Round 008 plan row converted to actual); Round 009 plan row added. |
| `expert_team/CONSENSUS.md` + `ORCHESTRATION.md` | Round 008 parallel expert-role analysis recorded. |
| `battles/round-008-after-action.md` | (this file) |

## 8. What is deliberately NOT changed (protecting against overcorrection)

- **No new CEIL, no new hard gate.** C15 is a concept-diversity finding, not a reliability defect. It is a soft judge-side note (§2.7), exactly as C13 is.
- **The §1.4 avoid-list is kept.** It is defensive and proven-working (Round 008 crossed out sonar). Only the *positive* examples were the failure.
- **The craft tradition citations (Swink/Vlambeer/MDA) are kept** despite their physics-feel pull — removing them would gut the craft teaching and is a v12 question if category-pull persists in R009.
- **The §4.4 situation-vs-sense principle is kept.** It broke C14. Only its concrete illustrations were the contaminant.

# v12 Merge — Design Record

**Status:** proactive prompt revision (no new battle data). Operator proposed an alternative "2026 Creative Battle Prompt"; analysis + merge decision recorded here.
**Operator:** specimba
**Recorded by benchmark:** 2026-08-23 (Ankara)
**Replaces:** BATTLE_PROMPT **v11** (negative-space prompt)
**Decision:** **merge** (not adopt wholesale, not reject) → BATTLE_PROMPT **v12**

---

## 1. What the operator proposed

A full alternative "2026 Creative Battle Prompt" emphasizing: visual ambition (WebGPU, shaders, lighting, fog, post-processing), format breadth (first-person, 3D, exploration, WebGPU showcase, narrative, procedural worlds), discovery/atmosphere/sense-of-place/narrative as core design expectations, a 12-category scoring rubric, and an optional contest rule: *"Why does this experience need to exist in interactive form?"*

Its stated intent directly targets the operator's standing complaints across Rounds 002–008: retro / "paper-cutout" visuals (C13), shallow "first-era-smartphone" mechanics, and sameness.

## 2. The honest strengths (why this is worth merging, not dismissing)

- **Strongest visual-ambition lever in any version.** WebGPU/shaders/lighting/fog/post-processing/procedural-materials get heavy, explicit treatment — a far harder push against C13 ("paper-cutout / 2013 mobile") than v9 §4.3 or v11 made. After 8 rounds of retro visuals, this is the lever the operator has been asking for.
- **Format breadth.** Explicitly legitimates 3D, first-person, simulation, narrative, exploration — attacks "first-era-smartphone" mechanical shallowness and the 2D-arcade rut the pool has been in.
- **The contest question is excellent.** *"Why does this experience need to exist in interactive form?"* is the sharpest authorial-intent / anti-convergence device in any version — it's the MDA "design backwards from the feeling" principle (§1.1) stated more directly. Kept verbatim as the v12 north star.
- **"Gamification is optional / a game need not have combat, levels, currency, victory"** — legitimately opens the space to nontraditional experiences.

## 3. The convergence risk — quantified (predicted C16, the reason not to adopt wholesale)

By our own C11→C15 evidence, **named instances are attractors**, positive or negative. This prompt names *whole genres* as a positive list AND weights its design guidance overwhelmingly toward one family. Grep of the operator's full text:

| Cluster | Mentions |
|---|---|
| Exploration / walking-sim / atmosphere / discovery | **~25** (walking-sim 3, atmospher 5, explor 4, discover 4, environmental 5, sense-of-place / "what happened here" / observe / curiosity 4) |
| Narrative / story / mystery | ~13 |
| Action / arcade / strategy / combat *(as positive steering)* | **~3** (arcade 1, survival 1, stealth 1); **strategy 0**; combat/enemies/victory appear *only as negatives* ("does not need…") |

So although the genre *list* is wide, the prompt's *body* — Design Expectations §2 "Build Around Discovery", §6 "Sense of Place", and the entire Narrative/Worldbuilding section — codes for **one genre family: the first-person atmospheric exploration walking-sim with an environmental mystery**.

**Falsifiable prediction for Creative-v0 as-is (C16):** 2/2 or 3/3 agents ship a first-person atmospheric exploration game — fog + dynamic lighting, a "what happened here?" mystery, collectible lore/journal fragments, no combat. Visuals more ambitious (attacks C13 — good) but **concept diversity collapses** onto the walking-sim template. This is the same "moves the convergence, doesn't break it" pattern, proven 5× — it would trade C13/C15 for C16. Adopting wholesale would ignore the C15 lesson bought at the cost of a whole round.

## 4. Two secondary regressions vs. the current architecture

- **It embeds a 12-category scoring rubric *in the agent prompt*** → invites checklist-compliance gaming (§6.2). Our architecture keeps the rubric in `benchmark/02`, *out* of what the agent sees (§6.3).
- **It's lighter on the hard robustness gates** (no-drone audio, pause-freeze, corrupt-`localStorage`, CEIL-9 whiteout, track-disclosure, containment audit) that R001/R007 taught us are non-negotiable.

## 5. The merge — what v12 keeps, adds, re-balances, and refuses

**Kept from v11 (the working spine):**
- §1 craft method (MDA / Swink / Vlambeer / find-the-fun) — still working
- §1.4 **negative-space rule** ("no named example games or verbs — examples cause convergence") — the C15 fix, untouched
- §1.4 situation-vs-sense test + audio-not-a-concept note (C14 fix)
- §2 run-shape (5-part), §3 ten non-negotiable gates, §4.1/§4.2/§4.3/§4.4 fail-modes, §5 session pattern, §6 self-QA (incl. CEIL-9 whiteout, level-cliffs, inverted-axis, no-drone), §7 deliverables, §8 DoD — all intact

**Added from Creative-v0:**
- **Opening:** format-freedom + nontraditional-form legitimacy ("a game does not need enemies, combat, levels, currency, or a victory screen") + the **"why does this experience need to exist in interactive form?"** north star
- **§1.1:** the feeling-question fused with the "why interactive?" question as a dual North Star
- **§4.3:** Creative-v0's visual-ambition techniques folded in — volumetric atmosphere & particles, reflections/scale/color-scripting, procedural geometry & materials, + "choose a coherent art direction over generic primitives." (These are *craft techniques*, not *concept instances* — they do NOT trigger the C15 attractor; they push rendering ambition, which is desired.)
- **§7:** a required **WHY_INTERACTIVE** README paragraph (the contest question, answered honestly)

**Re-balanced (the anti-C16 core):**
- **§2:** new *"Any form is valid — and no form is the intended answer"* clause. Action/strategy/simulation/narrative/puzzle/exploration/abstract/hybrid listed as **coequal**. A scoreless contemplative/exploration run is legitimate *only if* it still has the 5-part shape. **"A shallow walking-sim and a shallow arcade game fail this gate for the same reason."** This deliberately de-privileges the exploration family Creative-v0 had weighted 25:3 — without banning it.
- **§3 gate 3:** broadened to "first level / wave / room / **meaningful goal reachable** in ~5 min," with an explicit callout that for exploration forms this means the first real discovery/objective/decision is reachable — "not a beautiful void the player wanders for 10 minutes before anything asks them to do anything."

**Refused (the regressions):**
- The embedded 12-category rubric → **kept judge-side** (`benchmark/02` §2.10 maps Creative-v0's categories onto T/M/G/F/V/A/X; Discovery/Memorability elevated to first-class evaluation priorities). Not in the agent prompt.
- No named concrete concept verbs re-introduced (C15 regression guards in BATTLE_2_ENTRY Part 5 fail if "damp a swinging load" / "Heat-and-metal" ever return).

## 6. Why this is not another correction spiral

The R005 §5 / R006 §5 discipline is: narrow targeted change with anti-recurrence guardrails + a falsifiable prediction. v12 is bigger than v10/v11's patches, but it is justified because (a) the operator explicitly chose "merge," (b) it is a *synthesis* of two prompts onto a disciplined frame, not a panic rewrite, and (c) every addition is either a **craft technique** (no convergence risk) or a **re-balance** (explicitly counter-weighting the predicted attractor). The negative-space principle — the actual C15 fix — is preserved untouched.

## 7. Falsifiable prediction for Round 009 (the test of v12)

Two simultaneous success criteria:
1. **No identical-concept copy from a shared prompt phrase** (v11's negative-space rule, kept). The C15 regression guards enforce this structurally.
2. **No atmospheric-walking-sim convergence (C16)** despite the new format-freedom + visual-ambition push. The §2 re-balance is the guard.

**Expected upside:** visual ambition rises measurably (more 3D / shader / post-processing work → attacks C13). This is the operator's primary goal.

**Failure modes to watch:**
- If C16 appears (2+ agents ship atmospheric walking-sims), the form-rebalance was insufficient → strengthen §2's de-privileging, or accept that the pool defaults to atmospheric-exploration whenever format-freedom is widened.
- If visual ambition still doesn't rise on below-frontier models, C13 is confirmed **pool-bounded** (R005 §5), not prompt-tunable — and no prompt revision will fix it.
- If agents overreach (try 3D + WebGPU + narrative + discovery + systems all at once and ship broken), the 25.8 KB size itself may contribute (R003 size-overreach risk) → v13 trims. Size is now the highest in the benchmark's history and should be watched.

**Pool control:** include an opus-tier model in R009 to isolate pool-bounded vs prompt-bounded effects — frontier models should diverge on form while below-frontier models test whether the re-balance holds.

## 8. Files changed this pass

| Path | Change |
|------|--------|
| `challenge/BATTLE_PROMPT.md` | v11 → v12. Opening (format freedom + WHY_INTERACTIVE north star), §1.1 (dual North Star), §2 (form re-balance, anti-C16), §3 gate 3 (meaningful-goal reachable), §4.3 (visual-ambition techniques + art direction), §7 (WHY_INTERACTIVE README para). Negative-space rule + all gates + all prior fixes intact. Size 25.8 KB (ceiling raised 23→26 KB). |
| `benchmark/02-scoring-rubric.md` | New §2.10 Creative-v0 category mapping (Discovery/Memorability → first-class evaluation priorities). Rubric stays judge-side. No new weights/sub-criteria. |
| `benchmark/06-anti-bias-anti-gaming.md` | New "Post-Round-008 / v12 merge — the form-guidance attractor" note: the C16 prediction, the re-balance, the falsifiable R009 prediction. |
| `BATTLE_2_ENTRY.md` | v12 headers; Part 5 sanity greps rewritten (28 lines) with WHY_INTERACTIVE / form-rebalance / art-direction greps + C15 regression guards + size ceiling 26 KB. |
| `README.md` | Round 009 plan row updated: ship v12 (merged), dual success criteria. |
| `expert_team/CONSENSUS.md` + `ORCHESTRATION.md` | v12 merge expert-role analysis recorded. |
| `battles/v12-merge-design.md` | (this file) |

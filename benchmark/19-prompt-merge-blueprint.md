# v19 Merge Blueprint — one synthesized prompt from the deep analysis

**Input:** `benchmark/prompt-lineage-deep-analysis.md` (the section-by-section
investigation + verdicts). This blueprint converts it into an executable decision: exact
edit list, the new prompt draft, scoring/metrics additions, and the experiment design.
**Status:** draft for operator review — NOT the live prompt until approved.

---

## A. What we are NOT doing (equally important)

1. **Not adding C19/C20 to the warning list.** R011 proved guards can't name future
   clusters; adding "no sprout games / no 4X grids" would (a) make them attractors, (b)
   tax every agent's concept space, (c) be obsolete in one round. The convergence note
   stays at the three named families.
2. **Not deleting v18's engineering block.** It raised real code quality and powered
   glm-5.3's best-in-round 4X. It gets *demoted and re-sequenced*, not removed.
3. **Not growing the prompt.** Target 5.5–6.5 KB — the v16/v17 size. If the draft exceeds
   it, cut warnings before cutting generative content.
4. **Not re-litigating R010/R011.** Their conclusions are locked (ambition-permission +
   load-bearing guards + model variance).
5. **Not pretending one prompt fixes reliability.** Reliability needs the M-6 gate +
   "play it yourself" enforcement + the runtime verifier plane (Track E/verifier docs),
   not just prose.

---

## B. Exact edit list (v18 → v19)

| # | Section | Action |
|---|---|---|
| 1 | Title/framing | Keep. v19. |
| 2 | Opening ambition paragraph | Keep verbatim (proven generative core). |
| 3 | WHY_INTERACTIVE question | Keep, **plus** one sentence forcing the player's decision/tension: *"name the decision the player keeps making, and the tension that makes it interesting."* |
| 4 | 7-family menu | Reword "systemic": *"systemic — a world whose rules respond to you with consequences you can feel"* (anti-"balanced machine" reading). Others unchanged. |
| 5 | Materials+light recipe | **Replace** the MeshPhysicalMaterial/clearcoat/iridescence/transmission block with a de-recipe'd craft tip: *"Make it look considered: light, material, texture, composition, atmosphere — a coherent stylized look beats an unfinished fancy one. The technique is your call (this includes, if your stack supports it, physically-based materials — but only what you can finish end-to-end)."* |
| 6 | NEW §: **The game comes first** | Insert after the families: player's sentence rule + "no sim without a game" rule (text in §D). |
| 7 | Convergence soft-note | Keep the 3-family note; append the "not banned / why it exists" reframe (1 sentence). |
| 8 | Engineering block | Keep domain-notes/mini-contract/six invariants/self-test **verbatim**, but move it BELOW the game-first gate and add invariant 7: *"the simulation serves a game — every system maps to something the player decides, risks, or feels."* |
| 9 | Hard rules | Keep 7 rules; **tighten #4** (audio) with "no sound can exceed a sane level; test with headphones off"; **add a new rule** (or fold into #1): *"You must actually play your own build once, end to end, as a player, before delivering. If you cannot play it, do not deliver it."* |
| 10 | Self-QA list | Reword from self-report to code-checkable: replace "run this list" with the **play-through gate** + explicit "state in the README exactly what you verified by playing (not 'should work')". |
| 11 | Deliverables | Keep; HONEST_SELF_ASSESSMENT must now answer "what did you actually play-test, and what broke?" |

---

## C. Scoring/metrics additions (judge side, so the prompt can be held honest)

1. **New tracked metric M-6 — "is it a game"** (fun/goal/agency/challenge/readability),
   scored by the jury from the artifact. Formalize in the rubric as a **gate criterion
   pair**: gameplay-loop must have a *visible goal*, a *real obstacle/fail state*, and at
   least one *decision with tradeoffs* (rubric G2/M5/F6 anchors). A "simulation that runs
   correctly but is not a game" cannot score above the low band on G/F/M, no matter how
   good T/V are. (This makes the R014 "enjoyment 0" failure *scoreable* instead of
   anecdotal.)
2. **Cluster tracking:** register **C19 (grow/sprout/network-life)** and
   **C20 (infrastructure/4X/energy-grid)** in `benchmark/06` §6.5 as *judge-side
   observations* (soft-note only, per the V0 cluster logic) — with the explicit note that
   the prompt deliberately does NOT name them.
3. **Reliability measurement:** keep defect taxonomy; the S4a runtime-soak/experience
   endurance split (v2) gives the "is it actually playable for an hour" signal that the
   R013/R014 bug wave needs.

---

## D. New prompt draft (v19 CORE) — the changed sections only

> Full draft assembled from v18 + edits below (only the delta shown here; unchanged
> sections are elided as "[keep v18 §…]").

**§ After the WHY_INTERACTIVE question, before the families:**

> Before you write any code, write the **player's sentence** — one sentence answering:
> *what is the player trying to do, what can stop them, and what makes it fun?* If the
> sentence is about systems that run rather than choices a person makes, you don't have
> a game yet. **The game comes first: a correct simulation of something is not a game
> until a player has a goal, a real obstacle, and at least one decision with a tradeoff
> they can feel.** Build the smallest version of that loop first, in the ugliest possible
> graphics; make it fun; only then add the real numbers and the polish.

**§ Materials line (replacing the recipe):**

> Make it look considered. Light, material, texture, composition, atmosphere — a
> coherent stylized look beats an unfinished fancy one, and deliberate minimalism with
> real polish beats both. The specific technique is your call; if your stack supports
> physically-based materials, they are one way among many, and only worth it if you can
> finish them end-to-end on a fresh load.

**§ Convergence note (append):**

> These notes exist because this benchmark has watched a lot of rounds, not because the
> listed things are bad — a genuinely great game in any of these families can still win.
> They are here to make you look twice at your first instinct, then trust your judgment.

**§ Engineering block (moved below game-first; invariant 7 added):**

> [v18 block verbatim: domain notes, mini-contract, six invariants]
> 7. **The simulation serves a game.** Every system you build must map to something the
>    player decides, risks, or feels. If a system is pure background math the player
>    never touches, cut it — or find the decision that touches it.

**§ Hard rules — add:**

> **Play your own game.** Before you deliver, play it once, end to end, as a player —
> not as the developer who knows the answers. If you cannot play it, or you do not enjoy
> the run you just played, do not deliver it; fix it first. In the README, say exactly
> what you verified by playing (fresh load, one full run, restart) — not "should work".

---

## E. Experiment design (how to validate v19)

Per the benchmark's own discipline (R010/R011/R013), run a **controlled 3-arm
comparison** on the visually-capable workhorse pool:

```
ARM A: v17 (live today)
ARM B: v18 (held engineering block)
ARM C: v19 CORE (this blueprint)
same model set (e.g., claude-opus-5-*, glm-5.3-max, gpt-5.5-high, gemini-3.x-flash,
grok-4.6) — balanced across arms; ≥3 sessions per arm
```

Measure (pre-registered):

| Metric | How |
|---|---|
| M-1 ambition | stack-mentions (3D/WebGL/WebGPU) + jury visual |
| M-4 reliability | launch/blank/audio/controls defect rate (defect taxonomy) |
| **M-6 "is it a game"** | jury: goal/obstacle/decision present? (new) |
| fun/jury pairwise | human pairwise quality (benchmark/01) |
| convergence | concept-cluster counts (C14/16/18/19/20) + cluster entropy |
| code-quality | rubric T7 + engineering markers (seeded sim, self-test) |
| wall time / tool calls | efficiency |

**Success criteria:** v19 ≥ v18 on M-6 and fun WITHOUT losing M-1 or T7; v19 ≥ v17 on
reliability. If v19 loses M-1 → the craft-tip de-recipe went too far (restore recipe as
an *optional appendix*). If v19 loses M-6 → the game-first gate needs teeth (move it
into the hard rules). Either failure is informative.

---

## F. After approval — the concrete commits

1. `challenge/BATTLE_PROMPT_v19_CORE.md` — full assembled prompt (v18 base + §D edits).
2. `challenge/BATTLE_PROMPT.md` — remains v17 until the 3-arm experiment resolves.
3. `benchmark/06-anti-bias-anti-gaming.md` — register C19/C20 (judge-side notes).
4. Rubric/`02` — formalize M-6 gate wording (G2/M5/F6 anchors) if approved.
5. `README.md` battle-log row: R015 plan (3-arm v17/v18/v19).

---

## G. v20 package decision record (operator questionnaire, 2026-09-06)

Field evidence through R015 (`battles/round-015-v19core-field-analysis.md`) plus the
arena-sandbox engine audit (`battles/arena-sandbox-engine-capability-audit.md`) opened the
next edition. Built with the optional-selection questionnaire method (as used for v16):
operator answers, verbatim decisions:

1. **Edition scope — Full package:** new prompt edition **plus** an agent-facing how-to so
   contestants can try the methods and the engine (Blender-CLI/0-GPU studio path).
2. **Capabilities placement — Embedded section:** the conditional headless-tooling
   guidance lives **inside the prompt** (`BATTLE_PROMPT_v20.md` §"Headless tooling, engines
   & the asset pipeline") with the full verified recipes in the companion
   `SANDBOX_CAPABILITIES_GUIDE.md` handed to both agents in package runs.
3. **Hedonics edits (held v19.1 proposals from the C21 root cause) — all three applied:**
   (a) post-gate sentence: a game also needs a reason to be enjoyed — name what the player
   will *like*, not only what can stop them; (b) invariant 7: "decides, risks, or feels" →
   "decides, **cares about**, or feels"; (c) stop-you palette widened with non-crisis
   tension (a rival, a deadline, a mystery, an appetite).
4. **Promotion gate — after one field test of the package:** live `BATTLE_PROMPT.md` stays
   v17; R016 runs the v20 package (prompt + companion, identical for both agents); promotion
   follows its verdict.

Open watch items for the R016 v20-package field test:
- **Method-convergence risk (new):** tooling guidance can itself become a cluster (everyone
  ships bpy glTF props). Track as a judge-side count (engine-asset usage + whether the
  tooling shaped the *concept*). The prompt's "never the concept" line is the steer; do not
  name any tool in the families note.
- C21 fire/crisis share (did the hedonics counter-weight move the concept field?),
- M-1 visuals under the engine path (first real chance for bundled 3D assets in rounds),
- time-budget behavior (tooling setup vs loop completeness; drop-if-unavailable rule).

---

## H. v21 single-prompt revision decision record (operator directive + logs 15/16, 2026-09-07)

Operator directive (verbatim intent): the whole coverage must live inside the battle prompt in **one single copy-paste instruction** — no file transfer, no patchwork hand-additions. Plus: "0 success in using the engine or properly blender assets... the prompt is still not creating enough creative and impactful graphical tries... Fable 5.1 cardboard... we right now need proper revisions and improvements."

Evidence base: log15 (R016, v20) and log16 (R017, v20) — 23 sessions, 12 operator comments. Logs decoded in `battles/log15-16-v21-revision-notes.md`.

Decisions (questionnaire attempted, skipped by operator in favor of a new upload; decisions below are evidence-based, correction welcome):

1. **Single file, self-contained.** `BATTLE_PROMPT_v21.md` replaces the prompt+companion package: routes, recipes, look checklist, originality rule, fun contract, probe rule — all inline. No file handoff, no external references. (Log16's zero tooling use is partly attributable to the companion never being inside the paste.)
2. **Environment-class routing + required ENV report** (E1 shell / E2 npm-only / E3 file-edits, with a route per class incl. condensed bpy + npm-three + image recipes). Answers "are the sandbox conditions different?": yes — battle agents are E2/E3 and browser-less (agents' own words quoted in the notes doc), the verified E1 bpy pipeline belongs to the analyst sandbox class. The prompt now adapts to the class instead of assuming it, and demands a one-line blocker report so per-session sandbox truth is collected.
3. **Anti-cardboard look block with blind-visuals handling.** Concrete checklist (light/shadow, responding materials, palette tokens, depth, motion, finished frame) + the rule that a browser-less agent's only eyes are the image tool — put the see-able identity in charge of first impressions.
4. **Second-idea originality rule + expanded agent-visible repeat-families note** (adds wildfire/ember, energy-grid, growth/mycelium, lighthouse/beacon + the operations-crisis umbrella). C15 relocation cost accepted — operator fatigue after 4 consecutive comment sets on fire/grid is the binding constraint; C22/C23 registered judge-side.
5. **Fun contract + completeness teeth.** Minute-1/minute-10 fun statement (FUN_LINE in README), close-the-loop rule ("ship complete; building to infinity is the worst outcome"), pacing clause (no first-minute cliff), audio-defaults clause (ear-blasting complaints), autopilot playability probe for browser-less sandboxes (hard rule 8 reworded: play or probe).
6. **Promotion unchanged:** live stays v17 until the operator verdict on v21 (R018).

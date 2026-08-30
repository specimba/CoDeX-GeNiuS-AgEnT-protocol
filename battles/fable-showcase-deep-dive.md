# Deep Dive — Elicitation > Model: what FABLE-SHOWCASE proves about our battle prompt

**Status:** strategic finding / hypothesis. Revises the Round-009 "model-bounded" conclusion.

> **Post-Round-010 verdict (this hypothesis was tested — half confirmed, half refuted).** The controlled v13-vs-LEAN experiment bore out **§3's core claim**: over-caution suppresses ambition (LEAN → the benchmark's first WebGPU 3D game; ~13× more 3D-stack mentions than v13). But it **refuted §3's stronger claim** that the convergence apparatus (C11–C16, traps, avoid-lists) is "a misdiagnosis": stripped of v13's §4.4 + sonar/frequency avoid-list, Grok 4.6 immediately shipped a radio/signal/frequency game — **C14 back, first try.** The guards are load-bearing; the trap *essays* and craft *lectures* are not. The synthesis is **v15 = ambition-first tone + retained compact convergence guards.** Full read: [`round-010-after-action.md`](round-010-after-action.md). Read the rest of this doc as the hypothesis that Round 010 then tested.
**Trigger:** operator counterexample — [elder-plinius/FABLE-SHOWCASE](https://github.com/elder-plinius/FABLE-SHOWCASE).
**Recorded by benchmark:** 2026-08-24 (Ankara)

---

## 1. The operator is right — it is NOT (only) a model problem

Round 009's after-action leaned hard on "L3: model-bounded collapse, not prompt-fixable." **That was over-stated, and the FABLE-SHOWCASE repo is the proof.**

Fable 5 and opus5-max sit in the same frontier tier (our own C13 registry cites "Opus 5 / Fable 5 / Kimi K3 / Sol" together as the only >75 WebGL-shader scorers). FABLE-SHOWCASE shows that tier producing **57 visually-modern, zero-dependency generative/simulative demos** — boids, particle-life, black-hole lensing, cymatics, fractal voyager, stained glass, aurora, an infinite gothic cathedral, a pocket planet — from **a 4-sentence casual prompt**. Meanwhile opus5-max on our benchmark ships "old-looking browser-style" craft games from a **29 KB** prompt.

**Same capability tier, opposite results.** The variable that moved is not the model — it's the **elicitation**. The operator's instinct is correct: *"it cannot be that the whole thing is a model problem at all, because opus5 max also isn't showing huge differences on our bench."* Exactly. The model has the latent capability; our prompt isn't reaching it.

## 2. The contrast — what FABLE did vs what we do

| Dimension | FABLE-SHOWCASE (→ 57 modern demos) | Our battle prompt v13 (→ "old browser-style" games) |
|---|---|---|
| **Length** | ~4 sentences (~350 bytes) | ~29 KB, largest ever |
| **Tone** | Casual, enthusiastic, permissive (*"lets see if we can't build something epic"*) | Cautious, lecturing, prescriptive |
| **Stance toward the model** | Delegates creative authority (*"leverage fable 5's full creativity and intelligence"*) | Second-guesses it (6 traps, avoid-lists, "don't ship broken," "beware the category") |
| **Diversity strategy** | Breadth by enumeration (*"all sorts of different complex cool creative projects"*) | Avoid-lists + category frameworks + negative-space rules |
| **Ambition signal** | One strong, unqualified push (*"epic… full creativity"*) | Buried under 29 KB of caveats and "the ambition-theater trap is real" |
| **Compute paradigm** | ~275 parallel subagent runs, design→build→**enhance**→QA pipeline | Single-shot per agent |
| **Output look** | Modern, generative, shader/sim-heavy | Flat primitives, Canvas-2D, "2013 mobile" |

## 3. The reframe — over-caution suppresses ambition

Reading our v8→v13 arc through this lens, a single root cause emerges:

**Every revision ADDED caution — and the caution suppressed the permissive ambition that produces modern visuals.**

- v8 added the craft-method lectures. v9 the retro-visuals trap. v10 the modality trap. v11 the negative-space rule. v12 the form-rebalance + visual-ambition push (buried under warnings). v13 the craft-category trap + 7-family framework.
- The prompt grew ~15 KB → 29 KB, every byte of it more cautious and prescriptive.
- Result: frontier models play it **safe**. "Safe" in one-shot game creation = Canvas-2D + flat primitives + a craft/physics verb = exactly the "old-looking browser-style" the operator keeps seeing.

This re-explains **both** persistent failures at once:
- **C13 (retro-visuals)** wasn't a missing technique list (we added it in v9 §4.3 and it didn't help) — it was the model hedging because the prompt spent 29 KB telling it what could go wrong.
- **C16 (craft convergence)** wasn't (only) the §1.4 wording — craft/sim is the *safe* corner, and a cautious prompt herds frontier models toward the safe corner. The FABLE method (permissive + parallel) got 57 *diverse* demos with **no avoid-lists at all** — because permissiveness, not prohibition, is what spreads the field.

**Our entire convergence-fighting apparatus (C11–C16, traps, avoid-lists, category frameworks) is looking like a misdiagnosis.** It fixed instance-level copying (C14/C15) at the cost of ambition — and ambition is the dominant quality variable, as FABLE shows. We have been optimizing against convergence and quietly starving ambition for nine rounds.

## 4. The honest caveats (so we don't over-correct the other way)

1. **FABLE demos are not complete games.** They're single-concept generative/sim pieces — no loop/progression/restart/win-lose. Our benchmark legitimately requires a *complete playable game*, which trades against pure visual ambition. A lean prompt must still convey "build a complete game," not just "build a cool demo."
2. **FABLE used ~275 parallel runs with an enhance+QA pipeline.** Part of the quality gap is compute/parallelism, not just prompt. We are single-shot by design. **But** this confound does *not* save our prompt: a single frontier-model run under a permissive prompt should still beat a single run under 29 KB of caveats. The prompt is still suspect #1.
3. **The reliability gates are not caution — they're fairness.** Launch/loop/controls/pause/self-contained/no-telemetry exist for anti-gaming + comparability, not timidity. They must survive any lean rewrite.

## 5. The proposed fix — a LEAN, ambition-first prompt (v14 draft)

Reverse course. Instead of adding the 7th trap, **strip the caution and trust the frontier model's latent capability**, keeping only the hard reliability gates + one strong ambition signal + the WHY_INTERACTIVE question. Target ~6 KB (vs 29 KB) — FABLE-spirited.

### Draft (not yet the live prompt — for the operator to approve / test)

```
# BATTLE PROMPT — Build one good browser game, in one session (v14 LEAN — DRAFT)

You have one sustained session to build a complete, original, playable browser game. Push the sandbox as far as it goes — you are NOT limited to a small 2D browser game. Frontier models in 2026 routinely ship WebGL/WebGPU generative visuals, real simulations, shader post-processing, and procedural worlds in a single self-contained file. That capability is in your hands — use it. Build something a person would genuinely be glad they played, and that looks like 2026, not 2013.

Answer one question before you write any code: why does this experience need to exist in interactive form? If you can't answer it, you don't have a game yet.

Be ambitious and trust your own taste. Pick a concept you find genuinely interesting — any genre, any camera, any stack, any form (action, strategy, simulation, narrative, puzzle, exploration, abstract, experimental — your call). Make it look modern: real lighting or shaders, procedural materials, post-processing, particles, a coherent art direction. A stylized-but-polished look beats flat primitives every time. If you commit to 3D/WebGPU, FINISH it — a broken ambitious build scores worse than a clean simple one, so scope what you can actually complete end-to-end.

The only hard rules (reliability + fairness — everything else is your call):
1. Launches cleanly on a fresh load — no blank screen, no console-error loop.
2. Complete loop without a page refresh: start → play → progress → end → restart.
3. Controls work with a real mouse/keyboard/touch; first goal reachable in ~5 min of honest play.
4. Pause freezes everything; mute silences within one frame (no constant drone); restart resets fully.
5. Self-contained & offline: no backend, no network calls, no assets you can't legally ship, no telemetry. Static folder or single HTML.
6. Robust: resize/orientation safe, tab-blur safe, corrupt-localStorage safe, no full-screen flash/whiteout that fails to decay.
7. Honest: no placeholder screens, no dead buttons, no autoplay that fakes quality. First README line: `TRACK: strict-one-shot` or `TRACK: iterated (N passes)`.

Deliverables: the runnable game; a short README (TRACK line, how to run, controls, stack, what you cut, and short DESIGN_PILLARS / DIRECTOR_STATEMENT / WHY_INTERACTIVE / HONEST_SELF_ASSESSMENT paragraphs); optionally a design_notebook.md.

Ship a complete, polished, modern game you'd actually want to play.
```

~2 KB. It keeps every reliability gate, the WHY_INTERACTIVE ambition question, and a strong permissive ambition signal. It **drops**: the craft-method lectures, all 6 traps (§4.1–§4.5), the avoid-lists, the 7-family category framework, the negative-space meta-commentary, the form-rebalance clause, and most "don't" language. The convergence apparatus is gone on the bet that permissiveness spreads the field better than prohibition did.

## 6. The decisive experiment (this is what settles it)

Run a **head-to-head on the same frontier model**, holding everything else fixed:

- **A:** opus5-max under **v13** (29 KB, cautious).
- **B:** opus5-max under **v14 LEAN** (~2 KB, permissive).

Predictions (any of which is a useful result):
1. **v14 produces more modern / visually ambitious output than v13** → over-caution hypothesis CONFIRMED; we've been steering wrong for 9 rounds; promote v14 and retire the trap apparatus.
2. **v14 produces the same "browser-style" output as v13** → the elicitation gap is NOT the prompt (it's single-shot-vs-parallel-pipeline, i.e., genuinely compute/paradigm-bounded); keep v13's reliability work and investigate the parallel-pipeline direction.
3. **v14 produces more ambition BUT also more broken builds** → permissiveness unleashes ambition past reliability; the lean prompt needs the ambition-theater guardrail re-added (the one piece of v13 that R009 justified).

This is falsifiable, cheap, and directly answers the operator's challenge — and unlike another trap-addition, it tests whether the whole v8→v13 direction was a mistake.

## 7. What this revises in the record

- **Round-009 after-action §4 (L1/L2/L3) is over-claiming on L3.** L3 ("model-bounded, not prompt-fixable") should read: *"model-bounded under our current elicitation regime — but FABLE-SHOWCASE demonstrates the same model tier produces radically better output under short/permissive + parallel elicitation, so 'model-bounded' is conditional on the prompt, not absolute."* A forward-pointer to this doc is added there.
- The **pivot-to-controlled-experiments** recommendation from Round 009 still holds — but the FIRST experiment should be the v13-vs-v14 head-to-head above, because it tests whether the prompt is even the right lever before we measure model-vs-prompt splits.

## 8. Bottom line for the operator

You're right and I was wrong to lean on "model problem." FABLE-SHOWCASE proves the capability is sitting there in the frontier tier, untapped, while our 29 KB of caution herds it into safe, old-looking output. The most likely highest-leverage move is not v15-with-another-trap — it's **a lean, permissive, ambition-first prompt tested head-to-head against v13 on the same frontier model.** I've drafted v14 above for exactly that test. Say the word and I'll wire it in as the live prompt (or as a second paste-target for an A/B battle).

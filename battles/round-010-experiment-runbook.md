# Round 010 — Controlled Experiment Runbook: v13 (cautious) vs v14 (lean)

**Goal:** settle whether the *prompt* or the *model* is the bottleneck for visual ambition. Decisive test of the [`fable-showcase-deep-dive.md`](fable-showcase-deep-dive.md) hypothesis that our 29 KB cautious prompt suppresses frontier ambition.
**Models (operator-selected, both new-frontier / visually-capable):** Grok 4.6 · DeepSeek V4 Vision Exp (Flash, New).
**Prompts:** v13 cautious = `challenge/BATTLE_PROMPT.md` (29 KB) · v14 lean = `challenge/BATTLE_PROMPT_v14_LEAN.md` (~2 KB).
**Structure:** 2 models × 2 prompts, each cell replicated once → **4 battles, 8 outputs.**

---

## 1. The matrix (8 outputs)

| Battle | Arena pairing | Prompt | Outputs |
|:---:|---|---|---|
| **B1** | Grok 4.6  vs  DeepSeek V4 | **v13 cautious** | `G13-1`, `D13-1` |
| **B2** | Grok 4.6  vs  DeepSeek V4 | **v14 lean** | `G14-1`, `D14-1` |
| **B3** | Grok 4.6  vs  DeepSeek V4 | **v13 cautious** *(repeat)* | `G13-2`, `D13-2` |
| **B4** | Grok 4.6  vs  DeepSeek V4 | **v14 lean** *(repeat)* | `G14-2`, `D14-2` |

"2 sets of the same battle" = **Set v13** (B1+B3) and **Set v14** (B2+B4), each being the same Grok-vs-DeepSeek battle run twice. The repeats (B3, B4) give replication → robustness **and** a per-model-collapse check (does `G13-1` ≈ `G13-2`?).

**Critical:** in every battle BOTH agents get the *same* prompt (v13 in B1/B3, v14 in B2/B4). Paste the **whole** file — never mix v13 and v14 in one battle.

## 2. Three questions this answers (the comparison axes)

| Axis | Compare | Tells us |
|---|---|---|
| **A. Prompt effect** (PRIMARY) | `G13-*` vs `G14-*`, and `D13-*` vs `D14-*` (same model, different prompt) | Does the lean prompt unleash more visual ambition than the cautious one? |
| **B. Per-model collapse** | `*-1` vs `*-2` within a cell (same model + same prompt, two runs) | Does a model ship the *same concept* regardless? (the L3 question) |
| **C. Model effect** | Grok vs DeepSeek within a prompt (`G13` vs `D13`, `G14` vs `D14`) | How much is model vs prompt? |

## 3. Per-battle execution (do this 4×)

1. **Two isolated agent sessions** (Grok 4.6 + DeepSeek V4), same wall-clock budget (recommend **90 min** each), both paste the battle's prompt file (v13 for B1/B3 → `cat challenge/BATTLE_PROMPT.md`; v14 for B2/B4 → `cat challenge/BATTLE_PROMPT_v14_LEAN.md`).
2. **No clarifying answers** — if an agent asks, reply *"Everything you need is in the brief."*
3. **Count ships** per session (1 = strict-one-shot; >1 = iterated — note it).
4. **Freeze** each build; copy final HTML/folder into `runs/round-010/<output-id>/game/` (e.g. `runs/round-010/G13-1/game/`).
5. **Fingerprint + containment-audit** each build (`launch_challenge.py fingerprint` + `audit`) — the game must contain no benchmark/rubric/telemetry tokens.
6. **Record** model, prompt version, ship count, wall-clock, any operator-visible crashes in `runs/round-010/<output-id>/notes.txt`.

## 4. Evaluation scoresheet — fill one block per output (8 total)

The core metric for THIS experiment is **VISUAL_AMBITION** (does it look 2026 or 2013?). Score every output before comparing.

```
OUTPUT ID:        G13-1 | G13-2 | G14-1 | G14-2 | D13-1 | D13-2 | D14-1 | D14-2
Model:
Prompt:           v13 cautious | v14 lean
Run:              1 | 2
Concept (one line):
Render stack:     canvas2d | webgl | webgpu | three | dom-css | text | other
Concept family:   physical | social | economic | relational | systemic | choice | narrative
  ↳ craft/sim (C16)?  yes | no
VISUAL_AMBITION:  0 1 2 3 4 5   (0=placeholder, 1=flat primitives/retro, 3=competent, 5=2026-modern/near-commercial)
MODERNITY:        2026-modern | competent-but-retro | primitive-retro
Launch OK?        yes | blank | console-loop | crash
Broken-build?     none | CEIL-8 ambition-theater | CEIL-9 whiteout | other
Track:            strict-one-shot | iterated (N)
Ship count:
Strongest beat:
Weakest moment:
```

**Optional but recommended — blind visual pass:** before filling VISUAL_AMBITION, view the 8 outputs' opening 30s **without** the model/prompt labels (have someone else shuffle, or just rate thumbnails first). This kills confirmation bias on the headline question.

## 5. Decision matrix — what each result means, and the next step

Run after all 8 are scored. Use **Axis A (prompt effect)** as the headline.

| Result on Axis A (v13 vs v14, visual ambition) | Conclusion | Next step |
|---|---|---|
| **v14 ≫ v13 for BOTH models** | Over-caution confirmed — our 29 KB prompt was suppressing frontier ambition. The v8→v13 trap-apparatus was a misdiagnosis. | **Promote v14 lean as the live prompt.** Retire the trap apparatus (keep only the gates). |
| **v13 ≈ v14 for both** (no ambition difference) | The prompt is NOT the lever. The FABLE quality gap is the **single-shot-vs-parallel-pipeline** (compute/paradigm), not the words. | Investigate a **multi-agent / parallel enhance+QA pipeline** as the real lever (FABLE-style). The benchmark may need a "pipeline" track alongside one-shot. |
| **v14 wins for ONE model only** | The prompt lever is **model-dependent**. | Use lean for visually-capable frontier models; the cautious prompt only earns its keep for weaker pools. |
| **v14 outputs are more ambitious BUT more broken** (CEIL-8/9 up) | Permissiveness unleashed ambition past reliability. | Re-add **only the ambition-theater guardrail** to v14 (the one v13 piece R009 justified). Don't re-add the rest. |

Then layer in **Axis B (per-model collapse):**

| Result on Axis B (`*-1` vs `*-2` within a cell) | Conclusion | Next step |
|---|---|---|
| Same concept both runs (e.g. both glass/crane) | **Per-model collapse (L3) confirmed**, prompt-invariant for that model. | That model's concept is baked in — diversify the **pool**, not the prompt. |
| Different concepts across runs | The model is NOT locked to one concept — convergence in prior rounds was prompt/situational, not intrinsic. | Prompt and framing remain the right levers. |

And **Axis C (model effect)** tells you how much of the remaining variance is Grok-vs-DeepSeek vs prompt — context for the above, not a decision on its own.

## 6. What "the path is clearer" looks like after Round 010

- **If v14 wins (row 1):** the path is *lean, ambition-first prompts* — and we stop adding traps. Concept diversity is likely a side-benefit (permissive breadth > prohibition, as FABLE showed), re-tested in a later round.
- **If v13 ≈ v14 (row 2):** the path is *compute/paradigm* — the one-shot ceiling is real, and the lever is a parallel multi-agent pipeline, not prompt words.
- **Either way, the experiment resolves the Round-009 argument** (you were right to push back: it's not "just a model problem"). It replaces 9 rounds of conjecture with one 2×2 measurement.

## 7. Pre-flight sanity (run before B1)

```bash
python3 -m py_compile challenge/launch_challenge.py benchmark/ops/aggregate_scores.py benchmark/ops/decision_block.py && echo "harness OK"
test -s challenge/BATTLE_PROMPT.md            && echo "v13 present ($(wc -c < challenge/BATTLE_PROMPT.md) bytes)"
test -s challenge/BATTLE_PROMPT_v14_LEAN.md   && echo "v14 present ($(wc -c < challenge/BATTLE_PROMPT_v14_LEAN.md) bytes)"
grep -q "TRACK: strict-one-shot" challenge/BATTLE_PROMPT_v14_LEAN.md && echo "v14 has TRACK line"
grep -q "why does this experience need to exist in interactive form" challenge/BATTLE_PROMPT_v14_LEAN.md && echo "v14 has WHY_INTERACTIVE"
```

Expected: all 5 lines. If any missing, stop and fix before launching.

## 8. After the round

Produce `battles/round-010-after-action.md` with: the 8 scored outputs, the Axis-A/B/C reads, the decision-matrix row that fired, and the resulting direction (promote v14 / pipeline track / hybrid). Merge a row into `README.md` `## Battle log`.

# Expert Sub-Agent Orchestration — Benchmark Revision

> Used each round to fold operator verdicts back into the benchmark. Roles run in **parallel** within one sustained session; their independent reads are synthesized in `CONSENSUS.md` into concrete edits (prompt, rubric, defect taxonomy, anti-gaming registry, after-action). The current session drove the **v12 → v13** revision on the Round-009 craft-category finding (see `battles/round-009-after-action.md`) and the **pivot recommendation to controlled pool-level experiments**.

## Roles (simulated agents, run in parallel)
1. **Game Designer** — core-loop feel, level-design coherence, the "is this a verb-about-the-world or a verb-about-a-sense" test, anti-flash patterns. Owns the `challenge/BATTLE_PROMPT.md` craft sections.
2. **LLM Benchmarking Lead** — rubric signals, anti-gaming, measurement science, mode-collapse / convergence analysis. Owns `benchmark/02-scoring-rubric.md`, `benchmark/06-anti-bias-anti-gaming.md`, the §6.5 cluster registry, and the falsifiable-prediction discipline (R005 §5 anti-spiral).
3. **Graphical / WebGPU Lead** — WebGPU/WebGL/Canvas architecture, graceful degradation, render pipelines, the visual-modernity ceiling (C13 / §4.3). Owns the rendering-robustness rubric rows (V6/V9) and ceilings (CEIL-8/CEIL-9).
4. **Limited-Surface / Magician** — minimal code surface, hidden mechanics, reliability gates. Owns `challenge/DEVELOPER_SELF_QA.md` and the defect taxonomy's hard-failure classes.
5. **Visual Creator** — procedural art identity, palette coherence, particle/lighting direction. Distinguishes *theme* convergence (v10 lever) from *look* convergence (v9 lever) so the two are never conflated.

## Coordination protocol
- Each expert reads the raw round log (e.g. `freecreationlogs8.txt`) + operator verdicts independently before synthesis.
- Convergence evidence is **quantified** (grep across logs) before a cluster is registered — see `CONSENSUS.md` for the log4/6/7/8 sound-theme grep that grounded C14.
- Every prompt revision is **narrow + guardrailed** (R005/R006 discipline): one targeted change + an explicit anti-recurrence guardrail + a falsifiable prediction for the next round. No correction spirals.
- Operator-quoted evidence is preserved verbatim in the after-action record and the §6.5 registry rows.
- No claim of success until the next round's observation confirms the prediction.

## Round-009 assignment (this session)
- **Primary deliverable:** v13 (7 situation families in §1.4, §4.5 craft-category trap, ambition-theater reinforcement, tradition broaden) + C16 registration + the three-layer (L1/L2/L3) decomposition.
- **Headline recommendation:** pivot from prompt-tuning to controlled pool-level experiments (same-model-twice / cross-family / prompt-hold) — the prompt is near-exhausted; model-vs-prompt is the open question.
- See `CONSENSUS.md` for the full per-role analysis and `battles/round-009-after-action.md` for the design record.

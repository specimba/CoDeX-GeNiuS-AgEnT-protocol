# Battle Round 003 — After-Action Record

**Status:** informal / directional. Not a formal S1–S8 scored round.
**Source log (local, gitignored):** `.experiments/freecreation4.txt`
**Operator:** specimba
**Recorded by benchmark:** 2026-08-21 (Ankara)
**Prompt version active during observations:** BATTLE_PROMPT **v6** (the one just shipped in Round 002)

---

## 1. Summary

Round 003 tested v6 in production across five arena.ai battles (~9 game deliveries + one full harness failure). **All nine deliveries were rated as bad by the operator.** This is a regression from v3–v5 baseline, where at least one entry per round was rated as a genuine game the operator was glad to have.

This after-action documents what v6 did wrong, why the coordinated pass caused it, and the v7 correction. **v7 has shipped as part of this same commit.** No new rules were added to v6; v6 was largely torn out and replaced with a shorter, calmer, more concrete prompt.

## 2. Games observed and operator verdicts (verbatim, condensed)

| Battle | A | B | Operator verdict |
|:---:|---|---|---|
| B1 | **qwen3.8-27b** — *"Something went wrong"* — build never started | **grok-4.3** — **FOLD** (paper-weaving through wooden loom) | *"first battle is problematic contender A is bugged restarted and still cannot created any"* · *"grok's build is nonsense not understandable and 0 game mentality"* |
| B2 | **claude-opus-4-8** — **TIDEWRIGHT** → **FERROFLUX** (fluid particles / magnetic liquid metal, wow: fluid sim + boid schooling in browser) | **mimo-v2.5** — (game name not clearly extractable) | *"both buggy and not good at all creations"* |
| B3 | **claude-opus-4-7** — **HARMONIC** (analog synth CRT repair, drag knobs to match waveform, destructive interference) | **deepseek-v4-pro-high** — **TAPROOT** (growing root through procedural soil strata, rot chases from behind, springs = payoffs) | *"both bad, idea bad implementation bad not both od them feels game at all"* |
| B4 | **qwen3.6-27b** — **ECHO** (sonar sonar-illumination in pitch darkness) | **minimax-m3** — **CASSETTE** (top-down: you are magnetic tape moving through VCR, record real audio waveforms as physical weapons) | *"first one qwen's work cannot pass from menu but minimax m3 made very strange and original idea combination with old game idea fusion and very strange to that model establish that complexity work and at least not fun but strange to play game in the end"* |
| B5 | **mimo-v2.5-pro** — **FRACTURE** → **PRISM** (light beam through crystals, chromatic dispersion + volumetric glow in WebGL) | (arena harness crashed — no build produced) | *"first one is made shitty nonsense thing not even a game other one is not even started that virtual environment for me to test"* |

## 3. What went wrong — v6 diagnosis

### 3.1 The concepts were *not* the problem
Look at the ideas the agents converged on:
- FOLD (paper weaving), TIDEWRIGHT (fluid currents), FERROFLUX (magnetic liquid metal), HARMONIC (analog synth CRT), TAPROOT (growing root strata), ECHO (sonar), CASSETTE (magnetic tape), FRACTURE/PRISM (chromatic dispersion in WebGL)

These are genuinely novel verbs. Several actively dodged the v6 cliché-cluster warnings — deepseek's TAPROOT reasoning trace literally reads *"Idea: 'The Lighthouse Keeper' — no, that's the cliché."* Agents were selecting *away* from C1–C10.

**The problem was execution collapse under scope.** Every one of those concepts is a technical demo waiting to happen: fluid sim, magnetic field physics, procedural strata + growing life, real audio, chromatic dispersion optics. Small models attempting fluid sim in one session ship half-working fluid sim, not games.

### 3.2 v6 caused four compounding failures

**(a) "Wow-or-lose" framing pushed panic over judgment.**
v6 said *"Competent will lose. Safe will lose. Bland but bug-free will lose. Tie is correct over false winner."* That framing tells the agent: **overreach or fail.** An agent that would otherwise have shipped a modest, complete, entertaining game instead attempted a fluid simulation because "competent" was explicitly labeled a losing move.

**(b) The exhaustive cliché list created a new cliché (C11).**
By listing 10 forbidden themes, v6 pushed every agent toward the same anti-cliché: "novel verb + procedural canvas + WebAudio, no image assets." **7 of 9 Round-003 deliveries fit that mold verbatim.** Grok's FOLD, Claude's TIDEWRIGHT/FERROFLUX/HARMONIC, DeepSeek's TAPROOT, Qwen's ECHO, MiniMax's CASSETTE, MiMo's FRACTURE/PRISM — all novel-verb + procedural-render + WebAudio. That is now cluster **C11** in §6.5.

**(c) The prompt taught agents to narrate compliance instead of build games.**
TAPROOT's final delivery message reads like a v6 self-QA recitation: *"No drone. First spring beatable. Mouse-steering that can't soft-lock. Sustained visual identity across title→gameplay→death. Full pause + auto-pause on tab blur. localStorage guarded against corruption."* Every one of those items is a v6 gate. And the operator's verdict was *"idea bad implementation bad, not feels game at all."* The agent shipped the checklist, not a game.

**(d) The prompt got too long (21 KB) for small models to execute cleanly.**
Qwen3.8-27b and Qwen3.6-27b both failed to bootstrap. That's not conclusively the prompt's fault, but v6's 21 KB of rules leaves less attention budget for the actual creative task than v3's 12 KB did. Both smaller-parameter models in the round failed to even start.

### 3.3 The vaguer "complete loop" language hurt
v3 had explicit "start → gameplay → reward → end → restart" phrasing. v6 replaced with looser "start → meaningful interaction → payoff → restart." Agents interpreted "meaningful interaction → payoff" as "demo a novel mechanic and add a chime when it lands" — hence the half-working technical demos.

## 4. What v7 does differently

v7 (shipped in this same commit) is a ground-up rewrite of `challenge/BATTLE_PROMPT.md`:

| v6 pattern | v7 replacement |
|---|---|
| 21 KB, adversarial tone | **9.7 KB**, calm, concrete tone |
| *"Competent will lose. Safe will lose."* | *"The task is not to impress. The task is to build a game a person is genuinely glad they played."* |
| Explicit cliché list on agent side (created C11) | **Cliché list removed from agent brief** — moved to judge-side only (§6.5, deploy prompt). Agent no longer told "avoid these" and doesn't converge on the anti-cliché. |
| Vague "meaningful interaction → payoff" | **Concrete §1 "What 'a game' means here"**: start / gameplay / reward / end / restart, each explained. Explicit scope suggestion (one core verb, 3–5 levels or 3–5 minutes, simple loss condition, small polish pass). |
| "Depth after wow / graphic ambition / working-3D bonus" as separate escalating sections | Folded into §3 "What a human will notice" — same content, non-panicked phrasing |
| Long self-QA duplicated in prompt + separate file | Short prompt-side checklist (~12 items); full checklist stays in `DEVELOPER_SELF_QA.md` (also trimmed) |
| Two-track / one-shot disclosure buried in gate #12 | Gate #9, one paragraph, plus explicit *"first line of README: TRACK: strict-one-shot or TRACK: iterated (N passes)"* instruction |
| Nine 2026-cluster themes named individually | Zero themes named — agents get to make their own concept choice |
| Multiple sections implying "must be ambitious" | Explicit final line: *"Ship a modest complete game rather than an ambitious broken one."* |

## 5. What survives from Round 002 (kept intentionally)

All evaluator-side and harness infrastructure survives — Round 002's problem was the *agent-facing* prompt tone, not the judge tooling:

- Two-track policy (§2.8) — kept, `TRACK:` disclosure still required in v7 gate #9.
- Cliché-cluster registry (§6.5) — kept, but marked **JUDGE-SIDE ONLY** with an explicit warning about v6's mistake of showing it to the agent.
- Cluster cap → **softened from hard cap to soft note**. Agents weren't warned in v7, so mechanical penalization is unfair. Evaluator note only.
- CEIL-3 mouse extension, CEIL-5 first-level-beatable, CEIL-6 audio drone, CEIL-7 menu leak, CEIL-8 ambition-theater 3D — all kept.
- `M4` first-level anchor, `M8` depth-after-wow, `M6` death readability, `V9` working-3D bonus — all kept.
- New defect classes: DEPTH, AMBITION-THEATER, HONESTY, CLICHÉ-CLUSTER, ATTRIBUTION — all kept.
- `challenge/launch_challenge.py` — `--ship-count`, `_route_track`, `_readme_track_hint`, `fingerprint` — all kept.
- `LAUNCH_PROTOCOL.md` §4.1 arena.ai host quirks — all kept.

New cluster **C11** added to §6.5 registry to record the anti-cliché-cliché that v6 caused.

## 6. Files changed this pass (v7)

| Path | Change |
|------|--------|
| `challenge/BATTLE_PROMPT.md` | **Full rewrite → v7**. From 21 KB adversarial to 9.7 KB calm/concrete. See §4 above. |
| `challenge/DEVELOPER_SELF_QA.md` | Trimmed to match v7 tone. Same items, shorter phrasing, no "heavily weighted" framing. |
| `benchmark/02-scoring-rubric.md` | Cluster cap **softened to note** (was hard cap in Round 002). C11 special-case leniency documented. |
| `benchmark/06-anti-bias-anti-gaming.md` | §6.5 marked **JUDGE-SIDE ONLY** with explicit v6-lesson warning. C11 added as the anti-cliché cliché v6 created. |
| `benchmark/deploy/01-deploy-prompt.txt` | Updated to reference v7. New "asymmetric information" paragraph explains the agent no longer sees the cluster list. Cluster cap changed from hard to soft. |
| `battles/round-003-after-action.md` | (this file) |
| `BATTLE_2_ENTRY.md` | Sanity check updated to grep for `v7` and check v7-specific structure. |
| `README.md` | Battle log row added. |

## 7. Recommended next step

Run **Round 004** as a formal round using v7. Same launch kit (`BATTLE_2_ENTRY.md`), same harness. Specific hypothesis to test:

> Under v7 (calm tone, concrete completeness, no agent-side cliché list, "ship modest complete over ambitious broken" framing), do agents:
> 1. **Ship actual games** (start → gameplay → reward → end → restart) instead of half-working technical demos?
> 2. **Stop converging on cluster C11** (novel-verb + procedural-canvas + WebAudio)?
> 3. **Recover the Round-001 baseline** — at least one entry per round the operator is glad to have played?

If v7 still under-delivers, the next hypothesis is that the arena.ai model pool itself is not yet at the level required for one-shot browser-game creation, and the benchmark's value is in *measuring that gap* rather than in producing shippable games.

## 8. Honest admission

The Round 002 v6 pass over-engineered a prompt that had been working. The instinct to "harden every observed failure mode" was correct; the *execution* dumped every observation into the agent brief, which changed the game the agent thought it was being asked to play. v7 keeps the observations (they're all real) but puts them where they belong: on the judge side and in the self-QA, not in the marching orders. Round 003's failures are the direct cost of that mistake, recorded here so it isn't repeated.

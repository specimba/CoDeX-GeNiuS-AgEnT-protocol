# Launch Protocol — Initiating the Two‑Agent Challenge Fairly

This is the operator's guide to launching the challenge so both agents start from **equal
circumstances**, produce **sophisticated, original, visually ambitious** games, and cannot
exploit or game the benchmark — including when one agent has GitHub/repo access and the
other does not.

Read [`challenge/README.md`](README.md) for the fairness contract and runbook; this document
goes deeper on the two things you asked to be certain about: **how to deliver the identical
challenge** when repo access differs, and **how to guarantee no exploits / score‑tricking**.

---

## 1. The single comprehensive prompt (identical regardless of repo access)

There is exactly **one authoritative challenge**, and it is **fully self‑contained**:

> **`challenge/BATTLE_PROMPT.md`** — embeds the complete game spec, engineering
> standards, anti‑behaviors, self‑QA, deliverables, and definition of done. Nothing else is
> required.

There are **two delivery channels**, and they carry the **same bytes** of instructions:

| Agent has repo access? | How you deliver |
|---|---|
| **Yes** | Give it an isolated workspace provisioned by `launch_challenge.py setup` (contains `BATTLE_PROMPT.md`, `GAME_SPEC.md`, `DEVELOPER_SELF_QA.md`). The agent reads the brief file. |
| **No** | Give it the **entire contents** of `BATTLE_PROMPT.md` as one opening message. `launch_challenge.py single-prompt` emits a paste‑ready `SINGLE_PROMPT.md` for exactly this. |

Because the brief is self‑contained, the agent that never sees the repo knows **everything**
the repo‑access agent knows about *what to build*. Repo access changes **nothing** about the
requirements, the time budget, or the fairness of the comparison.

**Guarantee of equality.** `setup` hashes the brief and writes the hash into the run
manifest, so you can prove both agents received byte‑identical instructions.

## 2. Repository sharing and containment (the exploit you're worried about)

The real risk is not *delivery*, it's **information leakage**: an agent that can see the
evaluation files could tailor its build to the rubric. Three defenses, in depth:

### 2.1 Defense 1 — Keep the evaluation out of the agents' reach (recommended)

- The **agents' workspace** contains **only** the three challenge files. The `benchmark/`
  evaluation package (rubric, weights, ceilings, prompts, aggregator) is **not** copied in.
- The **evaluation package** lives in a **separate repository** (or a private folder the
  agents are never given). If you control both agents, this is trivially enforced.
- `launch_challenge.py setup` never copies `benchmark/` into a workspace — it is a hard
  property of the harness.

### 2.2 Defense 2 — Assume the rubric is public; make the score un‑gameable anyway

You cannot always keep the rubric secret — this very repo is on GitHub. So the design's
core stance is: **assume the agent has read the entire rubric, and make that harmless.**

Every score‑trick that "knowing the rubric" would enable is neutralized structurally:

| If the agent… | Why it doesn't work |
|---|---|
| Ticks spec boxes shallowly to inflate "coverage" | Experience‑over‑compliance: unusable/unreachable features score **zero**, not partial credit. |
| Front‑loads all polish into title/room‑1 | Long sessions (30–60 min) + repeat runs weight late content; flow/engagement can't score above low band on <30 min of play. |
| Piles on effects to inflate "presentation" | Effects that hurt readability are penalized under V2; V0 rewards *originality*, not effect count. |
| Hard‑codes a "known‑good" seed | Seeds are drawn **at evaluation time**; ≥2 seeds required; a single lucky seed is not enough to pass multi‑run reachability. |
| Embeds its own "score"/telemetry | CONTAINMENT audit flags it as a Critical defect and bars that channel. |
| Reads the exact weights (T20 M18…) | Weights can't be gamed in isolation because category scores require evidence, ceilings cap structural failures, and no single knob dominates OVERALL. |
| Tries to detect the evaluator and behave differently | **Environment‑consistency rule** (new): the game must behave identically in any player environment; the evaluator re‑runs key scenarios in different viewports/inputs and flags divergence. |

### 2.3 Defense 3 — Containment audit at freeze

After each build, run `launch_challenge.py audit <build_dir>` (or any grep) for
benchmark‑internal tokens (`CEIL-`, `HARD_PENALTY`, `OVERALL_adj`, `aggregate_scores`,
`evidence_schema`, …). A hit is a **Critical CONTAINMENT defect**. This catches an agent that
sneaked evaluation logic into the build.

### 2.4 If you MUST share one repo (the agents' workspace lives in the same repo as `benchmark/`)

This is the weak case and should be avoided, but if unavoidable:

1. The brief already tells the agent to treat only its workspace as authoritative and to
   build a pure game.
2. **Assume the rubric is public** (Defense 2) so even a fully‑informed agent gains no
   advantage.
3. The containment audit + environment‑consistency check still apply.
4. Never give the agent the *evaluation runbook* or *aggregator* — only the three challenge
   files — and audit the frozen build.

## 3. Equal circumstances → sophisticated, original, visually ambitious games

Your observation is correct: **graphical originality and complexity are where AI game builds
most often fall short**, yet capable agents on long, well‑scoped runs do produce close‑to‑AA
HTML games. To make this the thing we actually test, the brief and rubric now explicitly
reward it:

- The brief's new **Graphical Ambition** section (in `BATTLE_PROMPT.md`) instructs
  agents to build original, richly detailed, procedural visuals and to spend real effort on
  the visual identity — not primitive shapes or empty rooms.
- The rubric gained **V0 — Graphical originality, visual richness & complexity**, with clear
  low/medium/high anchors, so evaluators *must* distinguish "original and complex" from
  "generic." This is the exact gap one‑shot benchmarks miss.
- To get a *high* score on flow/engagement the build must survive 30–60+ minutes of live
  play — the same bar that separates a one‑shot demo from a real game.

Equal circumstances are then enforced mechanically: **identical brief** (hashed), **equal
time budget** (recorded in the manifest), **frozen builds**, and **blind labels**.

## 4. The full launch sequence

```
1. python challenge/launch_challenge.py setup --out runs/round1 --agents 2 --budget-min 60
   -> creates runs/round1/agent1 + agent2 (identical brief+spec+self-QA), writes manifest.
2. Launch agent1 and agent2 in PARALLEL for the same wall-clock budget.
   - repo-access agent: work in its workspace folder.
   - no-repo agent: send SINGLE_PROMPT.md contents; it builds in its own env.
3. When each reports done: python challenge/launch_challenge.py finalize --out runs/round1
   -> records end time + build hashes + elapsed minutes per agent (audits equal budget).
4. Containment audit each delivered game build:
   python challenge/launch_challenge.py audit runs/round1/agent1/game runs/round1/agent2/game
5. Copy only the frozen GAME build (not the workspace scaffolding) to the evaluation side.
6. Assign blind labels A/B (random, secret); launch evaluator(s) per benchmark/01 + 03.
7. Aggregate per benchmark/ops/aggregate_scores.py; select per benchmark/08.
```

## 5. What is guaranteed and what is not

**Guaranteed** by the harness: identical instructions, equal time budget, frozen builds,
blind labeling, containment of the evaluation package from the agent workspaces, and
environment‑consistency checks.

**Not guaranteed** (and impossible to fully guarantee with a public rubric): that an agent
never *reads* the rubric. That is why the rubric is designed to be **public‑safe** — see
Defense 2. The benchmark measures the *artifact a player experiences*, which no amount of
rubric‑reading can fabricate.

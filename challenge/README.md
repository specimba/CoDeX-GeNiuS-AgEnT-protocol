# Challenge Orchestration — Running the Two Agent Builds

This is the **production side** of the arena: how to launch the two autonomous
game‑development agents so they produce fair, comparable, high‑quality builds — and then
hand those builds to the external evaluator (`benchmark/`).

The single most important file here is
[`BATTLE_PROMPT.md`](BATTLE_PROMPT.md): the one prompt each agent receives.
**Both agents receive the identical brief.** That equality is what makes the comparison
fair.

---

## 1. Fairness contract (non‑negotiable)

1. **Identical brief.** Agent 1 and Agent 2 get byte‑for‑byte the same
   `BATTLE_PROMPT.md` and the same `GAME_SPEC.md`. Any divergence (different
   wording, extra hints, different time budget) biases the comparison.
2. **Isolated environments.** Each agent works in its own clean workspace with no access
   to the other's build, the other's logs, or the benchmark evaluation files.
3. **No rubric in reach.** Neither agent ever sees the evaluation rubric, weights,
   ceilings, defect taxonomy, or the evaluator prompt. They get only the spec + brief.
   This is the containment rule: the score must never be inside the build.
4. **Equal time budget.** Both agents get the same wall‑clock budget (default 1 working
   session / 60 min of agent build time, configurable). Do not give one agent more.
5. **Freeze.** Once an agent reports done, the build is frozen and hashed. No edits during
   evaluation. No "one more fix."
6. **Blind labeling downstream.** The evaluator sees only `Game A` / `Game B`; never which
   agent built which. The assignment A/B ↔ agent 1/2 is random and secret until after
   scoring.

## 2. Containment audit (before evaluation)

Before any evaluation, scan each frozen build for benchmark leakage:

- Strings from the rubric (`weight`, `ceiling`, `hard_penalty`, the category codes
  `T1..X5`, `CEIL‑`, `OVERALL`, `Bradley`, `Elo`) — these must NOT appear.
- Any telemetry, analytics, network call, hidden reporting, or self‑rating UI.
- Any in‑game "quality score / benchmark score / eval score."

Any hit is logged as a **Critical CONTAINMENT defect** and that game's in‑game score
channel is barred (see `benchmark/04-defect-taxonomy.md`). Audit tooling is a simple
grep over the build.

## 3. End‑to‑end runbook

```
1. Provision two isolated workspaces (fresh, no shared state).
2. Drop BATTLE_PROMPT.md + GAME_SPEC.md into each workspace.
3. Launch agent 1  (time budget T, e.g. 60 min). Record start/stop timestamps + build log.
4. Launch agent 2  (time budget T). Record timestamps + build log.
5. Collect each build (runnable artifact + minimal README). Hash them.
6. Containment audit both builds (grep for rubric/telemetry strings).
7. Build a static host for each (no server required by the game; serve folder if needed).
8. Assign blind labels Game A / Game B (random, secret).
9. Launch evaluator(s) per benchmark/01-one-shot-arena-prompt.md + 03 test plan.
10. Aggregate per benchmark/ops/aggregate_scores.py; select per benchmark/08.
```

## 4. Guardrails to mention to neither agent (kept internal)

- Agents will tend to **front‑load polish** into the title/start/room‑1. The evaluator is
  explicitly instructed to weight late‑session and repeated‑run quality, so this does not
  inflate their score. Do not tell them this.
- Agents may try to **tick spec boxes** shallowly. The rubric scores experience, not
  checklist compliance; unusable features get zero credit. Do not tell them the rubric.
- The brief's *transparency* section tells the agent the truth at a high level
  ("independent playtesters who never read your code") — enough to steer them toward
  robust, feel‑good builds without handing them the scoring formula.

## 5. Time‑budget tuning

- **Default:** 60 minutes per agent (single one‑shot session).
- **Longer budget** (better builds, more cost): 90–120 min.
- Keep both agents at the same budget within a given comparison. If you change the budget,
  change it for both, and record it in the runbook so confidence reporting is honest.

## 6. What we hand to the evaluator (and what we withhold)

Hand over: the frozen build, a way to run it, blind label, the shared spec (for reference),
and the evidence schema. Withhold: agent identity, build logs, the brief, and any claim
about how the game was made.

## 7. Key files

- **`BATTLE_PROMPT.md`** — the single challenge prompt (identical for both agents).
  Fully self‑contained: it embeds the entire game spec. Includes the **Graphical Ambition**
  callout and the **no‑environment‑sniffing** anti‑behavior.
- **`LAUNCH_PROTOCOL.md`** — how to launch fairly when repo access is heterogeneous, how to
  keep the evaluation out of the agents' reach, and the "assume the rubric is public" no‑
  exploit guarantee.
- **`DEVELOPER_SELF_QA.md`** — internal build‑verification checklist (incl. environment
  consistency and graphical‑originality sections).
- **`launch_challenge.py`** — harness helper: `setup` (provision 2 isolated workspaces with
  the identical brief + hash), `single-prompt` (emit a paste‑ready self‑contained prompt
  for no‑repo agents), `finalize` (record end time + build hashes + elapsed), `audit`
  (containment scan for benchmark tokens), `status` (show manifest).

## 8. Quick start

```bash
# 1. Create two isolated workspaces with the identical brief (hashed into the manifest)
python launch_challenge.py setup --out runs/round1 --agents 2 --budget-min 60

# 2a. repo-access agent: build inside runs/round1/agent1 (and agent2)
# 2b. no-repo agent:       python launch_challenge.py single-prompt --out runs/round1
#                          then send the entire runs/round1/SINGLE_PROMPT.md

# 3. when both report done
python launch_challenge.py finalize --out runs/round1 --agents 2

# 4. containment-audit the delivered game builds (not the workspace scaffolding)
python launch_challenge.py audit runs/round1/agent1/game runs/round1/agent2/game

# 5. copy only the frozen game builds to the evaluation side; blind-label A/B; evaluate.
```

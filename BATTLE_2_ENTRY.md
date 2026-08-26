# BATTLE — Unknown-LLM Round · Paste-Ready Launch Kit

This is the single file to open when you're ready to run a new round on arena.ai. It packages the launch procedure, the per-run scoresheet, and the paste-ready contestant prompt in one place. Everything else in the repo is supporting material.

**Prompt version:** BATTLE_PROMPT **v9** (v8 + targeted §4.3 "retro-visuals trap" — narrow addition after Round 006 operator complaint about 2013-mobile-game visuals)
**Rubric version:** 02-scoring-rubric §2.0–§2.9 (cluster cap soft, not hard)
**Anti-gaming version:** 06-anti-bias-anti-gaming §6.1–§6.8 (§6.5 cluster registry judge-side only; C11 caused by v6, C12 caused by v7, C13 persistent-visual-mode documented Round 006)
**Ready:** yes — see `battles/round-006-after-action.md` for the targeted v9 change, and `battles/round-005-after-action.md` for the "hold v8 constant, don't correction-spiral" learning that v9 respects.

---

## Part 1 — Operator runbook (do this)

### 1.1 Pre-flight (5 min)
- [ ] Confirm you can access two blind arena.ai battle slots (or two isolated agent sessions on a comparable platform).
- [ ] Pick a wall-clock budget for both agents (recommended: **90 min** for Battle 2 — enough to iterate + polish, short enough to be honestly one-shot).
- [ ] Pick a hardware/browser profile for evaluation (recommended: your daily driver desktop + one mobile).
- [ ] Note the current UTC time. This is the round start.

### 1.2 Provision the workspace
```bash
python challenge/launch_challenge.py setup \
    --out runs/round-002-formal \
    --agents 2 \
    --budget-min 90

python challenge/launch_challenge.py single-prompt \
    --out runs/round-002-formal
```

This creates two isolated agent workspaces containing only the identical brief + spec + self-QA (no `benchmark/` — see §6.4 Enforcement rules), records the SHA-256 of the brief in `manifest.json`, and emits a paste-ready `SINGLE_PROMPT.md` for the no-repo delivery channel.

### 1.3 Launch (in parallel)
- **Agent A** (arena.ai battle slot 1): paste `SINGLE_PROMPT.md` contents (Part 2 of this file is a duplicate for convenience — either is fine, they're byte-identical).
- **Agent B** (arena.ai battle slot 2): same paste.
- **Do not disclose** any information to either agent beyond the brief. Do not answer clarifying questions with new content. If asked, reply *"Everything you need is in the brief. Make your best call."*
- **Count ships.** For each agent, note in `runs/round-002-formal/notes.txt` how many times they deliver a "here is the final game" style message. **1 = strict-one-shot. > 1 = iterated track.**

### 1.4 Freeze
When each agent reports done (or the 90-min budget is up):
```bash
python challenge/launch_challenge.py finalize \
    --out runs/round-002-formal \
    --agents 2 \
    --ship-count agent1=<N>,agent2=<M>
```

If the agent produced files but you cannot pull them into the workspace directly (arena.ai often keeps builds inside its own sandbox), copy the final HTML/folder into `runs/round-002-formal/agent1/game/` and `agent2/game/` manually before running finalize.

### 1.5 Fingerprint & audit
```bash
python challenge/launch_challenge.py fingerprint \
    runs/round-002-formal/agent1/game \
    runs/round-002-formal/agent2/game

python challenge/launch_challenge.py audit \
    runs/round-002-formal/agent1/game \
    runs/round-002-formal/agent2/game
```

- `fingerprint` writes `fingerprint.json` (stack, deps, asset-count hint). This is the ground truth for §6.6 model attribution — arena UI labels are never trusted.
- `audit` scans for benchmark/rubric/telemetry tokens leaking into the game. Any hit = Critical CONTAINMENT defect.

### 1.6 Blind-label assignment (physical coin flip is fine)
Flip a coin — heads: agent1 → Game A, agent2 → Game B. Tails: swap. Record in `runs/round-002-formal/labels.txt`. **Do not share this mapping with the evaluator until after scoring.**

### 1.7 Score (deploy prompt)
Open `benchmark/deploy/01-deploy-prompt.txt` and follow it to the letter. Score Game A completely, lock it, THEN score Game B, THEN pairwise. Fill out `benchmark/05-reporting-template.md`. Emit evidence per `benchmark/ops/evidence_schema.json`.

### 1.8 Decide
```bash
python benchmark/ops/aggregate_scores.py --evidence runs/round-002-formal/evidence.json
python benchmark/ops/decision_block.py    --evidence runs/round-002-formal/evidence.json
```

### 1.9 Attribute & archive
- Open `manifest.json` — read `fingerprint.json`, resolve model identity, write `identity.json` (arena UI label + fingerprint verdict + any ATTRIBUTION anomaly).
- Merge into `battles/round-002-formal-after-action.md` AFTER the OVERALL is locked. Never before.
- Add a row to the README `## Battle log` section.

---

## Part 2 — Contestant prompt (byte-identical to `challenge/BATTLE_PROMPT.md`)

The paste target below is exactly the v6 prompt. It is intentionally the *only* thing the agent sees. Do not add framing, warnings, hints, or answers to clarifying questions.

> **BEGIN PASTE — copy from the next line all the way through the END PASTE marker, inclusive of headings and blank lines. Do not paraphrase.**

```
[Copy the entire current contents of challenge/BATTLE_PROMPT.md into your agent chat. This
file intentionally does NOT re-embed those bytes here to avoid drift — the launch_challenge.py
single-prompt subcommand emits the same bytes into runs/<round>/SINGLE_PROMPT.md, which is
the canonical paste target for the run.]
```

> **END PASTE.**

To get the actual bytes:
```bash
cat challenge/BATTLE_PROMPT.md          # single-file view
# OR
cat runs/round-002-formal/SINGLE_PROMPT.md   # after step 1.2 above
```

Both are hashed into `manifest.json` at setup time — if the two agents receive different bytes, the round is invalid.

---

## Part 3 — Per-run scoresheet (fill during evaluation)

Copy this block into your evaluator notes and fill it in as you play. Do not compute OVERALL by hand — let `aggregate_scores.py` do it. This scoresheet is a discipline aid, not the source of truth.

```
ROUND:              002-formal
DATE (UTC start):
DATE (UTC end):
BUDGET (min):       90
HARDWARE PROFILE:
BROWSER MATRIX:

===== GAME A =====
Track (from manifest):        strict-one-shot | iterated
Ship count:                   __
Concept (one sentence):
Rendering stack (fingerprint): canvas2d | webgl | webgpu | three.js | dom-css | text | other:
Cliché cluster (§6.5) hit?    none | C1 | C2 | C3 | C4 | C5 | C6 | C7 | C8 | C9 | C10

Category (mean of sub × 2, 0–10):
  T Technical / Code Quality             __ / 10
  M Core Mechanics & Code Craft          __ / 10
  G Gameplay & Human-Perceived Quality   __ / 10
  F Game Flow & Coherence                __ / 10
  V Visual & Presentation                __ / 10   (V0 __ · V8 __ · V9 __)
  A Atmosphere & World Invention         __ / 10
  X Accessibility & Inclusion            __ / 10

Ceilings triggered (list all that apply):
  [ ] CEIL-1  main-path crash / soft-lock
  [ ] CEIL-2  primary loop unreachable
  [ ] CEIL-3  core controls broken (incl. mouse)
  [ ] CEIL-4  persistence fails on fresh browser
  [ ] CEIL-5  first level unbeatable in ~5 min
  [ ] CEIL-6  constant unmuteable audio drone
  [ ] CEIL-7  menu ↔ gameplay state leak
  [ ] CEIL-8  ambition-theater 3D

Defects logged (count by severity):
  Blocker: __   Critical: __   Major: __   Minor: __   Trivial: __

Strongest beat (SUBJ, cite timestamp):
Weakest moment (OBS, cite timestamp):

===== GAME B =====
[repeat the entire A block]

===== PAIRWISE (open ONLY after both games independently locked) =====
Preferred game:                        A | B | Tie
Reason (2–4 sentences, evidence-cited):
Confidence (LOW | MED | HIGH):
Would you show this to someone?        A | B | Neither | Both
Convergent-cliché present in loser?    yes | no
Convergent-cliché present in winner?   yes | no
Track mismatch?                        (if one is iterated, note here)

===== FINAL =====
DECISION:      [Game A wins | Game B wins | Tie]
OVERALL:       A = __ | B = __ (margin __)
Confidence:    LOW | MED | HIGH
Rationale (from decision_block.py):
```

---

## Part 4 — Post-round handoff

After Battle 2 is locked and attributed, produce:

1. **`battles/round-002-formal-after-action.md`** — the same shape as `battles/round-001-after-action.md` and `round-002-after-action.md` in this repo. Include the model attribution, the fingerprint mismatch (if any), which cliché cluster (if any) was hit, and one paragraph on which failure modes v6 successfully caught vs missed.

2. **Cliché-cluster registry update** — if Battle 2 shows a NEW convergent theme not in §6.5, add it to that table (with `Observed models` and `Round(s)` filled in).

3. **v7 prompt hypothesis** — if v6's cliché-cluster warning failed to prevent convergence, escalate the warning to an outright ban on those specific themes in v7. Draft the change here so the next round can adopt it.

4. **`README.md` battle-log row** — add:
   ```
   | 002-formal | YYYY-MM-DD | <winner>  | <models>  | one-liner takeaway |
   ```

---

## Part 5 — Known-good preconditions (sanity check before you start)

Run this from repo root:

```bash
python3 -m py_compile challenge/launch_challenge.py benchmark/ops/aggregate_scores.py benchmark/ops/decision_block.py && echo "harness OK"

grep -q "(v9)" challenge/BATTLE_PROMPT.md && echo "prompt: v9 loaded (v8 + retro-visuals trap §4.3)"
BYTES=$(wc -c < challenge/BATTLE_PROMPT.md); [ "$BYTES" -lt 20000 ] && echo "prompt: size OK ($BYTES bytes, ceiling 20000 raised from 18000 for v9 §4.3)"
grep -q "actual game designers do" challenge/BATTLE_PROMPT.md && echo "prompt: §1 craft-based working method present (kept from v8)"
grep -q "DESIGN_PILLARS" challenge/BATTLE_PROMPT.md && echo "prompt: DESIGN_PILLARS README requirement present (kept from v8)"
grep -qE "MDA|Swink|Vlambeer|Porpentine|Ludum Dare" challenge/BATTLE_PROMPT.md && echo "prompt: craft tradition cited (kept from v8)"
grep -q "retro-visuals trap" challenge/BATTLE_PROMPT.md && echo "prompt: §4.3 retro-visuals trap present (new in v9)"
grep -q "ambition-theater trap is real" challenge/BATTLE_PROMPT.md && echo "prompt: v9 ambition-theater guardrail present (prevents C11 recurrence)"
grep -qE "M8 |Depth after wow" benchmark/02-scoring-rubric.md && echo "rubric: M8 depth-after-wow present"
grep -q "CEIL-8" benchmark/02-scoring-rubric.md && echo "rubric: CEIL-8 ambition-theater 3D present"
grep -q "JUDGE-SIDE ONLY" benchmark/06-anti-bias-anti-gaming.md && echo "anti-gaming: cluster registry judge-side-only"
grep -q "C13" benchmark/06-anti-bias-anti-gaming.md && echo "anti-gaming: C13 retro-visuals-collapse recorded (Round 006)"
grep -q "track" challenge/launch_challenge.py && echo "harness: track routing present"
grep -q "TRACK: strict-one-shot" challenge/BATTLE_PROMPT.md && echo "prompt: track disclosure requested"
! grep -q "Competent.*will lose" challenge/BATTLE_PROMPT.md && echo "prompt: v6 'competent will lose' framing STILL removed"
```

Expected output: fourteen OK lines. If any are missing, do not start — inspect `battles/round-006-after-action.md` for what changed and re-verify.

---

*This kit is the operator's single source of truth for launching Battle 2. Everything else in the repository supports it.*

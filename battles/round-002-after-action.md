# Battle Round 002 — After-Action Record

**Status:** informal / directional. Not a formal S1–S8 scored round.
**Source logs (local, gitignored):** `.experiments/roguelike1.txt`, `.experiments/freecreation2.txt`, `.experiments/freecreation3.txt`
**Operator:** specimba
**Recorded by benchmark:** 2026-08-20 (Ankara)
**Prompt versions active during observations:** BATTLE_PROMPT v3–v5 (mix), plus freebuff "WOW v5" prompt in freecreation3

---

## 1. Summary

Three overlapping sessions of one-shot game creation on arena.ai and adjacent tools (freebuff, Lovable, MiMo 2.5) produced ~8 distinct game deliveries across ~10 models. The operator's per-game commentary is the primary evidence source; raw session transcripts are archived in `.experiments/` for cross-check.

The observed failure modes are consistent enough to drive a rubric + prompt update (this document → the v6 pass). None of these runs were executed under the formal S1–S8 protocol, so no round result is recorded in the formal battle log.

## 2. Games observed and operator verdicts

| # | Model (claimed / attributed) | Game | Track | Operator verdict (verbatim, condensed) | Failure mode → rubric anchor |
|---|---|---|---|---|---|
| 1 | claude-haiku-4-5 (attributed via fingerprint; arena UI initially named "claude-haiku-4-5", swapped to "grok-4.5" post-selection) | **CHROMAFLUX** — color-cascade puzzle-action, particles-conducted-by-gates | strict-one-shot | (no explicit verdict — appears functional & complete but competing entry was preferred) | — |
| 2 | Kiana (arena-blind, community-attributed Qwen3.8-Max; the same model self-identified as Claude in an internal think trace) | **LUMEN MOTH** — lantern-and-moths night garden, spring-damper pendulum lantern, boid moths, procedural WebAudio | strict-one-shot | **Selected as winner** — genuinely liked; sustained mood; craft visible | Concept lands in **cliché-cluster C1** (lantern-and-moths) → V0/V1 cap 3 per §2.7 |
| 3 | Gemini 2.6 flash | **Project Olympus: Mach Mech Surfer** — 3D mech-grapple-slingshot, 300m Sky Dreadnought | strict-one-shot | *"very buggy … 0 point on one shot experiment"* | **AMBITION-THEATER 3D** → V9=0, CEIL-8 (55). Cluster C4. |
| 4 | Gemini 3.7 flash (Google AI Studio) | **Shatter-Point** — 2D physics slingshot, hi-contrast "paper obsidian and blood glass" | strict-one-shot | *"very simple but not revolutionary billard like shattering … **out-of-canvas mouse reach makes game buggy to fail at all**"* | **INPUT (mouse out-of-canvas)** → CEIL-3 (60). Concept lands in cluster C3. |
| 5 | Gemini Pro 3.1 (browser canvas tool) | 3D spaceship | strict-one-shot | *"buggy … **menu collapsing inside game** classic gemini shits again"* | **LOGIC/STATE (menu-gameplay leak)** → CEIL-7 (60). AMBITION-THEATER 3D → CEIL-8. |
| 6 | Qwen 3.8 Max (browser web-dev tools) | Glassblowing / quenching / commission puzzle | strict-one-shot | *"creative and very hard to handle actually fun but **strangely hard to beat even first level** … creative game mechanics but **not creating any continue interest** after couple fails"* | **M4 first-level-beatable failure** → CEIL-5 (50). **M8 depth-after-wow failure** → DEPTH defect. |
| 7 | glm-5.2 | **墨 INK** — sumi-e ink-painting combat with hanko seals | strict-one-shot | *"strangely weak approach from glm-5.2 feels real carving with sound and game feeling … but **0 meaning of up to date frontier LLM creation capability** representation"* | Cluster C2 (sumi-e-combat) → V0/V1 cap 3. Otherwise competent — no CEIL. |
| 8 | ChatGPT 5.6 SOL (browser) — deployed at optgamehtml.oneapp.dev | Spectral Frontier — optics puzzle w/ real-physics ambition | **iterated (disqualified from primary battle)** | *"very cool idea … **not one shot** — very strong mindset but still cannot be considered scored"* | **§2.8 iterated track** — cannot win primary battle. Cluster C10. |
| 9 | MiMo 2.5 (freebuff dev sandbox) | 3D marble tilt game | iterated (multi-turn debug pass) | *"looking good with 3d visuals but **marble starting or controls on gameplay very problematic bugs not even fixed in couple turns**"* | **AMBITION-THEATER 3D** + iterated track. CEIL-8 (55). |
| 10 | freebuff experiment (v5 "WOW" prompt) | — (prompt document itself) | — | Superb synthesis — adopted as the base for BATTLE_PROMPT v6 | — |

## 3. Cross-cutting patterns

### 3.1 3D-ambition-without-control (4 of 10 runs)
Runs #3, #5, #9, and MiMo (#9) all shipped 3D scenes with impressive visuals and broken controls. This is the single most common structural failure of the round. **Response:**
- Introduced `V9` — working-3D bonus that explicitly *rewards* landed 3D but zeros for broken 3D.
- Introduced `CEIL-8 (55)` — hard ceiling for ambition-theater 3D.
- Added `Q. Ambition-vs-execution honesty` section to DEVELOPER_SELF_QA.
- Explicit anti-pattern in BATTLE_PROMPT §2: *"Broken 3D scores below competent 2D."*

### 3.2 Convergent AI cliché themes (5 of 10 runs)
- C1 lantern-and-moths (LUMEN MOTH)
- C2 sumi-e-ink-combat (墨 INK)
- C3 brutalist-paper-obsidian-slingshot (Shatter-Point)
- C4 photorealistic-3D-speed-mech (Project Olympus + MiMo marble)
- C10 optics-spectrum-puzzle (Spectral Frontier / SOL)

The operator explicitly flagged this dynamic. **Response:**
- New §6.5 **Cliché-cluster registry (living)** — 10 clusters populated from observation.
- New §2.7 **cliché-cluster V0/V1 cap** at 3 unless clearly transformative.
- BATTLE_PROMPT v6 §2 lists the specific 2026 cluster with a warning that they've been seen.

### 3.3 First-level unbeatable / depth-after-wow (2 of 10 runs)
Qwen glassblowing (#6) had creative mechanics but "strangely hard to beat first level" + "not creating continue interest after couple fails". LUMEN MOTH (#2) sustained interest better but is a 5-minute run. **Response:**
- New `M4` anchor: first level beatable in ~5 min honest play, else score 0-1.
- New `M8`: **Depth after wow / sustained interest at minute 5** — dedicated sub-criterion.
- New `CEIL-5 (50)`: first level unbeatable by real human.
- New `DEPTH` defect class in taxonomy.
- New `S9 Creative Probe` in the evaluator protocol.

### 3.4 Multi-turn contamination of one-shot claim (2 of 10 runs)
SOL Spectral Frontier (#8) and MiMo marble (#9) both went through multi-turn iteration but were being compared informally to strict-one-shot runs. The operator correctly rejected them from the score comparison. **Response:**
- New §2.8 **two-track policy**: strict-one-shot vs iterated shelf. Iterated cannot win primary battle.
- New `--ship-count` argument + `_route_track` logic in `challenge/launch_challenge.py`.
- New `fingerprint` subcommand to capture build stack per §6.6.
- New `HONESTY` defect class for undisclosed multi-turn.
- BATTLE_PROMPT v6 gate #12: *"One shot"* + Definition-of-Done line: "the build I am about to ship is the *actual result of one session*".

### 3.5 Mouse / input failures on shipped builds (2 of 10 runs)
Battle 1 (roguelike, claude-opus-4-8 winner) had broken mouse + audio drone (already logged in `battles/round-001-after-action.md`). Shatter-Point (#4) had out-of-canvas mouse soft-lock. **Response:**
- CEIL-3 extended to explicitly cover mouse-broken cases.
- INPUT taxonomy entry extended with mouse-specific patterns.
- New `P-MouseIntegrity` probe in the evaluator protocol.
- DEVELOPER_SELF_QA §B updated with "real mouse" line.

### 3.6 Menu ↔ gameplay leak (1 explicit + several implicit)
Gemini Pro 3.1 3D spaceship (#5) had "menu collapsing inside game". This is a distinct failure mode from generic LOGIC/STATE. **Response:**
- New `CEIL-7 (60)` explicitly for menu-gameplay leak.
- LOGIC/STATE taxonomy entry extended.
- New `P-StateIsolation` probe in the evaluator protocol.

### 3.7 Audio drone (Battle 1 finding, reconfirmed)
Already merged in round-001. Reinforced with:
- New `CEIL-6 (65)` for constant unmuteable drone.
- AUDIO taxonomy entry extended.
- BATTLE_PROMPT v6 gate #8 explicit "no constant drone" line.

### 3.8 Model identity leakage (arena-side)
- Arena UI showed "claude-haiku-4-5" then swapped to "grok-4.5" post-selection.
- Blind label "Kiana" community-attributed to Qwen3.8-Max.
- Qwen3.8-Max self-identified as Claude in a think trace.

**Response:**
- New §6.6 **Model-identity handling (blind-arena leakage)** — evaluator never scores by claimed identity; fingerprint.json is ground truth; identity.json is captured separately AFTER score is locked.
- New `ATTRIBUTION` defect class (against the round, not the game).
- LAUNCH_PROTOCOL §4.1 documents arena.ai host quirks explicitly.

## 4. Files changed this pass (v6)

| Path | What changed |
|------|--------------|
| `challenge/BATTLE_PROMPT.md` | Rewritten as v6 from freebuff "WOW v5" base + our Kernel/CEIL/honesty gates. Explicit cliché-cluster warning; polish floor; working-3D framing; depth-after-wow; one-shot gate. |
| `challenge/DEVELOPER_SELF_QA.md` | Added mouse-integrity, menu-isolation, first-level-beatable, depth-after-wow, audio-hygiene, ambition-vs-execution items. |
| `challenge/LAUNCH_PROTOCOL.md` | Added ship_count capture, fingerprint capture, track-routing step, §4.1 arena.ai host quirks. |
| `challenge/launch_challenge.py` | Added `--ship-count`, `_route_track`, `_readme_track_hint`, `fingerprint` subcommand. Backward-compatible. |
| `benchmark/02-scoring-rubric.md` | Added M8 (depth-after-wow), V9 (working-3D bonus), M4 first-level-beatable anchor, M6 death-readability, CEIL-5/6/7/8, §2.7 cliché-cluster cap, §2.8 two-track policy, §2.9 working-3D rules. |
| `benchmark/04-defect-taxonomy.md` | Added DEPTH, AMBITION-THEATER, HONESTY, CLICHÉ-CLUSTER, ATTRIBUTION classes. Extended INPUT (mouse), LOGIC/STATE (menu leak), AUDIO (drone), BALANCE (first-level). |
| `benchmark/06-anti-bias-anti-gaming.md` | Added §6.5 Cliché-cluster registry with 10 seeded entries; §6.6 Model-identity handling; §6.7 Track enforcement; renumbered 6.4 → 6.8 Consistency checks. |
| `benchmark/deploy/01-deploy-prompt.txt` | Genericized from "Ashen Descent" to open-brief. Added S9 Creative Probe + P-MouseIntegrity/P-AudioHygiene/P-StateIsolation/P-FirstLevel/P-3DAmbition probes. CEIL-5/6/7/8 added. Cliché-cluster + track + identity rules folded in. |
| `battles/round-002-after-action.md` | (this file) |
| `BATTLE_2_ENTRY.md` | (companion: paste-ready arena launch kit) |

## 5. What this round did NOT test (limitations)

- **Formal S1–S8 coverage** was not run for any of the 10 games. All verdicts are directional.
- **Blind labeling** was partly compromised by arena.ai UI quirks — the operator saw model names in several runs.
- **Order counterbalancing** did not occur — games were reviewed sequentially as they were produced.
- **Multi-evaluator panel** — single operator throughout. Inter-rater agreement (κ / α) not measurable.
- **Evidence bundle** — no per-game screenshots / recordings archived beyond the operator's inline commentary.

Consequently: **no round result is entered into the formal battle log**. This round exists to drive rubric evolution, not to declare a winner among these 10 games.

## 6. Recommended next step

Run **Battle 2** as a formal round using the v6 kit (`BATTLE_2_ENTRY.md`):
1. `python challenge/launch_challenge.py setup --out runs/round-002-formal --agents 2 --budget-min 90`
2. Two arena.ai agents launched in parallel with BATTLE_PROMPT v6 identical bytes.
3. On ship: `finalize --ship-count agent1=N,agent2=M` and `fingerprint` per §6.6.
4. Blind labels A/B assigned by harness.
5. Full S1–S9 protocol per `03-long-session-test-plan.md`.
6. Aggregate + decision block per `benchmark/ops/`.
7. Model identity merged into after-action AFTER score is locked.

The specific hypothesis Battle 2 should test:
> With the v6 prompt (explicit cliché warning, polish floor, working-3D framing, depth-after-wow gate, one-shot enforcement), do the frontier models (Claude Opus 5 / GPT-5.6 Sol / Kimi K3 / Qwen3.8 Max) still converge on lantern-and-moths / sumi-e / brutalist-slingshot? Or does the explicit warning push them into genuinely divergent concepts?

If they still converge, the v6 warnings need to become v7 outright bans on those specific themes.

# Battle Round 004 — After-Action Record

**Status:** informal / directional. Not a formal S1–S8 scored round.
**Source log (local, gitignored):** `.experiments/freecreation5.txt`
**Operator:** specimba
**Recorded by benchmark:** 2026-08-22 (Ankara)
**Prompt version active during observations:** BATTLE_PROMPT **v7** (the calmer, shorter prompt shipped after Round 003's v6 regression)

---

## 1. Summary

Round 004 tested v7 across arena.ai. **Two of four builds independently converged on the same game — a shield-arc-rotation deflection arcade with waves, upgrades, and a boss.** The operator's verdict: *"gemini's creation nearly same as hy3's creation that means your prompt failed. and that whole testings are getting worse even with new models very strange."*

That verdict is exactly right. v7 didn't fix the problem — it just moved which cluster the agents converged on. This is the third consecutive round where prompt tone changes have produced *different* convergences rather than *broken* convergence.

This round drove a diagnosis rooted in published research and a v8 prompt that encodes real game-designer craft (MDA reversal, design pillars, find-the-fun ordering, small interlocking systems, notebook-then-scary-pick concept selection) as a working method — replacing rule-list prompts with craft-based ones. **v8 has shipped as part of this same commit.**

## 2. Games observed and operator verdicts (verbatim)

Log 5 starts with the v7 `BATTLE_PROMPT.md` pasted verbatim as the agent input, then contains 5 arena.ai sessions:

| # | Model | Game shipped | Operator verdict |
|:---:|---|---|---|
| S1 | **grok-4.6** (browser-beta sandbox) | **NINTH BELL** — gothic-cathedral lantern game (visible in generated brand-asset prompts + hero images before session cut off) | *"grok 4.6 with new browser build mode beta sandbox capabilities but made whole time nonsense related creation 2d simple game created. This is single shot single test"* |
| S2 | **hunyuan-hy3-preview** | **AEGIS — one shield, ten waves.** Rotate a single glowing arc around a core. Deflect enemy bolts back at their shooters. 10 hand-escalated waves + Warden boss at 5 and 10 + 8 upgrades × 3 levels each after every wave + chain-multiplier + Endless mode. All-canvas, all-synth-audio. | *"hy3's creation interestingly good game mechanics and evolving with diffuculty, other game is very un fun at all, both 2d simple dot circles boxes etc but hy3 created a real game with levels, still 0 graphical revolution"* |
| S3 | **deepseek-v4-pro** | Gravity-flip arcade with waves (spike/mine ratio, boost mechanic, combo, high scores). | (grouped in the "other game very un fun" verdict above) |
| S4 | **gemini-3.5-flash** | **REFLECTRON.** Single shield arc rotation deflection game. 5 sectors + escalating enemy types + card-based roguelike upgrades between sectors + final boss **VORTEX APEX**. All-canvas, procedural synth audio. | (see combined verdict below) |
| S5 | **qwen3.8-27b** | **SHATTER.** Hold + swipe to slice arcing crystals. 9 escalating "frequency" tiers with new crystal types + splitters + ward shells + 3-life system + combo-driven pitch on synth. Pixel font, all-canvas, all-synth-audio, no image assets. | ***"gemini's creation nearly same as hy3's creation that means your prompt failed. and that whole testings are getting worse even with new models very strange"*** |

The specific convergence:
- **hy3 → AEGIS**: "rotate one shield arc around a core, deflect bolts back at shooters, 10 waves, upgrades, boss"
- **gemini → REFLECTRON**: "single shield arc rotation deflection, 5 sectors, roguelike upgrades, boss VORTEX APEX"

Two independent frontier-tier models, from the same v7 prompt, shipped the same game concept. That is not "the prompt was bad in the way v6 was bad" — that is *concept-space collapse* onto a specific game type.

**All four shipping models converged on a broader cluster** — arcade waves + escalating enemy types + combo/upgrades + optional boss + 2D canvas + procedural everything. This is registered below as **cluster C12** (judge-side only, per §6.5 rules).

## 3. Diagnosis — what's actually happening (grounded in the literature)

I did a directed web search on why post-training-aligned LLMs converge on the same "safe" template for open-ended creative prompts. Three findings ground what we're seeing:

### 3.1 It's not a prompt tone problem — it's a documented alignment side-effect

The phenomenon has a name in the ML literature: **mode collapse** in post-trained models. From Zhang et al. "Verbalized Sampling: How to Mitigate Mode Collapse and Unlock LLM Diversity" (arxiv.org/abs/2510.01171, Oct 2025) and Kirk et al. earlier: RLHF and instruction-tuning systematically collapse creative distributions onto typical/high-reward templates. For any *open-ended creative* prompt, models reach into the same trained region and pull out the same answer, regardless of instruction. This is why v3-v5-v6-v7 all produced different convergences but never *broke* convergence — no prompt-tone change touches the underlying distribution.

The specific *content* of a convergence changes with the prompt tone (Round 002 saw C11: "novel-verb + procedural-canvas + WebAudio, no image assets"; Round 004 sees C12: "arcade-waves-shield-or-slice + combo + boss"); the *fact* of convergence doesn't.

### 3.2 The literature has proven mitigations, but they're prompt-technique-level

**Verbalized Sampling** (Zhang et al., 2025) shows 1.6-2.1× diversity gains on creative writing by prompting the model to *verbalize a probability distribution over 5+ candidates* and sample from the low-probability tail. **DiverseGRPO** (arxiv.org/abs/2512.21514, 2026) shows the reward function itself has to be diversity-aware, otherwise even RL fine-tuning re-collapses. Selective-layer-restoration papers show mode-collapse is *localized in specific layers* and can be undone post-hoc.

**Practical implication for us:** the arena.ai UI shows the raw `BATTLE_PROMPT.md` bytes to each agent with no operator scaffolding. So we can't do Verbalized Sampling mid-session (which needs multi-turn). But we *can* embed the pattern into the prompt itself as a working method the agent follows before writing code. That's the v8 approach: encode the real design-craft that human designers use to *avoid* landing on the safe default, embedded as a §1 working method.

### 3.3 Real game-designer craft is exactly the right target

I ran a second search on how successful indie / game-jam designers actually pick concepts under time pressure. What came back matches the mode-collapse mitigation almost exactly, but from the practitioner side:

| Practitioner finding | Source | Maps to |
|---|---|---|
| **Start from the emotion, not the mechanic.** Design pillars first (3-5 feeling words). | MDA framework (Hunicke/LeBlanc/Zubek GDC 2001-2004); Ryan Kubik on Wildfire Swap's pillars; InnoGames designer interview | v8 §1.1 |
| **Find the fun before you find the polish.** Grey rectangles for the core verb, play for a minute, kill if not smiling. | Vlambeer *Art of Screenshake*; Jonasson & Purho *Juice It or Lose It*; Swink *Game Feel* (controls → space → juice ordering); every Ludum Dare veteran post-mortem | v8 §1.2 |
| **"Exactly as many systems as it needs, and they all interlock."** Small interlocking systems > sprawling feature list. | Porpentine on Naked Shades (LD MMO in Twine); Tom Quinn's "keep the scope low" LD winners page | v8 §1.3 |
| **Pick from a wide personal list, not the first idea.** Notebook of hundreds of ideas → filter by theme → pick from what's left. | Joe Williamson LD45 winner interview; Sina Yeganeh on The Imposter Kings; every jam veteran | v8 §1.4 |
| **Cut before you polish, polish before you add.** Ship a small astonishing thing, not a big half-broken one. | Consensus across every Ludum Dare veteran interview | v8 §1.5 |

**The v6 → v7 → v8 arc** looks like: v6 tried to force divergence by *banning* things (backfired into C11); v7 tried to *relax* into a calm brief (converged into C12); v8 tries to teach the *method* by which designers actually make non-default concept choices. This is the right lever even if the ceiling is still bounded by RLHF-collapse.

## 4. What v8 does differently

v8 (shipped in this commit) is a substantive revision of `challenge/BATTLE_PROMPT.md` — same 21-KB → 15-KB scale as v7, but the added content is craft, not rules.

### 4.1 New §1 "What actual game designers do (the craft you're being asked to practice)"
Five subsections that name the working method:
- **§1.1 Start from the feeling, not the mechanic** — MDA reversal, pillars-before-verb pattern
- **§1.2 Find the fun before you find the polish** — Swink/Vlambeer ordering
- **§1.3 Small interlocking systems beat sprawling features** — Porpentine principle
- **§1.4 Pick from a wide personal list, not the first idea** — the notebook-then-scary-pick ritual (optional but appreciated as `design_notebook.md`)
- **§1.5 Scope by what you can *finish*** — the LD-veteran consensus

Each subsection cites the tradition it's drawing on (MDA, Swink, Vlambeer, Ludum Dare post-mortems). Not because the agent needs the reference to comply, but because *this is what real craft looks like* — the tone shifts from "here are rules to satisfy" to "here is how competent designers actually work."

### 4.2 New §4 "Two things previous rounds have consistently failed at"
Replaces v6's exhaustive anti-pattern list with just two specific, evidence-backed failure modes: depth-after-first-minute and visual-density-that-lasts. Directly addresses what killed Round 003 and Round 004 without creating another anti-cliché cliché.

### 4.3 New README shape
`DESIGN_PILLARS` (3-5 feeling words the game was designed toward) added as required, alongside `DIRECTOR_STATEMENT` and `HONEST_SELF_ASSESSMENT`. Optional `design_notebook.md` for authorship evidence.

### 4.4 Kept from v7 (which was structurally right)
- Calm concrete tone, not adversarial
- Zero cliché list in the agent brief
- All 10 non-negotiable gates
- Concrete "what a game means" definition
- One-shot track disclosure
- "Ship a modest complete game rather than an ambitious broken one" closing line

## 5. What survives from Round 002 (evaluator/harness infra — still correct)

All judge-side infrastructure remains — the problem was the agent brief, not the tooling:

- Two-track policy §2.8, launch_challenge.py `--ship-count` + `fingerprint` + `_route_track`
- CEIL-3 (mouse) / CEIL-5 (first-level) / CEIL-6 (audio drone) / CEIL-7 (menu leak) / CEIL-8 (ambition-theater 3D)
- M4 / M6 / M8 / V9 sub-criteria
- DEPTH / AMBITION-THEATER / HONESTY / CLICHÉ-CLUSTER / ATTRIBUTION defect classes
- §4.1 arena.ai host quirks in LAUNCH_PROTOCOL.md
- §6.5 cliché-cluster registry JUDGE-SIDE ONLY (Round 003 lesson still honored — agent brief does NOT list clusters)

**New cluster C12** added to §6.5 registry: *"Arcade waves + escalating enemy types + combo/upgrades + optional boss + 2D canvas + procedural-everything"* — the mode v7 collapsed onto. Recorded so future rounds' evaluators know to look for it.

## 6. Files changed this pass

| Path | Change |
|------|--------|
| `challenge/BATTLE_PROMPT.md` | **Full revision → v8**. 14.8 KB. New §1 encodes real game-design craft as a working method (MDA, Swink, Vlambeer, Porpentine, LD veteran patterns). New required README section: DESIGN_PILLARS. Optional design_notebook.md. Kept v7's calm tone and gate list. |
| `benchmark/06-anti-bias-anti-gaming.md` | New cluster **C12** added to §6.5 registry (arcade-waves-shield-slice + combo + boss + 2D-canvas + procedural). Registry still marked JUDGE-SIDE ONLY. |
| `battles/round-004-after-action.md` | (this file) |
| `BATTLE_2_ENTRY.md` | Sanity checks updated: check for v8, size ceiling raised to <18 KB (v8 is 14.8 KB, room for one more revision), new grep for §1 craft section presence, new grep for DESIGN_PILLARS README requirement. |
| `README.md` | Battle log row for Round 004 added; v7 status marked as regressed. |

## 7. Recommended next step

Run **Round 005** as a formal round using v8. Same launch kit (`BATTLE_2_ENTRY.md`), same harness. Specific hypothesis to test:

> Under v8 (craft-based working method: pillars-first, MDA reversal, find-the-fun ordering, small interlocking systems, notebook-then-scary-pick), do agents:
> 1. **Diverge on concept** — do we see 4 different game types across 4 agents rather than 2-of-4 converging on the same thing?
> 2. **Ship the notebook** — does `design_notebook.md` appear in deliveries? What does it show about the enumeration → filtering step?
> 3. **Show pillars in the README** — do the games' actual play match the stated `DESIGN_PILLARS`? If yes, we're teaching craft. If not, agents are treating pillars as another box to tick.
> 4. **Recover any operator-satisfying game** — is there at least one entry the operator would genuinely play again?

If v8 *still* produces convergence, that is meaningful evidence:
- The mode-collapse ceiling for arena.ai's current model pool is **prompt-uncrackable** at this level of prompt engineering.
- The benchmark's honest value is in *measuring the gap* between what agents can ship and what humans expect, not in fixing agents.
- The next fix would be at platform level (Verbalized Sampling in the operator scaffold before the agent sees the prompt, or per-round themes given identically to both agents — both of which change the benchmark contract).

## 8. Honest admission

Round 003 was my correction of Round 002's over-engineering. Round 004 shows that v7 also failed — for a different reason (mode collapse) than v6 did (adversarial framing). The mistake was assuming that if v6's rules-heavy approach was wrong, v7's rules-light approach would be right. Both were wrong for the same underlying reason: neither taught the agent *how* to make a non-default creative choice. v8 tries to teach that explicitly by drawing on the published tradition. If v8 also fails, the honest finding is that the arena.ai model pool has a concept-diversity ceiling we can't move with prompt engineering alone — and *that* is a benchmark result worth having.

## 9. What did the operator actually get from Round 004?

Cluster C12 aside, one game in this round is worth naming: **AEGIS** from hunyuan-hy3-preview. The operator's verdict — *"real game with levels, still 0 graphical revolution"* — was the most positive verdict across all 24 games observed in Rounds 002-004. It ships:
- 10 hand-escalated waves + 2 boss encounters
- 5 enemy types with distinct behavior
- 8 upgrades × 3 levels each = 24 upgrade paths
- Chain multiplier + Endless mode
- The single most technically-honest self-QA note in any round ("procedural (not authored) wave composition as the weak spot")
- All the v7 gates verified in the delivery message

That is a genuine one-shot creation-benchmark data point. Not "revolutionary." Not "the winner of Battle 2." But **a real game a real human could play**. It's what v8 is trying to bias toward — while ideally *also* breaking C12 convergence so hy3's next opponent doesn't ship the same game with different chrome.

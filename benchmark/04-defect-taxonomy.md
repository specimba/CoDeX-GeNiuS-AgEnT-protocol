# 04 — Defect Taxonomy

A single, shared vocabulary for every issue found. Every defect is a **single record**,
even if it affects multiple screens or appears in multiple sessions — it is logged once
with its frequency and severity.

## 4.1 Severity

| Severity | Definition | Score channel |
|---|---|---|
| **Blocker** | Progress cannot proceed along the main path; only a full restart recovers (or not at all). Unreachable finish/victory. Controls unusable. | HARD_PENALTY + ceilings |
| **Critical** | Crash, freeze requiring reload, save/high‑score loss, major mechanic broken, an accessibility path broken. | HARD_PENALTY |
| **Major** | Secondary feature broken or unusable without a workaround; significant immersion break; performance problem that meaningfully degrades play. | category scores |
| **Minor** | Cosmetic glitch, occasional jank, minor readability issue, small UI misalignment. | category scores + DEFECT_SEVERITY (0.5) |
| **Trivial** | Nitpick, negligible impact. | DEFECT_SEVERITY (0.1) |

## 4.2 Classes

| Class | Covers |
|---|---|
| CRASH | Hard crash, tab dies, infinite error loop on load, blank screen on load. |
| FREEZE/HANG | Unresponsive loop, infinite load, animation loops forever without progress. |
| SOFT‑LOCK | Player/enemy/state cannot proceed; no recovery but reload/restart. |
| PROGRESSION | Unreachable next area/finish, exit missing, objective impossible, dead end. |
| LOGIC/STATE | Wrong state transitions, stuck states, invalid data, counters wrong, actions leak across menus. |
| PHYSICS/COLLISION | Wrong hitboxes, pass‑through, getting stuck on geometry, off‑map. |
| INPUT | Key/binding broken, buffer issues, double‑fire, touch target failures, browser default not prevented. |
| UI/USABILITY | Broken button, unreachable menu, HUD obscures, focus lost, text overflow. |
| VISUAL | Glitch, z‑order, flicker, particles burst, readability failure, clipping. |
| AUDIO | Missing/failing sound, audio‑on‑load error, no fallback, music/effects toggle broken. |
| PERFORMANCE | FPS drops, jank, memory growth, input latency, layout thrash, DPR/resolution issue. |
| BALANCE | Unfair kill, unreadable attack, difficulty cliff, trivialization, exploit, grind. |
| DATA/PERSISTENCE | High scores lost/corrupt, save/load wrong, reset not clean. |
| CONTENT‑MISSING | Placeholder screen, "under construction", empty room, promised feature absent. |
| RESPONSIVE/LAYOUT | Break on resize/orientation, controls off‑screen, safe‑area overlap. |
| ACCESSIBILITY | Reduced‑motion ineffective, color‑only info, no focus states, no keyboard nav. |
| CONTAINMENT* | Embedded score/telemetry/eval logic found inside the game. |

\* *CONTAINMENT* is special: finding benchmark score/telemetry logic inside a game is itself
a defect (severity Critical) and that game is barred from using any in‑game score channel.

## 4.3 Canonical defect record

```json
{
  "game": "A" | "B",
  "id": "D-0001",
  "title": "Concise title",
  "severity": "Blocker|Critical|Major|Minor|Trivial",
  "class": "CRASH|FREEZE/HANG|...|CONTAINMENT",
  "description": "What happened, in observable terms.",
  "reproduction": ["step 1", "step 2", "step 3"],
  "frequency": "Once|Intermittent|Frequent|Always (reproducible)",
  "reproductions_confirmed": 2,
  "context": {
    "session": "S3", "timestamp": "00:12:44", "floor": 2, "input": "keyboard",
    "reduced_motion": false, "seed": "abc123" | null
  },
  "blocks_progress": true | false,
  "recoverable": "restart|reload|self_resolved|none",
  "immersion_damage": "low|medium|high",
  "polish_only": true | false,          // true = cosmetic, false = affects playability
  "evidence": ["shot_0123.png", "note [S3][00:12:44] ..."],
  "score_channel": "HARD_PENALTY|CATEGORY|DEFECT_SEVERITY",
  "assigned_to_categories": ["M","G"],  // sub-scores the category panel already reflects this; logged once
  "resolved_as_harness": false           // set true if this was an environment issue, not the game
}
```

## 4.4 Logging rules

1. **One record per defect**, regardless of how many screens/sessions it touched. Frequency
   field captures recurrence.
2. **No double‑count.** A defect's impact flows into exactly one score channel per the
   `score_channel` field; the category panel reflects it, and it is never subtracted again
   in HARD_PENALTY unless Blocker/Critical.
3. **Severity from impact, not class.** A VISUAL defect that blocks reading an attack is
   Major, not Minor. Always justify severity with `blocks_progress`, `recoverable`, and
   `immersion_damage`.
4. **Reproduce before Blocker/Critical.** A Blocker/Critical must be reproduced ≥2× (or be
   objectively guaranteed by inspection of observed behavior) unless it is a hard crash.
5. **Harness issues** (environmental, not game) get `resolved_as_harness: true` and are
   excluded from scores.

## 4.5 Defect severity score

`DEFECT_SEVERITY_SCORE = max(0, 100 − HARD_PENALTY − (minor×0.5) − (trivial×0.1))` (per rubric §2.4).
Higher = fewer/less severe defects. Reported separately from creative quality.

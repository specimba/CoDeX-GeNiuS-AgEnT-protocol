# 04 — Defect Taxonomy: One-Shot Game Creation

Shared vocabulary for issues found in games **created** by developer agents. Every defect is single record even if appears multiple sessions. Focuses on technical reliability, code quality signals, and human-perceived quality impact — not on scoring within a pre-existing game.

## 4.1 Severity (for created games)

| Severity | Definition | Score channel |
|---|---|---|
| **Blocker** | Progress cannot proceed along main path of created game; only full restart recovers or not at all. Unreachable win/lose, controls unusable, loop cannot proceed. Reveals poor code quality / long-session failure. | HARD_PENALTY + ceilings |
| **Critical** | Crash, freeze requiring reload, save/progress loss if applicable, major mechanic broken, accessibility path broken, memory leak causing crash at 45-60min. | HARD_PENALTY |
| **Major** | Secondary feature broken or unusable without workaround; significant immersion break; performance problem meaningfully degrading play; visual ambition collapse (e.g., simple box gradient enemies after polished title) | category scores (T/M/G/F/V/A/X) |
| **Minor** | Cosmetic glitch, occasional jank, minor readability issue, small UI misalignment, particle burst, z-order flicker | category scores + DEFECT_SEVERITY 0.5 |
| **Trivial** | Nitpick, negligible impact | DEFECT_SEVERITY 0.1 |

## 4.2 Classes

| Class | Covers for created games |
|---|---|
| CRASH | Hard crash, tab dies, infinite error loop on load, blank screen on load of created game |
| FREEZE/HANG | Unresponsive loop, infinite load, animation loops forever without progress |
| SOFT-LOCK | Player/entity/state cannot proceed in created game; no recovery but reload/restart |
| PROGRESSION | Unreachable next area/finish, exit missing, objective impossible, dead end despite README claim |
| LOGIC/STATE | Wrong state transitions, stuck states, invalid data, counters wrong, actions leak across menus — code quality signal |
| PHYSICS/COLLISION | If applicable: wrong hitboxes, pass-through, stuck on geometry, off-map |
| INPUT | Key/binding broken, buffer issues, double-fire, touch target failures, browser default not prevented, scroll/zoom leak |
| UI/USABILITY | Broken button, unreachable menu, HUD obscures, focus lost, text overflow, no onboarding |
| VISUAL | Glitch, z-order, flicker, particles burst, readability failure, clipping, simple box gradient enemies as final (visual ambition failure) — explicitly low V0 |
| AUDIO | Missing/failing sound, audio-on-load error, no fallback, toggle broken, drone loop not stopping |
| PERFORMANCE | FPS drops, jank, memory growth, input latency, layout thrash, DPR/resolution issue, no pooling/capping |
| BALANCE | If applicable: unfair kill, unreadable attack, difficulty cliff, trivialization, exploit, grind, no curve |
| DATA/PERSISTENCE | If applicable: progress/high-scores lost/corrupt, save/load wrong, reset not clean; or explicit no-persistence by design not documented |
| CONTENT-MISSING | Placeholder screen, "under construction", empty room, promised feature absent despite README |
| RESPONSIVE/LAYOUT | Break on resize/orientation, controls off-screen, safe-area overlap |
| ACCESSIBILITY | Reduced-motion ineffective, color-only info, no focus states, no keyboard nav |
| CODE-QUALITY | No centralization, scattered magic numbers, no separation state/input/loop/rendering, no pooling, evidence of no iteration/refactor, console error spam — long-session execution signal |
| CONTAINMENT* | Embedded score/telemetry/eval logic found inside game |

*CONTAINMENT special: finding benchmark score/telemetry logic inside game is itself defect (Critical) and barred from using any in-game score channel.

## 4.3 Canonical defect record

```json
{
  "game": "A" | "B",
  "id": "D-0001",
  "title": "Concise title",
  "severity": "Blocker|Critical|Major|Minor|Trivial",
  "class": "CRASH|FREEZE/HANG|...|CODE-QUALITY|CONTAINMENT",
  "description": "What happened in observable terms in created game.",
  "reproduction": ["step 1", "step 2", "step 3"],
  "frequency": "Once|Intermittent|Frequent|Always",
  "reproductions_confirmed": 2,
  "context": {
    "session": "S3",
    "timestamp": "00:12:44",
    "level": 2,
    "input": "keyboard",
    "reduced_motion": false,
    "seed": "abc123" | null
  },
  "blocks_progress": true | false,
  "recoverable": "restart|reload|self_resolved|none",
  "immersion_damage": "low|medium|high",
  "polish_only": true | false,
  "evidence": ["shot_0123.png", "note [S3][00:12:44] ..."],
  "score_channel": "HARD_PENALTY|CATEGORY|DEFECT_SEVERITY",
  "assigned_to_categories": ["M","G"],
  "resolved_as_harness": false
}
```

## 4.4 Logging rules

1. One record per defect regardless of screens/sessions touched. Frequency captures recurrence.
2. No double-count: impact flows into exactly one score channel; category panel reflects it, never subtracted again in HARD_PENALTY unless Blocker/Critical.
3. Severity from impact not class. Visual defect blocking reading attack is Major not Minor. Justify severity with blocks_progress, recoverable, immersion_damage.
4. Reproduce before Blocker/Critical: must be reproduced ≥2× or objectively guaranteed by observed behavior unless hard crash.
5. Harness issues (environmental not game) get resolved_as_harness true and excluded from scores.
6. Code-quality defects: need observable signal (console error loop, memory growth at 60min, no pooling) + brief code pointer (file:line pattern) — not just claim.

## 4.5 Defect severity score

`DEFECT_SEVERITY_SCORE = max(0, 100 − HARD_PENALTY − (minor×0.5) − (trivial×0.1))` Higher = fewer/less severe defects. Reported separately from creative quality.

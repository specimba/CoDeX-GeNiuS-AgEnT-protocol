# Restored Session Notes (2026-03-17)

These notes were recovered from local Codex archived session logs because the original Codex sidebar history for the Playground workspace was no longer visible after a UI "Hand off"/close.

## What Happened (Practical Explanation)

- Your work was produced in a separate git worktree created by Codex:
  - `C:\Users\speci.000\.codex\worktrees\449e\Playground`
- The normal checkout you opened later was still clean on `master`:
  - `C:\Users\speci.000\Documents\Playground`
- The work is now committed and backed up to GitHub, and this workspace is restored on:
  - Branch: `codex/specimba/resume-20260317`

## Where The Old Thread Content Lives Locally

- Thread index:
  - `C:\Users\speci.000\.codex\session_index.jsonl`
- Archived thread logs (JSONL):
  - `C:\Users\speci.000\.codex\archived_sessions\rollout-2026-03-17T17-31-52-019cfc35-d5d1-7950-97de-a5e755530b28.jsonl` (Design)
  - `C:\Users\speci.000\.codex\archived_sessions\rollout-2026-03-17T18-01-33-019cfc51-00cf-7842-bebb-a16230dac2b3.jsonl` (Backend)
  - `C:\Users\speci.000\.codex\archived_sessions\rollout-2026-03-17T18-27-50-019cfc69-1136-7660-800d-d9ff46eeba95.jsonl` (Frontend)
  - `C:\Users\speci.000\.codex\archived_sessions\rollout-2026-03-17T18-28-43-019cfc69-dfde-7841-8ae8-2fcbc096557c.jsonl` (QA)

## Testing Checkpoint (Restored)

Automated pack smoke tests:

```powershell
.\agents\smoke-test-pack.ps1
```

Status: passed in this restored workspace on 2026-03-17.

---

## UI/UX Designer Output (Recovered)

Objective:
- Own the single-session "Music + AI storytelling" experience so a creator learner can pick an intent, shape narrative beats, pair them with music, and review playback while learning the design/coding rationale behind each choice.

Target user/scenario:
- A creator learner or storytelling coach entering the assistant to prototype one beat-by-beat story (e.g., "uplifting space exploration") with clear teachable moments, no commitment to multiple stories per session.

Flow summary:
- Intent selection -> Beat design -> Music pairing -> Playback review. Each screen surfaces "What changed," "Why it matters," and "Next step" panels alongside the main canvas so every decision doubles as learning notes. The experience remains linear with optional detours for editing or learning details but never branches into multi-story baking.

Screens / sections:
1. Intent selection hero
   - Wireframe: split-screen layout (left: intent cards + moodboard slider; right: learning notes + quick tip toggle). Primary CTA "Lock intent & generate beats."
   - Learning notes: inline copy explains how descriptive intent guides prompt templates (e.g., "specifying tempo keywords increases beat pacing predictability").
   - Error/loading: card skeletons while AI populates suggested intents; toast if model timeout ("Try a simpler phrase in 5s").
2. Beat design canvas
   - Wireframe: vertical timeline of beats with editable titles, emotion chips, and AI suggestion inline "Why the pace fits this arc." Sidebar shows live learning notes (e.g., "Short, punchy prompts help emphasize climax").
   - Input states: default collapsed beat; hover reveals "Edit description," "Regenerate ideas," "Add note."
   - Error/loading: placeholder loader in timeline slots while beats stream; inline warning if AI can't match current tempo ("Switch to 'calmer' mood to continue").
3. Music pairing stage
   - Wireframe: segmented card grid showing curated tracks with metadata (tempo, instrumentation, licensing flag) and a mini-play button. Pairing slot shows beat-to-track match map and learning note ("Why sync at 120 bpm keeps energy steady").
   - Interaction: drag track onto beat; or allow "Auto match" button.
   - States: disabled pair button until a track is selected; loading overlay when fetching preview URLs; error state with alternate suggestions if catalog API fails ("Use local placeholder sample").
4. Playback review player
   - Wireframe: top media player with waveform + synchronized story beat highlights, bottom "Prompt history" accordion showing prompts/perception adjustments and learning annotations. "What changed / why it matters / next step" callouts flank player.
   - Learning notes: highlight how prompts evolved (e.g., "Notice: adding 'gentle strings' aligned instrumental texture").
   - States: playback spinner while track buffers; offline fallback message if streaming blocked ("Download preview to continue").

Interaction states:
- Focused beat editing: elevated card, keyboard shortcut (Enter) creates note, Escape cancels.
- Hover/selection states include contextual "learning note" peek and accessible focus ring with 3px high-contrast outline.
- Loading: skeleton timeline and spinner overlays per stage, plus copy explaining progress (e.g., "Pulling beats from the story engine...").
- Errors: inline banners with guidance ("Try a simpler intent" or "Choose a different track"), accompanied by "Retry" CTA and optional "Explain why this failed" toggle that surfaces developer reasoning.
- Empty: when no beats exist yet, show a "Generate first beat" hero card with quick tip on prompt phrasing.

Content hierarchy & wireframe guidance:
- Primary action (generate intent, accept beat, pair track, start playback) must sit top-right on each screen, supported by secondary "Learn more" toggles.
- Learning notes occupy persistent right rail (desktop) or collapsible footer (mobile) so teachable insights stay visible without blocking creation.
- Each beat card follows consistent header (title/emotion), body (description + AI justification), footer (controls + learning note icon).
- Use 3-column layout for desktop (main canvas, learning rail, stepper) and stacked single column for mobile.
- Color coding ties emotions to beats (soft gradients) while ensuring contrast ratios >= 4.5:1 for text.

Accessibility considerations:
- All controls keyboard-operable; timeline uses roving tabindex with aria-live announcements ("Beat 3 now focused").
- Learning notes include aria-describedby linking to reason text; iconography supplemented with text labels.
- Contrast: ensure emotion chips and CTA hover/active states maintain AA ratios; don't rely on color alone - add text or pattern.
- Playback player supports spacebar toggle, skip buttons, and descriptive longitudinal narration ("Now playing: beat 3, uplifts the arrival").
- Error messages announced via aria-live polite regions so users relying on screen readers receive feedback immediately.

Handoff notes:
- Frontend: implement linear flow components (IntentSelector, BeatTimeline, PairingGrid, PlaybackPreview) with data stubs for AI output and learning notes; share prop contract for "learning note" content (id, text, type). Include toggles for "explain failure" and "learning note history." Provide responsive grid/rail layout and ensure skeleton/loading overlay components exist per stage.
- QA: verify single-story session (no branching) completes intent -> beats -> pairing -> playback without leaving flow; test learning notes display and toggle states, inline error recoveries, focus order (timeline -> pairing -> player), and accessible announcements for loading/errors. Document scenarios: intent generation failure, beat regeneration, music catalog timeout, playback buffering, and offline fallback.

Next steps:
- (1) Sync with backend on prompt templates/bandwidth.
- (2) Provide final wireframes for each stage.
- (3) Frontend builds stub components while QA vets error/loading paths before integrating real services.

---

## Backend Engineer Output (Recovered)

- API Contracts: model the flow (intent -> beats -> pairing -> preview) into main services so the frontend can orchestrate prompts, persist the story+music state, and resolve licensed metadata.
  1. `POST /api/sessions` (creates a session tied to the chosen intent/mood)
     Request:
     ```json
     {
       "creatorId": "user-123",
       "intent": "Uplifting space exploration",
       "focus": "coding + design tradeoffs",
       "maxModelBudgetCents": 250
     }
     ```
     Response:
     ```json
     {
       "sessionId": "sess-abcd",
       "status": "intent-picked",
       "createdAt": "2026-03-17T08:12:00Z",
       "sessionConfig": {
         "guardrails": { "maxPromptTokens": 1200, "maxResponseTokens": 1000, "modelPreference": "gpt-5o-mini" },
         "learningTone": "coach-friendly"
       }
     }
     ```
  2. `POST /api/sessions/{sessionId}/orchestrate` (runs prompt orchestration for beats + learning notes)
     Request:
     ```json
     {
       "sessionId": "...",
       "phase": "beat-plan",
       "existingBeats": [],
       "anchorTrack": { "trackId": "lic-789" },
       "tokenBudget": 1400,
       "costBudgetCents": 220,
       "seeds": { "beats": 4, "emotions": ["curiosity", "hope"] }
     }
     ```
     Response includes `storyBeats`, `learningNotes`, `promptTrace`, `tokenUsage`, and `budgetUsed` fields, plus `fallbackSource` (e.g., "static-template") when the model is unavailable.
  3. `POST /api/music/lookup` (searches the catalog or licensed track metadata)
     Request:
     ```json
     {
       "sessionId": "...",
       "query": { "mood": "uplifting", "tempoBpm": { "min": 90, "max": 130 }, "licensedOnly": true }
     }
     ```
     Response surfaces `tracks[]` with `license`, `previewUrl`, `metadata`, and `relevance`. A `trackUnavailable` boolean flags when we fall back to placeholders.
  4. `GET /api/sessions/{sessionId}` and `PATCH /api/sessions/{sessionId}` persist the session state (intent, beats, learning notes, selected track, playback pointers, status) so the frontend can resume the teaching loop; responses include the last orchestration result and a `learningHistory` array for "what changed/why it matters" cards.

- Fallback & Guardrails:
  - Every orchestration call enforces budget caps and records `tokenUsage` + `budgetUsed`.
  - Auto-switch to a lower-cost model when the higher tier exceeds its cap.
  - If the chosen LLM returns 5xx/timeout, still supply a `fallbackBeats` template plus a `promptTrace`.
  - Track lookups retry once before providing curated placeholders.
  - If nothing matches, return HTTP 422 with `reason: "no-music-match"` and a `suggestedPlaceholders` list.
  - Structured errors use `{ "code": "...", "message": "...", "details": {...} }` along with standard HTTP statuses (400, 401, 404, 429, 503).

- Summary & Assumptions:
  - Single-path intent -> beat planning -> music pairing -> preview loop.
  - Token/cost tracking is returned in-band so cost/guardrails stay visible.

- Next steps:
  1. Frontend: wire session/orchestration endpoints into the flow, render `learningNotes`/`promptTrace`, and call music lookup before playback.
  2. QA: validate LLM fallback, confirm session persistence, ensure metadata fallbacks set `trackUnavailable`, and exercise error responses (400/404/429/503).

---

## Frontend Engineer Output (Recovered)

Structure plan:
- `src/features/musicStory/session/`
  - `IntentSelector/`
    - `IntentSelector.tsx` - renders choice chips; props: `intents: IntentOption[]`, `selectedId: string`, `onSelect(id)`, `isLoading`, `error`.
    - `IntentOptionCard.tsx` - reusable variant for rich descriptions with `title`, `subtitle`, `storyPrompt`, and optional `learningNote`.
  - `BeatTimeline/`
    - `BeatTimeline.tsx` - visualizes timeline; props: `segments: BeatSegment[]`, `currentOffsetMs`, `tempo`, `onJump(segmentId)`, `isSyncing`.
    - `SegmentBadge.tsx` - small pill showing tone/mood; receives `segment`.
  - `PairingGrid/`
    - `PairingGrid.tsx` - grid of story-beat pairings; props: `pairings: PairingCardData[]`, `onSave(pairingId)`, `guardrailWarnings?: GuardrailWarning[]`, `isPairingPending`.
    - `PairingCard.tsx` - shows beat details, story twist, promptTrace snippet; supports `isDisabled`, `onEdit`.
  - `PlaybackReview/`
    - `PlaybackReview.tsx` - summarises session playback; props: `reviews: ReviewNote[]`, `learningNotes: LearningNote[]`, `onFeedback(subtype, text)`, `stageStatus: StageStatus`.
    - `LearningNotesPanel.tsx` - toggled panel showing `learningNotes`.
  - `SessionFlowContext.tsx` - keeps `stage: 'intent' | 'timeline' | 'pairing' | 'review'`, `guardrails`, `errors`, `isLoadingStages`.
  - `components/shared/`
    - `StageShell.tsx`, `SkeletonCard.tsx`, `ToastManager.tsx`, `ErrorState.tsx`.

States & UX handling (highlights):
- Intent stage: shimmer skeleton, interaction disabled while loading, toast + retry on error, prompt trace peek on hover.
- Timeline/pairing: syncing spinner badge, guardrail banners, blocking guardrail fallback UI, expandable prompt trace.
- Playback review: learning notes panel (pinning), guardrail alerts, replay CTA, persistent toast for playback failures.

Mock data and open questions were captured in the archived session log.

---

## QA Engineer Output (Recovered)

Validation scope:
- Guardrails: enforce linear step order and lock unstable states.
- Fallback behaviors: pairing failures, stalled intent recognition, connectivity drops -> verify dedicated fallback UI + accessible state.
- Learning-note visibility: ensure learning notes surface at touchpoints, act as anchor for screen readers, update after persistence.
- Persistence endpoints: valid/malformed payloads, idempotency (no dup pairings), correct HTTP statuses, playback references intent/beat IDs.
- Accessible states: consistent DOM landmarks/aria, keyboard traversal order.

Critical-path test ideas:
- Manual smoke: intent -> beat -> pairing -> playback in one session, reload and verify persistence, keyboard-only + screen-reader checks.
- Automated regression: script happy path + failure scenarios (Playwright) to assert API sequence, UI transitions, guardrails.
- API contract tests: exercise endpoints with valid/invalid payloads.
- Telemetry test: confirm fallback reasons are recorded and frontend metrics increment.
- Learning-note audit: edit learning note server-side and reload to confirm it is visible + accessible.

Blockers:
- Backend readiness: persistence endpoints must exist and be stable.
- Telemetry hooks: need instrumentation for meaningful validation.
- Accessibility landmarks: required aria landmarks must exist for real coverage.

Data & instrumentation needs:
- Event logging per state transition.
- Payload snapshots/structured logging for persistence.
- Frontend feature-flag capture + error telemetry tied to guardrail reasons.
- Accessibility audit reports (axe) per state.


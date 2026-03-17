# Music + AI Storytelling Frontend Plan

## 1. Context & designer flow
- **Mission alignment**: This experience implements the assisted storytelling loop from `plans/music-ai-storytelling-assistant.md`—support one story per session, surface teachable insights, and keep costs modest.
- **Designer’s flow (derived from intent selection → preview)**:
  1. **Intent selection**: Creator chooses narrative intent/mood, learns how prompts are penned, and receives early learning notes about tone and pacing.
  2. **Beat timeline**: AI-suggested beats appear as a sequencing canvas; the learner can reorder beats while seeing why each beat matters (learning notes + guardrail hints).
  3. **Pairing grid**: Beats are mapped to music metadata (tempo, stems, instrumentation) so the assistant can explain why a track reinforces a beat.
  4. **Playback review**: A lightweight player simulates the story + track while surfacing the prompt trace, learning recap, and any guardrail warnings before finalizing the session.
- Each screen writes back to the same session so we are always adding to one canonical story.

## 2. Folder / file plan
| Path | Responsibility |
| --- | --- |
| `frontend/src/music-ai/types.ts` | Shared DTOs (intent, beat, pairing, learning note, guardrail, prompt trace, playback status). |
| `frontend/src/music-ai/data/sampleResponses.ts` | Demo payloads for early UI work until real API is live. |
| `frontend/src/music-ai/hooks/useStorytellingSession.ts` | Orchestrates fetch, exposes status (`idle`/`loading`/`error`/`ready`), and surfaces learning notes, prompt trace, and guardrails. |
| `frontend/src/music-ai/components/IntentSelector.tsx` | Intent picker with guardrail warnings and loading/error slots. |
| `frontend/src/music-ai/components/BeatTimeline.tsx` | Timeline grid that highlights beats, learning notes, and allows reorder hooks. |
| `frontend/src/music-ai/components/PairingGrid.tsx` | Pairing matrix to show track metadata + rationale, plus quick actions. |
| `frontend/src/music-ai/components/PlaybackReview.tsx` | Playback state viewer w/ prompt trace, learning recap, and guardrail callouts. |
| `frontend/src/music-ai/components/StorytellingExperience.tsx` | Top-level orchestrator that wires the components, handles fallback UI, and renders timeline + playback tabs. |
| `frontend/docs/music-ai-storytelling-plan.md` | This document, so stakeholders can review folder structure, data hooks, and open questions before coding. |

## 3. API contract assumptions (to be confirmed with backend)
Assuming the backend exposes a REST-ish flow that can be mocked with sample data from `sampleResponses.ts`:
1. `POST /api/storytelling-sessions`
   - Request: `{ "userId": "u123", "intentId": "uplifting-space" }`
   - Response: `{ "sessionId": "sess-demo", "intent": {...}, "beats": [...], "learningNotes": [...], "promptTrace": [...], "guardrailWarnings": [...] }`
2. `PATCH /api/storytelling-sessions/{id}/beats`
   - Payload: `[ { "beatId": "b2", "rank": 2 } ]` for reordering.
   - Response: Re-muted beat array + `learningNotes` deltas.
3. `POST /api/storytelling-sessions/{id}/pairings`
   - Payload: `{ "beatId": "b3", "trackId": "track-highway" }`
   - Response: Updated `pairings` + new `learningNotes` and optional `guardrailWarnings` when a track is outside the safe list.
4. `GET /api/storytelling-sessions/{id}/playback`
   - Response: `{ "playbackState": "staged", "audioPreviewUrl": "https://cdn...", "promptTrace": [...], "learningNotes": [...], "guardrailWarnings": [...] }`
Each response should return `learningNotes`, the `promptTrace` array (step, prompt, AI summary, timestamp), and any `guardrailWarnings` (id, severity, message, linkedStep).

## 4. Sample props / responses
```ts
const intentSelectorProps = {
  options: [
    { id: 'uplifting-space', label: 'Uplifting space exploration', description: 'Gently rising tempo, bright synths.', suggestedBeatCount: 3 },
    { id: 'retro-noir', label: 'Retro noir thriller', description: 'Slow drums, smoky alto, narrative tension.' }
  ],
  selectedIntentId: 'uplifting-space',
  status: 'ready',
  guardrailWarnings: [
    { id: 'g1', severity: 'info', message: 'High-energy intent may need shorter beats.' }
  ],
  onSelect: (id) => console.log('switch intent', id)
};
```
```ts
const beatTimelineProps = {
  beats: [
    { beatId: 'b1', title: 'Spark the lift-off', learningNote: 'Use airy pads to mimic lift.', learningImpact: 'Sets optimism' },
    { beatId: 'b2', title: 'Orbit discovery', learningNote: 'Add syncopated percussion for curiosity.' }
  ],
  onDragEnd: (ordered) => console.log('new order', ordered),
  status: 'ready',
  guardrailWarnings: [ { id: 'g2', severity: 'warning', message: 'Orbit beat is longer than the target tempo window.' } ]
};
```
```ts
const pairingGridProps = {
  pairings: [
    { beatId: 'b1', trackId: 'track-moonrise', trackLabel: 'Moonrise Lightroom', tempo: 88, instrumentation: ['glass', 'strings'], rationale: 'Tempo mirrors gentle ascent.' }
  ],
  status: 'ready',
  onPair: (beatId, trackId) => console.log('paired', beatId, trackId)
};
```
```ts
const playbackReviewProps = {
  playbackState: 'staged',
  audioUrl: 'https://cdn.example.com/demo.mp3',
  promptTrace: [
    { step: 'intent', prompt: 'Describe an uplifting space mission', responseSummary: 'Bright atmosphere, optimistic viewpoint', timestamp: '2026-03-17T10:02:00Z' }
  ],
  learningNotes: [ { id: 'ln1', message: 'Bright prompts kept tempo at 90 BPM to match upbeat travel.' } ],
  guardrailWarnings: [ { id: 'g3', severity: 'error', message: 'Selected track licensing expires soon.' } ]
};
```

## 5. Data hooks & fallback states
- `useStorytellingSession(sessionId?: string)` exposes `{ status, session, learningNotes, promptTrace, guardrailWarnings, error, refresh }` so components can render consistent insights.
- Components should render fallback UI when `status` is `loading` (skeleton cards, spinner) or `error` (callout + retry button) before showing the `ready` state.
- Learning notes and guardrails are surfaced in each screen via their prop lists so the designer’s "teach why it matters" requirement stays visible.

## 6. Open questions for backend / QA
1. Backend: What is the exact schema for `learningNotes` and `guardrailWarnings` (fields, severity levels, persistence rules)?
2. Backend: Are prompt templates immutable per intent, or can we store the trace per session for auditing/enrichment?
3. Backend: Do pairings expect pre-approved tracks (IDs + metadata) or should the frontend let creators upload their own audio and rely on guardrails?
4. Backend: Should we cache `GET /playback` responses or stream them for real-time preview? Any CORS/auth requirements for the preview URL?
5. QA: How should we validate that learning notes remain synchronized with beat order changes, especially under throttled networks?
6. QA: Which browsers/devices must support the playback preview and how should we flag missing codecs or autoplay restrictions?
7. QA: What guardrail severities trigger blocking UX (error vs warning vs info) so we can plan remediation flows?

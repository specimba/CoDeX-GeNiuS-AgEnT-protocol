# Music + AI Storytelling Assistant
## Mission
- Build an interactive learning assistant that helps creators combine music cues with AI-generated narrative beats, teaching both coding and design tradeoffs through the experience itself.
## Success criteria
- The assistant guides a user through creating one short AI-driven story synced to a music track within a single session.
- Every interaction surfaces a teachable insight (e.g., why a voice prompt was written a certain way, how to pair a moodboard with tempo).
- The system stays within a low-cost model budget during prototyping, escalating only when accuracy/responsiveness cannot be achieved otherwise.
## Key personas
1. **Creator learner** – designer or developer who wants to understand how to marry sound and story.
2. **Music curator** – needs structure for sequencing tracks and narrative states.
3. **Storyteller coach** – trusts the assistant to explain design/coding choices.
## Experience pillars
- **Narrative scaffold**: User chooses a story intent (e.g., “uplifting space exploration”), then the assistant suggests narrative beats tied to emotions.
- **Music pairing**: Assistant suggests or pulls a licensed track or placeholder snippet; shows how tempo, instrumentation, and mood reinforce each beat.
- **Live learning notes**: At each step, the assistant highlights design/coding rationale in approachable language.
- **Playback preview**: Simple UI that plays the track while showing the story beats and prompt history.
## Architecture sketch
- **Backend**: orchestrate prompt templates, interact with OpenAI (or similar) for story beats, and optionally query a music catalog API for metadata or streaming URLs.
- **Frontend**: single-page flow (intent → beats → pairing → preview) with nodes for “what changed,” “why it matters,” and “next step” to reinforce learning.
- **Data**: store session progress, chosen beats, music metadata, and learning notes for later reflection or export.
## Immediate workstreams
1. **Director (this thread)**
   - Triages new requirements, keeps scope limited to one prototyped session, and ensures each specialist has a clear contract.
   - Owns risk log: licensing, latency, learning validation.
2. **UI/UX Designer**
   - Deliver flow diagram + annotated wireframes covering onboarding, intent selection, beat editing, and playback review.
   - Highlight where the learning commentary appears and how it doubles as a designer/developer coach.
3. **Backend Engineer**
   - Define API endpoints or serverless functions for prompt orchestration, session persistence, and optional music metadata.
   - Document assumptions about AI service limits, tokens, and fallback behavior.
4. **Frontend Engineer**
   - Map the UI flows to React/Vue components (or chosen stack) and stub data for Designer outputs (beats, notes, track selection).
   - Implement learning hint toggles and timeline sync for playback.
5. **QA Engineer**
   - Draft validation scenarios for narrative correctness, learning note rendering, music sync, and API error handling.
   - Decide on proof-of-concept tests (manual + automated).
## Next steps
1. Frame the scope (confirm slider: one story/mood per session).
2. Designer builds the annotated flow so frontend and backend have clear contracts.
3. Backend/Frontend ship stubs aligned with the flow; QA defines validation early.
4. Director tracks risks (licensing, AI accuracy, cost) and learning hits for you as the learner.

# Context Optimization Discipline

Date: 2026-03-18
Owner: Director (MANAGER)
Purpose: record the control structure used to reduce context burn in the multi-agent pack and preserve the method for future Director-led threads.

## Problem Statement

The pack was functionally correct but context-hungry. The issue was not one oversized prompt. The issue was repeated cold-start rehydration:

- too many docs behaved like entrypoints
- runtime prompts pointed to broad shared-doc reading by default
- managed start mixed operational metadata into the active reasoning surface
- compaction policy existed, but enforcement was weak
- review packets and handoff prompts could silently recreate large summaries

## Control Structure Used

### 1. Director-led triage

Classify the optimization task before editing:

- `Intent=review`
- `SurfaceCount=multi-module`
- `RiskClass=medium`
- `ValidationNeed=static`

Why: this prevented speculative redesign and kept the work bounded to prompt, doc, and runtime control surfaces.

### 2. Split the search by bottleneck

Use distinct review lanes:

- prompt surface and launcher behavior
- document topology and canonical entrypoints
- runtime growth, handoff size, and compaction enforcement

Why: this keeps one owner while still allowing bounded sidecar analysis.

### 3. Make runtime smaller than reference

Create a minimum required runtime layer:

- `agents/runtime-charter.md`

Then point launchers to:

1. runtime charter
2. role file
3. only the step-specific policy docs needed for the slice

Why: reference docs remain available without forcing broad reading on every thread.

### 4. Reduce duplicate authority surfaces

Keep these canonical:

- `THREAD_BOOTSTRAP.md`
- `SYSTEM_INDEX.md`
- `agents/runtime-charter.md`
- `agents/team-pipeline.md`
- `plans/autonomous-execution-program-2026-03-18.md`

Keep these derivative:

- `README.md`
- `agents/README.md`
- `NEXT_THREAD.md`
- `plans/agent-work-queue-2026-03-18.md`

Why: one canonical answer per question lowers retrieval ambiguity and context drift.

### 5. Enforce compaction earlier

Do not wait for critical context.

Compact at:

- `81%` context
- 2 handoffs on the same task
- 3 progress packets without new validation
- 2 reviewer passes
- any reasoning-waste signal

Use:

- `agents/should-compact.ps1`
- `agents/new-thread-handoff.ps1`

Why: early compaction is cheaper than late rescue.

### 6. Bound the packet surfaces

Bound review packets by size, not by intent alone.

Rules:

- compress multi-line fields
- replace long fields with file pointers or artifact references
- reject oversized packets
- prefer delta packets after the first full packet

Why: this stops “bounded review” from becoming “recreated thread history.”

## Confirmation Structure

Every optimization slice should confirm:

1. what changed
2. what validation ran
3. what stayed canonical vs derivative
4. what new helper or guardrail enforces the policy
5. what future Director threads should do first

## Situation Patterns And Responses

### Situation: too many docs feel mandatory

Response:

- define one canonical entrypoint
- define one current-state surface
- demote the rest to derivative or archival

### Situation: role prompts are small but threads still bloat

Response:

- inspect what the prompt asks the model to read next
- reduce shared-doc references
- make doc loading step-aware

### Situation: policy exists but behavior does not change

Response:

- convert the policy into a helper script
- wire the helper into the normal command path

### Situation: handoff artifacts become second copies of the thread

Response:

- bound artifact size
- prefer delta forms
- use repo file references instead of narrative re-summaries

### Situation: restart prompts reopen the entire system

Response:

- prefer task-scoped restart when a task id exists
- make the emitted restart prompt itself carry the minimum runtime rules
- use full-system restart only as fallback

## Future Director Play

When a new Director inherits a large or expensive conversation:

1. read `THREAD_BOOTSTRAP.md`
2. run `START_NEW_CHAT.ps1`
3. use the emitted prompt as the bootstrap surface
4. run `agents/should-compact.ps1`
5. keep one owner
6. use delta packets after the first full packet
7. only reopen broad system docs if the task genuinely changed class

## Validation Targets

This discipline is only credible if the repo proves it:

- smoke tests pass
- launcher output stays compact
- task-scoped handoff works
- review packet limits are enforced
- canonical docs point to the right live surfaces

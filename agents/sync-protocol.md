# Sync Protocol

This document defines how agents report status, transfer ownership, and keep work aligned without long, vague summaries.

## Protocol goals

- Keep updates short, structured, and actionable.
- Make ownership and next action obvious.
- Preserve evidence, assumptions, and risk at handoff points.
- Reduce repeated rediscovery of the same context.

## Required message types

### 1. Intake packet
Use when accepting a new task.

Fields:
- `Task`
- `Owner`
- `Objective`
- `Scope`
- `Assumptions`
- `Immediate next step`

### 2. Progress packet
Use when meaningful progress has been made.

Fields:
- `Status`
- `What changed`
- `Evidence`
- `Risks`
- `Next step`

### 3. Handoff packet
Use when ownership moves to another agent.

Fields:
- `From`
- `To`
- `Reason for transfer`
- `What is complete`
- `What is still needed`
- `Files or surfaces affected`
- `Validations already done`
- `Known risks or assumptions`

### 4. Blocker packet
Use when progress cannot continue safely inside the current lane.

Fields:
- `Blocked by`
- `Why it blocks progress`
- `What was already tried`
- `Narrowest unblock needed`
- `Recommended owner`

### 5. Completion packet
Use when a slice is done.

Fields:
- `Outcome`
- `Validation`
- `Residual risk`
- `Recommended next owner or final status`
- `Confidence`

## Sync rules

- Keep packets short. Prefer dense facts over narrative.
- Every packet must name the current owner.
- Every handoff must say what the next owner should do, not only what happened.
- State assumptions explicitly when they affect correctness.
- Distinguish verified evidence from inference.

## Evidence rules

- Use file paths, test names, flow names, error signatures, or concrete observations.
- If a command, test, or flow was not run, say so directly.
- If a conclusion is inferred rather than proven, label it as inference.

## Confidence scale

- `High`: validated directly with strong evidence
- `Medium`: strong reasoning plus partial validation
- `Low`: limited validation or unresolved ambiguity

## Recommended short formats

### Intake packet

```text
Task: Fix save flow failure on settings page
Owner: Frontend Engineer
Objective: Restore successful save behavior without UI regression
Scope: Settings form submit flow and client-side validation only
Assumptions: Backend endpoint contract is unchanged
Immediate next step: Trace submit handler and failing request path
```

### Handoff packet

```text
From: Frontend Engineer
To: Backend Engineer
Reason for transfer: API returns unexpected validation payload
What is complete: UI reproduction and request capture
What is still needed: Confirm contract and implement server-side fix if needed
Files or surfaces affected: Settings save flow, profile update endpoint
Validations already done: Browser reproduction, request payload confirmed
Known risks or assumptions: Inference that backend validation schema changed
```

### Completion packet

```text
Outcome: Profile update endpoint now accepts optional timezone field
Validation: Targeted test passed and manual request replay succeeded
Residual risk: Broader profile edit regression not fully exercised
Recommended next owner or final status: QA Engineer for focused regression pass
Confidence: High
```

## Packet discipline by role

- `Director`: optimize for ownership clarity, sequencing, and risk framing.
- `Backend Engineer`: optimize for contracts, failure modes, and validation evidence.
- `Frontend Engineer`: optimize for affected flow, UI states, and reproduction detail.
- `UI/UX Designer`: optimize for intended behavior, acceptance criteria, and edge states.
- `QA Engineer`: optimize for evidence, reproducibility, and release confidence.

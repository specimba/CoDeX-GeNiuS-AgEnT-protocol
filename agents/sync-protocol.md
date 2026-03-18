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
- `Triage`
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

### 2b. Delta progress packet
Use after the first full packet on a task when ownership did not change.

Fields:
- `Status`
- `New evidence`
- `Delta since last packet`
- `New risks`
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
- `Attempt count`

### 3b. Delta handoff packet
Use for later-stage ownership transfer when a prior full handoff already exists.

Fields:
- `From`
- `To`
- `Reason for transfer`
- `Delta since last packet`
- `New validations`
- `New risks or assumptions`
- `Immediate next step`

### 4. Blocker packet
Use when progress cannot continue safely inside the current lane.

Fields:
- `Blocked by`
- `Why it blocks progress`
- `What was already tried`
- `Narrowest unblock needed`
- `Recommended owner`
- `Escalation reason`
- `Reasoning-waste flag` when applicable
- `Reasoning-waste reason` when applicable

### 4b. Research fallback packet
Use when research output is weak, noisy, or not actionable.

Fields:
- `Research verdict`
- `Why the output was weak`
- `Brainstormed alternatives`
- `Decision`
- `Reason for decision`
- `Recommended higher owner`

### 5. Completion packet
Use when a slice is done.

Fields:
- `Outcome`
- `Deliverable label`
- `Changed files`
- `Validation`
- `Approval mode`
- `Evidence source`
- `Residual risk`
- `Known gaps`
- `Recommended next owner or final status`
- `Confidence`
- `Reasoning-waste flag` when applicable
- `Reasoning-waste reason` when applicable

## Sync rules

- Keep packets short. Prefer dense facts over narrative.
- Every packet must name the current owner.
- Every handoff must say what the next owner should do, not only what happened.
- State assumptions explicitly when they affect correctness.
- Distinguish verified evidence from inference.
- Use one full packet first, then prefer delta packets until ownership or risk changes materially.

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
Triage: Intent=edit; SurfaceCount=one-module; RiskClass=medium; ValidationNeed=user-visible
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
Deliverable label: Verified
Changed files: backend/profile.py, backend/tests/test_profile.py
Validation: Targeted test passed and manual request replay succeeded
Approval mode: Director-plus-QA
Evidence source: targeted backend test plus manual request replay
Residual risk: Broader profile edit regression not fully exercised
Known gaps: full profile edit matrix not rerun
Recommended next owner or final status: QA Engineer for focused regression pass
Confidence: High
```

### Blocker packet

```text
Blocked by: Validation evidence is too weak for the requested Verified label
Why it blocks progress: Current bundle shows repeated summaries but no new artifact or targeted validation
What was already tried: Smoke pass, manual readthrough, one escalated planning pass
Narrowest unblock needed: Produce one validation artifact bundle or downgrade the label
Recommended owner: QA Engineer
Escalation reason: Verification target is stronger than the available proof
Reasoning-waste flag: yes
Reasoning-waste reason: Two expensive passes repeated the same conclusion without adding new evidence
```

### Research fallback packet

```text
Research verdict: Weak output
Why the output was weak: Sources repeated the same claims without enough implementation detail
Brainstormed alternatives: Narrow to one repo, inspect source files directly, switch from summaries to concrete artifacts
Decision: Retry narrower
Reason for decision: There is still likely value, but only with tighter scope
Recommended higher owner: Director (MANAGER)
```

### Research fallback packet - stop case

```text
Research verdict: Weak output
Why the output was weak: The repo mainly contained duplicated wrappers and no concrete implementation evidence for the claimed feature
Brainstormed alternatives: Search for runtime tests, inspect entrypoints directly, narrow to one module, stop and defer
Decision: Stop and defer
Reason for decision: Another pass would likely repeat the same weak signals and waste tokens
Recommended higher owner: Director (MANAGER)
```

### Research fallback packet - salvage case

```text
Research verdict: Partial value
Why the output was weak: Broad repo review mixed useful parser ideas with unproven execution claims
Brainstormed alternatives: Split support-tool modules from execution modules, salvage validators only, ignore preview layer
Decision: Retry narrower
Reason for decision: The support-tool lane still has bounded reusable value
Recommended higher owner: Director (MANAGER)
```

## Packet discipline by role

- `Director (MANAGER)`: optimize for ownership clarity, sequencing, and risk framing.
- `Backend Engineer`: optimize for contracts, failure modes, and validation evidence.
- `Frontend Engineer`: optimize for affected flow, UI states, and reproduction detail.
- `UI/UX Designer`: optimize for intended behavior, acceptance criteria, and edge states.
- `QA Engineer`: optimize for evidence, reproducibility, and release confidence.

# Triage And Proof Guide

This guide keeps the five-agent system fast, cheap, and evidence-driven.

Use it to avoid wasteful loops, over-escalation, and broad execution when the task does not justify it.

## Four-field triage classifier

Every new task should be classified before execution.

Fields:

- `Intent`: `explain`, `review`, `edit`, `research`, or `deploy`
- `SurfaceCount`: `one-file`, `one-module`, `multi-module`, or `multi-repo`
- `RiskClass`: `low`, `medium`, or `high`
- `ValidationNeed`: `none`, `static`, `runtime`, or `user-visible`

Example:

```text
Intent: edit
SurfaceCount: multi-module
RiskClass: medium
ValidationNeed: runtime
```

## Routing consequences

- `one-file` + `low` + `none/static`: specialist can usually proceed directly
- `one-module` + `medium`: specialist owns the slice, but must name impacted neighbors
- `multi-module` or `user-visible`: route through `Director (MANAGER)` unless the owner is already clear
- `multi-repo` or `high`: `Director (MANAGER)` must coordinate sequencing and proof

## Worktree policy

Do not use a separate worktree by default.

Use an isolated worktree only when at least one is true:

- parallel agents need disjoint write scopes
- the edit is hazardous or hard to roll back
- branch-level proof is required before merge
- conflict risk is material

## Loop-breaker policy

Every execution slice should track:

- `AttemptCount`
- `BlockedBecause`
- `NextSmallestStep`
- `EscalationReason`

Escalate or re-scope when:

- the same slice fails twice without stronger evidence
- confidence stays `Low` after two attempts
- the owner cannot narrow the problem any further

Do not allow open-ended retries.

## Confidence labels

Every deliverable must use exactly one:

- `Concept`: idea only, not implemented
- `Prototype`: implemented or drafted, but not sufficiently verified
- `Verified`: supported by direct evidence
- `Deferred`: intentionally not pursued now

`High/Medium/Low` confidence is still useful inside packets, but the deliverable label is separate and mandatory.

## Proof packet minimum

Any execution completion should include:

- `DeliverableLabel`
- `ChangedFiles`
- `ValidationSteps`
- `ValidationResult`
- `KnownGaps`
- `Confidence`

Additional fields for risky edits:

- `BranchOrWorktree`
- `DiffSummary`
- `CleanupStatus`

## Cheap-first model rule

Default behavior:

- triage, routing, summarization, and scaffolding: cheapest competent model
- bounded implementation: cheap coding model
- escalate only for ambiguity, repeated failure, or high-risk integration

Escalation must be justified in one sentence.

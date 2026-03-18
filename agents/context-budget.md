# Context Budget Policy

Purpose: keep the thread light, move memory into files, and avoid high-context drift.

## Thresholds

- `0-60%`: normal
- `61-80%`: caution
- `81-90%`: warning
- `91-100%`: critical

## Actions By Threshold

### Caution

- keep updates short
- stop repeating old explanations
- rely on repo docs instead of thread memory

### Warning

- do not open extra sidecar agents unless they are essential
- convert long discussion into plan or policy files
- use bounded review packets only
- run `should-compact.ps1`
- prefer task-scoped restart over broad system restart

### Critical

- stop narrative exploration
- finish the current slice or hand it off cleanly
- write the current state into repo files
- prepare for compact/handoff instead of stretching the thread

## Core Rule

Use files as memory, not the chat thread.

## Operational triggers

Compact now when:

- context is `81%` or higher
- the same task already had 2 handoffs
- 3 progress packets happened without new validation
- 2 reviewer passes already happened
- reasoning-waste was flagged

Preferred memory surfaces:

- `SYSTEM_INDEX.md`
- `plans/*.md`
- `agents/*.md`
- ledger summaries

## Anti-Waste Rule

Do not paste large reports or re-summarize the whole system when a file reference is enough.

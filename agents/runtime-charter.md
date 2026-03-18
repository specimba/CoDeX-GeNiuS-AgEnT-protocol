# Runtime Charter

Purpose: provide the minimum required runtime contract for new threads and spawned roles.

Use this file first. Open deeper policy docs only when the current slice needs them.

## Runtime defaults

- keep one primary owner per slice
- keep updates short and operational
- use repo files as memory instead of repeating thread history
- prefer the cheapest competent model tier
- escalate only when the cheaper pass stops producing progress
- use QA for proof and release confidence

## Runtime workflow

1. classify the slice
2. confirm the primary owner
3. execute the narrowest useful step
4. validate with concrete evidence
5. compact or hand off before the thread becomes expensive

## Read less by default

- use one canonical entrypoint: `SYSTEM_INDEX.md`
- use one current-state surface: `plans/autonomous-execution-program-2026-03-18.md`
- treat queue or support docs as reference, not default reading
- do not reopen broad system docs unless the current slice truly needs them

## Compact earlier

Compact now when any of these are true:

- context is `81%` or higher
- the same task already had 2 handoffs
- 3 progress packets passed without new validation
- 2 reviewer passes already happened
- a reasoning-waste flag was raised

Preferred compact outputs:

- task summary from the ledger
- one bounded review packet
- one task-scoped handoff prompt

## Confirmation rule

Every slice should end with:

- what changed
- what was validated
- what remains risky or deferred
- who should act next

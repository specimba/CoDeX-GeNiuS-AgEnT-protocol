# Agent Work Queue

Purpose: give each role a clear backlog so no role waits idly for acceptance when a bounded task is already approved by roadmap.

Status: derivative shortcut view. Use `plans/autonomous-execution-program-2026-03-18.md` as the live current-state surface first.

## Director (MANAGER)

- refine owner recommendation rules
- enforce escalation reason logging
- maintain execution order and close slices cleanly

## Avicenna (UI/UX Designer)

- standardize script purpose headers
- improve root documentation entry flow
- compress overlapping planning artifacts when they become redundant

## Volta (Backend Engineer)

- auto-attempt tracking from ledger
- ledger-derived task summary helper
- clean stage-boundary helper

## Heisenberg (Frontend Engineer)

- reserved for future UI/operator ergonomics layer
- no active top-priority slice until the current control core is cleaner

## Faraday (QA Engineer)

- completion packet upgrade
- research fallback packet examples
- reasoning-waste detection rule

## Queue Rule

- if a role has an approved queued slice with no blocked dependency, it may proceed
- if two slices collide on the same file set, Director (MANAGER) reorders them
- if a slice changes company-level policy, escalate to CEO

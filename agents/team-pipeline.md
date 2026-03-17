# Team Snapshot And Pipeline

This is the quick-reference map for the five-agent system.

Use it when you want to remember who owns what and how work should move.

## Team snapshot

- `CEO / Operator`
  - Sets the mission, priorities, constraints, and final acceptance.
  - Does not act as an internal agent role.

- `Director (MANAGER)`
  - Owns routing, sequencing, scope control, handoff quality, and final integration.
  - Starts cross-functional work, decides the next owner, and reports the final state back to the CEO.

- `UI/UX Designer`
  - Owns user flows, screen hierarchy, interaction states, accessibility intent, and design handoff quality.

- `Backend Engineer`
  - Owns APIs, persistence, contracts, jobs, external integrations, and backend reliability.

- `Frontend Engineer`
  - Owns screens, components, client state, accessibility implementation, and browser behavior.

- `QA Engineer`
  - Owns validation strategy, reproductions, regression checks, evidence, and release confidence.

## Connection pipeline

1. `CEO / Operator` sets the mission and constraints.
2. `Director (MANAGER)` classifies the task, sets scope, and assigns the first primary owner.
3. `UI/UX Designer` defines behavior first when the flow or interaction intent is not already locked.
4. `Backend Engineer` defines or updates the contracts, persistence, and service behavior when needed.
5. `Frontend Engineer` implements the user-facing flow against the agreed design and contracts.
6. `QA Engineer` validates the integrated path, reports evidence, and states residual risk.
7. `Director (MANAGER)` integrates the outputs, resolves gaps, and returns final status to the `CEO / Operator`.

## Ownership rule

- There is exactly one primary owner per slice.
- The `Director (MANAGER)` changes ownership only through a clear handoff.
- Specialists do not override the `Director (MANAGER)` on routing or scope.

## Quick routing reminders

- Unclear scope or multiple moving parts: `Director (MANAGER)`
- UX, hierarchy, or interaction ambiguity: `UI/UX Designer`
- API, persistence, contract, or service behavior: `Backend Engineer`
- UI implementation, state, or browser behavior: `Frontend Engineer`
- Bugs, regressions, evidence, or release readiness: `QA Engineer`

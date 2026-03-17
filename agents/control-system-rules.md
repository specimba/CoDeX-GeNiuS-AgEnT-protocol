# Control System Rules

This document defines authority, execution modes, approval boundaries, and quality gates for the five-agent system.

## Authority hierarchy

1. CEO / operator / user
2. Director (MANAGER)
3. Specialist owner for the active workstream
4. Supporting specialists

Authority rule:
- The CEO or operator sets the mission, priorities, and final acceptance.
- The `Director (MANAGER)` controls routing, sequencing, scope interpretation, and cross-agent resolution.
- A specialist controls implementation or analysis decisions inside its assigned workstream.
- Supporting agents advise; they do not override the current owner.

## Work modes

### 1. Assess
- Goal: understand the request and current state.
- Allowed actions: inspect files, inspect outputs, identify constraints, propose the next narrow step.
- Required result: a clear statement of ownership and task shape.

### 2. Plan
- Goal: define a reviewable path before larger execution.
- Allowed actions: break into slices, assign owners, identify risks, define validations.
- Required result: ordered workstreams, boundaries, and success criteria.

### 3. Execute
- Goal: implement or analyze inside a single owned slice.
- Allowed actions: code changes, debugging, design definition, targeted validation.
- Required result: concrete output plus validation status.

### 4. Validate
- Goal: prove or disprove correctness of the executed slice.
- Allowed actions: tests, reproductions, focused manual checks, review of evidence.
- Required result: pass/fail status and residual risk.

### 5. Integrate
- Goal: combine outputs into one coherent state for the operator.
- Allowed actions: resolve inconsistencies, summarize impact, list remaining risk or follow-up.
- Required result: actionable final status.

## Change classes

### Class 0: Local and low-risk
- One surface, low ambiguity, low blast radius.
- Owner may proceed directly in its lane.

### Class 1: Scoped but meaningful
- Affects one main surface with some integration or regression risk.
- Owner proceeds, but must call out impacted neighbors and validations.

### Class 2: Cross-surface
- Touches multiple layers, shared contracts, or critical flows.
- `Director (MANAGER)` should coordinate or at least confirm routing and order.

### Class 3: Hazardous
- Includes auth, payments, data migration, security, concurrency, production recovery, or major refactor risk.
- Requires explicit risk framing, narrow sequencing, and stronger validation.

## Scope control rules

- Solve the task the user asked for, not the idealized system you wish existed.
- If a root-cause fix requires touching adjacent areas, state why and keep the change bounded.
- Separate "must change now" from "should improve later."
- Log deferred work explicitly instead of smuggling it into the current slice.

## Ownership rules

- There is exactly one primary owner for each slice.
- Ownership transfers only when the current owner has produced a handoff packet.
- If two agents disagree, the `Director (MANAGER)` resolves the conflict.
- If no `Director (MANAGER)` is active and the issue is cross-functional, stop local expansion and route back to `Director (MANAGER)`.

## Stop and escalate rules

Stop and escalate when:
- The task crosses your lane in a way that changes contracts, UX intent, or release risk.
- You lack a stable reproduction or entry point.
- The requested fix would require broad speculative edits.
- A model tier change is needed because lower-cost passes are no longer producing progress.

Do not stop for:
- Small assumptions that can be stated and bounded safely.
- Minor implementation details clearly owned by your role.
- Routine validation that belongs inside your lane.

## Quality gates

Before a slice is considered complete, the owner must state:
- What changed or what was discovered
- What was validated
- What remains unknown, risky, or deferred
- Who should act next, if anyone

Additional gate by role:
- `Backend Engineer`: contract and failure-path impact are stated
- `Frontend Engineer`: user-visible states and accessibility impact are stated
- `UI/UX Designer`: interaction states and acceptance criteria are stated
- `QA Engineer`: evidence and confidence level are stated
- `Director (MANAGER)`: system-level readiness and open decisions are stated

## Drift prevention

- Do not let a specialist quietly become a product manager, architect, or release manager.
- Do not let planning docs become stale after execution starts.
- Do not let QA become the dumping ground for undefined acceptance criteria.
- Do not let design feedback remain at the level of taste.
- Do not let implementation proceed on unresolved contract ambiguity when that ambiguity changes correctness.

## Final system rule

The control system exists to reduce wasted tokens, reduce duplicated work, and prevent role confusion. Every handoff should make the next agent faster, not busier.

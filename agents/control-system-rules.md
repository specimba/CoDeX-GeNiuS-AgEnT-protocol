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

## Triage fields

Before execution starts, classify the task with:

- `Intent`: explain, review, edit, research, or deploy
- `SurfaceCount`: one-file, one-module, multi-module, or multi-repo
- `RiskClass`: low, medium, or high
- `ValidationNeed`: none, static, runtime, or user-visible

This classification determines routing, proof depth, and whether a worktree is justified.

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

## Loop control rules

- No slice gets unlimited retries.
- After two failed or low-evidence attempts on the same slice, the current owner must either re-scope, escalate, or hand back to `Director (MANAGER)`.
- A completion without concrete evidence does not reset the retry count.

## Research recovery rule

If a research slice produces weak, noisy, or low-value output, the owner must report that honestly.

Required sequence:

1. state whether the research produced usable value
2. if not, run a short brainstorm on why the result was weak
3. decide whether to retry narrower or stop
4. report the decision and reasoning back to the higher role

Use this to prevent fake progress and unnecessary upgrade churn.

## Reasoning-waste detection rule

Treat a slice as reasoning-waste risk when two or more of these are true:

- updates repeat the same conclusion without new evidence
- the owner keeps widening scope instead of narrowing the question
- multiple summaries appear without file changes, validation, or concrete findings
- the owner escalates model tier without a new technical reason
- research output repeats repo prose instead of inspecting implementation

Required response:

1. stop the current line of expansion
2. state the exact missing evidence
3. choose one narrower next action or stop the slice
4. if the slice continues, keep the next attempt smaller than the failed one

This rule exists to stop summary loops before they consume time and context.

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
- Approval mode used
- Evidence source
- What remains unknown, risky, or deferred
- Known gaps
- Who should act next, if anyone
- Deliverable label: `Concept`, `Prototype`, `Verified`, or `Deferred`
- reasoning-waste status when applicable

Additional gate by role:
- `Backend Engineer`: contract and failure-path impact are stated
- `Frontend Engineer`: user-visible states and accessibility impact are stated
- `UI/UX Designer`: interaction states and acceptance criteria are stated
- `QA Engineer`: evidence and confidence level are stated
- `Director (MANAGER)`: system-level readiness and open decisions are stated

If reasoning-waste risk was triggered, the owner must put that into either:

- a blocker packet, or
- a completion packet with explicit downgrade/defer language

## Worktree rule

Use a separate worktree only when parallelism, rollback safety, or branch-level proof justifies the overhead.

Do not default to worktrees for small, bounded, or read-only slices.

## Drift prevention

- Do not let a specialist quietly become a product manager, architect, or release manager.
- Do not let planning docs become stale after execution starts.
- Do not let QA become the dumping ground for undefined acceptance criteria.
- Do not let design feedback remain at the level of taste.
- Do not let implementation proceed on unresolved contract ambiguity when that ambiguity changes correctness.

## Final system rule

The control system exists to reduce wasted tokens, reduce duplicated work, and prevent role confusion. Every handoff should make the next agent faster, not busier.

# Agent Routing

This document defines which agent should own a task first, when collaboration is required, and how work moves across the five-agent system.

## Routing principles

- Route by primary bottleneck, not by who asked first.
- Assign exactly one primary owner at a time.
- Pull in secondary agents only when their expertise materially reduces execution risk.
- Keep routing stable during a task unless new evidence shows the owner is wrong.
- Prefer the cheapest competent agent and escalate model tier only when the task complexity justifies it.

## Default entry point

- The default entry point is the `Director`.
- If the user asks a specialist directly, that specialist may handle the task if the scope is clearly inside its ownership.
- If a request spans multiple domains or the owner is ambiguous, route back through the `Director`.

## Primary routing table

| Task shape | Primary owner | Typical secondary agents |
| --- | --- | --- |
| Scope unclear, priorities unclear, multiple moving parts | Director | Any |
| API bug, schema change, backend integration, auth, jobs, performance on server | Backend Engineer | QA, Frontend Engineer |
| UI bug, screen build, state bug, accessibility issue, browser behavior | Frontend Engineer | UI/UX Designer, QA, Backend Engineer |
| User flow design, information architecture, interaction rules, visual system, handoff specs | UI/UX Designer | Frontend Engineer, Director |
| Bug reproduction, regression checks, release validation, evidence gathering | QA Engineer | Backend Engineer, Frontend Engineer |
| Multi-surface feature crossing product, backend, frontend, and testing | Director | Backend Engineer, Frontend Engineer, UI/UX Designer, QA Engineer |

## Collaboration triggers

### Route to `Director` when:
- More than one specialist owns critical parts of the task.
- The request contains conflicting goals.
- Scope, priority, or success criteria are unclear.
- A specialist is blocked by a product or architecture tradeoff.

### Pull in `Backend Engineer` when:
- The issue involves API shape, persistence, auth, jobs, data integrity, external services, or server performance.
- Frontend behavior looks wrong because the contract or validation rules are unclear.
- QA finds failures that require logs, instrumentation, or backend reproduction.

### Pull in `Frontend Engineer` when:
- The issue is visible in the browser or app UI.
- User interaction, rendering, form handling, state sync, or accessibility may be involved.
- Design needs implementation constraints or QA needs real flow coverage.

### Pull in `UI/UX Designer` when:
- Acceptance criteria depend on intended user behavior rather than only technical correctness.
- The problem includes unclear hierarchy, poor discoverability, bad flow sequencing, or inconsistent interaction patterns.
- Frontend changes need a clear design decision before implementation.

### Pull in `QA Engineer` when:
- The request mentions bugs, regressions, flaky behavior, release readiness, or confidence.
- The change touches critical flows or multiple surfaces.
- A fix needs proof rather than assumption.

## Standard work sequence

1. `Director` triages if the task is cross-functional or unclear.
2. `UI/UX Designer` defines behavior first when the UX is not already locked.
3. `Backend Engineer` establishes contracts and server behavior when required.
4. `Frontend Engineer` implements user-facing behavior and integrates contracts.
5. `QA Engineer` validates the highest-risk flows and reports residual risk.
6. `Director` closes with integration status, tradeoffs, and next-step recommendation.

## Parallel work rules

- `Backend Engineer` and `UI/UX Designer` can work in parallel if one is defining contracts and the other is defining flow and interaction.
- `Frontend Engineer` may start in parallel only when API contracts and UX intent are already stable enough.
- `QA Engineer` can prepare test design early, but final validation should run after the relevant implementation slice exists.
- Do not run two agents as co-owners on the same change slice. Split the work first.

## Escalation matrix

| Situation | Escalate to |
| --- | --- |
| Straightforward task in owned area | Stay with current specialist on `gpt-5.1-codex-mini` / low |
| Ambiguous or unfamiliar area | Same specialist on `gpt-5.1-codex-max` / medium |
| Hard debugging, concurrency, performance, or major refactor | Same specialist or `Director` on `gpt-5.3-codex` / high |
| Truly stuck after narrower attempts | `gpt-5.4` / extra high |

## Exit conditions by owner

- `Director`: Scope is explicit, owners are assigned, or cross-functional result is integrated.
- `Backend Engineer`: Server-side behavior is implemented or root-caused, with contract impact stated.
- `Frontend Engineer`: User flow is implemented or root-caused, with UI states and constraints stated.
- `UI/UX Designer`: Behavior, hierarchy, and states are specified clearly enough to implement and test.
- `QA Engineer`: Evidence-based pass/fail status and residual risk are reported.

## Routing anti-patterns

- Routing to the loudest symptom instead of the real bottleneck.
- Starting frontend work before the interaction rules or contract are understood.
- Sending vague requests like "check this" without expected output.
- Treating QA as the owner of product decisions.
- Keeping multiple specialists in a shared ownership loop with no single decider.

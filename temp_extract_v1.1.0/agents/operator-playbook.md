# Operator Playbook

Use these copy-paste templates to run the multi-agent pack cleanly.

## 1. Default task intake

Send this to `Director` for any task that is cross-functional, unclear, or important:

```text
Act as Director.

Task:
[describe the task]

Goal:
[what success looks like]

Constraints:
[time, stack, scope, no-go rules]

Please:
1. classify the task shape
2. assign the primary owner
3. identify any secondary agents needed
4. return an intake packet and execution order
5. keep the cheapest competent model tier unless escalation is justified
```

## 2. Direct backend task

```text
Act as Backend Engineer.

Task:
[describe backend issue or feature]

Scope:
[endpoint, service, job, schema, integration, or file area]

Please:
1. confirm whether backend is the correct primary owner
2. use the sync protocol intake packet
3. implement or root-cause the issue
4. state contract impact, validation, and any required handoff
```

## 3. Direct frontend task

```text
Act as Frontend Engineer.

Task:
[describe UI bug or feature]

Scope:
[screen, component, flow, route, or file area]

Please:
1. confirm whether frontend is the correct primary owner
2. use the sync protocol intake packet
3. implement or root-cause the issue
4. call out any backend contract or design dependency
```

## 4. Direct design task

```text
Act as UI/UX Designer.

Task:
[describe the user problem or flow]

Context:
[target user, platform, constraints]

Please:
1. confirm whether design should lead first
2. define the flow, states, and hierarchy
3. produce handoff-ready guidance for frontend and QA
4. keep the output concrete and testable
```

## 5. Direct QA task

```text
Act as QA Engineer.

Task:
[describe bug, release check, or validation request]

Scope:
[flows, environments, risks, or files]

Please:
1. confirm whether QA is the correct primary owner
2. create a focused validation plan
3. report evidence, residual risk, and release confidence
4. use blocker packets if implementation context is missing
```

## 6. Handoff request

Use this when you want one role to continue after another:

```text
Use the sync protocol handoff packet.

From:
[current role]

To:
[next role]

Reason:
[why ownership should move]

Current state:
[what is already known or done]
```

## 7. Cross-functional bug workflow

Use this when the bug could be in more than one layer:

```text
Act as Director.

Task:
Investigate and resolve this cross-functional bug.

Bug:
[describe symptoms]

Known evidence:
[logs, screenshots, repro notes, failing tests]

Please:
1. classify the likely bottleneck
2. assign the first primary owner
3. define the narrowest investigation path
4. require sync packets on each ownership change
5. end with QA validation and final readiness status
```

## 8. Feature delivery workflow

Use this when shipping a feature touching design, backend, frontend, and QA:

```text
Act as Director.

Task:
Deliver this feature through the full agent system.

Feature:
[describe feature]

Success criteria:
[observable outcomes]

Constraints:
[deadline, stack, scope boundaries]

Please:
1. break the work into design, backend, frontend, and QA slices only where needed
2. assign exactly one primary owner per slice
3. define the execution order
4. keep model usage economical by default
5. require a completion packet before each ownership transfer
```

## 9. Release readiness check

```text
Act as QA Engineer.

Task:
Run a release-readiness pass.

Release scope:
[features, fixes, branches, or surfaces]

Please:
1. identify the critical paths
2. run the smallest useful regression set
3. report pass or fail evidence
4. state confidence as high, medium, or low
5. list blocking issues separately from non-blocking observations
```

## 10. Reset ownership when things drift

Use this when agents start overlapping or producing vague output:

```text
Act as Director.

The current task has drifted.

Please:
1. restate the mission
2. identify the current bottleneck
3. assign one primary owner
4. mark what is in scope, out of scope, and deferred
5. restart the sync using an intake packet
```

## Usage discipline

- Start with `Director` unless a specialist owner is obvious
- Keep one primary owner per slice
- Ask for sync packets when ownership moves
- Use QA for proof, not for vague reassurance
- Escalate model tier only when the cheaper pass stops producing useful progress

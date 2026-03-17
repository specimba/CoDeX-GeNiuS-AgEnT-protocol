# Workflow Smoke Checklist

Use these two drills to confirm the five-agent pack behaves consistently before using it on real work.

`director` and `manager` both target the same `Director (MANAGER)` role. Use `manager` if that naming is easier for your workflow.

## Drill 1: Feature delivery

Goal: confirm the normal pipeline works from intake to validation.

1. `.\agents\use-agent.ps1 manager -Task "Triage a feature that needs design, backend, frontend, and QA."`
2. `.\agents\use-agent.ps1 designer -Task "Define the user flow and interaction states for that feature."`
3. `.\agents\use-agent.ps1 backend -Task "Define the backend contracts and failure paths for that feature."`
4. `.\agents\use-agent.ps1 frontend -Task "Implement the user-facing flow against the approved design and contracts."`
5. `.\agents\use-agent.ps1 qa -Task "Validate the critical path and report release confidence."`

Expected outcome:
- `Director (MANAGER)` is the first owner.
- Ownership moves in the standard order when needed.
- Each prompt points to the correct role file and shared docs.

## Drill 2: Cross-functional bug

Goal: confirm the routing and handoff logic works when the first owner is not obvious.

1. `.\agents\use-agent.ps1 director -Task "Classify a playback bug that could be frontend, backend, or UX."`
2. `.\agents\use-agent.ps1 frontend -Task "Reproduce the bug in the UI and isolate the user-visible state changes."`
3. `.\agents\use-agent.ps1 backend -Task "Check whether the API contract or persistence caused the failure."`
4. `.\agents\use-agent.ps1 qa -Task "Run a focused regression pass on the repaired playback flow."`
5. `.\agents\use-agent.ps1 manager -Task "Integrate the findings, confirm readiness, and report the next step."`

Expected outcome:
- `Director (MANAGER)` decides the first owner.
- Specialists route back through `Director (MANAGER)` if the bottleneck changes.
- QA closes with evidence instead of vague reassurance.

## Two-pass role coverage

Each agent is exercised twice across the two drills:

- `Director (MANAGER)`: feature intake, bug triage and closure
- `UI/UX Designer`: feature flow definition, interaction-state clarification
- `Backend Engineer`: contract definition, bug isolation
- `Frontend Engineer`: implementation path, bug reproduction
- `QA Engineer`: feature validation, regression validation

## Fast automated check

Run the prompt-pack smoke tests:

```powershell
.\agents\smoke-test-pack.ps1
```

Add `-ShowPrompts` if you want the generated prompts printed as part of the check.
Add `-StopOnFailure` if you want the suite to abort on the first broken case.

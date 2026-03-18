# Multi-Agent Pack

This folder contains the runtime and policy surfaces for the five-agent pack.

Canonical runtime order:

1. `runtime-charter.md`
2. the role file
3. only the step-specific policy docs named by the launcher

## Pack contents

- Runtime:
  - `runtime-charter.md`
  - `director.agent.md`
  - `backend-engineer.agent.md`
  - `frontend-engineer.agent.md`
  - `qa-engineer.agent.md`
  - `ui-ux-designer.agent.md`

- Routing and proof:
  - `agent-routing.md`
  - `triage-and-proof.md`
  - `sync-protocol.md`
  - `artifact-first-validation.md`

- Task control:
  - `use-agent.ps1`
  - `start-managed-task.ps1`
  - `close-managed-task.ps1`
  - `triage-task.ps1`
  - `should-compact.ps1`
  - `task-ledger.ps1`
  - `new-thread-handoff.ps1`

- Review helpers:
  - `prepare-review-packet.ps1`
  - `prepare-completion-packet.ps1`
  - `prepare-blocker-packet.ps1`
  - `prepare-validation-artifact.ps1`

- Operating policy:
  - `control-system-rules.md`
  - `context-budget.md`
  - `spawn-control.md`
  - `role-model-policy.md`
  - `permission-and-autonomy.md`

- Operator docs:
  - `activation-guide.md`
  - `operator-playbook.md`
  - `team-pipeline.md`
  - `background-agents-ui.md`

- Validation and release:
  - `workflow-smoke-checklist.md`
  - `smoke-test-pack.ps1`
  - `package-pack.ps1`
  - `release-packaging.md`

Use [`SYSTEM_INDEX.md`](..\SYSTEM_INDEX.md) for system entry, [`team-pipeline.md`](team-pipeline.md) for role order, and [`activation-guide.md`](activation-guide.md) for commands.

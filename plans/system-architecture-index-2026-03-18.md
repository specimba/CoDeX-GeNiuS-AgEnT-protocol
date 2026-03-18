# System Architecture Index

Date: 2026-03-18
Purpose: provide one company-style map of what exists, why it exists, and how each part connects to the higher control system.

## System Purpose

This repository is not a loose collection of prompts.

It is a company operating system for:

- task classification
- role-based execution
- bounded autonomy
- proof-driven review
- low-energy collaboration

The control chain is:

`CEO -> Director (MANAGER) -> primary owner -> QA when needed -> Director (MANAGER) -> CEO`

## Layer Map

### 1. Identity Layer

Purpose:

- define the five-agent team
- keep naming, ownership, and role boundaries stable

Files:

- `agents/director.agent.md`
- `agents/backend-engineer.agent.md`
- `agents/frontend-engineer.agent.md`
- `agents/ui-ux-designer.agent.md`
- `agents/qa-engineer.agent.md`
- `agents/team-pipeline.md`

Higher connection:

- this layer defines who acts inside the company system

### 2. Control Layer

Purpose:

- define routing, scope, escalation, retry, and autonomy rules

Files:

- `agents/agent-routing.md`
- `agents/control-system-rules.md`
- `agents/triage-and-proof.md`
- `agents/permission-and-autonomy.md`
- `agents/role-model-policy.md`
- `agents/spawn-control.md`
- `agents/context-budget.md`

Higher connection:

- this layer decides how authority moves and when the CEO must be involved

### 3. Sync Layer

Purpose:

- make handoffs, blockers, and completions structured and auditable

Files:

- `agents/sync-protocol.md`
- `agents/bounded-review.md`
- `agents/prepare-review-packet.ps1`
- `agents/prepare-completion-packet.ps1`
- `agents/prepare-blocker-packet.ps1`
- `agents/artifact-first-validation.md`
- `agents/prepare-validation-artifact.ps1`

Higher connection:

- this layer turns informal work into reviewable company records

### 4. Execution Helper Layer

Purpose:

- reduce operational friction with low-token command wrappers

Files:

- `agents/use-agent.ps1`
- `agents/triage-task.ps1`
- `agents/start-managed-task.ps1`
- `agents/close-managed-task.ps1`
- `agents/new-thread-handoff.ps1`
- `START_NEW_CHAT.ps1`
- `agents/load-determinism-profile.ps1`

Higher connection:

- this layer converts policy into repeatable execution

### 5. Memory And Audit Layer

Purpose:

- track task state, attempts, and closure with low overhead

Files:

- `agents/task-ledger.ps1`
- `agents/task-ledger.md`

Higher connection:

- this layer gives the Director and CEO traceability without heavy orchestration

### 6. Validation And Release Layer

Purpose:

- prove the pack works
- package it cleanly when needed

Files:

- `golden/README.md`
- `golden/golden-run-seed.json`
- `profiles/README.md`
- `profiles/strict.json`
- `profiles/ci.json`
- `profiles/explore.json`
- `agents/smoke-test-pack.ps1`
- `agents/workflow-smoke-checklist.md`
- `agents/package-pack.ps1`
- `agents/release-packaging.md`

Higher connection:

- this layer prevents fake readiness and supports controlled releases

### 7. Operator Layer

Purpose:

- make the system usable without relearning it each time

Files:

- `agents/README.md`
- `agents/activation-guide.md`
- `agents/operator-playbook.md`
- `agents/background-agents-ui.md`
- `SYSTEM_INDEX.md`
- `NEXT_THREAD.md`

Higher connection:

- this layer keeps the company system usable in daily work

### 8. Strategy Layer

Purpose:

- store roadmap, review, and integration direction

Files:

- `plans/integration-discipline-2026-03-18.md`
- `plans/agent-system-micro-roadmaps-2026-03-18.md`
- `plans/agent-system-adopted-patterns-2026-03-18.md`
- `plans/aoa-v2-review-and-roadmap-2026-03-18.md`
- `plans/quarterly-milestones-2026-q2-q3.md`
- `plans/autonomous-execution-program-2026-03-18.md`
- `plans/agent-work-queue-2026-03-18.md`
- `plans/codex-skills-and-automations-review-2026-03-18.md`
- `plans/roadmap-upgrades-adopt-sandbox-reject-2026-03-18.md`

Higher connection:

- this layer explains why the system is shaped this way and what should happen next

## Naming Rule

System files must follow one of these patterns:

- role file
- policy file
- protocol file
- helper script
- packaging script
- roadmap or review plan

If a file does not clearly fit one of those categories, it should be questioned before adoption.

## Source Of Truth Rule

Track as source:

- `agents/`
- `plans/`
- top-level policy files

Do not treat as source by default:

- `dist/`
- `runs/`
- `temp_extract_*`
- cache files

## Review Rule

Every new addition should be easy to answer with:

- what is it
- why does it exist
- where does it connect
- who owns it
- how is it validated

If those answers are weak, the addition is probably premature.

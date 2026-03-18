# System Index

Purpose: provide one top-level company entry document for the Manager-led agent system.

Use this file when the question is:

- what is this system
- where should I start
- which document or script owns a given concern

Startup note:
- use `THREAD_BOOTSTRAP.md` and the emitted `START_NEW_CHAT.ps1` handoff first for ongoing task continuation
- use this file when routing is ambiguous or a broader system map is required

## System Identity

This repository operates as a company control system for low-energy, high-discipline agent work.

Primary control chain:

`CEO -> Director (MANAGER) -> primary owner -> QA when needed -> Director (MANAGER) -> CEO`

## Team Snapshot

- `Director (MANAGER)` - routing, scope, proof gates, final integration
- `Avicenna (UI/UX Designer)` - flow quality, interaction clarity, design handoff
- `Volta (Backend Engineer)` - backend structure, safety, persistence, integration logic
- `Heisenberg (Frontend Engineer)` - user-facing flow, state behavior, visible ergonomics
- `Faraday (QA Engineer)` - proof, regression confidence, failure clarity

## Start Here

### Operator entry

- `THREAD_BOOTSTRAP.md`
- `agents/runtime-charter.md`
- `agents/startup-prompts.md`
- `agents/README.md`
- `agents/activation-guide.md`
- `agents/operator-playbook.md`
- `NEXT_THREAD.md`
- `START_NEW_CHAT.ps1`

### Architecture and purpose

- `plans/system-architecture-index-2026-03-18.md`
- `plans/integration-discipline-2026-03-18.md`

### Roadmap and milestones

- `plans/agent-system-micro-roadmaps-2026-03-18.md`
- `plans/quarterly-milestones-2026-q2-q3.md`
- `plans/autonomous-execution-program-2026-03-18.md`

Current-state note:
- `plans/autonomous-execution-program-2026-03-18.md` is the live current-state surface
- `plans/agent-work-queue-2026-03-18.md` is a shortcut backlog view, not the default entry

## Policy Layer

Use these to understand authority, routing, proof, and escalation.

- `agents/agent-routing.md`
- `agents/control-system-rules.md`
- `agents/triage-and-proof.md`
- `agents/permission-and-autonomy.md`
- `agents/role-model-policy.md`
- `agents/spawn-control.md`
- `agents/context-budget.md`

## Protocol Layer

Use these for handoffs, review packets, and structured communication.

- `agents/sync-protocol.md`
- `agents/bounded-review.md`
- `agents/artifact-first-validation.md`

## Execution Helpers

Use these to operate the system quickly without repeating instructions.

- `agents/use-agent.ps1`
- `agents/triage-task.ps1`
- `agents/start-managed-task.ps1`
- `agents/close-managed-task.ps1`
- `agents/prepare-review-packet.ps1`
- `agents/prepare-completion-packet.ps1`
- `agents/prepare-blocker-packet.ps1`
- `agents/prepare-validation-artifact.ps1`
- `agents/load-determinism-profile.ps1`
- `agents/new-thread-handoff.ps1`
- `agents/should-compact.ps1`

## Memory And Audit

Use these to track task history and attempts.

- `agents/task-ledger.ps1`
- `agents/task-ledger.md`

## Validation And Release

Use these to prove the system works and package it cleanly.

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

## Strategy And Review

Use these to understand why the system evolved this way.

- `plans/agent-system-adopted-patterns-2026-03-18.md`
- `plans/aoa-v2-review-and-roadmap-2026-03-18.md`
- `plans/context-optimization-discipline-2026-03-18.md`

## Source Boundary

Source of truth:

- `agents/`
- `plans/`
- root policy documents

Generated or runtime-only by default:

- `dist/`
- `runs/`
- `temp_extract_*`
- cache files

## Working Rule

Every meaningful system addition should answer:

- what it is
- why it exists
- where it connects
- who owns it
- how it is validated

If those answers are weak, the addition is not ready.

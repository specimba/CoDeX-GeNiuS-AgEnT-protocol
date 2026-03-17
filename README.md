# Multi-Agent Pack

A practical multi-agent operating system for Codex-style work across planning, backend, frontend, design, and QA.

This repository is designed for people who want:
- clear role boundaries
- low-cost default model usage
- predictable handoffs
- less duplicated investigation
- a reusable operating pattern for real software work

## What is inside

- `agents/`
  - five role prompts
  - background-agent UI note
  - workflow smoke checklist
  - prompt smoke-test script
  - routing rules
  - control system rules
  - sync protocol
  - operator playbook
  - activation guide
  - PowerShell launcher
- `WORKSTYLE.md`
  - preferred working style and escalation policy for this workspace
- `dist/`
  - packaged zip releases and release metadata

## Roles

- `Director (MANAGER)`
  - routing, coordination, sequencing, scope control, final integration
- `Backend Engineer`
  - APIs, services, persistence, contracts, integrations, jobs, backend debugging
- `Frontend Engineer`
  - screens, components, client state, UI behavior, accessibility, browser-side debugging
- `UI/UX Designer`
  - flows, hierarchy, interaction rules, handoff-ready design guidance
- `QA Engineer`
  - test strategy, bug reproduction, regression validation, release confidence

## Start here

1. Read [`agents/README.md`](agents/README.md)
2. Read [`agents/activation-guide.md`](agents/activation-guide.md)
3. Use [`agents/operator-playbook.md`](agents/operator-playbook.md) for ready prompts
4. Use [`agents/use-agent.ps1`](agents/use-agent.ps1) for fast local prompt generation
5. Use [`agents/team-pipeline.md`](agents/team-pipeline.md) for the role map and connection pipeline
6. Use [`agents/background-agents-ui.md`](agents/background-agents-ui.md) to understand app-side visibility limits
7. Use [`agents/workflow-smoke-checklist.md`](agents/workflow-smoke-checklist.md) and [`agents/smoke-test-pack.ps1`](agents/smoke-test-pack.ps1) to verify the pack before real work

## Quick use

PowerShell:

```powershell
.\agents\use-agent.ps1 director
```

Copy a ready prompt:

```powershell
.\agents\use-agent.ps1 frontend -Task "Fix the broken settings form submit flow" -Clipboard
```

Run the whole system through the `Director (MANAGER)`:

```powershell
.\agents\use-agent.ps1 system -Task "Investigate and deliver the new billing settings feature"
```

## Operating principles

- one primary owner per slice
- route by bottleneck, not by visible symptom
- keep model usage cheap first
- escalate only when cheaper passes stop making progress
- use QA for proof, not vague reassurance
- keep changes surgical and bounded

## Recommended model policy

- default: `gpt-5.1-codex-mini` with low reasoning
- escalate to `gpt-5.1-codex-max` with medium reasoning for ambiguous work, tricky tests, or unfamiliar systems
- escalate to `gpt-5.3-codex` with high reasoning for hard debugging, performance, concurrency, or gnarly refactors
- use `gpt-5.4` with extra high reasoning only when truly stuck

## Repository layout

```text
.
|-- README.md
|-- WORKSTYLE.md
|-- agents/
|   |-- README.md
|   |-- activation-guide.md
|   |-- operator-playbook.md
|   |-- agent-routing.md
|   |-- control-system-rules.md
|   |-- sync-protocol.md
|   |-- director.agent.md
|   |-- backend-engineer.agent.md
|   |-- frontend-engineer.agent.md
|   |-- qa-engineer.agent.md
|   |-- ui-ux-designer.agent.md
|   `-- use-agent.ps1
`-- dist/
    |-- manifest.json
    |-- SHA256SUMS.txt
    `-- release zip files
```

## GitHub use

This repo works well as:
- a personal Codex operating pack
- a shared team prompt pack
- a starting point for more specialized agent systems

If you publish it on GitHub, the cleanest pattern is:
- keep the source files in the repo root and `agents/`
- use `dist/` zips as release assets or downloadable snapshots
- extend roles carefully instead of making every agent do everything

## Extending the pack

- add new roles only when ownership is meaningfully different
- keep shared rules in the routing, control, and sync docs
- update the operator playbook whenever you add a new workflow
- preserve the cheap-first model policy

## Status

Current packaged release metadata lives in [`dist/manifest.json`](dist/manifest.json).

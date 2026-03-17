# Multi-Agent Pack

This folder is a ready-to-use five-agent operating pack for product, engineering, design, and QA work.

It is designed to do three things well:
- keep ownership clear
- keep model usage cheap by default
- keep cross-agent work synchronized without vague summaries

## Pack contents

- `director.agent.md`
- `backend-engineer.agent.md`
- `frontend-engineer.agent.md`
- `qa-engineer.agent.md`
- `ui-ux-designer.agent.md`
- `agent-routing.md`
- `control-system-rules.md`
- `sync-protocol.md`
- `operator-playbook.md`
- `activation-guide.md`
- `use-agent.ps1`

## Default way to use the pack

Start with the `Director` unless one of these is true:
- the task is obviously pure backend
- the task is obviously pure frontend
- the task is obviously pure design
- the task is obviously pure QA

Use the `Director` for:
- unclear scope
- multi-step feature work
- cross-functional bugs
- sequencing and handoff control
- final integration and readiness calls

## Agent roles at a glance

### `Director`
- Owns routing, scope control, sequencing, and final integration
- Default entry point for ambiguous or cross-functional work

### `Backend Engineer`
- Owns APIs, services, persistence, data contracts, integrations, jobs, and server performance

### `Frontend Engineer`
- Owns screens, flows, client state, browser behavior, accessibility, and UI integration

### `UI/UX Designer`
- Owns user flows, hierarchy, interaction states, visual rules, and implementation-ready design guidance

### `QA Engineer`
- Owns validation strategy, bug reproduction, regression checks, evidence, and release confidence

## Operating order

Use this order unless the task is clearly single-surface:

1. `Director` triages and assigns owner
2. `UI/UX Designer` defines behavior if the UX is not already locked
3. `Backend Engineer` locks contracts and server behavior if needed
4. `Frontend Engineer` implements the user-facing flow
5. `QA Engineer` validates the highest-risk paths
6. `Director` closes with readiness and next-step guidance

## Model and reasoning policy

Default for all agents:
- `gpt-5.1-codex-mini`
- `low` reasoning

Escalate only when necessary:
- `gpt-5.1-codex-max` / `medium`
  - ambiguous requirements
  - unfamiliar codebase area
  - non-trivial debugging
  - tricky tests
- `gpt-5.3-codex` / `high`
  - hard refactors
  - concurrency issues
  - deep performance problems
  - cross-layer failure analysis
- `gpt-5.4` / `extra high`
  - only when narrower attempts have failed and the problem is genuinely stuck

## Core rules

- One primary owner per slice
- No co-owned implementation slices
- Route by bottleneck, not by symptom
- Use the sync packet formats for handoffs and blockers
- State assumptions explicitly
- Separate validated facts from inference
- Keep scope bounded to the requested outcome

## Minimal daily workflow

### For a new task

1. Send the task to `Director`
2. Let `Director` produce an intake packet and assign the primary owner
3. Let the owner execute inside its lane
4. Use handoff packets only when ownership must move
5. End with QA validation if the change has user or system risk

### For a direct specialist task

1. Send the task straight to the specialist
2. If the specialist finds cross-functional impact, route back to `Director`
3. Continue only after ownership is clear again

## Quick routing guide

- API bug or data issue: `Backend Engineer`
- UI bug or form bug: `Frontend Engineer`
- unclear flow or UX problem: `UI/UX Designer`
- release confidence or regression risk: `QA Engineer`
- feature spanning multiple layers: `Director`

## Required documents by purpose

- Routing and ownership: `agent-routing.md`
- Authority, scope, escalation, and quality gates: `control-system-rules.md`
- Packet formats for updates and handoffs: `sync-protocol.md`
- Copy-paste operator prompts: `operator-playbook.md`
- Codex usage and role activation: `activation-guide.md`
- Quick prompt generator: `use-agent.ps1`

## Quickest launcher

From PowerShell in this workspace:

```powershell
.\agents\use-agent.ps1 director
```

Copy a ready prompt to clipboard:

```powershell
.\agents\use-agent.ps1 frontend -Task "Fix the broken settings form submit flow" -Clipboard
```

Run the whole system through Director:

```powershell
.\agents\use-agent.ps1 system -Task "Ship the new billing settings flow"
```

## Surgeon mode

Use this pack in a surgical way:
- make one owner responsible for one slice
- avoid parallel overlap on the same surface
- escalate model tier only when the cheap pass stops producing progress
- close each slice with validation and residual risk

If the system starts producing long vague summaries, routing churn, or duplicated investigation, return to `Director` and re-establish ownership.

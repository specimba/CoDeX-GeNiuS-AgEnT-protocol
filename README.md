# CoDeX GeNiuS AgEnT Protocol

Professional Codex-ready agent pack for managed software delivery.

Built for teams and solo operators who want:

- clear ownership instead of role drift
- low-context startup and restart
- predictable handoffs
- QA-backed confidence
- a reusable pack that feels operational, not experimental

## Why This Pack Exists

Most agent workflows break down in the same places:

- too many roles overlap
- prompts get longer as work gets harder
- restarts lose task state
- validation becomes hand-wavy
- complex tasks turn into noisy coordination

This repo solves that with a manager-led operating model:

`Operator -> Director (MANAGER) -> specialist owner -> QA -> Director`

The result is a Codex workflow that is faster to restart, easier to trust, and cleaner to run repeatedly.

## What You Get

- A five-role agent pack with explicit ownership boundaries
- One-command conversation bootstrap
- Task-scoped handoff generation
- Reader and Director startup prompts
- Managed task scripts with routing and ledger support
- Smoke tests, validation helpers, and determinism profiles
- A structure designed to reduce context waste instead of expanding it

## Quick Start

Verify the pack:

```powershell
.\agents\smoke-test-pack.ps1
```

Start a new compact conversation:

```powershell
.\START_NEW_CHAT.ps1
```

Generate a Director prompt directly:

```powershell
.\agents\use-agent.ps1 director
```

Start a managed task with routing plus ledger tracking:

```powershell
.\agents\start-managed-task.ps1 -Task "Investigate and deliver the feature"
```

## One-Command Startup

The default startup path is:

```powershell
.\START_NEW_CHAT.ps1
```

That command emits a compact handoff prompt containing:

- runtime rules
- latest task state
- current branch
- next slice
- fallback guidance only when broader routing is actually needed

If you need manual briefing prompts for a fresh reader or Director, use:

- [`agents/startup-prompts.md`](agents/startup-prompts.md)

## The Agent Pack

- `Director (MANAGER)`: routing, sequencing, scope control, integration
- `Backend Engineer`: APIs, persistence, contracts, jobs, backend debugging
- `Frontend Engineer`: UI flows, components, state, browser behavior, accessibility
- `UI/UX Designer`: flow quality, hierarchy, interaction design, handoff clarity
- `QA Engineer`: reproductions, regression coverage, evidence, release confidence

## How It Works

1. Verify the pack
2. Start or restart with `START_NEW_CHAT.ps1`
3. Route through `Director (MANAGER)` unless a specialist owner is obvious
4. Keep one primary owner per slice
5. Validate before stronger claims
6. Compact or hand off before the thread becomes expensive

## Repo Structure

- [`agents/`](agents): prompts, startup helpers, task control, validation scripts
- [`plans/`](plans): architecture notes, current-state program docs, optimization discipline
- [`profiles/`](profiles): determinism presets for repeatable validation
- [`golden/`](golden): bounded seed data for smoke and proof checks
- `runs/`: runtime state and archived validation artifacts
- `dist/`: generated release artifacts when packaging is used

## Key Entry Files

- [`START_NEW_CHAT.ps1`](START_NEW_CHAT.ps1): one-command compact restart
- [`THREAD_BOOTSTRAP.md`](THREAD_BOOTSTRAP.md): minimal startup rule for fresh conversations
- [`SYSTEM_INDEX.md`](SYSTEM_INDEX.md): full internal reference map
- [`agents/runtime-charter.md`](agents/runtime-charter.md): minimum runtime contract
- [`agents/new-thread-handoff.ps1`](agents/new-thread-handoff.ps1): task-scoped handoff generator
- [`agents/startup-prompts.md`](agents/startup-prompts.md): compact prompts for reader agents

## Operating Rules

- default to `Director (MANAGER)` when the task is cross-functional or unclear
- keep exactly one primary owner per slice
- use repo files as memory instead of long thread restatements
- prefer the cheapest competent model tier
- escalate only when the cheaper pass stops producing progress
- use QA for evidence, not reassurance

## Validation And Confidence

The pack includes:

- prompt and workflow smoke tests
- bounded review packet generation
- validation artifact helpers
- task ledger summaries and snapshots
- determinism profiles

Primary verification command:

```powershell
.\agents\smoke-test-pack.ps1
```

## Source Of Truth

Authoritative by default:

- `agents/`
- `plans/`
- root startup and policy files

Generated or runtime-only by default:

- `dist/`
- `runs/`
- `temp_extract_*`
- caches

## Contributing

Use [`CONTRIBUTING.md`](CONTRIBUTING.md) for contribution guidance.

Good changes keep the pack:

- clearer
- cheaper to run
- easier to route
- easier to validate

## Reference Map

For the full internal system map, use:

- [`SYSTEM_INDEX.md`](SYSTEM_INDEX.md)

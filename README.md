# CoDeX GeNiuS AgEnT Protocol

**Professional Codex-ready agent pack for managed software delivery.**

A manager-led operating system for Codex that turns scattered prompting into a disciplined workflow with clear ownership, compact restarts, and validation-first execution.

![Codex Ready](https://img.shields.io/badge/Codex-Ready-0f172a?style=for-the-badge)
![Manager Led](https://img.shields.io/badge/Workflow-Manager--Led-1d4ed8?style=for-the-badge)
![Validation First](https://img.shields.io/badge/Validation-QA--Backed-047857?style=for-the-badge)
![Startup](https://img.shields.io/badge/Startup-One--Command-7c3aed?style=for-the-badge)

## The Pitch

Most agent workflows fail in predictable ways:

- too many roles overlap
- prompts get heavier as tasks get harder
- restarts lose context
- validation becomes vague
- complex tasks dissolve into coordination noise

This pack is built to fix that.

It gives you a clean operating chain:

`Operator -> Director (MANAGER) -> specialist owner -> QA -> Director`

That means:

- one primary owner per slice
- low-context startup
- compact handoffs
- cheaper default model usage
- stronger proof before claiming confidence

## Why This Feels Different

Generic prompt packs usually give you more text.

This pack gives you more control:

| Problem | Typical Prompt Pack | CoDeX GeNiuS AgEnT Protocol |
| --- | --- | --- |
| Startup | Re-explain everything every time | One-command bootstrap with compact task state |
| Ownership | Multiple roles blur together | One primary owner per slice |
| Restarts | Thread history becomes the memory layer | Repo files and task-scoped handoffs become memory |
| Validation | “Looks good” style confidence | Smoke tests, review packets, validation helpers, QA discipline |
| Complexity | More docs, more prompt weight | Runtime charter first, broader docs only when needed |

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

Start a managed task with routing and ledger tracking:

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
- current branch
- latest task state
- next slice
- fallback guidance only when broader routing is actually needed

This is the intended reading order for a fresh conversation:

1. run `.\START_NEW_CHAT.ps1`
2. use the emitted handoff prompt as the bootstrap surface
3. continue from the stated next slice
4. open broader docs only if routing becomes ambiguous

If you need manual briefing prompts for a fresh reader or Director, use:

- [`agents/startup-prompts.md`](agents/startup-prompts.md)

Example emitted startup shape:

```text
Use my multi-agent pack in ...\agents.

Bootstrap rules:
- open ...\agents\runtime-charter.md first
- keep one primary owner per slice
- keep replies short and operational
- open SYSTEM_INDEX.md only if routing is ambiguous

Task state:
- branch: [current branch]
- task id: [latest task]
- latest owner: [owner]
- latest status: [status]

Next slice:
[next step]
```

## The Agent Pack

- `Director (MANAGER)`: routing, sequencing, scope control, integration
- `Backend Engineer`: APIs, persistence, contracts, jobs, backend debugging
- `Frontend Engineer`: UI flows, components, state, browser behavior, accessibility
- `UI/UX Designer`: flow quality, hierarchy, interaction design, handoff clarity
- `QA Engineer`: reproductions, regression coverage, evidence, release confidence

## Workflow In Practice

1. Verify the pack
2. Start or restart with `START_NEW_CHAT.ps1`
3. Route through `Director (MANAGER)` unless a specialist owner is obvious
4. Keep one primary owner per slice
5. Validate before stronger claims
6. Compact or hand off before the thread becomes expensive

## What Is In The Repo

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

## Design Principles

- clear ownership beats collaborative blur
- compact runtime surfaces beat long startup prose
- proof beats reassurance
- cheaper competent models beat expensive defaults
- file-based memory beats thread-history dependency
- bounded coordination beats fake parallelism

## Best For

- long-running Codex work that needs clean restarts
- multi-step engineering work with routing and proof needs
- people who want reusable agent operations instead of ad hoc prompts
- teams that care about ownership, validation, and low-context execution

## Not For

- casual one-off prompting with no workflow structure
- maximum-agent fan-out with loose coordination
- roleplay-heavy agent systems
- repos where generated artifacts are intended to stay as the main product surface

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

## Pack Philosophy

The point of this pack is not to sound more agentic.

The point is to make Codex work feel:

- tighter
- more recoverable
- easier to trust
- cheaper to run
- less dependent on thread memory

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

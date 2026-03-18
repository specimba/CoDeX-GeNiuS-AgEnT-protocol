# CoDeX GeNiuS AgEnT Protocol

Codex-optimized multi-agent operating pack for managed software delivery.

This repository is built for people who want a professional Codex workflow with:

- one clear manager-led control path
- explicit role ownership
- low-context startup and restart
- QA-backed validation instead of vague confidence
- reusable prompts, scripts, and proof helpers

Reference map:
- [`SYSTEM_INDEX.md`](SYSTEM_INDEX.md)

## What This Repo Is

This is a ready-to-use multi-agent pack for running software work through a disciplined chain:

`Operator -> Director (MANAGER) -> specialist owner -> QA -> Director`

It is designed to make Codex sessions faster, cleaner, and more repeatable by reducing prompt waste, keeping one primary owner per slice, and turning repo files into working memory.

## Why Use It

- Clear ownership: one primary owner per slice, no co-owned implementation loops.
- Faster startup: one-command conversation bootstrap with compact task state.
- Lower context burn: runtime charter, task-scoped handoff, early compaction rules.
- Better proof: smoke checks, validation helpers, bounded review packets, QA discipline.
- Cleaner reuse: startup prompts, managed task scripts, determinism profiles, golden data.

## Quick Start

Run the pack verification:

```powershell
.\agents\smoke-test-pack.ps1
```

Start a new compact Codex conversation:

```powershell
.\START_NEW_CHAT.ps1
```

Generate a role prompt directly:

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

That command emits a compact handoff prompt with:

- runtime rules
- current branch
- latest task state
- next slice
- fallback guidance only when broader routing is needed

If the next conversation needs a manual briefing prompt, use:

- [`agents/startup-prompts.md`](agents/startup-prompts.md)

## Agent Pack

- `Director (MANAGER)`: routing, scope control, sequencing, final integration
- `Backend Engineer`: APIs, persistence, contracts, jobs, backend debugging
- `Frontend Engineer`: UI flows, components, state, browser behavior, accessibility
- `UI/UX Designer`: interaction flows, hierarchy, design guidance, handoff clarity
- `QA Engineer`: validation strategy, reproductions, regression confidence, release proof

## Core Workflow

1. Verify the pack with `.\agents\smoke-test-pack.ps1`
2. Start or restart with `.\START_NEW_CHAT.ps1`
3. Route through `Director (MANAGER)` unless a specialist owner is obvious
4. Keep one primary owner per slice
5. Validate before stronger labels or release claims
6. Compact or hand off before the thread gets expensive

## Key Files

- [`THREAD_BOOTSTRAP.md`](THREAD_BOOTSTRAP.md): minimal startup rule for a fresh conversation
- [`SYSTEM_INDEX.md`](SYSTEM_INDEX.md): full system map and internal reference surface
- [`START_NEW_CHAT.ps1`](START_NEW_CHAT.ps1): one-command compact restart
- [`agents/runtime-charter.md`](agents/runtime-charter.md): minimum runtime contract
- [`agents/new-thread-handoff.ps1`](agents/new-thread-handoff.ps1): task-scoped handoff generator
- [`agents/startup-prompts.md`](agents/startup-prompts.md): compact prompts for new reader agents

## Repository Structure

- [`agents/`](agents): role prompts, startup helpers, task control scripts, validation helpers
- [`plans/`](plans): current-state program docs, architecture notes, optimization discipline
- [`profiles/`](profiles): determinism presets for repeatable proof runs
- [`golden/`](golden): bounded seed data for smoke and proof checks
- `dist/`: generated release artifacts
- `runs/`: runtime state and archived review artifacts

## Operating Rules

- default to `Director (MANAGER)` when scope is cross-functional or unclear
- keep one primary owner per slice
- use repo files as memory instead of long thread restatements
- prefer the cheapest competent model tier
- escalate only when the cheaper pass stops producing progress
- use QA for evidence and release confidence

## Validation

The pack includes:

- prompt and workflow smoke tests
- bounded review packet generation
- validation artifact helpers
- task ledger summaries and snapshots
- determinism profiles

Primary validation command:

```powershell
.\agents\smoke-test-pack.ps1
```

## Source Of Truth

Authoritative by default:

- `agents/`
- `plans/`
- root policy and startup files

Generated or runtime-only by default:

- `dist/`
- `runs/`
- `temp_extract_*`
- caches

## Contributing

Use [`CONTRIBUTING.md`](CONTRIBUTING.md) for contribution guidance.

If you extend the pack:

- keep startup surfaces compact
- preserve the one-owner rule
- update smoke coverage when adding new helpers
- prefer cleaner workflow over more documentation

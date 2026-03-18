# Multi-Agent Pack

A practical company-style multi-agent operating system for planning, backend, frontend, design, and QA work.

Canonical entrypoint:
- [`SYSTEM_INDEX.md`](SYSTEM_INDEX.md)

GitHub / GENIUS AGENT install:
- [`README.txt`](README.txt)

## Start here

Open [`SYSTEM_INDEX.md`](SYSTEM_INDEX.md) first, then open the current-state plan:
- [`plans/autonomous-execution-program-2026-03-18.md`](plans/autonomous-execution-program-2026-03-18.md)

## Quick use

```powershell
.\agents\use-agent.ps1 director
```

```powershell
.\agents\use-agent.ps1 frontend -Task "Fix the broken settings form submit flow" -Clipboard
```

```powershell
.\agents\use-agent.ps1 system -Task "Investigate and deliver the new billing settings feature"
```

Context reset:

```powershell
.\START_NEW_CHAT.ps1
```

Reader briefing prompts:
- [`agents/startup-prompts.md`](agents/startup-prompts.md)

## Source boundary

Source of truth:
- `agents/`
- `plans/`
- root policy files

Generated or runtime-only by default:
- `dist/`
- `runs/`
- `temp_extract_*`
- cache files

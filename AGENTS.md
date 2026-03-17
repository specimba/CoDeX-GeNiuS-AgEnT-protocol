# Agent Instructions (Repo-Local)

This repository is a multi-agent operating pack.

## Operating Rules

- Prefer the five-agent pack in `./agents`.
- Default entry point is `Director (MANAGER)` unless the task is obviously single-surface.
- Keep exactly one primary owner per slice; no co-owned implementation slices.
- Follow the shared rules:
  - `WORKSTYLE.md`
  - `agents/agent-routing.md`
  - `agents/control-system-rules.md`
  - `agents/sync-protocol.md`
- Use QA for evidence and release confidence.
- Keep model usage cheap by default; escalate only when the cheaper pass stops producing progress.

## Sanity Checks

- Before relying on the pack for real work, run:

```powershell
.\agents\smoke-test-pack.ps1
```


# Background Agents UI

This note explains why a repo-defined role file does not automatically appear in the Codex app's Background Agents panel.

## What the panel does

- The Background Agents UI shows runtime agents and agent threads created by the Codex app.
- Files in this repository such as `director.agent.md` and `backend-engineer.agent.md` define operating prompts and rules.
- Those files do not register themselves as clickable built-in agents in the app sidebar.

## What is true in this repo

- `Director (MANAGER)` exists as a real role file in `agents/director.agent.md`.
- The launcher `agents/use-agent.ps1` can generate the correct prompt for `Director (MANAGER)` and the other four roles.
- The routing, control, sync, and pipeline docs now reference `Director (MANAGER)` consistently.

## What is not available here

- There is no repo-local manifest, config key, or agent registry in this workspace that the Codex app reads to populate the Background Agents panel.
- Editing role markdown files will not make a new custom agent appear there by itself.

## Supported way to use this pack

1. Generate a role prompt with `.\agents\use-agent.ps1`.
2. Start a new Codex thread or background task with that prompt.
3. Keep the thread open if you want it visible in the app's agent workspace.

## Fast examples

```powershell
.\agents\use-agent.ps1 director -Clipboard
.\agents\use-agent.ps1 backend -Task "Trace the playback metadata contract" -Clipboard
.\agents\use-agent.ps1 system -Task "Run the pack for a cross-functional feature" -Clipboard
```

## Practical conclusion

If `Director (MANAGER)` is not visible in the Background Agents panel, the missing piece is not the role file in this repo. The missing piece is that no runtime background agent has been created by the app from that prompt yet.

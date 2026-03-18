# Activation Guide

Canonical entry is `C:\Users\speci.000\.codex\worktrees\449e\Playground\SYSTEM_INDEX.md`.

Use this file for runtime commands only. The scripts are canonical. Prefer them over manual prompt templates.

## Fastest launcher from this workspace

Use the helper script:

```powershell
.\agents\use-agent.ps1 director
```

Copy a prompt directly to clipboard:

```powershell
.\agents\use-agent.ps1 qa -Task "Run a focused release-readiness pass for the settings flow" -Clipboard
```

Run the full pack through Director (MANAGER):

```powershell
.\agents\use-agent.ps1 system -Task "Investigate and deliver the profile settings feature"
```

Start a managed run with task id + ledger entry + Director prompt:

```powershell
.\agents\start-managed-task.ps1 -Task "Investigate and deliver the profile settings feature"
```

Preview the lightweight classification first:

```powershell
.\agents\triage-task.ps1 -Task "Investigate and deliver the profile settings feature"
```

Close a managed run after Director sign-off:

```powershell
.\agents\close-managed-task.ps1 -TaskId "investigate-and-deliver-the-profile-set-20260318123000" -Status closed -DeliverableLabel Verified -Note "Released after QA"
```

Check whether the thread should compact:

```powershell
.\agents\should-compact.ps1 -ContextPercent 81 -TaskId "[task-id]" -HandoffCount 2
```

Create a task-scoped restart prompt:

```powershell
.\agents\new-thread-handoff.ps1 -TaskId "[task-id]" -Clipboard -WriteFile
```

## Prompt templates

Use `C:\Users\speci.000\.codex\worktrees\449e\Playground\agents\operator-playbook.md` for copy-paste prompts.

## Background Agents UI

If you are looking at the Codex app's Background Agents panel, read `background-agents-ui.md`.

Short version:
- the panel shows runtime agents created by the app
- repo role files do not auto-register there
- use `use-agent.ps1` to generate the exact role prompt, then start a thread or background task with it

## Important note

These files are operating instructions, not executable plugins.

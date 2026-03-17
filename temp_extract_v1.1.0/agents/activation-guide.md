# Activation Guide

This pack does not auto-register itself as clickable built-in agents in Codex.

The practical way to use it here is to invoke a role explicitly in your prompt and point Codex at the pack.

If you cloned this repository somewhere else, replace the example absolute path with your own local checkout path.

## Fastest launcher from this workspace

Use the helper script:

```powershell
.\agents\use-agent.ps1 director
```

Copy a prompt directly to clipboard:

```powershell
.\agents\use-agent.ps1 qa -Task "Run a focused release-readiness pass for the settings flow" -Clipboard
```

Run the full pack through Director:

```powershell
.\agents\use-agent.ps1 system -Task "Investigate and deliver the profile settings feature"
```

## Fastest way

Start a prompt with one of these:

```text
Act as Director. Follow [your-local-repo]\agents\director.agent.md and the shared docs in [your-local-repo]\agents.
```

```text
Act as Backend Engineer. Follow [your-local-repo]\agents\backend-engineer.agent.md and the shared docs in [your-local-repo]\agents.
```

```text
Act as Frontend Engineer. Follow [your-local-repo]\agents\frontend-engineer.agent.md and the shared docs in [your-local-repo]\agents.
```

```text
Act as UI/UX Designer. Follow [your-local-repo]\agents\ui-ux-designer.agent.md and the shared docs in [your-local-repo]\agents.
```

```text
Act as QA Engineer. Follow [your-local-repo]\agents\qa-engineer.agent.md and the shared docs in [your-local-repo]\agents.
```

## Best daily pattern

Use `Director` first for:
- unclear tasks
- cross-functional work
- feature delivery
- bug triage
- coordination and handoffs

Use direct specialist activation only when the owner is obvious.

## Easiest reusable commands

You can keep short prompt snippets like these in your notes:

```text
Use my Director pack from [your-local-repo]\agents and route this task correctly:
[task]
```

```text
Use my Frontend Engineer pack from [your-local-repo]\agents for this UI task:
[task]
```

## If you want sub-agent style behavior

Ask Codex like this:

```text
Use my multi-agent pack in [your-local-repo]\agents.
Director should triage first, then delegate as needed.
Task:
[task]
```

That is the closest practical activation model in this environment.

## Important note

These files are operating instructions, not executable plugins. Activation here means:
- Codex reads the selected role file
- Codex follows the shared routing, control, and sync rules
- Codex responds in that role for the task

For ready-made prompts, use `operator-playbook.md`.

# Startup Prompts

Use these when a new conversation or reader agent needs the fastest correct startup.

Prefer `START_NEW_CHAT.ps1` first. Use these prompts only when you need a manual briefing surface.

## 1. Reader Startup Prompt

```text
Open `agents/runtime-charter.md` first.
Use the emitted handoff prompt as the task state source.
Keep one primary owner.
Keep replies short and operational.
Do not reopen broad system docs unless routing is ambiguous.
Continue directly from the stated next slice.
```

## 2. Director Briefing Prompt

```text
Act as Director (MANAGER).

Open `agents/runtime-charter.md` first.
Treat the emitted handoff prompt as the canonical task state.
Use `SYSTEM_INDEX.md` only if routing or scope is ambiguous.

Please:
1. confirm the primary owner
2. restate the next slice in operational terms
3. execute the narrowest useful step
4. validate before stronger labels
5. compact or hand off early if the thread gets expensive
```

## 3. Specialist Reader Prompt

```text
Open `agents/runtime-charter.md` first.
Use the emitted handoff prompt as the only required task state.
Stay inside the current slice.
State assumptions briefly.
Return concrete output plus validation status.
```

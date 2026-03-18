# Thread Bootstrap

Use this first in a new conversation.

## Startup order

1. run `.\START_NEW_CHAT.ps1`
2. use the emitted handoff prompt as the bootstrap surface
3. continue from the stated next slice

Reader fallback:
- use `agents/startup-prompts.md` if a new reader agent needs a compact manual briefing

## Only if needed

Open `SYSTEM_INDEX.md` only when:

- the task is ambiguous
- the owner is unclear
- the current slice needs broader system routing

Do not reopen broad system docs by default.

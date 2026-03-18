GENIUS AGENT INSTALL GUIDE

Repository:
https://github.com/specimba/Playground

Branch:
codex/specimba/genius-agent-install-entry

Quick install:
1. Clone or pull the repo.
2. Check out `codex/specimba/genius-agent-install-entry`.
3. Open PowerShell in the repo root.
4. Run `.\agents\smoke-test-pack.ps1`.
5. Start a new compact conversation with `.\START_NEW_CHAT.ps1`.

Fast startup path:
- `START_NEW_CHAT.ps1`
- emitted handoff prompt
- `agents\runtime-charter.md` only if needed
- `SYSTEM_INDEX.md` only if routing is ambiguous

Reader-agent prompts:
- `agents\startup-prompts.md`

Important files:
- `THREAD_BOOTSTRAP.md`
- `START_NEW_CHAT.ps1`
- `SYSTEM_INDEX.md`
- `agents\runtime-charter.md`
- `agents\new-thread-handoff.ps1`

If `START_NEW_CHAT.ps1` works and `.\agents\smoke-test-pack.ps1` passes, the install is good.

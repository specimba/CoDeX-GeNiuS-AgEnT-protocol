# Contributing

This repository is a prompt-and-protocol system, not a code framework.

Good contributions make the pack clearer, cheaper to run, and easier to route. Bad contributions make roles blur together.

## Contribution rules

- Keep one role focused on one kind of ownership.
- Put shared behavior in shared docs, not duplicated into every role file.
- Prefer cheaper default model settings unless there is a clear quality loss.
- Add escalation rules instead of making expensive models the default.
- Make handoffs more precise, not more verbose.
- Keep outputs concrete, testable, and role-specific.

## When adding or changing a role

Update all relevant places:
- `agents/*.agent.md`
- `agents/agent-routing.md`
- `agents/control-system-rules.md`
- `agents/sync-protocol.md`
- `agents/operator-playbook.md`
- `agents/README.md`

## Review standard

A good change should improve at least one of:
- routing clarity
- scope control
- model efficiency
- handoff quality
- operator ease of use

Avoid changes that:
- turn multiple roles into near-duplicates
- make prompts longer without increasing precision
- hide escalation logic
- encourage unnecessary coordination for simple tasks

## Packaging

If you use release packaging helpers, treat `dist/` output as generated artifacts.
Do not rely on generated files as the source of truth for normal development.

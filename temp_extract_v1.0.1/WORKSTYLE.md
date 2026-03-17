# Workstyle Memory

This file records the preferred Codex working style for this workspace.

## Preferred operating style

- Use the multi-agent pack in `C:\Users\speci.000\Documents\Playground\agents`
- Start with `Director` unless the owner is obviously one specialist
- Keep one primary owner per slice
- Route by bottleneck, not by symptom
- Use the cheapest competent model first
- Escalate model tier only when the lower-cost pass stops producing progress
- Prefer surgical, bounded edits over broad refactors
- Use QA for proof and release confidence, not for vague reassurance

## Model preference

- Default everyday work: `gpt-5.1-codex-mini` with low reasoning
- Escalate for non-trivial bugs, tricky tests, or unfamiliar areas: `gpt-5.1-codex-max` with medium reasoning
- Escalate for hard debugging, concurrency, performance, or gnarly refactors: `gpt-5.3-codex` with high reasoning
- Use `gpt-5.4` with extra high reasoning only when truly stuck

## When Codex should suggest this system

Suggest the multi-agent pack when:
- the task is cross-functional
- the scope is unclear
- there is handoff or sequencing risk
- the work touches backend, frontend, design, and QA together
- the user seems to be drifting between roles

Do not push the system when:
- the task is clearly one small single-surface fix
- the user wants a quick one-off answer
- the extra coordination would add more ceremony than value

## Fast activation

- Read `agents/activation-guide.md`
- Use `agents/use-agent.ps1` for quick prompt generation
- Use `agents/operator-playbook.md` for copy-paste workflows

## Note

This is workspace memory, not guaranteed global account memory. If this workspace is available, Codex should use it as the preferred operating reference.

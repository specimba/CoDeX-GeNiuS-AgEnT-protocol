# Role Model Policy

This is the central low-energy model and reasoning map for the five-agent system.

Rule:

- use the cheapest model that is genuinely competent for the current slice
- escalate only when progress stalls, ambiguity remains material, or the risk class justifies it
- do not over-upgrade a role "just in case"

## Default per role

- `Director (MANAGER)`
  - model: `gpt-5.1-codex-mini`
  - reasoning: `low`
  - use for triage, routing, scope control, integration, and light reviews

- `Backend Engineer`
  - model: `gpt-5.1-codex-mini`
  - reasoning: `low`
  - use for bounded API, service, storage, and backend debugging work

- `Frontend Engineer`
  - model: `gpt-5.1-codex-mini`
  - reasoning: `low`
  - use for normal UI, state, and browser-side work

- `UI/UX Designer`
  - model: `gpt-5.1-codex-mini`
  - reasoning: `low`
  - use for flows, hierarchy, wireframes, and handoff notes

- `QA Engineer`
  - model: `gpt-5.1-codex-mini`
  - reasoning: `low`
  - use for focused validation, reproductions, and release confidence

## Escalation rules

- escalate to `gpt-5.1-codex-max` with `medium` reasoning when:
  - the owner is in the correct lane
  - the slice is still bounded
  - lower-cost passes stopped producing useful progress

- escalate to `gpt-5.3-codex` with `high` reasoning when:
  - the problem is genuinely hard
  - concurrency, performance, or deep integration risk is central
  - a medium pass did not resolve the uncertainty

- escalate to `gpt-5.4` only when:
  - the task is still blocked after narrower attempts
  - the blast radius justifies the cost

## Anti-waste rules

- do not use a stronger model to compensate for unclear scope
- fix routing first, then escalate if needed
- do not keep high-reasoning agents open after the slice is complete
- if a stronger model or reasoning level is used, record why
- managed start and managed close should include an escalation reason only when escalation actually occurred

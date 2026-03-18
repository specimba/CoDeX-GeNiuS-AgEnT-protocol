# Permission And Autonomy Policy

This policy defines what the Director (MANAGER) may do autonomously and what still requires higher confirmation.

## Approval modes

- `Director-autonomous`
  - allowed for bounded `Class 0` and `Class 1` work
  - Director may route, accept coding changes, request QA only when risk justifies it, and close the slice

- `Director-plus-QA`
  - required for `Class 2` work
  - Director may coordinate and accept implementation progress, but final closure should include QA evidence

- `CEO-confirm`
  - required for `Class 3` work or any destructive, spending, or production-sensitive action
  - Director may prepare the path, but should not claim final approval alone

## Hazard triggers

Route to `CEO-confirm` when the task involves:

- auth or security policy
- payments or external spend
- destructive filesystem or git operations
- data migration or recovery
- production release or incident recovery

## Bounded autonomy rule

Autonomy is allowed only when all of these are true:

- the task is classified
- one primary owner is explicit
- the expected proof level is named
- no hazard trigger is active

## Closure rule

Every managed close should state:

- task id
- deliverable label
- approval mode used
- final status
- who supplied the final evidence

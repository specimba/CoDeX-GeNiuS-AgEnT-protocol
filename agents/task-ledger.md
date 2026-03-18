# Task Ledger

This is the lightweight durable memory for the five-agent pack.

It exists to track attempts, owners, and outcomes without building a heavy orchestration layer first.

Storage:

- append-only JSONL file at `runs/agent-ledger/task-events.jsonl`
- optional snapshot file at `runs/agent-ledger/task-snapshots.jsonl`

Use cases:

- count repeated attempts on the same slice
- keep audit history after ownership transfers
- record deliverable labels and status transitions
- avoid repeating low-evidence loops

## Commands

Append an event:

```powershell
.\agents\task-ledger.ps1 append `
  -TaskId "playback-bug-001" `
  -Owner "Director (MANAGER)" `
  -Event "intake" `
  -Status "active" `
  -AttemptCount 1 `
  -Note "Routed to frontend first"
```

Show the latest event per task:

```powershell
.\agents\task-ledger.ps1 summary
```

Show full history for one task:

```powershell
.\agents\task-ledger.ps1 history -HistoryTaskId "playback-bug-001"
```

Show the next attempt count for a task:

```powershell
.\agents\task-ledger.ps1 next-attempt -TaskSummaryId "playback-bug-001"
```

Show a compact summary for one task:

```powershell
.\agents\task-ledger.ps1 task-summary -TaskSummaryId "playback-bug-001"
```

Write task snapshots for compact restarts:

```powershell
.\agents\task-ledger.ps1 snapshot
```

Reset the ledger:

```powershell
.\agents\task-ledger.ps1 reset
```

Close a managed task:

```powershell
.\agents\close-managed-task.ps1 -TaskId "playback-bug-001" -Status closed -DeliverableLabel Verified -Note "QA passed and Director closed the slice"
```

## Event discipline

Recommended event names:

- `intake`
- `progress`
- `handoff`
- `blocked`
- `completion`
- `closed`

Recommended statuses:

- `active`
- `blocked`
- `validated`
- `deferred`
- `closed`

## Minimum fields

Each append should capture:

- task id
- owner
- event
- status
- attempt count

Add these when relevant:

- deliverable label
- note
- path

Notes and paths are truncated automatically to keep runtime memory bounded.

## Rule

If a task reaches attempt count 2 with weak evidence, route it back through `Director (MANAGER)` instead of repeating the same slice again.

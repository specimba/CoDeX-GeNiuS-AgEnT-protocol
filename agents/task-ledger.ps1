# Purpose: store append-only task events and derive task history, summaries, and retry state.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet("append", "summary", "history", "latest", "next-attempt", "task-summary", "snapshot", "reset")]
    [string]$Action,

    [string]$TaskId,

    [string]$Owner,

    [string]$Event,

    [string]$Status,

    [string]$Note,

    [string]$DeliverableLabel,

    [int]$AttemptCount,

    [string]$Path = "",

    [string]$HistoryTaskId,

    [string]$LatestTaskId,

    [string]$TaskSummaryId
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$agentsPath = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
$repoRoot = (Resolve-Path (Join-Path $agentsPath "..")).Path
$ledgerDir = Join-Path $repoRoot "runs\agent-ledger"
$ledgerPath = Join-Path $ledgerDir "task-events.jsonl"
$snapshotPath = Join-Path $ledgerDir "task-snapshots.jsonl"

function Ensure-LedgerDir {
    if (-not (Test-Path $ledgerDir)) {
        New-Item -ItemType Directory -Path $ledgerDir | Out-Null
    }
}

function Get-Events {
    Ensure-LedgerDir
    if (-not (Test-Path $ledgerPath -PathType Leaf)) {
        return @()
    }

    $events = @()
    foreach ($line in Get-Content $ledgerPath) {
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            $events += ($line | ConvertFrom-Json)
        }
    }
    return $events
}

function Get-LastEventForTask {
    param([string]$RequestedTaskId)

    Ensure-LedgerDir
    if (-not (Test-Path $ledgerPath -PathType Leaf)) {
        return $null
    }

    $latestMatch = $null
    foreach ($line in Get-Content $ledgerPath) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        $entry = $line | ConvertFrom-Json
        if ($entry.task_id -eq $RequestedTaskId) {
            $latestMatch = $entry
        }
    }

    return $latestMatch
}

function Get-LatestByTask {
    param([object[]]$Events)

    $latest = @{}
    foreach ($entry in $Events) {
        $latest[$entry.task_id] = $entry
    }
    return $latest
}

function Get-MaxAttemptCount {
    param([object[]]$Events)

    $maxAttempt = 0
    foreach ($entry in $Events) {
        if ($null -ne $entry.attempt_count -and [int]$entry.attempt_count -gt $maxAttempt) {
            $maxAttempt = [int]$entry.attempt_count
        }
    }
    return $maxAttempt
}

switch ($Action) {
    "append" {
        foreach ($required in @("TaskId", "Owner", "Event", "Status")) {
            if ([string]::IsNullOrWhiteSpace((Get-Variable -Name $required -ValueOnly))) {
                throw "Missing required field for append: $required"
            }
        }

        Ensure-LedgerDir

        $eventRecord = [ordered]@{
            timestamp = (Get-Date).ToString("o")
            task_id = $TaskId
            owner = $Owner
            event = $Event
            status = $Status
            attempt_count = $AttemptCount
            deliverable_label = $DeliverableLabel
            note = if ([string]::IsNullOrWhiteSpace($Note)) { "" } elseif ($Note.Length -gt 240) { $Note.Substring(0, 240) } else { $Note }
            path = if ([string]::IsNullOrWhiteSpace($Path)) { "" } elseif ($Path.Length -gt 240) { $Path.Substring(0, 240) } else { $Path }
        }

        Add-Content -Path $ledgerPath -Value (($eventRecord | ConvertTo-Json -Compress))
        Write-Output ("Appended event for task '{0}'." -f $TaskId)
    }
    "summary" {
        $events = @(Get-Events)
        if ($events.Count -eq 0) {
            Write-Output "No task events recorded."
            break
        }

        $latest = Get-LatestByTask -Events $events
        $rows = foreach ($task in ($latest.Keys | Sort-Object)) {
            $entry = $latest[$task]
            [pscustomobject]@{
                TaskId = $entry.task_id
                Owner = $entry.owner
                Event = $entry.event
                Status = $entry.status
                Attempt = $entry.attempt_count
                Label = $entry.deliverable_label
                Timestamp = $entry.timestamp
            }
        }

        $rows | Format-Table -AutoSize | Out-String | Write-Output
    }
    "history" {
        if ([string]::IsNullOrWhiteSpace($HistoryTaskId)) {
            throw "Missing required field for history: HistoryTaskId"
        }

        $events = @(Get-Events | Where-Object { $_.task_id -eq $HistoryTaskId })
        if ($events.Count -eq 0) {
            Write-Output ("No history found for task '{0}'." -f $HistoryTaskId)
            break
        }

        $events | Select-Object timestamp, task_id, owner, event, status, attempt_count, deliverable_label, note, path |
            Format-Table -AutoSize | Out-String | Write-Output
    }
    "latest" {
        if ([string]::IsNullOrWhiteSpace($LatestTaskId)) {
            throw "Missing required field for latest: LatestTaskId"
        }

        $latest = Get-LastEventForTask -RequestedTaskId $LatestTaskId
        if ($null -eq $latest) {
            Write-Output ""
            break
        }

        $latest | ConvertTo-Json -Compress | Write-Output
    }
    "next-attempt" {
        if ([string]::IsNullOrWhiteSpace($TaskSummaryId)) {
            throw "Missing required field for next-attempt: TaskSummaryId"
        }

        $events = @(Get-Events | Where-Object { $_.task_id -eq $TaskSummaryId })
        if ($events.Count -eq 0) {
            Write-Output "1"
            break
        }

        Write-Output ((Get-MaxAttemptCount -Events $events) + 1)
    }
    "task-summary" {
        if ([string]::IsNullOrWhiteSpace($TaskSummaryId)) {
            throw "Missing required field for task-summary: TaskSummaryId"
        }

        $events = @(Get-Events | Where-Object { $_.task_id -eq $TaskSummaryId })
        if ($events.Count -eq 0) {
            Write-Output ("No summary found for task '{0}'." -f $TaskSummaryId)
            break
        }

        $latest = $events[$events.Count - 1]
        $owners = @($events | ForEach-Object { $_.owner } | Select-Object -Unique)
        $eventKinds = @($events | ForEach-Object { $_.event } | Select-Object -Unique)
        $maxAttempt = Get-MaxAttemptCount -Events $events

        [pscustomobject]@{
            TaskId = $TaskSummaryId
            LatestOwner = $latest.owner
            LatestEvent = $latest.event
            LatestStatus = $latest.status
            AttemptCount = $maxAttempt
            DeliverableLabel = $latest.deliverable_label
            Owners = ($owners -join ", ")
            EventKinds = ($eventKinds -join ", ")
            StartedAt = $events[0].timestamp
            LastUpdatedAt = $latest.timestamp
        } | Format-List | Out-String | Write-Output
    }
    "reset" {
        Ensure-LedgerDir
        if (Test-Path $ledgerPath -PathType Leaf) {
            Remove-Item $ledgerPath -Force
        }
        if (Test-Path $snapshotPath -PathType Leaf) {
            Remove-Item $snapshotPath -Force
        }
        Write-Output "Ledger reset."
    }
    "snapshot" {
        $events = @(Get-Events)
        if ($events.Count -eq 0) {
            Write-Output "No task events recorded."
            break
        }

        Ensure-LedgerDir
        $latest = Get-LatestByTask -Events $events
        $rows = foreach ($task in ($latest.Keys | Sort-Object)) {
            $taskEvents = @($events | Where-Object { $_.task_id -eq $task })
            $final = $latest[$task]
            [pscustomobject]@{
                task_id = $task
                latest_owner = $final.owner
                latest_status = $final.status
                deliverable_label = $final.deliverable_label
                attempt_count = Get-MaxAttemptCount -Events $taskEvents
                event_count = $taskEvents.Count
                started_at = $taskEvents[0].timestamp
                last_updated_at = $final.timestamp
            }
        }

        $rows | ForEach-Object {
            ($_ | ConvertTo-Json -Compress) | Add-Content -Path $snapshotPath
        }

        Write-Output ("Wrote task snapshots: {0}" -f $snapshotPath)
    }
}

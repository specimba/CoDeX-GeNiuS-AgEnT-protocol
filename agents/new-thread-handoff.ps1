# Purpose: generate the smallest useful restart prompt for a fresh conversation.
[CmdletBinding()]
param(
    [string]$NextSlice = "richer completion packet helper",
    [string]$TaskId = "",
    [switch]$Compact,
    [switch]$Clipboard,
    [switch]$WriteFile
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$threadBootstrap = Join-Path $repoRoot "THREAD_BOOTSTRAP.md"
$runtimeCharter = Join-Path $repoRoot "agents\runtime-charter.md"
$systemIndex = Join-Path $repoRoot "SYSTEM_INDEX.md"
$autonomousPlan = Join-Path $repoRoot "plans\autonomous-execution-program-2026-03-18.md"
$ledgerFile = Join-Path $repoRoot "runs\agent-ledger\task-events.jsonl"
$handoffFile = Join-Path $repoRoot "CURRENT_THREAD_HANDOFF.txt"
$taskLedgerScript = Join-Path $repoRoot "agents\task-ledger.ps1"
$reviewPacketDir = Join-Path $repoRoot "runs\review-packets"

if (-not (Test-Path $systemIndex -PathType Leaf)) {
    throw "Missing system index: $systemIndex"
}

if (-not (Test-Path $threadBootstrap -PathType Leaf)) {
    throw "Missing thread bootstrap: $threadBootstrap"
}

if (-not (Test-Path $autonomousPlan -PathType Leaf)) {
    throw "Missing autonomous execution plan: $autonomousPlan"
}

$branch = (git -C $repoRoot branch --show-current).Trim()
$latestTaskId = ""

if (Test-Path $ledgerFile -PathType Leaf) {
    $latestLine = Get-Content $ledgerFile -Tail 1
    if (-not [string]::IsNullOrWhiteSpace($latestLine)) {
        $latestEvent = $latestLine | ConvertFrom-Json
        $latestTaskId = [string]$latestEvent.task_id
    }
}

if ([string]::IsNullOrWhiteSpace($TaskId)) {
    $TaskId = $latestTaskId
}

$prompt = ""
$compactMode = $Compact.IsPresent -or $true

if (-not [string]::IsNullOrWhiteSpace($TaskId) -and (Test-Path $taskLedgerScript -PathType Leaf)) {
    $latestTaskJson = & $taskLedgerScript latest -LatestTaskId $TaskId
    $latestTask = $null
    if (-not [string]::IsNullOrWhiteSpace($latestTaskJson)) {
        $latestTask = $latestTaskJson | ConvertFrom-Json
    }

    $attemptCount = (& $taskLedgerScript next-attempt -TaskSummaryId $TaskId | Out-String).Trim()
    if (-not [string]::IsNullOrWhiteSpace($attemptCount)) {
        $attemptCount = [int]$attemptCount - 1
    }

    $latestReviewPacket = ""
    if (Test-Path $reviewPacketDir -PathType Container) {
        $match = Get-ChildItem $reviewPacketDir -File |
            Where-Object { $_.Name -like "$TaskId-*" } |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
        if ($null -ne $match) {
            $latestReviewPacket = $match.FullName
        }
    }

    $latestOwner = if ($null -ne $latestTask) { [string]$latestTask.owner } else { "[unknown]" }
    $latestEvent = if ($null -ne $latestTask) { [string]$latestTask.event } else { "[unknown]" }
    $latestStatus = if ($null -ne $latestTask) { [string]$latestTask.status } else { "[unknown]" }
    $deliverableLabel = if ($null -ne $latestTask -and -not [string]::IsNullOrWhiteSpace([string]$latestTask.deliverable_label)) { [string]$latestTask.deliverable_label } else { "[none]" }

    $prompt = @"
Use my multi-agent pack in $repoRoot\agents.

Bootstrap rules:
- open $runtimeCharter first
- keep one primary owner per slice
- keep replies short and operational
- use repo files as memory, not old chat history
- validate before stronger labels
- compact at 81% context, 2 handoffs, 3 progress updates without validation, 2 reviews, or any reasoning-waste signal
- open SYSTEM_INDEX.md only if routing is ambiguous

Task state:
- branch: $branch
- task id: $TaskId
- latest owner: $latestOwner
- latest event: $latestEvent
- latest status: $latestStatus
- attempt count: $attemptCount
- deliverable label: $deliverableLabel

Next slice:
$NextSlice
"@

    if (-not [string]::IsNullOrWhiteSpace($latestReviewPacket)) {
        $prompt += "`r`nEvidence pointer: $latestReviewPacket"
    }
} else {
    $prompt = @"
Use my multi-agent pack in $repoRoot\agents.

Bootstrap rules:
- open $runtimeCharter first
- keep one primary owner per slice
- keep replies short and operational
- use repo files as memory, not old chat history
- open SYSTEM_INDEX.md only if routing or scope is ambiguous
- use $autonomousPlan as the live current-state fallback

Task state:
- branch: $branch
- latest task id: $latestTaskId

Next slice:
$NextSlice
"@
}

if ($Clipboard) {
    Set-Clipboard -Value $prompt
}

if ($WriteFile -or -not $Clipboard) {
    Set-Content -Path $handoffFile -Value $prompt -NoNewline
}

Write-Output $prompt
Write-Output ""
Write-Output ("Saved handoff file: {0}" -f $handoffFile)

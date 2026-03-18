# Purpose: close a managed task with status, label, approval mode, and escalation trace.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TaskId,

    [ValidateSet("Concept", "Prototype", "Verified", "Deferred")]
    [string]$DeliverableLabel = "Prototype",

    [ValidateSet("validated", "deferred", "closed", "blocked")]
    [string]$Status = "closed",

    [string]$Owner = "Director (MANAGER)",

    [string]$Note = "Managed task closed",

    [ValidateSet("Director-autonomous", "Director-plus-QA", "CEO-confirm")]
    [string]$ApprovalMode = "Director-autonomous",

    [string]$EscalationReason = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$agentsPath = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
$ledgerPath = Join-Path $agentsPath "task-ledger.ps1"

if ([string]::IsNullOrWhiteSpace($TaskId)) {
    throw "TaskId cannot be empty."
}

if (-not (Test-Path $ledgerPath -PathType Leaf)) {
    throw "Missing task ledger: $ledgerPath"
}

$latestJson = & $ledgerPath latest -LatestTaskId $TaskId | Out-String
if ([string]::IsNullOrWhiteSpace($latestJson)) {
    throw ("Unknown task id: {0}" -f $TaskId)
}

$latest = $latestJson | ConvertFrom-Json
$attemptCount = if ($null -ne $latest.attempt_count -and [int]$latest.attempt_count -gt 0) { [int]$latest.attempt_count } else { 1 }
$priorEscalationReason = ""
if (-not [string]::IsNullOrWhiteSpace([string]$latest.note)) {
    $priorEscalationMatch = [regex]::Match([string]$latest.note, '(^|;\s*)escalation=(?<reason>.*)$')
    if ($priorEscalationMatch.Success) {
        $priorEscalationReason = $priorEscalationMatch.Groups["reason"].Value.Trim()
    }
}
$wasEscalated = -not [string]::IsNullOrWhiteSpace($priorEscalationReason) -or -not [string]::IsNullOrWhiteSpace($EscalationReason)

if ([string]::IsNullOrWhiteSpace($EscalationReason) -and -not [string]::IsNullOrWhiteSpace($priorEscalationReason)) {
    $EscalationReason = $priorEscalationReason
}

if ($wasEscalated -and [string]::IsNullOrWhiteSpace($EscalationReason)) {
    throw "EscalationReason is required when closing a task that used an escalated model or reasoning level."
}

& $ledgerPath append -TaskId $TaskId -Owner $Owner -Event "closed" -Status $Status -AttemptCount $attemptCount -DeliverableLabel $DeliverableLabel -Note ("{0}; approval={1}; escalation={2}" -f $Note, $ApprovalMode, $EscalationReason) | Out-Null

Write-Output ("Closed task: {0}" -f $TaskId)
Write-Output ("Status: {0}" -f $Status)
Write-Output ("Deliverable label: {0}" -f $DeliverableLabel)
Write-Output ("Approval mode: {0}" -f $ApprovalMode)
if ($wasEscalated) {
    Write-Output ("Escalation reason: {0}" -f $EscalationReason)
}

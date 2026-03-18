# Purpose: recommend whether the current task should continue, compact now, or hand off now.
[CmdletBinding()]
param(
    [ValidateRange(0, 100)]
    [int]$ContextPercent = 0,

    [string]$TaskId = "",

    [ValidateRange(0, 1000)]
    [int]$HandoffCount = 0,

    [ValidateRange(0, 1000)]
    [int]$ReviewCount = 0,

    [ValidateRange(0, 1000)]
    [int]$ProgressWithoutValidationCount = 0,

    [switch]$ReasoningWaste,

    [switch]$OutputJson
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$decision = "continue"
$reasons = New-Object System.Collections.Generic.List[string]

if ($ContextPercent -ge 91) {
    $decision = "handoff-now"
    $reasons.Add("context-critical")
} elseif ($ContextPercent -ge 81) {
    $decision = "compact-now"
    $reasons.Add("context-warning")
}

if ($HandoffCount -ge 2) {
    if ($decision -eq "continue") {
        $decision = "compact-now"
    }
    $reasons.Add("handoff-limit")
}

if ($ReviewCount -ge 2) {
    if ($decision -eq "continue") {
        $decision = "compact-now"
    }
    $reasons.Add("review-limit")
}

if ($ProgressWithoutValidationCount -ge 3) {
    if ($decision -eq "continue") {
        $decision = "compact-now"
    }
    $reasons.Add("progress-without-validation")
}

if ($ReasoningWaste.IsPresent) {
    if ($decision -eq "continue") {
        $decision = "compact-now"
    }
    $reasons.Add("reasoning-waste")
}

$result = [pscustomobject]@{
    TaskId = $TaskId
    ContextPercent = $ContextPercent
    Decision = $decision
    Reasons = @($reasons)
}

if ($OutputJson) {
    $result | ConvertTo-Json -Compress | Write-Output
} else {
    $result | Format-List | Out-String | Write-Output
}

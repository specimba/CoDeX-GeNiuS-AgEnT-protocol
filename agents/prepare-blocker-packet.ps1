# Purpose: emit a blocker packet when a slice should stop, narrow, or hand back cleanly.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$BlockedBy,

    [Parameter(Mandatory = $true)]
    [string]$WhyItBlocksProgress,

    [Parameter(Mandatory = $true)]
    [string]$WhatWasAlreadyTried,

    [Parameter(Mandatory = $true)]
    [string]$NarrowestUnblockNeeded,

    [Parameter(Mandatory = $true)]
    [string]$RecommendedOwner,

    [string]$EscalationReason = "",

    [switch]$ReasoningWaste,

    [string]$ReasoningWasteReason = "",

    [switch]$Clipboard
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if ($ReasoningWaste -and [string]::IsNullOrWhiteSpace($ReasoningWasteReason)) {
    throw "ReasoningWasteReason is required when -ReasoningWaste is used."
}

$packet = @"
Blocker packet
Blocked by: $BlockedBy
Why it blocks progress: $WhyItBlocksProgress
What was already tried: $WhatWasAlreadyTried
Narrowest unblock needed: $NarrowestUnblockNeeded
Recommended owner: $RecommendedOwner
Escalation reason: $EscalationReason
"@

if ($ReasoningWaste) {
    $packet += "`r`nReasoning-waste flag: yes"
    $packet += "`r`nReasoning-waste reason: $ReasoningWasteReason"
}

if ($Clipboard) {
    Set-Clipboard -Value $packet
    Write-Output "Copied blocker packet to clipboard."
}

Write-Output $packet

# Purpose: emit a standard completion packet with proof, risk, and next-owner fields.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TaskId,

    [Parameter(Mandatory = $true)]
    [string]$Outcome,

    [ValidateSet("Concept", "Prototype", "Verified", "Deferred")]
    [string]$DeliverableLabel = "Prototype",

    [string]$ChangedFiles = "[list changed files or state none]",

    [string]$Validation = "[state exact validation run or not run]",

    [ValidateSet("Director-autonomous", "Director-plus-QA", "CEO-confirm")]
    [string]$ApprovalMode = "Director-autonomous",

    [string]$EvidenceSource = "[state exact evidence source]",

    [string]$ResidualRisk = "[state residual risk or none]",

    [string]$KnownGaps = "[state known gaps or none]",

    [string]$NextOwnerOrStatus = "[state next owner or final status]",

    [ValidateSet("High", "Medium", "Low")]
    [string]$Confidence = "Medium",

    [switch]$ReasoningWaste,

    [string]$ReasoningWasteReason = "",

    [string]$ContractImpact = "",

    [string]$UserVisibleImpact = "",

    [string]$AcceptanceCriteria = "",

    [switch]$Clipboard
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

if ($ReasoningWaste -and [string]::IsNullOrWhiteSpace($ReasoningWasteReason)) {
    throw "ReasoningWasteReason is required when -ReasoningWaste is used."
}

$packet = @"
Completion packet
Task ID: $TaskId
Outcome: $Outcome
Deliverable label: $DeliverableLabel
Changed files: $ChangedFiles
Validation: $Validation
Approval mode: $ApprovalMode
Evidence source: $EvidenceSource
Residual risk: $ResidualRisk
Known gaps: $KnownGaps
Recommended next owner or final status: $NextOwnerOrStatus
Confidence: $Confidence
"@

if ($ReasoningWaste) {
    $packet += "`r`nReasoning-waste flag: yes"
    $packet += "`r`nReasoning-waste reason: $ReasoningWasteReason"
}

if (-not [string]::IsNullOrWhiteSpace($ContractImpact)) {
    $packet += "`r`nContract impact: $ContractImpact"
}

if (-not [string]::IsNullOrWhiteSpace($UserVisibleImpact)) {
    $packet += "`r`nUser-visible impact: $UserVisibleImpact"
}

if (-not [string]::IsNullOrWhiteSpace($AcceptanceCriteria)) {
    $packet += "`r`nAcceptance criteria: $AcceptanceCriteria"
}

$packet += @"

Instructions:
- Keep this packet factual and short
- Separate direct evidence from inference
- If validation was not run, say so directly
- If the deliverable label is Verified, the evidence source should justify it
"@

if ($Clipboard) {
    Set-Clipboard -Value $packet
    Write-Output "Copied completion packet to clipboard."
} else {
    Write-Output $packet
}

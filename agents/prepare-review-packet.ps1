# Purpose: emit a bounded review packet so secondary review stays cheap and focused.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TaskId,

    [Parameter(Mandatory = $true)]
    [string]$Reviewer,

    [Parameter(Mandatory = $true)]
    [string]$ScopeSummary,

    [ValidateSet("Concept", "Prototype", "Verified", "Deferred")]
    [string]$DeliverableLabel = "Prototype",

    [string]$ChangedFiles = "[list changed files]",

    [string]$Validation = "[list validation already run]",

    [ValidateSet("Director-autonomous", "Director-plus-QA", "CEO-confirm")]
    [string]$ApprovalMode = "Director-autonomous",

    [string]$EvidenceSource = "[state exact evidence source]",

    [string]$OpenRisks = "[list remaining risks]",

    [string]$KnownGaps = "[list known gaps or explicitly state none]",

    [switch]$Clipboard,

    [switch]$WriteFile
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$archiveDir = Join-Path $repoRoot "runs\review-packets"
$safeTaskId = ($TaskId -replace '[^a-zA-Z0-9\-_.]', '-')
$archivePath = Join-Path $archiveDir ("{0}-{1}.txt" -f $safeTaskId, (Get-Date -Format "yyyyMMddHHmmss"))

$fieldLimit = 180
$packetLimit = 1200

function Compress-Field {
    param(
        [string]$Label,
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return "[none]"
    }

    $trimmed = $Value.Trim()
    $singleLine = (($trimmed -split "(`r`n|`n|`r)") -join " | ").Trim()
    if ($singleLine.Length -le $fieldLimit) {
        return $singleLine
    }

    return ("See attached artifact or repo file for {0}; summary truncated to stay bounded." -f $Label.ToLowerInvariant())
}

$scopeSummary = Compress-Field -Label "Scope summary" -Value $ScopeSummary
$changedFiles = Compress-Field -Label "Changed files" -Value $ChangedFiles
$validation = Compress-Field -Label "Validation" -Value $Validation
$evidenceSource = Compress-Field -Label "Evidence source" -Value $EvidenceSource
$openRisks = Compress-Field -Label "Open risks" -Value $OpenRisks
$knownGaps = Compress-Field -Label "Known gaps" -Value $KnownGaps

$packet = @"
Review packet
Task ID: $TaskId
Reviewer: $Reviewer
Scope summary: $ScopeSummary
Deliverable label: $DeliverableLabel
Changed files: $ChangedFiles
Validation already run: $Validation
Approval mode: $ApprovalMode
Evidence source: $EvidenceSource
Open risks: $OpenRisks
Known gaps: $KnownGaps

Instructions:
- Review only the scope above
- Do not rediscover unrelated context
- State findings first
- State whether the current evidence supports the claimed deliverable label
- Flag any mismatch between approval mode, evidence source, and validation depth
"@

if ($packet.Length -gt $packetLimit) {
    throw "Review packet exceeds bounded size. Reduce field content or point to repo files instead."
}

if ($WriteFile -or -not $Clipboard) {
    New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
    Set-Content -Path $archivePath -Value $packet -NoNewline
}

if ($Clipboard) {
    Set-Clipboard -Value $packet
    Write-Output "Copied review packet to clipboard."
}

Write-Output $packet

if (Test-Path $archivePath) {
    Write-Output ""
    Write-Output ("Archived review packet: {0}" -f $archivePath)
}

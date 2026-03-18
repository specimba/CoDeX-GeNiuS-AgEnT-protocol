# Purpose: create a small, reviewable validation bundle for one task or run.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TaskId,

    [Parameter(Mandatory = $true)]
    [string]$Summary,

    [string]$ValidationProfile = "strict",

    [string]$Url = "",

    [string]$Action = "",

    [string]$EvidenceSource = "",

    [string]$Artifacts = "",

    [string]$Notes = "",

    [switch]$Clipboard
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$artifactRoot = Join-Path $repoRoot "runs\validation-artifacts"
$safeTaskId = ($TaskId -replace '[^a-zA-Z0-9\-_.]', '-')
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$bundleDir = Join-Path $artifactRoot ("{0}-{1}" -f $safeTaskId, $timestamp)

New-Item -ItemType Directory -Path $bundleDir -Force | Out-Null

$metadata = [ordered]@{
    task_id = $TaskId
    timestamp = (Get-Date).ToString("o")
    validation_profile = $ValidationProfile
    summary = $Summary
    url = $Url
    action = $Action
    evidence_source = $EvidenceSource
    artifacts = @()
    notes = $Notes
}

if (-not [string]::IsNullOrWhiteSpace($Artifacts)) {
    $metadata.artifacts = @($Artifacts -split '\s*,\s*' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

$metadataPath = Join-Path $bundleDir "metadata.json"
$summaryPath = Join-Path $bundleDir "summary.txt"

$metadata | ConvertTo-Json -Depth 5 | Set-Content -Path $metadataPath

$summaryText = @"
Validation artifact bundle
Task ID: $TaskId
Validation profile: $ValidationProfile
Summary: $Summary
URL: $Url
Action: $Action
Evidence source: $EvidenceSource
Artifacts: $Artifacts
Notes: $Notes
"@

Set-Content -Path $summaryPath -Value $summaryText -NoNewline

if ($Clipboard) {
    Set-Clipboard -Value $summaryText
}

Write-Output $summaryText
Write-Output ""
Write-Output ("Artifact bundle: {0}" -f $bundleDir)
Write-Output ("Metadata file: {0}" -f $metadataPath)

# Purpose: load a named determinism profile for proof-oriented runs.
[CmdletBinding()]
param(
    [ValidateSet("strict", "ci", "explore")]
    [string]$Profile = "strict"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$profilePath = Join-Path $repoRoot ("profiles\{0}.json" -f $Profile)

if (-not (Test-Path $profilePath -PathType Leaf)) {
    throw "Missing determinism profile: $profilePath"
}

$content = Get-Content $profilePath -Raw
$profileObject = $content | ConvertFrom-Json

Write-Output ("Determinism profile: {0}" -f $profileObject.name)
Write-Output ("Profile path: {0}" -f $profilePath)
Write-Output $content

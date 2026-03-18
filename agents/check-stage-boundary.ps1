# Purpose: fail fast when staged changes include generated or runtime-only noise.
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = (Get-Location).Path
$badPrefixes = @(
    "dist\",
    "runs\",
    "temp_extract_aoa_v2\",
    "temp_extract_v1.0.1\",
    "temp_extract_v1.1.0\"
)

$badPatterns = @(
    "__pycache__",
    ".pyc"
)

$staged = @(git diff --cached --name-only)
if ($staged.Count -eq 0) {
    Write-Output "No staged files."
    exit 0
}

$violations = @()
foreach ($path in $staged) {
    foreach ($prefix in $badPrefixes) {
        if ($path.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            $violations += $path
            break
        }
    }

    foreach ($pattern in $badPatterns) {
        if ($path -like "*$pattern*") {
            $violations += $path
            break
        }
    }
}

$violations = @($violations | Select-Object -Unique)
if ($violations.Count -eq 0) {
    Write-Output "Stage boundary clean."
    exit 0
}

Write-Output "Stage boundary violations:"
$violations | ForEach-Object { Write-Output ("- {0}" -f $_) }
exit 1

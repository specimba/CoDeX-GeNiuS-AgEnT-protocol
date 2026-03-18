# Purpose: build a versioned pack archive with manifest and checksum for release hygiene.
[CmdletBinding()]
param(
    [string]$Version = "0.2.0"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$agentsPath = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
$repoRoot = (Resolve-Path (Join-Path $agentsPath "..")).Path
$distPath = Join-Path $repoRoot "dist"
$packageName = "manager-pack-$Version"
$stagingPath = Join-Path $distPath $packageName
$zipPath = Join-Path $distPath "$packageName.zip"
$manifestPath = Join-Path $distPath "manifest.json"
$shaPath = Join-Path $distPath "SHA256SUMS.txt"
$rootFiles = @(
    "AGENTS.md",
    "README.md",
    "THREAD_BOOTSTRAP.md",
    "WORKSTYLE.md",
    "SYSTEM_INDEX.md",
    "NEXT_THREAD.md",
    "START_NEW_CHAT.ps1"
)
$rootDirectories = @(
    "agents",
    "plans",
    "profiles",
    "golden"
)

if (-not (Test-Path $distPath)) {
    New-Item -ItemType Directory -Path $distPath | Out-Null
}

if (Test-Path $stagingPath) {
    Remove-Item $stagingPath -Recurse -Force
}

New-Item -ItemType Directory -Path $stagingPath | Out-Null

foreach ($relativePath in $rootFiles) {
    $sourcePath = Join-Path $repoRoot $relativePath
    if (-not (Test-Path $sourcePath -PathType Leaf)) {
        throw "Missing required release file: $sourcePath"
    }

    Copy-Item -Path $sourcePath -Destination (Join-Path $stagingPath $relativePath) -Force
}

foreach ($relativePath in $rootDirectories) {
    $sourcePath = Join-Path $repoRoot $relativePath
    if (-not (Test-Path $sourcePath -PathType Container)) {
        throw "Missing required release directory: $sourcePath"
    }

    Copy-Item -Path $sourcePath -Destination (Join-Path $stagingPath $relativePath) -Recurse -Force
}

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Compress-Archive -Path (Join-Path $stagingPath "*") -DestinationPath $zipPath -Force
$hash = (Get-FileHash -Algorithm SHA256 $zipPath).Hash.ToLowerInvariant()

Remove-Item $stagingPath -Recurse -Force

$manifest = [ordered]@{
    name = "manager-pack"
    version = $Version
    generated_at = (Get-Date).ToString("o")
    archive = [System.IO.Path]::GetFileName($zipPath)
    sha256 = $hash
}
$manifest | ConvertTo-Json | Set-Content -Path $manifestPath
("{0}  {1}" -f $hash, [System.IO.Path]::GetFileName($zipPath)) | Set-Content -Path $shaPath

Write-Output ("Packaged: {0}" -f $zipPath)
Write-Output ("Manifest: {0}" -f $manifestPath)
Write-Output ("SHA256: {0}" -f $hash)

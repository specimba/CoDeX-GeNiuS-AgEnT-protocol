# Purpose: provide the default task-scoped restart command before broad system rehydration.
[CmdletBinding()]
param(
    [string]$NextSlice = "richer completion packet helper"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$scriptPath = Join-Path $PSScriptRoot "agents\new-thread-handoff.ps1"

if (-not (Test-Path $scriptPath -PathType Leaf)) {
    throw "Missing handoff helper: $scriptPath"
}

powershell -ExecutionPolicy Bypass -File $scriptPath -NextSlice $NextSlice -Clipboard -WriteFile

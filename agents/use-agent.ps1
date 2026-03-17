[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("director", "manager", "backend", "frontend", "designer", "qa", "system")]
    [string]$Role,

    [string]$Task,

    [switch]$Clipboard
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$agentsPath = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
$normalizedRole = if ($Role -eq "manager") { "director" } else { $Role }
$sharedDocs = @(
    "README.md",
    "agent-routing.md",
    "control-system-rules.md",
    "sync-protocol.md",
    "team-pipeline.md"
) | ForEach-Object { Join-Path $agentsPath $_ }

$config = @{
    director = @{
        title = "Director (MANAGER)"
        file  = "director.agent.md"
        mode  = "single"
    }
    backend = @{
        title = "Backend Engineer"
        file  = "backend-engineer.agent.md"
        mode  = "single"
    }
    frontend = @{
        title = "Frontend Engineer"
        file  = "frontend-engineer.agent.md"
        mode  = "single"
    }
    designer = @{
        title = "UI/UX Designer"
        file  = "ui-ux-designer.agent.md"
        mode  = "single"
    }
    qa = @{
        title = "QA Engineer"
        file  = "qa-engineer.agent.md"
        mode  = "single"
    }
    system = @{
        title = "Director (MANAGER)"
        file  = "director.agent.md"
        mode  = "system"
    }
}

$selected = $config[$normalizedRole]
$agentFile = Join-Path $agentsPath $selected.file
$taskBlock = if ([string]::IsNullOrWhiteSpace($Task)) { "[your task]" } else { $Task.Trim() }

if (-not (Test-Path $agentFile -PathType Leaf)) {
    throw "Missing agent file: $agentFile"
}

$missingSharedDocs = @($sharedDocs | Where-Object { -not (Test-Path $_ -PathType Leaf) })
if ($missingSharedDocs.Count -gt 0) {
    throw ("Missing shared docs:`n{0}" -f ($missingSharedDocs -join "`n"))
}

if ($selected.mode -eq "system") {
    $teamPipeline = Join-Path $agentsPath "team-pipeline.md"
    $prompt = @"
Use my multi-agent pack in $agentsPath.
Director (MANAGER) should triage first, then delegate as needed.
Follow $agentFile and the shared docs in $agentsPath.
Use $teamPipeline for the role map and connection pipeline.

Task:
$taskBlock
"@
} else {
    $prompt = @"
Act as $($selected.title). Follow $agentFile and the shared docs in $agentsPath.

Task:
$taskBlock
"@
}

if ($Clipboard) {
    Set-Clipboard -Value $prompt
    Write-Output ("Copied {0} prompt to clipboard." -f $selected.title)
} else {
    Write-Output $prompt
}

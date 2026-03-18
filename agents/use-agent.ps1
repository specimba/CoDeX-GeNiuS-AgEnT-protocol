# Purpose: generate the correct role prompt with shared pack context for a chosen agent.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("director", "manager", "backend", "frontend", "designer", "qa", "system")]
    [string]$Role,

    [string]$Task,

    [ValidateSet("assess", "plan", "execute", "validate", "integrate", "research", "document")]
    [string]$StepType = "execute",

    [switch]$Clipboard
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$agentsPath = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
$normalizedRole = if ($Role -eq "manager") { "director" } else { $Role }
$runtimeCharter = Join-Path $agentsPath "runtime-charter.md"

$config = @{
    director = @{
        title = "Director (MANAGER)"
        file  = "director.agent.md"
        mode  = "single"
        baseDocs = @("agent-routing.md", "sync-protocol.md", "triage-and-proof.md")
    }
    backend = @{
        title = "Backend Engineer"
        file  = "backend-engineer.agent.md"
        mode  = "single"
        baseDocs = @("sync-protocol.md")
    }
    frontend = @{
        title = "Frontend Engineer"
        file  = "frontend-engineer.agent.md"
        mode  = "single"
        baseDocs = @("sync-protocol.md")
    }
    designer = @{
        title = "UI/UX Designer"
        file  = "ui-ux-designer.agent.md"
        mode  = "single"
        baseDocs = @("sync-protocol.md")
    }
    qa = @{
        title = "QA Engineer"
        file  = "qa-engineer.agent.md"
        mode  = "single"
        baseDocs = @("sync-protocol.md", "triage-and-proof.md", "artifact-first-validation.md")
    }
    system = @{
        title = "Director (MANAGER)"
        file  = "director.agent.md"
        mode  = "system"
        baseDocs = @("agent-routing.md", "sync-protocol.md", "triage-and-proof.md", "team-pipeline.md")
    }
}

$selected = $config[$normalizedRole]
$agentFile = Join-Path $agentsPath $selected.file
$taskBlock = if ([string]::IsNullOrWhiteSpace($Task)) { "[your task]" } else { $Task.Trim() }

if (-not (Test-Path $agentFile -PathType Leaf)) {
    throw "Missing agent file: $agentFile"
}

if (-not (Test-Path $runtimeCharter -PathType Leaf)) {
    throw "Missing runtime charter: $runtimeCharter"
}

$stepDocs = switch ($StepType) {
    "assess" { @("triage-and-proof.md", "agent-routing.md") }
    "plan" { @("agent-routing.md", "sync-protocol.md") }
    "execute" { @("sync-protocol.md") }
    "validate" { @("sync-protocol.md", "artifact-first-validation.md", "triage-and-proof.md") }
    "integrate" { @("sync-protocol.md", "team-pipeline.md") }
    "research" { @("triage-and-proof.md") }
    "document" { @("sync-protocol.md") }
}

$docRefs = @($selected.baseDocs + $stepDocs | Select-Object -Unique)
$resolvedDocs = @($docRefs | ForEach-Object { Join-Path $agentsPath $_ })
$missingDocs = @($resolvedDocs | Where-Object { -not (Test-Path $_ -PathType Leaf) })
if ($missingDocs.Count -gt 0) {
    throw ("Missing runtime docs:`n{0}" -f ($missingDocs -join "`n"))
}

if ($selected.mode -eq "system") {
    $routingDoc = Join-Path $agentsPath "agent-routing.md"
    $syncDoc = Join-Path $agentsPath "sync-protocol.md"
    $proofDoc = Join-Path $agentsPath "triage-and-proof.md"
    $prompt = @"
Use my multi-agent pack in $agentsPath.
Start with $runtimeCharter and $agentFile.
Director (MANAGER) should triage first, then delegate as needed.
Use $routingDoc for owner selection, $syncDoc for packets, and $proofDoc for proof depth.
Step type: $StepType

Task:
$taskBlock
"@
} else {
    $docList = $resolvedDocs -join ", "
    $prompt = @"
Act as $($selected.title).
Start with $runtimeCharter and $agentFile.
Use only these additional docs for this slice: $docList
Step type: $StepType

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

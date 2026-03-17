param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("director", "backend", "frontend", "designer", "qa", "system")]
    [string]$Role,

    [string]$Task,

    [switch]$Clipboard
)

$agentsPath = Split-Path -Parent $MyInvocation.MyCommand.Path

$config = @{
    director = @{
        title = "Director"
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
        title = "Director"
        file  = "director.agent.md"
        mode  = "system"
    }
}

$selected = $config[$Role]
$agentFile = Join-Path $agentsPath $selected.file
$taskBlock = if ([string]::IsNullOrWhiteSpace($Task)) { "[your task]" } else { $Task.Trim() }

if ($selected.mode -eq "system") {
    $prompt = @"
Use my multi-agent pack in $agentsPath.
Director should triage first, then delegate as needed.
Follow $agentFile and the shared docs in $agentsPath.

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
    Write-Output "Copied $Role prompt to clipboard."
} else {
    Write-Output $prompt
}

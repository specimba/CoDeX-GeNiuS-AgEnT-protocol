[CmdletBinding()]
param(
    [switch]$StopOnFailure,
    [switch]$ShowPrompts
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$agentsPath = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
$launcherPath = Join-Path $agentsPath "use-agent.ps1"

if (-not (Test-Path $launcherPath -PathType Leaf)) {
    throw "Missing launcher: $launcherPath"
}

$requiredFiles = @(
    "director.agent.md",
    "backend-engineer.agent.md",
    "frontend-engineer.agent.md",
    "ui-ux-designer.agent.md",
    "qa-engineer.agent.md",
    "team-pipeline.md",
    "agent-routing.md",
    "control-system-rules.md",
    "sync-protocol.md",
    "background-agents-ui.md"
) | ForEach-Object { Join-Path $agentsPath $_ }

$missingFiles = @($requiredFiles | Where-Object { -not (Test-Path $_) })
if ($missingFiles.Count -gt 0) {
    throw ("Missing required files:`n{0}" -f ($missingFiles -join "`n"))
}

$cases = @(
    @{
        Name = "Director feature intake"
        Role = "director"
        Task = "Triage a feature spanning design, backend, frontend, and QA."
        Expected = @("Act as Director (MANAGER).", "director.agent.md", "Task:")
    },
    @{
        Name = "Manager alias drift reset"
        Role = "manager"
        Task = "Reset ownership after routing drift on a cross-functional bug."
        Expected = @("Act as Director (MANAGER).", "director.agent.md", "routing")
    },
    @{
        Name = "Backend contract pass"
        Role = "backend"
        Task = "Define the session persistence contract for story playback."
        Expected = @("Act as Backend Engineer.", "backend-engineer.agent.md", "session persistence")
    },
    @{
        Name = "Backend failure-path pass"
        Role = "backend"
        Task = "Trace the fallback behavior for music lookup timeouts."
        Expected = @("Act as Backend Engineer.", "backend-engineer.agent.md", "music lookup")
    },
    @{
        Name = "Frontend beat flow"
        Role = "frontend"
        Task = "Implement the beat timeline loading and empty states."
        Expected = @("Act as Frontend Engineer.", "frontend-engineer.agent.md", "beat timeline")
    },
    @{
        Name = "Frontend playback review"
        Role = "frontend"
        Task = "Wire the playback review panel to guardrail warnings."
        Expected = @("Act as Frontend Engineer.", "frontend-engineer.agent.md", "guardrail warnings")
    },
    @{
        Name = "Designer onboarding"
        Role = "designer"
        Task = "Design the first-run intent selection experience."
        Expected = @("Act as UI/UX Designer.", "ui-ux-designer.agent.md", "intent selection")
    },
    @{
        Name = "Designer pairing flow"
        Role = "designer"
        Task = "Define interaction states for track pairing conflicts."
        Expected = @("Act as UI/UX Designer.", "ui-ux-designer.agent.md", "track pairing")
    },
    @{
        Name = "QA persistence regression"
        Role = "qa"
        Task = "Validate session persistence and replay recovery."
        Expected = @("Act as QA Engineer.", "qa-engineer.agent.md", "session persistence")
    },
    @{
        Name = "QA fallback regression"
        Role = "qa"
        Task = "Run a focused check on pairing fallback and timeout messaging."
        Expected = @("Act as QA Engineer.", "qa-engineer.agent.md", "timeout messaging")
    },
    @{
        Name = "System workflow feature"
        Role = "system"
        Task = "Deliver a feature through Director, design, backend, frontend, and QA."
        Expected = @("Use my multi-agent pack", "Director (MANAGER) should triage first", "Task:")
    },
    @{
        Name = "System workflow bug"
        Role = "system"
        Task = "Investigate a cross-functional playback regression and route the first owner."
        Expected = @("Use my multi-agent pack", "Director (MANAGER) should triage first", "Task:")
    }
)

$results = @()

foreach ($case in $cases) {
    $startedAt = Get-Date
    try {
        $output = & $launcherPath -Role $case.Role -Task $case.Task | Out-String
    } catch {
        throw ("Fatal launcher failure in '{0}': {1}" -f $case.Name, $_.Exception.Message)
    }

    $missing = @()

    foreach ($expectedText in $case.Expected) {
        if ($output -notlike "*$expectedText*") {
            $missing += $expectedText
        }
    }

    if ($ShowPrompts) {
        Write-Host ("----- {0} -----" -f $case.Name)
        Write-Host $output
    }

    $results += [pscustomobject]@{
        Name = $case.Name
        Role = $case.Role
        Passed = ($missing.Count -eq 0)
        Missing = if ($missing.Count -eq 0) { "" } else { $missing -join "; " }
        DurationMs = [int]((Get-Date) - $startedAt).TotalMilliseconds
    }

    if ($missing.Count -gt 0 -and $StopOnFailure) {
        throw ("Smoke test failed fast:`n{0}: {1}" -f $case.Name, ($missing -join "; "))
    }
}

$failed = @($results | Where-Object { -not $_.Passed })

Write-Host ""
Write-Host "Smoke test summary"
$results | Format-Table -AutoSize | Out-String | Write-Host

if ($failed.Count -gt 0) {
    throw ("Smoke tests failed:`n{0}" -f (($failed | ForEach-Object { "{0}: {1}" -f $_.Name, $_.Missing }) -join "`n"))
}

Write-Host "All smoke tests passed."

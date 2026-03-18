# Purpose: start a Director-managed task with triage, ledger intake, and role/model guidance.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Task,

    [string]$TaskId,

    [ValidateSet("assess", "plan", "execute", "validate", "integrate", "research", "document")]
    [string]$StepType = "execute",

    [ValidateSet("Concept", "Prototype", "Verified", "Deferred")]
    [string]$DeliverableLabel = "Prototype",

    [string]$EscalationReason = "",

    [switch]$Clipboard
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$agentsPath = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
$launcherPath = Join-Path $agentsPath "use-agent.ps1"
$ledgerPath = Join-Path $agentsPath "task-ledger.ps1"
$triagePath = Join-Path $agentsPath "triage-task.ps1"
$contextBudgetPath = Join-Path $agentsPath "context-budget.md"
$taskValue = $Task.Trim()

if ([string]::IsNullOrWhiteSpace($taskValue)) {
    throw "Task cannot be empty."
}

if (-not (Test-Path $launcherPath -PathType Leaf)) {
    throw "Missing launcher: $launcherPath"
}

if (-not (Test-Path $ledgerPath -PathType Leaf)) {
    throw "Missing task ledger: $ledgerPath"
}

if (-not (Test-Path $triagePath -PathType Leaf)) {
    throw "Missing triage script: $triagePath"
}

if (-not (Test-Path $contextBudgetPath -PathType Leaf)) {
    throw "Missing context budget policy: $contextBudgetPath"
}

if ([string]::IsNullOrWhiteSpace($TaskId)) {
    $slug = $taskValue.ToLowerInvariant() -replace '[^a-z0-9]+', '-' -replace '(^-+|-+$)', ''
    if ([string]::IsNullOrWhiteSpace($slug)) {
        $slug = "managed-task"
    }
    if ($slug.Length -gt 40) {
        $slug = $slug.Substring(0, 40).TrimEnd('-')
    }
    $TaskId = "{0}-{1}" -f $slug, (Get-Date -Format "yyyyMMddHHmmss")
}

$triage = & $triagePath -Task $taskValue | ConvertFrom-Json
$attemptCount = [int](& $ledgerPath next-attempt -TaskSummaryId $TaskId)

$recommendedModel = [string]$triage.RecommendedModel
$recommendedReasoning = [string]$triage.RecommendedReasoning

switch ($StepType) {
    "assess" {
        $recommendedModel = "gpt-5.1-codex-mini"
        $recommendedReasoning = "low"
    }
    "plan" {
        if ($triage.ChangeClass -eq "Class 2" -or $triage.ChangeClass -eq "Class 3") {
            $recommendedModel = "gpt-5.1-codex-max"
            $recommendedReasoning = "medium"
        } else {
            $recommendedModel = "gpt-5.1-codex-mini"
            $recommendedReasoning = "low"
        }
    }
    "research" {
        $recommendedModel = "gpt-5.1-codex-mini"
        $recommendedReasoning = "low"
    }
    "document" {
        $recommendedModel = "gpt-5.1-codex-mini"
        $recommendedReasoning = "low"
    }
    "validate" {
        if ($triage.ValidationNeed -eq "runtime" -or $triage.ValidationNeed -eq "user-visible") {
            $recommendedModel = "gpt-5.1-codex-max"
            $recommendedReasoning = "medium"
        } else {
            $recommendedModel = "gpt-5.1-codex-mini"
            $recommendedReasoning = "low"
        }
    }
}

$defaultRoleModel = "gpt-5.1-codex-mini"
$defaultRoleReasoning = "low"
$wasEscalated = ($recommendedModel -ne $defaultRoleModel) -or ($recommendedReasoning -ne $defaultRoleReasoning)

if ($wasEscalated -and [string]::IsNullOrWhiteSpace($EscalationReason)) {
    throw "EscalationReason is required when the recommended model or reasoning is above the role default."
}

if (-not $wasEscalated) {
    $EscalationReason = ""
}

$directorTask = @"
Triage: Intent=$($triage.Intent); SurfaceCount=$($triage.SurfaceCount); RiskClass=$($triage.RiskClass); ValidationNeed=$($triage.ValidationNeed)
Recommended first owner: $($triage.PrimaryOwner)
Change class: $($triage.ChangeClass)
Approval mode: $($triage.ApprovalMode)
Step type: $StepType
Initial deliverable label target: $DeliverableLabel

Mission:
$taskValue
"@

if ($wasEscalated) {
    $directorTask = $directorTask -replace [regex]::Escape("Initial deliverable label target:"), ("Escalation reason: {0}`r`nInitial deliverable label target:" -f $EscalationReason)
}

& $ledgerPath append -TaskId $TaskId -Owner "Director (MANAGER)" -Event "intake" -Status "active" -AttemptCount $attemptCount -DeliverableLabel $DeliverableLabel -Note ("Managed task started; owner={0}; approval={1}; escalation={2}" -f $triage.PrimaryOwner, $triage.ApprovalMode, $EscalationReason) | Out-Null

if ($Clipboard) {
    & $launcherPath -Role system -Task $directorTask -StepType $StepType -Clipboard | Out-Null
} else {
    & $launcherPath -Role system -Task $directorTask -StepType $StepType
}

Write-Output ""
Write-Output ("Task ledger id: {0}" -f $TaskId)
Write-Output ("Step type: {0}" -f $StepType)
Write-Output ("Attempt count: {0}" -f $attemptCount)
Write-Output ("Suggested first owner: {0}" -f $triage.PrimaryOwner)
Write-Output ("Approval mode: {0}" -f $triage.ApprovalMode)
Write-Output ("Recommended model: {0}" -f $recommendedModel)
Write-Output ("Recommended reasoning: {0}" -f $recommendedReasoning)
if ($wasEscalated) {
    Write-Output ("Escalation reason: {0}" -f $EscalationReason)
}
Write-Output ("Ledger file: {0}" -f (Join-Path (Resolve-Path (Join-Path $agentsPath "..")).Path "runs\agent-ledger\task-events.jsonl"))

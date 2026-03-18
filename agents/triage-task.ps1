# Purpose: classify task shape and recommend owner, approval mode, worktree mode, model, and reasoning.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Task
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$taskText = $Task.Trim()
if ([string]::IsNullOrWhiteSpace($taskText)) {
    throw "Task cannot be empty."
}

$lower = $taskText.ToLowerInvariant()

function Test-Any {
    param(
        [string]$Text,
        [string[]]$Terms
    )

    foreach ($term in $Terms) {
        if ($Text.Contains($term)) {
            return $true
        }
    }
    return $false
}

function Get-MatchCount {
    param(
        [string]$Text,
        [string[]]$Terms
    )

    $count = 0
    foreach ($term in $Terms) {
        if ($Text.Contains($term)) {
            $count++
        }
    }
    return $count
}

$intent = "edit"
if (Test-Any -Text $lower -Terms @("review", "audit", "assess", "inspect")) {
    $intent = "review"
} elseif (Test-Any -Text $lower -Terms @("research", "compare", "deep search", "deepsearch")) {
    $intent = "research"
} elseif (Test-Any -Text $lower -Terms @("deploy", "publish", "release", "ship live")) {
    $intent = "deploy"
} elseif (Test-Any -Text $lower -Terms @("explain", "teach", "brainstorm", "summarize")) {
    $intent = "explain"
}

$surfaceCount = "one-module"
if (Test-Any -Text $lower -Terms @("cross-functional", "backend and frontend", "design and backend", "full stack", "full-stack", "multi-agent", "pipeline")) {
    $surfaceCount = "multi-module"
} elseif (Test-Any -Text $lower -Terms @("repo", "repository", "repositories", "multi-repo")) {
    $surfaceCount = "multi-repo"
} elseif (Test-Any -Text $lower -Terms @("one file", "single file")) {
    $surfaceCount = "one-file"
}

$riskClass = "medium"
if (Test-Any -Text $lower -Terms @("auth", "payment", "security", "migration", "delete", "destructive", "recovery", "concurrency", "production")) {
    $riskClass = "high"
} elseif (Test-Any -Text $lower -Terms @("docs", "prompt", "copy", "rename", "readme", "report")) {
    $riskClass = "low"
}

$validationNeed = "static"
if (Test-Any -Text $lower -Terms @("ui", "ux", "screen", "flow", "user-visible", "playback", "frontend")) {
    $validationNeed = "user-visible"
} elseif (Test-Any -Text $lower -Terms @("runtime", "integration", "api", "endpoint", "server", "deploy")) {
    $validationNeed = "runtime"
} elseif (Test-Any -Text $lower -Terms @("explain", "review", "research", "brainstorm", "report")) {
    $validationNeed = "none"
}

$backendTerms = @("api", "backend", "database", "schema", "server", "auth", "queue", "storage", "endpoint", "migration", "persistence")
$frontendTerms = @("ui", "frontend", "browser", "component", "screen", "form", "accessibility", "render", "client", "layout")
$designTerms = @("ux", "design", "flow", "layout", "interaction", "wireframe", "hierarchy", "copy", "journey")
$qaTerms = @("test", "qa", "regression", "reproduce", "validation", "verify", "smoke", "release confidence", "bug report")

$backendScore = Get-MatchCount -Text $lower -Terms $backendTerms
$frontendScore = Get-MatchCount -Text $lower -Terms $frontendTerms
$designScore = Get-MatchCount -Text $lower -Terms $designTerms
$qaScore = Get-MatchCount -Text $lower -Terms $qaTerms

$changeClass = "Class 1"
if ($riskClass -eq "high") {
    $changeClass = "Class 3"
} elseif ($surfaceCount -eq "multi-module" -or $validationNeed -eq "user-visible" -or $validationNeed -eq "runtime") {
    $changeClass = "Class 2"
} elseif ($surfaceCount -eq "one-file" -and $riskClass -eq "low") {
    $changeClass = "Class 0"
}

$primaryOwner = "Director (MANAGER)"
$maxScore = ($backendScore, $frontendScore, $designScore, $qaScore | Measure-Object -Maximum).Maximum
$scoredOwners = @()
if ($backendScore -eq $maxScore -and $backendScore -gt 0) { $scoredOwners += "Backend Engineer" }
if ($frontendScore -eq $maxScore -and $frontendScore -gt 0) { $scoredOwners += "Frontend Engineer" }
if ($designScore -eq $maxScore -and $designScore -gt 0) { $scoredOwners += "UI/UX Designer" }
if ($qaScore -eq $maxScore -and $qaScore -gt 0) { $scoredOwners += "QA Engineer" }

$isCrossFunctional = $surfaceCount -eq "multi-module" -or $surfaceCount -eq "multi-repo" -or $scoredOwners.Count -gt 1
$hasDominantSpecialist = $scoredOwners.Count -eq 1 -and $maxScore -gt 0

if ($hasDominantSpecialist -and ((-not $isCrossFunctional) -or $changeClass -ne "Class 3")) {
    $primaryOwner = $scoredOwners[0]
}

$approvalMode = "Director-autonomous"
$spendSensitive = Test-Any -Text $lower -Terms @("purchase", "billing", "pay", "external spend", "token cost")
if ($changeClass -eq "Class 3" -or $spendSensitive) {
    $approvalMode = "CEO-confirm"
} elseif ($changeClass -eq "Class 2") {
    $approvalMode = "Director-plus-QA"
}

$worktreeMode = "no"
if ($surfaceCount -eq "multi-module" -or $surfaceCount -eq "multi-repo" -or $riskClass -eq "high") {
    $worktreeMode = "consider"
}

$recommendedModel = "gpt-5.1-codex-mini"
$recommendedReasoning = "low"
if ($riskClass -eq "high" -or $surfaceCount -eq "multi-repo") {
    $recommendedModel = "gpt-5.3-codex"
    $recommendedReasoning = "high"
} elseif ($changeClass -eq "Class 2" -or $validationNeed -eq "runtime") {
    $recommendedModel = "gpt-5.1-codex-max"
    $recommendedReasoning = "medium"
}

[pscustomobject]@{
    Intent = $intent
    SurfaceCount = $surfaceCount
    RiskClass = $riskClass
    ValidationNeed = $validationNeed
    PrimaryOwner = $primaryOwner
    ChangeClass = $changeClass
    ApprovalMode = $approvalMode
    WorktreeMode = $worktreeMode
    RecommendedModel = $recommendedModel
    RecommendedReasoning = $recommendedReasoning
    BackendScore = $backendScore
    FrontendScore = $frontendScore
    DesignScore = $designScore
    QAScore = $qaScore
} | ConvertTo-Json -Compress

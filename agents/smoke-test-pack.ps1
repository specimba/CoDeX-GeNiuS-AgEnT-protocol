# Purpose: verify prompt generation, helper scripts, and pack workflow contracts still hold.
[CmdletBinding()]
param(
    [switch]$StopOnFailure,
    [switch]$ShowPrompts
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$agentsPath = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
$launcherPath = Join-Path $agentsPath "use-agent.ps1"
$ledgerPath = Join-Path $agentsPath "task-ledger.ps1"
$managedStartPath = Join-Path $agentsPath "start-managed-task.ps1"
$managedClosePath = Join-Path $agentsPath "close-managed-task.ps1"
$triagePath = Join-Path $agentsPath "triage-task.ps1"
$reviewPacketPath = Join-Path $agentsPath "prepare-review-packet.ps1"
$completionPacketPath = Join-Path $agentsPath "prepare-completion-packet.ps1"
$blockerPacketPath = Join-Path $agentsPath "prepare-blocker-packet.ps1"
$validationArtifactPath = Join-Path $agentsPath "prepare-validation-artifact.ps1"
$determinismProfilePath = Join-Path $agentsPath "load-determinism-profile.ps1"
$packagePath = Join-Path $agentsPath "package-pack.ps1"
$stageBoundaryPath = Join-Path $agentsPath "check-stage-boundary.ps1"
$compactPath = Join-Path $agentsPath "should-compact.ps1"
$runtimeCharterPath = Join-Path $agentsPath "runtime-charter.md"
$startupPromptsPath = Join-Path $agentsPath "startup-prompts.md"
$threadBootstrapPath = Join-Path (Resolve-Path (Join-Path $agentsPath "..")).Path "THREAD_BOOTSTRAP.md"
$goldenSeedPath = Join-Path (Resolve-Path (Join-Path $agentsPath "..")).Path "golden\golden-run-seed.json"

if (-not (Test-Path $launcherPath -PathType Leaf)) {
    throw "Missing launcher: $launcherPath"
}

if (-not (Test-Path $ledgerPath -PathType Leaf)) {
    throw "Missing task ledger: $ledgerPath"
}

if (-not (Test-Path $managedStartPath -PathType Leaf)) {
    throw "Missing managed start script: $managedStartPath"
}

if (-not (Test-Path $managedClosePath -PathType Leaf)) {
    throw "Missing managed close script: $managedClosePath"
}

if (-not (Test-Path $triagePath -PathType Leaf)) {
    throw "Missing triage script: $triagePath"
}

if (-not (Test-Path $reviewPacketPath -PathType Leaf)) {
    throw "Missing review packet script: $reviewPacketPath"
}

if (-not (Test-Path $completionPacketPath -PathType Leaf)) {
    throw "Missing completion packet script: $completionPacketPath"
}

if (-not (Test-Path $blockerPacketPath -PathType Leaf)) {
    throw "Missing blocker packet script: $blockerPacketPath"
}

if (-not (Test-Path $validationArtifactPath -PathType Leaf)) {
    throw "Missing validation artifact script: $validationArtifactPath"
}

if (-not (Test-Path $determinismProfilePath -PathType Leaf)) {
    throw "Missing determinism profile script: $determinismProfilePath"
}

if (-not (Test-Path $packagePath -PathType Leaf)) {
    throw "Missing packaging script: $packagePath"
}

if (-not (Test-Path $stageBoundaryPath -PathType Leaf)) {
    throw "Missing stage-boundary script: $stageBoundaryPath"
}

if (-not (Test-Path $compactPath -PathType Leaf)) {
    throw "Missing compact helper: $compactPath"
}

if (-not (Test-Path $runtimeCharterPath -PathType Leaf)) {
    throw "Missing runtime charter: $runtimeCharterPath"
}

if (-not (Test-Path $startupPromptsPath -PathType Leaf)) {
    throw "Missing startup prompts: $startupPromptsPath"
}

if (-not (Test-Path $threadBootstrapPath -PathType Leaf)) {
    throw "Missing thread bootstrap: $threadBootstrapPath"
}

if (-not (Test-Path $goldenSeedPath -PathType Leaf)) {
    throw "Missing golden dataset seed: $goldenSeedPath"
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
    "triage-and-proof.md",
    "task-ledger.md",
    "permission-and-autonomy.md",
    "bounded-review.md",
    "release-packaging.md",
    "role-model-policy.md",
    "spawn-control.md",
    "context-budget.md",
    "runtime-charter.md",
    "startup-prompts.md",
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
        Expected = @("Act as Director (MANAGER).", "runtime-charter.md", "director.agent.md", "Step type: execute", "Task:")
    },
    @{
        Name = "Manager alias drift reset"
        Role = "manager"
        Task = "Reset ownership after routing drift on a cross-functional bug."
        Expected = @("Act as Director (MANAGER).", "runtime-charter.md", "director.agent.md")
    },
    @{
        Name = "Backend contract pass"
        Role = "backend"
        Task = "Define the session persistence contract for story playback."
        Expected = @("Act as Backend Engineer.", "runtime-charter.md", "backend-engineer.agent.md", "session persistence")
    },
    @{
        Name = "Backend failure-path pass"
        Role = "backend"
        Task = "Trace the fallback behavior for music lookup timeouts."
        Expected = @("Act as Backend Engineer.", "runtime-charter.md", "backend-engineer.agent.md", "music lookup")
    },
    @{
        Name = "Frontend beat flow"
        Role = "frontend"
        Task = "Implement the beat timeline loading and empty states."
        Expected = @("Act as Frontend Engineer.", "runtime-charter.md", "frontend-engineer.agent.md", "beat timeline")
    },
    @{
        Name = "Frontend playback review"
        Role = "frontend"
        Task = "Wire the playback review panel to guardrail warnings."
        Expected = @("Act as Frontend Engineer.", "runtime-charter.md", "frontend-engineer.agent.md", "guardrail warnings")
    },
    @{
        Name = "Designer onboarding"
        Role = "designer"
        Task = "Design the first-run intent selection experience."
        Expected = @("Act as UI/UX Designer.", "runtime-charter.md", "ui-ux-designer.agent.md", "intent selection")
    },
    @{
        Name = "Designer pairing flow"
        Role = "designer"
        Task = "Define interaction states for track pairing conflicts."
        Expected = @("Act as UI/UX Designer.", "runtime-charter.md", "ui-ux-designer.agent.md", "track pairing")
    },
    @{
        Name = "QA persistence regression"
        Role = "qa"
        Task = "Validate session persistence and replay recovery."
        Expected = @("Act as QA Engineer.", "runtime-charter.md", "qa-engineer.agent.md", "session persistence")
    },
    @{
        Name = "QA fallback regression"
        Role = "qa"
        Task = "Run a focused check on pairing fallback and timeout messaging."
        Expected = @("Act as QA Engineer.", "runtime-charter.md", "qa-engineer.agent.md", "timeout messaging")
    },
    @{
        Name = "System workflow feature"
        Role = "system"
        Task = "Deliver a feature through Director, design, backend, frontend, and QA."
        Expected = @("Use my multi-agent pack", "runtime-charter.md", "Director (MANAGER) should triage first", "Step type: execute", "Task:")
    },
    @{
        Name = "System workflow bug"
        Role = "system"
        Task = "Investigate a cross-functional playback regression and route the first owner."
        Expected = @("Use my multi-agent pack", "runtime-charter.md", "Director (MANAGER) should triage first", "Task:")
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

& $ledgerPath reset | Out-Null
& $ledgerPath append -TaskId "smoke-ledger-001" -Owner "Director (MANAGER)" -Event "intake" -Status "active" -AttemptCount 1 -Note "smoke" | Out-Null
& $ledgerPath append -TaskId "smoke-ledger-001" -Owner "QA Engineer" -Event "completion" -Status "validated" -AttemptCount 1 -DeliverableLabel "Verified" -Note "smoke" | Out-Null
$ledgerSummary = & $ledgerPath summary | Out-String
$ledgerTaskSummary = & $ledgerPath task-summary -TaskSummaryId "smoke-ledger-001" | Out-String
$nextAttempt = & $ledgerPath next-attempt -TaskSummaryId "smoke-ledger-001" | Out-String

if ($ledgerSummary -notlike "*smoke-ledger-001*" -or $ledgerSummary -notlike "*Verified*") {
    throw "Ledger smoke check failed."
}
if ($ledgerTaskSummary -notlike "*AttemptCount*" -or $ledgerTaskSummary -notlike "*LatestStatus*" -or $nextAttempt.Trim() -ne "2") {
    throw "Ledger summary smoke check failed."
}

$triageOutput = & $triagePath -Task "Investigate a cross-functional playback bug involving frontend and backend" | Out-String
if ($triageOutput -notlike "*Director (MANAGER)*" -or $triageOutput -notlike "*Director-plus-QA*" -or $triageOutput -notlike "*RecommendedModel*" -or $triageOutput -notlike "*RecommendedReasoning*") {
    throw "Triage smoke check failed."
}

$dominantOwnerTriage = & $triagePath -Task "Trace the backend API validation contract causing a frontend playback error" | ConvertFrom-Json
if ($dominantOwnerTriage.PrimaryOwner -ne "Backend Engineer" -or
    $dominantOwnerTriage.ChangeClass -ne "Class 2" -or
    $dominantOwnerTriage.ApprovalMode -ne "Director-plus-QA") {
    throw "Dominant owner triage smoke check failed."
}

$managedStartOutput = & $managedStartPath -Task "Document the operator prompt examples in the README" -StepType document | Out-String
if ($managedStartOutput -notlike "*runtime-charter.md*" -or
    $managedStartOutput -notlike "*Director (MANAGER) should triage first*" -or
    $managedStartOutput -notlike "*Triage: Intent=*" -or
    $managedStartOutput -notlike "*Step type:*" -or
    $managedStartOutput -notlike "*Attempt count:*" -or
    $managedStartOutput -notlike "*Task ledger id:*" -or
    $managedStartOutput -notlike "*Approval mode:*" -or
    $managedStartOutput -notlike "*Recommended model:*" -or
    $managedStartOutput -notlike "*Recommended reasoning:*") {
    throw "Managed start smoke check failed."
}
if ($managedStartOutput -like "*Escalation reason:*") {
    throw "Managed start printed an escalation reason for a default-tier task."
}

$managedEscalatedStartOutput = & $managedStartPath -Task "Validate a frontend playback flow with runtime checks" -EscalationReason "Runtime validation requires stronger review settings." | Out-String
if ($managedEscalatedStartOutput -notlike "*Escalation reason: Runtime validation requires stronger review settings.*") {
    throw "Escalated managed start smoke check failed."
}

$managedTaskIdMatch = [regex]::Match($managedStartOutput, 'Task ledger id:\s*(?<taskId>[a-z0-9\-]+)')
if (-not $managedTaskIdMatch.Success) {
    throw "Managed start did not return a parsable task id."
}
$managedTaskId = $managedTaskIdMatch.Groups["taskId"].Value
$managedCloseOutput = & $managedClosePath -TaskId $managedTaskId -Status closed -DeliverableLabel Verified -ApprovalMode Director-plus-QA -Note "smoke close" | Out-String
if ($managedCloseOutput -notlike "*Closed task:*" -or $managedCloseOutput -notlike "*Deliverable label: Verified*" -or $managedCloseOutput -notlike "*Approval mode: Director-plus-QA*") {
    throw "Managed close smoke check failed."
}
if ($managedCloseOutput -like "*Escalation reason:*") {
    throw "Managed close printed an escalation reason for a default-tier task."
}

$managedEscalatedTaskIdMatch = [regex]::Match($managedEscalatedStartOutput, 'Task ledger id:\s*(?<taskId>[a-z0-9\-]+)')
if (-not $managedEscalatedTaskIdMatch.Success) {
    throw "Escalated managed start did not return a parsable task id."
}
$managedEscalatedTaskId = $managedEscalatedTaskIdMatch.Groups["taskId"].Value
$managedEscalatedCloseOutput = & $managedClosePath -TaskId $managedEscalatedTaskId -Status closed -DeliverableLabel Verified -ApprovalMode Director-plus-QA -Note "smoke escalated close" | Out-String
if ($managedEscalatedCloseOutput -notlike "*Escalation reason: Runtime validation requires stronger review settings.*") {
    throw "Escalated managed close smoke check failed."
}

$reviewPacketOutput = & $reviewPacketPath -TaskId "smoke-review-001" -Reviewer "QA Engineer" -ScopeSummary "Review the playback fallback scope" | Out-String
if ($reviewPacketOutput -notlike "*Review packet*" -or
    $reviewPacketOutput -notlike "*Reviewer: QA Engineer*" -or
    $reviewPacketOutput -notlike "*Scope summary:*" -or
    $reviewPacketOutput -notlike "*Deliverable label:*" -or
    $reviewPacketOutput -notlike "*Approval mode:*" -or
    $reviewPacketOutput -notlike "*Evidence source:*" -or
    $reviewPacketOutput -notlike "*Known gaps:*" -or
    $reviewPacketOutput -notlike "*Archived review packet:*") {
    throw "Review packet smoke check failed."
}

$completionPacketOutput = & $completionPacketPath -TaskId "smoke-complete-001" -Outcome "Playback fallback copy aligned with runtime evidence" -NextOwnerOrStatus "QA Engineer" | Out-String
if ($completionPacketOutput -notlike "*Completion packet*" -or
    $completionPacketOutput -notlike "*Outcome:*" -or
    $completionPacketOutput -notlike "*Deliverable label:*" -or
    $completionPacketOutput -notlike "*Approval mode:*" -or
    $completionPacketOutput -notlike "*Evidence source:*" -or
    $completionPacketOutput -notlike "*Known gaps:*" -or
    $completionPacketOutput -notlike "*Recommended next owner or final status:*" -or
    $completionPacketOutput -notlike "*Confidence:*") {
    throw "Completion packet smoke check failed."
}

$reasoningWasteCompletionOutput = & $completionPacketPath -TaskId "smoke-complete-002" -Outcome "Proof was downgraded after repeated weak-evidence passes" -NextOwnerOrStatus "Director (MANAGER)" -ReasoningWaste -ReasoningWasteReason "Two expensive passes repeated the same conclusion without new evidence." | Out-String
if ($reasoningWasteCompletionOutput -notlike "*Reasoning-waste flag: yes*" -or
    $reasoningWasteCompletionOutput -notlike "*Reasoning-waste reason:*") {
    throw "Reasoning-waste completion smoke check failed."
}

$blockerPacketOutput = & $blockerPacketPath -BlockedBy "Evidence gap" -WhyItBlocksProgress "No reviewable artifact supports the requested label." -WhatWasAlreadyTried "Smoke pass and summary review" -NarrowestUnblockNeeded "Produce one artifact bundle" -RecommendedOwner "QA Engineer" -ReasoningWaste -ReasoningWasteReason "Repeated high-cost reasoning added no new proof." | Out-String
if ($blockerPacketOutput -notlike "*Blocker packet*" -or
    $blockerPacketOutput -notlike "*Reasoning-waste flag: yes*" -or
    $blockerPacketOutput -notlike "*Reasoning-waste reason:*") {
    throw "Blocker packet smoke check failed."
}

$validationArtifactOutput = & $validationArtifactPath -TaskId "smoke-validate-001" -Summary "Playback fallback validation bundle" -Artifacts "runs/screens/test.png" | Out-String
if ($validationArtifactOutput -notlike "*Validation artifact bundle*" -or
    $validationArtifactOutput -notlike "*Task ID:*" -or
    $validationArtifactOutput -notlike "*Validation profile:*" -or
    $validationArtifactOutput -notlike "*Artifact bundle:*" -or
    $validationArtifactOutput -notlike "*Metadata file:*") {
    throw "Validation artifact smoke check failed."
}

$compactOutput = & $compactPath -ContextPercent 81 -TaskId "smoke-compact-001" -HandoffCount 2 | Out-String
if ($compactOutput -notlike "*compact-now*" -or
    $compactOutput -notlike "*handoff-limit*" -or
    $compactOutput -notlike "*context-warning*") {
    throw "Compact helper smoke check failed."
}

$handoffOutput = & (Join-Path $agentsPath "new-thread-handoff.ps1") -TaskId "smoke-ledger-001" -NextSlice "smoke next slice" | Out-String
if ($handoffOutput -notlike "*Bootstrap rules:*" -or
    $handoffOutput -notlike "*open*runtime-charter.md*first*" -or
    $handoffOutput -notlike "*task id: smoke-ledger-001*" -or
    $handoffOutput -notlike "*latest owner:*" -or
    $handoffOutput -notlike "*smoke next slice*") {
    throw "Task-scoped handoff smoke check failed."
}

$determinismOutput = & $determinismProfilePath -Profile strict | Out-String
if ($determinismOutput -notlike "*Determinism profile: strict*" -or
    $determinismOutput -notlike "*Profile path:*" -or
    $determinismOutput -notlike '*"network_mode"*') {
    throw "Determinism profile smoke check failed."
}

$packageVersion = "0.2.0-smoke-{0}" -f [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$packageOutput = & $packagePath -Version $packageVersion | Out-String
if ($packageOutput -notlike "*Packaged:*" -or $packageOutput -notlike "*Manifest:*" -or $packageOutput -notlike "*SHA256:*") {
    throw "Packaging smoke check failed."
}
$packageZipMatch = [regex]::Match($packageOutput, 'Packaged:\s*(?<zipPath>.+\.zip)')
if (-not $packageZipMatch.Success) {
    throw "Packaging smoke check did not return a parsable archive path."
}

$packageZipPath = $packageZipMatch.Groups["zipPath"].Value.Trim()
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($packageZipPath)
try {
    $packageEntries = @($archive.Entries | Select-Object -ExpandProperty FullName)
} finally {
    $archive.Dispose()
}

$requiredPackageEntries = @(
    "AGENTS.md",
    "README.md",
    "THREAD_BOOTSTRAP.md",
    "WORKSTYLE.md",
    "SYSTEM_INDEX.md",
    "NEXT_THREAD.md",
    "START_NEW_CHAT.ps1",
    "agents/README.md",
    "agents/runtime-charter.md",
    "agents/startup-prompts.md",
    "agents/should-compact.ps1",
    "plans/autonomous-execution-program-2026-03-18.md",
    "profiles/strict.json",
    "golden/golden-run-seed.json"
)

foreach ($requiredPackageEntry in $requiredPackageEntries) {
    if ($packageEntries -notcontains $requiredPackageEntry) {
        throw "Packaging smoke check missing required archive entry: $requiredPackageEntry"
    }
}

$stageBoundaryOutput = & $stageBoundaryPath | Out-String
if ($stageBoundaryOutput -notlike "*Stage boundary clean.*" -and
    $stageBoundaryOutput -notlike "*No staged files.*") {
    throw "Stage boundary smoke check failed."
}

$goldenSeed = Get-Content $goldenSeedPath | ConvertFrom-Json
if ($goldenSeed.Count -lt 3) {
    throw "Golden dataset seed smoke check failed."
}

if ($failed.Count -gt 0) {
    throw ("Smoke tests failed:`n{0}" -f (($failed | ForEach-Object { "{0}: {1}" -f $_.Name, $_.Missing }) -join "`n"))
}

Write-Host "All smoke tests passed."

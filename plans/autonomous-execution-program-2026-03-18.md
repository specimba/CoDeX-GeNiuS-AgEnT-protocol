# Autonomous Execution Program

Date: 2026-03-18
Purpose: keep the team working continuously with low approval friction, clear ownership, and bounded parallelism.

## Team Snapshot

- Director (MANAGER): routing, sequencing, proof gates, final integration
- Avicenna (UI/UX Designer): flow quality, interaction clarity, design handoff
- Volta (Backend Engineer): backend logic, persistence, safety, integration contracts
- Heisenberg (Frontend Engineer): user-facing flow, client state, visible ergonomics
- Faraday (QA Engineer): proof, regression confidence, failure clarity

## Operating Rule

The team does not wait for CEO approval on normal bounded work.

The team proceeds autonomously when:

- scope is already aligned with the active roadmap
- the task is not destructive
- the task does not change company-level policy
- the task does not require a major stage change

Escalate only for:

- major architectural change
- destructive or production-sensitive operations
- big scope shift
- policy-level control changes

## Parallelism Rule

- best mode: 2 active agents total
- normal max: 3 active agents total
- hard ceiling: 4 active agents total

Use one primary owner and one sidecar whenever possible.

## Work Program

## Lane A - Efficiency Core

Status: active
Owner: Director (MANAGER) with Volta support

### A1. Auto-attempt tracking

Owner: Volta
Type: independent
Goal:

- derive attempt count directly from ledger events
- remove manual retry drift

Needs:

- `agents/task-ledger.ps1`
- `agents/start-managed-task.ps1`
- `agents/close-managed-task.ps1`

Validation:

- smoke test covers repeat attempts

### A2. Better owner recommendation

Owner: Director (MANAGER)
Type: independent
Goal:

- refine `triage-task.ps1`
- reduce unnecessary Director routing

Needs:

- `agents/triage-task.ps1`
- `agents/role-model-policy.md`

Validation:

- targeted triage examples
- smoke-test extension

### A3. Clean stage boundary helper

Owner: Volta
Type: independent
Goal:

- add a helper that reports source vs generated/runtime noise before staging

Needs:

- `.gitignore`
- `plans/integration-discipline-2026-03-18.md`

Validation:

- dry-run output over current repo

Status:

- complete

## Lane B - Reasoning Discipline

Status: active
Owner: Director (MANAGER)

### B1. Escalation reason logging

Owner: Director (MANAGER)
Type: independent
Goal:

- require a short reason whenever model or reasoning is escalated

Needs:

- `agents/start-managed-task.ps1`
- `agents/close-managed-task.ps1`
- `agents/role-model-policy.md`

Validation:

- start/close output includes reason only when escalated

Status:

- complete

### B2. Waste detection

Owner: Faraday
Type: sidecar
Goal:

- define a lightweight rule for identifying unjustified high-cost reasoning

Needs:

- `agents/role-model-policy.md`
- `agents/sync-protocol.md`

Validation:

- one policy doc update
- example packet

Status:

- complete

## Lane C - Proof And Audit

Status: active
Owner: Faraday with Director (MANAGER) support

### C1. Completion packet upgrade

Owner: Faraday
Type: independent
Goal:

- enrich completion expectations with exact files, validations, approval mode, and evidence source

Needs:

- `agents/sync-protocol.md`
- `agents/control-system-rules.md`

Validation:

- packet examples updated

Status:

- complete

### C2. Ledger summary helper

Owner: Volta
Type: independent
Goal:

- add a one-command task summary derived from ledger history

Needs:

- `agents/task-ledger.ps1`

Validation:

- output shows intake, owners, attempts, and final status

Status:

- complete

### C3. Research fallback tracking

Owner: Faraday
Type: sidecar
Goal:

- make weak-research outcomes visible instead of silently abandoned

Needs:

- `agents/sync-protocol.md`
- `agents/control-system-rules.md`

Validation:

- example fallback packet and usage note

Status:

- complete

### C4. Bounded-review archive

Owner: Faraday
Type: independent
Goal:

- keep review packets tied to task ids under a runtime archive path

Needs:

- `agents/prepare-review-packet.ps1`
- `agents/bounded-review.md`

Validation:

- packet helper writes archived review packet under `runs/review-packets/`

Status:

- complete

### C5. Golden-run dataset seed

Owner: Faraday with Volta support
Type: independent
Goal:

- create a small seed dataset for repeatable proof checks

Needs:

- `plans/roadmap-upgrades-adopt-sandbox-reject-2026-03-18.md`
- `C:\MyFlaskAI\SEQUENCE\brain\GOLDEN_DATASET_SEED.json`

Validation:

- seed file exists in this repo with bounded examples and expected signals

Status:

- complete

### C6. Artifact-first validation helper

Owner: Heisenberg with Faraday review
Type: independent
Goal:

- standardize small reviewable run bundles for validation evidence

Needs:

- browser artifact policy
- helper script or documented bundle format

Validation:

- one helper or documented format exists and is referenced by proof docs

Status:

- complete

### C7. Determinism profile helper

Owner: Volta with Faraday review
Type: independent
Goal:

- define small runtime presets for repeatable proof runs

Needs:

- `profiles/`
- `agents/load-determinism-profile.ps1`
- `agents/determinism-profiles.md`

Validation:

- profile files exist
- helper can load them

Status:

- complete

## Lane D - Documentation Chain

Status: active
Owner: Avicenna

### D1. Script purpose headers

Owner: Avicenna
Type: independent
Goal:

- standardize short purpose headers across helper scripts

Needs:

- all `agents/*.ps1`

Validation:

- spot check on key scripts

### D2. Root README system entry

Owner: Avicenna
Type: dependent on SYSTEM_INDEX existing
Goal:

- add `SYSTEM_INDEX.md` as the primary company entrypoint in root docs

Needs:

- `README.md`
- `SYSTEM_INDEX.md`

Validation:

- root docs point clearly to the system index

## Lane E - Idea Creation Chain

Status: queued
Owner: Director (MANAGER) with Avicenna review

### E1. Idea packet template

Owner: Director (MANAGER)
Type: queued until efficiency core is cleaner
Goal:

- standardize idea generation into benefit/cost/risk/proof shape

### E2. Idea compression rule

Owner: Avicenna
Type: queued
Goal:

- merge overlapping ideas before they become roadmap noise

## Recommended Active Configuration

Default:

- 1 primary owner
- 1 sidecar reviewer or support owner

Examples:

- Director + Volta for execution helpers
- Faraday + Director for proof-chain upgrades
- Avicenna alone for documentation cleanup

Avoid:

- opening all roles at once
- keeping idle roles "parked" open
- parallelizing overlapping edits

## Immediate Next Sequence

1. Volta: A1 auto-attempt tracking
2. Director (MANAGER): A2 owner recommendation refinement
3. Faraday: C1 completion packet upgrade
4. Avicenna: D2 root README entrypoint

These four are the highest-value low-energy tasks and can be run in bounded sequence with one sidecar at a time.

## Output Discipline

Every completed slice should say:

- what changed
- what proof exists
- what remains
- whether the next slice can proceed autonomously

That keeps the team moving without waiting on CEO approval for normal work.

# Bounded Review

Use bounded review packets to keep reviewer context small and purposeful.

This pattern is adapted from the strongest low-token idea found in `obra/superpowers`: reviewers should see only the scope they need to judge.

## Rule

When asking another agent to review work:

- send only the task id
- send only the scope under review
- include the claimed deliverable label
- list changed files
- list validations already run
- include the approval mode used
- include the evidence source
- list open risks
- list known gaps

Do not send the full thread by default.

Archive the packet under `runs/review-packets/` so the review request stays tied to the task id without depending on chat history.

## Command

```powershell
.\agents\prepare-review-packet.ps1 `
  -TaskId "playback-fix-001" `
  -Reviewer "QA Engineer" `
  -ScopeSummary "Review the playback timeout fallback flow" `
  -DeliverableLabel "Verified" `
  -ChangedFiles "frontend/playback.tsx, backend/playback.py" `
  -Validation "smoke-test-pack; manual timeout repro" `
  -ApprovalMode "Director-plus-QA" `
  -EvidenceSource "manual timeout reproduction plus targeted smoke pass" `
  -OpenRisks "broader music sync regression not exercised" `
  -KnownGaps "full music sync matrix not rerun" `
  -WriteFile
```

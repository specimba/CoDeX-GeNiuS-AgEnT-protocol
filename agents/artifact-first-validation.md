# Artifact-First Validation

Purpose: make validation reviewable from artifacts before rerunning the same flow.

## Rule

For proof-oriented checks, prefer a small artifact bundle over a repeated narrative summary.

Minimum bundle:

- task id
- validation profile
- summary
- URL when relevant
- action under test
- evidence source
- artifact references

Typical artifact references:

- screenshot path
- DOM snapshot path
- console log path
- network log path
- diff or test output path

## Command

```powershell
.\agents\prepare-validation-artifact.ps1 `
  -TaskId "playback-fix-001" `
  -Summary "Playback timeout fallback shows the guardrail banner and keeps the session resumable." `
  -ValidationProfile "strict" `
  -Url "http://localhost:3000/playback" `
  -Action "Trigger timeout fallback and inspect banner state" `
  -EvidenceSource "manual repro plus targeted smoke pass" `
  -Artifacts "runs/screens/playback-timeout.png,runs/logs/playback-timeout-console.txt"
```

## Storage

Artifact bundles live under:

- `runs/validation-artifacts/`

This is runtime output, not tracked source.

# Release Packaging

Use this when you want to export the current Manager-led pack as a versioned artifact.

## Command

```powershell
.\agents\package-pack.ps1 -Version "0.2.0"
```

## Output

The command writes:

- `dist/manager-pack-<version>.zip`
- `dist/manifest.json`
- `dist/SHA256SUMS.txt`

The archive should include the current source-of-truth pack surfaces:

- root entry docs and helpers such as `THREAD_BOOTSTRAP.md`, `SYSTEM_INDEX.md`, `NEXT_THREAD.md`, and `START_NEW_CHAT.ps1`
- `agents/`
- `plans/`
- `profiles/`
- `golden/`

These are generated release artifacts and should not be treated as source files in normal development.

## Rule

Package only after:

- smoke tests pass
- the pack docs are consistent
- the intended staged set is clean enough to release
- generated `dist/` output is reviewed as an artifact, not mixed into source changes by default

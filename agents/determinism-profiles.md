# Determinism Profiles

Purpose: reduce flaky proof runs by using explicit runtime presets.

Available profiles:

- `strict`
- `ci`
- `explore`

Use:

```powershell
.\agents\load-determinism-profile.ps1 -Profile strict
```

Meaning:

- `strict`: best for local proof checks with minimal retries
- `ci`: stable shared baseline for repeatable automated checks
- `explore`: wider budget for investigation, not for final proof by default

Rule:

Prefer `strict` for proof packets unless there is a concrete reason to use a looser profile.

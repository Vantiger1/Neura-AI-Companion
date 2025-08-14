# Neura Companion – CI/Local Fix + Build

This repo includes `scripts/tools/fix_and_optimize.ps1` to run a reliable clean, format, analyze, and build.

## Quick Start (Windows PowerShell 7+)

```pwsh
pwsh -File scripts/tools/fix_and_optimize.ps1 -BuildTargets apk,appbundle,web,windows -Strict
```

Flags:
- `-NoBuild` to skip building
- `-SkipTests`, `-SkipFix`, `-SkipFormat` to speed up
- `-BuildTargets apk,appbundle,web,windows` to choose outputs

Artifacts and a slim project ZIP are saved to `build/ci_artifacts`.
Generated on: 2025-08-12T04:52:54

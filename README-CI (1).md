# Neura Companion – CI/Local Fix + Build

This repo includes `scripts/tools/fix_and_optimize.ps1` to clean, format, analyze, and build multi-target artifacts.

## Quick Start (Windows PowerShell 7+)

```pwsh
pwsh -File scripts/tools/fix_and_optimize.ps1 -BuildTargets apk,appbundle,web,windows -Strict
```

Flags:
- `-NoBuild` to skip building
- `-SkipTests`, `-SkipFix`, `-SkipFormat` to speed up
- `-BuildTargets apk,appbundle,web,windows` to choose outputs

Artifacts and a slim project ZIP are saved to `build/ci_artifacts`.

CI Status badge (replace OWNER/REPO):
![CI](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)

Generated: 2025-08-12T10:30:23

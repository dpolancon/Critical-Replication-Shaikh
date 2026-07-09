# Workflow — Pre-Commit Review Deferred

## Current status

Commit review is deferred.

## Principle

Editing-system work and repo-state work are separate.

## Before any staging

Run manually:

```powershell
git status --short
git branch --show-current
git log --oneline -5
```

Then create a staging plan.

## Do not

- do not use `git add .`;
- do not stage generated artifacts automatically;
- do not treat compile readiness as commit readiness.

---
name: commit
description: Git commit conventions and safety rules. Use before any git commit — covers branch-aware push behavior, GPG signing failure handling, versioning, and PR workflow. Fires when the user asks to commit, or when you are about to create a git commit as part of any workflow.
---

# Commit

Conventions that override or extend default commit behavior. Only includes rules Claude doesn't already know — standard commit practices (message style, HEREDOC format, Co-Authored-By, secrets detection) are already handled by the system prompt.

## Rules

### Never use -C
Write a fresh commit message based on the actual changes. Do not reuse previous messages with `git commit -C` unless the user explicitly requests it.

### Handle GPG signing failures
If `git commit` fails with a GPG signing error (e.g., "gpg failed to sign the data"), the user is away from their computer and cannot authenticate 1Password.

**Do not retry. Do not bypass with --no-gpg-sign.**

Tell the user: _"GPG signing failed — 1Password probably needs authentication. Let me know when you're back and I'll retry."_

Stop and wait for the user to respond.

## Branch Behavior

After committing, adapt push behavior to the current branch:

### On `main`
1. Push to origin
2. Tag if versioning was requested (see below)

### On any other branch
1. Push with `-u origin <branch>`
2. Check for an existing open PR (`gh pr list --head <branch> --state open`)
   - **PR exists** — report the PR URL (the push already updates it)
   - **No PR** — create one with `gh pr create`, targeting `dev` if it exists, otherwise `main`

## Versioning

Apply only when the user explicitly requests a version bump or tag.

### Detect scheme from existing tags
- Tags matching `v1.2.3` or `1.2.3` → **Semver**
- Tags matching `2026.02.001` → **CalVer** (year.month.sequence)
- No tags → ask which scheme to use

### Semver
Bump `major`, `minor`, or `patch` as specified. Default to `patch`.

### CalVer
Generate `YYYY.MM.NNN` — increment NNN from the last tag in the current month, or start at `001` for a new month.

### Apply version
```
git tag -a <version> -m "<version>"
git push origin <version>
```

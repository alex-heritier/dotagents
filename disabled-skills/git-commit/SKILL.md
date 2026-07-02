---
name: git-commit
description: ALWAYS use this skill when committing - makes best-effort conventional commits from the current working tree
license: MIT
compatibility: opencode
metadata:
  workflow: conventional-commits
  scope: git
---

## What I do
- Review status, diffs, untracked files, and recent commit style
- Make best-effort conventional commits with sensible staging
- Usually split clearly unrelated changes, but avoid over-optimizing history
- If the user says exactly `commit all`, commit all changes in one commit

## Guidelines
- Do not modify code unless the user asks for fixes before committing
- Inspect existing staged changes before committing; staged changes may be intentional
- Do not revert or rewrite commits to improve history; commit the current changes as best effort
- Stage and commit in one shell command, joined with `&&`, so staged changes are committed immediately
- Use conventional messages: `feat`, `fix`, `chore`, `refactor`, `docs`, or `test`
- Keep commit messages concise and intent-focused

## Workflow
1. Run `bash ~/.config/opencode/skills/git-commit/scripts/context.sh` from the repo root
2. Inspect status, staged diff, unstaged diff, untracked files, and recent commit style
3. Choose one commit or a small number of obvious intent-based commits
4. If the user typed exactly `commit all`, make one commit containing all tracked and untracked changes
5. Commit directly with one-liners like `git add -- <paths...> && git commit -m "type: message"`
6. Verify with `git status --short`

## Safety
- Never update git config
- Never run destructive git commands (--force, hard reset, etc) unless explicit
- Never skip hooks (--no-verify, --no-gpg-sign, etc) unless explicit
- Never amend unless asked
- Don't commit files that likely contain secrets (.env, credentials.json, etc)

## Helper Scripts
- `scripts/context.sh`: deterministic read-only inventory for status, staged diff, unstaged diff, untracked files, and recent log

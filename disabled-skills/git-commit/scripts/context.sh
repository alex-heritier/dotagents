#!/usr/bin/env bash
set -euo pipefail

git rev-parse --show-toplevel >/dev/null

printf '## git status --short\n'
git status --short

printf '\n## staged files\n'
git diff --cached --name-status

printf '\n## staged diff\n'
git diff --cached --stat
git diff --cached --

printf '\n## unstaged files\n'
git diff --name-status

printf '\n## unstaged diff\n'
git diff --stat
git diff --

printf '\n## untracked files\n'
git ls-files --others --exclude-standard

printf '\n## recent commits\n'
git log --oneline --decorate -10

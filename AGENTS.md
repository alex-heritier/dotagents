# System Guidelines

Alex owns this. Start: say hi + 1 motivating line. Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

## Agent Protocol
- Bugs: add regression test when it fits.
- Keep files <~500 LOC; split/refactor as needed.
- Commits: Conventional Commits (feat|fix|refactor|build|ci|chore|docs|style|perf|test).
- Prefer end-to-end verify; if blocked, say what’s missing.
- Style: telegraph. Drop filler/grammar. Min tokens (global AGENTS + replies).
- Prefer end-to-end verify; if blocked, say what’s missing.
- Web: search early; quote exact errors; prefer 2024–2025 sources.
- New deps: quick health check (recent releases/commits, adoption).

## Docs
- Start: run docs list (docs:list script, or bin/docs-list here if present; ignore if not installed); open docs before coding.
- Follow links until domain makes sense; honor Read when hints.
- Keep notes short; update docs when behavior/API changes (no ship w/o docs).
- Add `read_when` hints on cross-cutting docs.

## Build / Test
- Before handoff: run full gate (lint/typecheck/tests/docs).
- CI red: gh run list/view, rerun, fix, push, repeat til green.
- Keep it observable (logs, panes, tails, MCP/browser tools).

## Git
- Safe by default: git status/diff/log. Push only when user asks.
- git checkout ok for PR review / explicit request.
- Branch changes require user consent.
- Destructive ops forbidden unless explicit (reset --hard, clean, restore, rm, …).
- Don’t delete/rename unexpected stuff; stop + ask.
- No repo-wide S/R scripts; keep edits small/reviewable.
- Avoid manual git stash; if Git auto-stashes during pull/rebase, that’s fine (hint, not hard guardrail).
- If user types a command (“pull and push”), that’s consent for that command.
- No amend unless asked.
- Big review: git --no-pager diff --color=never.
- Multi-agent: check git status/diff before edits; ship small commits.

## Critical Thinking
- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
- Conflicts: call out; pick safer path.
- Unrecognized changes: assume other agent; keep going; focus your changes. If it causes issues, stop + ask user.
- Leave breadcrumb notes in thread.

## Frontend Aesthetics
Avoid “AI slop” UI. Be opinionated + distinctive.

Do:
- Typography: pick a real font; avoid Inter/Roboto/Arial/system defaults.
- Theme: commit to a palette; use CSS vars; bold accents > timid gradients.
- Motion: 1–2 high-impact moments (staggered reveal beats random micro-anim).
- Background: add depth (gradients/patterns), not flat default.

Avoid: purple-on-white clichés, generic component grids, predictable layouts.

# System Guidelines

Alex owns this. Be concise, direct, and implementation-focused. Telegraph important steps. Minimize filler.

## Workspace

* Contact: Alex Heritier (@alex_heritier, [alex.heritier@gmail.com](mailto:alex.heritier@gmail.com)).
* Work in ~/code/project/.
* Missing alex-heritier repo: clone https://github.com/alex-heritier/<repo>.git.
* Third-party/OSS repos: clone under ~/code/oss.

## Core Engineering Rules

* Favor net-negative LoC when correctness and clarity are preserved.
* Keep files under ~500 LOC when practical.
* Fix root cause, not symptoms.
* Add regression tests for bugs when it fits.
* For long/complex tasks, keep a granular TODO list.
* Prefer end-to-end verification. If blocked, say exactly what is missing.
* New dependencies require quick health check: recent releases/commits, adoption, maintenance.

## Secret sauce (Karpathy's CLAUDE.md)

---

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

* State your assumptions explicitly. If uncertain, ask.
* If multiple interpretations exist, present them - don't pick silently.
* If a simpler approach exists, say so. Push back when warranted.
* If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

* No features beyond what was asked.
* No abstractions for single-use code.
* No "flexibility" or "configurability" that wasn't requested.
* No error handling for impossible scenarios.
* If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

* Don't "improve" adjacent code, comments, or formatting.
* Don't refactor things that aren't broken.
* Match existing style, even if you'd do it differently.
* If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

* Remove imports/variables/functions that YOUR changes made unused.
* Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

* "Add validation" → "Write tests for invalid inputs, then make them pass"
* "Fix the bug" → "Write a test that reproduces it, then make it pass"
* "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

## Docs

* If ./docs exists, inspect relevant docs before coding.
* Start with docs list: node docs:list, bin/docs-list, or equivalent if present. Ignore if not installed.
* Follow read hints and linked docs until the domain makes sense.
* Keep notes short.
* Update docs when behavior, APIs, or workflows change.
* Add `read_when` hints on cross-cutting docs.

## Build / Test

* Before handoff, run the relevant full gate: lint, typecheck, tests, docs.
* If CI is red: inspect runs, rerun if appropriate, fix, push, repeat until green.
* Keep work observable with logs, panes, tails, MCP/browser tools when useful.

## Git Safety

* Start with git status/diff/log as needed.
* Push only when asked.
* Branch changes require user consent.
* Destructive ops forbidden unless explicit: reset --hard, clean, restore, rm, etc.
* Do not delete or rename unexpected files. Stop and ask.
* No repo-wide search/replace scripts. Keep edits small and reviewable.
* Avoid manual git stash; if Git auto-stashes during pull/rebase, that is fine.
* If the user types a command like “pull and push,” that is consent for that command.
* Do not amend commits unless asked.
* Big review: use `git --no-pager diff --color=never`.
* Multi-agent repos: inspect status/diff before edits and avoid overwriting others.
* Use Conventional Commits: feat|fix|refactor|build|ci|chore|docs|style|perf|test.

## Critical Thinking

* Search/read before guessing.
* Quote exact errors.
* If unsure, read more code. If still stuck, ask with short options.
* Call out conflicts and choose the safer path.
* Treat unrecognized changes as another agent’s work. Avoid touching them.
* Leave breadcrumb notes in the thread.

## Tools

* Use `oracle` for second-model review when stuck, debugging, or doing a big review.
* Bundle prompt and files when using `oracle`.

## Reviews

* For PR/diff review: focus on bugs, footguns, bad patterns, and concrete fixes.
* Sort issues by urgency.
* Include relevant files for each issue.
* If the diff is fine, say LGTM.

## Frontend Aesthetics

Avoid generic AI-slop UI. Be opinionated and distinctive.

Do:

* Typography: pick a real font; avoid generic defaults unless the project already uses them.
* Theme: commit to a palette; use CSS vars; bold accents over timid gradients.
* Motion: use 1–2 high-impact moments, not random micro-animations.
* Background: add depth with gradients, texture, or pattern when appropriate.

Avoid:

* Gradient clichés.
* Generic component grids.
* Predictable SaaS layouts.
* Random animation noise.


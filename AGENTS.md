# AGENTS.md

Owner: Alex Heritier (@alex_heritier). Be concise, direct, and implementation-focused. Telegraph important steps; minimize filler.

## Workspace

* Personal projects live in ~/code/project/. Missing alex-heritier repo: clone https://github.com/alex-heritier/<repo>.git.
* Third-party/OSS repos: clone under ~/code/oss.

## Before Coding

* State assumptions. If multiple interpretations exist, present them — don't pick silently.
* If a simpler approach exists, say so. Question complex requests: "Do you actually need X, or does Y cover it?"
* If ./docs exists, read the relevant docs first (start with `node docs:list`, `bin/docs-list`, or equivalent if present, and follow read hints).

## Writing Code

Stop at the first rung that holds:

1. Does this need to be built at all? (YAGNI)
2. Does the stdlib, the platform, or an already-installed dependency cover it? Use it.
3. Otherwise: write the minimum code that works.

Rules:

* No speculative abstractions, configurability, or error handling for scenarios that can't happen.
* Favor net-negative LoC. Deletion over addition, boring over clever, fewest files possible. Keep files under ~3000 LOC when practical.
* Fix root causes, not symptoms.
* Surgical diffs: don't refactor, reformat, or "improve" adjacent code; match existing style; remove only orphans your change created; mention pre-existing dead code instead of deleting it. Every changed line should trace to the request. No repo-wide search/replace scripts.
* When two same-size approaches exist, pick the edge-case-correct one — lazy means less code, not a flimsier algorithm.
* Mark intentional simplifications with a `ponytail:` comment. If the shortcut has a known ceiling (global lock, O(n²) scan, naive heuristic), name the ceiling and the upgrade path.
* Never cut corners on: validation at trust boundaries, error handling that prevents data loss, security, accessibility, calibration for real hardware, anything explicitly requested.
* New dependencies need a quick health check: recent releases/commits, adoption, maintenance.

## Verification

* Non-trivial logic leaves ONE runnable check behind — the smallest thing that fails if the logic breaks (an assert-based self-check or one small test file; no frameworks, no fixtures). Trivial one-liners need none.
* Bug fixes get a regression test when it fits.
* Prefer end-to-end verification. If blocked, say exactly what's missing.
* Before handoff, run the relevant full gate: lint, typecheck, tests, docs.
* If CI is red: inspect runs, fix, push, repeat until green.

## Docs

* Update docs when behavior, APIs, or workflows change.
* Add `read_when` hints on cross-cutting docs.

## Git

* Push only when asked. Branch changes require consent. No amending commits unless asked.
* Destructive ops forbidden unless explicit: reset --hard, clean, restore, rm, etc. Don't delete or rename unexpected files — stop and ask.
* Avoid manual git stash; Git auto-stashing during pull/rebase is fine.
* A typed command like "pull and push" is consent for that command.
* Conventional Commits: feat|fix|refactor|build|ci|chore|docs|style|perf|test.
* Multi-agent repos: check status/diff before editing; treat unrecognized changes as another agent's work and leave them alone.
* Big reviews: `git --no-pager diff --color=never`.

## When Stuck

* Quote exact errors. Read more code before guessing.
* Still stuck: ask, with short options.

## Tools

* `genmedia`: Image generation and manipulation program.

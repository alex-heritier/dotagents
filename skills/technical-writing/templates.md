# Technical Writing Templates

Ready-to-fill scaffolds for each document type in the `SKILL.md` quick reference.
Copy the relevant one, replace the bracketed placeholders, and delete sections that
do not apply. Each scaffold already encodes the patterns from `patterns.md`.

Keep the BLUF opener, the scope/non-goals, and the testable-claims sections in
every document — those are the load-bearing parts.

---

## Specification / Model

```markdown
# [System] Model

This document defines the exact [mathematical/behavioral] model used by [system].

The choices here are intentionally opinionated. They exist to prevent individual
components from introducing competing [conventions/assumptions].

## 1. Model Summary

[System] uses:
* [Core choice 1]
* [Core choice 2]

[System] currently does not use:
* [Excluded choice 1]
* [Excluded choice 2]

## 2. [Foundational concept — e.g. Coordinate System / Units / Time]

[Define it once. Formula blocks and tables, not prose.]

## 3. [Next concept, building on §2]

...

## N. Canonical [State/Data] Shapes

The exact syntax may change, but the conceptual contracts are fixed.

\```text
[StateName]
    fieldWithUnitM
    fieldWithFrameAndUnitMps
\```

The canonical state must not contain:
* [Forbidden content, e.g. render coordinates, cached values]

## N+1. Deliberate Simplifications

The following inaccuracies are accepted by design:
1. [Simplification + one-clause reason]
2. [Simplification + one-clause reason]

These are core choices unless a later phase explicitly replaces one.
```

---

## Architecture / Systems

```markdown
# [Codebase] Systems

This document defines ownership and dependency boundaries. It does not duplicate
[the model in `model.md` / the roadmap in `roadmap.md`].

The architecture has [N] layers. Code dependencies point downward; runtime data
flows upward.

\```text
[Top Layer]
        │ depends on
        ▼
[Lower Layer]
\```

A layer may depend only on layers below it. [Cross-cutting rule, e.g. "Core code
must never import the UI framework."]

## [N]. [System Name]

[One-sentence statement of what it does.]

Inputs:
* [Input with unit/frame]

Outputs:
* [Output with unit/frame]

Responsibilities:
* [Responsibility]

It must not:
* [Boundary — what it does not own or do]

## State Ownership

### [System] owns
* [Authoritative mutable state]

No other system may maintain a competing authoritative copy of this state.

## Dependency Rules

1. [Rule — "X must always go through Y."]
2. [Rule]

## What Is Not a Separate System

The following are intentionally absent:
* [Deliberately omitted system + one-clause reason]
```

---

## Invariants / Rules

```markdown
# [System] Invariants

These invariants are non-negotiable properties of [system].

An invariant violation is a bug even when the result appears correct. Tolerance
changes or special cases must never be used to conceal an invalid state.

## 1. [Category — e.g. State Authority]

### 1.1 [Specific invariant title]

[The rule, as a `must`/`must not` statement.]

[One-clause consequence or rationale if non-obvious.]

## N. Error Tolerances

Results are compared with combined absolute and relative tolerances:

\```text
error <= absolute tolerance + relative tolerance × comparison scale
\```

| Quantity   | Absolute | Relative |
| ---------- | -------: | -------: |
| [Quantity] | [value]  | [value]  |

A tolerance may be changed only when:
1. The expected error has been measured.
2. The reason is documented.
3. The new value does not conceal a bug.

## N+1. Required Tests

The automated suite must include at least:
1. [Observable, falsifiable check]
2. [Observable, falsifiable check]
```

---

## Roadmap / Phased Plan

```markdown
# [Feature] Roadmap

This document owns the [feature] roadmap and current phase status.

## Approach

[The end goal in one or two sentences, then the increment strategy.]

Each phase is implemented, inspected, and accepted before the next begins.

## Status

Status legend:
* Complete — implemented and accepted
* Current  — the active phase
* Planned  — agreed architecture, not yet implemented
* Deferred — explicitly outside the current roadmap

| Phase | Status | Summary |
| ----- | ------ | ------- |
| 1     | [...]  | [...]   |

## Phase [N] — [Title] · [Status]

[One-sentence goal of the phase.]

Deliverables:
* [Concrete deliverable]

Excludes: [what this phase deliberately does not do].

Acceptance:
1. [Observable check]
2. [Observable check]
```

---

## README

```markdown
# [Project]

[One paragraph: what it is, what it does, at what scale or for whom.]

The authoritative specification lives in [`docs/`](docs/).

## Scope

**Included:**
* [Capability]

**Excluded:**
* [Non-capability] ([planned; see `link`] if applicable)

## Why [The Hard Part] Is Necessary

[The naive approach and why it fails — the core problem the design solves.]

[The hard problems, as a bulleted list with bold lead-ins:]
* **[Problem].** [One or two sentences.]

## [Core Concepts / How It Works]

### [N]. [Concept]

[What it is and why it exists, in two or three sentences.]

## Architecture at a Glance

[Layer diagram + one paragraph. Link to `systems.md` for the full set.]

## Specification Documents

* **[`model.md`](docs/model.md)** — [what it owns]
* **[`systems.md`](docs/systems.md)** — [what it owns]
* **[`invariants.md`](docs/invariants.md)** — [what it owns]
```

---

## RFC / ADR (Decision Record)

```markdown
# [ADR-NNN] [Decision title]

Status: [Proposed | Accepted | Superseded by ADR-MMM]

## Context

[The forces at play: the problem, constraints, and what makes this non-trivial.
State facts, not opinions.]

## Decision

[The decision, stated as a rule. One paragraph.]

## Options Considered

### Option A — [name] (chosen)
* Pros: [...]
* Cons: [...]

### Option B — [name]
* Pros: [...]
* Cons: [...]
* Rejected because: [reason]

## Consequences

* [What becomes easier]
* [What becomes harder]
* [Accepted trade-off]
```

---

## Runbook

```markdown
# Runbook: [Procedure]

Use when: [trigger condition].
Outcome: [what the system looks like when done].

## Preconditions
* [Required access, state, or tool]

## Steps

1. [Action.]
   \```bash
   [exact command]
   \```
   Expected: [observable result].

2. [Action.]
   Expected: [observable result].

## Verification
* [How to confirm success — an observable check.]

## Rollback
1. [How to undo, if the procedure fails partway.]
```

---

## API Reference Entry

```markdown
### `functionName(args) -> ReturnType`

[One sentence: what it does.]

Parameters:
| Name    | Type           | Unit/Frame | Description |
| ------- | -------------- | ---------- | ----------- |
| [name]  | [type]         | [unit]     | [meaning]   |

Returns: [type] — [meaning, with unit/frame].

Errors:
* `[ErrorType]` — [when it is raised].

Example:
\```[lang]
[minimal, runnable usage]
\```

Notes:
* [Non-obvious constraint, determinism guarantee, or boundary.]
```

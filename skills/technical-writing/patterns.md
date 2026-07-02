# Technical Writing Patterns

The technique catalog behind `SKILL.md`. Each pattern has a rule, a rationale, and
a before/after rewrite. Read the relevant entries while drafting or tightening.

The patterns are grouped: document-level, section-level, sentence-level,
precision, and density.

---

## Document-Level Patterns

### P1. Authority-declaring opener

**Rule.** The first sentence states what the document *is* and its authority.

The reader must know in one line whether they are holding the source of truth, a
proposal, or a description — and what it governs.

```text
Good:
"This document is the single source of truth for the local terrain system."
"This document defines the exact mathematical model used by the engine."
"These invariants are non-negotiable properties of the engine."

Weak:
"This document talks about some of the terrain stuff and how it works."
```

### P2. One fact, one home (anti-drift)

**Rule.** Each fact lives in exactly one document/section. Everywhere else links to it, and says so when the discipline matters.

Duplicated facts drift into contradictions the moment one copy is edited. Naming
the discipline ("not duplicated here so they cannot drift") tells future editors
not to paste it back.

```text
Good:
"The per-phase required tests live in `docs/invariants.md` §15. They are not
 duplicated here so they cannot drift."

Bad:
(the same test list pasted into three documents, now silently out of sync)
```

### P3. Cross-reference map

**Rule.** Near the top, list the sibling documents and what each owns.

A reader who lands in the wrong document should be routed in seconds.

```text
The other docs stay aligned with this one and are not duplicated here:
* `systems.md`          — system ownership and dependency rules
* `simulation-model.md` — the mathematical and physical model
* `invariants.md`       — non-negotiable properties and the required test list
```

### P4. Status legend + status table

**Rule.** When a document tracks progress, define the status vocabulary once, then use a compact table.

```text
Status legend:
* Complete — implemented and accepted
* Current  — the active phase
* Planned  — agreed architecture, not yet implemented
* Deferred — explicitly outside the current roadmap

| Phase | Status   | Summary |
| ----- | -------- | ------- |
| 6     | Complete | Deterministic visual height |
| 8     | Current  | Body-specific macro geometry |
| 9     | Planned  | Terrain-aware impact |
```

### P5. Numbered sections for cheap reference

**Rule.** In long documents, number sections and subsections so "stated once, referenced everywhere" costs one token (`§11.7`).

Numbered anchors let you state a mechanism once and point to it from a dozen
places without repeating it.

---

## Section-Level Patterns

### P6. Scope and Non-Goals

**Rule.** State explicitly what is included and what is excluded. The exclusions carry as much signal as the inclusions.

Listing exclusions stops scope creep and preempts "what about X?" questions. Add
the reason an exclusion exists when it is non-obvious.

```text
The terrain work explicitly excludes, until a phase promotes them: terrain-aware
impact, collision meshes, atmosphere, texture streaming, and any change to
orbital mechanics. These must not be smuggled into an earlier phase because the
architecture could support them later.
```

### P7. Terminology, with conflated concepts kept distinct

**Rule.** Define terms once in a terminology section. Explicitly separate concepts that readers tend to merge.

The highest-value definition is the one that says "these two things look the same
and are not."

```text
* The three LOD concepts — kept distinct and never merged into one enum:
  * Representation LOD — which whole-body view to show
  * Terrain patch LOD  — how finely the local surface subdivides
  * Material LOD       — surface shading detail
```

### P8. Responsibilities / Inputs / Outputs triad

**Rule.** Describe each component with a fixed structure: what it is responsible for, what it consumes, what it produces.

A repeated structure lets a reader scan twenty components the same way.

```text
### Reference Frame System
Converts positions and velocities between coordinate frames.

Inputs:  a state, a source frame, a target frame
Outputs: the equivalent state in the target frame

Responsibilities:
* Convert body-relative state to heliocentric state
* Transform both position and velocity correctly
* Preserve global state during frame changes

It performs transformations only. It does not advance time, move bodies, or render.
```

### P9. Negative-space boundary ("must not" / "does not own")

**Rule.** Every component gets an explicit list of what it must not do or own. Define the thing by its edges.

Most architecture bugs are ownership bugs. The "must not" list prevents them.

```text
The Local PQS System must not:
* Perform orbital propagation
* Detect SOI crossings
* Define gravity or decide physical impact
* Read Three.js transforms as authoritative coordinates
```

### P10. Roadmap phase template

**Rule.** Each phase uses the same four parts: Status, Deliverables, Excludes, Acceptance. Acceptance criteria are numbered, observable checks.

```text
### Phase 1 — Static six-face quad-sphere · Complete
Replace the close-range sphere with six fixed cube-face root meshes.

Deliverables:
* Six root patches on a 16×16 grid
* Filled mesh plus an explicit grid overlay

Excludes: subdivision, height, collision changes.

Acceptance:
1. Hiding one root removes exactly one-sixth of the body.
2. The body looks spherical with no gaps between faces.
3. Every square boundary is visible and no triangle diagonals appear.
```

### P11. Deliberate-simplifications list

**Rule.** Collect accepted inaccuracies and trade-offs in one explicit list, framed as choices.

Stated trade-offs read as engineering judgment; the same trade-offs unstated read
as defects.

```text
## Deliberate Simplifications
The following inaccuracies are accepted by design:
1. Bodies follow fixed two-body Keplerian orbits.
2. The spacecraft feels gravity from one primary at a time.
These are core choices unless a later phase explicitly replaces one.
```

### P12. Anti-over-engineering callout

**Rule.** Where a reader might over-build, cap it explicitly and gate the expansion on evidence.

```text
Deliberately small. This is a few explicit, typed layers — not a framework.
Do not propose a generic modifier graph, a node editor, or a plugin system
before profiling proves it necessary.
```

---

## Sentence-Level Patterns

### P13. Bottom line up front

**Rule.** First sentence of every paragraph is the conclusion. Support follows.

```text
Good:
"Visibility is separate from LOD. Patches outside the frustum need not refine..."

Buried:
"There are several considerations around frustum handling and after weighing them
 we concluded that visibility is separate from LOD."
```

### P14. Rationale as a clause

**Rule.** Attach the "why" to the rule with one `so`/`because` clause. Never spend a paragraph on it.

```text
"Split and merge thresholds differ (split > merge) so small camera movements
 cannot cause oscillation."
```

### P15. Name the rule, then explain

**Rule.** Lead a rule with a short bold label, then the body.

```text
**Presentation-only until promoted.** Terrain is visual. It must not change
gravity, impact, or landing until an explicit phase promotes it.
```

### P16. Active voice, present tense, declarative

**Rule.** State what the system *does* and *is*. Avoid passive and future tense for behavior.

```text
Good: "The runtime commits canonical state and publishes an immutable snapshot."
Weak: "Canonical state will be committed and a snapshot will be published."
```

### P17. Cut throat-clearing and hedging

**Rule.** Delete phrases that carry no information.

```text
Delete: "It is important to note that", "In order to", "As we mentioned",
        "basically", "essentially", "it should probably", "for the most part"
```

```text
Before: "It is important to note that the simulation should basically never
         use Date for orbital math."
After:  "The core simulation must never use `Date` for orbital calculations."
```

---

## Precision Patterns

### P18. Units and frames in names

**Rule.** Identifiers crossing a boundary carry their unit and frame. A bare type is not a contract.

```text
Good: positionRelativeToPrimaryM, velocityRelativeToPrimaryMps, epochS,
      signedRotationRateRadPerS
Bad:  position: Vector3   // which frame? which unit?
```

### P19. Calibrated requirement strength

**Rule.** Use `must` / `must not` for hard rules, `should` for recommendations, `may` for options. Keep usage consistent across the document.

```text
"The integrator must never use a step larger than the fixed timestep."   (hard)
"A shorter sub-step may be taken only to land on an event boundary."      (option)
"Most systems should be stateless functions."                            (recommendation)
```

### P20. Explicit limits and tolerances

**Rule.** Replace "small", "fast", "close enough" with numbers, and state when a number may change.

```text
A tolerance may be changed only when:
1. The expected floating-point error has been measured.
2. The reason is documented.
3. The new value does not conceal a discontinuity or algorithmic bug.
```

### P21. Falsifiable properties

**Rule.** Turn adjectives into observable checks.

```text
Before: "Propagation should be reliable and reversible."
After:  "Propagating from t0 to t1 and back to t0 reproduces the original state
         within the tolerances of §14."
```

---

## Density Patterns

### P22. Formula blocks over prose math

**Rule.** Put any equation in a fenced block. Never describe math in a sentence when the expression is clearer.

```text
a_gravity = -μ r / |r|³

where μ is the current primary body's gravitational parameter.
```

### P23. Tables for repeated-attribute data

**Rule.** Three or more items sharing attributes go in a table.

```text
| Quantity     | Unit                      |
| ------------ | ------------------------- |
| Position     | meters                    |
| Velocity     | meters per second         |
| Acceleration | meters per second squared |
```

### P24. ASCII / Mermaid diagrams for structure

**Rule.** Show hierarchy, topology, and data flow as a diagram.

```text
Presentation Systems
        │ depends on
        ▼
Application Runtime
        │ depends on
        ▼
Pure Simulation Systems
        │ depends on
        ▼
Shared Mathematical Foundation
```

### P25. Typed shapes for data and interfaces

**Rule.** Describe data by its shape, not by paragraphs about its fields.

```text
SOICrossingEvent
    eventTimeS
    fromBodyId
    toBodyId
    direction
```

### P26. Pipelines and ordered lists for sequences

**Rule.** When order matters, use a numbered list or a labeled pipeline, not a sentence with "first… then… after that…".

```text
current time
    → earliest event
    → state transition
    → next event
    → final requested time
```

---

## Revision Pass Order

When tightening an existing document, apply passes in this order — each makes the next cheaper:

1. **Structure** — fix ownership and section order first (P1–P5, P6–P9). Moving text later is wasted if it moves again.
2. **Density** — convert prose to tables, formulas, diagrams, shapes (P22–P26).
3. **Sentences** — apply BLUF, cut filler, calibrate strength (P13–P19).
4. **Precision** — fix names, units, tolerances, falsifiability (P18, P20, P21).
5. **Final read** — verify every cross-reference resolves and no fact is duplicated (P2).

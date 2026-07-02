---
name: technical-writing
description: >-
  Write and revise high-signal technical documentation — specifications, architecture
  and design docs, invariants/rules, roadmaps, READMEs, RFCs, ADRs, runbooks, and API
  references. Produces clear sectioning, high information density, and high signal-to-noise
  prose with testable claims and explicit scope. Use when the user asks to write, structure,
  tighten, or review any engineering document, spec, design doc, or README.
---

# Technical Writing

Produce documents an engineer can act on without asking follow-up questions. The
test of a technical document is not that it reads well — it is that a competent
reader reaches the **same** decisions, builds the **same** mental model, and can
**verify** every claim.

This skill optimizes for three properties, in order:

1. **Correct sectioning** — every fact has exactly one home; structure mirrors ownership.
2. **High information density** — bullets, tables, formulas, diagrams, and data shapes instead of prose paragraphs.
3. **High signal-to-noise** — every sentence carries a fact, a rule, or a reason. Nothing else survives.

Detailed material is split out so this file stays scannable:

- `patterns.md` — the technique catalog with before/after rewrites. Read it when drafting or tightening prose.
- `templates.md` — ready-to-fill scaffolds for each document type. Read it when starting a new document.

---

## Operating Principles

These are non-negotiable. Everything else in this skill is a consequence of them.

- **Bottom line up front (BLUF).** Lead every document, section, and paragraph with the conclusion or rule. Support comes after, never before.
- **One fact, one home.** State each fact in exactly one place. Everywhere else, cross-reference it. Duplicated facts drift and become contradictions.
- **Define by boundaries.** A component is defined as much by what it is *not* and what it must *not* do as by its responsibilities. Always write the scope, the non-goals, and the "must not" list.
- **Show, don't narrate.** Replace prose with the densest faithful form: a formula for math, a table for multi-attribute data, a diagram for structure, a typed shape for data. Prose is for relationships and reasoning only.
- **Encode requirement strength.** Use `must` / `must not` / `may` / `should` deliberately and consistently (RFC-2119 sense). A reader must be able to tell a hard rule from a recommendation at a glance.
- **Name with precision.** Identifiers carry their unit and frame (`positionRelativeToPrimaryM`, `epochS`). A bare `position` or `timeout` is not an acceptable contract.
- **Every claim is testable.** Write properties and acceptance criteria as observable, falsifiable checks. If you cannot describe how to verify it, you have not specified it.
- **Earn every token.** Delete any word, sentence, or section that does not change what the reader does. Assume an expert reader; cut what they already know.
- **State decisions, not options.** Pick the approach, state it as the rule, and record the rejected alternatives and the accepted trade-offs explicitly. Do not leave the reader to choose.

---

## The Writing Workflow

Follow these phases in order. Do not skip to prose before the structure exists.

### Phase 1 — Define the document's job (before writing)

Answer these in one line each. They go at the top of the document or in your notes.

- **Identity:** What *is* this document, in one sentence? (e.g. "the single source of truth for X", "the exact mathematical model", "the non-negotiable testable properties").
- **Reader and use:** Who reads it, and what decision or task do they use it for?
- **Authority:** Is it normative (rules others must follow) or descriptive (explains how something works)? Normative docs use `must`/`must not`; descriptive docs explain and link.
- **Ownership:** What does this document own that no sibling document does? List the topics that live *elsewhere* and link to them.

If two documents would own the same topic, stop and resolve it. Overlap is the most common defect.

### Phase 2 — Outline by ownership

- Create one section per topic the document owns. A topic appearing in two sections is a structure bug.
- Order sections so each builds only on earlier ones (define terms before using them; foundations before consumers).
- Number sections when the document is long enough that cross-references help (`§7.5`, `§11`). Numbered sections make "stated once, referenced everywhere" cheap.
- Add a short cross-reference map near the top listing sibling documents and what each owns.

### Phase 3 — Draft each section BLUF

For every section and paragraph:

1. **Lead with the rule or conclusion.** First sentence states the takeaway.
2. **Then support it** with the formula, table, list, or reasoning.
3. **Attach the "why" as a clause, not a paragraph.** Use a single `so that` / `because` clause: "Split and merge thresholds differ (`split > merge`) **so** small movements cannot cause oscillation."
4. **One idea per paragraph.** If a paragraph covers two ideas, split it.

### Phase 4 — Convert prose to dense forms

Walk the draft and downgrade prose wherever a denser form is faithful:

| If the content is... | Use... |
| --- | --- |
| Math, an equation, or a derivation | A fenced formula block, not a sentence |
| Several items with the same attributes | A table |
| An enumerable set of facts (responsibilities, inputs, steps) | A bullet or numbered list |
| Structure, hierarchy, topology, or data flow | An ASCII or Mermaid diagram |
| The shape of data or an interface | A typed pseudo-code block |
| A sequence with ordering that matters | A numbered list or a labeled pipeline |

Prose that survives this pass should describe **relationships and reasoning** — the things lists and tables cannot express.

### Phase 5 — Add scope boundaries

For the document and for each significant component:

- Write an explicit **Scope / Non-Goals** (or **Included / Excluded**) section.
- For each component, add a **"must not" / "does not own"** list. Define it by its edges.
- Call out **accepted trade-offs and simplifications** explicitly ("an accepted, documented mismatch until Phase 9"). Unstated trade-offs read as bugs.
- Add an **anti-over-engineering** note where a reader might over-build: "Deliberately small — a few typed layers, not a framework. Do not introduce X before profiling proves it necessary."

### Phase 6 — Make every claim testable

- Rewrite vague properties as observable checks. "Fast" → "responds within `N` ms at the p99". "Robust" → the specific inputs it must survive.
- Give normative docs a numbered **acceptance criteria** or **required tests** list. Each item is one falsifiable check a reader could turn into a test.
- Make tolerances and limits explicit, and state the rule for when they may change.

### Phase 7 — Self-review against the checklists

Run the document through every checklist below. Fix what fails before declaring done. This phase is not optional; first drafts always fail at least one checklist.

---

## Quality Checklists

Copy the relevant checklist and verify each item. A document ships only when all apply.

### Structure

- [ ] The document's identity and authority are stated in the first sentence.
- [ ] Each fact appears in exactly one place; everything else cross-references it.
- [ ] No topic is owned by two sections.
- [ ] Sections are ordered so each depends only on earlier ones.
- [ ] Terms are defined before they are used.
- [ ] Sibling documents and their owned topics are listed and linked.

### Signal-to-noise

- [ ] Every sentence states a fact, a rule, or a reason. Delete the rest.
- [ ] No throat-clearing ("It is important to note that", "As mentioned above", "In order to").
- [ ] No hedging ("basically", "essentially", "kind of", "should probably") unless the uncertainty is the point.
- [ ] Paragraphs cover one idea each and are short.
- [ ] Every section would change what the reader does; cut sections that don't.
- [ ] Rationale is a clause, not a paragraph.

### Information density

- [ ] Math is in formula blocks, not sentences.
- [ ] Repeated-attribute data is in tables.
- [ ] Enumerable facts are in lists, not run-on prose.
- [ ] Structure, hierarchy, and data flow use diagrams.
- [ ] Data and interface shapes use typed blocks.
- [ ] Surviving prose expresses relationships and reasoning, not enumerable facts.

### Precision and naming

- [ ] Identifiers carry units and frames where they could be ambiguous.
- [ ] Requirement strength is explicit and consistent (`must` / `must not` / `may` / `should`).
- [ ] Easily-conflated concepts are named and explicitly kept distinct.
- [ ] No vague pronouns ("this", "it") without a clear, nearby referent.
- [ ] One term per concept throughout; no synonym drift.

### Scope and boundaries

- [ ] Scope and non-goals are explicit.
- [ ] Each component has a "must not" / "does not own" boundary.
- [ ] Accepted trade-offs and simplifications are stated, not implied.
- [ ] Over-engineering risks carry an explicit "do not build X yet" note.

### Testability

- [ ] Properties are observable and falsifiable, not adjectives.
- [ ] Normative docs include numbered acceptance criteria or required tests.
- [ ] Limits, tolerances, and thresholds are explicit, with a rule for changing them.

---

## Common Smells (fix on sight)

- **Duplicated facts.** The same number or rule stated in two places. Keep one, link the rest.
- **Narrating instead of specifying.** "The function loops over the items and processes each one." Specify behavior, contracts, and invariants, not a play-by-play.
- **Prose where a table belongs.** Three or more items compared in sentences. Tabulate them.
- **Undefined or drifting terms.** A key noun used before definition, or three words for one concept.
- **Unbounded scope.** No non-goals, no "must not", no stated trade-offs. The reader cannot tell where the thing ends.
- **Untestable adjectives.** "Fast", "robust", "scalable", "clean" with no observable definition.
- **Buried lede.** The key rule sits in the third paragraph instead of the first sentence.
- **Hedging and filler.** Words that carry no information. Delete them.
- **Mixed requirement strength.** "Should" used for a hard rule, or "must" for a nicety. Calibrate.

---

## Document Type Quick Reference

Match the document to its job. Full scaffolds are in `templates.md`.

| Document | Job | Hallmarks |
| --- | --- | --- |
| **Specification / model** | Define the exact, opinionated rules of a system | Numbered sections, formulas, canonical data shapes, deliberate-simplifications list |
| **Architecture / systems** | Define components, ownership, and dependency rules | Per-system responsibilities/inputs/outputs, "must not" lists, dependency rules, diagrams |
| **Invariants / rules** | Define non-negotiable, testable properties | "must"/"must not" statements, tolerances, a numbered required-test list |
| **Roadmap / phased plan** | Sequence work into verifiable increments | Status legend + table, per-phase Deliverables / Excludes / Acceptance |
| **README** | Orient a newcomer and route them to detail | What/why, scope, "why this is hard", links to the authoritative docs |
| **RFC / ADR** | Propose a change and record the decision | Context, options with trade-offs, the decision, consequences |
| **Runbook** | Drive an operator through a procedure | Numbered steps, exact commands, expected output, rollback |
| **API reference** | Specify a contract | Signature, params with units/types, returns, errors, example |

---

## Worked Mini-Example

**Before** (low signal, narrated, untestable):

> It's important to note that the rendering system is basically responsible for
> taking the simulation data and then it will render it to the screen. It should
> be pretty fast and it shouldn't really modify the simulation since that could
> cause bugs. There are a few different things it handles like cameras and meshes
> and so on.

**After** (BLUF, dense, bounded, testable):

> The Rendering System consumes immutable simulation snapshots and produces frames.
> It owns Three.js scenes, cameras, meshes, and render passes.
>
> It **must not** write to canonical simulation state: the simulation must remain
> correct if the entire scene is destroyed and rebuilt from the latest snapshot.
>
> Target: a full frame in under `16 ms` at p99 on the reference hardware.

The rewrite leads with the rule, names what it owns, bounds it with an explicit
`must not` plus the consequence, and replaces "pretty fast" with a falsifiable target.

See `patterns.md` for the full catalog of these rewrites.

---

## When to Use

Use this skill whenever the task is to write, structure, tighten, or review a
technical document: a spec, design or architecture doc, set of invariants or
rules, roadmap, README, RFC/ADR, runbook, or API reference. Apply the workflow
when authoring from scratch and the checklists when revising existing text.

## Limitations

- This skill governs *how* to write, not domain correctness. Verify facts, numbers, and APIs against the actual system.
- Density is a means, not an end. Never drop a necessary explanation to hit a smaller line count.
- For end-user or marketing prose, prefer a copywriting-oriented approach; this skill targets engineering readers.

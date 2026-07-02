---
name: beans
description: Creates and optimizes high-quality beans for implementation planning. Must be used whenever the user asks to create beans, optimize beans, plan work as beans, split tasks into beans, add bean dependencies, or improve a bean set.
license: MIT
compatibility: opencode
metadata:
  category: planning
  workflow: beans
---

# Beans

General-purpose workflow for turning requirements into complete, atomic, executable beans.

## Preconditions

- Reread relevant `AGENTS.md` instructions before creating or editing beans.
- Read source requirements, linked docs, issue text, code context, and existing beans until the work domain is clear.
- If a `beans` tool exists, use ONLY that tool to create, update, close, and link beans. Do not simulate beans in markdown unless no beans tool is available.
- Operate in plan space before implementation. Do not simplify away scope, behavior, tests, docs, or validation.

## Bean Quality Bar

Every bean must be:

- **Atomic:** one executable unit with a clear done state.
- **Complete:** enough context to execute without consulting original docs.
- **Specific:** concrete files, behavior, interfaces, commands, edge cases, and constraints where known.
- **Sequenced:** dependency links express what must happen first.
- **Validatable:** includes unit, integration, e2e, logging, docs, or manual checks as applicable.
- **User-centered:** preserves all required features and avoids hidden regressions.

## Creation Workflow

1. Inventory all source material.
2. Extract user-visible requirements, non-functional requirements, constraints, and exclusions.
3. Identify hidden work: migrations, docs, tests, telemetry/logging, rollout, cleanup, backward compatibility, edge cases, failure modes, permissions, accessibility, performance, security, and operational validation.
4. Build a dependency graph before creating beans.
5. Split work until each bean is independently assignable and has a crisp completion condition.
6. Create implementation beans first, then validation/documentation beans, then cleanup/rollout beans.
7. Add dependency links immediately after creating related beans.
8. Run polishing passes until no useful changes remain.

## Bean Template

Use this structure inside each bean when the beans tool supports rich descriptions:

```markdown
## Goal
[Concrete outcome and why it matters]

## Scope
- Include: [specific work]
- Exclude: [nearby work intentionally out of scope]

## Implementation Notes
- [Files/modules/interfaces/behavior]
- [Constraints and sequencing concerns]
- [Compatibility or migration notes]

## Edge Cases
- [Failure mode, unusual input, state transition, permissions, concurrency, etc.]

## Validation
- [Unit tests]
- [Integration/e2e tests or scripts]
- [Logging/observability expectations]
- [Manual checks if automation is not feasible]

## Done
- [Observable completion criteria]
```

## Dependency Rules

- Dependencies must represent real sequencing constraints, not vague grouping.
- Foundation before consumers: schema, types, API contracts, shared utilities, feature flags, test fixtures.
- Implementation before validation only when validation cannot be written first.
- Docs depend on final behavior unless docs drive the implementation contract.
- Cleanup depends on replacement behavior and tests being complete.
- Avoid dependency cycles. If a cycle appears, split a bean or extract a shared prerequisite.

## Polishing Passes

Repeat these passes until the bean set stops changing:

1. **Coverage pass:** compare beans against all requirements; add missing work.
2. **Atomicity pass:** split vague or multi-outcome beans.
3. **Redundancy pass:** merge duplicates only when their done states are identical.
4. **Sequencing pass:** add, remove, or correct dependencies.
5. **Validation pass:** ensure every implementation path has tests/checks/logging.
6. **Clarity pass:** tighten titles, descriptions, edge cases, and done criteria.
7. **Execution pass:** verify the graph can be implemented in a sensible order.

## Title Style

- Start with an imperative verb: `Add`, `Fix`, `Implement`, `Validate`, `Document`, `Remove`, `Migrate`.
- Name the concrete target: component, endpoint, module, workflow, script, or behavior.
- Avoid vague titles: `Improve system`, `Handle edge cases`, `Tests`, `Cleanup`.

## Validation Expectations

- Include comprehensive unit tests for logic-heavy changes.
- Include integration/e2e scripts for critical user flows.
- Add detailed logging to test scripts where useful for diagnosing failures.
- Include negative tests and boundary cases, not only happy paths.
- If a test is impossible or not worth automating, state the manual validation explicitly.

## When Editing Existing Beans

1. Audit each bean for sense, optimality, scope, and user value.
2. Close invalid or inapplicable beans rather than leaving stale work.
3. Revise beans that are underspecified, overbroad, obsolete, or missing validation.
4. Preserve useful existing dependency structure, but correct anything misleading.
5. Re-run all polishing passes after edits.

## Do Not

- Do not collapse distinct deliverables into one large bean.
- Do not omit tests, docs, migration, rollout, or cleanup because they feel secondary.
- Do not create placeholder beans with no execution detail.
- Do not leave requirements only in source docs; copy needed context into beans.
- Do not overfit dependencies to preferred order when work can safely run in parallel.

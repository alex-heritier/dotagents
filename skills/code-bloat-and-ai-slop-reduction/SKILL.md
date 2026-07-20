---
name: code-bloat-and-ai-slop-reduction
description: Review code, diffs, refactors, architecture proposals, and AI-generated implementations for unnecessary complexity, overengineering, accidental frameworks, speculative robustness, defensive code, and bloat. Treat code as a liability and apply YAGNI and KISS. Prioritize correctness, then deletion and net-negative diffs that preserve behavior, contracts, security, and observability. Use for diffs, refactors, MVPs, tests, migrations, CLIs, APIs, infra, benchmark harnesses, and reduction passes. Produce a verdict, ranked findings, metrics, invariants, and a deletion ledger. LGTM is a valid result.
---

# Code Bloat and AI Slop Reduction

Find the **minimum sufficient engineering**: the smallest clear implementation that truthfully satisfies current requirements, preserves important contracts, fails visibly, protects real boundaries, and adds no speculative machinery.

Code is a liability as much as an asset. Every maintained line can hold a bug; every branch is another execution path; every state is more invalid combinations; every abstraction, option, dependency, and layer is one more thing to learn, test, document, and break; every fallback can hide failure; every public interface may need support forever.

So:

- **New code must justify itself.** "Technically defensible" is not enough.
- **Existing code must keep justifying its existence.**
- The highest-leverage outcome is often a **behavior-preserving net-negative diff**: the required behavior reached with fewer lines, concepts, branches, states, options, dependencies, and tests — and fewer places to fail. That, not "added a correct implementation," is the holy grail.
- A line removed is not automatically good. A line removed **while preserving required behavior** permanently removes bug surface, review cost, and cognitive load.

The target is **less total system complexity, not fewer visible lines.** Reduce concepts aggressively; preserve contracts obsessively. Simplicity (KISS) is judged by what the next maintainer can understand and change, so **brevity is not simplicity**: a cryptic one-liner or clever metaprogramming that shortens the diff while hiding intent is a regression, not a win.

## Optimize in this order

Correctness → simplicity → clarity → deletion → locality → debuggability → extensibility (only for a current, concrete need).

Never trade away correctness, security boundaries, data integrity, explicit public contracts, expected return/query shapes, or meaningful observability for brevity. **Minimum code does not mean minimum care.** YAGNI targets presumptive *features*, not the work of keeping code easy to change — refactoring toward simplicity is always in scope, and "YAGNI/simplicity" is never an excuse to ship rigid code or skip a warranted refactor.

## Default assumptions (unless the repo proves otherwise)

- Keep the system sized to the **current** deployment, not hypothetical scale.
- **Build for a demonstrated need, not an anticipated one (YAGNI).** A *presumptive feature* — code for a future that hasn't arrived — is the default thing to cut; it charges four costs now: build, delay (what you didn't build instead), carry (it taxes every later change while unused), and repair (if the guess is wrong). "We might need it" is not a need.
- Reuse existing primitives before adding abstractions; prefer the **boring, idiomatic, standard** solution over a clever one (KISS).
- Manual recovery can be valid; a rare, cheap manual step beats a permanent subsystem.
- Visible failure usually beats silent fallback. A trusted internal bug should crash loudly, not become misleading output.
- A local bug does not justify a broad refactor.
- A little duplication can beat a premature abstraction.
- A reduction pass is a new diff: fewer lines do not imply fewer bugs. Review it from scratch.

---

# Procedure

## Deletion hierarchy

Don't start from "what architecture should we add?" Start from "what code, behavior, state, branch, or concept can disappear?" Take the first option that works:

1. Remove the feature or requirement entirely.
2. Delete obsolete or dead behavior.
3. Use an existing primitive (column, query, function, library, db/OS feature).
4. Collapse two code paths into one.
5. Eliminate a state, branch, parameter, abstraction, option, or dependency.
6. Make invalid states impossible instead of handling them.
7. Replace rarely used automation with a manual workflow.
8. Solve it with one local conditional, direct call, or query.
9. Only then: write the smallest new code required.

## Review in three passes

**Before** — write one sentence each for:

- The exact bug or requirement. Don't let a proposed architecture redefine a small problem into a large one ("prevent two workers from claiming one job" is not "build a distributed job system").
- Behavior, security properties, and data contracts that must survive.
- What is explicitly out of scope.
- Expected deletion boundary, files touched, acceptable concept/LOC growth, and whether a net-negative diff should be possible.

**During** —

- **Trace the concern both directions** (see Dependency tracing). Watch for **parameter spread**: one optional arg threaded through several signatures usually means the feature is misplaced, premature, or deletable — don't "fix" it with a context object.
- **Count concepts and states added vs removed** (see Metrics); compare problem size to fix size.
- Hunt the high-signal failures: fake success, semantic fallback, hidden errors, broken score/aggregation invariants, changed query/return shapes, lost security flags, unrelated churn.
- For each change ask: can this be achieved by **deleting** code instead?

**After (mandatory whenever the diff reduces code)** — re-review from scratch and re-check Invariants. Confirm:

- [ ] No stub, fixed score, empty result, `pass`, or fake success replaced real behavior.
- [ ] No core end-to-end path became `xfail`/`skip`; assertions were consolidated, not dropped.
- [ ] Deleted features are gone from registration, callers, weights, config, tests, and docs.
- [ ] Query and return shapes still satisfy surviving callers.
- [ ] Security properties and useful error/observability remain.
- [ ] The diff is genuinely easier to understand and **total** complexity fell — not just LOC.
- [ ] The **core end-to-end path** was run, not only helper unit tests.

## Specify every deletion precisely

Coding agents apply reduction literally and will weaken behavior to satisfy a vague request. For each deletion recommendation, state all six:

1. **The exact defect.**
2. **The deletion boundary** (files, registrations, states, config, callers, tests).
3. **Behavior that must survive**, and its invariants.
4. **Co-removals/updates**: callers, registrations, weights, configuration, documentation.
5. **Prohibited substitutes**: stub, fixed score, fallback, `pass`, `return True/[]`, `xfail`, placeholder.
6. **Verification**: the focused test or command proving it still works.

> Good: "Remove the benchmark directory and its suite registration and category weight. Preserve correct 0–100 aggregation for remaining categories. Do not replace it with a stub grader, fixed score, skipped test, fallback, or placeholder category. Run one full suite summary."

> Good: "Revert the repository file, then add only `expected_status` support. Do not change query columns, ordering, date handling, argument order, row conversion, duplicate checks, or formatting."

## Dependency tracing

A deletion is incomplete while dead support code, registration, weights, config, tests, or docs remain.

- **Upstream (who needs it):** callers, CLI commands, routes, jobs, tests, config that enables it, docs that promise it.
- **Downstream (what it needs):** helpers, db columns/tables, serializers/result fields, imports, exceptions, fixtures that exist only for it.
- **Adjacent survivors (must keep working):** functions sharing its query, callers relying on its return shape, helpers still used by audit/read paths, security controls inside a subsystem you're removing.

---

# Decisions

## Classify each change

Put every meaningful change in one bucket.

**Keep** — it prevents a reproducible crash, data corruption, wrong output, security exposure, lost write, or contract/score violation, at the smallest size that does so.

**Delete the feature when** it has no current caller/user; its only consumer is a test or a newly added abstraction; it serves a hypothetical future; its output can't be measured or trusted; it silently falls back to different semantics; manual handling is cheaper; it needs heavy support code for marginal value; it can't be tested credibly; it duplicates existing behavior; its core e2e test is permanently skipped/`xfail`; or its implementation is a stub that lies about success.

**Collapse the abstraction when** it has one implementation or one consumer; forwards args without interpreting them; only renames a type or wraps a direct call; exists to look layered; has more support code than domain logic; needs flags/mode switches for divergent cases; or removing it shortens the call chain without mixing responsibilities.

**Inline the helper when** it's used once; its name adds nothing beyond the code; it hides a simple condition; understanding it requires jumping files; or it exists only to dedupe a few visual lines.

**Keep duplication when** the repeated code is small; the cases may diverge; the abstraction would need flags/branching or would obscure behavior; or it would couple concepts and need docs longer than the duplication.

**Defer when** the issue is real but unlikely, manual recovery is cheap, the future need isn't concrete, or the fix would add significant machinery.

**Incomplete or partial features are not slop by default.** Do not delete, rewrite, or label them as bloat merely because they are unfinished. Mark each detected incomplete or partial live feature with a clear `// TODO <message>` comment at the narrowest relevant code location, and notify the user with a simple list of those features.

**Major side-effect changes need explicit markers.** If a reduction changes behavior with operational side effects — especially DB migrations, schema/data movement, destructive cleanup, queue/job semantics, external integrations, or irreversible user-visible behavior — mark the relevant code path with a clear `// TODO <message>` comment and notify the user with a simple list of those side-effect risks.

**Prefer a net-negative fix when** a bug comes from duplicated paths or ambiguous fallback; legacy compatibility is no longer required; two state machines can merge; a custom subsystem can become a language/library/db/OS primitive; the requirement is met by removing invalid states; or a category can't be implemented truthfully and should be removed.

## Failure and recovery defaults

| Fork | Default | Take the other branch only when |
|---|---|---|
| Loud failure vs graceful handling | **Loud** (`raise`) for trusted-internal defects | the input is expected-invalid external input the caller can recover from |
| Manual vs automated recovery | **Manual** when failures are rare, state is inspectable, recovery is one admin/db action | expected `incidents × recovery time` clearly exceeds `build + maintain + debug` time |
| Stub vs explicit removal | **Remove** the feature, registration, and surface | the limitation is intentionally supported, non-core, and documented (then it isn't a stub) |
| Revert-and-reapply vs incremental edit | **Revert + reapply** when a file got broad churn but needs one local change | the broad change is itself the required, in-scope work |
| Deterministic grader vs AI judge vs delete | **Deterministic** for contract facts | qualitative work → judge; can't grade credibly → delete the benchmark |

---

# Detection

## AI slop signatures

| Signature | Tell | Default action |
|---|---|---|
| Speculative machinery | distributed lock/lease/ownership for one process; pluggable backend or policy with one impl; circuit breaker/retry without observed instability; auto-recovery for rare, manually-fixable failures | delete or defer; a conditional or existing primitive usually suffices |
| Accidental framework | a local fix becomes a manager/registry/provider/event/lifecycle system | ask whether one function or conditional solves the actual problem |
| Fake success | `return True`/`[]`/fixed score/stub; HTTP 200/202 for work whose precondition can already be false; `# stub`/`# temporary` on registered code | remove the feature + registration, or fail explicitly — never fabricate success |
| Hidden failure | `except Exception: return default/pass/FailedResult(...)` on trusted code; semantic fallback (same type, different meaning) | let trusted defects raise; delete the fallback (don't paper over it with provenance fields) |
| Runtime schema repair | `if column_missing: ALTER` where migrations exist | one migration path; fail clearly on stale schema |
| Config without an operator | env vars/flags/limits/strategies/feature-flags nobody sets | hard-code current behavior until a 2nd real use case appears |
| Custom parser/serializer | ad-hoc HTML/SQL/URL/header/template/citation parsing | use a library, remove the feature, or accept a manual workflow |
| Tests inventing requirements | assert file length, mandatory abstractions/naming/structure, style-as-correctness, fake deterministic grading of qualitative work | test only the written contract; tie each assertion to a requirement |
| Defensive duplication | same validation/timeout/retry at every layer with no distinct trust boundary | validate once at the meaningful boundary |
| `SELECT *` / silent field filtering | `SELECT *` "to simplify"; `Model(**{k:v ... if k in known})` | keep explicit field lists; let schema/type drift fail visibly |
| Hidden core path | new `xfail`/`skip` on the main e2e path during a refactor | fix or remove the feature; don't green the suite by hiding it |
| Unrelated churn | quote/format churn, arg reorder, query rewrite, date-handling change in a file that needed one local edit | revert and reapply only the needed change |
| Security collateral | deleting a security subsystem also drops cookie `Secure/HttpOnly/SameSite`, authz, secret scrubbing, path-traversal checks, parameterized SQL, network denial | remove machinery, keep the direct controls |
| Broken score invariant | sections total ≠ declared max; deleted category still weighted; errors scored as success | re-verify arithmetic (see Invariants) |

## Invariants — check before and after reduction

- **Scorer/benchmark:** a perfect answer can reach the declared max; invalid answers can't pass; sections total to the max; category weights stay correct after deletions; pass thresholds stay meaningful; errors aren't scored as success.
- **Repository/query:** selected fields stay compatible with surviving callers; ordering, null, and uniqueness behavior preserved; return shape stable; schema/type drift not silently hidden; explicit field lists not broadened.
- **Route:** every route returns a response; accepted requests can actually succeed; rejected requests fail before spawning doomed work; auth and cookie attributes intact; status codes truthful.
- **Background worker:** only one worker claims work when required; a worker can't report success after losing ownership; failures stay visible; manual reset stays possible if auto-recovery is omitted; the API doesn't ack work that can't proceed.
- **Sandbox:** children can't inherit secrets; network/write boundaries restricted; timeouts kill descendants; the intended runtime still works; core e2e tests not hidden with `xfail`.
- **Tests:** important assertions remain; tests enforce the written contract, not one implementation; no no-assertion tests; broad `raises(Exception)` is suspect; simplification consolidates mechanics, not coverage.

## Metrics

Read these together; none alone is a verdict. Never emit a fake-precise quality score.

| Metric | Compute | Suspicious | Common false positive |
|---|---|---|---|
| Bug:fix ratio | fix LOC ÷ bug LOC | > ~10× | genuinely cross-cutting fix |
| Impl:test ratio | test LOC ÷ impl LOC | very high, or tests assert structure | parsers/security legitimately need many cases |
| Concept Delta | concepts in − concepts out | > 0 for a small bug | a real new feature |
| Concern Propagation | layers touched by one concern | > 2–3 without cause | true cross-layer contract change |
| Parameter Spread | signatures carrying a new param | > 1–2 | param genuinely interpreted at each layer |
| Files per behavior | files touched ÷ behaviors changed | high | deliberate mechanical rename |
| Unrelated churn % | out-of-scope changed lines ÷ total | > 0 | the churn *is* the task |
| One-impl abstractions | interfaces/factories/registries with < 2 real consumers | > 0 | enforces a real, tested boundary |
| Fake-success count | stubs/fixed returns/`return True\|[]` in live paths | > 0 | none — always investigate |
| Hidden-failure count | broad `except`→default + semantic fallbacks | > 0 | expected external-input handling |
| Disabled-coverage count | new `xfail`/`skip` + removed/empty assertions + broad `raises` | > 0 on a core path | intentional, documented non-core skip |
| Safety regressions | changed surviving contracts + query/return-shape changes + removed security + leftover registration/config/docs + broken invariants | ≥ 1 | none — blocks approval |

Counts (fake-success, hidden-failure, disabled-coverage, one-impl, files-per-behavior, churn %, safety regressions) are automatable gates. Ratios and the signals below need human judgment.

```text
Concept Delta = new concepts − removed concepts
    (count classes, interfaces, states, transitions, config keys, flags,
     db columns/tables, deps, public fns, optional params, fallback/retry/recovery paths)
    > 0 for a small change → bloat

Reduction Yield = useful concepts removed / (new concepts + 1)
    < 1 in a "simplification" → suspect

Behavior-Preserving Deletion Ratio = verified exec lines removed / total changed exec lines
    high + invariants intact → strong positive signal

Accidental Framework Signal = new abstractions + new config + new states + new recovery paths,
    for one stated behavior
    0 low · 1–2 inspect closely · 3–4 likely bloated · 5+ severe accidental framework
```

When weighing Concept Delta, weight new states, public APIs, db schema, config, dependencies, cross-layer params, and recovery paths higher than ordinary code — but keep the weighting explainable; do not compute a 0–100 score.

## Anti-gaming

A net-negative diff is not automatically good. Reject "reductions" that reach negative LOC by: replacing behavior with stubs/fixed success/empty defaults; disabling tests or removing assertions; hiding failures; dense unreadable code or metaprogramming; `SELECT *`; hiding behavior behind a generic framework; removing security checks; deleting docs for behavior that still exists; moving complexity into config, generated code, dependencies, SQL, or templates; or merging unrelated concepts into one ambiguous function. The target is less total complexity, not fewer visible lines.

## Ask on every change

- What can be deleted instead of fixed? What can be made impossible instead of handled?
- Which fallback should become explicit failure? Which wrapper/helper can become a direct call or inline?
- Which subsystem can be removed entirely? Which feature is still registered but no longer works?
- Which query/return shape or security control changed without need?
- Can this finish net-negative? If not, what concrete product behavior justifies the growth, and what future bug becomes impossible if we remove code instead?

---

# Transformations

Before → minimal, plus the trap to avoid.

- **Duplicate background work:** `job_id` + leases + ownership + claim/complete + recovery command  →

```sql
UPDATE proposals SET status='running' WHERE id=? AND status='ready'
```

proceed iff one row changed; manual reset is fine. *Trap:* don't keep an API returning 202 when the worker's precondition can already be false.

- **Judge/parse fallback:** on failure, substitute a heuristic/stale/empty result of the same type  →  fail ("no score produced"). *Trap:* don't add `scoring_method`/provenance to legitimize mixing methodologies.
- **Runtime schema repair:** `if column_missing: ALTER`  →  numbered migrations; fail startup on stale schema. *Trap:* don't swallow db errors.
- **Ungradable benchmark:** weak regex grader  →  delete dir + suite registration + category weight; redistribute weights. *Trap:* never `return {"score":100,"passed":True}` or leave a `# stub`.
- **Local repo fix buried in churn:** broad rewrite (`SELECT *`, reorder, date change, field filtering)  →  revert; add only `expected_status` and its `WHERE status=?`. *Trap:* don't change query/return shape for surviving callers.
- **Exception taxonomy:** many one-use exception classes that only change a message  →  `raise` directly; CLI exits nonzero from the raise. *Trap:* keep useful error text and the operation id (slug/ID).
- **Test simplification:** delete assertions to shorten  →  parametrize + shared fixtures, keep every contract assertion. *Trap:* don't `xfail` the core e2e path.

---

# Output

Sort findings by urgency and impact. Don't invent low-value issues; `LGTM` is a valid verdict for already-simple, correct code.

1. **Verdict** — LGTM · minor fixes · correct but bloated · not merge-ready · fundamentally overengineered. Name the main source of complexity.
2. **Diff summary + key metrics** — net LOC, Concept Delta, and any suspicious signals.
3. **One-sentence problem statement.**
4. **Confirmed correctness/security bugs** — severity, file, concrete failure, smallest fix.
5. **Deletion ledger** — one row per target: action (delete / collapse / inline / keep / defer / out-of-scope) · behavior preserved · co-removals (callers, registration, weights, config, tests, docs) · prohibited substitutes · verification · est. concepts/LOC removed · failure surface eliminated.
6. **Minimal target** — what the implementation should look like after reduction, with the net-reduction estimate (files, LOC, concepts, functions, params, states, config, deps removed).
7. **Incomplete/partial features and side-effect TODOs** — simple list of any live incomplete or partial features and any major side-effect risks detected, each with the `// TODO <message>` marker that was or should be added. Omit this section when none exist.
8. **Answer four questions:** Did total complexity drop? Did failure surface drop? Did any contract get weaker? Could the diff be net-negative — and if not, what concrete product behavior justifies the growth?

**Severity:** *Critical* — security/secret exposure, data corruption, broken core route, startup failure, wrong authoritative score, destructive behavior. *High* — common crash, stuck workflow, wrong state transition, silent semantic fallback, hidden internal error shown as normal output, major contract mismatch. *Medium* — real but limited bug, misleading config, excessive subsystem without immediate failure. *Low* — use sparingly; never pad a review.

Be direct: "Delete the `Budget` subsystem; it threads optional state through four layers and isn't needed for correctness," not "consider whether the budget abstraction might be simplified later."

---

# Keep this skill accretive

After a review, fold a new lesson back in **only if** it generalizes beyond one repo, materially changes review quality, isn't already covered, and fits as a short rule, check, metric, or example. Merge it into the relevant section — don't append anecdotes. Good candidates: a new slop signature, a reduction-failure pattern, a misleading metric, a new invariant category, an agent-prompt ambiguity that caused bad behavior, or a documented false positive. Prefer editing an existing line to adding one; this skill is held to its own deletion hierarchy.

# The standard

Not "could this be useful someday?" but **"is this the smallest clear implementation justified by the system today?"** And for reduction, not "did the diff get shorter?" but **"did the system lose unnecessary concepts while truthfully preserving behavior, invariants, observability, and security?"**

When unsure: delete code, preserve explicit contracts, fail visibly, and add complexity only after a real need appears. Every unnecessary line removed is failure surface removed.

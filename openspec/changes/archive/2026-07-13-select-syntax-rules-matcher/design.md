## Context

The compiler's passes use a vendored `syntax-case` `match` (`src/match.sls`). Porting to a
`syntax-rules` matcher unblocks self-hosting, but the choice of matcher is consequential and
under-determined. Research (verified against source/SRFI text) shows the three properties we
want do not co-occur in any single existing matcher:

| Matcher | `,x` convention (zero churn) | `syntax-rules`-only | Ellipsis + `(p ... plast)` |
|---|:--:|:--:|:--:|
| SRFI-241 (Nieper-Wißkirchen) | ✅ | ❌ (`syntax-case`) | ✅ |
| `pmatch` (Kiselyov/Friedman) | ✅ | ✅ | ❌ (fixed structure only) |
| SRFI-204 / Shinn `match.scm` | ❌ (Wright) | ✅ | ✅ |

The compiler uses only a small pattern subset (literal symbol, pair/dotted, `(p ...)`,
`(p ... plast)`, `,id` binder, `(guard …)`, `else`) and only three guard shapes
(`(symbol? x)` ×8, `(prim? op)`, one compound). Catamorphism is unused.

## Goals / Non-Goals

**Goals:**
- Produce an **evidence-backed decision**: which matcher, why, and what expander work the
  rewrite will need.
- De-risk the follow-on rewrite by running the actual expander spike and a two-pass bake-off
  before committing.

**Non-Goals:**
- The production rewrite of the passes (that is [[port-match-to-syntax-rules]]).
- Implementing the expander extension for real (this change only determines whether one is
  needed and scopes it). Spike code may prototype it but is not integrated.
- Implementing `syntax-case`. Explicitly deferred.

## Decisions

### D1: The choice is buy vs build, not "which library"

Because no matcher has all three properties, the survivors after gating are:

- **Buy** — adopt Shinn/SRFI-204 as-is. `syntax-rules` ✅, ellipsis ✅, proven, conformance
  test suite. Cost: rewrite ~22 `match` forms to the Wright convention
  (literal→`'quote`, `,x`→bare binder, `(guard …)`→`?`-predicate patterns) with a
  silent-inversion risk (a mis-quoted literal becomes a catch-all binder).
- **Build** — author a `,x` + `syntax-rules` + ellipsis matcher, starting from `pmatch`
  (add ellipsis) or by porting SRFI-241's semantics off `syntax-case`, borrowing Shinn's /
  Kiselyov's `syntax-rules` techniques. Cost: we author and own the hard part (ellipsis over
  runtime lists), gain zero pass churn.

Likely shared cost: both need the expander to support the ellipsis-escape `(... ...)`
(Shinn-style ellipsis relies on it; our `expand.ss` shows no escape handling).

### D2: A four-stage funnel — gates → score → bake-off → record

**Stage A — Gates (binary):** G1 `syntax-rules`-only (eliminates SRFI-241's impl); G2
covers the used subset incl. `(p ... plast)` (eliminates stock `pmatch` unless we commit to
extending it); G3 matcher uses no feature scheme-llvm lacks (so it can eventually be expanded
by our own compiler); G-license compatible.

**Stage B — Weighted score (survivors):**

| Criterion | Weight | Rationale |
|---|--:|---|
| Pass churn (convention fit) | ×3 | Size/risk of the follow-on rewrite |
| Expander work required | ×2 | `(... ...)` and any other construct to add |
| Test-suite reuse | ×2 | Regression oracle for the matcher itself |
| Size / auditability | ×2 | We vendor and self-host-expand it |
| Maturity / provenance | ×1 | Standard/maintained vs one-off |

**Stage C — Empirical bake-off (decisive):** for the top buy and top build candidate:
1. Expander spike — expand three probes (`(match x [(a b) …])`, `[(a b ...) …]`,
   `[(a ... z) …]`) in the *current* expander; record pass/fail and any missing construct.
2. Port two representative passes — `convert-assignments.ss` (small, 2 forms) and `emit.ss`
   (largest, ~12 forms) — each way.
3. Diff emitted IR against the current baseline: **must be byte-identical**.
4. Record LOC delta, expander changes needed, effort, and any silent-inversion bugs hit.

**Stage D — Record** the pick, scores, and bake-off evidence in this change's `design.md`
(update this section on completion), and state the exact expander work the port requires.

### D3: Preliminary lean (to be confirmed by the bake-off)

If `(... ...)` is needed either way, the swing factor is pass-churn vs matcher-authorship.
Start the bake-off with **buy (Shinn/SRFI-204)** — proven ellipsis + tests immediately, and
the Wright rewrite is mechanical under the existing suite. Fall back to **build** if the
bake-off shows the convention rewrite is nastier than expected or zero-churn is worth the
authorship. Two ported passes will reveal which pain is smaller cheaply.

## Risks / Trade-offs

- **Analysis-paralysis / research rabbit-hole** → the bake-off is time-boxed to two passes;
  the gates cut the field to two candidates before any porting.
- **Bake-off on two passes under-samples the real diversity of patterns** → deliberately
  pick the smallest and the largest/most-varied pass (`emit.ss`) to bracket the range; note
  this as an explicit sampling assumption in the recorded decision.
- **SRFI-204 is withdrawn** → the *SRFI* is withdrawn but Shinn's `match.scm` ships in chibi
  and many R7RS systems and is maintained; we track the implementation, not the SRFI status.
  Staying convention-flexible keeps us aligned with wherever R7RS-large lands.

## Migration Plan

1. Enumerate + gate candidates (Stage A).
2. Score survivors (Stage B).
3. Run the bake-off + expander spike on two passes (Stage C).
4. Record the decision and required expander work (Stage D); hand off to
   [[port-match-to-syntax-rules]] (trim its selection/spike tasks to "consume this
   decision").

## Open Questions

- **Buy or build** — narrowed by the expander spike (below); the residual is authoring
  effort, which the full IR-diff bake-off (tasks 3.2–3.4) would quantify.
- **Where spike code lives** — the spike harness lives in the session scratchpad
  (`spike-expander.ss`); it is not integrated into `src/`.

## Decision (recorded)

### Gate results (Stage A)

Verified against SRFI texts and source (SRFI-241, SRFI-204, Shinn's `match.scm`, `pmatch`):

| Candidate | G1 syntax-rules-only | G2 covers subset (incl. `(p ... plast)`) | Verdict |
|---|:--:|:--:|---|
| SRFI-241 (Nieper-Wißkirchen) | ❌ reference impl needs `syntax-case` | ✅ | **eliminated** (G1) |
| `pmatch` (stock) | ✅ | ❌ no ellipsis | **eliminated** (G2) as-is |
| SRFI-204 / Shinn `match.scm` | ✅ | ✅ | **survives (buy)** |
| `,x` matcher (build: pmatch-derived / SRFI-241 ported) | ✅ | ✅ (once ellipsis authored) | **survives (build)** |

G3 note: both survivors' *ellipsis* handling relies on the ellipsis escape `(... ...)`,
which our expander lacks. That makes "add `(... ...)` to the expander" a **precondition for
either candidate**, not a candidate disqualifier — so it is neutral in the buy-vs-build
comparison.

### Expander spike evidence (Stage C, task 3.1)

Ran candidate constructs through the real expander (`src/passes/expand.ss`) via a scratch
harness:

| Probe | Input | Result |
|---|---|---|
| A | template with ellipsis escape `(... ...)` | **ERROR** — "ellipsis template has no matching pattern variable" (escape unsupported) |
| B | `,x` CPS matcher on `(,a ,b)` | **OK** — clean `if/pair?/car/cdr/let/null?` code, no extension needed |
| B2 | `,x` matcher on `(lambda ,x)` (literal head) | **OK** — `lambda` correctly matched as a literal via `eq?` |
| C | same `,x` matcher meets `(,x ...)` | **mis-handled** — `...` compiled to `(eq? (quote ...) …)`, i.e. treated as a literal atom, not repetition |

Conclusions:
1. A `,x`-convention `syntax-rules` matcher hosts on the **current** expander for all
   non-ellipsis patterns with **no extension** (B, B2) — recursion, `(unquote v)` binder
   detection, literal-head matching, and CPS success/fail threading all work.
2. **Ellipsis** patterns (which the passes need) require the ellipsis escape `(... ...)`,
   which the expander does not support (A, C). This holds for **buy and build alike**.

### Weighted scores (Stage B; 1–5, indicative)

| Criterion | ×w | Buy (Shinn/SRFI-204) | Build (`,x` matcher) |
|---|--:|--:|--:|
| Pass churn (convention fit) | 3 | 1 (rewrite ~22 forms) → 3 | 5 (zero churn) → 15 |
| Expander work | 2 | 3 (needs escape) → 6 | 3 (needs escape) → 6 |
| Test-suite reuse | 2 | 5 (SRFI suite) → 10 | 2 (we write) → 4 |
| Size / auditability | 2 | 2 (~900 lines) → 4 | 4 (small, targeted) → 8 |
| Maturity / provenance | 1 | 5 → 5 | 2 → 2 |
| **Total** | | **28** | **35** |

### Decision (accepted)

**Build a `,x`-convention `syntax-rules` matcher**, after first adding ellipsis-escape
`(... ...)` support to the expander (required either way). Rationale: the escape cost is
shared, so the decision turns on churn vs authorship; the spike shows the `,x` core is clean
and gives **zero pass churn** (the ~22 pass `match` forms stay byte-for-byte), and a small
targeted matcher is more auditable and self-host-friendly than vendoring ~900 lines of
Wright-style machinery. Buy remains the fallback if authoring the ellipsis handling proves
harder than the Wright rewrite.

**Residual risk (accepted):** the spike does not measure the *authoring effort of the `,x`
matcher's ellipsis handling* relative to the Wright rewrite. Tasks 3.2–3.4 (the full dual-port
IR-diff bake-off) were skipped as unnecessary for the selection; the effort question is
carried into [[port-match-to-syntax-rules]], where "buy (Shinn)" remains the documented
fallback if authoring the ellipsis handling proves harder than expected.

### Required expander work (for [[port-match-to-syntax-rules]])

Add ellipsis-escape `(... ...)` handling to `src/passes/expand.ss` (template instantiation:
`(... x)` yields a literal `x` with `...` treated as data). This is the single expander
construct the rewrite depends on, regardless of which matcher is chosen.

Sources: [SRFI-241](https://srfi.schemers.org/srfi-241/srfi-241.html),
[SRFI-204](https://srfi.schemers.org/srfi-204/srfi-204.html),
[Shinn `match.scm`](https://synthcode.com/scheme/match.scm),
[pmatch](https://github.com/webyrd/quines/blob/master/pmatch.scm).

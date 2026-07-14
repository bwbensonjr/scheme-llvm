## Context

The passes use a vendored `match` (`src/match.sls`, 325 lines, Andy Keep's matcher) built
on `syntax-case`. Our expander implements only `syntax-rules`, so this `match` is
un-expandable by scheme-llvm and blocks self-hosting.

Two facts scope the work:

1. **Catamorphism is implemented in `match.sls` but unused by the compiler.** There are
   zero `,[…]` catamorphism forms in the passes. The used pattern subset is: literal
   symbol (bare symbol matches itself), pair `(a . b)`, single ellipsis `(p ...)`,
   ellipsis-with-fixed-tail `(p ... plast)`, `,id` binder, `(guard <exp> …)`, and `else`.
2. **The expander is already close.** `src/passes/expand.ss` tracks per-variable ellipsis
   depth and supports ellipsis-with-tail (`match-ellipsis` takes a `tailpat`). It has no
   visible handling of the ellipsis-escape `(... ...)`.

A `syntax-rules` matcher works by expanding to *runtime* destructuring code
(`car`/`cdr`/`pair?`/`null?`/`eq?`/`equal?`/`let`/`if`) — all in the M1 subset, so no
runtime growth is required. This is what makes the `syntax-rules` route keep the
self-hosting gap flat (unlike `syntax-case`, whose hygiene bookkeeping would pull in
gensym/records/hashtables).

## Goals / Non-Goals

**Goals:**
- Remove the `syntax-case` dependency from the compiler's `match`.
- Adopt a single `syntax-rules` matcher used by both the host and the future self-hosted
  build (retire `match.sls`; no host/target divergence).
- Preserve compiler behavior exactly — the existing test suite is the oracle.
- Record the self-hosting-relevant decision (matcher depends only on `syntax-rules`).

**Non-Goals:**
- Implementing `syntax-case`. Explicitly deferred until R7RS-large's pattern-matching
  story settles.
- Catamorphism, `?`-predicate patterns beyond what the guards need, or any matcher feature
  the passes do not use.
- Self-hosting itself. This change removes one blocker; it does not compile the passes with
  scheme-llvm yet.

## Decisions

### D1: Inputs consumed from the selection change

The matcher choice and the expander-sufficiency spike are owned by
[[select-syntax-rules-matcher]]; this change does not re-derive them. It consumes that
change's recorded decision:

- the **chosen matcher** and its pattern convention (`,x`-preserving → ~zero pass churn;
  Wright-style → rewrite ~22 `match` forms with literal→`'quote`, `,x`→binder,
  `(guard …)`→`?`-pattern);
- the **required expander work** (e.g. add the ellipsis escape `(... ...)`, or "none
  needed"), established by that change's bake-off spike.

If [[select-syntax-rules-matcher]] has not landed, this change is blocked on it.

### D2: Guards migrate to inline predicate patterns (if a Wright-style matcher is chosen)

There are only three guard shapes (10 uses): `(symbol? x)` ×8, `(prim? op)`, and one
`(and (list? params) (= (length params) …))`. In a Wright-style matcher these become
`?`-predicate patterns: `(? symbol? x)`, `(? prim? op)`,
`(? (lambda (p) (and (list? p) …)) params)`. Mechanical and low-risk. A `,x`-preserving
matcher would instead keep the `(guard …)` clause form and need no guard rewrite.

### D3: One matcher, both builds; migrate and test pass-by-pass

Replace `match.sls` wholesale so host and target expand identically. Rewrite passes one
file at a time, running the full suite after each, so a silent literal↔binder inversion
(a mis-quoted literal becomes a catch-all binder and fires the wrong clause) is caught
immediately rather than compounding across files.

## Risks / Trade-offs

- **Silent literal↔binder inversion** (Wright-style path) → migrate per-file with the suite
  as oracle after each file; the `,x`-preserving matcher avoids the inversion entirely.
- **Ellipsis-with-tail over runtime lists is fiddly** → the selection bake-off already
  exercised it; add targeted tests for `(p ... plast)` here.
- **Required expander extension is larger than expected** → its scope is known up front from
  the selection change's spike; if large, it can be split into its own change.
- **Two matchers drifting** → avoided by D3 (single matcher, both builds; `match.sls`
  retired).

## Migration Plan

1. Consume the decision from [[select-syntax-rules-matcher]] (matcher + required expander
   work).
2. Implement the required expander construct (if any) with tests.
3. Land the matcher; retire `match.sls`.
4. Rewrite passes one file at a time, full suite green after each (D3).
5. Confirm `./run-all-tests.sh` all green; confirm no `syntax-case`/`match.sls` references
   remain.

Rollback: revert the pass files and restore `match.sls`; the change touches only compiler
internals, no runtime or emitted-IR contract.

## Open Questions

- **Sequencing with self-hosting.** This composes with host-side `match` pre-expansion:
  first-light self-hosting can pre-expand `match` and not need a target matcher at all;
  this change lets the *target* expand its own `match` afterward. The two can proceed in
  parallel.

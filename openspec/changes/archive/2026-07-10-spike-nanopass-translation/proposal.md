## Why

`LLVM.md` treats nanopass as a settled choice for the compiler's pass pipeline, but
that assumption has not been tested against this project's overriding value: "as
simple and easy-to-understand as possible" (`CLAUDE.md`). Inspection of Chez Scheme's
own compiler shows ~50 passes across ~30 intermediate languages, of which a Scheme →
LLVM compiler needs only the **top third** — LLVM subsumes everything from
`remove-complex-opera*` (ANF) down through calling conventions, basic-block layout,
instruction selection, and register allocation. At that reduced pass count, nanopass's
payoff (which scales with the number of passes) is no longer obviously worth importing
a large `syntax-case` macro framework that is itself harder to read than the compiler
it would host.

This spike settles the question empirically **before** any pipeline code or
documentation commits to a direction: translate a few representative Chez nanopass
passes into stylized plain Scheme and compare.

## What Changes

- Add a **research spike** (kept as a reference implementation under `spike/nanopass/`,
  not discarded) that translates three representative Chez `cpnanopass.ss` passes into
  stylized hand-rolled Scheme:
  - `np-recognize-let` (L1→L2) — the boilerplate floor (trivial, pure traversal).
  - `np-convert-assignments` (L3→L4) — nanopass's sweet spot (delta = remove `set!`).
  - `np-convert-closures` (L5→L6) — a structural language-shape change.
- Define the **stylized hand-rolled convention** to compare against — a `match`-based
  recursive descent (using the standard Chez `match` macro for clarity) plus a "recur
  over subforms" helper — so the two versions differ only in framework, not in taste.
- Produce a **verdict**: nanopass vs. hand-rolled for this project's top-third pipeline,
  scored on line count, share of boilerplate, readability, and the safety lost by
  giving up nanopass's automatic form-coverage checking.
- Produce a **new frontend/pass-ladder design doc** capturing the transferable spine
  (`read → expand → core → assignment-conv → closure-conv → lambda-lift → emit .ll`)
  and the LLVM-subsumes line — the doc `LLVM.md` already points at with "documented
  elsewhere," which does not yet exist.
- **Defer** touching `LLVM.md`. Only its single framing sentence ("uses the nanopass
  framework for its pass pipeline") is at stake, and only if the verdict flips it.

## Capabilities

### New Capabilities
<!-- None. This is a research spike; its deliverable is a decision and a design
     document, not a runtime capability. No spec requirements are created. -->

### Modified Capabilities
<!-- None. No existing spec-level behavior changes. -->

## Impact

- **New code kept as reference**: spike translations under a tracked `spike/nanopass/`
  directory. Not yet the production compiler source, but retained (not discarded) as a
  worked reference for both frameworks.
- **New doc**: frontend/pass-ladder design doc (location decided in design.md).
- **Docs untouched for now**: `LLVM.md` (at most a one-sentence reconciliation after
  the verdict).
- **Dependency question resolved**: whether nanopass becomes a committed dependency of
  the compiler, or the pipeline is hand-rolled over plain s-expressions.
- **Reference material**: Chez Scheme source at
  `/Users/bwb/src/github.com/cisco/ChezScheme` (`s/cpnanopass.ss`, `s/np-languages.ss`).

## Why

The compiler is already **self-hosting in capability**: `test/self-host-fixpoint.sh` proves
the compiled compiler compiles its own full source to a byte-identical fixed point (stage-2 ≡
stage-3). But the **plumbing hasn't caught up** — regenerating the shipped compiler still
routes through Chez in two places:

- **Assembly** (`chez --script tools/assemble-core.ss`): text-munges the `library`-structured
  source (de-`library` `match`/`util`, drop `include`s, rename the `match-pat` collision,
  append an entry) into one flat program. Chez-only.
- **Compilation** (`chez … compile.ss --emit-ir`): compiles that flat program to IR. This is
  *redundant* — `schemec` (proven by the fixed-point test) can do it — but the Makefile still
  calls Chez, and no self-compiled `schemec` IR is committed.

So today a developer who changes the compiler (adds a primitive, a pass, module support) must
have Chez installed to regenerate `bootstrap/*.ll`. The goal of this change is **"a developer
needs only LLVM"**: make the Chez-free pipeline the standard one, with the flat, self-hostable
source promoted to the source of truth and the committed self-compiled IR favored. Chez is
retained only as the **historical genesis** and an optional **CI trust-check**, never in the
day-to-day edit→rebuild loop.

## What Changes

- **Promote the flat program to source of truth (Chez-free assembly).** Flatten the few
  library/include-structured files so assembly collapses to ordered concatenation (a shell/Make
  step, no Chez): `match`/`util` become flat `define-syntax`/`define`s (baking the assembler's
  `%match-pat` rename), `core.ss` drops its `include`s and unifies on `read-all-from-string`,
  and the per-target entries become small committed files. `tools/assemble-core.ss` is retired
  from the default build (kept as historical/reproduction tooling).
- **Commit a self-compiled `schemec` artifact** (a third `bootstrap/*.ll`, alongside `embed.ll`
  / `embed-repl.ll`) so `schemec` builds from committed IR + clang with no Chez.
- **Rewire regeneration to the compiled compiler.** The Make recipes that produce the committed
  `bootstrap/*.ll` invoke `schemec` (or `scheme-run --emit`), not `chez … --emit-ir`. A
  developer edits source → `make regen` (Chez-free) → new committed IR → binaries.
- **Sever the committed IR from the default build graph** (the mtime-caveat fix): `make`
  treats `bootstrap/*.ll` as checked-in inputs and links binaries from them with LLVM only;
  regeneration is an explicit, opt-in target. Bare `make` builds `scheme-run` **and**
  `repl-host`.
- **Make the test suite Chez-free by default.** `run-all-tests.sh` runs behavioral suites on
  the shipped binaries (demos via `scheme-run`, REPL via `repl-host`). Chez-bound suites
  (backend equivalence, the fixed-point/self-emit checks, IL-level unit tests) move to a
  clearly-marked, auto-skipped-without-Chez developer/CI suite that also performs the anti-stale
  **trust-check** (`make regen` reproduces the committed IR).
- **Optional Chez-free standalone-exe (AOT).** Add `scheme-run --emit` (write the returned IR to
  stdout instead of JITting it, reusing the existing committed `embed.ll`) so
  `scheme-run --emit < prog.scm | clang … → prog` produces a native executable with no Chez —
  honoring the `CLAUDE.md` "standalone executables are a first-class deliverable" goal.
- **README/Makefile restructure.** Lead with "install LLVM, `make`, run/build/REPL"; Chez moves
  to a secondary "Regenerating the compiler (bootstrap)" section.

## Capabilities

### New Capabilities
- _(none — extends existing capabilities.)_

### Modified Capabilities
- `self-hosting`: assembly becomes Chez-free (flat source + concatenation, not a Chez script);
  add the Chez-free **regeneration loop** (edit source → rebuild the committed compiler IR and
  binaries with only LLVM) and the committed **self-compiled artifacts** as the favored,
  authoritative form; demote Chez to genesis + an optional trust-check.

## Impact

- **Depends on:** `self-hosting-bootstrap` (the assembled core + fixed point) and
  `path-a-embedding` / `repl-embedded-incremental` (the embedded `scheme-run` / `repl-host`
  that make the runners Chez-free).
- **Code:** the compiler source structure (`match`/`util`/`core.ss` flattening, entry files),
  `tools/assemble-core.ss` (retired from default), `Makefile` (regen split, default target,
  cat-assembly), `src/run.cpp` (optional `--emit`), `run-all-tests.sh` + harnesses (Chez-free
  default suite + a Chez dev/CI suite), and committed `bootstrap/*.ll` (add `schemec`).
- **Tests:** the full behavioral suite runs Chez-free on the shipped binaries; a Chez-gated CI
  step reproduces the committed IR (trust-check) and runs the IL-level unit + backend suites.
- **Risk / gate:** the byte-identical fixed point is emission-order-sensitive; flattening
  reorders/renames definitions and could perturb it. A spike proves the flattened source still
  converges *before* the mechanical rewrite. (The proposer is not especially worried, but the
  spike is cheap insurance.)
- **Note:** this deliberately reverses the auto-rebuild mechanism of
  `fix-stale-repl-host-rebuild` — the committed IR is authoritative and not auto-regenerated;
  the anti-stale guarantee moves to the Chez-gated CI trust-check.

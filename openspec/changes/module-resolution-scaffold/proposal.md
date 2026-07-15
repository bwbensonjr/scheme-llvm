## Why

Separate compilation — compiling a `define-library` once into an artifact linkable into an
AOT executable and loadable into the REPL — is a stated project goal, but the compiler is
whole-program today and three things block it: lifted code blocks are named `@code1,
@code2…` from a per-compilation counter (`src/passes/lower.ss:48`, `src/emit.ss:637`) so two
units collide on link; every module defines its own `@scheme_entry`; and there is no scope
boundary (the compile sees all forms at once). The full design lives in
`docs/superpowers/specs/2026-07-15-modules-v0-design.md`; this change is its **Stage 0** —
the behavior-preserving groundwork that makes the later module-artifact work small and safe.

Landing the resolution/naming scaffolding on its own, verified by byte-identity, de-risks
the riskiest emission and resolution changes independently of any new user-facing syntax.

## What Changes

- Generalize the flat global resolver (`resolve-globals`, `src/parse.ss:224`) into a **typed
  scope**: every resolved binding is classified `local`, `imported`, or `primitive`, with
  lexical locals resolved first. Only `local` and `primitive` are populated in this change
  (no imports yet); the `imported` kind and its "referenced ⇒ `external global`" emission
  hook are structured for Stage 1 to use.
- Introduce a **deterministic, unit-parameterized symbol-naming function**: for library
  `(p₁ … pₙ)` and internal name `x` the symbol is `p₁.….pₙ:x`. Route unit-owned global
  names and lifted code-block labels through it. The **program** (non-library) unit uses the
  empty prefix, so its emitted symbols are unchanged.
- **Acceptance is byte-identity:** any program that imports no library emits byte-for-byte
  identical LLVM IR before and after this change. No new syntax, no behavior change.
- Regenerate the committed compiler IR (`make regen`) since the compiler's own source
  changed; the anti-stale trust-check verifies the regenerated `bootstrap/*.ll` is a stable
  self-hosting fixed point.

## Capabilities

### New Capabilities
- `module-system`: The R7RS-small module / separate-compilation system. This change adds its
  **foundational** requirements only — the typed binding-resolution model, the deterministic
  module-qualified symbol-naming ABI, and the guarantee that introducing this scaffolding
  preserves emitted IR for library-free programs. Later stages (define-library, export/import,
  the two doors, prelude-as-`(scheme base)`) extend this same capability.

### Modified Capabilities
<!-- None. The scaffolding is behavior-preserving: no existing capability's REQUIREMENTS
     change. compiler-pipeline's documented pass behavior is unchanged (byte-identity), and
     self-hosting's fixed-point guarantee is re-established by `make regen`. -->

## Impact

- **Compiler core (in `CORE_FLAT`, so committed IR is regenerated):** `src/parse.ss`
  (resolver → typed scope), `src/passes/lower.ss` and `src/emit.ss` (unit-parameterized
  naming for globals and lifted code labels), `src/core.ss` (thread the unit/naming context).
- **Committed IR:** `bootstrap/{schemec,embed,embed-repl}.ll` regenerated via `make regen`
  (the compiler source changed; output for library-free programs is unchanged).
- **No behavioral change:** demos, REPL, and all backends produce identical results and, for
  library-free programs, identical IR. `run-all-tests.sh` and `run-dev-tests.sh` (including
  self-emission-equivalence and the anti-stale trust-check) must stay green.
- **Tests added:** a byte-identity check (library-free programs vs a pre-change baseline) and
  a direct unit test of the naming function.
- **Dependencies:** none.

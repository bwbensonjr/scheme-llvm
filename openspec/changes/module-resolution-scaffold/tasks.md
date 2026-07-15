## 1. Baseline capture (before any edit)

- [x] 1.1 Add `test/module-scaffold-baseline.sh` that compiles every `demos/*.scm` to `.ll` (via the existing compile path) and saves them under a baseline dir; run it on the pristine tree to capture the pre-change IR
- [x] 1.2 Confirm `run-all-tests.sh` and `run-dev-tests.sh` are green on the pristine tree (establish the starting point)

## 2. Typed binding resolution (parse.ss)

- [x] 2.1 Define a binding record carrying `kind` (`local` | `imported` | `primitive`) and `symbol`, in a form the `match` passes read cleanly and that is self-hostable
- [x] 2.2 Rewrite `resolve-globals` (`src/parse.ss:224`) to return typed bindings: `local` for the unit's own top-level defines, `primitive` for built-ins/keywords, unbound-variable error otherwise — behavior identical to the current flat resolver
- [x] 2.3 Define the `imported` kind and its consumption path, but do NOT produce it from the resolver in this change (Stage 1 populates it)

## 3. Unit-parameterized symbol naming (lower.ss / emit.ss / core.ss)

- [x] 3.1 Implement `(mangle library-name internal-name)` returning `p1.….pn:x`; for the empty/program prefix it returns the internal name unchanged. Unit-test it directly: `mangle((scheme base), map) = "scheme.base:map"`, and empty-prefix round-trips the input
- [x] 3.2 Thread a `unit` (naming) context through `core.ss` into `lower.ss`/`emit.ss`; the program unit uses the empty prefix
- [x] 3.3 Route lifted code-block labels (`@codeN`, `src/passes/lower.ss:48` / `src/emit.ss:637`) and top-level global names (`src/emit.ss:590`) through `mangle` with the current unit — emitting the identical string for the program unit
- [x] 3.4 Emit `external global i64` for a referenced `imported` binding (wire the existing REPL hook to the new binding kind); unexercised in this change but ready for Stage 1

## 4. Byte-identity verification

- [x] 4.1 Recompile all demos and diff against the captured baseline — every library-free program's `.ll` MUST be byte-for-byte identical; investigate and fix any diff
- [x] 4.2 Run `run-all-tests.sh` (Chez-free) — all suites pass

## 5. Regenerate committed IR and self-host verification

- [x] 5.1 `make regen` to rebuild `bootstrap/{schemec,embed,embed-repl}.ll` from the changed source
- [x] 5.2 Run `run-dev-tests.sh` (Chez-gated) — self-emission-equivalence, self-hosting fixed point, and the anti-stale trust-check all pass (regenerated committed IR reproduced byte-for-byte from source)
- [x] 5.3 Commit the regenerated `bootstrap/*.ll` together with the source change

## 6. Wrap-up

- [x] 6.1 Confirm the new `test/module-scaffold-baseline.sh` (or a byte-identity assertion derived from it) is wired into a suite so the guarantee is re-checkable, or documented as a one-shot verification in the change notes
- [x] 6.2 Sanity-run a demo at `EMIT_VERBOSITY=verbose` to confirm stage output still reads correctly after the resolver/naming refactor

## 1. Failing regression test (TDD)

- [x] 1.1 Add a high-arity demo that reproduces the bug: max arity `K ≥ 6` plus a non-tail
      closure call with a live argument, e.g. `demos/high-arity-nontail.scm`:
      `(define (big a1 a2 a3 a4 a5 a6) (+ a1 a2)) (define (helper x) (+ x 100))
      (define (f a b) (+ (helper a) b)) (f 10 20)` — expected value `130`. Register it in
      `demos/run-tests.sh` (and thus `run-backends.sh`). Confirm it FAILS (garbage/hang) before the fix.
      — added; RED before fix (returned `542653501`).

## 2. Fix the calling convention

- [x] 2.1 In `src/emit.ss`, change the emitted calling convention from `tailcc` to `fastcc`:
      the function prototype in `emit-code-def` and the two call forms in `finish-call`
      (the `musttail` tail call and the non-tail call); update the convention comment/banner.
- [x] 2.2 Confirm the emitted tail calls remain `musttail` (already invariant: `tc?` is always
      `#t`), so `fastcc` guarantees them. — emitted IR shows `define fastcc` / `musttail call fastcc` / `call fastcc`.

## 3. Verification

- [x] 3.1 The new high-arity demo now returns `130` (AOT), and agrees across all three backends
      (`demos/run-backends.sh`). — AOT/JIT/bitcode all `130`.
- [x] 3.2 Deep-tail-loop demos (`countdown` 10M, `named-let-loop`) still run in bounded stack
      under `fastcc` (guaranteed `musttail` preserved). — pass within the AOT suite.
- [x] 3.3 Run `./run-all-tests.sh`; all suites pass (demos × 3 backends, REPL host, interactive
      REPL, equivalence/batch) — the REPL host and JIT consume the same IR, so confirm no
      regression there. — 10/10 suites pass.

## 4. Hand off

- [x] 4.1 Hand back to [[self-hosting-bootstrap]] task 2.1: rebuild `build/schemec`
      (`RT_FILTER_MAIN` + `assemble-core.ss --filter-main` are already in place) and confirm it
      emits IR without hanging/crashing on a trivial program, then resume the stage-1 build and
      the triple test. — **rebuilt; `printf '(+ 1 2)' | build/schemec` now exits 0 and emits IR
      that is byte-identical to `chez … --emit-ir --no-prelude`.** self-hosting-bootstrap 2.1 is
      unblocked (full stage-1 build + triple test resume there).

## 1. Gate check (prerequisites)

- [x] 1.1 Confirm all prerequisites are done: [[decompose-core-driver]], [[prelude-cxr-and-case]], [[integer-division-number-format]], [[multiple-values]], [[error-and-guard-conditions]], [[stdin-source-reader]] (plus the completed `match`/syntax-rules and vectors work). — all archived.
- [x] 1.2 Compile the core with scheme-llvm; for any residual unsupported construct, loop back to the relevant prerequisite change and record the gap. — **gaps found (see design.md "Gate-check findings"): G1 internal defines unsupported, G2 emit.ss byte/hex/UTF-8 escaping, G3 path-C I/O shell. Blocks tasks 2–3.**
- [x] 1.3 Audit for output nondeterminism (gensym counter, ordering) that would break the fixed point. — clean: only the reset-per-compile counter; no hashtables/sort/random.

## 2. Stage-1 build (path C)  — BLOCKED on a codegen bug ([[fix-closure-self-compilation]])

G3 ([[self-host-io-strategy]]) is closed and G1/G2/G6–G10 are landed. Building `schemec`
surfaced two self-application miscompilations, both invisible to the demo suite (which only
checks scheme-llvm's *output* for small programs, never scheme-llvm compiling *itself*):

1. **Calling-convention bug — FIXED ([[fix-high-arity-call-convention]], landed).** Calls
   passed `K+3` args (`self`, `argc`, `a0..a{K-1}`, `overflow`); at max-arity `K ≥ 6` that
   exceeds arm64's 8 argument registers and `tailcc` non-tail calls corrupted the caller's
   live args. Fixed by emitting `fastcc`. After this, `schemec` builds and compiles
   closure-free programs byte-identically.
2. **Closure-arity gap — FIXED ([[fix-closure-self-compilation]], landed).** `schemec` failed
   on any closure-producing program (`lambda`/`let`/`letrec`/define-of-procedure) with
   `arity error: expected 2, got 3`. Root cause was **not** codegen: the prelude
   `map`/`for-each`/`append` were fixed-arity, but the core uses multi-list `map`/`for-each` and
   3-arg `append` (Chez's are variadic). Fixed by making them variadic. `schemec` now compiles
   closure/`let`/`letrec`/recursion programs (with `(...)` parens).
3. **Bracket-reader gap — FIXED ([[fix-bracket-reader]], landed).** The prelude reader's
   `rd-datum` had no case for `[` (char 91), so `[...]` syntax mis-read and `schemec` segfaulted
   on the ~529-bracket core. Fixed by accepting `[`/`]` as list syntax. `schemec` now compiles
   bracket programs (incl. `demos/fact.scm`) to correct, runnable IR (fact → 120).
4. **Evaluation-order divergence — OPEN ([[fix-emit-eval-order]], next).** `schemec`'s IR is
   correct but **not byte-identical** to the Chez-hosted compiler's: temps come out in a
   different order because `(emit-app (ev f …) (map … args) …)` and similar rely on host
   argument-evaluation order (Chez right-to-left vs scheme-llvm left-to-right). This breaks the
   byte-identical fixed point (task 3), so it must close before the triple test — it is the
   long-standing open question "does any pass rely on Chez evaluation order?" made concrete.

Resume 2.1 (full build) once (4) lands; the driver wiring (2.2) already works on non-brackets.
Prelude, toggle, and REPL-scope decisions are D4/D5 in design.md.

- [~] 2.1 Build the core AOT to a native `schemec` using the Chez-hosted compiler: assemble the
      core with `tools/assemble-core.ss`, append the `(display (compile-source-string
      (read-all-stdin)))` main, AOT-compile with `compile.ss`, and add a `make build/schemec` rule.
      — **Build machinery done** (`make build/schemec`: assemble `--filter-main` → `--emit-ir` →
      link `-DRT_FILTER_MAIN`, all `fastcc`), and `schemec` compiles closure-free programs
      byte-identically (`(+ 1 2)`, `42`, `(if …)`, `(quote …)`). **But NOT functionally complete:**
      `schemec` fails on any program that produces a closure — `arity error: expected 2, got 3`
      for `lambda`/`let`/`letrec`/`define`-of-procedure — and segfaults on recursive `letrec`.
      These are **further self-application miscompilations** (distinct from the fixed `tailcc`
      bug) in `schemec`'s own closure path; scheme-llvm compiles closure programs correctly when
      Chez-hosted (demo `toplevel` etc.), so they surface only under self-compilation. **BLOCKED**
      pending dedicated fixes (see §2 header) — likely a short series, one change each.
      **NB (from [[self-host-io-strategy]] 3.3):** the standard standalone `main` prints the
      program's final value (`rt_write` + newline), which would append `()\n` after the IR. Use a
      **filter-style main that suppresses the final-value print** (or have the driver strip a
      trailing `()\n`) — otherwise stdout carries trailing bytes that break `llvm-as` and the
      byte-identical triple test.
      **Scaffolding done (2026-07-14):** runtime `RT_FILTER_MAIN` (suppresses the value print) and
      `tools/assemble-core.ss --filter-main` (emits `build/schemec.scm` with the filter entry) are
      in place; the build itself is BLOCKED on [[fix-high-arity-call-convention]] (see §2 header).
- [~] 2.2 Wire the **batch** driver to invoke `schemec` (text→IR) instead of the in-process core
      (D4): toggleable `SCHEMEC`/`--via-schemec` path in `compile-file`; driver merges the prelude
      (`with-prelude`) and pipes merged text to `schemec`; `host-target-header` + toolchain
      unchanged; in-process path retained for bootstrapping and fallback.
      — **Wiring code implemented** (`compile.ss`: `--via-schemec`/env `SCHEMEC`,
      `forms->ir-via-schemec` writes merged forms to the `schemec` co-process and reads IR back).
      Cannot be end-to-end verified against real demos until 2.1's closure miscompilations are
      fixed (every demo has closures). NB: chez `process` merges the child's stderr into the
      captured stdout — separate stderr before trusting captured IR (a `2>` redirect, as
      `run-repl` does).
  - [ ] 2.2a (REPL) Do **not** wire the REPL to `schemec` (D5). Record that the REPL stays on the
        Chez front-end through path C and moves off Chez via path A (task 4.2), noting the
        entry points path A must drive (`repl-lcode` / `emit-repl-module` / `emit-repl-batch`).
- [ ] 2.3 Confirm program results are unchanged under the `schemec` path: schemec-path IR is
      byte-identical to the in-process path for every demo, across all three backends.

## 3. Fixed-point (triple) test

- [ ] 3.1 Compile the core with stage-1 `schemec` to produce stage-2 IR.
- [ ] 3.2 Require stage-1 and stage-2 IR to be byte-identical; chase any diff to a self-application bug.
- [ ] 3.3 Add the triple test to the suite as the self-hosting regression.

## 4. Policy + follow-up

- [ ] 4.1 Decide the stage-0 artifact policy (always bootstrap from Chez vs. check in a stage-0 `schemec`).
- [ ] 4.2 Note path A (in-process embedding of the compiled compiler in the host) as a separate follow-up change.

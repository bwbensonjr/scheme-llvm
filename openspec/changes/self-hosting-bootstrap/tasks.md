## 1. Gate check (prerequisites)

- [x] 1.1 Confirm all prerequisites are done: [[decompose-core-driver]], [[prelude-cxr-and-case]], [[integer-division-number-format]], [[multiple-values]], [[error-and-guard-conditions]], [[stdin-source-reader]] (plus the completed `match`/syntax-rules and vectors work). — all archived.
- [x] 1.2 Compile the core with scheme-llvm; for any residual unsupported construct, loop back to the relevant prerequisite change and record the gap. — **gaps found (see design.md "Gate-check findings"): G1 internal defines unsupported, G2 emit.ss byte/hex/UTF-8 escaping, G3 path-C I/O shell. Blocks tasks 2–3.**
- [x] 1.3 Audit for output nondeterminism (gensym counter, ordering) that would break the fixed point. — clean: only the reset-per-compile counter; no hashtables/sort/random.

## 2. Stage-1 build (path C)  — BLOCKED on a codegen bug ([[fix-high-arity-call-convention]])

G3 ([[self-host-io-strategy]]) is now closed and G1/G2/G6–G10 are landed. Attempting task 2.1
(below) surfaced a **new blocker**: the self-compiled `schemec` builds (2 MB IR, links) but
hangs/crashes at runtime. Root-caused to a **calling-convention bug**: calls pass `K+3` args
(`self`, `argc`, `a0..a{K-1}`, `overflow`); at max-arity `K ≥ 6` that is ≥ 9 args, exceeding
arm64's 8 argument registers, and `tailcc` non-tail calls mishandle the stack-passed arg,
corrupting the caller's live arguments. The core has arity-7 functions (`ev-if`/`et-if`), so it
trips this pervasively; all demos are `K ≤ 5`, which is why the suite never caught it (verified
independent of `-O0`/`-O2`). Fix tracked in [[fix-high-arity-call-convention]]; resume 2.1 once
it lands. Prelude, toggle, and REPL-scope decisions are D4/D5 in design.md.

- [ ] 2.1 Build the core AOT to a native `schemec` using the Chez-hosted compiler: assemble the
      core with `tools/assemble-core.ss`, append the `(display (compile-source-string
      (read-all-stdin)))` main, AOT-compile with `compile.ss`, and add a `make build/schemec` rule.
      **NB (from [[self-host-io-strategy]] 3.3):** the standard standalone `main` prints the
      program's final value (`rt_write` + newline), which would append `()\n` after the IR. Use a
      **filter-style main that suppresses the final-value print** (or have the driver strip a
      trailing `()\n`) — otherwise stdout carries trailing bytes that break `llvm-as` and the
      byte-identical triple test.
      **Scaffolding done (2026-07-14):** runtime `RT_FILTER_MAIN` (suppresses the value print) and
      `tools/assemble-core.ss --filter-main` (emits `build/schemec.scm` with the filter entry) are
      in place; the build itself is BLOCKED on [[fix-high-arity-call-convention]] (see §2 header).
- [ ] 2.2 Wire the **batch** driver to invoke `schemec` (text→IR) instead of the in-process core
      (D4): toggleable `SCHEMEC`/`--via-schemec` path in `compile-file`; driver merges the prelude
      (`with-prelude`) and pipes merged text to `schemec`; `host-target-header` + toolchain
      unchanged; in-process path retained for bootstrapping and fallback.
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

## 1. Front end: persistent global top-level model

- [x] 1.1 Add a REPL-mode top-level lowering in `src/parse.ss` (alongside `collect-toplevel`) that lowers each `(define name init)` to a persistent global slot + init, instead of a monolithic `letrec`; leave batch `collect-toplevel` untouched.
- [x] 1.2 Add a compiler-side top-level environment: a `name → current-symbol` map, with generation-mangled symbols (e.g. `x.g3`) so redefinition allocates a fresh symbol and references resolve to the latest.
- [x] 1.3 Make variable resolution consult the top-level environment so a form can reference globals from earlier forms; raise an unbound-variable error for names not yet defined (no forward references).
- [x] 1.4 Unit-test the lowering + environment in Chez: earlier-define visibility, redefinition-wins-for-later-forms, and forward-reference rejection. (`test/repl-frontend.ss`, 8 checks passing)

## 2. Emit: one IR module per form

- [x] 2.1 Add per-form emission in `src/emit.ss`: `global-ref`/`global-set!` load/store, a `global` slot definition for each introduced name, and (for the split-module case) a scanner (`repl-scan-globals`) that separates defined vs. referenced globals so referenced-only ones become `external`. Batch validation (Group 3) emits one combined module, so externals are exercised later by the ORC host (Group 4).
- [x] 2.2 Emit a single `@__repl_N() -> i64` entry thunk per form (`emit-named-entry`) that evaluates the form, stores into any new global slots, and returns the value to print.
- [x] 2.3 Reuse the host-target-header logic so each emitted module carries the host `datalayout`/`triple`.
- [x] 2.4 Verify emitted modules assemble with LLVM 22 `llvm-as` and run via `lli` without warnings (validated in Group 3). Pinned session-wide closure arity K=8 (design D6) with an over-arity error.

## 3. Front-end validation on the existing batch JIT (no ORC yet)

- [x] 3.1 Add a temporary driver (`test/repl-batch.ss`) that lowers each top-level form as a separate REPL entry and emits one module with `@__repl_1..N` thunks called in order from `@scheme_entry` (`emit-repl-batch`).
- [x] 3.2 Confirm cross-thunk globals, redefinition, and heap-value reuse (e.g. `(define p (cons 1 2))` then `(car p)`) produce correct values through the AOT and `lli` paths (`test/repl-batch-tests.sh`, 8 cases passing; 34 existing demos still green).
- [ ] 3.3 Remove/retire the temporary driver once the ORC host (section 4) supersedes it.

## 4. Persistent LLVM ORC / LLJIT host

- [ ] 4.1 Create a C++ ORC v2 / LLJIT host that calls `GC_INIT()` once and stands up a persistent `LLJIT` instance.
- [ ] 4.2 Link `runtime.c` + libgc into the host and expose process symbols to the JIT via `DynamicLibrarySearchGenerator::GetForCurrentProcess()` so `rt_*` resolve without re-adding the runtime per form.
- [ ] 4.3 Implement the host request loop: read IR text for one form, `parseIR`, `addIRModule`, `lookup("__repl_N")`, cast to `val(*)()`, call, and report the result.
- [ ] 4.4 Have the host print results via the runtime `rt_write` printer.
- [ ] 4.5 Isolate runtime traps (e.g. arity errors) so a failing form reports and the host stays alive for the next form.
- [ ] 4.6 Document the LLVM 22 ORC build/link requirements in `TOOLCHAIN.md`.

## 5. REPL driver (Chez) and host transport

- [ ] 5.1 Add a REPL driver that reads one form, runs it through the existing reader/expander/lowering/emit to IR text, and sends it to the host.
- [ ] 5.2 Implement the Chez↔host transport (length-prefixed IR text over a pipe), including receiving the printed result back.
- [ ] 5.3 Wire an interactive entry path in `src/compile.ss` (e.g. a `--repl`/`repl` mode) that starts the host and enters the read-eval-print loop; prompt, print, loop.
- [ ] 5.4 Handle end-of-input by shutting down the host and exiting cleanly.

## 6. Verification and regression

- [ ] 6.1 Add REPL scenario tests covering the `interactive-repl` spec: later-form-sees-earlier-define, redefinition, forward-reference rejection, heap-value survival, and symbol `eq?` persistence across forms.
- [ ] 6.2 Add a backends equivalence check: a scripted form sequence in the REPL yields the same final value as the batch/whole-program build of the same forms.
- [ ] 6.3 Confirm AOT, bitcode, and batch `lli` exits and the existing demo suite are unaffected.
- [ ] 6.4 Update `README.md` with REPL usage.

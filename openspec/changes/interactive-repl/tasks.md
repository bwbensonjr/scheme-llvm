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
- [x] 3.3 The ORC host supersedes the temporary batch driver for interactive use, but `test/repl-batch.ss` + `test/repl-batch-tests.sh` are **retained** as standalone regression coverage for `emit-repl-batch`, which is now load-bearing (the REPL loads the prelude as one combined `emit-repl-batch` module).

## 4. Persistent LLVM ORC / LLJIT host

- [x] 4.1 Create a C++ ORC v2 / LLJIT host that calls `GC_INIT()` once and stands up a persistent `LLJIT` instance. (`src/repl/host.cpp`)
- [x] 4.2 Link `runtime.c` + libgc into the host and expose process symbols to the JIT via `DynamicLibrarySearchGenerator::GetForCurrentProcess()` so `rt_*` resolve without re-adding the runtime per form. (`-rdynamic`; runtime built `-DRT_NO_MAIN`)
- [x] 4.3 Implement the host request loop: read IR text for one form (framed on stdin), `parseIR`, `addIRModule`, `lookup("__repl_N")`, cast to `intptr_t(*)()`, call, and report the result. Also added `emit-repl-module` (per-form single module with `external` prior globals) and `test/repl-frames.ss` (frame generator).
- [x] 4.4 Have the host print results via the runtime `rt_write` printer.
- [x] 4.5 Isolate runtime traps (arity errors) so a failing form reports (`!trap`) and the host stays alive; `rt_trap` `longjmp` hook in `runtime.c`, null in standalone exes (still `exit(1)`).
- [x] 4.6 Document the LLVM 22 ORC build/link requirements in `TOOLCHAIN.md`. (`test/repl-host-tests.sh`, 7 cases passing end-to-end.)

## 5. REPL driver (Chez) and host transport

- [x] 5.1 REPL driver (`run-repl` in `src/compile.ss`) reads one form, runs it through the expander (per-form macro env + growing known set) and lowering/emit to a per-form module, and sends it to the host. Expands the define *init* (not the raw signature) so dotted/variadic defines don't crash. A bad form is reported and rolled back (all session state snapshotted).
- [x] 5.2 Chez↔host transport: `"<entry> <byte-count>\n" + IR` frames over the co-process pipe, reading the one-line result back. Host stderr is redirected off the pipe (Chez merges it) and trap detail is carried on stdout via `rt_trap_msg`. EOF from the host is detected.
- [x] 5.3 `--repl` entry path in `src/compile.ss` starts the host (building it if missing) and runs the prompt/read/print loop. The standard library is loaded as one mutually-recursive group (pre-register names → one combined `emit-repl-batch` module) so the in-language reader and other recursive prelude defs work.
- [x] 5.4 End-of-input closes the host's stdin and exits cleanly. (`test/repl-interactive-tests.sh`, 9 cases: core model, error recovery, arity-trap survival, cond/map macros, user `define-syntax`, and the in-language `read-from-string`.)

## 6. Verification and regression

- [x] 6.1 REPL scenario tests covering the `interactive-repl` spec (`test/repl-interactive-tests.sh`, 12 cases): later-form-sees-earlier-define, redefinition, forward-reference rejection, heap-value survival, symbol `eq?` persistence, arity-trap survival, macros/library, user `define-syntax`, in-language reader, and clean EOF exit.
- [x] 6.2 Backends equivalence check (`test/repl-equiv-tests.sh`, 14 programs): the REPL's final-form value equals the whole-program batch (AOT) value. (`toplevel` is excluded and documented — it uses mutual top-level recursion, which the REPL rejects by design.)
- [x] 6.3 Confirmed AOT, bitcode, and `lli` exits and the demo suite are unaffected: `demos/run-tests.sh` (34) and `demos/run-backends.sh` (34 × 3 backends, byte-identical) both green.
- [x] 6.4 Updated `README.md` with REPL usage, the interactive-REPL summary, the test-harness list, and the self-hosting/exploration pointer.

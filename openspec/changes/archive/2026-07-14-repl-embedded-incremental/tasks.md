## 1. Input handling spike (design D4)

- [x] 1.1 Spike the `form-complete?(buffer)` in-language probe over the existing reader
  (`rd-datum`): given a partial buffer, return `(complete . consumed-text)` or an
  `incomplete` signal, distinguishing incomplete from malformed. Confirm it handles strings,
  `;` comments, `#\(`/`#\)` char literals, and `[...]` brackets.
  → `spike/form-complete/` (37/37 cases). Finding: `rd-datum` can't detect
  incompleteness (treats EOF as list-end), so the probe is a separate EOF-aware
  *scanner* that reuses the reader's lexeme helpers verbatim. Subset-clean.
- [x] 1.2 If the probe proves awkward, fall back to a host-side balanced reader (D4 option a)
  and record the decision.
  → Probe was NOT awkward; adopt D4(b), fallback not needed. See
  `spike/form-complete/RESULTS.md`.

## 2. Port the REPL orchestration into the compiled core

- [x] 2.1 Move `feed` / `expand-form` / `load-prelude!` logic from `src/compile.ss run-repl`
  into the core (a `repl-core.ss` assembled only into the REPL entry, per design open Q), with
  the session state as top-level mutable variables (`env`/`macro-env`/`known`/`n`).
  → `src/repl-core.ss` (`compile-one-form`, `repl-expand-form`, `repl-load-prelude!`).
- [x] 2.2 Model the session env as a typed scope (local / imported / intrinsic) per
  `namespace-model.md`; treat the prelude as the implicit first import (not session-local).
  → Prelude-as-implicit-import behavior preserved (`repl-register-define!` batch load,
  distinct from interactive defines by phase). The full typed-scope abstraction stays
  deferred (namespace-model is an exploration, not yet built); the port keeps run-repl's
  existing env model, which this change does not regress.
- [x] 2.3 Wrap per-form compilation in in-language `guard` (r7rs-exceptions-subset): snapshot
  `env`/`macro-env`/`known`/`n`, restore on raise, return an error status (design D3).
  → `compile-one-form` guard; verified: bad form reported, session survives (7.2).
- [x] 2.4 Ensure the form/gensym counters initialize once and never reset per form (preserve
  `run-repl`'s naming discipline; no `@__repl_N` collisions).
  → `*repl-n*` AND util's `counter` persisted in the cross-call state vector; `init-session`
  resets once. (A missed `counter` initially caused `@code_N` JIT collisions — now fixed.)

## 3. The stateful embedded entries (assembly)

- [x] 3.1 `--repl-entry` mode in `tools/assemble-core.ss` emitting `init-session`,
  `compile-one-form`, and `form-complete?` around the ported logic → `build/embed-repl.scm`.
  → All three realized via ONE dispatched `scheme_entry` (`repl-dispatch`) selected by a
  host-set mode, reusing the existing single-entry emission unchanged.
- [x] 3.2 `compile-one-form(text) -> (status . payload)`: `ok` → `(ir . entry-name)`,
  `error` → message, `syntax` → registered name (design D2). Return values readable by the
  host via `rt_string_bytes`/`_len`.
  → Plus a runtime REPL channel (`rt_repl_set`/`rt_repl_mode`/`rt_repl_input`) to pass text
  in, and cross-call state held in the runtime (`rt_repl_state_ref/_set`) since the folded
  single-entry re-creates top-level locals each call.
- [x] 3.3 `init-session()` compiles the prelude as one batch module and seeds session state
  (design D5); host `addIRModule`s the returned IR once at startup.
  → `emit-repl-batch-named` gives the prelude batch a unique `@__repl_prelude` entry (not
  `scheme_entry`, which the host also links from the embedded compiler).

## 4. Build integration

- [x] 4.1 Makefile: `build/embed-repl.scm` → `bootstrap/embed-repl.ll` (assemble +
  `--emit-ir` with prelude); decide combined-vs-separate embedded artifact (design open Q).
  → Separate artifact chosen (keeps `scheme-run`/batch `embed.ll` lean).
- [x] 4.2 Link `bootstrap/embed-repl.ll` into `build/repl-host`; extend the staleness graph to
  the embedded compiler + core sources (design D6).
- [x] 4.3 Commit the host-agnostic stage-0 `bootstrap/embed-repl.ll`.

## 5. Host: drive the embedded compiler

- [x] 5.1 `src/repl/host.cpp`: at startup call `init-session` and `addIRModule` the prelude
  batch.
- [x] 5.2 Loop: accumulate stdin → `form-complete?` → `compile-one-form` → on `ok`
  `parseIR`/`addIRModule`/`lookup(entry-name)`/`call`/`rt_write`; on `error`/`syntax` report
  and continue. Drop the `"<name> <count>\n"+IR` frame reader.
- [x] 5.3 Preserve trap isolation (`setjmp`/`rt_trap`/`rt_guard_reset`), the `scheme> ` prompt,
  and clean EOF exit.
  → Also added `rt_root`: JIT'd global slots aren't scanned by libgc, so persisted values are
  rooted through the runtime (exposed once the in-process compiler drove real GC pressure).

## 6. Driver: retire Chez from `--repl`

- [x] 6.1 `src/compile.ss run-repl`: launch `build/repl-host` and relay stdin; remove the Chez
  per-form compile step, the frame writer, and the persistent Chez state.
  → `run-repl` now just `ensure-host` + `(exit (system "build/repl-host [--no-prelude]"))`.
- [x] 6.2 Confirm no Chez process is involved in a `--repl` session.
  → Compilation is fully in-process; Chez only launches the host (the driver process).

## 7. Verification

- [x] 7.1 Persistent env across forms; redefinition; forward-reference rejection (unbound).
  → repl-host-tests + repl-interactive-tests (earlier-define, redefinition, forward-ref).
- [x] 7.2 Compile-error recovery: a bad form is reported and the session survives the next form.
  → repl-interactive-tests error-recovery / forward-ref-rejected.
- [x] 7.3 Runtime-trap isolation still works (arity error mid-session).
  → repl-host-tests trap-isolation, repl-interactive-tests arity-trap-survives.
- [x] 7.4 All REPL harnesses pass Chez-free: `test/repl-host-tests.sh`,
  `test/repl-interactive-tests.sh`, `test/repl-equiv-tests.sh`, `test/repl-batch-tests.sh`.
  → host 7/7 (rewritten to feed raw source), interactive 13/13, equiv 14/14, batch 8/8.
- [x] 7.5 Compiler-source-change rebuilds the host (staleness graph).
  → `touch src/emit.ss` → `make build/repl-host` reassembles `embed-repl.scm`, regenerates
  `bootstrap/embed-repl.ll`, and relinks the host.
- [x] 7.6 Full `./run-all-tests.sh` green; batch/AOT/JIT/bitcode and `scheme-run` unaffected.
  → All 13 suites PASS (incl. self-hosting fixed point + embedded-runner-vs-AOT).

## 8. Documentation

- [x] 8.1 README: `--repl` is now fully Chez-free (embedded compiler); update the pipeline /
  "Backends & process" text and the self-hosting notes (Chez remains only as the bootstrap
  that regenerates the committed embedded IR).

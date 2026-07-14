## 1. Callable compiler entry (`--repl-entry`)

- [ ] 1.1 Add a `--repl-entry` mode to `tools/assemble-core.ss` that emits the same
  assembled core ending in a C-ABI entry instead of the `--filter-main` stdin→stdout main.
- [ ] 1.2 Define the entry `rt_compile(const char* src, size_t len) → char*` (or
  `(ptr,len)` out): build a Scheme string from `(src,len)`, call `compile-source-string`,
  return the result string's bytes. Reuse the runtime string helpers already added for
  `read-all-stdin`/`display`.
- [ ] 1.3 Implement the entry-name handshake (D3a): the compiler returns the per-form
  thunk symbol it chose — a companion `rt_compile_entry_name()` or a `{ir, entry}` return —
  so the host looks up exactly that string.
- [ ] 1.4 Sanity-check: assemble with `--repl-entry`, compile to `compiler.ll`, confirm it
  builds and exposes `rt_compile` (`nm`/`llvm-nm`).

## 2. Build integration (embed into the host)

- [ ] 2.1 Add a Makefile rule to (re)generate `compiler.ll` from the core sources via
  `schemec`/Chez.
- [ ] 2.2 Link `compiler.ll` into `build/repl-host`
  (`clang compiler.ll runtime.c host.cpp …`), keeping `-rdynamic` and libgc.
- [ ] 2.3 Extend the host staleness graph: add `compiler.ll` and the core sources behind it
  as prerequisites of `build/repl-host` so a compiler-source change rebuilds the host.
- [ ] 2.4 Check in `compiler.ll` (D6, cross-platform: core IR carries no target header) so
  a Chez-free checkout builds the host from the committed artifact; the 2.1 rule refreshes
  it after a compiler-source change.

## 3. Host: compile in-process

- [ ] 3.1 In `src/repl/host.cpp`, read a form's source text from stdin instead of an IR
  frame; drop the `"<name> <count>\n"` frame reader.
- [ ] 3.2 Call `rt_compile` on the source text, copy the returned IR bytes into the
  `parseIR` buffer (respecting the documented pointer lifetime), then run the existing
  `parseIR → addIRModule → lookup → call → rt_write` path.
- [ ] 3.3 Obtain the per-form entry symbol name via the chosen handshake (task 1.3) and use
  it for `lookup`.
- [ ] 3.4 Preserve trap isolation (`setjmp`/`rt_trap`) and error reporting for both compile
  errors (from `rt_compile`) and runtime traps.

## 4. Driver: retire Chez from `--repl`

- [ ] 4.1 In `src/compile.ss`, change the `--repl` driver to launch `build/repl-host` and
  relay source text; remove the Chez per-form compile step and the frame writer.
- [ ] 4.2 Confirm no Chez process is involved in a `--repl` session (verify via process
  inspection / by running with Chez unavailable on PATH for the compile step).
- [ ] 4.3 Leave batch/AOT/JIT/bitcode paths untouched.

## 5. Namespace hygiene

- [ ] 5.1 Audit the embedded compiler for unmangled top-level globals that could collide
  with user `define`s in the shared process; apply a compiler-private prefix as needed.
- [ ] 5.2 Confirm the design does not hardcode a single flat namespace, leaving room for
  future module-scoped names.

## 6. Verification

- [ ] 6.1 REPL end-to-end harness (`test/repl-host-tests.sh`) passes against the embedded
  host.
- [ ] 6.2 Interactive `--repl` harness (`test/repl-interactive-tests.sh`) passes with Chez
  removed from the compile path.
- [ ] 6.3 REPL-vs-batch equivalence harness (`test/repl-equiv-tests.sh`) passes,
  demonstrating dev→ship fidelity.
- [ ] 6.4 Persistent-globals / redefinition harness (`test/repl-batch-tests.sh`) passes.
- [ ] 6.5 Full `./run-all-tests.sh` roll-up is green (batch demos + backends unaffected).
- [ ] 6.6 Verify the staleness graph: touch a compiler source, start the REPL, confirm the
  host rebuilds before the first form.

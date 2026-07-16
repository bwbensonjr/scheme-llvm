# Emit

A Scheme to LLVM compiler

Emit is a **self-hosting Scheme→LLVM compiler**: a hand-rolled
frontend pipeline that emits textual LLVM IR, a small C runtime under
Boehm GC, and **three backends** (AOT, JIT, bitcode) that are checked
to agree byte-for-byte. There is an **interactive REPL** on a
persistent LLVM ORC/LLJIT host, where each form is compiled by the
**embedded compiler in-process** into a long-lived session. The
compiler is written in Scheme and compiles its own source to a
**byte-identical fixed point** — so the day-to-day build, run, REPL,
and recompile loop needs **only LLVM 22 + libgcz**. The ability to
host with Chez Scheme survives as the historical genesis
(`historical/genesis/`) and an optional CI trust-check. The
implementation prioritizes simple, transparent stages (see
`CLAUDE.md`); development is OpenSpec-driven, tracked under
`openspec/`. There is a high-level architectural goal of generating
standalone native-code executables while also supporting incremental
REPL-based development and debugging.

## Quick start

**Install LLVM 22 + libgc** (`brew install llvm@22 bdw-gc`).

```sh
# build the shipped binaries from the committed compiler LLVM IR
make                       # -> build/scheme-run (runner) and build/repl-host (REPL)

# In-process compile-and-run. The compiled compiler is linked into
# build/scheme-run; it compiles the program to IR in-process and JITs
# it via ORC/LLJIT.
build/scheme-run < demos/fact.scm                              # => 120

# standalone native executable (emit IR + clang):
bin/scheme-compile demos/fact.scm -o /tmp/fact && /tmp/fact    # => 120
build/scheme-run --emit < demos/fact.scm > /tmp/fact.ll        # (the emit step alone)

# Interactive REPL: the embedded compiler is linked into
# build/repl-host and compiles each form IN-PROCESS.  Run the host
# directly:
build/repl-host                                                # ^D to exit
build/repl-host --no-prelude                                   # faster start, no stdlib
#   scheme> (define (sq n) (* n n))
#   scheme> (sq 9)          => 81
#   scheme> (define sq 100) => 100   ; redefinition; later forms see the new binding

# The batch text->IR filter compiler
make schemec
cat src/prelude.scm demos/fact.scm | build/schemec > /tmp/fact.ll   # source text -> LLVM IR

# Run the default test suite (exercises the shipped binaries)
./run-all-tests.sh
```

**Changing the compiler.** Edit the source, then regenerate the committed IR and relink —
the compiled compiler recompiles itself. See
[Regenerating the compiler](#regenerating-the-compiler-bootstrap) for how it works and the
anti-stale trust-check.

```sh
make regen                 # reassemble source (cat) + self-compile IR + relink
```

The Chez-gated developer/CI suite (backend equivalence, the self-hosting fixed point, the
IL-level unit tests, and the trust-check) is `./run-dev-tests.sh`; it auto-skips when `chez`
is absent.

### Interactive REPL

`build/repl-host` is a read-eval-print loop backed by a **persistent
LLVM ORC/LLJIT host** (`src/repl/host.cpp`, built by `make
repl-host`). The host **A-links the embedded compiler** (the committed
`bootstrap/embed-repl.ll`) and compiles each entered form **in-process
— no per-form subprocess**. Each form is compiled to its own module
and added to a long-lived JIT in which the GC heap, symbol table, and
runtime stay alive, so definitions, closures, and heap values persist
across forms and top-level names can be redefined. A bad form's
compile error is reported and the session state rolled back (via
in-language `guard`), and runtime traps (e.g. arity errors) are
isolated, so the session continues; `^D` (end of input)
exits. References resolve to earlier forms only — mutual top-level
recursion (which the whole-program batch `letrec` supports) is not
available interactively. (A Chez Scheme launcher, `chez --libdirs src
--script src/compile.ss --repl`, builds and execs the same host.)

## Regenerating the compiler (bootstrap)

The binaries are linked from **committed compiler IR** under `bootstrap/` — host-agnostic
stage-0 artifacts that are the **favored, authoritative form**:

- `bootstrap/schemec.ll` — the batch text→IR filter compiler
- `bootstrap/embed.ll` — the in-process runner's embedded compiler
- `bootstrap/embed-repl.ll` — the interactive REPL's embedded compiler

These are produced by the **compiled compiler itself** (the self-hosting fixed point), so they
regenerate. The default `make` treats them as **checked-in inputs**: it links
them with LLVM only and never regenerates them. To rebuild them after a compiler-source change:

```sh
make regen                 # see tools/regen.sh
```

`regen` (1) **assembles** the flat source by ordered `cat` — the
source files are already concatenation-ready (flat
`match.scm`/`util.scm`, `core.ss` with no `include`s, per-target
`entry-*.scm`) — and (2) **compiles** with the self-hosted `schemec`,
iterating it to its byte-identical fixed point before emitting the
other artifacts.

Because the default build does not auto-regenerate (design D4 — this deliberately **reverses**
the earlier `fix-stale-repl-host-rebuild` auto-rebuild-on-source-change, so the committed IR
is authoritative and never silently rebuilt), a **trust-check** guards against stale IR:
`test/trust-check.sh` (run by `run-dev-tests.sh`) regenerates from a clean tree and asserts
`git diff --exit-code bootstrap/` — a compiler edit that forgot `make regen` fails loudly in
CI. `test/self-host-fixpoint.sh` doubles as an **independent-host** re-derivation: Chez rebuilds
the compiler from the current flat source and must reach the *same committed* fixed point.

Chez is otherwise needed only for the developer/CI suite; the pre-flattening Chez assembler and
library-structured source are frozen under `historical/genesis/`.

## Layout

- `src/` — the **flat, concatenation-ready** compiler source (the single source of truth):
  `match.scm` (pattern matcher), `util.scm` (helpers), `parse.ss`, `passes/`, `emit.ss`,
  `core.ss` (the pure forms→IR core; no `include`s — the passes are concatenated ahead of it),
  `prelude.scm` (standard library), `repl-core.ss` (interactive orchestration), and the
  per-target entries `entry-{schemec,embed,repl}.scm`. `compile.ss` is the Chez driver, which
  `(include ...)`s the same flat files (no separate library tree).
- `src/repl/` — the persistent REPL host: `host.cpp` (LLVM ORC/LLJIT), which A-links the
  embedded compiler (`bootstrap/embed-repl.ll`) and drives it in-process; built by `make repl-host`.
- `src/run.cpp` — the in-process runner (`build/scheme-run`): links the compiled compiler
  (`bootstrap/embed.ll`) and JITs its output, so a whole program is compiled *and* run in one
  process. With the prelude re-homed as `(scheme base)` the entry returns two modules (the
  `(scheme base)` library and the program) separated by a boundary marker; the host splits on it
  and JITs both. `--emit` writes the whole IR to stdout; `--no-prelude` skips the auto-import.
- `bootstrap/` — committed host-agnostic stage-0 IR (the authoritative form): `schemec.ll`
  (batch filter), `embed.ll` (runner), `embed-repl.ll` (REPL); regenerate with `make regen`.
- `tools/regen.sh` — the regenerator (ordered-`cat` assembly + self-hosted compile).
- `bin/scheme-compile` — source→native-executable wrapper (`scheme-run --emit` + clang); splits
  the emitted IR on the boundary marker and clang-links the `(scheme base)` unit + program.
- `historical/genesis/` — the frozen pre-flattening genesis: the Chez Scheme assembler
  (`assemble-core.ss`) and library-structured `match.sls`/`util.ss` (provenance; not maintained).
- `demos/` — example programs and the `run-tests.sh` (`RUNNER=scheme-run|aot`) / `run-backends.sh`
  / `run-embedded.sh` harnesses.
- `test/` — REPL harnesses, the front-end unit tests, `self-host-fixpoint.sh`, and `trust-check.sh`.
- `run-all-tests.sh` — the default suite (shipped binaries); `run-dev-tests.sh`
  — the **Chez-gated** developer/CI suite (backends, self-host, IL units, trust-check).
- `openspec/` — specs (`specs/`), archived changes (`changes/archive/`), and forward-looking
  notes (`explorations/`).
- `LLVM.md`, `docs/PIPELINE.md` — value representation / calling convention, and the pass
  ladder.
- `docs/OUTPUT.md` — the tool-output convention: message format, stderr/stdout discipline,
  and the `EMIT_VERBOSITY` control that every build/compile/regen/test tool honors.
- `tools/log.sh` — the shared `say`/`vsay`/`bytes` helpers that implement that convention.

## Pipeline

Hand-rolled `match` passes, one observable intermediate language per `--dump` stage:

```
read (host) → prepend prelude → collect-toplevel → expand → parse+rename → recognize-let
            → convert-assignments → convert-closures → lambda-lift+lower
            → emit .ll → clang (+ runtime, + libgc)
```

Values are tagged 64-bit words. All 8 tags are assigned: fixnum, boolean, nil, pair,
closure, box, symbol (interned), and an extended/header-word object (tag 7) hosting strings
(UTF-8) and characters (Unicode codepoints). Every Scheme function shares one `tailcc`
prototype `(self, argc, a0…a{K-1}, overflow)`, so tail calls are emitted `musttail`
(bounded stack verified at 10M iterations).

## Accomplished

**Language**
- Core: `lambda`, `if`, `let`/`letrec`, `begin`, `set!`, application, top-level `define`,
  multi-form programs.
- Derived forms: `cond` (with `else`/`=>`/bare-test clauses), `and`, `or`, `when`, `unless`,
  `let*` — realized as `syntax-rules` macros in the prelude; named `let` (hand-written).
- **Macros**: `define-syntax` + `syntax-rules` (literals, `_`, ellipsis), a fixpoint
  `expand` stage, hygienic for macro-introduced identifiers.
- **Exceptions (R7RS-small subset)**: `guard`, `raise`, and `error` with catchable error
  objects (`error-object?`/`-message`/`-irritants`). `guard` is a one-shot upward escape
  over a runtime `setjmp` frame stack (no `call/cc` needed); an uncaught raise aborts as
  before. `error` is a superset — `(error message ...)` (R7RS) or `(error who message ...)`.
- Arithmetic: n-ary `+ - *`. Comparisons: n-ary/chained `= < > <= >=`, `eq?` / `eqv?`, and
  structural `equal?`.
- Variadic `lambda`, dotted rest parameters, `apply`, and runtime arity checking — on the
  uniform `argc`+`overflow` calling convention, preserving `musttail`.
- `quote` of symbols and arbitrary nested structure; `quasiquote` (`` ` ``/`,`/`,@`) over
  list structure with nesting-level tracking — a built-in expander transformer that lowers
  to `cons`/`append`/`list`/`quote`.

**Data & runtime**
- Fixnums, booleans, `()`, pairs, closures, boxes; **interned symbols and characters**
  (`eq?` / `eqv?` by identity); **strings and characters** that are Unicode-capable (UTF-8
  storage, codepoint-indexed operations, in-place `string-set!`); **vectors** (mutable,
  fixed-length, `#(...)` syntax).
- Primitives: `+ - * = < cons car cdr null? pair? eq? eqv? equal? not char->integer
  integer->char string-length string-ref substring string->symbol string=? string-append
  symbol->string list->string make-string string-set! string-copy`, and `display`
  (writes any datum in *display* style — strings unquoted, characters raw — to stdout).
- C runtime under Boehm GC; a tag-walking value printer shared by `display` (display
  style) and the final-value printer (write style: quoted strings, `#\`-prefixed chars).

**Library & reader**
- A prelude re-homed as the library `(scheme base)`, auto-imported into every program on all
  three doors — the Chez driver, the REPL, and the Chez-free embedded runner
  (`scheme-run`/`scheme-compile`) — with user-wins shadowing and `--no-prelude` to opt out:
  `list length reverse append map memq assq member assoc filter fold-left fold-right`,
  the n-ary character comparisons `char=? char<? char>? char<=? char>=?`, and `string->list`.
  (The compiler's own bootstrap still prepends the prelude for its self-compilation.)
- `read-from-string` — a recursive-descent Scheme reader (integers, symbols, lists,
  dotted/improper lists, `#t`/`#f`, characters incl. named `#\newline`/`#\space`/…,
  `"strings"` with `\n`/`\t`/`\r`/`\\`/`\"`/`\xHH;` escapes, `#(...)` vectors, `'`-quote
  and `` ` ``/`,`/`,@` quasiquote sugar, `;` comments).

**Backends & process**
- AOT / JIT / bitcode from one emitted `.ll`, with a 3-way equivalence harness.
- **In-process embedded run** (`build/scheme-run`, Path A — mechanism): the compiled
  compiler is linked into a JIT host (`src/run.cpp`); its ccc `scheme_entry` reads the
  program, returns the emitted IR as a string, and the host JITs and runs it — a whole
  program compiled *and* run in one process.
  A parity harness checks the runner agrees with AOT on every demo (dev→ship fidelity). The
  compiler IR is a committed, host-agnostic stage-0 artifact (`bootstrap/embed.ll`).
- **Interactive REPL** (`--repl`) on a persistent LLVM ORC/LLJIT host, driven by the
  **embedded compiler in-process** (Path A for the REPL — **no per-form
  subprocess**; `bootstrap/embed-repl.ll` A-linked into the host): per-form modules added to
  a long-lived JIT with a shared GC heap / symbol table / runtime, so definitions, closures,
  heap values, and redefinition persist across forms; compile errors roll back (in-language
  `guard`) and runtime traps (arity errors) are isolated so the session survives. A
  REPL-vs-batch equivalence harness checks the two agree on final values — the same compiler
  core drives both (dev→ship fidelity).
- OpenSpec-driven changes; decisions (framework, calling convention) backed by spikes.

## Not yet done

**Larger language features**
- **Macros (follow-ons)** — `let-syntax`/`letrec-syntax` (local macros), procedural /
  `syntax-case` macros, and full referential-transparency hygiene (the current expander is
  hygienic for macro-introduced identifiers only).
- **Numeric tower** — fixnums only; no bignums/flonums/rationals, no `quotient`/`remainder`/
  `/`, no overflow handling.
- **Control**: `call/cc`, `values`/`call-with-values`, `dynamic-wind`; and the rest of the
  R7RS exception system beyond the shipped subset — `with-exception-handler` and
  `raise-continuable` (their non-unwinding/resumable semantics need `call/cc`),
  `read-error?`/`file-error?`.
- **Data**: bytevectors, hash tables, records (vectors done).
- **I/O**: ports, files, `read` from stdin, `write` as a procedure (`display` is
  supported — see above; `newline`/`write`/ports are not yet).
- Recoverable error handling: `guard` catches in-language `raise`/`error` (see above), but
  runtime type/arity errors are still not guard-catchable (they trap to the host, per R7RS
  "it is an error" latitude); no general condition-type hierarchy.

**Self-hosting (the north star)**
- The compiler compiles itself to a byte-identical fixed point, and there are now three
  Chez-free ways to *use* it: the batch `schemec` filter (Path C, subprocess), the in-process
  `build/scheme-run` (Path A — mechanism, whole program compiled and JIT-run in one process),
  and the **interactive `--repl`**, whose stateful, incremental orchestration (persistent env,
  per-form modules, compile-error rollback via in-language `guard`) is now **ported into the
  embedded compiler** (`src/repl-core.ss`, A-linked as `bootstrap/embed-repl.ll`) and runs
  in-process — completing Path A for the REPL (change: `repl-embedded-incremental`). Chez
  remains only as the **bootstrap** that regenerates the committed embedded IR from source.
  See `openspec/explorations/modules-and-embedding.md` and `…/chez-free-repl.md` for the
  roadmap.

**Performance / cleanup (deferred by design)**
- No dead-code elimination (the whole prelude is emitted into every program); O(n)
  codepoint string indexing; separate/precompiled prelude; immediate (non-heap) characters.

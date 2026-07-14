# Scheme LLVM

Experiment with compiling Scheme into LLVM IR.

A **Chez-hosted Scheme→LLVM compiler**: a hand-rolled frontend pipeline that emits textual
LLVM IR, a small C runtime under Boehm GC, and **three backends** (AOT, JIT, bitcode) that
are checked to agree byte-for-byte. **34 demos pass, all three backends in agreement.**
There is also an **interactive REPL** on a persistent LLVM ORC/LLJIT host (`--repl`), where
each form is JIT-compiled into a long-lived session. The compiler is written in Scheme
(bootstrapped with Chez), with an eventual self-hosting goal, and prioritizes simple,
transparent stages (see `CLAUDE.md`). Development is OpenSpec-driven, tracked under
`openspec/`.

## Installing the toolchain

The compiler needs **Chez Scheme** (invoked as `chez`), **Boehm GC** (`libgc`), and — for the
JIT, bitcode, and REPL backends — **LLVM 22**. Nothing is hardcoded to a specific install
location: `tools/toolchain.sh` discovers LLVM 22 and libgc on the host, and
`tools/toolchain.sh check` prints exactly what it resolved. Override discovery with
`LLVM_CONFIG` or `LLVM_PREFIX` (and `GC_PREFIX`, or `GC_INC`/`GC_LIB`) if your install lives
somewhere unusual.

### macOS (Homebrew)

```sh
brew install llvm@22 bdw-gc chezscheme
```

The `llvm@22` keg (at `/opt/homebrew/opt/llvm@22`), libgc, and the `chez` command are all found
automatically; the AOT backend uses Apple's own `clang`.

### Ubuntu / Debian

LLVM 22 is newer than the distribution's repositories, so add the official LLVM apt repository
first. The `llvm.sh` helper from <https://apt.llvm.org> adds the repo and installs the base
`clang-22`/`llvm-22`:

```sh
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 22
```

Then install the LLVM 22 development packages, libgc, and the C++ standard library the REPL
host links against:

```sh
sudo apt-get install -y \
  llvm-22 llvm-22-dev llvm-22-runtime clang-22 \
  libgc-dev libstdc++-14-dev
```

Notes:

- **`libstdc++-14-dev`** matches the GCC install LLVM's `clang++` selects by default (the
  highest present — gcc-14 on Ubuntu 24.04). Without it the REPL host build fails with
  `'type_traits' file not found`.
- If `apt` reports unmet dependencies for `libz3`/`libobjc`, enable the **universe** component
  (`sudo add-apt-repository universe`) — LLVM 22's dependencies live there.
- **Chez Scheme:** the project targets Chez **10.x**; Ubuntu's `chezscheme` package is 9.5.8
  (too old), so build a recent Chez from source. However installed, the binary is often named
  `scheme` rather than `chez`. Because Chez selects its boot file from the name it is invoked
  as, a plain `chez` symlink fails (`cannot find compatible chez.boot`); use a wrapper on your
  `PATH` instead:

  ```sh
  printf '#!/bin/sh\nexec "$(command -v scheme)" "$@"\n' > ~/.local/bin/chez
  chmod +x ~/.local/bin/chez
  ```

### Verify

```sh
tools/toolchain.sh check     # resolved llvm-config, tool dir, cc, and libgc paths
```

## Quick start

Install the toolchain first — see [Installing the toolchain](#installing-the-toolchain) for
macOS and Linux steps. In short: `chez` (Chez Scheme), Boehm GC (`libgc`), and LLVM 22; the
build discovers LLVM 22 and libgc on the host, so no paths are hardcoded.

```sh
# compile and run a demo (AOT is the default backend)
chez --libdirs src --script src/compile.ss demos/fact.scm -o /tmp/fact && /tmp/fact   # => 120

# other backends, IL dump, and disabling the prelude
chez --libdirs src --script src/compile.ss demos/fact.scm --backend jit
chez --libdirs src --script src/compile.ss demos/fact.scm --backend bitcode -o /tmp/fact
chez --libdirs src --script src/compile.ss demos/fact.scm --dump          # print IL after each pass
chez --libdirs src --script src/compile.ss demos/fact.scm --no-prelude

# interactive REPL (persistent ORC/LLJIT host; builds build/repl-host on first use)
chez --libdirs src --script src/compile.ss --repl              # ^D to exit
chez --libdirs src --script src/compile.ss --repl --no-prelude # faster start, no stdlib
#   scheme> (define (sq n) (* n n))
#   scheme> (sq 9)          => 81
#   scheme> (define sq 100) => 100   ; redefinition; later forms see the new binding

# run every harness below in one shot, with a roll-up summary
./run-all-tests.sh

# test harnesses (each also runnable on its own)
demos/run-tests.sh              # compile+run every demo, compare to expected values
demos/run-backends.sh           # assert AOT = JIT = bitcode for each demo
test/repl-frontend.ss           # REPL front-end unit tests (chez --script)
test/repl-host-tests.sh         # persistent host, end-to-end
test/repl-interactive-tests.sh  # interactive `--repl`, end-to-end
test/repl-equiv-tests.sh        # REPL final value == batch build value
test/repl-batch-tests.sh        # persistent globals via batch build (redefinition, recursion)
```

### Interactive REPL

`--repl` runs a read-eval-print loop backed by a **persistent LLVM ORC/LLJIT host**
(`src/repl/host.cpp`, built via `make build/repl-host` — automatically, and rebuilt whenever
the runtime or host sources change). Each
entered form is compiled to its own module and added to a long-lived JIT in which the GC
heap, symbol table, and runtime stay alive, so definitions, closures, and heap values
persist across forms and top-level names can be redefined. Runtime traps (e.g. arity errors)
are isolated, so a bad form is reported and the session continues; `^D` (end of input) exits.
It needs the LLVM 22 development install (headers + `llvm-config`; see
[Installing the toolchain](#installing-the-toolchain)). References resolve to earlier forms
only — mutual top-level recursion (which the whole-program batch letrec supports) is not
available interactively.

## Layout

- `src/` — the compiler: `compile.ss` (driver + `--repl`), `parse.ss`, `passes/`, `emit.ss`,
  `runtime/runtime.c`, and `prelude.scm` (standard library, prepended to every program).
- `src/repl/` — the persistent REPL host: `host.cpp` (LLVM ORC/LLJIT); built by the
  top-level `Makefile` (`build-host.sh` is a thin wrapper over `make build/repl-host`).
- `demos/` — example programs and the `run-tests.sh` / `run-backends.sh` harnesses.
- `test/` — REPL test harnesses and the front-end unit tests.
- `run-all-tests.sh` — top-level runner that invokes every `demos/` and `test/`
  harness and prints a pass/fail roll-up.
- `openspec/` — specs (`specs/`), archived changes (`changes/archive/`), and forward-looking
  notes (`explorations/`).
- `LLVM.md`, `docs/PIPELINE.md` — value representation / calling convention, and the pass
  ladder.

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
  symbol->string list->string make-string string-set! string-copy`.
- C runtime under Boehm GC; a tag-walking value printer.

**Library & reader**
- A prelude prepended to every program (user-wins shadowing, `--no-prelude`):
  `list length reverse append map memq assq member assoc filter fold-left fold-right`,
  the n-ary character comparisons `char=? char<? char>? char<=? char>=?`, and `string->list`.
- `read-from-string` — a recursive-descent Scheme reader (integers, symbols, lists,
  dotted/improper lists, `#t`/`#f`, characters incl. named `#\newline`/`#\space`/…,
  `"strings"` with `\n`/`\t`/`\r`/`\\`/`\"`/`\xHH;` escapes, `#(...)` vectors, `'`-quote
  and `` ` ``/`,`/`,@` quasiquote sugar, `;` comments).

**Backends & process**
- AOT / JIT / bitcode from one emitted `.ll`, with a 3-way equivalence harness.
- **Interactive REPL** (`--repl`) on a persistent LLVM ORC/LLJIT host: per-form modules
  added to a long-lived JIT with a shared GC heap / symbol table / runtime, so definitions,
  closures, heap values, and redefinition persist across forms; runtime traps (arity errors)
  are isolated so the session survives. A REPL-vs-batch equivalence harness checks the two
  agree on final values.
- OpenSpec-driven changes; decisions (framework, calling convention) backed by spikes.

## Not yet done

**Larger language features**
- **Macros (follow-ons)** — `let-syntax`/`letrec-syntax` (local macros), procedural /
  `syntax-case` macros, and full referential-transparency hygiene (the current expander is
  hygienic for macro-introduced identifiers only).
- **Numeric tower** — fixnums only; no bignums/flonums/rationals, no `quotient`/`remainder`/
  `/`, no overflow handling.
- **Control**: `call/cc`, `values`/`call-with-values`, exceptions/`guard`, `dynamic-wind`.
- **Data**: bytevectors, hash tables, records (vectors done).
- **I/O**: ports, files, `read` from stdin, `display`/`write` as procedures.
- Recoverable error handling: arity errors are isolated in the REPL host (the session
  survives) but still abort the standalone AOT/JIT executables; no general condition system.

**Self-hosting (the north star)**
- The compiler is still Chez-hosted and uses the host `read`. The concrete path: swap host
  `read` for the Scheme `read-from-string`, then port the passes to run within the compiled
  subset — what the recent data-type / prelude / reader changes were building toward. The
  REPL's execution host is already Chez-free; see `openspec/explorations/chez-free-repl.md`
  for the roadmap (the gap is the compiler front end).

**Performance / cleanup (deferred by design)**
- No dead-code elimination (the whole prelude is emitted into every program); O(n)
  codepoint string indexing; separate/precompiled prelude; immediate (non-heap) characters.

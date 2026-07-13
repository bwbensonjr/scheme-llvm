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

## Quick start

Requires `chez` (Chez Scheme), `clang`, and Boehm GC (`libgc`, e.g. `brew install bdw-gc`);
the JIT and bitcode backends additionally use LLVM 22 (`brew install llvm@22`).

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
(`src/repl/host.cpp`, built via `src/repl/build-host.sh` — automatically on first use). Each
entered form is compiled to its own module and added to a long-lived JIT in which the GC
heap, symbol table, and runtime stay alive, so definitions, closures, and heap values
persist across forms and top-level names can be redefined. Runtime traps (e.g. arity errors)
are isolated, so a bad form is reported and the session continues; `^D` (end of input) exits.
It needs the LLVM 22 development install (headers + `llvm-config`, from the same `llvm@22`
keg). References resolve to earlier forms only — mutual top-level recursion (which the
whole-program batch letrec supports) is not available interactively.

## Layout

- `src/` — the compiler: `compile.ss` (driver + `--repl`), `parse.ss`, `passes/`, `emit.ss`,
  `runtime/runtime.c`, and `prelude.scm` (standard library, prepended to every program).
- `src/repl/` — the persistent REPL host: `host.cpp` (LLVM ORC/LLJIT) and `build-host.sh`.
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
- `quote` of symbols and arbitrary nested structure.

**Data & runtime**
- Fixnums, booleans, `()`, pairs, closures, boxes; **interned symbols and characters**
  (`eq?` / `eqv?` by identity); **strings and characters** that are Unicode-capable (UTF-8
  storage, codepoint-indexed operations); **vectors** (mutable, fixed-length, `#(...)` syntax).
- Primitives: `+ - * = < cons car cdr null? pair? eq? eqv? equal? not char->integer
  integer->char string-length string-ref substring string->symbol string=? string-append
  symbol->string list->string make-string`.
- C runtime under Boehm GC; a tag-walking value printer.

**Library & reader**
- A prelude prepended to every program (user-wins shadowing, `--no-prelude`):
  `list length reverse append map memq assq member assoc filter fold-left fold-right`,
  the n-ary character comparisons `char=? char<? char>? char<=? char>=?`, and `string->list`.
- `read-from-string` — a recursive-descent Scheme reader (integers, symbols, lists,
  `#t`/`#f`, `#\char`, `"strings"`, `#(...)` vectors, `'`-quote sugar, `;` comments).

**Backends & process**
- AOT / JIT / bitcode from one emitted `.ll`, with a 3-way equivalence harness.
- **Interactive REPL** (`--repl`) on a persistent LLVM ORC/LLJIT host: per-form modules
  added to a long-lived JIT with a shared GC heap / symbol table / runtime, so definitions,
  closures, heap values, and redefinition persist across forms; runtime traps (arity errors)
  are isolated so the session survives. A REPL-vs-batch equivalence harness checks the two
  agree on final values.
- OpenSpec-driven changes; decisions (framework, calling convention) backed by spikes.

## Not yet done

**Near-term (additive)**
- String mutation: `string-set!` (and `string-copy`) — the one deferred string op.
- Reader extensions: string escapes, named characters, dotted pairs, quasiquote.

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

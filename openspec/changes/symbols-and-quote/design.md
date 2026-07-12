## Context

Values are tagged i64 words; tags 0–5 are used (fixnum, bool, nil, pair, closure, box),
leaving 6–7 free. `parse` lowers `(quote d)` to `(const d)`, and `encode-const` handles
only exact integers, booleans, and `()`; a symbol or pair constant errors. So `(quote
foo)` and `(quote (1 2))` cannot compile today. Symbols are the prerequisite for the
reader and macros, and for self-hosting (the compiler manipulates symbolic code and
compares symbols with `eq?`).

## Goals / Non-Goals

**Goals:**
- A `symbol` data type: interned (equal names ⇒ pointer-identical), `eq?`-comparable,
  printed by name.
- `quote` of symbols and of arbitrary list/atom structure (nested pairs, symbols,
  fixnums, booleans, `()`).

**Non-Goals:**
- Strings and characters (separate change; the reader needs them but `quote` does not).
- `string->symbol` / `symbol->string` and other symbol procedures (later).
- Guaranteed `eq?` identity between *distinct* quoted-list literals (only symbols are
  interned; see D3).

## Decisions

### D1 — Symbol representation: tag 6, interned

`TAG_SYMBOL = 6`. A symbol is a heap object holding its name; `rt_intern(const char*)`
looks the name up in a process-wide intern table and returns the existing symbol or
creates one. Because interning canonicalizes, `eq?` (pointer/word equality, already
implemented) is correct for symbols with no change. `rt_write` prints the name. The intern
table is a GC root (allocated through / known to `libgc`) so interned symbols survive.

### D2 — Emitting a symbol literal

For `(const sym)`, emit a **private string constant** global in the `.ll`
(e.g. `@.str.sym.N = private constant [len x i8] c"name\00"`) and a call
`call i64 @rt_intern(ptr @.str.sym.N)` at the use site. This adds a small new emitter
ability (private string constants); it is contained and reused by the reader later.

**Alternative considered:** a one-time table of symbol globals initialized in an
`rt_init`/module ctor. Rejected for now — per-use `rt_intern` is simpler and, because
interning is a cheap hash lookup, fast enough; hoisting to build-once globals is a later
optimization.

### D3 — Materializing quoted structure: runtime cons-up

A quoted pair/list `(const (a . d))` is materialized by emitting code that builds it:
`rt_cons(<encode a>, <encode d>)`, recursing so nested lists, symbols (via `rt_intern`),
and immediates (inline encoding) compose. Chosen over a **static data section** because it
introduces no new IR/representation concepts, matches the compiler's existing "emit calls
to the runtime" style, and reuses `rt_cons`.

Consequence: a quoted list literal is **rebuilt each time it is evaluated**, so two
evaluations are `equal?` but not `eq?`. This is acceptable for the subset (nothing relies
on quoted-list identity; symbols *are* interned so symbol `eq?` holds). A future
optimization can hoist a literal into a build-once global for identity + speed — noted, not
done here.

### D4 — Frontend unchanged

`parse` already produces `(const d)` for any quoted datum, and `rename` leaves consts
alone. Only the emitter changes (encode-const grows symbol + pair cases, recursing). No
new pass or stage.

## Risks / Trade-offs

- **Intern table + GC** → the table must be reachable by Boehm (a static/`GC`-managed
  root) or symbols get collected; verified by a demo that interns, drops the reference,
  allocates heavily, then compares `eq?`.
- **String-constant emission correctness** → escape/length of the `c"…"` literal must be
  right (embedded special chars, the trailing `\00`); covered by symbol demos with varied
  names.
- **Quoted-structure rebuild cost / identity** → documented (D3); only symbols guarantee
  `eq?`. Optimize with build-once globals later if needed.
- **Cross-backend behavior** → `rt_intern`/`rt_cons` materialization must give identical
  results under AOT/JIT/bitcode; the 3-backend harness with quote/symbol demos is the
  gate.
- **Tag budget** → tag 6 used here; only tag 7 remains for immediates/heap after this. A
  future type past that needs a header-word scheme (note for strings/vectors/chars).

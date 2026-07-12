## Context

The pipeline spec's spine is `read → expand → core → … → emit`, but `read` is currently the
host Chez `read` in `compile.ss`. Everything a Scheme reader needs is now present: symbols
(interned) and `string->symbol`, strings and characters, the codepoint-indexed accessors
(`string-length`, `string-ref`, `substring`, `char->integer`), `cons`/`car`/`cdr`, fixnum
arithmetic and `=`/`<`, and — from the prelude mechanism — a home for reusable Scheme code.
This change writes the reader in Scheme and puts it in the prelude.

## Goals / Non-Goals

**Goals:**
- `read-from-string`: source string → the first datum, for the v1 datum set below.
- Pure M-subset Scheme in the prelude; no runtime, emitter, or pass changes.
- Read symbols via `string->symbol` so they are `eq?` to literals.

**Non-Goals (deferred):**
- String **escape sequences** (`\n`, `\t`, `\"`, `\\`) — they need a char→string builder
  (`list->string` / a string buffer), which is not in the subset yet.
- **Named characters** (`#\space`, `#\newline`, `#\tab`).
- **Dotted pairs** `( a . b )`, **quasiquote**/unquote, **vectors** `#( … )`.
- The wider **number tower** (floats, rationals, radix/`#x` prefixes) — v1 reads signed
  integers only.
- Reading from a **port / stdin** — there is no I/O yet; the reader consumes a string.
- Replacing the compiler's own front-end `read` (a later self-hosting milestone).

## Decisions

### D1 — Recursive descent with a functional position

`read-from-string s` calls an internal `read-datum s i` that returns a pair
`(datum . next-index)`; list reading accumulates elements until `)` and threads the index
through. The position is carried functionally (no mutation, no ports) — the M-subset has
`cons`/`car`/`cdr` and that is enough. `read-from-string` returns just the datum (the first
one); a `read-all` returning every datum is a trivial future addition.

### D2 — Tokenizing with the codepoint accessors

Scanning uses `string-length` / `string-ref` (codepoint-indexed) and classifies characters
by comparing `char->integer` against ASCII code points (whitespace, digits, `(`, `)`, `"`,
`;`, `#`, `'`, delimiter). Character predicates are written inline in Scheme on top of
`char->integer` + `=`/`<`, so no new `char=?`/`char<?` primitives are needed. Tokens
(symbols, strings) are extracted with `substring` over the scanned codepoint range, which
preserves their UTF-8 bytes; a symbol token is then interned with `string->symbol`.

### D3 — v1 datum grammar

Skipping whitespace and `;`-to-end-of-line comments between tokens:
- **integer** — optional `-`/`+` then digits → a fixnum (built by `acc*10 + (d-48)`);
- **symbol** — a run of non-delimiter characters not starting a number → `string->symbol`;
- **list** — `(` … `)` of whitespace-separated datums → a proper list (empty → `()`);
- **boolean** — `#t` / `#f`;
- **character** — `#\` then one codepoint → that character (via the source `string-ref`);
- **string** — `"` … `"`, contents copied verbatim by `substring` (no escapes, D-nongoal);
- **quote sugar** — `'x` reads `x` and wraps it as `(quote x)`.

### D4 — Lives in the prelude, reuses library helpers

The reader is added to `src/prelude.scm`, so any program (compiled with the prelude, the
default) can call `read-from-string`. It reuses prelude helpers (`reverse` to fix
accumulated list order, etc.); everything sits in the program's top-level `letrec`, so the
reader's internal helpers are mutually recursive with no extra machinery.

## Risks / Trade-offs

- **Scope creep** → v1 deliberately omits escapes, named chars, dotted pairs, quasiquote,
  vectors, and the number tower (D-nongoals); each is an additive follow-on.
- **Error handling** → malformed input (unbalanced parens, bad `#…`) has undefined behavior
  in v1; a real error/`condition` story is future. Demos read well-formed input.
- **O(n) codepoint indexing** → `string-ref`/`substring` are O(n) (from the string-ops
  change); the reader is O(n²) on input length in the worst case. Acceptable for source-file
  sizes now; a byte-cursor or codepoint-array representation optimizes it later behind the
  same interface.
- **Cross-backend** → the reader is ordinary compiled Scheme, so it must give identical
  results under AOT/JIT/bitcode; the 3-backend harness with reader demos is the gate.

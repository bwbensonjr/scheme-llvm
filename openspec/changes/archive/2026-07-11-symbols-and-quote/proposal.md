## Why

`quote` today only handles immediates: `(quote foo)` and `(quote (1 2))` both die in
`encode-const` (there are no symbols, and no way to materialize quoted structure). Symbols
are the gateway to the next arc — the reader, `syntax-rules` macros, and ultimately
self-hosting (the compiler consumes symbolic Scheme code and compares symbols with `eq?`).
This change adds symbols as an interned data type and makes `quote` work for symbols and
lists.

## What Changes

- **Runtime** — a new `symbol` heap type (tag 6) with an **intern table** so equal names
  are pointer-identical; `eq?` on symbols therefore works, and `rt_write` prints the name.
- **Codegen** — `quote` of a symbol emits an interned-symbol reference; `quote` of a list
  or nested structure is **materialized at runtime** by emitting `rt_cons` / symbol-intern
  / immediate-encoding code (decision recorded in design). This adds a small ability to
  emit private string constants in the `.ll`.
- **Frontend** — `parse` already lowers `(quote d)` to `(const d)`; the emitter is
  extended to encode non-immediate constants (symbols, pairs, nested).
- `eq?` gains symbol identity for free (interning); `null?`/`pair?` already cover the list
  structure.

## Capabilities

### New Capabilities
<!-- None: extends the existing data types and quote handling. -->

### Modified Capabilities
- `core-language`: add symbols as a first-class data type (interned, `eq?`-comparable,
  printable) and support `quote` of symbols and of arbitrary list/atom structure.
- `aot-codegen`: the value-representation scenario is updated to include interned symbols
  (tag 6) and runtime-materialized quoted structure.

## Impact

- **Code:**
  - `src/runtime/runtime.c` — `TAG_SYMBOL` (6), intern table + `rt_intern`, `rt_write`
    symbol case; `eq?` unchanged (pointer identity now covers symbols).
  - `src/emit.ss` — encode non-immediate constants: emit a private string-constant global
    + `rt_intern` call for symbols; emit `rt_cons` chains to materialize quoted pairs;
    recurse for nesting.
  - `demos/` — quote a symbol, quote a list, `eq?` on symbols, print a quoted structure.
- **Verification:** `demos/run-backends.sh` (3-way) with the new quote/symbol demos.
- **Unaffected:** the calling convention, closures, existing passes (frontend already
  produces `(const d)` for quotes).
- **Enables (future):** the reader (needs symbols/strings to read into) and macros.

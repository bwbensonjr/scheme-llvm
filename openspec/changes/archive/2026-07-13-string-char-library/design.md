## Context

Strings are tag-7 extended heap objects `{HDR_STRING, byte-length, char *bytes}` holding
UTF-8; characters are `{HDR_CHAR, codepoint}` and are interned (so `eqv?` on characters holds
by identity). `string-char-operations` added `string-length`, `string-ref`, `substring`,
`char->integer`, `integer->char`, and `string->symbol`, and settled that string length and
indexing are **codepoint** based. It has a shared UTF-8 decode helper. Runtime primitives are
C functions wired through the fixed-arity `primcall` path (`*prims*` in `parse.ss` →
`prim-table` + `declare` in `emit.ss`), taking/returning tagged `i64`. This change adds the
comparison and construction library on top, splitting work between C primitives (byte-level)
and prelude Scheme (expressible over existing primitives).

## Goals / Non-Goals

**Goals:**
- Character comparison: `char=?`, `char<?`, `char>?`, `char<=?`, `char>=?`.
- String comparison: `string=?` (content equality).
- String construction: `string-append`, `symbol->string`, `list->string`, `make-string`.
- String → characters: `string->list`.

**Non-Goals:**
- String mutation (`string-set!`) and mutable-string semantics — the `string-mutation`
  change. `make-string` here yields an immutable filled string (D3).
- Ordering comparison of strings (`string<?`, `string-ci=?`, case folding) — add when needed.
- N-ary `string=?` / `string-append` — binary here (D2).
- Number/char conversions beyond the existing `char->integer` / `integer->char`.

## Decisions

### D1 — Split: byte-level ops are C primitives; the rest is prelude Scheme

Operations that must touch raw UTF-8 bytes are C primitives in `runtime.c`:

- `rt_string_eq(a, b)` — equal iff equal byte length and equal bytes (UTF-8 makes byte
  equality equivalent to codepoint equality).
- `rt_string_append(a, b)` — allocate a new string whose bytes are `a`'s followed by `b`'s.
- `rt_symbol_to_string(sym)` — a fresh string over the symbol's name bytes.
- `rt_list_to_string(lst)` — walk a list of characters, UTF-8-encode each codepoint, and
  build the string.
- `rt_make_string_fill(k, ch)` — a string of `k` copies of character `ch` (encode `ch`'s
  codepoint `k` times).

Operations expressible over existing primitives live in `prelude.scm`:

- Character comparisons reduce through `char->integer` and the existing n-ary numeric
  comparisons, so they are one-liners and n-ary for free:

  ```scheme
  (define (char=? . cs) (apply = (map char->integer cs)))
  (define (char<? . cs) (apply < (map char->integer cs)))
  ;; char>? char<=? char>=? likewise over > <= >=
  ```

- `string->list` loops with `string-ref` from the end, consing characters:

  ```scheme
  (define (string->list s)
    (let loop ([i (- (string-length s) 1)] [acc (quote ())])
      (if (< i 0) acc (loop (- i 1) (cons (string-ref s i) acc)))))
  ```

### D2 — `string=?` and `string-append` are binary (n-ary deferred)

Runtime primitives are fixed arity. `string=?` and `string-append` take exactly two
arguments in this change. N-ary variants are deferred: they can later be added either by
emit-time pairwise reduction (as n-ary arithmetic already is) or by prelude wrappers over the
binary primitives — neither is needed by current consumers, and deferring keeps this change
independent of `equality-and-list-library` (no reliance on `fold-left`). Character
comparisons are n-ary because they get it for free via `apply` over the existing n-ary
numeric comparisons.

### D3 — `make-string` yields an immutable filled string

`(make-string k ch)` returns an immutable string of `k` copies of `ch`. Strings in this
subset are immutable, so there is no separate "unfilled mutable buffer" concept yet. The
typical R7RS pattern of `make-string` + `string-set!` is out of scope here; the
`string-mutation` change decides whether `make-string` should instead produce a mutable
buffer (and how mutation interacts with variable-width UTF-8). Until then, `make-string`
requires the fill character (a 2-argument form); the optional-fill 1-argument form is
deferred to that change.

### D4 — Reuse existing UTF-8 helpers; no new emitter concepts

`rt_list_to_string` and `rt_make_string_fill` reuse the existing UTF-8 encode path (the
inverse of the decode helper used by `string-ref`). All primitives are fixed arity with
tagged-`i64` arguments/results, so the `primcall` path emits them unchanged; the only
frontend change is adding names to `*prims*` and `prim-table` + `declare`s. Fixnum arguments
(`k`) are `UNFIX`ed and character arguments carry their codepoint in the tag-7 object.

## Risks / Trade-offs

- **Binary `string=?`/`string-append`** — mild ergonomic limit; documented (D2) and cheap to
  lift later. Chosen for independence and simplicity.
- **`list->string` element domain** — assumes every list element is a character; a non-char
  element is undefined for this subset (matches the "out-of-range indices are undefined"
  stance of the prior change). A checked-error variant can come with the broader error story.
- **`make-string` immutability surprise** — R7RS users expect a mutable result; documented as
  a deliberate deferral (D3), revisited by `string-mutation`.
- **`char>?`/`char<=?`/`char>=?` availability** — relies on `>`, `<=`, `>=` existing as n-ary
  numeric comparisons (they do, from `n-ary-comparisons`).

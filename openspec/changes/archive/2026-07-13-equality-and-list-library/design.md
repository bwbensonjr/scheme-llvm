## Context

The prelude (`src/prelude.scm`) already carries a small list library — `list`, `length`,
`reverse`, `append`, `map`, `memq`, `assq` — written in pure Scheme over the core
primitives. `memq`/`assq` compare with `eq?`, and a comment there already notes that
"member/assoc arrive with equal?". Equality today is `eq?` / `eqv?` (primitives): identity
for heap objects, value for immediates, and identity for interned symbols and characters.
There is no structural comparison, so `(equal? '(1 2) '(1 2))` cannot be expressed. Runtime
primitives are C functions wired through the fixed-arity `primcall` path (`*prims*` in
`parse.ss` → `prim-table` + `declare` in `emit.ss`), taking and returning tagged `i64`.

## Goals / Non-Goals

**Goals:**
- `equal?`: structural equality over the current value set (fixnums, booleans, nil, symbols,
  characters, pairs, strings).
- The list procedures that stand on it: `member`, `assoc`.
- The two general list combinators the prelude lacks: `filter`, `fold-left`, `fold-right`.

**Non-Goals:**
- `equal?` over vectors — vectors do not exist yet (see the `vectors` change); `rt_equal`
  will be extended to recurse into them when they land.
- Comparison predicates on strings/chars as *separate* procedures (`string=?`, `char=?`) —
  those belong to the `string-char-library` change; `equal?` compares string content
  internally without exposing `string=?`.
- Numeric-tower equality (`=` already covers fixnums; no flonums/bignums exist).
- Cyclic-structure detection (no shared/circular data is constructible in the subset).

## Decisions

### D1 — `equal?` is a runtime primitive (`rt_equal`), not prelude Scheme

`equal?` is implemented in C and wired as a reserved primitive, rather than written in the
prelude. A prelude implementation would need a `string?` type predicate and a way to compare
string contents — neither exists yet (the string library is a separate, later change). A C
primitive is self-contained: it dispatches on the tag, recurses into pairs, compares string
bytes directly, and defers to `eqv?`-style identity/immediate equality for everything else.
This mirrors how `eq?` / `eqv?` are primitives and keeps this change independent of the
string-library change.

Semantics of `rt_equal(a, b)`:
- If `a` and `b` are `eqv?` (same immediate value, or same interned symbol/char, or the same
  heap object), return `#t`.
- Else if both are pairs, return `(and (equal? car…) (equal? cdr…))` (recurse).
- Else if both are strings, return `#t` iff they have identical codepoint content (compare
  the stored UTF-8 bytes; equal length + equal bytes suffices since both are UTF-8).
- Else return `#f`.

### D2 — `member` / `assoc` / `filter` / folds are prelude Scheme

These are ordinary list traversals expressible over the existing primitives plus `equal?`,
so they live in `prelude.scm`, mirroring `memq`/`assq`:

```scheme
(define (member x xs)
  (if (null? xs) #f (if (equal? x (car xs)) xs (member x (cdr xs)))))
(define (assoc k xs)
  (if (null? xs) #f (if (equal? k (car (car xs))) (car xs) (assoc k (cdr xs)))))
(define (filter p xs)
  (if (null? xs) (quote ())
      (if (p (car xs)) (cons (car xs) (filter p (cdr xs))) (filter p (cdr xs)))))
(define (fold-left f acc xs)
  (if (null? xs) acc (fold-left f (f acc (car xs)) (cdr xs))))
(define (fold-right f acc xs)
  (if (null? xs) acc (f (car xs) (fold-right f acc (cdr xs)))))
```

`fold-left` is written tail-recursively (accumulator threaded, `musttail` on the recursive
call); `fold-right` is naturally non-tail. Both take a single list argument in this change.

Note — primitives are not first-class in this compiler: reserved primitive names (`-`,
`cons`, `+`, …) are only valid in operator position, not as values passed to a higher-order
procedure. So higher-order use requires a lambda wrapper, e.g. `(fold-left (lambda (a b) (- a b)) 0 xs)`
rather than `(fold-left - 0 xs)`. This is a pre-existing property of the compiler, not
introduced here; it just surfaces the first time folds take a combining procedure. Lifting
it (eta-expanding primitives into callable closures) is out of scope for this change.

### D3 — Fold naming: `fold-left` / `fold-right` (R6RS)

The README says "fold" generically. We adopt the R6RS pair `fold-left` / `fold-right` rather
than the SRFI-1 `fold`, because (a) the host is Chez (R6RS), so behavior matches the
bootstrap environment, and (b) the two names make the argument order and association
direction explicit. `f` receives `(acc elem)` for `fold-left` and `(elem acc)` for
`fold-right`, per R6RS. Multi-list folds are out of scope (single list only for now).

### D4 — Frontend unchanged beyond the prim list

No new pass or IL node. `equal?` flows through the existing binary `primcall` path; adding
its name to `*prims*` and its `rt_equal` mapping + `declare` to `emit.ss` is the only
frontend change. The prelude procedures are plain top-level defines already handled by the
prelude mechanism.

## Risks / Trade-offs

- **String comparison in `rt_equal`** must compare full codepoint content, not pointer
  identity (distinct string literals with equal content are `equal?` but not `eq?`) —
  covered by a demo comparing two separately-constructed equal strings.
- **Recursion depth** — `rt_equal` recurses on the C stack over pair spines; extremely deep
  structure could overflow. Acceptable for the subset (no deep data is generated); a future
  iterative/explicit-stack version can replace it behind the same interface.
- **Forward compatibility with vectors** — noted in Non-Goals: when vectors land, `rt_equal`
  gains a vector arm; this change deliberately does not block on that.
- **`fold` naming churn** — if SRFI-1 `fold` is wanted later, it can be added as an alias;
  choosing R6RS names now avoids a semantics clash.

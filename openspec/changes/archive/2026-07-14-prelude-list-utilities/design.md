## Context

The prelude already carries the derived syntactic forms and a list/equality/string library
(`map`, `filter`, `fold-left`/`fold-right`, `append`, `reverse`, `length`, `member`/`assoc`,
the cxr combinators up to three deep, etc.). The sweep's free-variable analysis of the
assembled core turned up a small, closed set of additional procedures the passes assume but
that are not yet defined. All are pure Scheme over what the prelude/prims already provide.

## Goals / Non-Goals

**Goals:** define exactly the procedures the core needs, with standard semantics, in the
prelude; keep them general (usable by ordinary programs), not compiler-specific.

**Non-Goals:** a comprehensive R7RS list library — add only what the sweep proved is used.
Anything beyond this set waits for a demonstrated need.

## Decisions

### D1: Definitions (all pure Scheme)

- `andmap` — `#t` if every element satisfies the predicate (short-circuits on `#f`).
- `memp` — the first tail of the list whose head satisfies the predicate, else `#f`.
- `for-each` — apply a procedure to each element for effect, return unspecified.
- `cadddr` — `(car (cdddr x))`; extends the existing cxr set one deeper.
- `list?` — proper-list test (walk to `null`; guards against a dotted tail).
- `list-ref` / `list-tail` / `list-head` — indexed access, drop-n, take-n.
- `make-list` — a list of `n` copies of a fill value.
- `iota` — `(0 1 … n-1)` (the one-argument form the core uses).
- `max` — the larger of its arguments (the core uses the binary form).
- `zero?` — `(= x 0)`.
- `void` — returns the unspecified value (matching `(if #f #f)`).
- `string` — construct a string from its character arguments (e.g. via `make-string` +
  `string-set!`, or list→string of the args); the core uses the one-character case
  `(string ch)`.

### D2: Semantics match the host assumptions

Each procedure mirrors the Chez/R7RS behavior the core was written against, so the assembled
core computes identically whether hosted on Chez or self-compiled. Predicate-taking procedures
(`andmap`, `memp`) take the predicate as the first argument.

## Risks / Trade-offs

- **Subtle semantic mismatch** (e.g. `iota` arity, `max` arity, `list?` on improper lists) →
  pin down to the exact forms the core uses and the standard semantics; cover with tests.
- **Prelude growth / name clashes** → names are standard; user-wins shadowing keeps programs
  that redefine them working.
- **`string` constructor scope** → provide the general character-arguments form; the core only
  needs one character, but the general form is the conventional one and no costlier to define.

## Why

The gap sweep ([[self-host-gap-sweep]]) found gap **G10**: the compiler core calls a set of
standard-library procedures the prelude does not yet define, so their references are unbound
when the assembled core is compiled. All are ordinary Scheme expressible over existing
primitives — no language or runtime change needed, just prelude additions.

The missing procedures (from the sweep's free-variable analysis of the assembled core):
`andmap`, `memp`, `for-each`, `cadddr`, `list?`, `list-ref`, `list-tail`, `list-head`,
`make-list`, `iota`, `max`, `zero?`, `void`, and the character→string constructor `string`.

## What Changes

- Add the above procedures to `src/prelude.scm`, defined in pure Scheme over existing prims and
  prelude procedures:
  - list combinators: `andmap` (all elements satisfy a predicate), `memp` (first tail whose head
    satisfies a predicate), `for-each` (apply for effect).
  - list access/construction: `cadddr`, `list?`, `list-ref`, `list-tail`, `list-head`,
    `make-list`, `iota`.
  - numeric/misc: `max`, `zero?`, `void` (returns the unspecified value), and `string`
    (construct a string from character arguments).
- Behavior matches the usual R7RS/Chez semantics the core assumes.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `core-language`: extend the standard prelude with `andmap`, `memp`, `for-each`, `cadddr`,
  `list?`, `list-ref`, `list-tail`, `list-head`, `make-list`, `iota`, `max`, `zero?`, `void`,
  and `string`, completing the library surface the compiler core depends on.

## Impact

- **Code**: `src/prelude.scm` only.
- **Depends on**: existing prelude procedures (`fold`/`reverse`/`length`/cxr combinators) and
  prims (`make-string`/`string-set!` for `string`, arithmetic for `max`/`iota`). Unblocks
  [[self-hosting-bootstrap]] (the remaining unbound references in the assembled core).
- **Note**: user-wins prelude shadowing is preserved; a program defining any of these shadows
  the prelude version.

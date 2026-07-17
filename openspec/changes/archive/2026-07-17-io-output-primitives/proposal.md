## Why

Emit programs can compute output but cannot fully format it. `display` exists,
but there is no way to emit a trailing newline or to print a value in *write*
style (quoted strings, `#\`-prefixed characters) from user code — the only
write-style output is the runner auto-printing the program's single top-level
value. This is a real gap: the standard `ackermann.scm`/`fact.scm` idiom of
`(display (result))(newline)` fails today because `newline` is unbound, and the
P5 timing comparison against Chez had to route around it. The runtime printer
that would back these primitives (`rt_write`, sharing `print_val` with
`rt_display`) already exists and is exercised on every run; this change exposes
it to the language surface.

## What Changes

- Add `newline` — a nullary primitive that writes a single `\n` (U+000A) to
  standard output and returns the unspecified value.
- Add `write` — a unary primitive that writes any datum in R7RS *write* style
  (strings quoted, characters `#\`-prefixed, compounds recursing in write style)
  and returns the unspecified value. This is the write-style companion to the
  existing display-style `display`.
- Wire both through the existing tag-walking `print_val` printer in the runtime
  (no new printer logic): `write` reuses the `display=0` path already backing
  the runner's final-value print; `newline` is a thin `putchar('\n')`.
- Register both as reserved primitives (`*prims*` in `src/parse.ss`, prim→runtime
  mapping in `src/emit.ss`) and declare their runtime externs.
- Add demos (`demos/newline.scm`, `demos/write.scm`) and wire them into the
  `demos/run-tests.sh` value harness on both backends (`scheme-run` and `aot`).

Non-goals (deferred): ports / `current-output-port`, `write-string`,
`write-char`, and any input-side primitives. This change is output-only and
port-implicit (standard output), consistent with how `display` works today.

## Capabilities

### New Capabilities
<!-- None — this extends the existing core-language surface. -->

### Modified Capabilities
- `core-language`: add requirements for the `newline` and `write` output
  primitives, alongside the existing `display` requirement. `write` style itself
  is already specified (as the final-value print format); this exposes it as a
  callable primitive and adds `newline`.

## Impact

- **Code**: `src/parse.ss` (`*prims*` list), `src/emit.ss` (prim→runtime symbol
  table + LLVM extern declarations), `src/runtime/runtime.c` (a value-returning
  `write` entry and an `rt_newline`). Existing `print_val` is reused unchanged.
- **Backends**: both `scheme-run` (in-process JIT) and `aot` native exe must
  produce byte-identical output; the regen fixed point and byte-identical-backends
  invariants must still hold.
- **Tests/Demos**: new demos + harness entries.
- **Docs**: none required beyond spec deltas; `docs/OUTPUT.md` is about tool
  narration, not in-language I/O, so it is unaffected.
- **Compatibility**: additive. `newline` and `write` are currently unbound, so
  no existing program can be relying on other bindings for those names (they are
  becoming reserved primitives — a program that shadowed them with a user
  `define` would now conflict, but none exists in-tree).

## Context

Emit's output surface today is a single primitive, `display`, plus the runner
auto-printing a program's final top-level value in *write* style. The runtime
already contains the full tag-walking printer: `print_val(val v, int display)`
in `src/runtime/runtime.c` handles every value type in both styles, `rt_display`
calls it with `display=1`, and the runner's final-value print (`rt_write` +
`printf("\n")`, runtime.c:989/1010) calls it with `display=0`. So both new
primitives are *exposure* work, not new printing logic.

A primitive in Emit is threaded through three places:
1. `src/parse.ss` — the `*prims*` list makes the name a reserved primcall head.
2. `src/emit.ss` — a prim→runtime-symbol row (near the `(display "rt_display")`
   entry, ~line 170) plus a `declare i64 @<sym>(...)` extern (~line 640).
3. `src/runtime/runtime.c` — the `rt_*` C entry point.

Constraints from the project charter: both backends (`scheme-run` in-process JIT
and `aot` native exe) must emit byte-identical output, and the self-host regen
fixed point must still converge.

## Goals / Non-Goals

**Goals:**
- Add `newline` (nullary) and `write` (unary) as first-class primitives with the
  same reach as `display` (usable in `begin`, as a statement, etc.).
- Reuse `print_val` verbatim — `write` must produce bytes identical to the
  runner's final-value print for the same datum.
- Cover both backends in the demo-value harness.

**Non-Goals:**
- Ports, `current-output-port`, `write-string`, `write-char`, `write-char`,
  input primitives, or pretty-printing. Output-only, standard-output-implicit.
- Changing `display` or the final-value print behavior.
- First-class-value (eta-expanded) use of `newline`/`write` beyond what the
  existing prim-eta mechanism already grants; not required by the spec.

## Decisions

**D1 — `write` gets its own value-returning runtime entry, distinct from the
existing `void rt_write`.** The runner's internal `void rt_write(val)` returns
nothing; primitives must return a `val` (they yield the unspecified value). Add
`val rt_write_val(val v) { print_val(v, /*display=*/0); return NIL_V; }` and map
`(write "rt_write_val")`. *Alternative considered:* change `rt_write`'s signature
to return `val` and update the one internal caller. Rejected — keeping the
internal runner entry untouched minimizes blast radius on the final-value path,
which is on every program's hot exit. (Name to be finalized in tasks; the point
is a separate value-returning wrapper.)

**D2 — `newline` is nullary, modeled on `rt_read_all_stdin`.** Declare
`i64 @rt_newline()` (the existing nullary extern `rt_read_all_stdin()` is the
template) and implement `val rt_newline(void) { putchar('\n'); return NIL_V; }`.
The arity checker (`emit-arity-check`, emit.ss:662) already enforces
`argc == 0` for a fixed-arity-0 primitive, giving the spec's "calling with
arguments is an arity error" for free.

**D3 — Reuse `print_val`, add no new printing code.** Both primitives route to
the existing printer. This guarantees the spec's "write matches the final-value
print style" scenario by construction and keeps the two backends byte-identical
(they share the same runtime object).

**D4 — Verify on both backends via the existing harness.** Add
`demos/newline.scm` and `demos/write.scm` with expected values, and run under
both `RUNNER=scheme-run` (default) and `RUNNER=aot`. Multi-line/− exact-byte
expectations are compared by the harness's stdout match.

## Risks / Trade-offs

- **[Newline inside the harness's value comparison]** → the harness compares a
  demo's full stdout to an expected string; a demo that prints an interior
  `\n` must have its expected value written with that newline. Mitigation: keep
  demo output single-line where possible (e.g. `(begin (write X) (quote ok))`
  patterns), and for the `newline` demo assert the exact multi-line bytes.
- **[Reserved-word conflict]** → making `write`/`newline` primitives means a user
  `(define (write ...) ...)` would now collide with a primcall head. Mitigation:
  none needed in-tree (no such definitions exist); this matches how `display`
  and all other primitives already behave, and is called out in the proposal.
- **[Regen fixed point]** → new externs/prims change emitter output. Mitigation:
  run the full regen + byte-identical-backends check (as the P5 changes did);
  expect convergence since the change is additive and local.

## Open Questions

- Final runtime symbol name for the value-returning write wrapper
  (`rt_write_val` vs. `rt_write1`) — cosmetic, settled during implementation.
- Whether to also add `write` to `*prim-eta-arity*` so it can be passed as a
  first-class value (e.g. `(for-each write xs)`). Deferred unless a demo needs
  it; not required by the spec.

## 1. Runtime entry points

- [x] 1.1 Add `val rt_newline(void)` to `src/runtime/runtime.c` — write `'\n'` to
      standard output (`putchar('\n')`) and return `NIL_V`.
- [x] 1.2 Add a value-returning write wrapper to `src/runtime/runtime.c` (e.g.
      `val rt_write_val(val v)`) that calls `print_val(v, /*display=*/0)` and
      returns `NIL_V`. Leave the existing `void rt_write` (runner final-value
      path) untouched.

## 2. Compiler wiring

- [x] 2.1 In `src/parse.ss`, add `newline` and `write` to the `*prims*` list.
- [x] 2.2 In `src/emit.ss` prim→runtime table (near `(display "rt_display")`),
      add `(newline "rt_newline")` and `(write "rt_write_val")`.
- [x] 2.3 In `src/emit.ss` extern-declaration block (near
      `declare i64 @rt_display(i64)`), add `declare i64 @rt_newline()` and
      `declare i64 @rt_write_val(i64)`.

## 3. Demos and harness

- [x] 3.1 Add `demos/newline.scm` exercising `newline` between two `display`s
      (e.g. `(begin (display "a")(newline)(display "b")(quote ok))`), with a
      header comment per the demo convention.
- [x] 3.2 Add `demos/write.scm` exercising `write` on a string, a char, and a
      nested list so quoting/prefixing and recursion are all covered.
- [x] 3.3 Register both demos in `demos/run-tests.sh` with exact expected stdout
      (mind the interior newline in the `newline` demo's expected value).

## 4. Verification

- [x] 4.1 Build `scheme-run` and run `demos/run-tests.sh` (default backend) —
      all demos pass, including the two new ones.
- [x] 4.2 Run `RUNNER=aot demos/run-tests.sh` — same expected values pass on the
      native-exe backend; confirm output is byte-identical to `scheme-run`.
- [x] 4.3 Confirm the self-host regen fixed point still converges and backends
      stay byte-identical (the project's standard regen check).
- [x] 4.4 Verify `write`'s bytes match the runner's final-value print for the
      same datum (the spec's "write matches the final-value print style"
      scenario).

## 5. Spec sync

- [x] 5.1 After implementation and green tests, sync the delta in
      `specs/core-language/spec.md` into `openspec/specs/core-language/spec.md`
      (via the sync/archive workflow).

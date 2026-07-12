## 1. Char intern table in the runtime

- [x] 1.1 In `src/runtime/runtime.c`, add a Latin-1 fast-path cache `val latin1[256]` (allocated lazily, `GC_MALLOC_UNCOLLECTABLE`, scanned) for codepoints 0…255
- [x] 1.2 Add a growable, `GC_MALLOC_UNCOLLECTABLE`, scanned overflow table (count/cap) for codepoints ≥256, with linear scan by codepoint — mirroring `intern_table`
- [x] 1.3 Add `char_lookup(cp)` (returns the interned char or 0) and `char_intern_add(ch)` helpers over the two tiers

## 2. Route rt_make_char through interning

- [x] 2.1 Rewrite `rt_make_char` to return the interned char for `cp` if present, else allocate `{ HDR_CHAR, cp }`, intern it, and return it
- [x] 2.2 Confirm the three construction paths (literal `@rt_make_char`, `rt_integer_to_char`, `rt_string_ref`) all now yield canonical chars (they all call `rt_make_char`)
- [x] 2.3 Update the `rt_eqv_p` comment to note chars are now interned (the remaining seam is non-immediate numbers)

## 3. Demos and tests

- [x] 3.1 Add a demo asserting `(eqv? #\a #\a)`, `(eq? #\a #\a)`, identity across `integer->char`/`string-ref`/literal, `(eqv? #\a #\b)` = `#f`, and a char surviving GC (allocate churn, then re-check identity)
- [x] 3.2 Add it to `demos/run-tests.sh` with the expected value
- [x] 3.3 Add it to `demos/run-backends.sh` for the cross-backend regression check

## 4. Verify

- [x] 4.1 Build and run the demo; confirm equal chars are `eqv?`/`eq?` and distinct chars are not
- [x] 4.2 Run `demos/run-tests.sh` and `demos/run-backends.sh`: all demos agree across AOT/JIT/bitcode
- [x] 4.3 Confirm existing string/char/unicode demos (`strlit`, `charlit`, `strchar`, `unicode`, `strops`, `struni`) still pass unchanged — interning is transparent for immutable chars
- [x] 4.4 Confirm no changes outside `src/runtime/runtime.c` (plus demos)

## 5. Spec sync

- [x] 5.1 Sync the `core-language` delta into `openspec/specs/`: add the `Character interning` requirement and apply the `eqv? primitive` modification (drop the char caveat)

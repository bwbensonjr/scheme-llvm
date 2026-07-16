## 1. Runtime: grow the string header and constructor (src/runtime/runtime.c)

- [x] 1.1 Change the string layout comment and `rt_make_string` (`:228-236`) from the 3-word
      `{ HDR_STRING, byte_len, bytes }` to the 5-word
      `{ HDR_STRING, byte_len, cp_len, bytes, index }`; allocate 5 words; compute `cp_len`
      with one forward scan (reuse `utf8_seq_len`) and store it; initialize `index` to `NULL`.
- [x] 1.2 Update the field accessors: `str_len` reads `[1]`, add `str_cplen` reading `[2]`,
      `str_bytes` now reads `[3]`; confirm the exported wrappers `rt_string_len`/
      `rt_string_bytes` (`:245-246`) still return byte length / bytes correctly.
- [x] 1.3 Grep every string-object field access and every `GC_MALLOC(3 * sizeof(val))` /
      `as_ptr(v)[1|2]` string site (`string-append`, `list->string`, `make-string`,
      `symbol->string`, mutation, printers) and route them through the accessors / the new
      layout so no caller hardcodes the old offsets.

## 2. Runtime: ASCII fast path + breadcrumb index (src/runtime/runtime.c)

- [x] 2.1 Refactor `utf8_offset(s, blen, cp)` (`:296`) into
      `utf8_offset_from(s, blen, start_byte, start_cp, target_cp)` and reimplement the old
      signature as a wrapper starting at `(0, 0)`.
- [x] 2.2 Make `rt_string_length` (`:307`) O(1): return `FIX(str_cplen(s))`.
- [x] 2.3 Add the ASCII fast path to `rt_string_ref` (`:313`) and `rt_substring` (`:318`):
      when `str_len(s) == str_cplen(s)`, treat the codepoint index as the byte offset
      directly (no scan, no index).
- [x] 2.4 Define the breadcrumb index type and a fixed sampling stride `K` (D2; pick 16 or
      32); add `cpidx_build(s)` (one O(byte_len) scan sampling byte offset every `K`
      codepoints, `GC_MALLOC_ATOMIC`, stored into header word `[4]`) and `cpidx_offset(s, cp)`
      (start at `index[cp/K]`, scan forward via `utf8_offset_from`).
- [x] 2.5 In `rt_string_ref`/`rt_substring`, for multi-byte strings build the index lazily on
      first use (D3) and resolve offsets through `cpidx_offset`.

## 3. Runtime: mutation invalidation (src/runtime/runtime.c)

- [x] 3.1 In `string-set!` / every in-place mutation path, recompute (or repair) `cp_len` and
      reset `index` to `NULL` so a stale index is never consulted after a byte-width change
      (D4).

## 4. Verify behavior and performance end to end

- [x] 4.1 Run the demo/test suite (`./run-all-tests.sh` / `demos/run-tests.sh`); confirm all
      string, `string-length`/`string-ref`/`substring`, `string=?`, `string-append`,
      `list->string`/`string->list`, `make-string`, mutation, and non-ASCII round-trip cases
      pass.
- [x] 4.2 Verify the spec scenarios: `(string-length "abc")`→3, `(string-ref "abc" 1)`→`#\b`,
      `(substring "hello" 1 4)`→`"ell"`, `(string-length "héllo")`→5,
      `(string-ref "héllo" 1)`→`#\é`, full 0…n−1 indexed traversal of `"héllo 日本語"` yields
      the expected characters, and index-then-mutate-then-index returns correct codepoints.
- [x] 4.3 Run the AOT/JIT/bitcode 3-way equivalence harness and the REPL-vs-batch equivalence
      harness; confirm identical final values on every demo. (REPL-vs-batch, self-emission, and
      self-hosting fixed point all PASS. NOTE: the dev suite has 4 pre-existing failures —
      `strchlib`/`rdatoms` where a `#t` prints as `#\nul` (value 9) in the *Chez-from-source*
      path only — that are present at HEAD `85c6011` without this change (verified by stashing
      it) and are unrelated to string storage. Backend equivalence shows aot==jit==bitcode, i.e.
      no divergence introduced here. This is a latent `#t`/char corner from the immediate-
      characters change; flagged for a separate fix.)
- [x] 4.4 Spot-check the complexity guarantee: an indexed loop over a large multi-byte string
      is no longer quadratic (20k-codepoint indexed loop ~4× faster than baseline and widening;
      correct result), and ASCII `string-ref`/`string-length` do no scan (structural fast path).

## 5. Bootstrap and self-hosting guard

- [x] 5.1 Confirm the emitter emits an unchanged `rt_make_string(ptr, i64)` call and that the
      committed stage-0 IR (`bootstrap/*.ll`) is byte-identical (no regeneration expected,
      since only the runtime changed).
- [x] 5.2 Verify the self-hosting fixed point (byte-identical stage-1/stage-2 IR) still holds.

## 6. Docs and close-out

- [x] 6.1 Update any prose describing the string object as a 3-word `{ header, len, bytes }`
      layout (README value-representation section, `LLVM.md`, `docs/PIPELINE.md` if
      applicable) to the new 5-word layout with cp_len + lazy index.
- [x] 6.2 Tick **P4** ☐→☑ in `docs/PERFORMANCE.md` (heading and status table) and fill its
      "OpenSpec change" line with `codepoint-string-indexing`.

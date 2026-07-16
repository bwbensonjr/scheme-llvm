## 1. Runtime: the misc-immediate encoding (src/runtime/runtime.c)

- [x] 1.1 Define the misc-immediate layout on tag `001`: subtype field (bits 3–7) and
      payload (bits 8–63); add `SUB_BOOL`/`SUB_CHAR` constants and helper macros
      (`mk_char(cp)`, `char_cp(v)`, subtype extractor).
- [x] 1.2 Re-encode booleans: keep `FALSE_V == 1`; set `TRUE_V = (1<<8)|1` (257). Confirm
      `truthy`, `rt_not`, and every `FALSE_V`/`TRUE_V` use still hold.
- [x] 1.3 Reimplement `rt_char_to_integer` as `v >> 8` and `rt_integer_to_char` as
      `(cp<<8)|SUB_CHAR|001`; update `rt_make_char` to return the immediate (used by
      `string-ref`), keeping the name/signature so `emit.ss` and `runtime.c` callers work.
- [x] 1.4 Update `rt_char_p` to test the char subtype and `rt_boolean_p` to test the bool
      subtype (both now under tag `001`); ensure `char?` and `boolean?` are mutually
      exclusive.
- [x] 1.5 Delete the intern machinery: `char_latin1`, `char_astral`/count/cap,
      `char_lookup`, `char_intern_add`, and the `HDR_CHAR` extended layout + its comments.
- [x] 1.6 Audit every `tag_of(v) == TAG_BOOL` and `HDR_CHAR` site (`equal?`, the `display`
      printer, the `write` final-value printer, error-object formatting): make the character
      case sub-discriminate before the boolean case so chars never print/compare as booleans.
- [x] 1.7 Update the tag-scheme header comment block (`runtime.c:1-50`) to document the
      misc-immediate family and its reserved subtypes.

## 2. Emitter: immediate character + boolean literals (src/emit.ss)

- [x] 2.1 Update boolean literal emission: `#t` → the new `TRUE_V` numeric (257), `#f` → `1`
      (unchanged); update the `icmp ne i64 v, 1` boolean-branch check if affected (it is
      not — `#f` is unchanged, but confirm).
- [x] 2.2 Emit a character literal as the inline immediate constant `(codepoint<<8)|9`
      instead of a `call @rt_make_char`; keep `rt_make_char` declared only if still used by
      `string-ref` lowering (it is, via the runtime), otherwise drop the stray decl.
- [x] 2.3 Confirm `char?`/`boolean?`/`char->integer`/`integer->char` primitive mappings
      still resolve to the (reimplemented) runtime externs; no emitter change needed beyond
      literals unless a check is inlined.

## 3. Verify behavior end to end

- [x] 3.1 Run the existing demo/test suite (`./run-all-tests.sh` / `demos/run-tests.sh`) and
      confirm all character, boolean, string, and `eq?`/`eqv?`/`equal?` cases pass.
- [x] 3.2 Verify the specific preserved-behavior cases: `(eqv? #\a #\a)`,
      `(eq? #\A (integer->char 65))`, `(eq? (string-ref "A" 0) #\A)`, `(eqv? #\a #\b)`,
      named literals (`#\newline`, `#\space`, `#\tab`), the n-ary char comparisons, and
      `#\`/string round-tripping through `display` and `write`.
- [x] 3.3 Run the AOT/JIT/bitcode 3-way equivalence harness and the REPL-vs-batch
      equivalence harness; confirm identical final values on every demo.

## 4. Regenerate bootstrap IR and self-hosting fixed point

- [x] 4.1 Regenerate the committed stage-0 IR (`bootstrap/embed.ll`, `embed-repl.ll`,
      `schemec.ll`, and `scheme.base.ll`) from source with the updated emitter.
- [x] 4.2 Verify the self-hosting fixed point (byte-identical stage-1/stage-2 IR) still holds
      with the new character/boolean encoding.

## 5. Docs and close-out

- [x] 5.1 Update any prose describing characters as heap/extended-tag objects (README
      value-representation section, `LLVM.md`, `docs/PIPELINE.md` if applicable).
- [x] 5.2 Tick **P2** ☐→☑ in `docs/PERFORMANCE.md` (heading and status table) and fill its
      "OpenSpec change" line with `immediate-characters`.

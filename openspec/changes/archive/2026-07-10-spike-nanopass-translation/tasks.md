## 1. Setup

- [x] 1.1 Create the tracked `spike/nanopass/` directory (kept as a reference, not
      discarded)
- [x] 1.2 Confirm Chez + nanopass run locally (`chez`), able to load `define-language`
- [x] 1.3 Read the three target passes in reference source and note their real logic:
      `np-recognize-let`, `np-convert-assignments`, `np-convert-closures` in
      `/Users/bwb/src/github.com/cisco/ChezScheme/s/cpnanopass.ss`, with the matching
      language deltas (L1→L2, L3→L4, L5→L6) in `s/np-languages.ss`
- [x] 1.4 Load the Chez `match` macro (`match.ss`; not exported by base
      `(chezscheme)`) and define the shared hand-rolled convention: a `match`-based
      recursive descent plus a "recur over subforms" helper (design D2)
- [x] 1.5 Write the shared test inputs: at least one program exercising captured-
      mutable boxing and one exercising a non-trivial closure (design D3)

## 2. Nanopass side

- [x] 2.1 Define minimal `define-language` forms for the relevant ILs (L1/L2/L3/L4/L5/L6
      subset needed by the three passes)
- [x] 2.2 Translate/port `recognize-let` as a nanopass `define-pass`
- [x] 2.3 Translate/port `convert-assignments` as a nanopass `define-pass`
- [x] 2.4 Translate/port `convert-closures` as a nanopass `define-pass`
- [x] 2.5 Run the shared test inputs through the nanopass versions; record output IR

## 3. Hand-rolled side

- [x] 3.1 Represent the same ILs as plain s-expressions
- [x] 3.2 Write `recognize-let` in stylized hand-rolled Scheme
- [x] 3.3 Write `convert-assignments` in stylized hand-rolled Scheme
- [x] 3.4 Write `convert-closures` in stylized hand-rolled Scheme
- [x] 3.5 Run the same shared test inputs; confirm output IR matches the nanopass side

## 4. Compare and decide

- [x] 4.1 Score each pass both ways on the rubric (design D4): line count, boilerplate
      share, readability, safety lost — reporting one-time framework setup separately
      from per-pass logic
- [x] 4.2 Note the self-hosting tie-breaker input (parked but real)
- [x] 4.3 Write the verdict: nanopass vs. hand-rolled for this project's top-third
      pipeline, with the rationale

## 5. Capture output

- [x] 5.1 Write the new frontend/pass-ladder design doc (proposed `docs/PIPELINE.md`):
      the transferable spine, the LLVM-subsumes line, and the verdict
- [x] 5.2 Reconcile `LLVM.md`'s single nanopass framing sentence only if the verdict
      flips it
- [x] 5.3 Tidy `spike/nanopass/` and keep it as a reference implementation; link to it
      from `docs/PIPELINE.md`

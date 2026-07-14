## Why

A self-hosted core reads program source and produces IR. scheme-llvm already has an
in-language reader — `read-from-string` (`src/prelude.scm`) parses one datum from a string —
but the core needs to read a **whole program** (a sequence of top-level forms) from its input
(stdin text). This is roadmap step 5: extend the existing reader from "one datum" to "all
forms in the source," so the core can consume its input without Chez's `read`/ports.

## What Changes

- Add an in-language **`read-all-from-string`** (name TBD) that repeatedly applies the
  existing datum reader across a source string, returning the list of all top-level forms
  (skipping inter-form whitespace/comments, stopping at end of input).
- The driver ([[decompose-core-driver]]) supplies the source string (from stdin or a file);
  the core turns it into the form list it already compiles. No new host reader needed —
  `read-from-string`'s machinery is reused.

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `core-language`: Extend the in-language reader to read a sequence of all top-level data
  from a source string (a whole-program read), building on the existing single-datum reader.

## Impact

- **Code**: `src/prelude.scm` (the multi-form reader over the existing `rd-*` helpers). No
  runtime change (pure Scheme over string primitives).
- **Depends on**: [[decompose-core-driver]] (the driver feeds source text to the core) and,
  for reading numeric-heavy sources back, nothing new. Complements the existing reader
  (archived `2026-07-11-scheme-reader`, `2026-07-13-reader-lexical-extensions`).
- **Enables**: the core to obtain its forms in-language, a prerequisite for
  [[self-hosting-bootstrap]].

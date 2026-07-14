## Why

The compiler's passes are expressed with a vendored `match` macro (`src/match.sls`) that
is implemented with **`syntax-case`** (procedural macros: `with-syntax`,
`generate-temporaries`, `datum`, quasisyntax, nested ellipsis). The scheme-llvm language
only provides `syntax-rules`, so this `match` cannot be expanded by our own expander —
making it the single largest obstacle on the path to self-hosting. Investigation showed
that although `match.sls` *implements* catamorphism, the compiler **never uses** it: every
pattern in the passes is within the non-catamorphic subset (literal symbol, pair, single
ellipsis `(p ...)`, ellipsis-with-tail `(p ... plast)`, `,id` binder, `(guard …)`, `else`).
That subset is expressible with `syntax-rules`, so we can remove the `syntax-case`
dependency without losing anything the compiler relies on — and we defer `syntax-case`
itself until R7RS-large's pattern-matching direction (the SRFI-200/204/241 lineage) settles.

This change consumes the recorded decision from [[select-syntax-rules-matcher]] (which
matcher, its convention, and the exact expander work required); it does not re-derive the
selection.

- Implement in `src/passes/expand.ss` whatever `syntax-rules` construct the decision
  identified as required (candidate: the ellipsis escape `(... ...)`), with tests; skip if
  the decision recorded that none is needed.
- Replace `src/match.sls` with the chosen `syntax-rules` matcher, used by **both** the
  host (Chez) build and the (future) self-hosted build, so there is a single matcher and
  no host/target divergence.
- Rewrite the ~22 `match` forms across the passes (`parse.ss`, `emit.ss`,
  `passes/lower.ss`, `passes/convert-assignments.ss`, `passes/convert-closures.ss`,
  `passes/recognize-let.ss`) to the adopted matcher's syntax — applying the convention
  mapping from the decision — and test that the whole suite still passes (behavior-preserving
  refactor).

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `compiler-pipeline`: Add a requirement that the pass pattern-matcher depends only on
  `syntax-rules` (no `syntax-case`), recording this as a self-hosting enabler. The
  hand-rolled pass-framework decision itself is unchanged.
- `macro-system`: Add a requirement that `syntax-rules` is sufficient to host a runtime
  pattern matcher — including whatever construct the spike identifies as required (the
  candidate being the ellipsis-escape `(... ...)`).

## Impact

- **Code**: `src/match.sls` (replaced), `src/passes/expand.ss` (possibly extended), and all
  pass files that use `match` (pattern rewrites). No change to runtime, emit output, or
  observable compiler behavior — the full test suite is the regression oracle.
- **Dependency removed**: the `(chezscheme)` `syntax-case` surface (`datum`, `errorf`,
  `trace-define-syntax`) that `match.sls` imports; the new matcher is portable
  `syntax-rules`.
- **Self-hosting**: removes the `match`/`syntax-case` blocker; unblocks compiling the
  passes with scheme-llvm's own expander. `syntax-case` is explicitly deferred, not
  implemented.
- **Risk**: the literal↔binder convention differs between the nanopass `,x` style and
  Wright/SRFI style; a mis-migrated literal silently becomes a catch-all binder. Mitigated
  by convention choice and by testing each pass against the existing suite.

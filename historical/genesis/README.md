# Genesis: the lift-off-from-Chez tooling (frozen)

These files are **frozen provenance** from before the compiler's build pipeline
became Chez-free (change: `self-hosting-completion`). They are **not maintained**
and are allowed to drift from the live source. The live, single source of truth is
now the flat, concatenation-ready source in `src/` (see `src/match.scm`,
`src/util.scm`, `src/core.ss`, the `src/passes/`, and `src/entry-*.scm`).

## What's here

| File | Was | Superseded by |
|---|---|---|
| `match.sls` | `(library (match) ...)` — the pattern matcher as an R6RS library | `src/match.scm` (flat `define-syntax`, helpers renamed `%match-pat`/`%match-clauses`) |
| `util.ss` | `(library (util) ...)` — set ops + deterministic fresh names | `src/util.scm` (flat top-level `define`s) |
| `assemble-core.ss` | the Chez assembler: de-`library`'d `match`/`util`, dropped `core.ss`'s `include`s, renamed the `match-pat` collision, and appended a per-target entry to emit one flat program | ordered `cat` in the `Makefile` `regen` recipe (no Chez) |
| `assemble-sanity.ss` | a Chez check that the assembled `build/core-self.scm` behaved like the real core | subsumed by the fixed-point + behavioral suites |

## Why they were retired

The assembler was the last real Chez dependency in the edit→rebuild loop: a
text-munging script using Chez file I/O, and the project deliberately keeps
file/subprocess I/O out of the language, so the assembler could never run under
the self-hosted compiler. `self-hosting-completion` removed the *need* for a smart
assembler by baking its transformations into the source once (the `%match-pat`
rename, the de-`library`, the dropped `include`s, the reader unified on
`read-all-from-string`), so "assembly" collapsed to ordered concatenation.

## Running the genesis path

These scripts operated on the **library-structured** `src/` tree as it existed at
the freeze commit (the commit that introduced `historical/genesis/`). To re-run
them, check out that commit — the live `src/` has since been flattened and no
longer has the `(library ...)` wrappers, `(include ...)` block, or port-based
reader they expect.

The independent-host ("trusting trust") re-derivation of the fixed point is kept
alive as a live check by `test/self-host-fixpoint.sh` (run via `run-dev-tests.sh`),
which builds a Chez stage-1 compiler from the **current** flat source and confirms
the self-hosted compiler reaches the committed byte-identical fixed point.

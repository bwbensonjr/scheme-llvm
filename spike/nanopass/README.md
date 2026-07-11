# Spike: nanopass vs. hand-rolled `match`

A reference implementation comparing two ways to write the compiler's frontend passes,
kept (not thrown away) as worked evidence behind the decision in
[`docs/PIPELINE.md`](../../docs/PIPELINE.md). Full scoring and verdict:
[`RESULTS.md`](./RESULTS.md).

Three probe passes distilled from Chez's `s/cpnanopass.ss`, each written both ways and
checked for identical output:

| pass | transition | probes |
|------|------------|--------|
| `recognize-let`       | L1→L2 | boilerplate floor (trivial structural pass) |
| `convert-assignments` | L3→L4 | nanopass's sweet spot (remove `set!` via boxing) |
| `convert-closures`    | L5→L6 | a structural language-shape change + free-var analysis |

## Layout

```
languages.ss    nanopass define-language ILs (L1..L6) + parsers   [nanopass side]
np-passes.ss    the three passes, nanopass                        [nanopass side]
hand-passes.ss  the three passes, plain s-exprs + match           [hand-rolled side]
util.ss         generic set ops, shared by both sides
tests.ss        shared test inputs (same datum feeds both sides)
run.ss          driver: runs both sides, compares output, reports
vendor/nanopass Andy Keep's nanopass framework (git submodule upstream)
vendor/match.sls Andy Keep's match macro, from akeep/scheme-to-llvm
```

## Run

```sh
chez --libdirs ".:vendor:vendor/nanopass" --script run.ss
# => 12/12 agree; 0 mismatch(es)
```

## Dependencies

Vendored under `vendor/` (fetched during the spike; not committed as submodules here):

- nanopass framework — `github.com/nanopass/nanopass-framework-scheme`
- `match.sls` — from `github.com/akeep/scheme-to-llvm` (the Chez→LLVM precedent cited in
  `LLVM.md`), by Andy Keep.

Requires Chez Scheme (developed against 10.4.1).

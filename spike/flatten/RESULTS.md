# Flatten spike results (change: self-hosting-completion, task 1)

**Verdict: GO.** Flattening the compiler source into concatenation-ready flat files
preserves the self-hosting fixed point *and* is byte-identical to the Chez
assembler's output. The mechanical rewrite (L1/L2) is safe.

## What was tested

Flat, `cat`-assembled source (no Chez assembler):

```
match.scm util.scm          <- de-library'd, helpers renamed %match-pat/%match-clauses
src/parse.ss ... src/emit.ss <- pass files, verbatim
core-flat.scm                <- core.ss with (include ...) dropped, reader unified on
                                read-all-from-string
entry-{schemec,embed,repl}   <- small per-target entries; embed/repl bake *prelude-source*
                                via a Chez-free shell escaper (\ -> \\, " -> \", newlines literal)
```

## Findings

| Check | Result |
|---|---|
| `schemec` self-hosting fixed point (stage-2 == stage-3) over flat T | **PASS**, 2,059,702 bytes |
| flat `schemec` IR vs Chez-assembler `schemec` IR (same host) | **byte-identical** |
| flat `embed` IR vs Chez-assembler `embed` IR (same host) | **byte-identical** (2,084,269 B) |
| flat `embed-repl` IR vs Chez-assembler `embed-repl` IR (same host) | **byte-identical** (2,177,429 B) |

Byte counts match the currently-committed `bootstrap/embed.ll` / `embed-repl.ll`,
so the flat source is a drop-in for the assembler with no observable change.

## Why byte-identity holds

Emission is order-sensitive (deterministic gensym counter + constant-pool intern
order), but the flat concatenation presents the *same top-level forms in the same
order with the same names* as the assembler did. Source whitespace/formatting does
not reach emission (the compiler reads forms, not text layout). The `*prelude-source*`
constant's *value* is the prelude file bytes whether produced by Chez `write` or the
shell escaper, and the self-hosted reader (`rd-string`) decodes `\\`/`\"`/literal
newlines back to those exact bytes.

Reproduce: `spike/flatten/run.sh` (the fixed-point triple over the flat source).

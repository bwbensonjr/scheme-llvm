## Context

The prelude's in-language reader turns source text into data for the self-hosted `schemec`
(the Chez-hosted compiler reads files with Chez `read` instead). Its single-datum dispatcher:

```scheme
(define (rd-datum s n i)
  (let ([k (char->integer (string-ref s i))])
    (cond
      [(= k 40) (rd-list s n (+ i 1) (quote ()))]   ; (
      [(= k 39) (rd-quote s n (+ i 1))]             ; '
      [(= k 96) (rd-quasi s n (+ i 1))]             ; `
      [(= k 44) (rd-unquote s n (+ i 1))]           ; ,
      [(= k 34) (rd-string s n (+ i 1))]            ; "
      [(= k 35) (rd-hash s n (+ i 1))]              ; #
      [else (rd-atom s n i)])))
```

There is no `[` (91) case, and `rd-list` closes only on `)` (41):

```scheme
(define (rd-delim? c)  ; ends a token
  (let ([k (char->integer c)])
    (or (rd-ws? c) (or (= k 40) (or (= k 41) (or (= k 34) (= k 59)))))))
```

## The bug

`(let ([x 5]) x)` fed to `schemec`: `rd-list` reads `let`, then the next datum starts at `[`.
`rd-datum` has no `[` case → `rd-atom`, which scans to the next delimiter; `[` and `]` are not
delimiters, so it mis-tokenizes (`[x`, then `5]`). The list `([x 5] …)` is never built; the
malformed structure crashes the compiler downstream (segfault). Confirmed: `(let ([x 5]) x)`
segfaults; `(let ((x 5)) x)` compiles. The assembled core has ~529 brackets (Chez
`pretty-print` output), so this blocks the stage-1 build / triple test.

## Goals / Non-Goals

**Goals:** accept `[...]` as list syntax equivalent to `(...)` in the in-language reader, so the
self-hosted `schemec` reads the bracket-bearing core; keep all existing reader behavior.

**Non-Goals:** strict bracket/paren matching (a `[` must be closed by `]`); nested-delimiter
error reporting; `{}` braces. The compiler's input is well-formed, so lenient interchangeable
matching is sufficient (and is what R6RS implementations like Chez do in practice).

## Decisions

### D1: Interchangeable brackets and parens (lenient)

Treat `[` as an alias for `(` and `]` as an alias for `)`, both accepted by `rd-list` as
openers/closers. This is the minimal change and matches well-formed input; strict matching adds
a delimiter stack for no benefit here. Three edits:

1. `rd-datum`: add `[(= k 91) (rd-list s n (+ i 1) (quote ()))]`.
2. `rd-list`: where it tests for the closer `)` (41), also accept `]` (93).
3. `rd-delim?`: add `[` (91) and `]` (93) so atoms adjacent to a bracket terminate.

`rd-hash`'s `#(` vector path already calls `rd-list`, so `#[...]` would also be accepted;
harmless (the core uses `#(`).

## Risks / Trade-offs

- **Lenient matching accepts `(x ]`** → out of scope by the non-goals; input is well-formed. If
  strictness is wanted later, it is a separate change.
- **`rd-delim?` now splits tokens at `[`/`]`** → correct for Scheme (a bracket cannot appear in
  a bare symbol); guarded by the reader unit tests plus a new bracket case.

## Verification

1. `(read-from-string "(let ([x 5]) x)")` (or a `read-all-from-string` unit) returns the same
   structure as the paren form.
2. A demo using `[...]` (`(let ([x 5]) (+ x 1))` and a bracketed `letrec`) compiles and returns
   the right value across all three backends.
3. `build/schemec` compiles a bracketed program (e.g. `demos/fact.scm`) without segfaulting.
4. `./run-all-tests.sh` — all suites pass.
5. Hand back to [[self-hosting-bootstrap]] 2.1.

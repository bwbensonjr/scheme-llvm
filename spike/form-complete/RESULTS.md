# Spike: `form-complete?` input probe (change: repl-embedded-incremental)

Tasks 1.1 / 1.2, design **D4** ("reading exactly one form" — the genuine fork).

## Question

The interactive host must hand `compile-one-form` exactly one complete form's
text per iteration. Design D4 offered two options:

- **(a)** a host-side (C++) balanced reader, or
- **(b)** an in-language `form-complete?(buffer)` probe reusing the real reader.

Is (b) feasible, and does it stay inside the compiled subset?

## What the spike did

`spike/form-complete/probe.ss` implements `form-complete?` and exercises 37
cases: complete atoms/lists/strings/chars/quotes/vectors/dotted pairs, brackets,
comments, leading whitespace, and the incomplete/malformed cases. Run it with:

```
chez --script spike/form-complete/probe.ss   # 37 passed, 0 failed
```

## Findings

1. **The shipped reader cannot answer the question directly.** `rd-datum` /
   `rd-list` (`src/prelude.scm`) treat end-of-input as end-of-list: `(+ 1` reads
   as `(+ 1)` with no signal. There is no "incomplete" result to observe. So
   reusing `rd-datum` *as-is* (the literal wording of D4(b)) does **not** work.

2. **A separate EOF-aware *scanner* does.** `form-complete?` mirrors the reader's
   structure (list / string / `#\` char / `#(` vector / quote / unquote / atom)
   but, instead of building a datum, returns the index just past the first
   complete datum, or a sentinel: `incomplete` (unbalanced, unterminated string,
   trailing escape, lone `#`/`'`/`#\`, or only whitespace/comments) or
   `malformed` (a close paren/bracket with nothing open). Return shape:
   `(complete . consumed) | 'incomplete | 'malformed`.

3. **No lexer drift.** The scanner *reuses the reader's own lexeme helpers
   verbatim* — `rd-ws?`, `rd-delim?`, `rd-skip-ws`, `rd-skip-line`,
   `rd-token-end` — so the two cannot disagree on what a delimiter, a comment, or
   whitespace is. It also inherits the reader's (loose) bracket handling: `)` and
   `]` are interchangeable closers, so `(a ]` closes just as the reader does.
   Faithful-to-the-reader was chosen over stricter bracket matching, because
   dev→ship fidelity requires the probe and the reader agree.

4. **Subset-clean.** The scanner uses only `char->integer`, `string-ref`,
   `string-length`, `+`/`-`/`<`/`=`, `cons`, and the copied helpers — all in the
   scheme-llvm compiled subset. It ports verbatim into the core for task 3.1.

## Decision

**Adopt D4 option (b): the in-language `form-complete?` probe** — implemented as
the EOF-aware scanner above, not as a call into `rd-datum`. Option (a)
(host-side C++ balanced reader) is **not** taken: a second lexer in C++ would
have to re-encode strings/comments/char-literal rules and could drift from the
reader. The host stays dumb (append bytes, call the probe, retry on
`incomplete`); all lexical correctness lives in the one reader we already trust.

The probe was **not** awkward, so the task 1.2 fallback (host-side balanced
reader) is not needed. The scanner code here is the reference for the compiled
`form-complete?` entry (task 3.1).

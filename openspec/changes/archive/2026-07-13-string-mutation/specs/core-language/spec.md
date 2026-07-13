## ADDED Requirements

### Requirement: In-place string mutation

The compiler SHALL provide `string-set!` and `string-copy`. `(string-set! s i ch)` SHALL
replace the character at codepoint index `i` of string `s` with character `ch`, in place, for
any character — including one whose UTF-8 encoding differs in byte length from the character it
replaces — and SHALL preserve the identity of the string object so that all aliases observe the
change. `(string-copy s)` SHALL return a fresh string with the same content that can be mutated
independently of `s`. Out-of-range indices are undefined for this subset, and mutating a string
literal is undefined (use `string-copy` or `make-string` for a mutable target).

#### Scenario: Set a character in place

- **WHEN** a program evaluates `(let ((s (make-string 3 #\a))) (string-set! s 1 #\b) s)`
- **THEN** the result is the string `"aba"`

#### Scenario: Replacement changes byte length (ASCII to multibyte)

- **WHEN** a program evaluates
  `(let ((s (make-string 2 #\a))) (string-set! s 0 #\é) (list (string-length s) (string-ref s 0)))`
- **THEN** the result is `(2 #\é)` (length stays 2 codepoints; index 0 is the multibyte character)

#### Scenario: Mutation is visible through an alias

- **WHEN** a program evaluates
  `(let* ((s (make-string 1 #\x)) (t s)) (string-set! s 0 #\y) (string-ref t 0))`
- **THEN** the result is `#\y` (the alias `t` sees the mutation)

#### Scenario: string-copy is independent

- **WHEN** a program evaluates
  `(let* ((s (make-string 1 #\x)) (c (string-copy s))) (string-set! c 0 #\z) (string-ref s 0))`
- **THEN** the result is `#\x` (mutating the copy leaves the original unchanged)

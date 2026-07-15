## MODIFIED Requirements

### Requirement: Emitter is expressible in the self-hostable subset

The emitter's LLVM C-string escaping SHALL be expressed using only operations in the language
Emit accepts (string/char access, integer arithmetic), without `string->utf8`,
bytevector operations, a radix argument to `number->string`, or `string-upcase`. The escaped
`c"…"` literal and its byte count (printable ASCII except `"` and `\` verbatim; every other
UTF-8 byte as an uppercase `\XX`; trailing NUL counted) SHALL be identical to the prior
output for all inputs.

#### Scenario: Escaping output is unchanged

- **WHEN** the emitter escapes any symbol or string name (ASCII, control characters, and
  multi-byte UTF-8 scalars) into an LLVM `c"…"` literal
- **THEN** the emitted literal and byte count are byte-for-byte identical to the previous
  implementation

#### Scenario: Emitter compiles in the subset

- **WHEN** the emitter source is compiled by Emit
- **THEN** it uses no operation outside the accepted subset (self-hosting gap G2 is closed)

### Requirement: Primitives usable as first-class values

The language SHALL allow a primitive to be used as a first-class value — at minimum `car`,
`cons`, and `string-append` — so it can be passed to a higher-order procedure such as `map`,
`apply`, or a fold. A primitive name appearing in value (non-operator) position SHALL evaluate to
a procedure with the primitive's behavior, while a call in operator position SHALL continue to
compile directly to the primitive. `string-append` SHALL accept any number of arguments, whether
called directly (`(string-append a b c …)`) or via `apply`, with zero arguments yielding the
empty string. This SHALL be achieved without any construct in the standard prelude that behaves
differently under the bootstrap host than under Emit, so the prelude continues to load and
run directly under the bootstrap host.

#### Scenario: Primitive passed to a higher-order procedure

- **WHEN** a program evaluates `(map car (list (cons 1 2) (cons 3 4)))`
- **THEN** it yields `(1 3)` — `car` resolves as a value — and a direct `(car (cons 1 2))` still
  compiles to the primitive

#### Scenario: string-append for any arity, direct or applied

- **WHEN** a program evaluates `(string-append "a" "b" "c")`, `(apply string-append (list "a" "b"
  "c"))`, and `(string-append)`
- **THEN** the results are `"abc"`, `"abc"`, and `""` respectively

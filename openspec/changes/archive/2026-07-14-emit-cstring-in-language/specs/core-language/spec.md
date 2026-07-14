## ADDED Requirements

### Requirement: Emitter is expressible in the self-hostable subset

The emitter's LLVM C-string escaping SHALL be expressed using only operations in the language
scheme-llvm accepts (string/char access, integer arithmetic), without `string->utf8`,
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

- **WHEN** the emitter source is compiled by scheme-llvm
- **THEN** it uses no operation outside the accepted subset (self-hosting gap G2 is closed)

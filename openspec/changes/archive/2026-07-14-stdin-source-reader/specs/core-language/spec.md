## ADDED Requirements

### Requirement: Read all top-level forms from source text

The standard prelude SHALL provide an in-language reader that, given a source string, returns
the list of all top-level data it contains, in order — skipping inter-form whitespace and
`;` line comments and stopping at end of input — built on the existing single-datum reader.

#### Scenario: Reads a sequence of forms

- **WHEN** the reader is applied to `"(define x 1) (define y 2) (+ x y)"`
- **THEN** it returns `((define x 1) (define y 2) (+ x y))`

#### Scenario: Skips comments and whitespace between and after forms

- **WHEN** the reader is applied to source with `;` comments and blank lines between forms
  and a trailing comment
- **THEN** the returned list contains exactly the forms, with comments and whitespace ignored

#### Scenario: Empty source yields no forms

- **WHEN** the reader is applied to `""` or a string of only whitespace/comments
- **THEN** it returns the empty list

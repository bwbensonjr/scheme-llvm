## ADDED Requirements

### Requirement: Character comparison procedures

The compiler SHALL provide the character comparison procedures `char=?`, `char<?`, `char>?`,
`char<=?`, and `char>=?`. Each SHALL accept two or more characters and SHALL return `#t` iff
the characters, ordered by Unicode codepoint, satisfy the relation pairwise across the whole
argument list (chained comparison), otherwise `#f`.

#### Scenario: Chained character ordering

- **WHEN** a program evaluates `(char<? #\a #\b #\c)` and `(char<? #\a #\c #\b)`
- **THEN** the results are `#t` and `#f`

#### Scenario: Character equality

- **WHEN** a program evaluates `(char=? #\x #\x)` and `(char=? #\x #\y)`
- **THEN** the results are `#t` and `#f`

### Requirement: String content equality

The compiler SHALL provide `string=?`, which compares two strings and returns `#t` iff they
have identical codepoint content, otherwise `#f`. Comparison is by content, not object
identity.

#### Scenario: Equal content, distinct objects

- **WHEN** a program evaluates `(string=? (substring "xhello" 1 6) "hello")`
- **THEN** the result is `#t`

#### Scenario: Unequal content

- **WHEN** a program evaluates `(string=? "abc" "abd")`
- **THEN** the result is `#f`

### Requirement: String construction procedures

The compiler SHALL provide `string-append`, `symbol->string`, `list->string`, and
`make-string`. `string-append` SHALL return a new string that is the concatenation of its two
string arguments. `symbol->string` SHALL return a fresh string of the symbol's name.
`list->string` SHALL return a string built from a list of characters, in order.
`(make-string k ch)` SHALL return a string of `k` copies of the character `ch`. The results
are immutable strings; codepoint content round-trips through UTF-8, including non-ASCII.

#### Scenario: Append and symbol->string

- **WHEN** a program evaluates `(string-append "foo" (symbol->string (quote bar)))`
- **THEN** the result is the string `"foobar"`

#### Scenario: make-string

- **WHEN** a program evaluates `(make-string 3 #\x)`
- **THEN** the result is the string `"xxx"`

#### Scenario: string->list / list->string round-trip

- **WHEN** a program evaluates `(list->string (string->list "héllo"))`
- **THEN** the result is the string `"héllo"` (codepoint content preserved)

### Requirement: String to character list

The compiler SHALL provide `string->list`, which returns a list of the characters of a
string, in codepoint order.

#### Scenario: Decompose a string

- **WHEN** a program evaluates `(string->list "ab")`
- **THEN** the result is the list `(#\a #\b)`

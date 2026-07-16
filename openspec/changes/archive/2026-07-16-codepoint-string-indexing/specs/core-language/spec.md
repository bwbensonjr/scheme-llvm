## MODIFIED Requirements

### Requirement: String and character operations

The compiler SHALL provide operations over the string and character data types:
`char->integer` and `integer->char` (between a character and its Unicode codepoint),
`string-length`, `string-ref`, `substring`, and `string->symbol`. String length and
indexing SHALL be measured in **Unicode codepoints** (not bytes), so `string-ref` returns
the requested character and `string-length` equals the character count. `string->symbol`
SHALL return the interned symbol of the string's text, so it is `eq?` to a symbol literal
of the same name.

These operations SHALL meet the following complexity guarantees, without changing any
observable result:

- `string-length` SHALL be O(1) for every string (the codepoint count is stored, not
  recomputed on each call).
- `string-ref` and `substring` SHALL be O(1) for strings whose codepoint count equals their
  UTF-8 byte length (i.e. all-ASCII strings), since codepoint index equals byte offset.
- For strings containing multi-byte codepoints, a full left-to-right indexed traversal
  (`string-ref` at each index 0…n−1) SHALL be O(n) amortized rather than O(n²): the
  implementation MAY build, at most once per string and only on first random access, an
  auxiliary codepoint→byte index so that each subsequent access is sublinear. Sequential
  forward iteration remains O(1) per step.

The auxiliary index (if built) SHALL be internal and unobservable — it changes performance
only, never the value returned by any operation, `eq?`/`equal?` identity, or printed form.

#### Scenario: Character and codepoint conversion

- **WHEN** a program evaluates `(char->integer #\A)` and `(integer->char 97)`
- **THEN** the results are the fixnum `65` and the character `#\a`

#### Scenario: String length and reference

- **WHEN** a program evaluates `(string-length "abc")` and `(string-ref "abc" 1)`
- **THEN** the results are `3` and the character `#\b`

#### Scenario: Substring

- **WHEN** a program evaluates `(substring "hello" 1 4)`
- **THEN** the result is the string `"ell"`

#### Scenario: Codepoint indexing over non-ASCII text

- **WHEN** a program evaluates `(string-length "héllo")` and `(string-ref "héllo" 1)`
- **THEN** the results are `5` and the character `#\é` (indexing counts codepoints, not
  UTF-8 bytes)

#### Scenario: Indexed access is stable across the whole string

- **WHEN** a program indexes every position of a multi-byte string in turn — e.g. it
  collects `(string-ref "héllo 日本語" i)` for `i` from `0` to `(- (string-length "héllo 日本語") 1)`
- **THEN** it obtains exactly the characters `#\h #\é #\l #\l #\o #\space #\日 #\本 #\語`
  in order, with each `string-ref` returning the codepoint at that index regardless of the
  access order or of any internally cached index

#### Scenario: string->symbol interns

- **WHEN** a program evaluates `(eq? (string->symbol "foo") (quote foo))`
- **THEN** the result is `#t`

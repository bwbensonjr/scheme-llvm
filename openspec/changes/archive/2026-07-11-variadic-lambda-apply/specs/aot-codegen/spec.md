## MODIFIED Requirements

### Requirement: Emit the argc + overflow calling convention

Every emitted Scheme function SHALL use the single uniform prototype
`tailcc i64 (i64 self, i64 argc, i64 a0 … i64 a{K-1}, ptr overflow)` (`K` = whole-program
max fixed arity), and every emitted call SHALL pass `argc` = the number of actual
arguments and the positional arguments padded to `K`. When a call supplies more than `K`
arguments (variadic calls and `apply`), the excess arguments SHALL be passed through the
`overflow` vector; fixed-arity calls with no excess SHALL pass `ptr null`. Variadic
callees SHALL consume `argc` and `overflow` to build their rest list, and fixed-arity
callees SHALL check `argc`. The convention SHALL preserve guaranteed tail calls
(`musttail`), and the fixed-arity hot path SHALL remain allocation-free.

#### Scenario: Widened prototype and call shape

- **WHEN** a program is compiled to LLVM IR
- **THEN** each Scheme function is defined with the `(self, argc, a0 … a{K-1}, overflow)`
  prototype, and each call site passes the actual-argument count as `argc`, the padded
  positional arguments, and either `ptr null` (no excess) or an `overflow` vector (excess
  args)

#### Scenario: Overflow carries excess arguments

- **WHEN** a variadic procedure or `apply` is called with more than `K` arguments
- **THEN** the first `K` arguments occupy the positional slots and the remainder are passed
  through the `overflow` vector, and the callee reconstructs the full argument sequence

#### Scenario: Tail calls remain guaranteed

- **WHEN** a tail-recursive loop (e.g. the 10M-iteration `countdown` / named-`let` loop)
  is compiled under the convention
- **THEN** the tail call is emitted as `musttail`, the program runs in bounded stack, and
  the loop allocates nothing on its hot path

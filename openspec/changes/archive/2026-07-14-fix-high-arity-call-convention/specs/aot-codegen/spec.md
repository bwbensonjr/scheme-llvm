## MODIFIED Requirements

### Requirement: Emit the argc + overflow calling convention

Every emitted Scheme function SHALL use the single uniform prototype
`fastcc i64 (i64 self, i64 argc, i64 a0 … i64 a{K-1}, ptr overflow)` (`K` = whole-program
max fixed arity), and every emitted call SHALL pass `argc` = the number of actual
arguments and the positional arguments padded to `K`. When a call supplies more than `K`
arguments (variadic calls and `apply`), the excess arguments SHALL be passed through the
`overflow` vector; fixed-arity calls with no excess SHALL pass `ptr null`. Variadic
callees SHALL consume `argc` and `overflow` to build their rest list, and fixed-arity
callees SHALL check `argc`. The convention SHALL preserve guaranteed tail calls
(`musttail`), and the fixed-arity hot path SHALL remain allocation-free.

Argument passing SHALL be correct at **every** arity `K`, including `K` large enough that a
call's argument count (`K + 3`) exceeds the target's register-argument budget and arguments
are passed on the stack. In particular, a non-tail call SHALL preserve the caller's live
arguments across the call regardless of `K`. (The convention uses `fastcc` rather than
`tailcc` precisely because a non-tail `call tailcc` with a stack-passed argument does not
preserve the caller's live arguments on arm64; `fastcc` does, and — because every emitted
tail call is `musttail`, which `fastcc` guarantees — guaranteed tail calls are unaffected.)

#### Scenario: Widened prototype and call shape

- **WHEN** a program is compiled to LLVM IR
- **THEN** each Scheme function is defined with the `fastcc (self, argc, a0 … a{K-1},
  overflow)` prototype, and each call site passes the actual-argument count as `argc`, the
  padded positional arguments, and either `ptr null` (no excess) or an `overflow` vector
  (excess args)

#### Scenario: Overflow carries excess arguments

- **WHEN** a variadic procedure or `apply` is called with more than `K` arguments
- **THEN** the first `K` arguments occupy the positional slots and the remainder are passed
  through the `overflow` vector, and the callee reconstructs the full argument sequence

#### Scenario: Tail calls remain guaranteed

- **WHEN** a tail-recursive loop (e.g. the 10M-iteration `countdown` / named-`let` loop)
  is compiled under the convention
- **THEN** the tail call is emitted as `musttail`, the program runs in bounded stack, and
  the loop allocates nothing on its hot path

#### Scenario: High arity preserves caller arguments across non-tail calls

- **WHEN** a program whose whole-program max fixed arity is `K ≥ 6` (so a call passes at least
  9 arguments and at least one is stack-passed) compiles a function that makes a non-tail
  closure call and then uses one of its own arguments after the call returns
- **THEN** the caller's argument is preserved and the function computes the correct result
  (e.g. `(define (big a1 a2 a3 a4 a5 a6) (+ a1 a2)) (define (helper x) (+ x 100))
  (define (f a b) (+ (helper a) b)) (f 10 20)` evaluates to `130`), with no corruption,
  hang, or crash

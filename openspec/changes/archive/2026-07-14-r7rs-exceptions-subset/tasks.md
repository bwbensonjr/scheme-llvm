## 1. Runtime: error objects

- [x] 1.1 Add an `HDR_ERROR` extended type to `src/runtime/runtime.c` holding
  `{ message-string, irritant-list }`, with a constructor.
- [x] 1.2 Add `rt_error_object_p`, `rt_error_object_message`, `rt_error_object_irritants`.
- [x] 1.3 Reshape `rt_error` to build an error object and raise it (via the escape stack,
  task 2), preserving the current message+irritants rendering on abort.
- [x] 1.4 Teach `rt_write` how to render an error object (open question in design; at minimum
  do not crash if one is printed).

## 2. Runtime: one-shot escape stack

- [x] 2.1 Spike the escape-primitive boundary (design D2): confirm a C runtime function can
  `setjmp`, call a Scheme thunk closure (via an emitter-synthesized ccc trampoline passed by
  pointer), and return a tagged `(ok . v)` / `(raised . obj)` pair. **Done** —
  `spike/guard/` passes (normal / catch / nested) at `-O2`; `guard` must be an
  emitter special form (D2a).
- [x] 2.2 Generalize `rt_trap` (single `jmp_buf*`) into a stack of escape frames
  `{ jmp_buf; val raised; }`, with push/pop and "raise into the top frame, else fall back to
  the outermost trap" semantics.
- [x] 2.3 Implement the guard primitive(s) chosen in 2.1 (`%call-guarded`, or the
  enter/raised?/object/leave set) over the frame stack.
- [x] 2.4 Wire `raise` and `rt_error` to raise into the current top frame; uncaught falls
  through to the outermost frame unchanged.

## 3. Prelude / expander: the language forms

- [x] 3.1 `raise`: `(raise obj)` over the runtime raise primitive.
- [x] 3.2 `error`: R7RS `(error message obj ...)` building an error object (as a superset that
  also accepts a leading `who` symbol — see task 4/D3); `error-object?`,
  `error-object-message`, `error-object-irritants` accessors.
- [x] 3.3 `guard` macro (design D2 lowering) — as a prelude `syntax-rules` macro if hygienic
  binding of the fresh handle/value/`variable` holds, else a built-in expander form.
- [x] 3.4 Confirm `guard` and the accessors load and run under Chez (the bootstrap host) too.

## 4. error signature (dual-host superset, D3 — no migration)

- [x] 4.1 Instead of migrating call sites, make the prelude `error` a compatible superset:
  string first arg = R7RS `(error message ...)`; symbol first arg = existing
  `(error who message ...)`. Keeps every internal call site valid under both Chez and
  self-host, with no fixed-point risk.
- [x] 4.2 Confirm `%error-abort` wiring (`parse.ss`) and the assembled core still line up
  (the runtime `rt_error` now builds an error object).

## 5. Hosts: initialize the escape stack

- [x] 5.1 In `src/repl/host.cpp` and `src/run.cpp`, initialize the frame stack with the
  outermost frame (the existing `setjmp` becomes frame 0), preserving trap isolation.
- [x] 5.2 Confirm uncaught `raise`/`error` still reports and survives under the hosts and
  aborts non-zero standalone.

## 6. Verification

- [x] 6.1 `guard` returns the body value when nothing is raised.
- [x] 6.2 `guard` catches and dispatches (`raise`d symbol; `error` object via
  `error-object?`/`error-object-message`/`error-object-irritants`).
- [x] 6.3 Nested `guard`s: inner re-raises when no clause matches; outer catches.
- [x] 6.4 Uncaught `raise`/`error` still aborts non-zero standalone and survives under the host.
- [x] 6.5 New demos + expected values, run through AOT and the in-process runner (parity).
- [x] 6.6 Re-verify the self-hosting byte-identical fixed point after the `error` migration
  (`test/self-host-fixpoint.sh`).
- [x] 6.7 Full `./run-all-tests.sh` roll-up is green.

## 7. Documentation

- [x] 7.1 Update `README.md`: `guard`/`raise`/`error`(R7RS)/error-objects under language
  features; move recoverable error handling out of "Not yet done" to the extent delivered,
  noting `with-exception-handler`/`raise-continuable`/`call/cc` remain deferred.

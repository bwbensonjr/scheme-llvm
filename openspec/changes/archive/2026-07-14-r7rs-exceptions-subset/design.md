## Context

Today the language raises but cannot catch. `error` (prelude) → `%error-abort` →
`rt_error` (`runtime.c:544`) → `rt_trap` (`runtime.c:34`, a single `jmp_buf*`) →
`longjmp` or exit. The C++ hosts (`repl-host`, `scheme-run`) `setjmp` on `rt_trap` once, at
the outermost level, so a runtime trap is reported instead of killing the process. There is
no in-language way to intercept and recover — the one real catch site, the REPL's
recover-and-continue, lives in the Chez driver as an R6RS `(guard (e …) …)`
(`compile.ss:214`), which the archived `error-and-guard-conditions` (D2) deliberately kept
out of the language because batch self-hosting never catches.

`repl-embedded-incremental` moves that recovery into the compiled compiler, so catch must
become a language feature. We scope it to the **R7RS-small §6.11** subset that is reachable
without general continuations.

## Goals / Non-Goals

**Goals:**
- `guard`, `raise`, and R7RS `error` + error-objects: enough to express "try to compile a
  form; on error, recover and continue" in compiled Scheme.
- Reuse the existing `setjmp`/`longjmp` (`rt_trap`) machinery; conservative GC already makes
  non-local jumps safe (no frame unwinding needed).
- Stay R7RS-conformant for what is implemented, so this is a down-payment on §6.11, not a
  divergent hook.

**Non-Goals:**
- `with-exception-handler` and `raise-continuable` (faithful semantics require `call/cc`).
- `read-error?` / `file-error?`, general `call/cc`, the R6RS condition-type tower.
- Changing the observable abort behavior of *uncaught* errors.

## Decisions

### D1: A stack of one-shot upward escape frames, not `call/cc`

R7RS derives `guard` from `with-exception-handler` + `call/cc`. We have no `call/cc`, but
`guard` only ever escapes *upward* and never resumes into its body, so a one-shot
`setjmp`/`longjmp` escape suffices. Generalize `rt_trap` (one `jmp_buf*`) into a **stack of
escape frames**, each `{ jmp_buf env; val raised; }`:

- `%guard-enter` pushes a frame and `setjmp`s it; `%guard-leave` pops.
- `raise obj` / `error`: store `obj` in the **top** frame's `raised` slot and `longjmp`
  there; if the stack is empty, fall back to the current outermost behavior (host `rt_trap`,
  else abort) — so uncaught semantics are unchanged.

The C++ host's existing outermost `setjmp` becomes the bottom of this stack (frame 0), so
an uncaught in-language `raise` still lands in the host and the session survives.

*Alternative — implement `call/cc` first, then derive `guard` per R7RS*: cleaner and more
general, but `call/cc` over the `musttail`/`tailcc` calling convention is a large,
independent effort. The escape stack delivers `guard` now and is forward-compatible (a real
`call/cc` can later subsume it).

### D2: `guard` lowers to the escape primitive (a prelude/expander macro)

```scheme
(guard (e clause …) body …)
  ⇒
  (let ([%f (%guard-enter)])          ; push a frame; returns the frame handle
    (if (%guard-raised? %f)           ; did a raise longjmp back into this frame?
        (let ([e (%guard-object %f)])  ; the raised object
          (%guard-leave %f)
          (cond clause …
                [else (raise e)]))     ; no clause matched -> re-raise outward
        (let ([%v (begin body …)])     ; normal path
          (%guard-leave %f)
          %v)))
```

**Spike outcome (task 2.1), which refines this:** a C runtime function cannot call the
guarded thunk directly — the thunk is `fastcc` with the K-padded uniform prototype
(`self, argc, a0…a{K-1}, overflow`, `emit.ss:6`) and only the emitter knows K. But the ccc→
fastcc call is exactly what `@scheme_entry` emits, and `longjmp` across JIT'd fastcc frames
back to a C `setjmp` is exactly what `rt_trap`/`rt_error` already do. So the working shaping
is:

```
;; C runtime (owns setjmp + the frame stack); ccc_fnptr is a ccc function pointer
rt_run_guarded(ccc_fnptr, thunk):
  push frame
  if setjmp(frame.env) == 0:  v = ccc_fnptr(thunk); pop; return (ok    . v)
  else:                       o = frame.raised;     pop; return (raised . o)

;; emitter-synthesized, PRIVATE, ccc, knows K: does the fastcc 0-arg call
@__apply0(clos) = call fastcc (clos, 0, undef×K, null)
```

`guard` lowers to `(rt-run-guarded <addr of @__apply0> (lambda () body …))` then a `cond`
over the tagged pair. Passing the trampoline **by pointer** (a runtime address, not a
symbol) is what makes it work under the per-form-module JIT without symbol collisions —
mirroring how the host already calls `scheme_entry` via a looked-up address.

**Validated** by `spike/guard/` (a standalone native binary composing a C setjmp-frame
stack + `@__apply0` ccc trampoline + `rt_raise` longjmp): normal return, single catch, and
nested frames with nearest-frame delivery all pass at `-O2`. The JIT case adds only
interactions already proven in this repo (`rt_trap` longjmps across JIT'd `fastcc` frames to
a live C frame; process↔JIT calls both directions; JIT pointer calls), so the composition
holds there too.

### D2a: `guard` is an emitter-recognized special form (revises the D2 lean)

Because the lowering must (a) synthesize the private ccc trampoline `@__apply0` that knows
the module's K and (b) take its address, `guard` is recognized by the frontend/emitter (as
`apply` already is), not implemented as a pure prelude `syntax-rules` macro. `raise`, `error`,
and the error-object accessors remain ordinary procedures (prelude + runtime); only `guard`
needs emitter support. This resolves the "guard home" open question.

### D3: R7RS `error` as a compatible superset (no call-site migration)

Support `(error message obj …)` — a string `message` — producing a heap **error-object**: a
new extended header type `HDR_ERROR` holding `{ message-string, irritant-list }`. Add
`error-object?`, `error-object-message`, `error-object-irritants`. `raise`ing an error-object
that reaches the outermost trap renders it (message + irritants) and aborts / is caught by
the host.

**Revised from a signature migration to a superset (found during apply).** The R7RS
signature (`message …`, ≥1 arg) collides with the bootstrap: the compiler source is compiled
by *both* Chez (R6RS `error` needs `who` + `message`, ≥2 args) and itself, and the many
internal `(error 'who "msg")` sites have no irritants — rewriting them to `(error "who: msg")`
(1 arg) is invalid under R6RS and would break the Chez bootstrap. Instead the prelude `error`
dispatches on its first argument: a **string** first arg is the R7RS `(error message …)`; a
**symbol** first arg is the existing `(error who message …)`. R7RS programs get exact R7RS
behavior; every internal call site is unchanged (so **no migration and no fixed-point risk**);
and a symbol-as-message is undefined by R7RS anyway, so treating it as `who` is a permissible
superset, not a violation.

*Alternative — strict R7RS `error` (drop `who`) + migrate sites*: breaks the dual-host
bootstrap (above) for no user-visible benefit; the superset is conformant for R7RS programs.

### D4: Preserve uncaught behavior; only add a catch layer

An uncaught `raise`/`error` must still: under the REPL/`scheme-run` host, report and let the
session survive; standalone, exit non-zero. Because the host's `setjmp` is frame 0 of the D1
stack, this falls out for free — no host change beyond initializing the stack with its frame.

## Risks / Trade-offs

- **`setjmp`/`longjmp` across the tailcc convention** → the escape primitive must be a C
  runtime function that owns the `setjmp`; JIT'd Scheme calls into it and passes a thunk
  closure it invokes. A spike validates calling a Scheme thunk from the runtime and returning
  a tagged pair (the boundary in D2).
- **GC and non-local jumps** → conservative Boehm GC needs no unwinding; already relied on by
  `rt_trap`. New heap allocated in an abandoned `guard` body is simply collected later.
- **Frame-stack discipline on normal exit** → `%guard-leave` must pop on the normal path and
  on the caught path; a `guard` whose body itself escapes via an *outer* raise must not leave
  a stale frame. The single-primitive `%call-guarded` shaping (D2) makes enter/leave
  automatic, avoiding leaks.
- **Fixed point after the `error` migration** → re-run the triple test; error paths aren't
  exercised by a clean self-compile, but the changed message literals alter the compiler's
  own emitted error-call IR consistently across stages, so the fixed point should hold. Verify.
- **Nested `guard` + host trap interaction** → the host must install its frame as the bottom
  of the stack before running any code; document the initialization order in both hosts.

## Migration Plan

1. Runtime: add the escape-frame stack (generalize `rt_trap`), `HDR_ERROR` error-objects,
   `error-object?`/`-message`/`-irritants`, `rt_run_guarded`, `rt_raise`, `rt_guard_reset`.
   `rt_error` builds and raises an error-object.
2. Emitter: `@__apply0` ccc trampoline (internal linkage) in every module emitter; the
   `%run-guarded` primitive special-emitted to pass `@__apply0`; declare the new runtime fns.
3. Prelude: the superset `error` (D3); `raise`; error-object accessors; the `guard` /
   `%guard-clauses` macros (D2). No internal call-site migration (D3).
4. Hosts: call `rt_guard_reset()` in the trap-recovery path (both `repl-host` and
   `scheme-run`) so a trap that bypassed a frame pop leaves no stale frames (D4).
5. Verify: `guard` catches a `raise`d object and an `error` object; nested `guard`s;
   re-raise-when-no-clause; uncaught still aborts/survives; the self-hosting fixed point holds
   after migration.
6. **Rollback:** the escape stack degenerates to the old single-slot `rt_trap` if only
   frame 0 is used, so reverting the prelude/`guard` additions restores prior behavior.

## Open Questions

- ~~**Exact escape-primitive boundary**~~ **Resolved (spike, D2):** C `rt_run_guarded(ccc_fnptr,
  thunk)` owns the `setjmp`/frame stack; the emitter synthesizes the private ccc trampoline
  `@__apply0` and passes its address.
- ~~**`guard` home**~~ **Resolved (D2a):** emitter-recognized special form (like `apply`).
- **error-object printing**: how `rt_write` renders an error-object if a program prints one
  (vs. only rendering it on abort).
- **Depth bound** on the frame stack (fixed array vs. growable), and its interaction with the
  10M-iteration tail-call demos that never nest guards.

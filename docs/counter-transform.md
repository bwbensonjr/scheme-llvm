# Transformation walkthrough: `demos/counter.scm`

Every stage of the core-lambda-slice pipeline applied to the most
feature-dense demo. It exercises the full pass chain at once:

- a captured variable mutated with `set!` (→ boxing)
- a closure returned from a closure (nested `lambda`, free-variable capture)
- `letrec` / `let` binding forms and a primitive call at the top level

Regenerate with:

```sh
chez --libdirs src --script src/compile.ss demos/counter.scm -o /tmp/counter --dump
```

## Source

```scheme
(letrec ([make-counter (lambda ()
                         (let ([c 0])
                           (lambda () (set! c (+ c 1)) c)))])
  (let ([f (make-counter)])
    (+ (f) (f))))
```

`make-counter` returns a fresh closure over its own `c`. Each returned
counter increments and returns its private `c`. `(+ (f) (f))` calls the
one counter twice, so the program evaluates to `1 + 2 = 3`.

## Stage 1 — parse + alpha-rename (`parse.ss`)

Surface syntax becomes the core IL, and every binding gets a unique
suffix (`make-counter.0`, `c.1`, `f.2`) so later passes never have to
worry about shadowing. Literals become `(const …)`, calls `(call …)`,
primitives `(primcall …)`, and the two-form `lambda` body folds into
`(seq …)`.

```scheme
(letrec ([make-counter.0 (lambda ()
                           (let ([c.1 (const 0)])
                             (lambda ()
                               (seq (set! c.1 (primcall + c.1 (const 1)))
                                    c.1))))])
  (let ([f.2 (call make-counter.0)])
    (primcall + (call f.2) (call f.2))))
```

## Stage 2 — recognize-let (`passes/recognize-let.ss`)

A no-op here: `let` was already explicit in the source, so there is
nothing for this pass to recover. (It matters for programs that write
`let` as an immediately-applied `lambda`.) Output is identical to Stage 1.

## Stage 3 — convert-assignments (`passes/convert-assignments.ss`)

`c.1` is mutated by `set!`, so it is heap-allocated in a **box**. The
original initializer is renamed to `c.1.3`, a new binding `c.1` holds
`(box c.1.3)`, reads become `(unbox c.1)`, and the `set!` becomes
`(set-box! c.1 …)`. After this pass no `set!` remains — mutation is just
primitive calls on a heap cell, which is what lets a closure share the
mutable variable.

```scheme
(letrec ([make-counter.0 (lambda ()
                           (let ([c.1.3 (const 0)])
                             (let ([c.1 (primcall box c.1.3)])
                               (lambda ()
                                 (seq (primcall
                                        set-box!
                                        c.1
                                        (primcall + (primcall unbox c.1) (const 1)))
                                      (primcall unbox c.1))))))])
  (let ([f.2 (call make-counter.0)])
    (primcall + (call f.2) (call f.2))))
```

## Stage 4 — convert-closures (`passes/convert-closures.ss`)

`letrec` becomes an explicit `(closures …)` form. Each bound lambda is
listed with its **free-variable list** (empty `()` for `make-counter.0`)
alongside the code. The mutually-recursive scope is now data the later
passes can lower directly.

```scheme
(closures
  ((make-counter.0
     ()
     (lambda ()
       (let ([c.1.3 (const 0)])
         (let ([c.1 (primcall box c.1.3)])
           (lambda ()
             (seq (primcall
                    set-box!
                    c.1
                    (primcall + (primcall unbox c.1) (const 1)))
                  (primcall unbox c.1))))))))
  (let ([f.2 (call make-counter.0)])
    (primcall + (call f.2) (call f.2))))
```

## Stage 5 — lambda-lift + lower (`passes/lower.ss`)

The final IL (`L-code`). Every `lambda` is lifted to a top-level `code`
block taking an explicit closure pointer (`cp.7`, `cp.5`). Free-variable
references become `(free-ref N)` — slot indices into the closure record —
so the inner counter reads its captured box as `(free-ref 0)`. The
returned inner counter is built with `(make-closure "code_6" ((local c.1)))`,
capturing the box into slot 0. Calls become `(app …)` and variable
references are tagged `(local …)`.

```scheme
(program
  ((code
     "code_6"
     cp.7
     ()
     (seq (primcall
            set-box!
            (free-ref 0)
            (primcall + (primcall unbox (free-ref 0)) (const 1)))
          (primcall unbox (free-ref 0))))
    (code
      "code_4"
      cp.5
      ()
      (let ([c.1.3 (const 0)])
        (let ([c.1 (primcall box (local c.1.3))])
          (make-closure "code_6" ((local c.1)))))))
  (closure-block
    ((make-counter.0 "code_4" ()))
    (let ([f.2 (app (local make-counter.0) ())])
      (primcall + (app (local f.2) ()) (app (local f.2) ())))))
```

## Stage 6 — emit LLVM IR (`emit.ss`)

L-code is rendered to textual LLVM. Notes on the mapping:

- Each `code` block is a `tailcc i64 @code_N(i64 %self)` function; `%self`
  is the closure pointer.
- `(free-ref 0)` is `%self & -8` (strip the `100` closure tag) →
  `inttoptr` → `getelementptr i64, ptr, i64 1` (skip the code pointer) →
  `load`. Slot 0 lives at record index 1 because index 0 is the code
  pointer.
- `(make-closure …)` allocates via `rt_alloc_words`, stores the code
  pointer then each captured value, and tags the result with `or …, 4`.
- Primitives dispatch to the C runtime (`rt_box`, `rt_unbox`,
  `rt_set_box`, `rt_add`). The `(const 1)` fixnum is emitted as the raw
  tagged word `8` (`1 << 3`).
- `@scheme_entry` (plain `ccc`, called from C `main`) builds the
  `make-counter` closure, calls it to get `f`, then calls `f` twice and
  adds the results.

```llvm
declare i64 @rt_alloc_words(i64)
declare i64 @rt_cons(i64, i64)
declare i64 @rt_car(i64)
declare i64 @rt_cdr(i64)
declare i64 @rt_box(i64)
declare i64 @rt_unbox(i64)
declare i64 @rt_set_box(i64, i64)
declare i64 @rt_add(i64, i64)
declare i64 @rt_sub(i64, i64)
declare i64 @rt_mul(i64, i64)
declare i64 @rt_num_eq(i64, i64)
declare i64 @rt_lt(i64, i64)
declare i64 @rt_null_p(i64)
declare i64 @rt_pair_p(i64)
declare i64 @rt_eq_p(i64, i64)

define tailcc i64 @code_6(i64 %self) {
entry:
  %t23 = and i64 %self, -8
  %t22 = inttoptr i64 %t23 to ptr
  %t21 = getelementptr i64, ptr %t22, i64 1
  %t20 = load i64, ptr %t21
  %t27 = and i64 %self, -8
  %t26 = inttoptr i64 %t27 to ptr
  %t25 = getelementptr i64, ptr %t26, i64 1
  %t24 = load i64, ptr %t25
  %t28 = call i64 @rt_unbox(i64 %t24)
  %t29 = call i64 @rt_add(i64 %t28, i64 8)
  %t30 = call i64 @rt_set_box(i64 %t20, i64 %t29)
  %t34 = and i64 %self, -8
  %t33 = inttoptr i64 %t34 to ptr
  %t32 = getelementptr i64, ptr %t33, i64 1
  %t31 = load i64, ptr %t32
  %t35 = call i64 @rt_unbox(i64 %t31)
  ret i64 %t35
}

define tailcc i64 @code_4(i64 %self) {
entry:
  %t36 = call i64 @rt_box(i64 0)
  %t38 = call i64 @rt_alloc_words(i64 2)
  %t37 = inttoptr i64 %t38 to ptr
  store i64 ptrtoint (ptr @code_6 to i64), ptr %t37
  %t39 = getelementptr i64, ptr %t37, i64 1
  store i64 %t36, ptr %t39
  %t40 = or i64 %t38, 4
  ret i64 %t40
}

define i64 @scheme_entry() {
entry:
  %t2 = call i64 @rt_alloc_words(i64 1)
  %t1 = inttoptr i64 %t2 to ptr
  store i64 ptrtoint (ptr @code_4 to i64), ptr %t1
  %t3 = or i64 %t2, 4
  %t7 = and i64 %t3, -8
  %t6 = inttoptr i64 %t7 to ptr
  %t5 = load i64, ptr %t6
  %t4 = inttoptr i64 %t5 to ptr
  %t8 = call tailcc i64 %t4(i64 %t3)
  %t12 = and i64 %t8, -8
  %t11 = inttoptr i64 %t12 to ptr
  %t10 = load i64, ptr %t11
  %t9 = inttoptr i64 %t10 to ptr
  %t13 = call tailcc i64 %t9(i64 %t8)
  %t17 = and i64 %t8, -8
  %t16 = inttoptr i64 %t17 to ptr
  %t15 = load i64, ptr %t16
  %t14 = inttoptr i64 %t15 to ptr
  %t18 = call tailcc i64 %t14(i64 %t8)
  %t19 = call i64 @rt_add(i64 %t13, i64 %t18)
  ret i64 %t19
}
```

## Result

```
$ /tmp/counter
3
```

`(f)` returns 1, the second `(f)` returns 2 (the shared box persists
between calls), and `(+ 1 2)` is `3`.

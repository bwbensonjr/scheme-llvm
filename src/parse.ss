;;; parse.ss -- read source into the core IL, then alpha-rename.  (Included into
;;; compile.ss; assumes (match) and (util) are imported.)
;;;
;;; Core IL:
;;;   (const d) | x | (if e e e) | (lambda (x ...) e) | (call e e ...)
;;;   (primcall op e ...) | (let ([x e] ...) e) | (letrec ([x e] ...) e)
;;;   (seq e e) | (set! x e)
;;;
;;; Nearly every primitive name is now an ordinary, shadowable binding (an
;;; *integrable*, below); only the raw %-ops and a few host internals are reserved
;;; keywords.  See the `first-class-primitives` change.

;; Reserved primcall heads.  EVERY standard primitive is now *integrable* (below),
;; i.e. an ordinary shadowable binding -- including the variadic folding ops, whose
;; value-position eta is a self-contained rest-param fold over raw primcalls, so no
;; primitive needs a prelude helper or a parse-time special case any more.  The
;; expander still folds n-ary `+`/`=`/`string-append`/... to binary forms (emitting
;; the plain name, which the inliner rewrites to `%+`/`%=`/`%string-append`/...);
;; `> <= >=` remain derived over the integrable `<`/`=`.  Only compiler/host internals
;; stay reserved: the %-ops (hashing, records, error plumbing, `%no-prelude?`) and the
;; REPL state ops (`repl-mode`/`repl-input`/`repl-state-ref`/`repl-state-set!`) --
;; never used as values, and the raw %-ops staying internal is a Non-Goal to relax.
(define *prims* '(%+ %- %* %/ %= %< %eq? %eqv?
                  %cons %quotient %remainder %modulo %car %cdr %null? %pair? %equal? %not
                  %char->integer %integer->char
                  %string-length %string-ref %string->symbol %symbol->string %list->string
                  %string-set! %substring %string=? %make-string %string-copy
                  %string-append
                  %vector-ref %vector-set! %vector-length %vector? %make-vector
                  %bytevector-u8-ref %bytevector-u8-set! %bytevector-length %bytevector?
                  %make-bytevector
                  %symbol? %string? %char? %boolean? %integer? %exact?
                  %flonum? %number? %real? %inexact? %exact->inexact %inexact->exact
                  %string->flonum %flonum->string
                  %read-all-stdin %display %write %write-char %newline
                  %hash %make-hash-table %hash-table? %hash-table-spine
                  %make-record-type %make-record %record-ref %record-set! %record-of-type? %record?
                  %list->mv %mv? %mv->list
                  %no-prelude?
                  repl-mode repl-input repl-state-ref repl-state-set!
                  %error-abort %raise %run-guarded
                  %error-object? %error-object-message %error-object-irritants))
(define (prim? op) (and (memq op *prims*) #t))

;; ---- primitives as first-class values ----
;; A bare primitive reference in value position (e.g. `(map car xs)`, `(apply + ns)`)
;; must become a genuine procedure.  This is no longer a parse-time special-case for
;; ANY primitive: every one is *integrable* (below), so the shadow-aware
;; inline-primitives pass (run after rename) supplies BOTH its direct-call inlining
;; and its value-position eta.  Fixed-arity ops eta to `(lambda (p ..) (primcall %op
;; p ..))`; the variadic folding ops (`+ - * = < string-append`) eta to a
;; self-contained rest-param fold over raw primcalls (fold-eta).  The old
;; `prim-as-value`/`*prim-eta-arity*`/`nsyms` machinery is fully retired (task 4.1).
;; The eta must not live in the prelude: a prelude `(define (car x) (car x))` would be
;; a primcall under Emit but infinite self-recursion under the bootstrap host.

;; ---- integrable primitives (change: first-class-primitives) ----
;; Plain names that are ORDINARY, shadowable, first-class -- NOT reserved keywords.
;; Each maps to its raw %-primcall and fixed arity.  After rename, an UNSHADOWED
;; integrable survives as its bare symbol (a lexical/user shadow was alpha-renamed
;; unique), so `inline-primitives` can tell them apart with no scope tracking:
;;   direct call  (cons a b)  -> (primcall %cons a b)          [bare op]
;;   value use     cons       -> (lambda (p ..) (primcall %cons p ..))   [eta]
;;   shadowed (renamed symbol) -> untouched (ordinary binding wins)
;; Universal by construction: the names are compiler-intrinsic (added to
;; compute-known), so programs, user libraries, and --no-prelude all get them.
(define *integrable*
  '((cons %cons 2)
    ;; Batch B: arithmetic / comparison / equality.  The expander (expand-arith,
    ;; expand-compare) reduces every n-ary OPERATOR-position call to a BINARY form, so
    ;; the arity-2 entry drives direct-call inlining.  The optional 4th field is a
    ;; fold-kind for the VALUE-position eta: `+ - * = <` are variadic as values
    ;; (`(apply + ns)`), so their eta is a self-contained rest-param fold over raw
    ;; primcalls (see fold-eta) -- no prelude dependency, works under --no-prelude.
    ;; `eq?`/`eqv?` are binary in R7RS, so they keep the plain binary eta.
    (+ %+ 2 sum) (- %- 2 diff) (* %* 2 product) (/ %/ 2 quot) (= %= 2 cmp) (< %< 2 cmp)
    (eq? %eq? 2) (eqv? %eqv? 2)
    (quotient %quotient 2) (remainder %remainder 2) (modulo %modulo 2)
    (car %car 1) (cdr %cdr 1) (null? %null? 1) (pair? %pair? 1)
    (equal? %equal? 2) (not %not 1)
    ;; inexact numbers (change: inexact-numbers): flonum predicates/conversions and
    ;; write-char.  integer?/exact? are unchanged here (only their runtime semantics
    ;; refine to distinguish flonums).
    (flonum? %flonum? 1) (number? %number? 1) (real? %real? 1) (inexact? %inexact? 1)
    (exact->inexact %exact->inexact 1) (inexact->exact %inexact->exact 1)
    (write-char %write-char 1)
    (char->integer %char->integer 1) (integer->char %integer->char 1)
    (string-length %string-length 1) (string-ref %string-ref 2)
    (string->symbol %string->symbol 1) (symbol->string %symbol->string 1)
    (list->string %list->string 1) (string-set! %string-set! 3)
    (vector-ref %vector-ref 2) (vector-set! %vector-set! 3)
    (vector-length %vector-length 1) (vector? %vector? 1)
    (bytevector-u8-ref %bytevector-u8-ref 2) (bytevector-u8-set! %bytevector-u8-set! 3)
    (bytevector-length %bytevector-length 1) (bytevector? %bytevector? 1)
    (symbol? %symbol? 1) (string? %string? 1) (char? %char? 1)
    (boolean? %boolean? 1) (integer? %integer? 1) (exact? %exact? 1)
    ;; Batch B increment 2: remaining string/vector/bytevector construction+access
    ;; and I/O prims.  All fixed-arity in Emit (the runtime rt_* have fixed C
    ;; signatures -- e.g. make-vector REQUIRES the fill, substring is exactly 3).
    (substring %substring 3) (string=? %string=? 2)
    (make-string %make-string 2) (string-copy %string-copy 1)
    (make-vector %make-vector 2) (make-bytevector %make-bytevector 2)
    (read-all-stdin %read-all-stdin 0)
    (display %display 1) (write %write 1) (newline %newline 0)
    ;; string-append: expander folds n-ary operator calls to binary %string-append
    ;; (arity 2 for direct inlining); as a VALUE it is variadic, so its eta is the
    ;; self-contained `str` fold -- retiring the prelude `%str-concat` special case.
    (string-append %string-append 2 str)))
(define (integrable-lookup name) (assq name *integrable*))
(define (integrable? name) (and (integrable-lookup name) #t))

(define (fresh-syms n)   ; n globally-unique param names for an eta lambda
  (let loop ([i n] [acc '()])
    (if (= i 0) acc (loop (- i 1) (cons (fresh-name 'p) acc)))))

;; Value-position eta for an integrable.  Fixed-arity ops get a plain
;; `(lambda (p ..) (primcall raw p ..))`; a variadic folding op (4th field = fold
;; kind) gets a self-contained rest-param fold built from raw primcalls -- so it
;; needs no prelude helper and works identically under --no-prelude.  A rest-param
;; lambda `(lambda gs ...)` collects all call args into the list `gs`, which serves
;; BOTH `(map + xs ys)` (args passed individually) and `(apply + ns)` (a list).
(define (eta-integrable entry)  ; (name raw arity [fold-kind]) -> value-position lambda
  (if (and (pair? (cdddr entry)) (cadddr entry))
      (fold-eta (cadr entry) (cadddr entry))
      (let ([ps (fresh-syms (caddr entry))])
        `(lambda ,ps (primcall ,(cadr entry) ,@ps)))))

;; a left-fold `(lambda gs (loop IDENT gs))` where loop threads ACC over gs with
;; `(primcall RAW acc (car rest))`.  Used for `+`(0) `*`(1) `string-append`("").
(define (left-fold-eta raw ident)
  (let ([gs (fresh-name 'gs)] [loop (fresh-name 'loop)]
        [acc (fresh-name 'acc)] [rest (fresh-name 'rest)])
    `(lambda ,gs
       (letrec ([,loop (lambda (,acc ,rest)
                         (if (primcall %null? ,rest)
                             ,acc
                             (call ,loop (primcall ,raw ,acc (primcall %car ,rest))
                                         (primcall %cdr ,rest))))])
         (call ,loop ,ident ,gs)))))

;; `-` as a value: `(- a)` negates, `(- a b ...)` subtracts left-to-right, `(- )`
;; is degenerate (0).  Distinct from the identity folds above.
(define (diff-eta raw)
  (let ([gs (fresh-name 'gs)] [loop (fresh-name 'loop)]
        [acc (fresh-name 'acc)] [rest (fresh-name 'rest)])
    `(lambda ,gs
       (if (primcall %null? ,gs)
           (const 0)
           (if (primcall %null? (primcall %cdr ,gs))
               (primcall ,raw (const 0) (primcall %car ,gs))          ; (- a) -> 0 - a
               (letrec ([,loop (lambda (,acc ,rest)
                                 (if (primcall %null? ,rest)
                                     ,acc
                                     (call ,loop (primcall ,raw ,acc (primcall %car ,rest))
                                                 (primcall %cdr ,rest))))])
                 (call ,loop (primcall %car ,gs) (primcall %cdr ,gs))))))))

;; `/` as a value: `(/ a)` -> `(/ 1 a)` (reciprocal), `(/ a b ...)` divides
;; left-to-right, `(/)` is degenerate (1).  Mirrors diff-eta with a 1 identity.
(define (div-eta raw)
  (let ([gs (fresh-name 'gs)] [loop (fresh-name 'loop)]
        [acc (fresh-name 'acc)] [rest (fresh-name 'rest)])
    `(lambda ,gs
       (if (primcall %null? ,gs)
           (const 1)
           (if (primcall %null? (primcall %cdr ,gs))
               (primcall ,raw (const 1) (primcall %car ,gs))          ; (/ a) -> 1 / a
               (letrec ([,loop (lambda (,acc ,rest)
                                 (if (primcall %null? ,rest)
                                     ,acc
                                     (call ,loop (primcall ,raw ,acc (primcall %car ,rest))
                                                 (primcall %cdr ,rest))))])
                 (call ,loop (primcall %car ,gs) (primcall %cdr ,gs))))))))

;; `= `/`<` as a value: a short-circuit pairwise chain; 0 or 1 operand -> #t.
(define (cmp-chain-eta raw)
  (let ([gs (fresh-name 'gs)] [loop (fresh-name 'loop)]
        [prev (fresh-name 'prev)] [rest (fresh-name 'rest)])
    `(lambda ,gs
       (if (primcall %null? ,gs)
           (const #t)
           (if (primcall %null? (primcall %cdr ,gs))
               (const #t)
               (letrec ([,loop (lambda (,prev ,rest)
                                 (if (primcall %null? ,rest)
                                     (const #t)
                                     (if (primcall ,raw ,prev (primcall %car ,rest))
                                         (call ,loop (primcall %car ,rest) (primcall %cdr ,rest))
                                         (const #f))))])
                 (call ,loop (primcall %car ,gs) (primcall %cdr ,gs))))))))

(define (fold-eta raw kind)
  (case kind
    [(sum)     (left-fold-eta raw '(const 0))]
    [(product) (left-fold-eta raw '(const 1))]
    [(str)     (left-fold-eta raw '(const ""))]
    [(diff)    (diff-eta raw)]
    [(quot)    (div-eta raw)]
    [(cmp)     (cmp-chain-eta raw)]
    [else (error 'parse "unknown integrable fold kind" kind)]))

;; inline-primitives: a universal pass run AFTER rename/resolve in every compile
;; path (compile-forms, compile-program-with-imports, repl-lower-form).
(define (inline-primitives e)
  (define (I e)
    (match e
      [(const ,d) e]
      [(global-ref ,s) e]
      [(global-set! ,s ,rhs) `(global-set! ,s ,(I rhs))]
      [,x (guard (symbol? x))
          (let ([p (integrable-lookup x)]) (if p (eta-integrable p) x))]
      [(if ,a ,b ,c) `(if ,(I a) ,(I b) ,(I c))]
      [(seq ,a ,b) `(seq ,(I a) ,(I b))]
      [(set! ,x ,rhs) `(set! ,x ,(I rhs))]
      [(primcall ,op . ,args) `(primcall ,op ,@(map I args))]
      [(apply ,f . ,args) `(apply ,(I f) ,@(map I args))]
      [(call ,f . ,args)
       (let ([p (and (symbol? f) (integrable-lookup f))])
         (if (and p (= (length args) (caddr p)))
             `(primcall ,(cadr p) ,@(map I args))     ; direct unshadowed call -> bare op
             `(call ,(I f) ,@(map I args))))]         ; value/wrong-arity -> eta (via symbol case)
      [(lambda ,params ,body) `(lambda ,params ,(I body))]
      [(let ,binds ,body)
       `(let ,(map (lambda (b) (list (car b) (I (cadr b)))) binds) ,(I body))]
      [(letrec ,binds ,body)
       `(letrec ,(map (lambda (b) (list (car b) (I (cadr b)))) binds) ,(I body))]))
  (I e))

;; ---- variadic parameter lists ----
;; A lambda's param field may be a proper list (fixed arity), an improper list
;; (dotted rest `(a b . r)`), or a bare symbol (all-args rest).  These helpers
;; decompose and rebuild that shape; every pass that touches params uses them so
;; the three cases are handled uniformly.
(define (param-fixed p)             ; proper list of the fixed param names
  (cond [(symbol? p) '()]
        [(pair? p) (cons (car p) (param-fixed (cdr p)))]
        [else '()]))                ; null
(define (param-rest p)              ; the rest name, or #f if fixed arity
  (cond [(symbol? p) p]
        [(pair? p) (param-rest (cdr p))]
        [else #f]))                 ; null
(define (param-names p)             ; all bound names: fixed ++ (rest if any)
  (let ([r (param-rest p)])
    (if r (append (param-fixed p) (list r)) (param-fixed p))))
(define (rebuild-params fixed rest) ; proper `fixed` + (sym|#f) -> param field
  (if rest
      (let loop ([f fixed]) (if (null? f) rest (cons (car f) (loop (cdr f)))))
      fixed))

;; ---- parse: s-expr -> core IL ----
(define (parse-program sexp) (parse-expr sexp))

(define (parse-expr e)
  (cond
    [(and (integer? e) (exact? e)) `(const ,e)]
    [(boolean? e) `(const ,e)]
    [(string? e) `(const ,e)]              ; string literals are self-evaluating
    [(char? e) `(const ,e)]                ; char literals are self-evaluating
    [(null? e) `(const ())]
    ;; a bare symbol is a variable ref; an integrable's value-use eta is synthesized
    ;; post-rename by inline-primitives (self-contained, so even variadic ops like
    ;; `+`/`string-append` need no parse-time special case anymore).
    [(symbol? e) e]
    [(pair? e)
     (match e
       [(quote ,d) `(const ,d)]
       [(if ,a ,b ,c) `(if ,(parse-expr a) ,(parse-expr b) ,(parse-expr c))]
       ;; two-armed `(if test then)`: a missing alternative is the unspecified
       ;; value, spelled `#f` to match `when`/`unless` and the `case` no-match
       ;; default (which desugars to `(if #f #f)`).  Distinct arities, so this
       ;; never overlaps the three-armed clause above.
       [(if ,a ,b) `(if ,(parse-expr a) ,(parse-expr b) (const #f))]
       [(lambda ,params . ,body) `(lambda ,params ,(parse-body body))]
       [(let ,binds . ,body) `(let ,(map parse-bind binds) ,(parse-body body))]
       [(letrec ,binds . ,body) `(letrec ,(map parse-bind binds) ,(parse-body body))]
       [(begin . ,body) (parse-body body)]
       [(define . ,rest) (error 'parse "'define' is only allowed at the top level" e)]
       [(set! ,x ,rhs) `(set! ,x ,(parse-expr rhs))]
       ;; (apply f a1 ... aN lst): N leading args then a list to spread.  The
       ;; last operand is the list; there must be at least one operand.
       [(apply ,f ,a . ,rest)
        `(apply ,(parse-expr f) ,@(map parse-expr (cons a rest)))]
       [(,op . ,args) (guard (prim? op)) `(primcall ,op ,@(map parse-expr args))]
       [(,f . ,args) `(call ,(parse-expr f) ,@(map parse-expr args))])]
    ;; inexact real (flonum) literal (change: inexact-numbers).  Placed after the
    ;; atom/pair clauses so `real?` is only evaluated for a genuine flonum datum --
    ;; the compiler/prelude sources carry no flonum literals, so this never runs
    ;; during the bootstrap regen (where the seed lacks `real?`).  An integral
    ;; flonum (3.0) fails clause 1's `(exact? e)` and lands here too.
    [(and (real? e) (not (exact? e))) `(const ,e)]
    [else (error 'parse "bad expression" e)]))

(define (parse-bind b) (list (car b) (parse-expr (cadr b))))

(define (parse-body body)  ; non-empty list of source forms -> one core expr
  (if (and (pair? body) (define-form? (car body)))
      (parse-expr (build-body body))   ; leading internal defines -> letrec/let+set!
      (let loop ([es (map parse-expr body)])
        (cond
          [(null? es) `(const ())]
          [(null? (cdr es)) (car es)]
          [else `(seq ,(car es) ,(loop (cdr es)))]))))

;; ---- collect-toplevel: a program's top-level forms -> one source expr ----
;; A program is a sequence of top-level forms: any number of (define ...) and
;; expressions, ending in an expression whose value is the program's value.
;; This is a source->source pass (its output goes through parse-expr like any
;; form) and the only place top-level `define` is understood.
;;
;; Definitions desugar to bindings over the trailing expression.  The backend's
;; `letrec` is letrec-*of-lambdas* (convert-closures turns every binding into a
;; closure), so:
;;   - all-lambda defines  -> (letrec (...) body)      -- efficient, unchanged
;;   - value/mixed defines -> (let (placeholders) (set! ...) ... body)
;;     the classic letrec*->let+set! transform; boxing is handled downstream by
;;     convert-assignments, so this stays frontend-only.
(define (define-form? f) (and (pair? f) (eq? (car f) 'define)))
(define (lambda-init? init) (and (pair? init) (eq? (car init) 'lambda)))

(define (normalize-define f)  ; (define ...) -> (name init-sexpr)
  (let ([sig (cadr f)] [rest (cddr f)])
    (cond
      [(pair? sig)                       ; (define (f arg ...) body ...)
       (list (car sig) `(lambda ,(cdr sig) ,@rest))]
      [(symbol? sig)                     ; (define x e)
       (unless (and (pair? rest) (null? (cdr rest)))
         (error 'collect-toplevel "malformed (define x e)" f))
       (list sig (car rest))]
      [else (error 'collect-toplevel "malformed define" f)])))

;; ---- define-record-type (openspec records) ------------------------------
;; A built-in definition form, recognized here alongside `define` (collect-toplevel
;; runs before `expand`, so a form that introduces bindings must be lowered where
;; top-level defines are understood -- not in the syntax-rules expander, which sees
;; the program already folded into one letrec body).  It lowers to a list of
;; (name init) binding pairs over the record primitives:
;;   (define-record-type NAME (CTOR cf ...) PRED (fld ACC [MUT]) ...)
;; ->
;;   (<rtd> (%make-record-type "NAME"))                 ; fresh descriptor, once
;;   (CTOR  (lambda (cf ...) (%make-record <rtd> (list <field0|()> ...))))
;;   (PRED  (lambda (o) (%record-of-type? o <rtd>)))
;;   (ACC   (lambda (o) (%record-ref o i)))             ; per field, i = body index
;;   (MUT   (lambda (o v) (%record-set! o i v)))        ; per field with a mutator
;; Field indices follow the body field-tag order; a constructor field not listed
;; in the body order is left unspecified (R7RS allows a subset constructor).
(define (record-type-form? f) (and (pair? f) (eq? (car f) 'define-record-type)))

;; ---- define-record-type shape validation -------------------------------------
;; record-type-bindings destructures the form with raw car/cdr, so a malformed
;; form would otherwise read past the end of short lists and drive the compiler
;; into undefined behavior (change: validate-record-type-syntax).  Validate the
;; whole shape here FIRST and raise a recoverable (error 'collect-toplevel ...)
;; -- the same channel the REPL catches, prints as an `error:` line, and returns
;; to the prompt from (mirroring normalize-define's existing validation).
(define (rt-proper-list? x)   ; a proper (nil-terminated) list
  (cond [(null? x) #t]
        [(pair? x) (rt-proper-list? (cdr x))]
        [else #f]))
(define (rt-symbols? x)       ; a proper list whose every element is a symbol
  (cond [(null? x) #t]
        [(and (pair? x) (symbol? (car x))) (rt-symbols? (cdr x))]
        [else #f]))
(define (rt-field-spec? spec) ; (fld ACC) or (fld ACC MUT), all symbols
  (and (rt-proper-list? spec)
       (rt-symbols? spec)
       (let ([n (length spec)]) (or (= n 2) (= n 3)))))

(define (check-record-type-form f)
  ;; f = (define-record-type NAME (CTOR cf ...) PRED (fld ACC [MUT]) ...)
  (unless (and (rt-proper-list? f) (>= (length f) 4))
    (error 'collect-toplevel
           "malformed define-record-type: expected (define-record-type NAME (CTOR field ...) PRED (field accessor [mutator]) ...)"
           f))
  (let ([tyname     (cadr f)]
        [ctor-spec  (caddr f)]
        [pred       (cadddr f)]
        [field-specs (cdr (cdddr f))])   ; cddddr, spelled without cddddr (not exported)
    (unless (symbol? tyname)
      (error 'collect-toplevel "define-record-type: type name must be a symbol" f))
    (unless (and (pair? ctor-spec) (rt-proper-list? ctor-spec) (rt-symbols? ctor-spec))
      (error 'collect-toplevel
             "define-record-type: constructor spec must be (constructor field ...) of symbols" f))
    (unless (symbol? pred)
      (error 'collect-toplevel "define-record-type: predicate must be a symbol" f))
    (for-each
      (lambda (spec)
        (unless (rt-field-spec? spec)
          (error 'collect-toplevel
                 "define-record-type: field spec must be (field accessor [mutator]) of symbols" f)))
      field-specs)
    ;; every constructor field tag must name a declared field
    (let ([field-names (map car field-specs)])
      (for-each
        (lambda (cf)
          (unless (memq cf field-names)
            (error 'collect-toplevel
                   "define-record-type: constructor field is not a declared field" f)))
        (cdr ctor-spec)))))

(define (record-field-bindings specs i)   ; ((fld ACC [MUT]) ...) -> (name init) pairs
  (if (null? specs)
      '()
      (let* ([spec (car specs)]
             [acc  (cadr spec)]
             [has-mut (pair? (cddr spec))]        ; a third element => mutator name
             [o    (fresh-name 'r)]
             [v    (fresh-name 'v)]
             [getter (list acc `(lambda (,o) (%record-ref ,o ,i)))]
             [rest (record-field-bindings (cdr specs) (+ i 1))])
        (if has-mut
            (cons getter
                  (cons (list (caddr spec) `(lambda (,o ,v) (%record-set! ,o ,i ,v)))
                        rest))
            (cons getter rest)))))

(define (record-type-bindings f)
  (check-record-type-form f)              ; reject malformed shapes before destructuring
  (let* ([tyname     (cadr f)]
         [rest1      (cddr f)]
         [ctor-spec  (car rest1)]              ; (CTOR cf ...)
         [rest2      (cdr rest1)]
         [pred       (car rest2)]
         [field-specs (cdr rest2)]             ; ((fld ACC [MUT]) ...)
         [ctor       (car ctor-spec)]
         [ctor-fields (cdr ctor-spec)]
         [field-names (map car field-specs)]
         [rtd        (fresh-name 'rtd)]
         [o          (fresh-name 'r)])
    (cons
      (list rtd `(%make-record-type ,(symbol->string tyname)))
      (cons
        (list ctor
              `(lambda ,ctor-fields
                 (%make-record ,rtd
                   (list ,@(map (lambda (fn) (if (memq fn ctor-fields) fn '(quote ())))
                                field-names)))))
        (cons
          (list pred `(lambda (,o) (%record-of-type? ,o ,rtd)))
          (record-field-bindings field-specs 0))))))

(define (seq-forms pre value)  ; non-final exprs + final -> one form
  (if (null? pre) value `(begin ,@pre ,value)))

(define (build-program binds pre value)
  (cond
    [(null? binds) (seq-forms pre value)]
    [(andmap (lambda (b) (lambda-init? (cadr b))) binds)
     `(letrec ,binds ,(seq-forms pre value))]
    [else
     `(let ,(map (lambda (b) (list (car b) '(quote ()))) binds)
        ,@(map (lambda (b) `(set! ,(car b) ,(cadr b))) binds)
        ,@pre
        ,value)]))

;; internal defines: a body whose leading forms are (define ...) desugars via the
;; SAME builder as the top level, but with R7RS body rules -- the defines must
;; form a prefix (no define after a body expression) and letrec* bindings are
;; visible across the whole run.  Returns a source form (re-parsed by parse-expr).
(define (any-define? fs)
  (and (pair? fs)
       (or (define-form? (car fs)) (record-type-form? (car fs)) (any-define? (cdr fs)))))
(define (build-body forms)
  (let loop ([fs forms] [binds '()])
    (cond
      [(and (pair? fs) (define-form? (car fs)))
       (loop (cdr fs) (cons (normalize-define (car fs)) binds))]
      [(and (pair? fs) (record-type-form? (car fs)))
       (loop (cdr fs) (append (reverse (record-type-bindings (car fs))) binds))]
      [(null? fs)
       (error 'parse "internal defines with no following body expression" forms)]
      [(any-define? fs)
       (error 'parse "internal 'define' must precede all body expressions" forms)]
      [else
       (let ([rev (reverse fs)])
         (build-program (reverse binds) (reverse (cdr rev)) (car rev)))])))

(define (collect-toplevel forms)
  (when (null? forms)
    (error 'collect-toplevel "empty program: no top-level forms"))
  (let loop ([fs forms] [binds '()] [pre '()])
    (cond
      [(null? fs)
       (error 'collect-toplevel
              "program must end in an expression, not a definition")]
      [(define-form? (car fs))
       (loop (cdr fs) (cons (normalize-define (car fs)) binds) pre)]
      [(record-type-form? (car fs))
       (loop (cdr fs) (append (reverse (record-type-bindings (car fs))) binds) pre)]
      [(null? (cdr fs))                  ; final form = the program's value
       (build-program (reverse binds) (reverse pre) (car fs))]
      [else                              ; a non-final top-level expression
       (loop (cdr fs) binds (cons (car fs) pre))])))

;; ---- REPL top-level model: persistent global definitions -----------------
;; Batch `collect-toplevel` folds a whole program into one letrec.  The REPL
;; instead compiles each entered form on its own, and top-level `define`s become
;; *persistent globals* that survive across forms.  A definition introduces two
;; new core-IL nodes that thread through the remaining passes:
;;
;;   (global-ref  sym)      -- load the current value of a persistent global
;;   (global-set! sym e)    -- store e into a persistent global slot (its value)
;;
;; `sym` is a *generation-mangled* symbol (e.g. x.g0, x.g1): redefining a name
;; allocates a fresh generation, so later forms resolve the name to the newest
;; binding while already-compiled forms keep the symbol they captured.  The
;; environment maps user names -> current mangled symbol.

(define (make-repl-env) (vector '() 0))          ; #(name->sym alist, generation)

(define (repl-env-lookup env name)               ; -> mangled sym, or #f
  (let ([p (assq name (vector-ref env 0))]) (and p (cdr p))))

(define (repl-env-define! env name)              ; allocate a fresh generation
  (let* ([g   (vector-ref env 1)]
         [sym (string->symbol
                (string-append (symbol->string name) ".g" (number->string g)))])
    (vector-set! env 1 (+ g 1))
    (vector-set! env 0 (cons (cons name sym) (vector-ref env 0)))
    sym))

;; ---- library (unit) environment (change: module-artifacts-vertical-slice) ---
;; A compilation unit binds each top-level define to its PLAIN name (no
;; generation suffix); the emit unit qualifies it to @"L:x" at emission.  It
;; reuses the REPL env vector shape so the same repl-lower-form* group-load path
;; (register? #f) drives a library body, but with stable, readable symbols.
(define (unit-env-define! env name)
  (vector-set! env 0 (cons (cons name name) (vector-ref env 0)))
  name)
(define (unit-register-define! env form)
  (unit-env-define! env (car (normalize-define form))))

;; ---- typed binding resolution (change: module-resolution-scaffold) ----------
;; Free-identifier resolution classifies each resolved binding by KIND rather
;; than returning a bare target.  A binding is (binding <kind> <symbol>):
;;   local     -- the current unit's own top-level definition; emitted as a
;;                (global-ref sym) into that unit's slot (today's flat case).
;;   imported  -- another unit's export (Stage 1); also emitted as a
;;                (global-ref sym), which is referenced-but-not-defined in this
;;                unit and so flows through the existing REPL external-global hook
;;                (emit.ss `emit-repl-module`) as `external global i64`.  NOT
;;                produced by the resolver in this change -- structured and
;;                consumable, ready for Stage 1 to populate from imports.
;;   primitive -- a reserved primcall head (a raw %-op) OR an integrable left as its
;;                bare symbol by `scope-resolve`.  The resolver leaves the symbol in
;;                place; the post-rename `inline-primitives` pass then either inlines a
;;                direct integrable call to a bare primcall or eta-expands a value-use.
;;                (A shadowed integrable was alpha-renamed unique and resolves as a
;;                normal binding, so it never lands here.)
(define (make-binding kind sym) (list 'binding kind sym))
(define (binding-kind b) (cadr b))
(define (binding-sym b) (caddr b))

;; Classify a free identifier against the unit's scope, resolving the unit's own
;; top-level definitions (the REPL env) first, then imported bindings (none in
;; this change), then primitives; #f if unbound.  With no imports the results for
;; any library-free program are identical to the prior flat name->sym lookup.
(define (scope-resolve env name)
  (let ([s (repl-env-lookup env name)])
    (cond
      [s           (make-binding 'local s)]
      [(prim? name) (make-binding 'primitive name)]
      [(integrable? name) (make-binding 'primitive name)]  ; leave symbol; inline-primitives rewrites it
      [else #f])))

;; Post-rename resolution: a bare symbol that is not bound by an enclosing
;; lambda/let/letrec is a top-level reference.  Map each through the typed scope
;; to a (global-ref sym) via the REPL env, or raise an unbound-variable error --
;; a form may reference globals from earlier forms but never a later (undefined)
;; one, which is exactly normal REPL scoping.  Resolution tracks the bound locals
;; as it descends so renamed params (e.g. n.0) are left alone.
(define (resolve-globals e env)
  (define (R e bound)
    (define (Rb e) (R e bound))
    (match e
      [(const ,d) e]
      [(global-ref ,s) e]
      [(global-set! ,s ,rhs) `(global-set! ,s ,(Rb rhs))]
      [,x (guard (symbol? x))
          (if (memq x bound)
              x                                    ; a lexical local
              (let ([b (scope-resolve env x)])
                (cond
                  [(not b) (error 'repl "unbound variable" x)]
                  ;; local and imported both target a global slot; imported's slot
                  ;; is defined by another unit and resolves via external global.
                  [(eq? (binding-kind b) 'local)    `(global-ref ,(binding-sym b))]
                  [(eq? (binding-kind b) 'imported) `(global-ref ,(binding-sym b))]
                  ;; primitive: a raw %-op or an unshadowed integrable -- leave the
                  ;; symbol for inline-primitives to rewrite post-rename.
                  [else x])))]
      [(if ,a ,b ,c) `(if ,(Rb a) ,(Rb b) ,(Rb c))]
      [(seq ,a ,b) `(seq ,(Rb a) ,(Rb b))]
      [(set! ,x ,rhs) `(set! ,x ,(Rb rhs))]        ; x is a renamed local
      [(primcall ,op . ,args) `(primcall ,op ,@(map Rb args))]
      [(apply ,f . ,args) `(apply ,(Rb f) ,@(map Rb args))]
      [(call ,f . ,args) `(call ,(Rb f) ,@(map Rb args))]
      [(lambda ,params ,body)
       `(lambda ,params ,(R body (append (param-names params) bound)))]
      [(let ,binds ,body)                          ; rhs in the outer scope
       (let ([bound2 (append (map car binds) bound)])
         `(let ,(map (lambda (b) (list (car b) (Rb (cadr b)))) binds)
            ,(R body bound2)))]
      [(letrec ,binds ,body)                       ; rhs in the new (recursive) scope
       (let ([bound2 (append (map car binds) bound)])
         `(letrec ,(map (lambda (b) (list (car b) (R (cadr b) bound2))) binds)
            ,(R body bound2)))]))
  (R e '()))

;; Lower one entered top-level form (an s-expr) against the REPL env, returning
;; core IL for that form.  A `(define name init)` becomes a (global-set! sym ..)
;; whose value is the stored value; any other form is just its own expression.
;;
;; Generation timing mirrors batch `build-program`'s letrec-vs-let split: a
;; lambda definition registers its new symbol BEFORE its init is resolved, so a
;; self-reference recurses into the new binding; a value definition registers
;; AFTER, so its init sees the previous binding (e.g. (define x (+ x 1))).
;; register? #t (interactive): a define allocates a fresh generation, and a
;; value init is resolved BEFORE the new symbol exists (so it reads the previous
;; binding).  register? #f (group load, e.g. the prelude): the name was already
;; pre-registered by `repl-register-define!`, so its current symbol is reused and
;; all sibling names in the group are visible to every body -- letrec* semantics.
(define (repl-lower-form* env form register?)
  (define (prep sexp) (inline-primitives (resolve-globals (rename-program (parse-program sexp)) env)))
  (cond
    [(define-form? form)
     (let* ([nd   (normalize-define form)]
            [name (car nd)]
            [init (cadr nd)])
       (cond
         [(not register?) `(global-set! ,(repl-env-lookup env name) ,(prep init))]
         [(lambda-init? init)
          (let ([sym (repl-env-define! env name)]) `(global-set! ,sym ,(prep init)))]
         [else
          (let ([init-il (prep init)]) `(global-set! ,(repl-env-define! env name) ,init-il))]))]
    [(record-type-form? form)
     ;; a define-record-type introduces several mutually-visible persistent
     ;; globals (descriptor, constructor, predicate, accessors/mutators): register
     ;; every name first (letrec* group), then emit a core-IL `seq` chain of
     ;; group-load stores so the constructor lambda's descriptor reference resolves.
     ;; (A raw `begin` would bypass parse-body's begin->seq desugaring, so build the
     ;; seq chain directly over the already-prepped global-set! nodes.)
     (let ([binds (record-type-bindings form)])
       (for-each (lambda (b) (repl-env-define! env (car b))) binds)
       (let loop ([bs binds])
         (let ([node `(global-set! ,(repl-env-lookup env (car (car bs))) ,(prep (cadr (car bs))))])
           (if (null? (cdr bs)) node `(seq ,node ,(loop (cdr bs)))))))]
    [else (prep form)]))

(define (repl-lower-form env form) (repl-lower-form* env form #t))

;; Pre-register a define's name without lowering it (group-load phase 1), so a
;; group of mutually recursive top-level defines can all see one another.
(define (repl-register-define! env form)
  (repl-env-define! env (car (normalize-define form))))

;; ---- alpha-rename: make every bound variable globally unique ----
(define (rename-program e) (rename e '()))

(define (rename e env)               ; env: alist old -> new
  (define (look x) (let ([p (assq x env)]) (if p (cdr p) x)))
  (define (R e) (rename e env))
  (match e
    [(const ,d) e]
    [,x (guard (symbol? x)) (look x)]
    [(if ,a ,b ,c) `(if ,(R a) ,(R b) ,(R c))]
    [(seq ,a ,b) `(seq ,(R a) ,(R b))]
    [(set! ,x ,rhs) `(set! ,(look x) ,(R rhs))]
    [(primcall ,op . ,args) `(primcall ,op ,@(map R args))]
    [(apply ,f . ,args) `(apply ,(R f) ,@(map R args))]
    [(call ,f . ,args) `(call ,(R f) ,@(map R args))]
    [(lambda ,params ,body)                        ; params may be variadic
     (let* ([names (param-names params)]
            [new   (map fresh-name names)]
            [amap  (map cons names new)]
            [env2  (append amap env)]
            [nfixed (map (lambda (x) (cdr (assq x amap))) (param-fixed params))]
            [nrest  (let ([r (param-rest params)]) (and r (cdr (assq r amap))))])
       `(lambda ,(rebuild-params nfixed nrest) ,(rename body env2)))]
    [(let ,binds ,body)
     (let* ([xs (map car binds)]
            [es (map (lambda (b) (R (cadr b))) binds)]     ; rhs in outer env
            [new (map fresh-name xs)]
            [env2 (append (map cons xs new) env)])
       `(let ,(map list new es) ,(rename body env2)))]
    [(letrec ,binds ,body)
     (let* ([xs (map car binds)]
            [new (map fresh-name xs)]
            [env2 (append (map cons xs new) env)]
            [es (map (lambda (b) (rename (cadr b) env2)) binds)])  ; rhs in new env
       `(letrec ,(map list new es) ,(rename body env2)))]))

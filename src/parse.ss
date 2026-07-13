;;; parse.ss -- read source into the core IL, then alpha-rename.  (Included into
;;; compile.ss; assumes (match) and (util) are imported.)
;;;
;;; Core IL:
;;;   (const d) | x | (if e e e) | (lambda (x ...) e) | (call e e ...)
;;;   (primcall op e ...) | (let ([x e] ...) e) | (letrec ([x e] ...) e)
;;;   (seq e e) | (set! x e)
;;;
;;; Primitive names are reserved keywords (not rebindable) in the M1 subset.

(define *prims* '(+ - * = < cons car cdr null? pair? eq? eqv? equal? not
                  char->integer integer->char
                  string-length string-ref substring string->symbol
                  string=? string-append symbol->string list->string make-string
                  make-vector vector-ref vector-set! vector-length vector?))
(define (prim? op) (and (memq op *prims*) #t))

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
    [(symbol? e) e]
    [(pair? e)
     (match e
       [(quote ,d) `(const ,d)]
       [(if ,a ,b ,c) `(if ,(parse-expr a) ,(parse-expr b) ,(parse-expr c))]
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
    [else (error 'parse "bad expression" e)]))

(define (parse-bind b) (list (car b) (parse-expr (cadr b))))

(define (parse-body body)  ; non-empty list of source forms -> one core expr
  (let loop ([es (map parse-expr body)])
    (cond
      [(null? es) `(const ())]
      [(null? (cdr es)) (car es)]
      [else `(seq ,(car es) ,(loop (cdr es)))])))

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

;; Post-rename resolution: a bare symbol that is not bound by an enclosing
;; lambda/let/letrec is a top-level reference.  Map each to a (global-ref sym)
;; via the REPL env, or raise an unbound-variable error -- a form may reference
;; globals from earlier forms but never a later (undefined) one, which is
;; exactly normal REPL scoping.  Resolution tracks the bound locals as it
;; descends so renamed params (e.g. n.0) are left alone.
(define (resolve-globals e env)
  (define (R e bound)
    (define (Rb e) (R e bound))
    (match e
      [(const ,d) e]
      [(global-ref ,s) e]
      [(global-set! ,s ,rhs) `(global-set! ,s ,(Rb rhs))]
      [,x (guard (symbol? x))
          (if (memq x bound)
              x                                    ; a bound local
              (let ([s (repl-env-lookup env x)])
                (or (and s `(global-ref ,s))
                    (error 'repl "unbound variable" x))))]
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
  (define (prep sexp) (resolve-globals (rename-program (parse-program sexp)) env))
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

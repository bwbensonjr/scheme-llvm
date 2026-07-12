;;; parse.ss -- read source into the core IL, then alpha-rename.  (Included into
;;; compile.ss; assumes (match) and (util) are imported.)
;;;
;;; Core IL:
;;;   (const d) | x | (if e e e) | (lambda (x ...) e) | (call e e ...)
;;;   (primcall op e ...) | (let ([x e] ...) e) | (letrec ([x e] ...) e)
;;;   (seq e e) | (set! x e)
;;;
;;; Primitive names are reserved keywords (not rebindable) in the M1 subset.

(define *prims* '(+ - * = < cons car cdr null? pair? eq?))
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

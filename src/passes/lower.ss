;;; lower.ss (tasks 3.4 lambda-lift + 3.5 closure/allocation lowering)
;;;
;;; Hoists every lambda's code to a top-level definition and turns closures into
;;; explicit heap allocation.  Output "L-code":
;;;
;;;   (program (code-def ...) entry-expr)
;;;   code-def = (code label self (fixed ...) rest body)  ; self = closure ptr (arg0)
;;;             rest = a name (variadic callee) or #f (fixed arity)
;;;   expr =
;;;     (const d) | (local x) | (free-ref i)
;;;     (if e e e) | (seq e e) | (primcall op e ...) | (let ([x e] ...) e)
;;;     (make-closure label (cap ...))                 ; acyclic closure
;;;     (closure-block ([x label (cap ...)] ...) body) ; letrec group (two-phase)
;;;     (app f (arg ...))
;;;
;;; A variable reference becomes (local x) if bound in the current code, else
;;; (free-ref i) into the current closure's environment.

(define *code-defs* '())
(define (add-code! def) (set! *code-defs* (cons def *code-defs*)))

(define (lower-program e)
  (set! *code-defs* '())
  (let ([entry (lower e '() '())])          ; top level: no locals, no free vars
    `(program ,(reverse *code-defs*) ,entry)))

;; lower expr in a code context: locals = names bound here; fmap = var -> env index
(define (lower e locals fmap)
  (define (L x) (lower x locals fmap))
  (match e
    [(const ,d) `(const ,d)]
    [,x (guard (symbol? x))
        (cond
          [(memq x locals) `(local ,x)]
          [(assq x fmap) => (lambda (p) `(free-ref ,(cdr p)))]
          [else (error 'lower "unbound variable" x)])]
    [(if ,a ,b ,c) `(if ,(L a) ,(L b) ,(L c))]
    [(seq ,a ,b) `(seq ,(L a) ,(L b))]
    [(primcall ,op . ,args) `(primcall ,op ,@(map L args))]
    [(let ,binds ,body)
     (let ([xs (map car binds)]
           [es (map (lambda (b) (L (cadr b))) binds)])   ; rhs in current scope
       `(let ,(map list xs es) ,(lower body (append xs locals) fmap)))]
    [(lambda ,params ,body)                              ; standalone -> make-closure
     (let* ([fvs (free-vars e)]
            [label (fresh-label "code")])
       (hoist-code! label params body fvs)
       `(make-closure ,label ,(map (lambda (v) (lower v locals fmap)) fvs)))]
    [(closures ,cbinds ,body)                            ; letrec group -> closure-block
     (let* ([xs (map car cbinds)]
            [locals2 (append xs locals)]
            [entries
             (map (lambda (b)
                    (match (caddr b)
                      [(lambda ,params ,lbody)
                       (let ([fvs (free-vars (caddr b))]
                             [label (fresh-label "code")])
                         (hoist-code! label params lbody fvs)
                         ;; captures lowered in the group scope (siblings visible)
                         (list (car b) label
                               (map (lambda (v) (lower v locals2 fmap)) fvs)))]))
                  cbinds)])
       `(closure-block ,entries ,(lower body locals2 fmap)))]
    [(apply ,f . ,args) `(apply-app ,(L f) ,(map L args))]
    [(call ,f . ,args) `(app ,(L f) ,(map L args))]))

;; hoist a lambda body as a top-level code def; its body sees params (fixed +
;; rest) as locals and free vars via an index map matching the capture order.
;; The code def records the fixed params and the rest name (or #f) so emit can
;; build the rest list and arity-check.
(define (hoist-code! label params body fvs)
  (let* ([self (fresh-name 'cp)]
         [fmap (let loop ([fvs fvs] [i 0] [acc '()])
                 (if (null? fvs) (reverse acc)
                     (loop (cdr fvs) (+ i 1) (cons (cons (car fvs) i) acc))))]
         [lbody (lower body (param-names params) fmap)])
    (add-code! `(code ,label ,self ,(param-fixed params) ,(param-rest params) ,lbody))))

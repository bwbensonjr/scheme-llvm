;;; np-passes.ss -- the three probe passes written with nanopass.
;;;
;;;   recognize-let       L1 -> L2
;;;   convert-assignments L3 -> L4
;;;   convert-closures    L5 -> L6
;;;
;;; Distilled from Chez's np-recognize-let / np-convert-assignments /
;;; np-convert-closures in s/cpnanopass.ss, at this project's altitude.

(library (np-passes)
  (export np-recognize-let np-convert-assignments np-convert-closures)
  (import (chezscheme) (nanopass) (languages) (util))

  ;; ================================================================
  ;; recognize-let : (call (lambda (x ...) body) e ...) => (let ([x e] ...) body)
  ;; ================================================================
  (define-pass np-recognize-let : L1 (ir) -> L2 ()
    (Expr : Expr (ir) -> Expr ()
      [(call ,e0 ,[e1*] ...)
       (nanopass-case (L1 Expr) e0
         [(lambda (,x* ...) ,body)
          (guard (= (length x*) (length e1*)))
          `(let ([,x* ,e1*] ...) ,(Expr body))]
         [else `(call ,(Expr e0) ,e1* ...)])]))

  ;; ================================================================
  ;; convert-assignments : remove set! by boxing the assigned variables.
  ;;   ref x        => (unbox x)          [x assigned]
  ;;   (set! x e)   => (set-box! x e)
  ;;   binding of assigned x: rename to a temp, box it just inside the body
  ;; ================================================================
  (define-pass np-convert-assignments : L3 (ir) -> L4 ()
    (definitions
      ;; analysis: which variables are ever set!  (input is alpha-renamed)
      (define (find-assigned ir)
        (let ([acc '()])
          (define (walk e)
            (nanopass-case (L3 Expr) e
              [,x (void)]
              [(quote ,d) (void)]
              [(lambda (,x* ...) ,body) (walk body)]
              [(call ,e0 ,e1* ...) (walk e0) (for-each walk e1*)]
              [(if ,e0 ,e1 ,e2) (walk e0) (walk e1) (walk e2)]
              [(seq ,e0 ,e1) (walk e0) (walk e1)]
              [(set! ,x ,e) (set! acc (cons x acc)) (walk e)]
              [(let ([,x* ,e*] ...) ,body) (for-each walk e*) (walk body)]
              [(letrec ([,x* ,e*] ...) ,body) (for-each walk e*) (walk body)]))
          (walk ir)
          acc))
      (define assigned (find-assigned ir))
      (define (asgd? x) (and (memq x assigned) #t))
      ;; rebind: given binding vars and an already-converted body, rename the
      ;; assigned ones to temps and box them at the top of the body.
      (define (rebind x* body)
        (let loop ([x* x*] [nx* '()] [a* '()] [t* '()])
          (if (null? x*)
              (let ([nx* (reverse nx*)] [a* (reverse a*)] [t* (reverse t*)])
                (if (null? a*)
                    (values nx* body)
                    (values nx*
                      (with-output-language (L4 Expr)
                        `(let ([,a* (box ,t*)] ...) ,body)))))
              (let ([x (car x*)])
                (if (asgd? x)
                    (let ([t (fresh-tmp x)])
                      (loop (cdr x*) (cons t nx*) (cons x a*) (cons t t*)))
                    (loop (cdr x*) (cons x nx*) a* t*)))))))
    (Expr : Expr (ir) -> Expr ()
      [,x (if (asgd? x) `(unbox ,x) x)]
      [(set! ,x ,[e]) `(set-box! ,x ,e)]
      [(let ([,x* ,[e*]] ...) ,[body])
       (let-values ([(x* body) (rebind x* body)])
         `(let ([,x* ,e*] ...) ,body))]
      [(lambda (,x* ...) ,[body])
       (let-values ([(x* body) (rebind x* body)])
         `(lambda (,x* ...) ,body))]))

  ;; ================================================================
  ;; convert-closures : letrec of lambdas => closures form naming each
  ;; lambda's free variables explicitly.
  ;; ================================================================
  (define-pass np-convert-closures : L5 (ir) -> L6 ()
    (definitions
      (define (free-vars e)
        (nanopass-case (L5 Expr) e
          [,x (list x)]
          [(quote ,d) '()]
          [(lambda (,x* ...) ,body) (diff (free-vars body) x*)]
          [(call ,e0 ,e1* ...) (union (free-vars e0) (union* (map free-vars e1*)))]
          [(if ,e0 ,e1 ,e2) (union (free-vars e0) (union (free-vars e1) (free-vars e2)))]
          [(seq ,e0 ,e1) (union (free-vars e0) (free-vars e1))]
          [(box ,e) (free-vars e)]
          [(unbox ,e) (free-vars e)]
          [(set-box! ,e0 ,e1) (union (free-vars e0) (free-vars e1))]
          [(let ([,x* ,e*] ...) ,body)
           (union (union* (map free-vars e*)) (diff (free-vars body) x*))]
          [(letrec ([,x* ,e*] ...) ,body)
           (diff (union (union* (map free-vars e*)) (free-vars body)) x*)])))
    (Expr : Expr (ir) -> Expr ()
      [(letrec ([,x* ,le*] ...) ,[body])
       (let ([fv** (map free-vars le*)]
             [le*^ (map (lambda (le) (Expr le)) le*)])
         `(closures ([,x* (,fv** ...) ,le*^] ...) ,body))])))

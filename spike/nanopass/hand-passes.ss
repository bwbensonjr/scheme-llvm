;;; hand-passes.ss -- the same three probe passes, hand-rolled over plain
;;; s-expressions using Andy Keep's `match` (vendor/match.sls).
;;;
;;; The IR is just s-expressions in the same shape the nanopass unparsers emit,
;;; so outputs can be compared directly (see run.ss). No define-language: the
;;; "language" is the set of match clauses each pass chooses to handle.

(library (hand-passes)
  (export hand-recognize-let hand-convert-assignments hand-convert-closures)
  (import (chezscheme) (match) (util))

  ;; ================================================================
  ;; recognize-let
  ;; ================================================================
  (define (hand-recognize-let e)
    (define (rl e) (hand-recognize-let e))
    (match e
      [,x (guard (symbol? x)) x]
      [(quote ,d) `(quote ,d)]
      [(lambda (,x* ...) ,body) `(lambda ,x* ,(rl body))]
      [(if ,a ,b ,c) `(if ,(rl a) ,(rl b) ,(rl c))]
      [(seq ,a ,b) `(seq ,(rl a) ,(rl b))]
      [(set! ,x ,e) `(set! ,x ,(rl e))]
      [(letrec ([,x* ,le*] ...) ,body)
       `(letrec ,(map (lambda (x le) (list x (rl le))) x* le*) ,(rl body))]
      [(call (lambda (,x* ...) ,body) ,e* ...)
       (guard (= (length x*) (length e*)))
       `(let ,(map (lambda (x e) (list x (rl e))) x* e*) ,(rl body))]
      [(call ,e0 ,e* ...) `(call ,(rl e0) ,@(map rl e*))]))

  ;; ================================================================
  ;; convert-assignments
  ;; ================================================================
  (define (find-assigned e)
    (define (fa e) (find-assigned e))
    (match e
      [,x (guard (symbol? x)) '()]
      [(quote ,d) '()]
      [(lambda (,x* ...) ,body) (fa body)]
      [(if ,a ,b ,c) (union (fa a) (union (fa b) (fa c)))]
      [(seq ,a ,b) (union (fa a) (fa b))]
      [(set! ,x ,e) (union (list x) (fa e))]
      [(let ([,x* ,e*] ...) ,body) (union (union* (map fa e*)) (fa body))]
      [(letrec ([,x* ,le*] ...) ,body) (union (union* (map fa le*)) (fa body))]
      [(call ,e0 ,e* ...) (union (fa e0) (union* (map fa e*)))]))

  (define (hand-convert-assignments prog)
    (define assigned (find-assigned prog))
    (define (asgd? x) (and (memq x assigned) #t))
    ;; rename assigned binders to temps, box them at the top of the body
    (define (rebind x* body)
      (let loop ([x* x*] [nx* '()] [a* '()] [t* '()])
        (if (null? x*)
            (let ([nx* (reverse nx*)] [a* (reverse a*)] [t* (reverse t*)])
              (if (null? a*)
                  (values nx* body)
                  (values nx*
                    `(let ,(map (lambda (a t) (list a `(box ,t))) a* t*) ,body))))
            (let ([x (car x*)])
              (if (asgd? x)
                  (let ([t (fresh-tmp x)])
                    (loop (cdr x*) (cons t nx*) (cons x a*) (cons t t*)))
                  (loop (cdr x*) (cons x nx*) a* t*))))))
    (define (cvt e)
      (match e
        [,x (guard (symbol? x)) (if (asgd? x) `(unbox ,x) x)]
        [(quote ,d) `(quote ,d)]
        [(set! ,x ,e) `(set-box! ,x ,(cvt e))]
        [(lambda (,x* ...) ,body)
         (let-values ([(nx* body^) (rebind x* (cvt body))]) `(lambda ,nx* ,body^))]
        [(let ([,x* ,e*] ...) ,body)
         (let-values ([(nx* body^) (rebind x* (cvt body))])
           `(let ,(map list nx* (map cvt e*)) ,body^))]
        [(if ,a ,b ,c) `(if ,(cvt a) ,(cvt b) ,(cvt c))]
        [(seq ,a ,b) `(seq ,(cvt a) ,(cvt b))]
        [(letrec ([,x* ,le*] ...) ,body)
         `(letrec ,(map list x* (map cvt le*)) ,(cvt body))]
        [(call ,e0 ,e* ...) `(call ,(cvt e0) ,@(map cvt e*))]))
    (cvt prog))

  ;; ================================================================
  ;; convert-closures
  ;; ================================================================
  (define (free-vars e)
    (define (fv e) (free-vars e))
    (match e
      [,x (guard (symbol? x)) (list x)]
      [(quote ,d) '()]
      [(lambda (,x* ...) ,body) (diff (fv body) x*)]
      [(if ,a ,b ,c) (union (fv a) (union (fv b) (fv c)))]
      [(seq ,a ,b) (union (fv a) (fv b))]
      [(box ,e) (fv e)]
      [(unbox ,e) (fv e)]
      [(set-box! ,a ,b) (union (fv a) (fv b))]
      [(let ([,x* ,e*] ...) ,body) (union (union* (map fv e*)) (diff (fv body) x*))]
      [(letrec ([,x* ,le*] ...) ,body)
       (diff (union (union* (map fv le*)) (fv body)) x*)]
      [(call ,e0 ,e* ...) (union (fv e0) (union* (map fv e*)))]))

  (define (hand-convert-closures e)
    (define (cc e) (hand-convert-closures e))
    (match e
      [,x (guard (symbol? x)) x]
      [(quote ,d) `(quote ,d)]
      [(lambda (,x* ...) ,body) `(lambda ,x* ,(cc body))]
      [(if ,a ,b ,c) `(if ,(cc a) ,(cc b) ,(cc c))]
      [(seq ,a ,b) `(seq ,(cc a) ,(cc b))]
      [(box ,e) `(box ,(cc e))]
      [(unbox ,e) `(unbox ,(cc e))]
      [(set-box! ,a ,b) `(set-box! ,(cc a) ,(cc b))]
      [(let ([,x* ,e*] ...) ,body)
       `(let ,(map list x* (map cc e*)) ,(cc body))]
      [(letrec ([,x* ,le*] ...) ,body)
       `(closures ,(map (lambda (x le) (list x (free-vars le) (cc le))) x* le*)
                  ,(cc body))]
      [(call ,e0 ,e* ...) `(call ,(cc e0) ,@(map cc e*))])))

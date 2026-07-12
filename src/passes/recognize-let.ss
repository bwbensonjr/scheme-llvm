;;; recognize-let.ss (task 3.1) -- (call (lambda (x ...) body) e ...) => let.
;;; Promoted from spike/nanopass/hand-passes.ss, extended with const/primcall.

(define (recognize-let e)
  (define (rl e) (recognize-let e))
  (match e
    [(const ,d) e]
    [,x (guard (symbol? x)) x]
    [(if ,a ,b ,c) `(if ,(rl a) ,(rl b) ,(rl c))]
    [(seq ,a ,b) `(seq ,(rl a) ,(rl b))]
    [(set! ,x ,rhs) `(set! ,x ,(rl rhs))]
    [(primcall ,op . ,args) `(primcall ,op ,@(map rl args))]
    [(apply ,f . ,args) `(apply ,(rl f) ,@(map rl args))]
    [(lambda ,params ,body) `(lambda ,params ,(rl body))]
    [(let ,binds ,body)
     `(let ,(map (lambda (b) (list (car b) (rl (cadr b)))) binds) ,(rl body))]
    [(letrec ,binds ,body)
     `(letrec ,(map (lambda (b) (list (car b) (rl (cadr b)))) binds) ,(rl body))]
    [(call (lambda ,params ,body) . ,args)
     (guard (and (list? params) (= (length params) (length args))))  ; fixed arity only
     `(let ,(map (lambda (p a) (list p (rl a))) params args) ,(rl body))]
    [(call ,f . ,args) `(call ,(rl f) ,@(map rl args))]))

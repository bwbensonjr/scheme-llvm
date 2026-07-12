;;; convert-closures.ss (task 3.3) -- letrec of lambdas => closures form naming
;;; each lambda's free vars.  Standalone (non-letrec) lambdas are left as-is for
;;; lower to closure-convert.  free-vars is shared with lambda-lift/lower.

(define (free-vars e)
  (define (fv e) (free-vars e))
  (match e
    [(const ,d) '()]
    [,x (guard (symbol? x)) (list x)]
    [(if ,a ,b ,c) (union (fv a) (union (fv b) (fv c)))]
    [(seq ,a ,b) (union (fv a) (fv b))]
    [(primcall ,op . ,args) (union* (map fv args))]
    [(lambda ,params ,body) (diff (fv body) (param-names params))]
    [(let ,binds ,body)
     (union (union* (map (lambda (b) (fv (cadr b))) binds))
            (diff (fv body) (map car binds)))]
    [(letrec ,binds ,body)
     (diff (union (union* (map (lambda (b) (fv (cadr b))) binds)) (fv body))
           (map car binds))]
    [(closures ,cbinds ,body)
     (diff (union (union* (map (lambda (b) (fv (caddr b))) cbinds)) (fv body))
           (map car cbinds))]
    [(apply ,f . ,args) (union (fv f) (union* (map fv args)))]
    [(call ,f . ,args) (union (fv f) (union* (map fv args)))]))

(define (convert-closures e)
  (define (cc e) (convert-closures e))
  (match e
    [(const ,d) e]
    [,x (guard (symbol? x)) x]
    [(if ,a ,b ,c) `(if ,(cc a) ,(cc b) ,(cc c))]
    [(seq ,a ,b) `(seq ,(cc a) ,(cc b))]
    [(primcall ,op . ,args) `(primcall ,op ,@(map cc args))]
    [(lambda ,params ,body) `(lambda ,params ,(cc body))]
    [(let ,binds ,body)
     `(let ,(map (lambda (b) (list (car b) (cc (cadr b)))) binds) ,(cc body))]
    [(letrec ,binds ,body)
     `(closures ,(map (lambda (b) (list (car b) (free-vars (cadr b)) (cc (cadr b)))) binds)
                ,(cc body))]
    [(apply ,f . ,args) `(apply ,(cc f) ,@(map cc args))]
    [(call ,f . ,args) `(call ,(cc f) ,@(map cc args))]))

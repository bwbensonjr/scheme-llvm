;;; convert-assignments.ss (task 3.2) -- remove set! by boxing assigned vars.
;;;   ref x        => (primcall unbox x)      [x assigned]
;;;   (set! x e)   => (primcall set-box! x e)
;;;   binder of assigned x: rename to temp, (primcall box temp) just inside body
;;; Boxes are ordinary primcalls (rt_box/rt_unbox/rt_set_box), lowering to a
;;; dedicated 1-slot box object at runtime (design R2).
;;;
;;; M1 assumption: letrec-bound names are not set! (they are recursive
;;; functions), so only let/lambda binders are rebound.

(define (find-assigned e)
  (define (fa e) (find-assigned e))
  (match e
    [(const ,d) '()]
    [,x (guard (symbol? x)) '()]
    [(if ,a ,b ,c) (union (fa a) (union (fa b) (fa c)))]
    [(seq ,a ,b) (union (fa a) (fa b))]
    [(set! ,x ,rhs) (union (list x) (fa rhs))]
    [(global-ref ,s) '()]
    [(global-set! ,s ,rhs) (fa rhs)]
    [(primcall ,op . ,args) (union* (map fa args))]
    [(lambda ,params ,body) (fa body)]
    [(let ,binds ,body) (union (union* (map (lambda (b) (fa (cadr b))) binds)) (fa body))]
    [(letrec ,binds ,body) (union (union* (map (lambda (b) (fa (cadr b))) binds)) (fa body))]
    [(apply ,f . ,args) (union (fa f) (union* (map fa args)))]
    [(call ,f . ,args) (union (fa f) (union* (map fa args)))]))

(define (convert-assignments prog)
  (define assigned (find-assigned prog))
  (define (asgd? x) (mem? x assigned))
  ;; rename assigned binders to temps, box them at the top of the (converted) body
  (define (rebind xs body)
    (let loop ([xs xs] [nx '()] [as '()] [ts '()])
      (if (null? xs)
          (let ([nx (reverse nx)] [as (reverse as)] [ts (reverse ts)])
            (if (null? as)
                (values nx body)
                (values nx
                  `(let ,(map (lambda (a t) (list a `(primcall box ,t))) as ts) ,body))))
          (let ([x (car xs)])
            (if (asgd? x)
                (let ([t (fresh-name x)]) (loop (cdr xs) (cons t nx) (cons x as) (cons t ts)))
                (loop (cdr xs) (cons x nx) as ts))))))
  (define (cvt e)
    (match e
      [(const ,d) e]
      [,x (guard (symbol? x)) (if (asgd? x) `(primcall unbox ,x) x)]
      [(global-ref ,s) e]
      [(global-set! ,s ,rhs) `(global-set! ,s ,(cvt rhs))]
      [(set! ,x ,rhs) `(primcall set-box! ,x ,(cvt rhs))]
      [(if ,a ,b ,c) `(if ,(cvt a) ,(cvt b) ,(cvt c))]
      [(seq ,a ,b) `(seq ,(cvt a) ,(cvt b))]
      [(primcall ,op . ,args) `(primcall ,op ,@(map cvt args))]
      [(lambda ,params ,body)                    ; params may be variadic
       (let ([rest (param-rest params)])
         (let-values ([(nx body^) (rebind (param-names params) (cvt body))])
           (if rest
               (let ([nrest  (list-ref nx (- (length nx) 1))]
                     [nfixed (list-head nx (- (length nx) 1))])
                 `(lambda ,(rebuild-params nfixed nrest) ,body^))
               `(lambda ,nx ,body^))))]
      [(let ,binds ,body)
       (let ([xs (map car binds)] [es (map (lambda (b) (cvt (cadr b))) binds)])
         (let-values ([(nx body^) (rebind xs (cvt body))])
           `(let ,(map list nx es) ,body^)))]
      [(letrec ,binds ,body)
       `(letrec ,(map (lambda (b) (list (car b) (cvt (cadr b)))) binds) ,(cvt body))]
      [(apply ,f . ,args) `(apply ,(cvt f) ,@(map cvt args))]
      [(call ,f . ,args) `(call ,(cvt f) ,@(map cvt args))]))
  (cvt prog))

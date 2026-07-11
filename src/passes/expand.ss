;;; expand.ss -- source->source expansion of derived forms into core forms.
;;; Runs after collect-toplevel and before parse.  A deliberate rehearsal for
;;; the eventual syntax-rules expander: each derived form has one fixed rewrite
;;; into the core language (if / let / letrec / begin / application).
;;;
;;;   (cond [t b...] ... [else e...]) -> nested if / begin
;;;   (and e ...) (or e ...)          -> short-circuit if chains (or binds a temp)
;;;   (when t b...) (unless t b...)   -> if + begin
;;;   (let* ([x e]...) b...)          -> nested let
;;;   (let name ([x e]...) b...)      -> letrec + immediate call
;;;
;;; quoted data is left untouched; every other subform is recursed into so
;;; derived forms nest freely.  Fresh names (for `or`) come from the shared
;;; rename counter, reset per program.

(define (expand e)
  (if (not (pair? e))
      e                                    ; atoms, symbols, literals: unchanged
      (case (car e)
        [(quote)  e]                        ; do not descend into quoted data
        [(cond)   (expand-cond (cdr e))]
        [(and)    (expand-and (cdr e))]
        [(or)     (expand-or (cdr e))]
        [(when)   (expand-when (cadr e) (cddr e))]
        [(unless) (expand-unless (cadr e) (cddr e))]
        [(let*)   (expand-let* (cadr e) (cddr e))]
        [(let)    (if (symbol? (cadr e))    ; named let
                      (expand-named-let (cadr e) (caddr e) (cdddr e))
                      (expand-let-form 'let (cadr e) (cddr e)))]
        [(letrec) (expand-let-form 'letrec (cadr e) (cddr e))]
        [(lambda) `(lambda ,(cadr e) ,@(map expand (cddr e)))]
        ;; if / begin / set! / primcall / application: recurse into every
        ;; position (operators and operands, never binding lists).
        [else     (map expand e)])))

(define (expand-cond clauses)
  (if (null? clauses)
      #f
      (let ([cl (car clauses)])
        (cond
          [(eq? (car cl) 'else)
           `(begin ,@(map expand (cdr cl)))]
          [(null? (cdr cl))
           (error 'expand "cond bare-test clause not supported yet" cl)]
          [(eq? (cadr cl) '=>)
           (error 'expand "cond => clause not supported yet" cl)]
          [else
           `(if ,(expand (car cl))
                (begin ,@(map expand (cdr cl)))
                ,(expand-cond (cdr clauses)))]))))

(define (expand-and args)
  (cond
    [(null? args) #t]
    [(null? (cdr args)) (expand (car args))]
    [else `(if ,(expand (car args)) ,(expand-and (cdr args)) #f)]))

(define (expand-or args)
  (cond
    [(null? args) #f]
    [(null? (cdr args)) (expand (car args))]
    [else
     (let ([t (fresh-name 'or)])
       `(let ([,t ,(expand (car args))])
          (if ,t ,t ,(expand-or (cdr args)))))]))

(define (expand-when test body)
  `(if ,(expand test) (begin ,@(map expand body)) #f))

(define (expand-unless test body)
  `(if ,(expand test) #f (begin ,@(map expand body))))

(define (expand-let* binds body)
  (if (null? binds)
      `(begin ,@(map expand body))
      (let ([b (car binds)])
        `(let ([,(car b) ,(expand (cadr b))])
           ,(expand-let* (cdr binds) body)))))

(define (expand-let-form head binds body)
  `(,head ,(map (lambda (b) (list (car b) (expand (cadr b)))) binds)
          ,@(map expand body)))

(define (expand-named-let name binds body)
  `(letrec ([,name (lambda ,(map car binds) ,@(map expand body))])
     (,name ,@(map (lambda (b) (expand (cadr b))) binds))))

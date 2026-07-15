;;; match.scm -- the `match` pattern matcher, flattened out of match.sls (change:
;;; self-hosting-completion).  Identical semantics to the library version, but as
;;; bare top-level `define-syntax`es so the source concatenates with no Chez
;;; assembler.  The two helper macros are renamed `%match-pat`/`%match-clauses`
;;; (baking the old assembler's rename) because flattening exposes them at the top
;;; level, where the bare name `match-pat` would collide with the `match-pat`
;;; *function* in src/passes/expand.ss.

;; (%match-pat PAT SUBJ SK FK): expand to code that matches SUBJ against PAT,
;; evaluating SK on success (with PAT's binders in scope) and FK on failure.
;; `unquote` is a literal so `,id` is detected.
(define-syntax %match-pat
  (syntax-rules (unquote)
    ((_ (unquote v) subj sk fk) (let ((v subj)) sk))
    ((_ () subj sk fk) (if (null? subj) sk fk))
    ((_ (pa . pd) subj sk fk)
     (if (pair? subj)
         (let ((h (car subj)) (t (cdr subj)))
           (%match-pat pa h (%match-pat pd t sk fk) fk))
         fk))
    ((_ lit subj sk fk) (if (eq? (quote lit) subj) sk fk))))

;; Try clauses in order.  Each clause's "try the next clause" continuation is a
;; thunk (fk), so clause bodies are shared, not duplicated across the pattern.
(define-syntax %match-clauses
  (syntax-rules (else guard)
    ((_ subj) (error 'match "no matching clause" subj))
    ((_ subj (else body0 body ...)) (begin body0 body ...))
    ((_ subj (pat (guard g0 g ...) body0 body ...) clause ...)
     (let ((fk (lambda () (%match-clauses subj clause ...))))
       (%match-pat pat subj
         (if (and g0 g ...) (begin body0 body ...) (fk))
         (fk))))
    ((_ subj (pat body0 body ...) clause ...)
     (let ((fk (lambda () (%match-clauses subj clause ...))))
       (%match-pat pat subj (begin body0 body ...) (fk))))))

(define-syntax match
  (syntax-rules ()
    ((_ e clause ...)
     (let ((subj e)) (%match-clauses subj clause ...)))))

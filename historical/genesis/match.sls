;;; match.sls -- a `syntax-rules`-only pattern matcher in the nanopass `,x`
;;; convention, replacing the previous `syntax-case` matcher (change:
;;; port-match-to-syntax-rules).  Written in plain `syntax-rules` so the same
;;; matcher the host build uses can also be expanded by scheme-llvm's own
;;; expander -- a step toward self-hosting (the old matcher's `syntax-case`
;;; dependency was the single largest blocker).
;;;
;;; Surface (the subset the compiler passes use):
;;;   (match EXPR clause ...)
;;;   clause => [PAT (guard G ...) BODY ...] | [PAT BODY ...] | [else BODY ...]
;;;   PAT    => ,id            -- binds id to the sub-value
;;;           | ()             -- matches the empty list
;;;           | (PAT . PAT)    -- matches a pair (dotted-rest falls out of ,rest)
;;;           | sym / datum    -- literal, matched with eq?
;;;
;;; NOT supported (deliberately deferred): ellipsis `(p ...)` / `(p ... . t)`,
;;; catamorphism `,[...]`, and the `_` wildcard.  Ellipsis is a follow-up change
;;; (it needs the expander to detect `...` in patterns via a custom ellipsis
;;; identifier; the current passes use no ellipsis patterns).

(library (match)
  (export match)
  (import (rnrs))

  ;; (match-pat PAT SUBJ SK FK): expand to code that matches SUBJ against PAT,
  ;; evaluating the expression SK on success (with PAT's binders in scope) and
  ;; the expression FK on failure.  `unquote` is a literal so `,id` is detected.
  (define-syntax match-pat
    (syntax-rules (unquote)
      ((_ (unquote v) subj sk fk) (let ((v subj)) sk))
      ((_ () subj sk fk) (if (null? subj) sk fk))
      ((_ (pa . pd) subj sk fk)
       (if (pair? subj)
           (let ((h (car subj)) (t (cdr subj)))
             (match-pat pa h (match-pat pd t sk fk) fk))
           fk))
      ((_ lit subj sk fk) (if (eq? (quote lit) subj) sk fk))))

  ;; Try clauses in order.  Each clause's "try the next clause" continuation is a
  ;; thunk (fk), so clause bodies are shared, not duplicated across the pattern.
  (define-syntax match-clauses
    (syntax-rules (else guard)
      ((_ subj) (error 'match "no matching clause" subj))
      ((_ subj (else body0 body ...)) (begin body0 body ...))
      ((_ subj (pat (guard g0 g ...) body0 body ...) clause ...)
       (let ((fk (lambda () (match-clauses subj clause ...))))
         (match-pat pat subj
           (if (and g0 g ...) (begin body0 body ...) (fk))
           (fk))))
      ((_ subj (pat body0 body ...) clause ...)
       (let ((fk (lambda () (match-clauses subj clause ...))))
         (match-pat pat subj (begin body0 body ...) (fk))))))

  (define-syntax match
    (syntax-rules ()
      ((_ e clause ...)
       (let ((subj e)) (match-clauses subj clause ...))))))

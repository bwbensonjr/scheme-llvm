;;; util.ss -- generic list-as-set helpers, shared by both the nanopass and
;;; hand-rolled sides so the comparison is about the framework, not about
;;; re-deriving set operations twice. Deterministic order (stable, no sorting).

(library (util)
  (export union union* diff fresh-tmp)
  (import (chezscheme))

  ;; order-preserving union: keep a's order, append b's new elements
  (define (union a b)
    (let loop ([b b] [acc (reverse a)])
      (cond
        [(null? b) (reverse acc)]
        [(memq (car b) acc) (loop (cdr b) acc)]
        [else (loop (cdr b) (cons (car b) acc))])))

  (define (union* ls) (fold-left union '() ls))

  (define (diff a b) (filter (lambda (x) (not (memq x b))) a))

  ;; deterministic fresh temp derived from a (unique) source name
  (define (fresh-tmp x)
    (string->symbol (string-append (symbol->string x) ".t"))))

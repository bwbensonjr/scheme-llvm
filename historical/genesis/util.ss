;;; util.ss -- generic helpers shared across passes (copied from the spike and
;;; extended with deterministic fresh-name generation).

(library (util)
  (export union union* diff mem?
          reset-counter! fresh-name fresh-label)
  (import (chezscheme))

  ;; order-preserving set ops (lists as sets)
  (define (union a b)
    (let loop ([b b] [acc (reverse a)])
      (cond
        [(null? b) (reverse acc)]
        [(memq (car b) acc) (loop (cdr b) acc)]
        [else (loop (cdr b) (cons (car b) acc))])))
  (define (union* ls) (fold-left union '() ls))
  (define (diff a b) (filter (lambda (x) (not (memq x b))) a))
  (define (mem? x s) (and (memq x s) #t))

  ;; deterministic gensym: a monotonic counter, reset per compile so output
  ;; (renamed IL, .ll labels) is stable and readable.
  (define counter 0)
  (define (reset-counter!) (set! counter 0))
  (define (next!) (let ([n counter]) (set! counter (+ n 1)) n))
  ;; fresh variable, e.g. (fresh-name 'x) => x.7
  (define (fresh-name base)
    (string->symbol
      (string-append (symbol->string base) "." (number->string (next!)))))
  ;; fresh code label string, e.g. (fresh-label "code") => "code_3"
  (define (fresh-label base)
    (string-append base "_" (number->string (next!)))))

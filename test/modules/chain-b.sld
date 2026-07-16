;;; chain-b.sld -- transitive-chain leaf (change: module-generalize).
;;; A base library imported (transitively) by a program through chain-a.
(define-library (chain-b)
  (export base-val)
  (begin
    (define (base-val) 10)))

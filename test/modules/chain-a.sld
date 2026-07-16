;;; chain-a.sld -- transitive-chain middle (change: module-generalize).
;;; A library that itself imports another library (chain-b) and uses its export.
(define-library (chain-a)
  (import (chain-b))
  (export a-plus)
  (begin
    ;; base-val is an IMPORTED binding, emitted as an external global @"chain.b:base-val".
    (define (a-plus) (+ (base-val) 5))))    ; 10 + 5 = 15

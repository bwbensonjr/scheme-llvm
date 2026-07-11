;;; run.ss -- drive both sides of each pass on the shared inputs and check the
;;; nanopass output (unparsed to s-exprs) equals the hand-rolled output.
;;;
;;; Usage:  chez --libdirs ".:vendor:vendor/nanopass" --script run.ss

(import (chezscheme)
        (languages) (np-passes) (hand-passes) (tests))

(define fail-count 0)
(define test-count 0)

(define (check name input np-out hand-out)
  (set! test-count (+ test-count 1))
  (let ([ok (equal? np-out hand-out)])
    (unless ok (set! fail-count (+ fail-count 1)))
    (printf "  [~a] ~a\n" (if ok "OK  " "FAIL") name)
    (printf "        in : ~s\n" input)
    (printf "        np : ~s\n" np-out)
    (unless ok (printf "        hnd: ~s   <-- MISMATCH\n" hand-out))))

(define (run-pass title inputs np-fn hand-fn)
  (printf "~a\n" title)
  (for-each
    (lambda (in) (check title in (np-fn in) (hand-fn in)))
    inputs)
  (newline))

(run-pass "recognize-let  (L1 -> L2)"
  rl-tests
  (lambda (in) (unparse-L2 (np-recognize-let (parse-L1 in))))
  hand-recognize-let)

(run-pass "convert-assignments  (L3 -> L4)"
  ca-tests
  (lambda (in) (unparse-L4 (np-convert-assignments (parse-L3 in))))
  hand-convert-assignments)

(run-pass "convert-closures  (L5 -> L6)"
  cc-tests
  (lambda (in) (unparse-L6 (np-convert-closures (parse-L5 in))))
  hand-convert-closures)

(printf "==================================================\n")
(printf "~a/~a agree; ~a mismatch(es)\n"
        (- test-count fail-count) test-count fail-count)
(exit (if (= fail-count 0) 0 1))

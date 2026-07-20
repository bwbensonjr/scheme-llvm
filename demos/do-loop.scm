;;; do-loop.scm -- the R7RS `do` iteration macro: parallel-updated bindings, a
;;; test/result clause, a body command, and a no-step binding (change:
;;; inexact-numbers).  Builds a list of three results.
(list
 ;; sum 0..4 via two parallel-updated bindings
 (do ((i 0 (+ i 1)) (acc 0 (+ acc i))) ((= i 5) acc))
 ;; a no-step binding (n stays 5) used as the loop bound
 (do ((i 0 (+ i 1)) (n 5)) ((= i n) i))
 ;; count iterations with a body command for effect
 (do ((i 0 (+ i 1)) (c 0 (+ c 1))) ((= i 4) c) (+ i 0)))

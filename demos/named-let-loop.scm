; named-let tail loop: 10M iterations, must run in bounded stack (musttail).
; Exercises the (let name (binds) body) -> letrec + call expansion in tail position.
(let loop ([n 10000000])
  (if (= n 0) 42 (loop (- n 1))))

;;; assemble-sanity.ss -- verify build/core-self.scm behaves like the real core.
;;;
;;; Change: self-host-gap-sweep, task 1.2.  Loads the assembled single-file core
;;; under Chez and checks that its `compile-source-string` emits byte-identical IR
;;; to the reference core (src/compile.ss --emit-ir --no-prelude) for a spread of
;;; sample programs.  The self-hostable core reads with the prelude's in-language
;;; `read-all-from-string`, which does not exist under bare Chez, so we supply a
;;; native-reader equivalent (Chez `read` over a string port) before loading.
;;;
;;; Run from the repo root (after tools/assemble-core.ss):
;;;   chez --libdirs src --script tools/assemble-sanity.ss

(import (chezscheme))

;; Native stand-in for the prelude's whole-program reader: all top-level forms of
;; the source string, in order.  Same contract as read-all-from-string.
(define (read-all-from-string s)
  (let ([p (open-input-string s)])
    (let loop ([acc '()])
      (let ([f (read p)])
        (if (eof-object? f) (reverse acc) (loop (cons f acc)))))))

;; `include` (not `load`): the assembled core is spliced into one top-level body,
;; exactly as `src/compile.ss` includes `src/core.ss`.  That gives letrec*
;; semantics -- forward references (e.g. `rename-program` -> `rename`) resolve and
;; the core's defines shadow Chez's aux keywords.  `load` would evaluate form by
;; form and choke on both.  Resolved relative to the current directory, so run
;; this from the repo root.
(include "build/core-self.scm")   ; defines compile-source-string (+ the whole core)

;; Reference: the real core as a subprocess, prelude-less IR on stdout.
(define (reference-ir src)
  (let-values ([(to from pid)
                (values #f #f #f)])
    (let* ([pipes (process "chez --libdirs src --script src/compile.ss --emit-ir --no-prelude")]
           [from (car pipes)] [to (cadr pipes)])
      (put-string to src)
      (close-port to)
      (let loop ([acc '()])
        (let ([ln (get-line from)])
          (if (eof-object? ln)
              (begin (close-port from)
                     (apply string-append (reverse acc)))
              (loop (cons (string-append ln "\n") acc))))))))

(define samples
  (list
    "(+ 1 2)"
    "(let ([x 1] [y 2]) (+ x y))"
    "((lambda (x) (* x x)) 5)"
    "(if (< 1 2) (cons 1 (quote ())) 0)"
    "(define (fact n) (if (= n 0) 1 (* n (fact (- n 1))))) (fact 5)"
    "(define (map1 f xs) (if (null? xs) (quote ()) (cons (f (car xs)) (map1 f (cdr xs))))) (map1 (lambda (x) (+ x 1)) (cons 1 (cons 2 (quote ()))))"))

(define failures 0)
(for-each
  (lambda (src)
    (let ([got (compile-source-string src)]
          [ref (reference-ir src)])
      ;; compile-source-string returns IR without the target header; reference-ir
      ;; strips it too? No -- --emit-ir emits pure core IR (no header), same as
      ;; compile-source-string.  Compare directly.
      (if (string=? got ref)
          (printf "  [OK]   ~a\n" src)
          (begin
            (set! failures (+ failures 1))
            (printf "  [DIFF] ~a\n" src)
            (printf "    --- assembled (~a bytes) vs reference (~a bytes) ---\n"
                    (string-length got) (string-length ref))))))
  samples)

(newline)
(if (zero? failures)
    (printf "sanity OK: assembled core matches the reference on ~a samples\n"
            (length samples))
    (begin (printf "~a sample(s) differ\n" failures) (exit 1)))

;;; mangle-tests.ss -- unit tests for the module-qualified symbol namer
;;; (src/util.scm `mangle`, change: module-resolution-scaffold).
;;; Run from the repo root:  chez --script test/mangle-tests.ss
;;;
;;; `mangle` fixes the export ABI: for library (p1 ... pn) and internal name x it
;;; returns "p1.....pn:x", and for the empty-prefix PROGRAM unit it round-trips
;;; the internal name unchanged (the property the byte-identity guarantee rests
;;; on).  It is a pure function -- no counter/order dependence.

(import (chezscheme))
(include "src/match.scm")           ; flat source (change: self-hosting-completion)
(include "src/util.scm")

(define pass 0)
(define fail 0)
(define (check name got want)
  (if (equal? got want)
      (begin (set! pass (+ pass 1)) (printf "  [OK  ] ~a\n" name))
      (begin (set! fail (+ fail 1))
             (printf "  [FAIL] ~a\n         got:  ~s\n         want: ~s\n" name got want))))

(printf "mangle unit tests\n")

;; the canonical example from the spec
(check "library name maps to canonical symbol"
       (mangle '(scheme base) 'map) "scheme.base:map")

;; empty (program) prefix round-trips the internal name unchanged
(check "empty prefix round-trips a symbol"
       (mangle program-unit 'x) "x")
(check "empty prefix round-trips a code label string"
       (mangle program-unit "code_7") "code_7")
(check "empty prefix leaves a punctuation-bearing name unchanged"
       (mangle '() 'string->symbol) "string->symbol")

;; single-part and multi-part prefixes
(check "single-part library prefix"
       (mangle '(foo) 'bar) "foo:bar")
(check "three-part library prefix"
       (mangle '(a b c) 'x) "a.b.c:x")

;; purity: same (library, name) pair always yields the same symbol
(check "same input yields same symbol"
       (equal? (mangle '(scheme base) 'map) (mangle '(scheme base) 'map)) #t)

;; internal name may be given as a string as well as a symbol
(check "string internal name under a prefix"
       (mangle '(scheme base) "map") "scheme.base:map")

(printf "\n  ~a passed, ~a failed\n" pass fail)
(exit (if (= fail 0) 0 1))

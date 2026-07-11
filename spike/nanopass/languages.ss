;;; languages.ss -- minimal nanopass intermediate languages for the spike.
;;;
;;; A distilled subset of Chez's L1..L6 (s/np-languages.ss), just enough to
;;; carry the three probe passes:
;;;
;;;   L1 -> L2   recognize-let       (call of a lambda  =>  let)
;;;   L3 -> L4   convert-assignments  (remove set! via boxing)
;;;   L5 -> L6   convert-closures     (letrec  =>  closures with explicit free vars)
;;;
;;; Simplifications vs. real Chez, all in service of "as simple as possible":
;;;   - `lambda` directly, no case-lambda / clause / arity-interface machinery
;;;   - variables assumed alpha-renamed (globally unique), so "assigned?" and
;;;     "free var" are simple set computations
;;;   - boxing modeled with explicit (box e)/(unbox e)/(set-box! e0 e1) forms
;;;     rather than Chez's cons/car/set-car! primcalls (clearer to read)
;;;   - no profiling, mvlet, loop, foreign, attachments

(library (languages)
  (export L1 L2 L3 L4 L5 L6
          parse-L1 parse-L3 parse-L5
          unparse-L1 unparse-L2 unparse-L3 unparse-L4 unparse-L5 unparse-L6
          datum?)
  (import (chezscheme) (nanopass))

  (define (datum? x)
    (or (number? x) (boolean? x) (null? x) (string? x) (char? x)))

  ;; ---- L1: core, with lambda as a first-class Expr (so a call of a lambda
  ;;         is expressible, which is what recognize-let looks for) ----
  (define-language L1
    (terminals
      (symbol (x))
      (datum (d)))
    (entry Expr)
    (Expr (e body le)
      x
      (quote d)
      (lambda (x* ...) body)
      (call e0 e1* ...)
      (if e0 e1 e2)
      (seq e0 e1)
      (set! x e)
      (letrec ([x* le*] ...) body)))

  ;; ---- L2: + let (the output of recognize-let) ----
  (define-language L2 (extends L1)
    (Expr (e body le)
      (+ (let ([x* e*] ...) body))))

  ;; ---- L3: convert-assignments input (Chez removes `moi` here; we have none,
  ;;         so L3 is L2 unchanged). Same surface as L2, incl. set! and let. ----
  (define-language L3 (extends L2))

  ;; ---- L4: - set!, + explicit boxes (the output of convert-assignments) ----
  (define-language L4 (extends L3)
    (Expr (e body le)
      (- (set! x e))
      (+ (box e)
         (unbox e)
         (set-box! e0 e1))))

  ;; ---- L5: convert-closures input. Post-assignment-conversion surface
  ;;         (no set!); L5 == L4 here. ----
  (define-language L5 (extends L4))

  ;; ---- L6: - letrec, + closures (each binding names its free vars). Mirrors
  ;;         Chez L6's `(closures ([x* (x** ...) le*] ...) body)`. ----
  (define-language L6 (extends L5)
    (Expr (e body le)
      (- (letrec ([x* le*] ...) body))
      (+ (closures ([x* (x** ...) le*] ...) body))))

  (define-parser parse-L1 L1)
  (define-parser parse-L3 L3)
  (define-parser parse-L5 L5))

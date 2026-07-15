;;; util.scm -- generic helpers shared across passes, flattened out of util.ss
;;; (change: self-hosting-completion).  Bare top-level `define`s, no `(library ...)`
;;; wrapper, so the source concatenates with no Chez assembler.

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
  (string-append base "_" (number->string (next!))))

;; ---- module-qualified symbol naming (change: module-resolution-scaffold) ----
;; A compilation unit's own emitted symbols -- top-level globals and lifted
;; code-block labels -- are named through `mangle`, a PURE function of the unit's
;; library name and the internal name, with no dependence on compile order or the
;; gensym counter.  For a library named (p1 p2 ... pn) and internal name x it
;; returns "p1.p2.....pn:x" (parts joined by ".", then ":", then the name).
;;
;; The PROGRAM (non-library) unit is the empty-prefix unit `program-unit`; for it
;; `mangle` returns the internal name UNCHANGED, so a library-free program's
;; emitted symbols are byte-identical to before this scaffolding.  Stage 1 passes
;; a real library name to get "scheme.base:map" and the like.
(define program-unit '())                 ; the empty-prefix (non-library) unit

(define (mangle library-name internal-name)
  (let ([x (if (symbol? internal-name)
               (symbol->string internal-name)
               internal-name)])
    (if (null? library-name)
        x                                  ; empty prefix: round-trip unchanged
        (let loop ([parts (cdr library-name)]
                   [acc   (symbol->string (car library-name))])
          (if (null? parts)
              (string-append acc ":" x)
              (loop (cdr parts)
                    (string-append acc "." (symbol->string (car parts)))))))))

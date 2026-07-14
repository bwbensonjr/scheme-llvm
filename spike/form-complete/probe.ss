;;; probe.ss -- spike for the in-language `form-complete?` probe (change:
;;; repl-embedded-incremental, task 1.1 / design D4).
;;;
;;; QUESTION: can the interactive host hand `compile-one-form` exactly one
;;; complete form per iteration by asking a compiled probe "does this buffer
;;; start with a complete datum yet?", reusing the in-language reader's lexical
;;; rules (strings, `;` comments, `#\` char literals, `[...]` brackets)?
;;;
;;; FINDING (see RESULTS.md): the reader we ship (`rd-datum`/`rd-list` in
;;; src/prelude.scm) CANNOT answer this directly -- `rd-list` treats end-of-input
;;; as end-of-list, so `(+ 1` silently reads as `(+ 1)`.  It never signals
;;; "incomplete".  So the probe is a *separate* EOF-aware scanner that mirrors the
;;; same lexical rules but reports incomplete/malformed instead of guessing.  It
;;; reuses the reader's delimiter/whitespace helpers verbatim, so the two lexers
;;; cannot drift on what a delimiter or a comment is.
;;;
;;; This file is self-contained (spike style): it copies just the small
;;; reader-lexeme helpers it depends on (`rd-ws?`/`rd-delim?`/`rd-skip-*`/
;;; `rd-token-end`, byte-for-byte from src/prelude.scm) plus the new scanner, and
;;; a test driver.  Run:  chez --script spike/form-complete/probe.ss
;;;
;;; Everything here stays inside the scheme-llvm compiled subset (only
;;; char->integer, string-ref/length, +, -, <, =, cons, and the copied helpers),
;;; so the scanner ports verbatim into the core for task 3.1.

;; ---- reader lexeme helpers (verbatim from src/prelude.scm) ----------------
(define (rd-ws? c)
  (let ([k (char->integer c)])
    (or (= k 32) (or (= k 9) (or (= k 10) (= k 13))))))
(define (rd-delim? c)
  (let ([k (char->integer c)])
    (or (rd-ws? c)
        (or (= k 40) (or (= k 41) (or (= k 91) (or (= k 93)
        (or (= k 34) (= k 59)))))))))
(define (rd-skip-line s n i)
  (if (< i n)
      (if (= (char->integer (string-ref s i)) 10) (+ i 1) (rd-skip-line s n (+ i 1)))
      i))
(define (rd-skip-ws s n i)
  (if (< i n)
      (let ([c (string-ref s i)])
        (cond
          [(rd-ws? c) (rd-skip-ws s n (+ i 1))]
          [(= (char->integer c) 59) (rd-skip-ws s n (rd-skip-line s n (+ i 1)))]
          [else i]))
      i))
(define (rd-token-end s n i)
  (if (< i n)
      (if (rd-delim? (string-ref s i)) i (rd-token-end s n (+ i 1)))
      i))

;; ---- the completeness probe ----------------------------------------------
;; A datum-scanner that returns the index just past the first complete datum, or
;; a negative sentinel: -1 incomplete (need more input), -2 malformed (a clear
;; error, e.g. a close paren with nothing open).  It does NOT build the datum --
;; the real reader does that once the host knows the form is whole.
(define fc-incomplete -1)
(define fc-malformed -2)
(define (fc-bad? r) (< r 0))

;; scan a "..." string starting just past the opening quote; -1 if unterminated.
(define (fc-string s n i)
  (if (< i n)
      (let ([k (char->integer (string-ref s i))])
        (cond
          [(= k 34) (+ i 1)]                                   ; closing "
          [(= k 92) (if (< (+ i 1) n) (fc-string s n (+ i 2)) ; \escape needs a char
                        fc-incomplete)]
          [else (fc-string s n (+ i 1))]))
      fc-incomplete))                                          ; EOF inside string

;; scan a #\ char literal; content char is at i (just past #\).  Force the first
;; content char in even if it is itself a delimiter (#\( #\) #\;), then run to the
;; next delimiter -- exactly what rd-char does.
(define (fc-char s n i)
  (if (< i n) (rd-token-end s n (+ i 1)) fc-incomplete))

;; scan after a leading '#'.
(define (fc-hash s n i)
  (if (< i n)
      (let ([k (char->integer (string-ref s i))])
        (cond
          [(= k 40) (fc-list s n (+ i 1))]                     ; #( vector
          [(= k 92) (fc-char s n (+ i 1))]                     ; #\ char literal
          [else (rd-token-end s n i)]))                        ; #t #f #xNN ...
      fc-incomplete))                                          ; lone # at EOF

;; scan after a quote/quasiquote prefix (' or `): a datum must follow.
(define (fc-prefix s n i)
  (let ([j (rd-skip-ws s n i)])
    (if (< j n) (fc-datum s n j) fc-incomplete)))

;; scan after an unquote (, or ,@): a datum must follow.
(define (fc-unquote s n i)
  (let ([i2 (if (and (< i n) (= (char->integer (string-ref s i)) 64)) (+ i 1) i)])
    (let ([j (rd-skip-ws s n i2)])
      (if (< j n) (fc-datum s n j) fc-incomplete))))

;; scan a parenthesized list; i is just past the open.  Read data until a close
;; paren/bracket (a lone '.' dotted-tail marker scans as an ordinary token, which
;; is fine -- only paren balance matters for completeness).  EOF first -> -1.
(define (fc-list s n i)
  (let ([j (rd-skip-ws s n i)])
    (if (< j n)
        (let ([k (char->integer (string-ref s j))])
          (cond
            [(or (= k 41) (= k 93)) (+ j 1)]                   ; ) or ] closes
            [else (let ([r (fc-datum s n j)])
                    (if (fc-bad? r) r (fc-list s n r)))]))
        fc-incomplete)))                                       ; EOF inside list

;; scan one datum at i (already past whitespace, i < n).
(define (fc-datum s n i)
  (let ([k (char->integer (string-ref s i))])
    (cond
      [(or (= k 40) (= k 91)) (fc-list s n (+ i 1))]           ; ( or [
      [(or (= k 41) (= k 93)) fc-malformed]                    ; unbalanced ) or ]
      [(= k 34) (fc-string s n (+ i 1))]                       ; "
      [(or (= k 39) (= k 96)) (fc-prefix s n (+ i 1))]         ; ' or `
      [(= k 44) (fc-unquote s n (+ i 1))]                      ; ,
      [(= k 35) (fc-hash s n (+ i 1))]                         ; #
      [else (rd-token-end s n i)])))                           ; atom -> to delimiter

;; PUBLIC: does buffer S start with a complete datum?
;;   (complete . CONSUMED)  -- CONSUMED = index just past the first datum
;;   'incomplete            -- need more input (unbalanced / unterminated / empty)
;;   'malformed             -- a clear syntax error (e.g. leading close paren)
(define (form-complete? s)
  (let ([n (string-length s)])
    (let ([i (rd-skip-ws s n 0)])
      (if (< i n)
          (let ([r (fc-datum s n i)])
            (cond
              [(= r fc-incomplete) (quote incomplete)]
              [(= r fc-malformed)  (quote malformed)]
              [else (cons (quote complete) r)]))
          (quote incomplete)))))                               ; only ws/comments

;; ---- test driver ----------------------------------------------------------
(define pass 0)
(define fail 0)
(define (check label input expected)
  (let ([got (form-complete? input)])
    (if (equal? got expected)
        (begin (set! pass (+ pass 1)))
        (begin (set! fail (+ fail 1))
               (printf "FAIL ~a: ~s -> ~s (expected ~s)\n" label input got expected)))))

;; complete forms: (complete . consumed)
(check "atom"          "42" (cons (quote complete) 2))
(check "atom-nl"       "42\n" (cons (quote complete) 2))
(check "symbol"        "foo" (cons (quote complete) 3))
(check "simple-list"   "(+ 1 2)" (cons (quote complete) 7))
(check "nested"        "(a (b c) d)" (cons (quote complete) 11))
(check "brackets"      "(let ([x 1]) x)" (cons (quote complete) 15))
(check "string"        "\"hi there\"" (cons (quote complete) 10))
(check "string-paren"  "\"a (b\"" (cons (quote complete) 6))       ; parens in string don't count
(check "string-semi"   "\"a;b\"" (cons (quote complete) 5))        ; ; in string is not a comment
(check "char-open"     "#\\(" (cons (quote complete) 3))           ; #\( -- the ( must not open
(check "char-semi"     "#\\;" (cons (quote complete) 3))
(check "char-space"    "#\\space" (cons (quote complete) 7))
(check "quote"         "'(1 2)" (cons (quote complete) 6))
(check "quasi-unquote" "`(a ,b)" (cons (quote complete) 7))
(check "unquote-splice" "`(a ,@b)" (cons (quote complete) 8))
(check "hash-t"        "#t" (cons (quote complete) 2))
(check "vector"        "#(1 2 3)" (cons (quote complete) 8))
(check "dotted"        "(a . b)" (cons (quote complete) 7))
(check "trailing"      "(+ 1 2) (+ 3 4)" (cons (quote complete) 7)) ; only the FIRST form
(check "leading-ws"    "  \n (x)" (cons (quote complete) 7))
(check "comment-then"  "; hi\n(x)" (cons (quote complete) 8))
(check "comment-in-list" "(a ; c\n b)" (cons (quote complete) 10))

;; incomplete: need more input
(check "empty"         "" (quote incomplete))
(check "ws-only"       "   \n  " (quote incomplete))
(check "comment-only"  "; just a comment\n" (quote incomplete))
(check "open-list"     "(+ 1" (quote incomplete))               ; THE crux case
(check "open-nested"   "(a (b c)" (quote incomplete))
(check "open-bracket"  "(let ([x 1]" (quote incomplete))
(check "open-string"   "\"unterminated" (quote incomplete))
(check "string-esc-eof" "\"ab\\" (quote incomplete))            ; trailing escape
(check "quote-eof"     "'" (quote incomplete))
(check "unquote-eof"   ",@" (quote incomplete))
(check "hash-eof"      "#" (quote incomplete))
(check "char-eof"      "#\\" (quote incomplete))

;; malformed: a clear error, not just "more input"
(check "close-first"   ")" (quote malformed))
(check "close-bracket" "]" (quote malformed))
;; The shipped reader (rd-list, prelude) treats ) and ] as interchangeable
;; closers -- it does NOT match bracket kinds.  The probe mirrors the reader
;; (D4(b) fidelity), so `]` closes a `(`-opened list; `(a ]` is a complete
;; 4-char datum with ` b)` left over.  Faithful-to-the-reader beats stricter.
(check "bracket-closes-paren" "(a ] b)" (cons (quote complete) 4))

(printf "\nform-complete? probe: ~a passed, ~a failed\n" pass fail)
(if (> fail 0) (exit 1) (exit 0))

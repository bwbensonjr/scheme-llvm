;;; prelude.scm -- standard library procedures prepended to every program.
;;;
;;; Pure Scheme over the core primitives + variadic lambda; the driver
;;; (src/compile.ss) prepends these top-level defines to each program, with
;;; user-wins shadowing (a user define of the same name drops the prelude's).
;;; See openspec prelude-mechanism.  memq/assq compare with eq?; member/assoc
;;; are their structural analogues over equal? (see openspec
;;; equality-and-list-library).  not/eq?/eqv?/equal? are primitives (see
;;; prim-table), so they are not defined here.

;;; --- derived syntactic forms (syntax-rules macros) ------------------------
;;; cond/and/or/when/unless/let* are macros expanded by src/passes/expand.ss.
;;; Named `let` is still hand-written there (it overloads the core `let`
;;; keyword).  `t` in `or`/`cond` is a macro-introduced temporary and is renamed
;;; hygienically per expansion, so it cannot capture user identifiers.

(define-syntax and
  (syntax-rules ()
    ((_) #t)
    ((_ e) e)
    ((_ e1 e2 ...) (if e1 (and e2 ...) #f))))

(define-syntax or
  (syntax-rules ()
    ((_) #f)
    ((_ e) e)
    ((_ e1 e2 ...) (let ((t e1)) (if t t (or e2 ...))))))

(define-syntax when
  (syntax-rules ()
    ((_ test e ...) (if test (begin e ...) #f))))

(define-syntax unless
  (syntax-rules ()
    ((_ test e ...) (if test #f (begin e ...)))))

(define-syntax let*
  (syntax-rules ()
    ((_ () body ...) (begin body ...))
    ((_ ((x v) rest ...) body ...) (let ((x v)) (let* (rest ...) body ...)))))

(define-syntax cond
  (syntax-rules (else =>)
    ((_) #f)
    ((_ (else e ...)) (begin e ...))
    ((_ (test => proc) rest ...) (let ((t test)) (if t (proc t) (cond rest ...))))
    ((_ (test) rest ...) (let ((t test)) (if t t (cond rest ...))))
    ((_ (test e ...) rest ...) (if test (begin e ...) (cond rest ...)))))

;; `case`: evaluate KEY once, then run the first clause whose datum list contains
;; it (eqv?), else the `else` clause.  A parenthesized KEY is bound to a hygienic
;; temp `k` first (so it is not re-evaluated per clause); the recursive calls pass
;; the bound identifier, which no longer matches the compound-KEY rule.  Expands
;; to `cond` over `(memv k '(d ...))`.
(define-syntax case
  (syntax-rules (else)
    ((_ (key ...) clause ...) (let ((k (key ...))) (case k clause ...)))
    ((_ k) (if #f #f))
    ((_ k (else e ...)) (begin e ...))
    ((_ k ((d ...) e ...) clause ...)
     (if (memv k (quote (d ...))) (begin e ...) (case k clause ...)))))

(define (list . xs) xs)

;;; --- compositional car/cdr accessors (cxr combinators) --------------------
;;; caar..cddr and the depth-3 forms caaar..cdddr, each the named composition of
;;; the primitive car/cdr (letters read right-to-left = innermost-first).
(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cdar x) (cdr (car x)))
(define (cddr x) (cdr (cdr x)))
(define (caaar x) (car (caar x)))
(define (caadr x) (car (cadr x)))
(define (cadar x) (car (cdar x)))
(define (caddr x) (car (cddr x)))
(define (cdaar x) (cdr (caar x)))
(define (cdadr x) (cdr (cadr x)))
(define (cddar x) (cdr (cdar x)))
(define (cdddr x) (cdr (cddr x)))

(define (length xs)
  (let loop ([xs xs] [n 0])
    (if (null? xs) n (loop (cdr xs) (+ n 1)))))

(define (reverse xs)
  (let loop ([xs xs] [acc (quote ())])
    (if (null? xs) acc (loop (cdr xs) (cons (car xs) acc)))))

(define (append a b)
  (if (null? a) b (cons (car a) (append (cdr a) b))))

(define (map f xs)
  (if (null? xs) (quote ()) (cons (f (car xs)) (map f (cdr xs)))))

(define (memq x xs)
  (if (null? xs) #f (if (eq? x (car xs)) xs (memq x (cdr xs)))))

;; memv: like memq but compares with eqv? (used by the `case` macro).
(define (memv x xs)
  (if (null? xs) #f (if (eqv? x (car xs)) xs (memv x (cdr xs)))))

(define (assq k xs)
  (if (null? xs) #f (if (eq? k (car (car xs))) (car xs) (assq k (cdr xs)))))

;;; --- structural list library (equality-and-list-library) ------------------
;;; member/assoc mirror memq/assq but compare with equal? (structural).
(define (member x xs)
  (if (null? xs) #f (if (equal? x (car xs)) xs (member x (cdr xs)))))

(define (assoc k xs)
  (if (null? xs) #f (if (equal? k (car (car xs))) (car xs) (assoc k (cdr xs)))))

(define (filter p xs)
  (if (null? xs)
      (quote ())
      (if (p (car xs))
          (cons (car xs) (filter p (cdr xs)))
          (filter p (cdr xs)))))

;; fold-left: tail-recursive, f receives (acc elem), left-to-right (R6RS order).
(define (fold-left f acc xs)
  (if (null? xs) acc (fold-left f (f acc (car xs)) (cdr xs))))

;; fold-right: non-tail, f receives (elem acc), right-to-left (R6RS order).
(define (fold-right f acc xs)
  (if (null? xs) acc (f (car xs) (fold-right f acc (cdr xs)))))

;;; --- character / string library (string-char-library) ---------------------
;;; char comparisons are n-ary and chained, reducing through char->integer and
;;; the numeric comparisons.  `op` is a lambda wrapper (primitives are not
;;; first-class, so we cannot pass = / < directly); chr-cmp recurses over the
;;; user-defined comparison chain.
(define (chr-cmp op a b rest)
  (if (op (char->integer a) (char->integer b))
      (if (null? rest) #t (chr-cmp op b (car rest) (cdr rest)))
      #f))
(define (char=?  a b . rest) (chr-cmp (lambda (x y) (=  x y)) a b rest))
(define (char<?  a b . rest) (chr-cmp (lambda (x y) (<  x y)) a b rest))
(define (char>?  a b . rest) (chr-cmp (lambda (x y) (>  x y)) a b rest))
(define (char<=? a b . rest) (chr-cmp (lambda (x y) (<= x y)) a b rest))
(define (char>=? a b . rest) (chr-cmp (lambda (x y) (>= x y)) a b rest))

;; string->list: codepoint-indexed, built from the end so the list is in order.
(define (string->list s)
  (let loop ([i (- (string-length s) 1)] [acc (quote ())])
    (if (< i 0) acc (loop (- i 1) (cons (string-ref s i) acc)))))

;;; --- vector constructors (vectors change) ---------------------------------
;;; make-vector/vector-ref/vector-set!/vector-length/vector? are primitives;
;;; the variadic constructor and list conversion are prelude Scheme over them.
(define (list->vector xs)
  (let ([v (make-vector (length xs) 0)])
    (let loop ([xs xs] [i 0])
      (if (null? xs)
          v
          (begin (vector-set! v i (car xs)) (loop (cdr xs) (+ i 1)))))))
(define (vector . xs) (list->vector xs))

;;; --- reader (scheme-reader): read-from-string source text -> datum --------
;;; Recursive descent over a string; the scan position is threaded functionally
;;; as (datum . next-index) pairs.  Characters are classified by codepoint
;;; (char->integer) because char literals are not interned (so eq? on them does
;;; not hold).  v1 reads integers, symbols, lists, #t/#f, #\char, "strings"
;;; (no escapes), 'quote and `/,/,@ quasiquote sugar, skipping whitespace and
;;; ; line comments.

(define (rd-ws? c)                       ; space, tab, newline, return
  (let ([k (char->integer c)])
    (or (= k 32) (or (= k 9) (or (= k 10) (= k 13))))))
(define (rd-digit? c)
  (let ([k (char->integer c)]) (and (< 47 k) (< k 58))))   ; '0'..'9'
(define (rd-delim? c)                    ; ends a token: ws or ( ) " ;
  (let ([k (char->integer c)])
    (or (rd-ws? c) (or (= k 40) (or (= k 41) (or (= k 34) (= k 59)))))))

(define (rd-skip-line s n i)             ; index just past the next newline (or n)
  (if (< i n)
      (if (= (char->integer (string-ref s i)) 10) (+ i 1) (rd-skip-line s n (+ i 1)))
      i))
(define (rd-skip-ws s n i)               ; next index that is not ws or a comment
  (if (< i n)
      (let ([c (string-ref s i)])
        (cond
          [(rd-ws? c) (rd-skip-ws s n (+ i 1))]
          [(= (char->integer c) 59) (rd-skip-ws s n (rd-skip-line s n (+ i 1)))]
          [else i]))
      i))

(define (rd-token-end s n i)             ; first delimiter index >= i (or n)
  (if (< i n)
      (if (rd-delim? (string-ref s i)) i (rd-token-end s n (+ i 1)))
      i))

(define (rd-all-digits? tok a m)
  (if (< a m) (if (rd-digit? (string-ref tok a)) (rd-all-digits? tok (+ a 1) m) #f) #t))
(define (rd-numeric? tok)                ; optional +/- then >=1 digits
  (let ([m (string-length tok)])
    (and (< 0 m)
         (let ([c0 (char->integer (string-ref tok 0))])
           (cond
             [(rd-digit? (string-ref tok 0)) (rd-all-digits? tok 0 m)]
             [(or (= c0 45) (= c0 43)) (and (< 1 m) (rd-all-digits? tok 1 m))]
             [else #f])))))
(define (rd-digits tok a m acc)
  (if (< a m)
      (rd-digits tok (+ a 1) m (+ (* acc 10) (- (char->integer (string-ref tok a)) 48)))
      acc))
(define (rd-parse-int tok)
  (let ([m (string-length tok)] [c0 (char->integer (string-ref tok 0))])
    (cond
      [(= c0 45) (- 0 (rd-digits tok 1 m 0))]
      [(= c0 43) (rd-digits tok 1 m 0)]
      [else (rd-digits tok 0 m 0)])))

(define (rd-atom s n i)                  ; token -> integer or interned symbol
  (let ([j (rd-token-end s n i)])
    (let ([tok (substring s i j)])
      (cons (if (rd-numeric? tok) (rd-parse-int tok) (string->symbol tok)) j))))

(define (rd-hex-digit c)                 ; hex char -> value (0 for non-hex)
  (let ([k (char->integer c)])
    (cond
      [(and (< 47 k) (< k 58)) (- k 48)]      ; 0-9
      [(and (< 96 k) (< k 103)) (- k 87)]     ; a-f
      [(and (< 64 k) (< k 71)) (- k 55)]      ; A-F
      [else 0])))
(define (rd-hex s n i acc)               ; \xHH...; -> (codepoint . index-past-;)
  (if (< i n)
      (if (= (char->integer (string-ref s i)) 59)     ; ;
          (cons acc (+ i 1))
          (rd-hex s n (+ i 1) (+ (* acc 16) (rd-hex-digit (string-ref s i)))))
      (cons acc i)))
(define (rd-str-esc c)                   ; escape letter -> the character it denotes
  (let ([k (char->integer c)])
    (cond
      [(= k 110) (integer->char 10)]     ; \n
      [(= k 116) (integer->char 9)]      ; \t
      [(= k 114) (integer->char 13)]     ; \r
      [else c])))                        ; \\ \" and any other: the char itself
(define (rd-string s n i)                ; i just past opening "; decodes escapes
  (let loop ([i i] [acc (quote ())])
    (if (< i n)
        (let* ([c (string-ref s i)] [k (char->integer c)])
          (cond
            [(= k 34) (cons (list->string (reverse acc)) (+ i 1))]        ; closing "
            [(= k 92)                                                     ; backslash escape
             (let ([e (string-ref s (+ i 1))])
               (if (= (char->integer e) 120)                             ; \xHH;
                   (let ([hx (rd-hex s n (+ i 2) 0)])
                     (loop (cdr hx) (cons (integer->char (car hx)) acc)))
                   (loop (+ i 2) (cons (rd-str-esc e) acc))))]            ; \n \t \r \\ \"
            [else (loop (+ i 1) (cons c acc))]))
        (cons (list->string (reverse acc)) i))))

(define (rd-hash s n i)                  ; i just past #
  (let ([k (char->integer (string-ref s i))])
    (cond
      [(= k 116) (cons #t (+ i 1))]                        ; #t
      [(= k 102) (cons #f (+ i 1))]                        ; #f
      [(= k 92) (rd-char s n i)]                           ; #\<char> or #\<name>
      [(= k 40) (let ([r (rd-list s n (+ i 1) (quote ()))])  ; #( ... ) -> vector
                  (cons (list->vector (car r)) (cdr r)))]
      [else (let ([j (rd-token-end s n i)])
              (cons (string->symbol (substring s i j)) j))])))

(define (rd-char-name tok)               ; multi-char #\ name -> character
  (cond
    [(string=? tok "space")   (integer->char 32)]
    [(string=? tok "newline") (integer->char 10)]
    [(string=? tok "tab")     (integer->char 9)]
    [(string=? tok "return")  (integer->char 13)]
    [(string=? tok "nul")     (integer->char 0)]
    [(string=? tok "null")    (integer->char 0)]
    [(string=? tok "delete")  (integer->char 127)]
    [(string=? tok "altmode") (integer->char 27)]
    [(string=? tok "esc")     (integer->char 27)]
    [else (string-ref tok 0)]))          ; unknown name: first char (undefined per spec)
(define (rd-char s n i)                  ; i at '\' of #\ ; content at i+1
  (let* ([cs (+ i 1)]
         [end (rd-token-end s n (+ cs 1))]   ; force the first content char in
         [tok (substring s cs end)])
    (if (= (string-length tok) 1)
        (cons (string-ref s cs) end)         ; single-character literal
        (cons (rd-char-name tok) end))))     ; named character

(define (rd-quote s n i)                 ; 'x -> (quote x)
  (let ([j (rd-skip-ws s n i)])
    (let ([r (rd-datum s n j)])
      (cons (list (quote quote) (car r)) (cdr r)))))

(define (rd-quasi s n i)                 ; `x -> (quasiquote x)
  (let ([j (rd-skip-ws s n i)])
    (let ([r (rd-datum s n j)])
      (cons (list (quote quasiquote) (car r)) (cdr r)))))

(define (rd-unquote s n i)               ; ,x -> (unquote x); ,@x -> (unquote-splicing x)
  (if (and (< i n) (= (char->integer (string-ref s i)) 64))     ; @  -> splicing
      (let ([j (rd-skip-ws s n (+ i 1))])
        (let ([r (rd-datum s n j)])
          (cons (list (quote unquote-splicing) (car r)) (cdr r))))
      (let ([j (rd-skip-ws s n i)])
        (let ([r (rd-datum s n j)])
          (cons (list (quote unquote) (car r)) (cdr r))))))

(define (rd-dot? s n j)                  ; a standalone `.` token at j (dotted-pair marker)
  (and (= (char->integer (string-ref s j)) 46)      ; .
       (= (rd-token-end s n (+ j 1)) (+ j 1))))      ; next char is a delimiter -> lone .
(define (rd-append-reverse acc tail)     ; (reverse acc) terminated by tail (improper list)
  (if (null? acc) tail (rd-append-reverse (cdr acc) (cons (car acc) tail))))
(define (rd-list s n i acc)              ; i after (; read until ) (supports . tail)
  (let ([j (rd-skip-ws s n i)])
    (if (< j n)
        (cond
          [(= (char->integer (string-ref s j)) 41) (cons (reverse acc) (+ j 1))]   ; )
          [(rd-dot? s n j)                                                          ; . tail
           (let* ([r (rd-datum s n (rd-skip-ws s n (+ j 1)))]
                  [j2 (rd-skip-ws s n (cdr r))])
             (cons (rd-append-reverse acc (car r)) (+ j2 1)))]                      ; past )
          [else (let ([r (rd-datum s n j)])
                  (rd-list s n (cdr r) (cons (car r) acc)))])
        (cons (reverse acc) j))))

(define (rd-datum s n i)                 ; i at a non-ws char -> (datum . next)
  (let ([k (char->integer (string-ref s i))])
    (cond
      [(= k 40) (rd-list s n (+ i 1) (quote ()))]          ; (
      [(= k 39) (rd-quote s n (+ i 1))]                    ; '
      [(= k 96) (rd-quasi s n (+ i 1))]                    ; `
      [(= k 44) (rd-unquote s n (+ i 1))]                  ; ,
      [(= k 34) (rd-string s n (+ i 1))]                   ; "
      [(= k 35) (rd-hash s n (+ i 1))]                     ; #
      [else (rd-atom s n i)])))

(define (read-from-string s)
  (let ([n (string-length s)])
    (car (rd-datum s n (rd-skip-ws s n 0)))))

;;; emit.ss (tasks 5.1-5.4) -- lower L-code to textual LLVM IR (opaque ptrs).
;;;
;;; Value = i64 tagged word (matches src/runtime/runtime.c).  Every Scheme
;;; function shares ONE prototype so musttail is legal (LLVM requires matching
;;; caller/callee prototypes):
;;;   fastcc i64 (i64 self, i64 argc, i64 a0 ... i64 a{K-1}, ptr overflow)
;;; The CC is `fastcc`, not `tailcc` (change: fix-high-arity-call-convention):
;;; a non-tail `call tailcc` with a stack-passed argument (which happens once
;;; K+3 > 8 args, i.e. K >= 6, exceed the arm64 argument registers) fails to
;;; preserve the caller's live arguments; `fastcc` preserves them.  Every tail
;;; call here is `musttail` (see finish-call), which `fastcc` still guarantees,
;;; so bounded-stack tail loops are unaffected.
;;; K = max fixed arity in the program.  self is the called closure (arg0), from
;;; which free variables are loaded.  argc is the actual argument count; the
;;; first K args ride in the positional slots (padded with 0 when fewer) and any
;;; excess spills through the overflow vector (null when there is none).  A
;;; fixed-arity callee checks argc == f; a variadic callee (argc >= f) rebuilds
;;; its rest list from the positional excess + overflow.  The top-level
;;; @scheme_entry is ccc (called from C main); its calls are regular, not tail.

;; --- output state (reset per program) ---
(define emit-lines '())
(define (emit! s) (set! emit-lines (cons s emit-lines)))
(define temp-n 0)
(define lbl-n 0)
(define current-bb "entry")
(define (fresh-temp) (set! temp-n (+ temp-n 1)) (string-append "%t" (number->string temp-n)))
(define (fresh-bb base) (set! lbl-n (+ lbl-n 1)) (string-append base (number->string lbl-n)))
(define (start-bb name) (emit! (string-append name ":")) (set! current-bb name))
(define (reset-emit!) (set! temp-n 0) (set! lbl-n 0) (set! emit-lines '()) (set! current-bb "entry"))

;; --- private byte-array constants (module-level globals, reset per program) ---
;; Symbol names and string literals both become private constant globals holding
;; their UTF-8 bytes; a symbol adds a per-use rt_intern call, a string a per-use
;; rt_make_string.  Globals are accumulated here and prepended to the module by
;; emit-program.
(define sym-globals '())          ; list of "@.str.*.N = ..." definition lines
(define sym-table '())            ; alist: symbol name-string -> "@.str.sym.N"
(define sym-n 0)
(define (reset-symbols!) (set! sym-globals '()) (set! sym-table '()) (set! sym-n 0))
(define (symbol-globals) (apply string-append (reverse sym-globals)))

;; --- C-string escaping, expressed in the self-hostable subset -------------
;; (change: emit-cstring-in-language) No string->utf8/bytevector ops, no radix
;; number->string, no string-upcase, no #x literals -- just string/char access
;; and quotient/remainder, so the emitter can compile itself.  Output is
;; byte-for-byte identical to the previous bytevector-based version.
(define hex-digits "0123456789ABCDEF")
(define (hex2 b)                  ; byte 0..255 -> two uppercase hex digits
  (string-append (string (string-ref hex-digits (quotient b 16)))
                 (string (string-ref hex-digits (remainder b 16)))))

;; Unicode scalar -> list of its UTF-8 byte values (1..4), via base-64 digit math
;; (192=0xC0, 224=0xE0, 240=0xF0 lead bytes; 128=0x80 continuation).  Reproduces
;; exactly what string->utf8 produced.
(define (utf8-bytes cp)
  (cond
    [(< cp 128) (list cp)]
    [(< cp 2048)
     (list (+ 192 (quotient cp 64))
           (+ 128 (remainder cp 64)))]
    [(< cp 65536)
     (list (+ 224 (quotient cp 4096))
           (+ 128 (remainder (quotient cp 64) 64))
           (+ 128 (remainder cp 64)))]
    [else
     (list (+ 240 (quotient cp 262144))
           (+ 128 (remainder (quotient cp 4096) 64))
           (+ 128 (remainder (quotient cp 64) 64))
           (+ 128 (remainder cp 64)))]))

(define (byte-escape b)           ; one UTF-8 byte -> its c"..." fragment
  (if (and (>= b 32) (<= b 126) (not (= b 34)) (not (= b 92)))
      (string (integer->char b))          ; printable ASCII except " (34) and \ (92)
      (string-append "\\" (hex2 b))))      ; everything else -> \XX

;; escape a name for an LLVM c"..." literal; return (list escaped byte-count),
;; the count including the trailing NUL.  Walk the string by Unicode scalar,
;; encode each to UTF-8 bytes, escape each byte.  Printable ASCII except " and \
;; go through verbatim; everything else (incl. UTF-8 bytes) as \XX.
(define (llvm-cstring name)
  (let ([n (string-length name)])
    (let loop ([i 0] [nbytes 0] [acc '()])
      (if (= i n)
          (list (apply string-append (reverse acc)) (+ nbytes 1))
          (let ([bs (utf8-bytes (char->integer (string-ref name i)))])
            (loop (+ i 1)
                  (+ nbytes (length bs))
                  (append (reverse (map byte-escape bs)) acc)))))))

;; emit a private constant global (prefix + counter) holding s's UTF-8 bytes and
;; a trailing NUL; return (list @global byte-length-without-NUL).
(define (emit-cstring-global prefix s)
  (let* ([esc+len (llvm-cstring s)]            ; len includes the trailing NUL
         [esc (car esc+len)] [len (cadr esc+len)]
         [g (string-append prefix (number->string sym-n))]
         [def (string-append g " = private unnamed_addr constant ["
                             (number->string len) " x i8] c\"" esc "\\00\"\n")])
    (set! sym-n (+ sym-n 1))
    (set! sym-globals (cons def sym-globals))
    (list g (- len 1))))

(define (symbol-global name)      ; dedup the name's global, return its @operand
  (cond
    [(assoc name sym-table) => cdr]
    [else
     (let* ([g+len (emit-cstring-global "@.str.sym." name)] [g (car g+len)])
       (set! sym-table (cons (cons name g) sym-table))
       g)]))

;; --- constants and primitives (must match runtime.c tags) ---
;; Immediates encode inline to an operand with no emission; a symbol emits an
;; rt_intern call and a pair materializes via rt_cons (recursing), so encode-const
;; may emit into the current function and returns the resulting operand.
(define (encode-const d)
  (cond
    [(and (integer? d) (exact? d)) (number->string (* d 8))]  ; fixnum: n<<3
    [(eq? d #t) "257"]                                        ; TRUE_V  (subtype BOOL, payload 1)
    [(eq? d #f) "1"]                                          ; FALSE_V (subtype BOOL, payload 0)
    [(null? d) "2"]                                           ; NIL_V
    [(char? d)                                                ; immediate char: (cp<<8)|(SUB_CHAR<<3)|TAG_BOOL
     (number->string (+ (* (char->integer d) 256) 9))]
    [(symbol? d)
     (let ([g (symbol-global (symbol->string d))] [t (fresh-temp)])
       (emit! (string-append t " = call i64 @rt_intern(ptr " g ")"))
       t)]
    [(string? d)                                              ; UTF-8 bytes + rt_make_string
     (let* ([g+len (emit-cstring-global "@.str.lit." d)]
            [g (car g+len)] [len (cadr g+len)])
       (let ([t (fresh-temp)])
         (emit! (string-append t " = call i64 @rt_make_string(ptr " g ", i64 "
                               (number->string len) ")"))
         t))]
    [(pair? d)                                                ; materialize at runtime
     (let* ([a  (encode-const (car d))]
            [dd (encode-const (cdr d))]
            [t  (fresh-temp)])
       (emit! (string-append t " = call i64 @rt_cons(i64 " a ", i64 " dd ")"))
       t)]
    ;; inexact real (flonum) literal (change: inexact-numbers): emit its shortest
    ;; round-trippable decimal as a C string constant and rebuild the flonum at
    ;; runtime with rt_flonum_lit (strtod, correctly rounded -> the same double).
    ;; number->string round-trips under both the Chez host and Emit.  Placed after
    ;; the exact/char/symbol/string/pair clauses; an integral flonum (3.0) reaches
    ;; here because it fails clause 1's exact? test.
    [(and (real? d) (not (exact? d)))
     (let* ([g+len (emit-cstring-global "@.flo.lit." (number->string d))]
            [g (car g+len)] [t (fresh-temp)])
       (emit! (string-append t " = call i64 @rt_flonum_lit(ptr " g ")"))
       t)]
    [else (error 'emit "bad const" d)]))

(define prim-table
  '((%+ "rt_add") (%- "rt_sub") (%* "rt_mul") (%/ "rt_div")
    (%quotient "rt_quotient") (%remainder "rt_remainder") (%modulo "rt_modulo")
    (%= "rt_num_eq") (%< "rt_lt")
    (%flonum? "rt_flonum_p") (%number? "rt_number_p") (%real? "rt_real_p")
    (%inexact? "rt_inexact_p") (%exact->inexact "rt_exact_to_inexact")
    (%inexact->exact "rt_inexact_to_exact")
    (%string->flonum "rt_string_to_flonum") (%flonum->string "rt_flonum_to_string")
    (%write-char "rt_write_char")
    (%cons "rt_cons") (%car "rt_car") (%cdr "rt_cdr")
    (%null? "rt_null_p") (%pair? "rt_pair_p") (%eq? "rt_eq_p")
    (%eqv? "rt_eqv_p") (%equal? "rt_equal") (%not "rt_not")
    (box "rt_box") (unbox "rt_unbox") (set-box! "rt_set_box")
    (%char->integer "rt_char_to_integer") (%integer->char "rt_integer_to_char")
    (%string-length "rt_string_length") (%string-ref "rt_string_ref")
    (%substring "rt_substring") (%string->symbol "rt_string_to_symbol")
    (%string=? "rt_string_eq") (%string-append "rt_string_append")
    (%symbol->string "rt_symbol_to_string") (%list->string "rt_list_to_string")
    (%make-string "rt_make_string_fill")
    (%string-set! "rt_string_set") (%string-copy "rt_string_copy")
    (%make-vector "rt_make_vector") (%vector-ref "rt_vector_ref")
    (%vector-set! "rt_vector_set") (%vector-length "rt_vector_length")
    (%vector? "rt_vector_p")
    (%make-bytevector "rt_make_bytevector") (%bytevector-u8-ref "rt_bytevector_u8_ref")
    (%bytevector-u8-set! "rt_bytevector_u8_set") (%bytevector-length "rt_bytevector_length")
    (%bytevector? "rt_bytevector_p")
    (%hash "rt_hash") (%make-hash-table "rt_make_hash_table")
    (%hash-table? "rt_hash_table_p") (%hash-table-spine "rt_hash_table_spine")
    (%make-record-type "rt_make_record_type") (%make-record "rt_make_record")
    (%record-ref "rt_record_ref") (%record-set! "rt_record_set")
    (%record-of-type? "rt_record_of_type_p") (%record? "rt_record_p")
    (%list->mv "rt_list_to_mv") (%mv? "rt_mv_p") (%mv->list "rt_mv_to_list")
    (%symbol? "rt_symbol_p") (%string? "rt_string_p") (%char? "rt_char_p")
    (%boolean? "rt_boolean_p") (%integer? "rt_integer_p") (%exact? "rt_exact_p")
    (%read-all-stdin "rt_read_all_stdin") (%display "rt_display")
    (%write "rt_write_val") (%newline "rt_newline")
    (%no-prelude? "rt_no_prelude_p")
    (repl-mode "rt_repl_mode") (repl-input "rt_repl_input")
    (repl-state-ref "rt_repl_state_ref") (repl-state-set! "rt_repl_state_set")
    (%error-abort "rt_error") (%raise "rt_raise")
    (%error-object? "rt_error_object_p")
    (%error-object-message "rt_error_object_message")
    (%error-object-irritants "rt_error_object_irritants")))

;; --- string helpers ---
(define (comma-join lst)
  (cond [(null? lst) ""]
        [(null? (cdr lst)) (car lst)]
        [else (string-append (car lst) ", " (comma-join (cdr lst)))]))
(define (i64s ops) (comma-join (map (lambda (o) (string-append "i64 " o)) ops)))
(define (label-line? l)
  (let ([n (string-length l)]) (and (> n 0) (char=? (string-ref l (- n 1)) #\:))))
(define (lines->string lines)
  (apply string-append
    (map (lambda (l) (if (label-line? l) (string-append l "\n") (string-append "  " l "\n")))
         lines)))

;; LLVM global operand for a code label (change: module-artifacts-vertical-slice).
;; A program-unit label ("code_N") is a legal unquoted identifier and stays
;; `@code_N` (byte-identical to before modules).  A unit-qualified label carries a
;; ':' (e.g. "mylib:code_N"), illegal unquoted, so it is quoted `@"mylib:code_N"`.
(define (label-has-colon? s)
  (let loop ([i 0] [n (string-length s)])
    (cond [(= i n) #f]
          [(char=? (string-ref s i) #\:) #t]
          [else (loop (+ i 1) n)])))
(define (label-operand label)
  (if (label-has-colon? label)
      (string-append "@\"" label "\"")
      (string-append "@" label)))

;; --- expression emission: ev returns an operand; et terminates the block ---
(define (ev e env cp tc?)
  (match e
    [(const ,d) (encode-const d)]
    [(local ,x) (cdr (assq x env))]
    [(free-ref ,i) (load-free cp i)]
    [(global-ref ,s)
     (let ([t (fresh-temp)])
       (emit! (string-append t " = load i64, ptr " (global-operand s)))
       t)]
    [(global-set! ,s ,e)                     ; store into the slot; value = stored
     ;; Route the value through rt_root so it survives GC: the JIT'd global slot
     ;; lives in memory libgc does not scan, so a value reachable only through the
     ;; slot would be collected (change: repl-embedded-incremental).
     ;; let* (not let): `op` (which emits and allocates temps) MUST evaluate before
     ;; the result temp, so temp numbering is identical under Chez (right-to-left
     ;; let) and the embedded compiler (left-to-right) -- the cross-door unit
     ;; byte-identity guarantee (change: module-artifacts-vertical-slice).
     (let* ([op (ev e env cp tc?)] [t (fresh-temp)])
       (emit! (string-append t " = call i64 @rt_root(i64 " op ")"))
       (emit! (string-append "store i64 " t ", ptr " (global-operand s)))
       t)]
    [(if ,a ,b ,c) (ev-if a b c env cp tc?)]
    [(seq ,a ,b) (ev a env cp tc?) (ev b env cp tc?)]
    [(let ,binds ,body)
     (let* ([ops (map (lambda (b) (ev (cadr b) env cp tc?)) binds)]
            [env2 (append (map (lambda (b op) (cons (car b) op)) binds ops) env)])
       (ev body env2 cp tc?))]
    [(primcall ,op . ,args)
     (emit-primcall op (map (lambda (a) (ev a env cp tc?)) args))]
    [(make-closure ,label ,caps)
     (emit-make-closure label (map (lambda (c) (ev c env cp tc?)) caps))]
    [(closure-block ,entries ,body)
     (ev body (emit-closure-block entries env cp tc?) cp tc?)]
    [(apply-app ,f ,args)
     ;; sequence operands then callee explicitly (fix-emit-eval-order): don't
     ;; rely on host argument-evaluation order, so schemec and the Chez-hosted
     ;; compiler emit temps in the same order.  Operands-first matches Chez.
     (let* ([aops (map (lambda (a) (ev a env cp tc?)) args)]
            [fop  (ev f env cp tc?)])
       (emit-apply fop aops #f tc?))]
    [(app ,f ,args)
     (let* ([aops (map (lambda (a) (ev a env cp tc?)) args)]
            [fop  (ev f env cp tc?)])
       (emit-app fop aops #f tc?))]
    [(self-app ,label ,args)                       ; direct self-call (B-self)
     (let ([aops (map (lambda (a) (ev a env cp tc?)) args)])
       (emit-self-app label aops #f tc? cp))]))

(define (et e env cp tc?)
  (match e
    [(if ,a ,b ,c) (et-if a b c env cp tc?)]
    [(seq ,a ,b) (ev a env cp tc?) (et b env cp tc?)]
    [(let ,binds ,body)
     (let* ([ops (map (lambda (b) (ev (cadr b) env cp tc?)) binds)]
            [env2 (append (map (lambda (b op) (cons (car b) op)) binds ops) env)])
       (et body env2 cp tc?))]
    [(closure-block ,entries ,body)
     (et body (emit-closure-block entries env cp tc?) cp tc?)]
    [(apply-app ,f ,args)                          ; operands-first (fix-emit-eval-order)
     (let* ([aops (map (lambda (a) (ev a env cp tc?)) args)]
            [fop  (ev f env cp tc?)])
       (emit-apply fop aops #t tc?))]
    [(app ,f ,args)
     (let* ([aops (map (lambda (a) (ev a env cp tc?)) args)]
            [fop  (ev f env cp tc?)])
       (emit-app fop aops #t tc?))]
    [(self-app ,label ,args)                       ; direct self-call in tail position
     (let ([aops (map (lambda (a) (ev a env cp tc?)) args)])
       (emit-self-app label aops #t tc? cp))]
    [else (emit! (string-append "ret i64 " (ev e env cp tc?)))]))

(define (ev-if a b c env cp tc?)
  ;; let* (not let): emit the test, then allocate labels/cmp, in a fixed order --
  ;; a parallel `let` would evaluate these side-effecting inits in host order
  ;; (Chez right-to-left vs Emit left-to-right), diverging temp/label
  ;; numbering (fix-emit-eval-order, ev-if/et-if sites).
  (let* ([tv (ev a env cp tc?)]
         [tl (fresh-bb "then")] [el (fresh-bb "else")] [ml (fresh-bb "merge")]
         [cmp (fresh-temp)])
    (emit! (string-append cmp " = icmp ne i64 " tv ", 1"))   ; != FALSE_V
    (emit! (string-append "br i1 " cmp ", label %" tl ", label %" el))
    (start-bb tl)
    ;; let* (not let): the arm must be emitted BEFORE reading current-bb, or
    ;; the phi records the arm-entry block instead of the block the arm ends in
    ;; (a nested if moves current-bb to its own merge block).  Chez evaluates
    ;; parallel let inits right-to-left, which would capture the stale block.
    (let* ([bv (ev b env cp tc?)] [bbb current-bb])
      (emit! (string-append "br label %" ml))
      (start-bb el)
      (let* ([cv (ev c env cp tc?)] [bbc current-bb])
        (emit! (string-append "br label %" ml))
        (start-bb ml)
        (let ([r (fresh-temp)])
          (emit! (string-append r " = phi i64 [ " bv ", %" bbb " ], [ " cv ", %" bbc " ]"))
          r)))))

(define (et-if a b c env cp tc?)
  (let* ([tv (ev a env cp tc?)]                ; operands-order fixed (see ev-if)
         [tl (fresh-bb "then")] [el (fresh-bb "else")] [cmp (fresh-temp)])
    (emit! (string-append cmp " = icmp ne i64 " tv ", 1"))
    (emit! (string-append "br i1 " cmp ", label %" tl ", label %" el))
    (start-bb tl) (et b env cp tc?)
    (start-bb el) (et c env cp tc?)))

(define (load-free cp i)
  (let* ([b (fresh-temp)] [p (fresh-temp)] [g (fresh-temp)] [v (fresh-temp)])
    (emit! (string-append b " = and i64 " cp ", -8"))
    (emit! (string-append p " = inttoptr i64 " b " to ptr"))
    (emit! (string-append g " = getelementptr i64, ptr " p ", i64 " (number->string (+ i 1))))
    (emit! (string-append v " = load i64, ptr " g))
    v))

;; --- inline fixnum fast path (change: inline-fixnum-arith-and-self-calls) -----
;; The hot numeric primitives get an inline fast path for the both-operands-fixnum
;; case instead of an out-of-line rt_* call.  Each entry is
;;   (scheme-op  rt-name  kind  llvm-instr)
;; where `kind` picks the fast-path shape.  Fixnums are tag 000 (payload value<<3),
;; so the tagged word IS value<<3 and the ops fall out with no shifts (except *):
;;   add : % = <instr> i64 a, b            (+ -> add, - -> sub)
;;   mul : untag one operand (ashr 3) then mul  ((a>>3)*b = (va*vb)<<3)
;;   cmp : <instr> i64 a, b (i1) then select TRUE_V/FALSE_V   (= -> eq, < -> slt)
;; The runtime primitive remains the single definition of numeric semantics: it is
;; the slow path, so a future flonum/bignum change lands in rt_* and non-fixnum
;; operands are routed there automatically (design: A2 tag-checked seam).  N-ary
;; arithmetic and chained comparisons are already reduced to binary primcalls in
;; expand.ss, so hooking here covers every arity and `> >= <=`.
(define inline-arith-table
  '((%+ "rt_add"    add "add")
    (%- "rt_sub"    add "sub")
    (%* "rt_mul"    mul "mul")
    (%= "rt_num_eq" cmp "icmp eq")
    (%< "rt_lt"     cmp "icmp slt")))

(define (emit-inline-fast kind instr a b)  ; emit the fast-path op, return its operand
  (cond
    [(eq? kind 'add)                          ; + -> add, - -> sub (tag 000, no shift)
     (let ([f (fresh-temp)])
       (emit! (string-append f " = " instr " i64 " a ", " b))
       f)]
    [(eq? kind 'mul)                          ; (a>>3) * b = (va*vb)<<3
     (let* ([s (fresh-temp)] [f (fresh-temp)])
       (emit! (string-append s " = ashr i64 " a ", 3"))
       (emit! (string-append f " = mul i64 " s ", " b))
       f)]
    [(eq? kind 'cmp)                          ; icmp (i1) then select TRUE_V(257)/FALSE_V(1)
     (let* ([c (fresh-temp)] [f (fresh-temp)])
       (emit! (string-append c " = " instr " i64 " a ", " b))
       (emit! (string-append f " = select i1 " c ", i64 257, i64 1"))
       f)]
    [else (error 'emit "bad inline arith kind" kind)]))

(define (emit-inline-arith entry a b)  ; guard -> fast op | slow rt_* call, joined by phi
  ;; let* throughout so temp/label numbering is fixed regardless of host
  ;; argument-evaluation order (the cross-door byte-identity guarantee; see ev-if).
  (let* ([rt    (cadr entry)]
         [kind  (caddr entry)]
         [instr (cadddr entry)]
         [g1 (fresh-temp)] [g2 (fresh-temp)] [g3 (fresh-temp)]
         [fast (fresh-bb "fixfast")] [slow (fresh-bb "fixslow")] [mrg (fresh-bb "fixmerge")])
    (emit! (string-append g1 " = or i64 " a ", " b))         ; both fixnum iff
    (emit! (string-append g2 " = and i64 " g1 ", 7"))        ; (a|b)&7 == 0
    (emit! (string-append g3 " = icmp eq i64 " g2 ", 0"))
    (emit! (string-append "br i1 " g3 ", label %" fast ", label %" slow))
    (start-bb fast)
    (let* ([fv (emit-inline-fast kind instr a b)] [fbb current-bb])
      (emit! (string-append "br label %" mrg))
      (start-bb slow)
      (let ([sv (fresh-temp)])
        (emit! (string-append sv " = call i64 @" rt "(i64 " a ", i64 " b ")"))
        (emit! (string-append "br label %" mrg))
        (start-bb mrg)
        (let ([r (fresh-temp)])
          (emit! (string-append r " = phi i64 [ " fv ", %" fbb " ], [ " sv ", %" slow " ]"))
          r)))))

(define (emit-primcall op ops)
  ;; %run-guarded is special: it passes the module's own ccc trampoline @__apply0
  ;; (a pointer, resolved within this module -- no cross-module symbol) so the C
  ;; runtime can invoke the guarded thunk (change: r7rs-exceptions-subset).
  (if (eq? op '%run-guarded)
      (let ([t (fresh-temp)])
        (emit! (string-append t " = call i64 @rt_run_guarded(ptr @__apply0, i64 "
                              (car ops) ")"))
        t)
      (let ([inl (assq op inline-arith-table)])
        (if (and inl (pair? ops) (pair? (cdr ops)) (null? (cddr ops)))  ; exactly 2 operands
            (emit-inline-arith inl (car ops) (cadr ops))
            (let ([entry (assq op prim-table)] [t (fresh-temp)])
              (unless entry (error 'emit "unknown prim" op))
              (emit! (string-append t " = call i64 @" (cadr entry) "(" (i64s ops) ")"))
              t)))))

;; The ccc trampoline @__apply0(closure): load the closure's code pointer and do
;; the fastcc 0-arg call (self=closure, argc=0, K positional pads = undef,
;; overflow = null), matching the uniform prototype.  `internal` linkage so each
;; module (incl. per-form REPL modules in one JITDylib) has its own with no
;; collision.  rt_run_guarded (C) calls this by pointer inside its setjmp frame.
(define (emit-apply0-trampoline k)
  (let loop ([i 0] [pads ""])
    (if (< i k)
        (loop (+ i 1) (string-append pads ", i64 undef"))
        (string-append
         "define internal i64 @__apply0(i64 %clos) {\nentry:\n"
         "  %b = and i64 %clos, -8\n"
         "  %bp = inttoptr i64 %b to ptr\n"
         "  %code = load i64, ptr %bp\n"
         "  %fp = inttoptr i64 %code to ptr\n"
         "  %r = call fastcc i64 %fp(i64 %clos, i64 0" pads ", ptr null)\n"
         "  ret i64 %r\n}\n\n"))))

;; allocate {code_ptr, cap...}, tag TAG_CLOSURE (4)
(define (emit-alloc-closure label caps-count)
  (let* ([raw (fresh-temp)] [p (fresh-temp)])
    (emit! (string-append raw " = call i64 @rt_alloc_words(i64 " (number->string (+ caps-count 1)) ")"))
    (emit! (string-append p " = inttoptr i64 " raw " to ptr"))
    (emit! (string-append "store i64 ptrtoint (ptr " (label-operand label) " to i64), ptr " p))
    (list raw p)))

(define (store-cap p i op)
  (let ([g (fresh-temp)])
    (emit! (string-append g " = getelementptr i64, ptr " p ", i64 " (number->string i)))
    (emit! (string-append "store i64 " op ", ptr " g))))

(define (emit-make-closure label capops)
  (let* ([raw+p (emit-alloc-closure label (length capops))]
         [raw (car raw+p)] [p (cadr raw+p)])
    (let loop ([i 1] [cs capops]) (unless (null? cs) (store-cap p i (car cs)) (loop (+ i 1) (cdr cs))))
    (let ([c (fresh-temp)]) (emit! (string-append c " = or i64 " raw ", 4")) c)))

;; two-phase: allocate + tag all, bind names, then fill env slots (may ref siblings)
(define (emit-closure-block entries env cp tc?)
  (let* ([allocs
          (map (lambda (ent)
                 (let* ([raw+p (emit-alloc-closure (cadr ent) (length (caddr ent)))]
                        [raw (car raw+p)] [p (cadr raw+p)])
                   (let ([c (fresh-temp)])
                     (emit! (string-append c " = or i64 " raw ", 4"))
                     (list (car ent) p (caddr ent) c))))   ; name, base-ptr, caps, tagged
               entries)]
         [env2 (append (map (lambda (a) (cons (car a) (cadddr a))) allocs) env)])
    (for-each
      (lambda (a)
        (let loop ([i 1] [cs (caddr a)])
          (unless (null? cs)
            (store-cap (cadr a) i (ev (car cs) env2 cp tc?))
            (loop (+ i 1) (cdr cs)))))
      allocs)
    env2))

;; load the code pointer out of a (tagged) closure value; returns the fn operand
(define (emit-load-code fop)
  (let* ([b (fresh-temp)] [bp (fresh-temp)] [code (fresh-temp)] [fp (fresh-temp)])
    (emit! (string-append b " = and i64 " fop ", -8"))
    (emit! (string-append bp " = inttoptr i64 " b " to ptr"))
    (emit! (string-append code " = load i64, ptr " bp))
    (emit! (string-append fp " = inttoptr i64 " code " to ptr"))
    fp))

;; emit the call itself; tail? => terminate with (musttail if tc?) call + ret
(define (finish-call fp callargs tail? tc?)
  (let ([r (fresh-temp)])
    (if tail?
        (begin
          (emit! (string-append r " = " (if tc? "musttail " "") "call fastcc i64 " fp "(" callargs ")"))
          (emit! (string-append "ret i64 " r))
          #f)
        (begin
          (emit! (string-append r " = call fastcc i64" fp "(" callargs ")"))
          r))))

;; spill i64 operands into a fresh GC-allocated array; returns a ptr operand.
(define (emit-spill ops)
  (let* ([raw (fresh-temp)] [p (fresh-temp)] [len (length ops)])
    (emit! (string-append raw " = call i64 @rt_alloc_words(i64 " (number->string len) ")"))
    (emit! (string-append p " = inttoptr i64 " raw " to ptr"))
    (let loop ([i 0] [os ops])
      (unless (null? os)
        (let ([g (fresh-temp)])
          (emit! (string-append g " = getelementptr i64, ptr " p ", i64 " (number->string i)))
          (emit! (string-append "store i64 " (car os) ", ptr " g)))
        (loop (+ i 1) (cdr os))))
    p))

;; indirect closure call with argc+overflow CC: self, argc (actual count),
;; a0..a{K-1} (padded), overflow (excess args beyond K, else null).
(define (emit-app fop aops tail? tc?)
  (let* ([fp (emit-load-code fop)]
         [n (length aops)]
         [k *arity*]
         [slots (if (>= n k)
                    (list-head aops k)                     ; excess -> overflow
                    (append aops (make-list (- k n) "0")))] ; pad short calls
         [overflow (if (> n k) (emit-spill (list-tail aops k)) "null")]
         [callargs (comma-join
                     (append
                       (list (string-append "i64 " fop)
                             (string-append "i64 " (number->string n)))
                       (map (lambda (o) (string-append "i64 " o)) slots)
                       (list (string-append "ptr " overflow))))])
    (finish-call fp callargs tail? tc?)))

;; direct self-call (change: inline-fixnum-arith-and-self-calls): call the enclosing
;; function's own code label instead of loading a code pointer from the closure, and
;; reuse the current closure ptr `cp` (%self) as the callee's self -- correct because
;; %self is a closure for this very function, which is exactly what the callee needs
;; to load its free vars.  Same slot/overflow layout as emit-app; a direct call with
;; a constant argc lets LLVM fold the callee's entry arity check.  A leading space
;; before the label operand keeps `call fastcc i64 @code_N(...)` well-formed.
(define (emit-self-app label aops tail? tc? cp)
  (let* ([n (length aops)]
         [k *arity*]
         [slots (if (>= n k)
                    (list-head aops k)
                    (append aops (make-list (- k n) "0")))]
         [overflow (if (> n k) (emit-spill (list-tail aops k)) "null")]
         [callargs (comma-join
                     (append
                       (list (string-append "i64 " cp)
                             (string-append "i64 " (number->string n)))
                       (map (lambda (o) (string-append "i64 " o)) slots)
                       (list (string-append "ptr " overflow))))]
         [r (fresh-temp)])
    (if tail?
        (begin
          (emit! (string-append r " = " (if tc? "musttail " "") "call fastcc i64 "
                                (label-operand label) "(" callargs ")"))
          (emit! (string-append "ret i64 " r))
          #f)
        (begin
          (emit! (string-append r " = call fastcc i64 " (label-operand label) "(" callargs ")"))
          r))))

;; (apply f a1 .. aN lst): flatten the N leading args and the elements of lst
;; into a runtime argv, load the K positional slots, and point overflow past K.
(define (emit-apply fop aops tail? tc?)
  (let* ([fp (emit-load-code fop)]
         [k *arity*]
         [n (- (length aops) 1)]                   ; leading (non-list) args
         [pre (list-head aops n)]
         [lst (list-ref aops n)]                   ; the list to spread
         [preptr (if (zero? n) "null" (emit-spill pre))]
         [m (fresh-temp)] [argc (fresh-temp)] [argv (fresh-temp)]
         [ovcmp (fresh-temp)] [ovg (fresh-temp)] [ov (fresh-temp)]
         [slots (map (lambda (i) (fresh-temp)) (iota k))])
    (emit! (string-append m " = call i64 @rt_list_length(i64 " lst ")"))
    (emit! (string-append argc " = add i64 " (number->string n) ", " m))
    (emit! (string-append argv " = call ptr @rt_apply_argv(i64 " (number->string n)
                          ", ptr " preptr ", i64 " lst ", i64 " (number->string k) ")"))
    (for-each (lambda (s i)
                (let ([g (fresh-temp)])
                  (emit! (string-append g " = getelementptr i64, ptr " argv ", i64 " (number->string i)))
                  (emit! (string-append s " = load i64, ptr " g))))
              slots (iota k))
    (emit! (string-append ovcmp " = icmp sgt i64 " argc ", " (number->string k)))
    (emit! (string-append ovg " = getelementptr i64, ptr " argv ", i64 " (number->string k)))
    (emit! (string-append ov " = select i1 " ovcmp ", ptr " ovg ", ptr null"))
    (finish-call fp
      (comma-join
        (append
          (list (string-append "i64 " fop) (string-append "i64 " argc))
          (map (lambda (s) (string-append "i64 " s)) slots)
          (list (string-append "ptr " ov))))
      tail? tc?)))

(define *arity* 0)  ; K = max fixed arity, set per program

;; --- top-level assembly ---
(define (max-arity defs)  ; K = max fixed-param count across all code defs
  (fold-left (lambda (m d) (match d [(code ,l ,s ,fixed ,rest ,b) (max m (length fixed))])) 0 defs))

(define (rt-declarations)
  (string-append
   "declare i64 @rt_alloc_words(i64)\n"
   "declare i64 @rt_cons(i64, i64)\n"
   "declare i64 @rt_car(i64)\n"
   "declare i64 @rt_cdr(i64)\n"
   "declare i64 @rt_box(i64)\n"
   "declare i64 @rt_unbox(i64)\n"
   "declare i64 @rt_set_box(i64, i64)\n"
   "declare i64 @rt_add(i64, i64)\n"
   "declare i64 @rt_sub(i64, i64)\n"
   "declare i64 @rt_mul(i64, i64)\n"
   "declare i64 @rt_div(i64, i64)\n"
   "declare i64 @rt_quotient(i64, i64)\n"
   "declare i64 @rt_remainder(i64, i64)\n"
   "declare i64 @rt_modulo(i64, i64)\n"
   "declare i64 @rt_num_eq(i64, i64)\n"
   "declare i64 @rt_lt(i64, i64)\n"
   "declare i64 @rt_flonum_lit(ptr)\n"
   "declare i64 @rt_string_to_flonum(i64)\n"
   "declare i64 @rt_flonum_to_string(i64)\n"
   "declare i64 @rt_flonum_p(i64)\n"
   "declare i64 @rt_number_p(i64)\n"
   "declare i64 @rt_real_p(i64)\n"
   "declare i64 @rt_inexact_p(i64)\n"
   "declare i64 @rt_exact_to_inexact(i64)\n"
   "declare i64 @rt_inexact_to_exact(i64)\n"
   "declare i64 @rt_write_char(i64)\n"
   "declare i64 @rt_null_p(i64)\n"
   "declare i64 @rt_pair_p(i64)\n"
   "declare i64 @rt_eq_p(i64, i64)\n"
   "declare i64 @rt_eqv_p(i64, i64)\n"
   "declare i64 @rt_equal(i64, i64)\n"
   "declare i64 @rt_not(i64)\n"
   "declare i64 @rt_intern(ptr)\n"
   "declare i64 @rt_make_string(ptr, i64)\n"
   "declare i64 @rt_char_to_integer(i64)\n"
   "declare i64 @rt_integer_to_char(i64)\n"
   "declare i64 @rt_string_length(i64)\n"
   "declare i64 @rt_string_ref(i64, i64)\n"
   "declare i64 @rt_substring(i64, i64, i64)\n"
   "declare i64 @rt_string_to_symbol(i64)\n"
   "declare i64 @rt_string_eq(i64, i64)\n"
   "declare i64 @rt_string_append(i64, i64)\n"
   "declare i64 @rt_symbol_to_string(i64)\n"
   "declare i64 @rt_list_to_string(i64)\n"
   "declare i64 @rt_make_string_fill(i64, i64)\n"
   "declare i64 @rt_string_set(i64, i64, i64)\n"
   "declare i64 @rt_string_copy(i64)\n"
   "declare i64 @rt_make_vector(i64, i64)\n"
   "declare i64 @rt_vector_ref(i64, i64)\n"
   "declare i64 @rt_vector_set(i64, i64, i64)\n"
   "declare i64 @rt_vector_length(i64)\n"
   "declare i64 @rt_vector_p(i64)\n"
   "declare i64 @rt_make_bytevector(i64, i64)\n"
   "declare i64 @rt_bytevector_u8_ref(i64, i64)\n"
   "declare i64 @rt_bytevector_u8_set(i64, i64, i64)\n"
   "declare i64 @rt_bytevector_length(i64)\n"
   "declare i64 @rt_bytevector_p(i64)\n"
   "declare i64 @rt_hash(i64)\n"
   "declare i64 @rt_make_hash_table(i64)\n"
   "declare i64 @rt_hash_table_p(i64)\n"
   "declare i64 @rt_hash_table_spine(i64)\n"
   "declare i64 @rt_make_record_type(i64)\n"
   "declare i64 @rt_make_record(i64, i64)\n"
   "declare i64 @rt_record_ref(i64, i64)\n"
   "declare i64 @rt_record_set(i64, i64, i64)\n"
   "declare i64 @rt_record_of_type_p(i64, i64)\n"
   "declare i64 @rt_record_p(i64)\n"
   "declare i64 @rt_list_to_mv(i64)\n"
   "declare i64 @rt_mv_p(i64)\n"
   "declare i64 @rt_mv_to_list(i64)\n"
   "declare i64 @rt_symbol_p(i64)\n"
   "declare i64 @rt_string_p(i64)\n"
   "declare i64 @rt_char_p(i64)\n"
   "declare i64 @rt_boolean_p(i64)\n"
   "declare i64 @rt_integer_p(i64)\n"
   "declare i64 @rt_exact_p(i64)\n"
   "declare i64 @rt_read_all_stdin()\n"
   "declare i64 @rt_no_prelude_p()\n"
   "declare i64 @rt_repl_mode()\n"
   "declare i64 @rt_repl_input()\n"
   "declare i64 @rt_repl_state_ref()\n"
   "declare i64 @rt_repl_state_set(i64)\n"
   "declare i64 @rt_root(i64)\n"
   "declare i64 @rt_display(i64)\n"
   "declare i64 @rt_write_val(i64)\n"
   "declare i64 @rt_newline()\n"
   "declare i64 @rt_list_length(i64)\n"
   "declare i64 @rt_build_rest(i64, i64, i64, ptr, ptr)\n"
   "declare ptr @rt_apply_argv(i64, ptr, i64, i64)\n"
   "declare void @rt_arity_error(i64, i64)\n"
   "declare i64 @rt_error(i64, i64)\n"
   "declare i64 @rt_raise(i64)\n"
   "declare i64 @rt_run_guarded(ptr, i64)\n"
   "declare i64 @rt_error_object_p(i64)\n"
   "declare i64 @rt_error_object_message(i64)\n"
   "declare i64 @rt_error_object_irritants(i64)\n\n"))

;; entry arity check: fixed callee requires argc == f, variadic requires
;; argc >= f; a mismatch calls rt_arity_error (which aborts).  Leaves emission
;; positioned in a fresh "ok" block.
(define (emit-arity-check f rest?)
  (let* ([ok (fresh-temp)] [errbb (fresh-bb "arityerr")] [okbb (fresh-bb "argok")])
    (emit! (string-append ok " = icmp " (if rest? "sge" "eq") " i64 %argc, " (number->string f)))
    (emit! (string-append "br i1 " ok ", label %" okbb ", label %" errbb))
    (start-bb errbb)
    (emit! (string-append "call void @rt_arity_error(i64 " (number->string f) ", i64 %argc)"))
    (emit! "unreachable")
    (start-bb okbb)))

;; variadic callee prologue: spill the K positional slots into an array and call
;; rt_build_rest to collect args [f, argc) (positional excess + overflow) into a
;; list.  Returns the operand holding that list.
(define (emit-build-rest f k)
  (let ([slots (emit-spill (map (lambda (i) (string-append "%a" (number->string i))) (iota k)))]
        [r (fresh-temp)])
    (emit! (string-append r " = call i64 @rt_build_rest(i64 %argc, i64 " (number->string f)
                          ", i64 " (number->string k) ", ptr " slots ", ptr %overflow)"))
    r))

(define (emit-code-def def k)
  (match def
    [(code ,label ,self ,fixed ,rest ,body)
     (set! emit-lines '()) (set! current-bb "entry")
     (let* ([f (length fixed)]
            [argdecls (comma-join
                        (append
                          (list "i64 %self" "i64 %argc")
                          (map (lambda (i) (string-append "i64 %a" (number->string i))) (iota k))
                          (list "ptr %overflow")))]
            [env0 (map (lambda (p i) (cons p (string-append "%a" (number->string i))))
                       fixed (iota f))])
       (start-bb "entry")
       (emit-arity-check f rest)                    ; then positioned in the ok block
       (let ([env (if rest
                      (cons (cons rest (emit-build-rest f k)) env0)  ; hot path: fixed only
                      env0)])
         (et body env "%self" #t))
       (string-append "define fastcc i64 " (label-operand label) "(" argdecls ") {\n"
                      (lines->string (reverse emit-lines)) "}\n\n"))]))

(define (emit-entry entry)
  (set! emit-lines '()) (set! current-bb "entry")
  (start-bb "entry")
  (et entry '() #f #f)                    ; ccc, no closure, regular calls
  (string-append "define i64 @scheme_entry() {\n" (lines->string (reverse emit-lines)) "}\n"))

(define (emit-program prog)
  (reset-emit!)
  (set! *emit-unit* program-unit)          ; a program's own globals are unprefixed
  (match prog
    [(program ,defs ,entry)
     (set! *arity* (max-arity defs))
     (reset-symbols!)
     ;; emit bodies first (populating the symbol-global accumulator), then
     ;; assemble with the private string constants prepended to the module.
     (let* ([body (apply string-append (map (lambda (d) (emit-code-def d *arity*)) defs))]
            [ent  (emit-entry entry)])
       (string-append (rt-declarations)
                      (symbol-globals)
                      body ent (emit-apply0-trampoline *arity*)))]))

;; --- REPL emission: persistent globals + per-form entry thunks ------------
;; In a persistent session, closures built by one form's module are called from
;; later forms' modules, so the shared closure arity K must be identical across
;; every module (design D6).  REPL emission therefore pins K to a session-wide
;; constant instead of the per-program max.
(define repl-arity 8)

;; The compilation unit whose top-level globals are being emitted (change:
;; module-resolution-scaffold).  The program / REPL unit is the empty prefix, so
;; global names are unchanged; Stage 1 sets it per library so a library's globals
;; carry its "L:" prefix.  Mirrors lower.ss's `*unit*` for code-block labels.
(define *emit-unit* program-unit)

;; LLVM global operand for a (generation-mangled, possibly non-identifier)
;; top-level symbol, named through `mangle` against the current emit unit (the
;; program/REPL unit is the empty prefix, so the operand is byte-identical).
;; Names are quoted so characters like ? ! - > are legal.
;;
;; An IMPORTED reference (change: module-generalize) already carries its exporter's
;; fully unit-qualified symbol (`b:add1`, containing the unit separator `:`), so it
;; must NOT be re-mangled against THIS unit -- else a library `(a)` referencing
;; `(b)`'s export would emit `@"a:b:add1"`.  A `:` is the unit separator (mirrors
;; label-has-colon? for code labels), so a symbol that already contains one is
;; emitted verbatim.  A unit's own names never contain `:` (they are plain names or
;; `x.gN` generations), so the program/single-unit cases stay byte-identical.
(define (global-operand s)
  (let ([str (if (symbol? s) (symbol->string s) s)])
    (if (label-has-colon? str)
        (string-append "@\"" str "\"")                      ; imported: already qualified
        (string-append "@\"" (mangle *emit-unit* s) "\"")))) ; own: qualify to this unit

;; Scan an L-code program for the persistent globals it defines (global-set!
;; targets) and references (global-ref / global-set! targets).
(define (repl-scan-globals prog)
  (let ([defd '()] [refd '()])
    (define (S e)
      (match e
        [(const ,d) (void)]
        [(local ,x) (void)]
        [(free-ref ,i) (void)]
        [(global-ref ,s) (set! refd (union refd (list s)))]
        [(global-set! ,s ,e) (set! defd (union defd (list s)))
                             (set! refd (union refd (list s))) (S e)]
        [(if ,a ,b ,c) (S a) (S b) (S c)]
        [(seq ,a ,b) (S a) (S b)]
        [(primcall ,op . ,args) (for-each S args)]
        [(let ,binds ,body) (for-each (lambda (b) (S (cadr b))) binds) (S body)]
        [(make-closure ,label ,caps) (for-each S caps)]
        [(closure-block ,entries ,body)
         (for-each (lambda (en) (for-each S (caddr en))) entries) (S body)]
        [(app ,f ,args) (S f) (for-each S args)]
        [(apply-app ,f ,args) (S f) (for-each S args)]
        [(self-app ,label ,args) (for-each S args)]))  ; label is static; no callee to walk
    (match prog
      [(program ,cdefs ,entry)
       (for-each (lambda (d) (match d [(code ,l ,self ,fixed ,rest ,body) (S body)])) cdefs)
       (S entry)])
    (list defd refd)))

(define (repl-check-arity prog)   ; enforce the pinned K (design D6)
  (match prog
    [(program ,cdefs ,entry)
     (for-each
       (lambda (d)
         (match d
           [(code ,l ,self ,fixed ,rest ,body)
            (when (> (length fixed) repl-arity)
              (error 'emit
                     (string-append "definition arity exceeds REPL max ("
                                    (number->string repl-arity) ")")
                     l))]))
       cdefs)]))

(define (emit-named-entry entry name)   ; ccc thunk @name returning the value
  (set! emit-lines '()) (set! current-bb "entry")
  (start-bb "entry")
  (et entry '() #f #f)
  (string-append "define i64 @" name "() {\n"
                 (lines->string (reverse emit-lines)) "}\n\n"))

;; Emit ONE module holding a whole session's worth of forms: every form's code
;; defs, one @__repl_N thunk per form, a single definition of each persistent
;; global slot, and a @scheme_entry that runs the thunks in order and returns
;; the last form's value.  This drives the batch-JIT validation of the
;; persistent-globals model (design D5 stage 1) with no separate-module linking.
;; The batch entry is @scheme_entry by default (the AOT/batch-JIT validators link
;; it against the runtime's main, which calls scheme_entry).  The interactive REPL
;; host, however, ALSO links the embedded compiler's own ccc @scheme_entry, so its
;; prelude batch needs a DISTINCT entry name or JIT->lookup would resolve to the
;; linked compiler instead of this module (change: repl-embedded-incremental).
;; emit-repl-batch-named takes that name; emit-repl-batch keeps the old default.
(define (emit-repl-batch progs) (emit-repl-batch-named progs "scheme_entry"))
(define (emit-repl-batch-named progs entry-name)
  (reset-emit!) (reset-symbols!)
  (set! *arity* repl-arity)
  (for-each repl-check-arity progs)
  (let loop ([ps progs] [n 1] [bodies '()] [thunks '()] [defd '()] [calls '()] [last #f])
    (if (null? ps)
        (let* ([slots (apply string-append
                        (map (lambda (s) (string-append (global-operand s)
                                                        " = global i64 0\n"))
                             defd))]
               [entry (string-append
                        "define i64 @" entry-name "() {\nentry:\n"
                        (apply string-append (reverse calls))
                        "  ret i64 " (or last "2") "\n}\n")])
          (string-append (rt-declarations) (symbol-globals) slots
                         (apply string-append (reverse bodies))
                         (apply string-append (reverse thunks))
                         entry (emit-apply0-trampoline repl-arity)))
        (let* ([prog (car ps)]
               [fd+rd (repl-scan-globals prog)]
               [fd (car fd+rd)] [rd (cadr fd+rd)])
          (match prog
            [(program ,cdefs ,e)
             (let* ([body (apply string-append
                            (map (lambda (d) (emit-code-def d repl-arity)) cdefs))]
                    [name (string-append "__repl_" (number->string n))]
                    [thunk (emit-named-entry e name)]
                    [r (string-append "%r" (number->string n))]
                    [call (string-append "  " r " = call i64 @" name "()\n")])
               (loop (cdr ps) (+ n 1)
                     (cons body bodies) (cons thunk thunks)
                     (union defd fd) (cons call calls) r))])))))

;; Emit ONE form as its own module for the persistent ORC/LLJIT host: globals it
;; defines get a slot definition, globals it only references (defined by earlier
;; forms) are declared `external` and resolve in the JIT to the module that
;; defined them.  The single entry thunk @__repl_N returns the form's value.
;; Returns (list module-text entry-name defined-globals).
;;
;; This referenced-but-not-defined -> `external global i64` path is exactly the
;; hook an `imported` binding reuses (change: module-resolution-scaffold): the
;; resolver names an imported reference as a (global-ref sym) into another unit's
;; slot, which is referenced-not-defined here and so lands in `external` below.
;; No imported bindings are produced in this change, so this stays unexercised
;; until Stage 1 populates imports.
(define (emit-repl-module prog n)
  (reset-emit!) (reset-symbols!)
  (set! *arity* repl-arity)
  (repl-check-arity prog)
  (let* ([defd+refd (repl-scan-globals prog)]
         [defd (car defd+refd)] [refd (cadr defd+refd)])
    (let ([external (diff refd defd)]
          [name (string-append "__repl_" (number->string n))])
      (match prog
        [(program ,cdefs ,entry)
         ;; emit bodies first so symbol-globals is populated before it is read
         (let* ([body  (apply string-append
                         (map (lambda (d) (emit-code-def d repl-arity)) cdefs))]
                [thunk (emit-named-entry entry name)]
                [exts  (apply string-append
                         (map (lambda (s) (string-append (global-operand s)
                                            " = external global i64\n"))
                              external))]
                [slots (apply string-append
                         (map (lambda (s) (string-append (global-operand s)
                                            " = global i64 0\n"))
                              defd))])
           (list (string-append (rt-declarations) exts slots (symbol-globals)
                                body thunk (emit-apply0-trampoline repl-arity))
                 name defd))]))))

;; ============================================================================
;; Module artifacts (change: module-artifacts-vertical-slice)
;; ============================================================================

;; @scheme_entry for a program that imports libraries: call each library's
;; one-shot @"L:__init" (declared external) before the program body, so every
;; imported global is populated before first use (generalizes emit-entry).
;; `init-libs` is the WHOLE transitive import closure in dependency (topological)
;; order (change: module-generalize) -- not just the direct imports -- so a
;; transitively-imported library is initialized before the dependent that uses it.
;; The one-shot @"L:__inited" guard makes a diamond's shared unit run once.
(define (emit-entry/inits entry init-libs)
  (set! emit-lines '()) (set! current-bb "entry")
  (start-bb "entry")
  (for-each
    (lambda (lib) (emit! (string-append "call i64 @\"" (mangle lib "__init") "\"()")))
    init-libs)
  (et entry '() #f #f)
  (string-append "define i64 @scheme_entry() {\n" (lines->string (reverse emit-lines)) "}\n"))

;; A program module that imports libraries.  Like emit-program, but pins the
;; closure arity K to repl-arity (the shared cross-module closure ABI, matching
;; the libraries' own K), declares each imported global `external`, declares each
;; closure library's __init, and runs those inits first in @scheme_entry.
;;   init-libs     : the transitive import closure in topological order (each a
;;                   list of symbol parts) -- every unit whose __init to call/declare
;;   imported-syms : mangled symbols the program references as externals (its DIRECT
;;                   imports' exports; transitive exports are not visible to it)
(define (emit-program-with-imports prog init-libs imported-syms)
  (reset-emit!)
  (set! *emit-unit* program-unit)          ; the program's own globals are unprefixed
  (match prog
    [(program ,defs ,entry)
     (set! *arity* repl-arity)
     (reset-symbols!)
     (let* ([body (apply string-append (map (lambda (d) (emit-code-def d *arity*)) defs))]
            [ent  (emit-entry/inits entry init-libs)]
            [gdecls (apply string-append
                      (map (lambda (s) (string-append (global-operand s) " = external global i64\n"))
                           imported-syms))]
            [idecls (apply string-append
                      (map (lambda (lib)
                             (string-append "declare i64 @\"" (mangle lib "__init") "\"()\n"))
                           init-libs))])
       (string-append (rt-declarations) gdecls idecls (symbol-globals)
                      body ent (emit-apply0-trampoline *arity*)))]))

;; Emit a library UNIT module for `library-name` from its lowered form-progs.
;; Mirrors emit-repl-batch-named, but every unit-owned symbol is qualified via
;; *emit-unit* (globals @"L:x", code labels @"L:code_N"); per-form init thunks are
;; qualified @"L:__init_N" (no cross-library collision); the aggregate entry is a
;; one-shot @"L:__init" guarded by @"L:__inited"; and there is NO @scheme_entry.
;; Globals get default (external) linkage so importers resolve them by name.
(define (emit-library-batch progs library-name)
  (reset-emit!) (reset-symbols!)
  (set! *emit-unit* library-name)
  (set! *arity* repl-arity)
  (for-each repl-check-arity progs)
  (let ([qop (lambda (nm) (string-append "@\"" (mangle library-name nm) "\""))])  ; @-operand
    (let loop ([ps progs] [n 1] [bodies '()] [thunks '()] [defd '()] [refd '()] [calls '()])
      (if (null? ps)
          ;; A transitively-imported global (change: module-generalize) is referenced
          ;; but not defined by this unit; declare it `external` so it resolves at
          ;; link/load time to the exporter.  For an import-free library `external`
          ;; is empty, so the emitted bytes are unchanged (Stage 1 byte-identity).
          (let* ([flag    (qop "__inited")]
                 [flagdef (string-append flag " = global i64 0\n")]
                 [external (diff refd defd)]
                 [exts    (apply string-append
                            (map (lambda (s) (string-append (global-operand s) " = external global i64\n"))
                                 external))]
                 [slots   (apply string-append
                            (map (lambda (s) (string-append (global-operand s) " = global i64 0\n"))
                                 defd))]
                 [init    (string-append
                            "define i64 " (qop "__init") "() {\n"
                            "entry:\n"
                            "  %f = load i64, ptr " flag "\n"
                            "  %c = icmp ne i64 %f, 0\n"
                            "  br i1 %c, label %already, label %run\n"
                            "already:\n"
                            "  ret i64 2\n"
                            "run:\n"
                            "  store i64 8, ptr " flag "\n"
                            (apply string-append (reverse calls))
                            "  ret i64 2\n}\n")])
            (string-append (rt-declarations) (symbol-globals) exts flagdef slots
                           (apply string-append (reverse bodies))
                           (apply string-append (reverse thunks))
                           init (emit-apply0-trampoline repl-arity)))
          (let* ([prog (car ps)]
                 [fd+rd (repl-scan-globals prog)]
                 [fd (car fd+rd)]
                 [rd (cadr fd+rd)])
            (match prog
              [(program ,cdefs ,e)
               (let* ([body  (apply string-append
                               (map (lambda (d) (emit-code-def d repl-arity)) cdefs))]
                      [tname (string-append "\""
                               (mangle library-name (string-append "__init_" (number->string n)))
                               "\"")]
                      [thunk (emit-named-entry e tname)]
                      [call  (string-append "  call i64 @" tname "()\n")])
                 (loop (cdr ps) (+ n 1)
                       (cons body bodies) (cons thunk thunks)
                       (union defd fd) (union refd rd) (cons call calls)))]))))))

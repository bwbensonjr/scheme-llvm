;;; emit.ss (tasks 5.1-5.4) -- lower L-code to textual LLVM IR (opaque ptrs).
;;;
;;; Value = i64 tagged word (matches src/runtime/runtime.c).  Every Scheme
;;; function shares ONE prototype so musttail is legal (LLVM requires matching
;;; caller/callee prototypes):
;;;   tailcc i64 (i64 self, i64 argc, i64 a0 ... i64 a{K-1}, ptr overflow)
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

(define (hex2 b)                  ; byte -> two uppercase hex digits
  (let ([s (number->string b 16)])
    (string-upcase (if (= (string-length s) 1) (string-append "0" s) s))))

;; escape a name for an LLVM c"..." literal; return (list escaped byte-count),
;; the count including the trailing NUL.  Printable ASCII except " and \ go
;; through verbatim; everything else (incl. UTF-8 bytes) as \XX.
(define (llvm-cstring name)
  (let* ([bv (string->utf8 name)] [n (bytevector-length bv)])
    (let loop ([i 0] [acc '()])
      (if (= i n)
          (list (apply string-append (reverse acc)) (+ n 1))
          (let ([b (bytevector-u8-ref bv i)])
            (loop (+ i 1)
                  (cons (if (and (>= b #x20) (<= b #x7e) (not (= b #x22)) (not (= b #x5c)))
                            (string (integer->char b))
                            (string-append "\\" (hex2 b)))
                        acc)))))))

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
    [(eq? d #t) "9"]                                          ; TRUE_V
    [(eq? d #f) "1"]                                          ; FALSE_V
    [(null? d) "2"]                                           ; NIL_V
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
    [(char? d)                                                ; Unicode codepoint
     (let ([t (fresh-temp)])
       (emit! (string-append t " = call i64 @rt_make_char(i64 "
                             (number->string (char->integer d)) ")"))
       t)]
    [(pair? d)                                                ; materialize at runtime
     (let* ([a  (encode-const (car d))]
            [dd (encode-const (cdr d))]
            [t  (fresh-temp)])
       (emit! (string-append t " = call i64 @rt_cons(i64 " a ", i64 " dd ")"))
       t)]
    [else (error 'emit "bad const" d)]))

(define prim-table
  '((+ "rt_add") (- "rt_sub") (* "rt_mul")
    (quotient "rt_quotient") (remainder "rt_remainder")
    (= "rt_num_eq") (< "rt_lt")
    (cons "rt_cons") (car "rt_car") (cdr "rt_cdr")
    (null? "rt_null_p") (pair? "rt_pair_p") (eq? "rt_eq_p")
    (eqv? "rt_eqv_p") (equal? "rt_equal") (not "rt_not")
    (box "rt_box") (unbox "rt_unbox") (set-box! "rt_set_box")
    (char->integer "rt_char_to_integer") (integer->char "rt_integer_to_char")
    (string-length "rt_string_length") (string-ref "rt_string_ref")
    (substring "rt_substring") (string->symbol "rt_string_to_symbol")
    (string=? "rt_string_eq") (string-append "rt_string_append")
    (symbol->string "rt_symbol_to_string") (list->string "rt_list_to_string")
    (make-string "rt_make_string_fill")
    (string-set! "rt_string_set") (string-copy "rt_string_copy")
    (make-vector "rt_make_vector") (vector-ref "rt_vector_ref")
    (vector-set! "rt_vector_set") (vector-length "rt_vector_length")
    (vector? "rt_vector_p")))

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
     (let ([op (ev e env cp tc?)])
       (emit! (string-append "store i64 " op ", ptr " (global-operand s)))
       op)]
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
     (emit-apply (ev f env cp tc?) (map (lambda (a) (ev a env cp tc?)) args) #f tc?)]
    [(app ,f ,args)
     (emit-app (ev f env cp tc?) (map (lambda (a) (ev a env cp tc?)) args) #f tc?)]))

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
    [(apply-app ,f ,args)
     (emit-apply (ev f env cp tc?) (map (lambda (a) (ev a env cp tc?)) args) #t tc?)]
    [(app ,f ,args)
     (emit-app (ev f env cp tc?) (map (lambda (a) (ev a env cp tc?)) args) #t tc?)]
    [else (emit! (string-append "ret i64 " (ev e env cp tc?)))]))

(define (ev-if a b c env cp tc?)
  (let ([tv (ev a env cp tc?)]
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
  (let ([tv (ev a env cp tc?)]
        [tl (fresh-bb "then")] [el (fresh-bb "else")] [cmp (fresh-temp)])
    (emit! (string-append cmp " = icmp ne i64 " tv ", 1"))
    (emit! (string-append "br i1 " cmp ", label %" tl ", label %" el))
    (start-bb tl) (et b env cp tc?)
    (start-bb el) (et c env cp tc?)))

(define (load-free cp i)
  (let ([b (fresh-temp)] [p (fresh-temp)] [g (fresh-temp)] [v (fresh-temp)])
    (emit! (string-append b " = and i64 " cp ", -8"))
    (emit! (string-append p " = inttoptr i64 " b " to ptr"))
    (emit! (string-append g " = getelementptr i64, ptr " p ", i64 " (number->string (+ i 1))))
    (emit! (string-append v " = load i64, ptr " g))
    v))

(define (emit-primcall op ops)
  (let ([entry (assq op prim-table)] [t (fresh-temp)])
    (unless entry (error 'emit "unknown prim" op))
    (emit! (string-append t " = call i64 @" (cadr entry) "(" (i64s ops) ")"))
    t))

;; allocate {code_ptr, cap...}, tag TAG_CLOSURE (4)
(define (emit-alloc-closure label caps-count)
  (let ([raw (fresh-temp)] [p (fresh-temp)])
    (emit! (string-append raw " = call i64 @rt_alloc_words(i64 " (number->string (+ caps-count 1)) ")"))
    (emit! (string-append p " = inttoptr i64 " raw " to ptr"))
    (emit! (string-append "store i64 ptrtoint (ptr @" label " to i64), ptr " p))
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
  (let ([b (fresh-temp)] [bp (fresh-temp)] [code (fresh-temp)] [fp (fresh-temp)])
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
          (emit! (string-append r " = " (if tc? "musttail " "") "call tailcc i64 " fp "(" callargs ")"))
          (emit! (string-append "ret i64 " r))
          #f)
        (begin
          (emit! (string-append r " = call tailcc i64 " fp "(" callargs ")"))
          r))))

;; spill i64 operands into a fresh GC-allocated array; returns a ptr operand.
(define (emit-spill ops)
  (let ([raw (fresh-temp)] [p (fresh-temp)] [len (length ops)])
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
   "declare i64 @rt_quotient(i64, i64)\n"
   "declare i64 @rt_remainder(i64, i64)\n"
   "declare i64 @rt_num_eq(i64, i64)\n"
   "declare i64 @rt_lt(i64, i64)\n"
   "declare i64 @rt_null_p(i64)\n"
   "declare i64 @rt_pair_p(i64)\n"
   "declare i64 @rt_eq_p(i64, i64)\n"
   "declare i64 @rt_eqv_p(i64, i64)\n"
   "declare i64 @rt_equal(i64, i64)\n"
   "declare i64 @rt_not(i64)\n"
   "declare i64 @rt_intern(ptr)\n"
   "declare i64 @rt_make_string(ptr, i64)\n"
   "declare i64 @rt_make_char(i64)\n"
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
   "declare i64 @rt_list_length(i64)\n"
   "declare i64 @rt_build_rest(i64, i64, i64, ptr, ptr)\n"
   "declare ptr @rt_apply_argv(i64, ptr, i64, i64)\n"
   "declare void @rt_arity_error(i64, i64)\n\n"))

;; entry arity check: fixed callee requires argc == f, variadic requires
;; argc >= f; a mismatch calls rt_arity_error (which aborts).  Leaves emission
;; positioned in a fresh "ok" block.
(define (emit-arity-check f rest?)
  (let ([ok (fresh-temp)] [errbb (fresh-bb "arityerr")] [okbb (fresh-bb "argok")])
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
       (string-append "define tailcc i64 @" label "(" argdecls ") {\n"
                      (lines->string (reverse emit-lines)) "}\n\n"))]))

(define (emit-entry entry)
  (set! emit-lines '()) (set! current-bb "entry")
  (start-bb "entry")
  (et entry '() #f #f)                    ; ccc, no closure, regular calls
  (string-append "define i64 @scheme_entry() {\n" (lines->string (reverse emit-lines)) "}\n"))

(define (emit-program prog)
  (reset-emit!)
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
                      body ent))]))

;; --- REPL emission: persistent globals + per-form entry thunks ------------
;; In a persistent session, closures built by one form's module are called from
;; later forms' modules, so the shared closure arity K must be identical across
;; every module (design D6).  REPL emission therefore pins K to a session-wide
;; constant instead of the per-program max.
(define repl-arity 8)

;; LLVM global operand for a (generation-mangled, possibly non-identifier)
;; top-level symbol.  Names are quoted so characters like ? ! - > are legal.
(define (global-operand s)
  (string-append "@\"" (symbol->string s) "\""))

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
        [(apply-app ,f ,args) (S f) (for-each S args)]))
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
(define (emit-repl-batch progs)
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
                        "define i64 @scheme_entry() {\nentry:\n"
                        (apply string-append (reverse calls))
                        "  ret i64 " (or last "2") "\n}\n")])
          (string-append (rt-declarations) (symbol-globals) slots
                         (apply string-append (reverse bodies))
                         (apply string-append (reverse thunks))
                         entry))
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
                                body thunk)
                 name defd))]))))

;;; toolchain.ss -- host-agnostic LLVM 22 + libgc locations for the compiler
;;; driver (compile.ss) and the pre-host REPL harness (test/repl.ss).
;;;
;;; A thin Scheme front over `tools/toolchain.sh` -- the single source of truth
;;; shared with the Makefile and the shell test harnesses -- so one override or
;;; discovery result governs every backend.  Overrides (env): LLVM_CONFIG /
;;; LLVM_PREFIX and GC_PREFIX (or GC_INC/GC_LIB).  See the openspec change
;;; `configurable-llvm-toolchain`.  Included, not imported, so it shares the
;;; driver's (chezscheme) environment; run from the repo root (like the rest of
;;; the driver's relative paths).

(define toolchain-script "tools/toolchain.sh")

(define (toolchain-trim s)
  (let* ([n (string-length s)]
         [a (let lp ([i 0])
              (if (and (< i n) (char-whitespace? (string-ref s i))) (lp (+ i 1)) i))]
         [b (let lp ([i n])
              (if (and (> i a) (char-whitespace? (string-ref s (- i 1)))) (lp (- i 1)) i))])
    (substring s a b)))

(define (toolchain-make-tempfile)
  (let* ([p (process "mktemp")] [name (get-line (car p))])
    (close-port (car p)) (close-port (cadr p))
    name))

(define (toolchain-read-all port)
  (let loop ([acc '()])
    (let ([ln (get-line port)])
      (if (eof-object? ln)
          (apply string-append (reverse acc))
          (loop (cons (string-append ln "\n") acc))))))

;; Run `tools/toolchain.sh QUERY` and return its trimmed stdout.  On failure the
;; script prints an actionable message to stderr and exits non-zero, yielding
;; empty stdout; we raise with that message so the compile stops.  Chez `process`
;; merges the child's stderr into the stdout pipe, so we redirect the script's
;; stderr to a temp file to keep the value (stdout) and the diagnostic separate.
(define (toolchain-query query)
  (let* ([errf  (toolchain-make-tempfile)]
         [pipes (process (string-append toolchain-script " " query " 2>" errf))]
         [from  (car pipes)]
         [to    (cadr pipes)])
    (close-port to)
    (let ([out (toolchain-read-all from)])
      (close-port from)
      (let ([v (toolchain-trim out)])
        (if (> (string-length v) 0)
            (begin (delete-file errf) v)
            (let ([msg (toolchain-trim (call-with-input-file errf get-string-all))])
              (delete-file errf)
              (error 'toolchain
                     (string-append "could not resolve '" query "'"
                                    (if (> (string-length msg) 0)
                                        (string-append ":\n" msg)
                                        (string-append " -- run `" toolchain-script " check`"))))))))))

;; libgc is needed by every backend (including AOT), so resolve eagerly.
(define gc-inc    (toolchain-query "gc-inc"))
(define gc-lib    (toolchain-query "gc-lib"))
(define gc-shared (toolchain-query "gc-shared"))

;; The LLVM 22 tool dir is needed only by JIT/bitcode/REPL; resolve lazily and
;; memoize, so AOT-only use on a host without the LLVM 22 dev tools still works.
(define %llvm-bin #f)
(define (llvm-bin)
  (or %llvm-bin
      (let ([b (string-append (toolchain-query "llvm-bindir") "/")])
        (set! %llvm-bin b) b)))

;; AOT C compiler + host-triple probe: system clang if present, else the
;; resolved LLVM 22 clang (see design D4).  Lazy + memoized.
(define %cc #f)
(define (cc)
  (or %cc (let ([c (toolchain-query "cc")]) (set! %cc c) c)))

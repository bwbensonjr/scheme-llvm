;;; compile.ss -- driver for the core-lambda-slice compiler.
;;;
;;; Usage (run from the repo root):
;;;   chez --libdirs src --script src/compile.ss SRC.scm [-o OUT] [--dump]
;;;
;;; Reads the top-level forms from SRC.scm (a sequence of `define`s and
;;; expressions), runs the pipeline (dumping the IL after each stage to stderr
;;; with --dump), emits OUT.ll, and links it with the C runtime + libgc into the
;;; executable OUT.

(import (chezscheme) (match) (util))

;; The pure forms->IR core (reader/expander/passes/emit) lives in core.ss.  This
;; file is the driver: it owns every effect -- file reads/writes, the host target
;; header, and the toolchain/JIT -- and delegates the forms->IR step to the core.
(include "src/core.ss")

(define runtime-c "src/runtime/runtime.c")
(define gc-inc "/opt/homebrew/include")
(define gc-lib "/opt/homebrew/lib")

;; Module header: the `target datalayout`/`target triple` lines for the host.
;; Without them clang fills in its own effective triple when it loads our IR and
;; warns (-Woverride-module).  We ask the system clang what it would emit for an
;; empty translation unit -- the canonical, portable way to learn the host's
;; exact triple (which -print-target-triple does not report on macOS).
(define (host-target-header)
  (let* ([pipes (process "clang -S -emit-llvm -x c -o - - 2>/dev/null")]
         [from (car pipes)]
         [to   (cadr pipes)])
    (put-string to "int __scheme_llvm_probe;\n")
    (close-port to)
    (let loop ([acc '()])
      (let ([ln (get-line from)])
        (cond
          [(eof-object? ln)
           (close-port from)
           (apply string-append (reverse acc))]
          [(and (>= (string-length ln) 7) (string=? (substring ln 0 7) "target "))
           (loop (cons (string-append ln "\n") acc))]
          [else (loop acc)])))))

(define (read-program path)   ; -> ordered list of all top-level forms (file I/O)
  (let* ([p (open-input-file path)]
         [forms (read-forms p)])
    (close-port p)
    forms))

(define (dump stage form)
  (fprintf (current-error-port) ";; ==== after ~a ====\n" stage)
  (pretty-print form (current-error-port))
  (newline (current-error-port)))

;; --- prelude (standard library prepended to every program) ---------------
;; The prelude is a *file*, so reading it is the driver's job; the pure core's
;; `with-prelude` merges the already-read forms (user-wins shadowing).
(define prelude-path "src/prelude.scm")

;; Read source (+ prelude) and assemble the ordered form list the core compiles.
(define (program-forms src prelude?)
  (let ([user-forms (read-program src)])
    (if prelude?
        (with-prelude (read-program prelude-path) user-forms)
        user-forms)))

;; --- optional self-hosted forms->IR via a compiled `schemec` (path C, D4) --
;; When enabled (env SCHEMEC=<path> or --via-schemec), the forms->IR step shells
;; out to the compiled `schemec` (a text->IR filter) instead of running the core
;; in-process.  The driver still owns everything else: it merges the prelude
;; (with-prelude), then serializes the already-merged forms to text on schemec's
;; stdin and reads the emitted core IR from its stdout.  `schemec` prepends no
;; prelude and no target header -- those stay the driver's job.  The in-process
;; path is retained (it builds schemec, and is the default/fallback).
(define default-schemec "build/schemec")
(define (schemec-binary) (or (getenv "SCHEMEC") default-schemec))

;; forms (already prelude-merged) -> IR text, via the schemec co-process.  Write
;; every form then close stdin; schemec reads to EOF, compiles, writes IR to
;; stdout.  It reads all input before emitting, so write-then-read cannot
;; deadlock on the pipe.
(define (forms->ir-via-schemec forms)
  ;; Chez `process` merges the child's stderr into the stdout pipe, which would
  ;; corrupt the captured IR; send schemec's stderr to /dev/null (a compile error
  ;; there surfaces as empty IR and a downstream clang failure).
  (let* ([pipes (process (string-append (schemec-binary) " 2>/dev/null"))]
         [from (car pipes)] [to (cadr pipes)])
    (for-each (lambda (f) (write f to) (newline to)) forms)
    (close-port to)
    (let ([ir (get-string-all from)])
      (close-port from)
      ir)))

;; Driver: assemble forms, run forms->IR (in-process core, or schemec when
;; via?), prepend the host target header, and write the .ll.  The header (a
;; clang subprocess) is an effect and stays here so the core stays host-agnostic.
(define (compile-file src ll dump? prelude? via?)
  (let* ([forms (program-forms src prelude?)]
         [ir    (if via?
                    (forms->ir-via-schemec forms)
                    (compile-forms forms (if dump? dump no-dump)))]
         [text  (string-append (host-target-header) ir)])
    (let ([out (open-output-file ll 'replace)]) (display text out) (close-port out))))

;; --- backends -----------------------------------------------------------
;; One emitted OUT.ll drives three exits.  AOT stays on the system clang
;; (unchanged).  The JIT and bitcode exits use the pinned LLVM 22 tools by
;; absolute path (Homebrew keg, off PATH).
(define llvm-bin "/opt/homebrew/opt/llvm@22/bin/")
(define (tool t) (string-append llvm-bin t))
(define gc-dylib (string-append gc-lib "/libgc.dylib"))
(define (sh who cmd)
  (unless (zero? (system cmd)) (error 'compile (string-append who " failed") cmd)))

(define (require-llvm-tools)
  (for-each
    (lambda (t)
      (unless (file-exists? (tool t))
        (error 'compile
               (string-append "required LLVM 22 tool not found: " (tool t)
                              "  (install with: brew install llvm@22)"))))
    '("lli" "llvm-as" "llvm-link" "clang")))

;; AOT (default): textual IR -> native exe via the system clang.  Unchanged.
(define (link ll exe)
  (sh "clang" (string-append "clang -I" gc-inc " -L" gc-lib " " runtime-c " " ll " -lgc -o " exe)))

;; Bitcode: assemble OUT.ll -> OUT.bc (the inspectable/opt-able artifact),
;; then codegen the .bc + runtime to a native exe (LLVM 22 clang).
(define (emit-bitcode ll bc)
  (sh "llvm-as" (string-append (tool "llvm-as") " " ll " -o " bc)))
(define (build-bitcode-exe bc exe)
  (sh "clang(bc)"
      (string-append (tool "clang") " -I" gc-inc " -L" gc-lib " " runtime-c " " bc " -lgc -o " exe)))

;; JIT: assemble the program, compile the runtime to bitcode, llvm-link them
;; (so the C main + rt_* join the module), and run in-process via lli with
;; libgc loaded.  lli executes the linked module's main.
(define (run-jit ll base)
  (let ([pbc (string-append base ".bc")]
        [rbc (string-append base ".rt.bc")]
        [cbc (string-append base ".combined.bc")])
    (sh "llvm-as"    (string-append (tool "llvm-as") " " ll " -o " pbc))
    (sh "clang-emit" (string-append (tool "clang") " -I" gc-inc " -emit-llvm -c " runtime-c " -o " rbc))
    (sh "llvm-link"  (string-append (tool "llvm-link") " " pbc " " rbc " -o " cbc))
    (sh "lli"        (string-append (tool "lli") " -load=" gc-dylib " " cbc))))

(define (strip-ext s)
  (let ([i (let loop ([i (- (string-length s) 1)])
             (cond [(< i 0) #f] [(char=? (string-ref s i) #\.) i] [else (loop (- i 1))]))])
    (if i (substring s 0 i) s)))

;; --- interactive REPL over the persistent ORC/LLJIT host ----------------
;; Drives build/repl-host as a co-process: read a form, run it through the same
;; expander/lowering/emit as batch (but one form at a time, against a persistent
;; REPL env + growing macro env), frame the module, send it, and print the value
;; the host returns.  A form that fails to compile is reported and dropped, with
;; all session state rolled back so the next form is unaffected.
(define repl-host-path "build/repl-host")

;; Rebuild the host whenever the runtime/host sources or the recipe changed, not
;; merely when the binary is missing: the host links a runtime snapshot and the
;; JIT resolves rt_* from the host process, so a stale binary silently lacks any
;; rt_* added since it was built (change: fix-stale-repl-host-rebuild).  `make`
;; no-ops when the host is already up to date.
(define (ensure-host)
  (unless (zero? (system "make build/repl-host 1>&2"))
    (error 'repl "failed to build the REPL host")))

(define (repl-frame text name)          ; host wire frame: "<name> <bytes>\n<ir>"
  (string-append name " "
                 (number->string (bytevector-length (string->utf8 text))) "\n"
                 text))

(define (condition->string e)
  (with-output-to-string (lambda () (display-condition e))))

;; `repl-lcode` (the shared back half of the pipeline for one core-IL
;; expression) lives in core.ss -- it is the entry point the REPL overlaps with.
(define (run-repl prelude?)
  (ensure-host)
  (reset-counter!)
  ;; Chez `process` merges the child's stderr into the stdout pipe, which would
  ;; desync our line-per-result framing; send the host's stderr to /dev/null (it
  ;; reports trap detail on stdout via rt_trap_msg instead).
  (let* ([pipes (process (string-append repl-host-path " 2>/dev/null"))]
         [from  (car pipes)]
         [to    (cadr pipes)]
         [err   (current-error-port)]
         [env   (make-repl-env)])
    (let ([macro-env '()]
          [known (union* (list *core-keywords* *prims* *extra-op-keywords*))]
          [n 0])
      (define (send-frame! text name)   ; -> the host's one-line result
        (put-string to (repl-frame text name))
        (flush-output-port to)
        (get-line from))
      (define (note-syntax! form)       ; register a define-syntax in the session
        (set! macro-env (cons (parse-define-syntax form) macro-env))
        (set! known (cons (cadr form) known)))
      ;; expand a define's INIT (not its raw signature -- expanding the raw form
      ;; would treat a dotted param list like `(f . xs)` as an application), then
      ;; rebuild a simple `(define name expanded-init)`; expand any other form
      ;; whole.
      (define (expand-form form)
        (if (define-form? form)
            (let ([nd (normalize-define form)])
              `(define ,(car nd) ,(expand (cadr nd) macro-env known)))
            (expand form macro-env known)))
      ;; process one interactive form; snapshot + roll back all session state on
      ;; a compile error so a bad form never corrupts the session.
      (define (feed form)
        (let ([s0 (vector-ref env 0)] [s1 (vector-ref env 1)]
              [sme macro-env] [sk known] [sn n])
          (guard (e (#t (vector-set! env 0 s0) (vector-set! env 1 s1)
                        (set! macro-env sme) (set! known sk) (set! n sn)
                        (fprintf err "error: ~a\n" (condition->string e))))
            (cond
              [(define-syntax-form? form)
               (note-syntax! form)
               (fprintf err ";; syntax ~a\n" (cadr form))]
              [else
               (let ([dn (define-name form)])
                 (when dn (set! known (cons dn known)))
                 (let ([lc (repl-lcode (repl-lower-form env (expand-form form)))])
                   (let* ([m (emit-repl-module lc (+ n 1))]
                          [text (car m)] [name (cadr m)] [defd (caddr m)])
                     (set! n (+ n 1))
                     (let ([result (send-frame! text name)])
                       (when (eof-object? result)
                         (fprintf err "host terminated unexpectedly\n") (exit 1))
                       (display result) (newline)
                       (flush-output-port (current-output-port))))))]))))
      ;; Load the standard library as ONE mutually-recursive group: collect its
      ;; macros, pre-register every define name (so forward/mutual references
      ;; resolve), lower each body reusing those symbols, and emit a single
      ;; combined module (emit-repl-batch) whose globals later forms resolve
      ;; against.  A single module is required: splitting a recursive group into
      ;; per-form modules would reference a slot before its defining module was
      ;; added to the JIT.
      (define (load-prelude!)
        (let ([forms (read-program prelude-path)])
          (for-each
            (lambda (f)
              (cond [(define-syntax-form? f) (note-syntax! f)]
                    [(define-form? f)
                     (set! known (cons (define-name f) known))
                     (repl-register-define! env f)]))
            forms)
          (let ([progs (fold-left
                         (lambda (acc f)
                           (if (define-form? f)
                               (cons (repl-lcode (repl-lower-form* env (expand-form f) #f)) acc)
                               acc))
                         '() forms)])
            (send-frame! (emit-repl-batch (reverse progs)) "scheme_entry")
            ;; the combined module used @__repl_1..N internally; start interactive
            ;; thunks above that range so their names don't collide in the JIT.
            (set! n (length progs)))))
      (when prelude? (load-prelude!))
      (fprintf err "scheme-llvm REPL (persistent ORC/LLJIT host).  ^D to exit.\n")
      (let loop ()
        (fprintf err "scheme> ") (flush-output-port err)
        (let ([form (read)])
          (if (eof-object? form)
              (begin (fprintf err "\n") (close-port to) (exit 0))
              (begin (feed form) (loop))))))))

;; --- core filter mode: stdin source text -> stdout IR text ---------------
;; The self-hosting-facing shape of the core (design D2): read all of stdin as
;; source, run the pure pipeline, and write IR to stdout.  The target header and
;; toolchain are intentionally left to the driver/host, so a future self-hosted
;; core runs as a plain text filter without any filesystem/subprocess surface.
(define (emit-ir-filter prelude?)
  (let* ([user-forms (read-forms (current-input-port))]
         [forms (if prelude?
                    (with-prelude (read-program prelude-path) user-forms)
                    user-forms)]
         [ir (compile-forms forms no-dump)])
    (display ir (current-output-port))
    (flush-output-port (current-output-port))))

;; --- argument handling ---
;; `via?` (env SCHEMEC=<path> or --via-schemec) routes the batch forms->IR step
;; through the compiled `schemec` (path C, D4) instead of the in-process core.
(define (main args)
  (let loop ([args args] [src #f] [out #f] [dump? #f] [backend "aot"] [prelude? #t]
             [repl? #f] [emit-ir? #f] [via? (and (getenv "SCHEMEC") #t)])
    (cond
      [(null? args)
       (cond
         [repl? (run-repl prelude?)]
         [emit-ir? (emit-ir-filter prelude?)]
         [else
          (unless src (error 'compile "usage: compile.ss SRC.scm [-o OUT] [--dump] [--backend aot|jit|bitcode] [--no-prelude] [--via-schemec]\n   or: compile.ss --repl [--no-prelude]\n   or: compile.ss --emit-ir [--no-prelude] < SRC.scm  (IR text on stdout)\n   (--via-schemec / env SCHEMEC=<path>: run forms->IR through the compiled schemec)"))
          (let* ([out (or out (strip-ext src))] [ll (string-append out ".ll")])
            (compile-file src ll dump? prelude? via?)
            (case (string->symbol backend)
              [(aot)
               (link ll out)
               (fprintf (current-error-port) "wrote ~a and ~a~a\n" ll out (if via? " (via schemec)" ""))]
              [(bitcode)
               (require-llvm-tools)
               (let ([bc (string-append out ".bc")])
                 (emit-bitcode ll bc)
                 (build-bitcode-exe bc out)
                 (fprintf (current-error-port) "wrote ~a, ~a and ~a\n" ll bc out))]
              [(jit)
               (require-llvm-tools)
               (run-jit ll out)]
              [else (error 'compile "unknown backend (want aot|jit|bitcode)" backend)]))])]
      [(string=? (car args) "-o") (loop (cddr args) src (cadr args) dump? backend prelude? repl? emit-ir? via?)]
      [(string=? (car args) "--dump") (loop (cdr args) src out #t backend prelude? repl? emit-ir? via?)]
      [(string=? (car args) "--backend") (loop (cddr args) src out dump? (cadr args) prelude? repl? emit-ir? via?)]
      [(string=? (car args) "--no-prelude") (loop (cdr args) src out dump? backend #f repl? emit-ir? via?)]
      [(string=? (car args) "--repl") (loop (cdr args) src out dump? backend prelude? #t emit-ir? via?)]
      [(string=? (car args) "--emit-ir") (loop (cdr args) src out dump? backend prelude? repl? #t via?)]
      [(string=? (car args) "--via-schemec") (loop (cdr args) src out dump? backend prelude? repl? emit-ir? #t)]
      [else (loop (cdr args) (car args) out dump? backend prelude? repl? emit-ir? via?)])))

(main (command-line-arguments))

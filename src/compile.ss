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

(include "src/parse.ss")
(include "src/passes/expand.ss")
(include "src/passes/recognize-let.ss")
(include "src/passes/convert-assignments.ss")
(include "src/passes/convert-closures.ss")
(include "src/passes/lower.ss")
(include "src/emit.ss")

(define runtime-c "src/runtime/runtime.c")
(define gc-inc "/opt/homebrew/include")
(define gc-lib "/opt/homebrew/lib")

(define (read-program path)   ; -> ordered list of all top-level forms
  (let ([p (open-input-file path)])
    (let loop ([forms '()])
      (let ([e (read p)])
        (if (eof-object? e)
            (begin (close-port p) (reverse forms))
            (loop (cons e forms)))))))

(define (dump stage form)
  (fprintf (current-error-port) ";; ==== after ~a ====\n" stage)
  (pretty-print form (current-error-port))
  (newline (current-error-port)))

(define (compile-file src ll dump?)
  (reset-counter!)
  (let* ([top   (collect-toplevel (read-program src))]
         [expd  (expand top)]
         [core  (rename-program (parse-program expd))]
         [a     (recognize-let core)]
         [b     (convert-assignments a)]
         [c     (convert-closures b)]
         [d     (lower-program c)]
         [text  (emit-program d)])
    (when dump?
      (dump "collect-toplevel" top) (dump "expand" expd)
      (dump "parse+rename" core) (dump "recognize-let" a)
      (dump "convert-assignments" b) (dump "convert-closures" c) (dump "lower" d))
    (let ([out (open-output-file ll 'replace)]) (display text out) (close-port out))))

(define (link ll exe)
  (let ([cmd (string-append "clang -I" gc-inc " -L" gc-lib " " runtime-c " " ll " -lgc -o " exe)])
    (unless (zero? (system cmd)) (error 'compile "clang failed" cmd))))

(define (strip-ext s)
  (let ([i (let loop ([i (- (string-length s) 1)])
             (cond [(< i 0) #f] [(char=? (string-ref s i) #\.) i] [else (loop (- i 1))]))])
    (if i (substring s 0 i) s)))

;; --- argument handling ---
(define (main args)
  (let loop ([args args] [src #f] [out #f] [dump? #f])
    (cond
      [(null? args)
       (unless src (error 'compile "usage: compile.ss SRC.scm [-o OUT] [--dump]"))
       (let* ([out (or out (strip-ext src))] [ll (string-append out ".ll")])
         (compile-file src ll dump?)
         (link ll out)
         (fprintf (current-error-port) "wrote ~a and ~a\n" ll out))]
      [(string=? (car args) "-o") (loop (cddr args) src (cadr args) dump?)]
      [(string=? (car args) "--dump") (loop (cdr args) src out #t)]
      [else (loop (cdr args) (car args) out dump?)])))

(main (command-line-arguments))

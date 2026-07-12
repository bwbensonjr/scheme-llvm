;;; repl-batch.ss -- TEMPORARY driver (change: interactive-repl, Group 3).
;;;
;;; Validates the persistent-globals model on the EXISTING batch JIT/AOT before
;;; the ORC/LLJIT host exists (design D5 stage 1).  It treats each top-level
;;; form of SRC.scm as a separate REPL entry, lowers each against one persistent
;;; REPL env, and emits a single module whose @scheme_entry runs the per-form
;;; thunks in order and returns the last form's value.  Build the emitted .ll
;;; with clang + the C runtime exactly like the AOT backend.
;;;
;;; Remove once the ORC/LLJIT host (Group 4) supersedes it (task 3.3).
;;;
;;; Usage: chez --libdirs src --script test/repl-batch.ss SRC.scm -o OUT.ll

(import (chezscheme) (match) (util))
(include "src/parse.ss")
(include "src/passes/recognize-let.ss")
(include "src/passes/convert-assignments.ss")
(include "src/passes/convert-closures.ss")
(include "src/passes/lower.ss")
(include "src/emit.ss")

;; host datalayout/triple (mirrors compile.ss host-target-header)
(define (host-target-header)
  (let* ([pipes (process "clang -S -emit-llvm -x c -o - - 2>/dev/null")]
         [from (car pipes)] [to (cadr pipes)])
    (put-string to "int __scheme_llvm_probe;\n")
    (close-port to)
    (let loop ([acc '()])
      (let ([ln (get-line from)])
        (cond
          [(eof-object? ln) (close-port from) (apply string-append (reverse acc))]
          [(and (>= (string-length ln) 7) (string=? (substring ln 0 7) "target "))
           (loop (cons (string-append ln "\n") acc))]
          [else (loop acc)])))))

(define (read-forms path)
  (let ([p (open-input-file path)])
    (let loop ([fs '()])
      (let ([e (read p)])
        (if (eof-object? e)
            (begin (close-port p) (reverse fs))
            (loop (cons e fs)))))))

;; one REPL entry -> L-code (mutates env; must run in order)
(define (form->lcode env form)
  (lower-program
    (convert-closures
      (convert-assignments
        (recognize-let
          (repl-lower-form env form))))))

(define (main args)
  (let loop ([args args] [src #f] [out #f])
    (cond
      [(null? args)
       (unless (and src out)
         (error 'repl-batch "usage: repl-batch.ss SRC.scm -o OUT.ll"))
       (reset-counter!)
       (let* ([env   (make-repl-env)]
              [forms (read-forms src)]
              ;; left-to-right: env generations + fresh-name order must be stable
              [progs (let lp ([fs forms] [acc '()])
                       (if (null? fs) (reverse acc)
                           (lp (cdr fs) (cons (form->lcode env (car fs)) acc))))]
              [text  (string-append (host-target-header) (emit-repl-batch progs))]
              [o     (open-output-file out 'replace)])
         (display text o) (close-port o)
         (fprintf (current-error-port) "wrote ~a\n" out))]
      [(string=? (car args) "-o") (loop (cddr args) src (cadr args))]
      [else (loop (cdr args) (car args) out)])))

(main (command-line-arguments))

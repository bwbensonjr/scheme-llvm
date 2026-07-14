;;; repl-frames.ss -- emit a session as ORC-host frames (change: interactive-repl).
;;;
;;; Treats each top-level form of SRC.scm as a separate REPL entry, emits each as
;;; its own module (emit-repl-module), and writes the host wire protocol to
;;; stdout:  "<entry-symbol> <byte-count>\n" then <byte-count> bytes of IR.
;;; Pipe into build/repl-host to exercise the persistent JIT end-to-end:
;;;
;;;   chez --libdirs src --script test/repl-frames.ss SRC.scm | build/repl-host
;;;
;;; This is a batch stand-in for the Group 5 interactive driver's transport.

(import (chezscheme) (match) (util))
(include "src/parse.ss")
(include "src/passes/recognize-let.ss")
(include "src/passes/convert-assignments.ss")
(include "src/passes/convert-closures.ss")
(include "src/passes/lower.ss")
(include "src/emit.ss")

(define (read-forms path)
  (let ([p (open-input-file path)])
    (let loop ([fs '()])
      (let ([e (read p)])
        (if (eof-object? e)
            (begin (close-port p) (reverse fs))
            (loop (cons e fs)))))))

(define (form->lcode env form)
  (lower-program
    (convert-closures
      (convert-assignments
        (recognize-let
          (repl-lower-form env form))))))

(define (main args)
  (when (null? args) (error 'repl-frames "usage: repl-frames.ss SRC.scm"))
  (reset-counter!)
  (let ([env (make-repl-env)]
        [bout (standard-output-port)])            ; binary: exact byte framing
    (let loop ([forms (read-forms (car args))] [n 1])
      (unless (null? forms)
        (let* ([m (emit-repl-module (form->lcode env (car forms)) n)]
               [text (car m)] [name (cadr m)] [defd (caddr m)])
          (let ([bv (string->utf8 text)])
            (put-bytevector bout (string->utf8
                                   (string-append name " "
                                     (number->string (bytevector-length bv)) "\n")))
            (put-bytevector bout bv)))
        (loop (cdr forms) (+ n 1))))
    (flush-output-port bout)))

(main (command-line-arguments))

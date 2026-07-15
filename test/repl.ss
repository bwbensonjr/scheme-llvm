;;; repl.ss -- interactive REPL for testing the persistent-globals model
;;; BEFORE the ORC/LLJIT host (Group 4) exists.
;;;
;;; Strategy (design's "recompile the whole session" stopgap): keep every
;;; entered form, and on each new entry re-lower the whole session against one
;;; fresh REPL env, emit the combined module (emit-repl-batch), build it with
;;; clang + the C runtime, run it, and print the newest form's value.  This is
;;; O(n^2) and re-runs side effects each entry, but the only observable in the
;;; M1 subset is the final value, so the interactive behavior is faithful.  The
;;; Group 4 ORC host replaces this with genuine incremental persistence.
;;;
;;; Usage (from the repo root):
;;;   chez --libdirs src --script test/repl.ss
;;; A form that fails to compile is reported and dropped from the session.

(import (chezscheme))
(include "src/match.scm")           ; flat source (change: self-hosting-completion)
(include "src/util.scm")
(include "src/parse.ss")
(include "src/passes/recognize-let.ss")
(include "src/passes/convert-assignments.ss")
(include "src/passes/convert-closures.ss")
(include "src/passes/lower.ss")
(include "src/emit.ss")

(define runtime-c "src/runtime/runtime.c")
(define gc-inc "/opt/homebrew/include")
(define gc-lib "/opt/homebrew/lib")

(define err-port (current-error-port))

;; a scratch working directory for the .ll / exe / captured output
(define workdir
  (let* ([p (process "mktemp -d")] [d (get-line (car p))])
    (close-port (car p)) (close-port (cadr p)) d))
(define ll-path  (string-append workdir "/s.ll"))
(define exe-path (string-append workdir "/s"))
(define out-path (string-append workdir "/out"))
(define cc-path  (string-append workdir "/cc.err"))

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

(define (read-file path)
  (call-with-input-file path get-string-all))

(define (form->lcode env form)
  (lower-program
    (convert-closures
      (convert-assignments
        (recognize-let
          (repl-lower-form env form))))))

;; lower + emit + build + run the whole session.  Returns (values status text):
;;   status 'ok    -> text is the program's printed output
;;   status 'error -> text is the emit or clang error message
(define (run-session forms)
  (guard (e (#t (values 'error
                  (with-output-to-string (lambda () (display-condition e))))))
    (reset-counter!)
    (let* ([env   (make-repl-env)]
           [progs (let lp ([fs forms] [acc '()])          ; strict left-to-right
                    (if (null? fs) (reverse acc)
                        (lp (cdr fs) (cons (form->lcode env (car fs)) acc))))]
           [text  (string-append (host-target-header) (emit-repl-batch progs))])
      (call-with-output-file ll-path (lambda (o) (display text o)) 'replace)
      (if (zero? (system (string-append
                           "clang -I" gc-inc " -L" gc-lib " " runtime-c " "
                           ll-path " -lgc -o " exe-path " 2> " cc-path)))
          (begin (system (string-append exe-path " > " out-path))
                 (values 'ok (read-file out-path)))
          (values 'error (read-file cc-path))))))

(define (repl)
  (fprintf err-port "Emit REPL (recompile-all mode; pre-Group-4).  ^D to exit.\n")
  (let loop ([hist '()])
    (fprintf err-port "scheme> ") (flush-output-port err-port)
    (let ([form (read)])
      (if (eof-object? form)
          (begin (fprintf err-port "\n") (exit 0))
          (let-values ([(status text) (run-session (append hist (list form)))])
            (cond
              [(eq? status 'ok)
               (display text)                      ; program prints value + newline
               (flush-output-port (current-output-port))
               (loop (append hist (list form)))]   ; keep the accepted form
              [else
               (fprintf err-port "error: ~a\n" text)
               (loop hist)]))))))                   ; drop the bad form

(repl)

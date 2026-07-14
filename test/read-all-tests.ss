;;; Unit tests for read-all-from-string (change: stdin-source-reader).
;;;
;;; The in-language reader in src/prelude.scm is written in the common subset, so
;;; it loads and runs directly under Chez.  We check the whole-program read on
;;; the spec scenarios (multi-form source, comments/whitespace, empty input) and
;;; cross-check its form list against Chez's own `read` over a sample file.
;;; Run from the repo root: chez --script test/read-all-tests.ss
(load "src/prelude.scm")

(define pass 0)
(define fail 0)
(define (check name got want)
  (if (equal? got want)
      (begin (set! pass (+ pass 1)) (printf "  [OK  ] ~a\n" name))
      (begin (set! fail (+ fail 1))
             (printf "  [FAIL] ~a\n         got:  ~s\n         want: ~s\n" name got want))))

(printf "read-all-from-string tests\n")

;; multi-form source: defines + a trailing expression
(check 'multi-form
  (read-all-from-string "(define x 1) (define y 2) (+ x y)")
  '((define x 1) (define y 2) (+ x y)))

;; comments and whitespace between and after forms
(check 'comments-and-ws
  (read-all-from-string "; lead\n(define a 1) ; mid\n\n(b c)\n; trailing comment\n")
  '((define a 1) (b c)))

;; empty / whitespace-only / comment-only input -> no forms
(check 'empty        (read-all-from-string "")                    '())
(check 'ws-only      (read-all-from-string "   \n\t  ")           '())
(check 'comment-only (read-all-from-string "  ; just a comment\n") '())

;; cross-check: same form list as Chez `read` over a sample source file
(define (chez-read-all path)
  (let ([p (open-input-file path)])
    (let loop ([acc '()])
      (let ([f (read p)])
        (if (eof-object? f)
            (begin (close-port p) (reverse acc))
            (loop (cons f acc)))))))
(define (file->string path)
  (let ([p (open-input-file path)])
    (let loop ([acc '()])
      (let ([c (read-char p)])
        (if (eof-object? c)
            (begin (close-port p) (list->string (reverse acc)))
            (loop (cons c acc)))))))

(let ([sample "test/read-all-sample.scm"])
  (check 'cross-check-vs-chez-read
    (read-all-from-string (file->string sample))
    (chez-read-all sample)))

(printf "\n  ~a passed, ~a failed\n" pass fail)
(exit (if (= fail 0) 0 1))

;;; dia-c.sld -- diamond shared dependency (change: module-generalize).
;;; Imported by BOTH dia-a and dia-b; the program's @scheme_entry must init it
;;; exactly once (topo-order dedup + the one-shot @"dia.c:__inited" guard).
(define-library (dia-c)
  (export c-val)
  (begin
    (define (c-val) 7)))

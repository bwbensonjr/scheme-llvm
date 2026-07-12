; interning: symbols with the same name are eq?, different names are not.
(if (eq? (quote foo) (quote foo))      ; same name  => #t
    (if (eq? (quote foo) (quote bar))  ; diff name  => #f
        #f
        #t)
    #f)                                ; => #t

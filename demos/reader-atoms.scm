; read one datum of each atom type into a list.
(list (read-from-string "42")          ; 42
      (read-from-string "hello")        ; hello (symbol)
      (read-from-string "#t")           ; #t
      (read-from-string "#\\z")         ; #\z
      (read-from-string "\"hi\""))      ; "hi"   => (42 hello #t #\z "hi")

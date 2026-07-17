; A record prints opaquely as #<record TYPE> (the type name); not readable.
;   => #<record point>
(define-record-type point (make-point x y) point? (x point-x) (y point-y))
(make-point 1 2)

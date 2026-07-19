;;; mandelbrot.scm  --  A simple Mandelbrot set renderer in R7RS Scheme.
;;; Prints ASCII art to standard output.

;; The heart of the algorithm.
;; For a point c = cx + cy*i, iterate  z <- z^2 + c  starting at z = 0,
;; and return how many steps it takes for |z| to exceed 2.  Points that
;; never escape within MAX-ITER steps are considered part of the set.
(define (escape-count cx cy max-iter)
  (let loop ((zx 0.0) (zy 0.0) (i 0))
    (cond
      ((= i max-iter) i)                          ; didn't escape -> in the set
      ((> (+ (* zx zx) (* zy zy)) 4.0) i)         ; escaped once |z|^2 > 4
      (else
       (loop (+ (- (* zx zx) (* zy zy)) cx)       ; new real part: zx^2 - zy^2 + cx
             (+ (* 2.0 zx zy) cy)                 ; new imag part: 2*zx*zy + cy
             (+ i 1))))))

;; Turn an escape count into a character.  Points inside the set are drawn
;; solid; points outside are shaded by how quickly they escaped.
(define palette " .,:;irsXA253hMHGS#9B&@")

(define (shade n max-iter)
  (if (= n max-iter)
      #\*                                          ; inside the set
      (string-ref palette
                  (modulo n (string-length palette)))))

;; Sample a rectangle of the complex plane onto a COLS x ROWS grid.
(define (render x-min x-max y-min y-max cols rows max-iter)
  (let ((dx (/ (- x-max x-min) cols))
        (dy (/ (- y-max y-min) rows)))
    (do ((row 0 (+ row 1))) ((= row rows))
      (do ((col 0 (+ col 1))) ((= col cols))
        (let ((cx (+ x-min (* col dx)))
              (cy (+ y-min (* row dy))))
          (write-char (shade (escape-count cx cy max-iter) max-iter))))
      (newline))))

;; Draw the classic view of the whole set.
(render -2.5 1.0 -1.25 1.25 80 32 100)

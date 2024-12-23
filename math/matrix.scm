; This library defines functions for performing matrix and vector calculations.
; (load "./matrix.scm")
; (import (math matrix))
(library (math matrix (1 0 0))
  (export
    matrix-get-dims matrix-ref matrix=?
    matrix-copy make-matrix matrix-transpose make-constant-matrix
    matrix-set! matrix* matrix-mapi!
    matrix-mapi matrix-map! matrix-map matrix+ matrix- *-vector-matrix
    *-matrix-vector)
  (import (rnrs (6)) (math vector (1)))

; Accepts a matrix x and returns two natural numbers, n and m,
; where n specifies the number of rows in x and m specifies the number
; of columns.
(define (matrix-get-dims x)
  (let
    ([n (vector-length x)])
    (if (= n 0) (values 0 0)
      (values n (vector-length (vector-ref x 0))))))

(assert (equal? (matrix-get-dims '#(#(1 2 3) #(4 5 6))) (values 2 3)))

; Accepts three arguments: x, a matrix; i, a natural number that
; represents a row index; and j, a natural number that represents a
; column index; and returns the element in x located at row i and column
; j.
(define (matrix-ref x i j)
  (vector-ref (vector-ref x i) j))

(assert (= (matrix-ref '#(#(1 2) #( 3 4)) 0 1) 2))

(assert (= (matrix-ref '#(#(1 2) #( 3 4)) 1 1) 4))

; Accepts two matrices and returns true iff they are equal.
(define (matrix=? x y)
  (let
    ([n (vector-length x)])
    (and (= n (vector-length y))
      (if (= n 0) #t
        (let
          ([m (vector-length (vector-ref x 0))])
          (and (= m (vector-length (vector-ref y 0)))
            (do
              ([i 0 (+ i 1)]
               [res #t])
              ((or (not res) (= i n)) res)
              (do
                ([j 0 (+ j 1)])
                ((or (not res) (= j m)))
                (set! res
                  (= (matrix-ref x i j)
                     (matrix-ref y i j)))))))))))

(assert (not (matrix=? '#(#(1 2) #(3 4)) '#())))
(assert (not (matrix=? '#() '#(#(1 2) #(3 4)))))
(assert (not (matrix=? '#(#(1 2) #(3 5)) '#(#(1 2) #(3 4)))))
(assert (matrix=? '#(#(1 2) #(3 4)) '#(#(1 2) #(3 4))))

; Accepts one argument: x, a real matrix; and returns a copy of it.
(define (matrix-copy x)
  (let
    ([n (vector-length x)])
    (if (= n 0)
      (make-vector 0)
      (let
        ([m (vector-length (vector-ref x 0))]
         [res (make-vector n)])
        (do
          ([i 0 (+ i 1)])
          ((= i n) res)
          (let
           ([row (make-vector m)])
            (vector-set! res i row)
            (do
              ([j 0 (+ j 1)])
              ((= j m))
              (vector-set! row j (matrix-ref x i j)))))))))

(assert (equal? (matrix-copy '#(#(1 2) #(3 4))) '#(#(1 2) #(3 4))))

; Accepts three arguments: f, a function that accepts two natural
; numbers i and j and returns the real number that should be stored in
; matrix location (i, j); n, a natural number that specifies the number
; of rows that the matrix should have; and m, a natural number that
; specifies the number of columns that the matrix should have; and
; returns a matrix with n rows and m columns where the (i, j) element
; equals (f i j).
(define (make-matrix f n m)
  (if (= n 0)
    (make-vector 0)
    (let
      ([res (make-vector n)])
      (do
        ([i 0 (+ i 1)])
        ((= i n) res)
        (let
          ([row (make-vector m)])
          (vector-set! res i row)
          (do
            ([j 0 (+ j 1)])
            ((= j m))
            (vector-set! row j (f i j))))))))

(assert (matrix=? (make-matrix (lambda (i j) (+ (* 2 i) j)) 2 3) '#(#(0 1 2) #(2 3 4))))

; Accepts one argument: x, a matrix; and returns its transpose.
(define (matrix-transpose x)
  (let*-values
    ([(n m) (matrix-get-dims x)])
    (make-matrix
      (lambda (i j) (matrix-ref x j i))
      m n)))

(assert (equal? (matrix-transpose '#(#(1 2) #(3 4))) '#(#(1 3) #(2 4))))

; Accepts three arguments: n and m, two natural numbers; and x, a
; number; and returns a matrix with n rows and m columns where every
; element equals x.
(define (make-constant-matrix n m x)
  (make-matrix (lambda (i j) x) n m))

; Accepts four arguments: x, a matrix; i and j, natual numbers; and y,
; a real number; and sets the (i, j) element in x to y.
(define (matrix-set! x i j y)
  (vector-set! (vector-ref x i) j y)
  x)

(assert
  (let
    ([m (vector (vector 1 2) (vector 3 4))])
    (matrix-set! m 1 0 11)
    (matrix=? m '#(#(1 2) #(11 4)))))

; Accepts two matrices and returns their product.
(define (matrix* x y)
  (let*-values
    ([(n m') (matrix-get-dims x)]
     [(n' m) (matrix-get-dims y)])
    (assert (= m' n'))
    (let
      ([res (make-vector n)])
      (do
        ([i 0 (+ i 1)])
        ((= i n) res)
        (vector-set! res i (make-vector m))
        (do
          ([j 0 (+ j 1)])
          ((= j m))
	      ; multiply the i-th row vector in x with the j-th column
	      ; vector in y and save the result to acc.
          (do
            ([k 0 (+ k 1)]
             [acc 0 (+ acc (* (matrix-ref x i k) (matrix-ref y k j)))])
            ((= k m') (matrix-set! res i j acc))))))))

(assert (matrix=?
  (matrix* '#(#(1 2)) '#(#(3) #(4)))
  '#(#(11))))

(assert (matrix=?
  (matrix* '#(#(1 2) #(3 4)) '#(#(5 6) #(7 8)))
  '#(#(19 22) #(43 50))))

; Accepts two arguments:
; * f, a function that accepts three arguments:
;   * i and j, two natural numbers
;   * and x, a real number
;   and returns a real number
; and x, a matrix; and replaces every element (i, j) in x with (f i j
; x[i][j]).
(define (matrix-mapi! f x)
  (let
    ([n (vector-length x)])
    (if (= n 0) x
      (let
        ([m (vector-length (vector-ref x 0))])
        (do
          ([i 0 (+ i 1)])
          ((= i n) x)
          (do
            ([j 0 (+ j 1)])
            ((= j m))
            (matrix-set! x i j (f i j (matrix-ref x i j)))))))))

(assert (matrix=?
  (let
    ([x (vector (vector 1 2) (vector 3 4))])
    (matrix-mapi! (lambda (i j x) (* x x)) x))
  '#(#(1 4) #(9 16))))

; Accepts two arguments:
; * f, a function that accepts three arguments:
;   * i and j, two natural numbers
;   * and x, a real number
;   and returns a real number
; and x, a real matrix; and creates a new matrix
; whose (i, j) element equals (f i j x[i][j]).
(define (matrix-mapi f x)
  (let*
    ([n (vector-length x)]
     [res (make-vector n)])
    (if (= n 0) res
      (let
        ([m (vector-length (vector-ref x 0))])
        (do
          ([i 0 (+ i 1)])
          ((= i n) res)
          (let
            ([row (make-vector m)])
            (vector-set! res i row)
            (do
              ([j 0 (+ j 1)])
              ((= j m))
              (vector-set! row j (f i j (matrix-ref x i j))))))))))

(define (matrix-map! f x)
  (matrix-mapi! (lambda (i j y) (f y)) x))

(define (matrix-map f x)
  (matrix-mapi (lambda (i j y) (f y)) x))

(define (matrix+ x y)
  (matrix-mapi (lambda (i j z) (+ z (matrix-ref y i j))) x))

(assert (matrix=?
  (matrix+ '#(#(1 2) #(3 4)) '#(#(5 6) #(7 8)))
  '#(#(6 8) #(10 12))))

(define (matrix- x y)
  (matrix-mapi (lambda (i j z) (- z (matrix-ref y i j))) x))

(assert (matrix=?
  (matrix- '#(#(1 2) #(3 4)) '#(#(5 6) #(7 8)))
  '#(#(-4 -4) #(-4 -4))))

; (define (matrix-fold f init x)
;   (let*-values
;     ([(n m) (matrix-get-dims x)])
;     (

; Accepts two arguments: vec, a vector of real numbers that represents
; a row vector; and mat, a real matrix; and returns the product of vec
; and mat with vec on the left.
(define (*-vector-matrix vec mat)
  (let*
    ([n (vector-length mat)]
     [m (if (= n 0) 0 (vector-length (vector-ref mat 0)))]
     [res (make-vector m 0)])
    (do
      ([j 0 (+ j 1)])
      ((= j m) res)
      (do
        ([i 0 (+ i 1)])
        ((= i n))
        (vector-set! res j
          (+ (vector-ref res j)
            (* (vector-ref vec i)
              (matrix-ref mat i j))))))))

(assert (equal? (*-vector-matrix '#(3.0 5.0) '#(#(1 2) #(3 4))) '#(18.0 26.0)))

; Accepts two arguments: mat, a real matrix; and vec, a real vector;
; and returns their product where mat is on the left and vec is on the
; right.
(define (*-matrix-vector mat vec)
  (let*
    ([n (vector-length mat)])
    (if (= n 0) (make-vector 0)
      (let
        ([m (vector-length (vector-ref mat 0))]
         [res (make-vector n)])
        (do
          ([i 0 (+ i 1)])
          ((= i n) res)
          (do
            ([j 0 (+ j 1)]
             [acc 0 (+ acc (* (matrix-ref mat i j) (vector-ref vec j)))])
            ((= j m) (vector-set! res i acc))))))))

(assert (equal? (*-matrix-vector '#(#(1 2) #(3 4)) '#(5 6)) '#(17 39)))
)
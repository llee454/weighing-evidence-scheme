; This library defines functions for performing matrix and vector calculations.
; (load "./matrix.scm")
; (import (math matrix))
(library (math matrix (1 0 0))
  (export
    vector-sum vector-* matrix-ref matrix=? matrix-copy matrix-set!
    matrix-* matrix-map! matrix-map *-vector-matrix *-matrix-vector)
  (import (rnrs (6)))

; Accepts one argument: x, a vector; and returns the sum of all of the
; elements in x.
(define (vector-sum x)
  (let
    ([n (vector-length x)])
    (do
      ([i (- n 1) (- i 1)]
       [acc 0 (+ acc (vector-ref x i))])
      ((< i 0) acc))))

(assert (= (vector-sum '#(1 2 3)) 6))

; Returns the dot product of two vectors.
(define (vector-* x y)
  (let
    ([n (vector-length x)]
     [res 0])
    (do
      ([i 0 (+ i 1)])
      ((= i n) res)
      (set! res (+ res (* (vector-ref x i) (vector-ref y i)))))))

(assert (= (vector-* '#(3 5 7) '#(7 11 13)) 167))

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
          ([i 0 (+ i 1)]
           [row (make-vector m)])
          ((= i n) res)
          (vector-set! res i row)
          (do
            ([j 0 (+ j 1)])
            ((= j m))
            (vector-set! row j (matrix-ref x i j))))))))

(assert (equal? (matrix-copy '#(#(1 2) #(3 4))) '#(#(3 4) #(3 4))))

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
(define (matrix-* x y)
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
          (vector-set! res i (make-vector m))
          (do
            ([j 0 (+ j 1)])
            ((= j m))
	        ; multiply the i-th row vector in x with the j-th column
	        ; vector in y and save the result to acc.
            (do
              ([k 0 (+ k 1)]
               [acc 0 (+ acc (* (matrix-ref x i k) (matrix-ref y k j)))])
              ((= k n) (matrix-set! res i j acc)))
            ))))))

(assert (matrix=?
  (matrix-* '#(#(1 2) #(3 4)) '#(#(5 6) #(7 8)))
  '#(#(19 22) #(43 50))))

; Accepts two arguments: f, a function that accepts a real number and
; returns a real number; and x, a matrix; and replaces every element y
; in x with (f y).
(define (matrix-map! f x)
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
            (matrix-set! x i j (f (matrix-ref x i j)))))))))

(assert (matrix=?
  (let
    ([x (vector (vector 1 2) (vector 3 4))])
    (matrix-map! (lambda (x) (* x x)) x))
  '#(#(1 4) #(9 16))))

; Accepts two arguments: f, a function that accepts a real number and
; returns a real number; and x, a real matrix; and creates a new matrix
; whose (i, j) element equals (f x[i][j]).
(define (matrix-map f x)
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
              (vector-set! row j (f (matrix-ref x i j))))))))))

(assert (matrix=?
  (matrix-map (lambda (x) (* x x)) '#(#(1 2) #(3 4)))
  '#(#(1 4) #(9 16))))

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
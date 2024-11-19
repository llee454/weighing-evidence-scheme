; This library defines functions for evaluating claims and weighing evidence.
; (load "./evidence.scm")
; (import (math evidence))
(library (math evidence (1 0 0))
  (export get-posterior-probabilities get-weights-alt
    get-weight-matrix get-evidential-weight get-epistemic-weight get-weights
    get-weight-probability
    get-probability-weight
    test
  )
  (import (rnrs (6)) (math vector ((>= 1))) (math matrix ((>= 1))))

  ; This function helps you determine how likely a set of hypotheses
  ; are given a some pieces of independent evidence.
  ;
  ; We assume that there are n possible hypothesis. One must be true,
  ; and all of them are non-overlapping. Thus sum (P (Hi)) = 1. Next, we
  ; have several independent pieces of evidence Ej. This function
  ; returns a vector that lists the probability that each hypothesis is
  ; true given that we observed all of the pieces of evidence.
  ;
  ; Accepts one argument: a probabilities matrix of the form:
  ;
  ;   P(H0) | P(E0|H0) P(E1|H0) ...
  ;   P(H1) | P(E0|H1) P(H2|H1) ...
  ;   ...
  ;
  ; where the i-th row represents the probabilities associated with a
  ; hypothesis Hi, and the (j+1) column represents the probabilities
  ; associated with a piece of evidence Ej. All entries in (i, 0) store
  ; P(Hi) the probability that Hi was true before we saw the evidence.
  ; The entry (i, j) stores P(Ej|Hi), the probability of seeing evidence
  ; Ej when Hi is true.
  ;
  ; This function returns a vector of the form:
  ;
  ;  P(H0|E0 /\ E1 /\ ...) P(H1|E0 /\ E1 /\ ...) ...
  ;
  ; Where P(Hi|E0 /\ E1 /\ ...) represents the probability that
  ; hypothesis Hi is true given that we observed the evidence E0, E1,
  ; and so on.
  (define (get-posterior-probabilities x)
    (let*
      ([n (vector-length x)]
       ; Returns a vector where the i-th element represents the
       ; probability that the i-th hypothesis is true and that we would
       ; see all of the pieces of evidence.
       [phes (vector-map vector-prod x)]
       ; the probability of seeing all of the pieces of evidence.
       [pe (vector-sum phes)])
      (vector-map (lambda (phe) (/ phe pe)) phes)))

  (assert (equal?
    (get-posterior-probabilities
      '#(
        #(0.64 0.05 0.95 0.95)
        #(0.16 1.0  0.5  0.5)
        #(0.16 0.05 0.5  0.2)
        #(0.04 0.05 0.2 0.2)))
    '#(0.41399082568807344 0.5733944954128442
       0.011467889908256883 0.0011467889908256884)))

  (define (get-weights-alt x)
    (let*-values
      ([(n m) (matrix-get-dims x)]
       [(M) (make-matrix (lambda (i j) (if (= i j) 0 1)) n m)])
      (matrix-map 
        (lambda (x) (+ (log (- n 1)) x))
        (matrix-
          (matrix-map log x)
          (matrix-map log (matrix* M x))))))

  ; Accepts a matrix of the form:
  ;
  ;   P (E0|H0) P(E0|H1) ...
  ;   P (E1|H0) P(E1|H1) ...
  ;   ...
  ;
  ; and returns a matrix where every element wij represents the weight
  ; of evidence Ei on hypothesis Hj.
  (define (get-weight-matrix x)
    (let*-values
      ([(n m) (matrix-get-dims x)])
      (matrix-mapi
        (lambda (i j pij)
          (+ 
            (log (- n 1))
            (log pij)
            (- (log
              (vector-foldi
                (lambda (k acc pik) (if (= j k) acc (+ acc pik)))
                0 (vector-ref x i)
              )
        ))))
        x
    ))
  )

  (assert (matrix=?
    (get-weight-matrix
      '#(
        #(0.05 0.05 0.95)
        #(0.5  0.5  0.95)
        #(0.2 0.5  0.5)))
    '#(
      #(-2.3025850929940455 -2.3025850929940455 2.9444389791664403)
      #(-0.371563556432483 -0.371563556432483 0.6418538861723947)
      #(-0.916290731874155 0.35667494393873245 0.35667494393873245))
  ))

  ; Accepts a matrix of the form:
  ;
  ;   P (E0|H0) P(E0|H1) ...
  ;   P (E1|H0) P(E1|H1) ...
  ;   ...
  ;
  ; and returns a vector where every element wi represents the
  ; total evidential weight of evidence on hypothesis Hi.
  (define (get-evidential-weights x)
    (let*-values
      ([(n m) (matrix-get-dims x)])
      (*-vector-matrix
        (make-vector n 1)
        (get-weight-matrix x))
  ))

  (assert (equal?
    (get-evidential-weights
      '#(
        #(0.05 0.05 0.95)
        #(0.5  0.5  0.95)
        #(0.2 0.5  0.5)))
    '#(-3.5904393813006834 -2.317473705487796 3.9429678092775675)
  ))

  ; Accepts one argument: n, the number of plausible hypotheses;
  ; and returns the epistemic weight for each hypothesis assuming
  ; that we are agnostiic.
  (define (get-epistemic-weight n)
    (log (/ 1 (- n 1))))

  ; Accepts a matrix of the form:
  ;
  ;   P (E0|H0) P(E0|H1) ...
  ;   P (E1|H0) P(E1|H1) ...
  ;   ...
  ;
  ; and returns a vector where every element wi represents the
  ; total weight of evidence on hypothesis Hi.
  ;
  ; Note that this includes both the "evidential" and the implicit
  ; "epistemic" weights.
  (define (get-weights x)
    (let*
      ([n (vector-length x)]
       [we (get-epistemic-weight n)])
      (vector-map
        (lambda (wi) (+ wi we))
        (get-evidential-weights x)
  )))

  (assert (equal?
    (get-weights
      '#(
        #(0.05 0.05 0.95)
        #(0.5  0.5  0.95)
        #(0.2 0.5  0.5)))
    '#(-4.283586561860629 -3.0106208860477413 3.249820628717622)
  ))

  ; Accepts the total weight that supports a hypothesis (including
  ; its epistemic weight) and returns the probability that the
  ; hypothesis is true given the observed evidence.
  (define (get-weight-probability x)
    (/ 1 (+ 1 (exp (- x)))))

  (define (get-probability-weight x)
    (- (log (- (/ 1 x) 1))))

  ; Accepts a matrix of the form:
  ;
  ;   P (E0|H0) P(E0|H1) ...
  ;   P (E1|H0) P(E1|H1) ...
  ;   ...
  ;
  ; and returns a vector where every element pi represents the
  ; probabiltiy of hypothesis Hi given the total evidence E and
  ; assuming that we are initially agnositic between the hypotheses.
  (define (get-weight-probabilities x)
    (vector-map
      get-weight-probability
      (get-weights x)))

  (define test
    (get-posterior-probabilities
      (matrix-transpose    
        '#(
          #(1/3 1/3 1/3)
          #(0.05 0.05 0.95)
          #(0.5  0.5  0.95)
          #(0.2 0.5  0.5)))))
)
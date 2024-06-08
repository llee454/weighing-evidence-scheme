; This library defines functions for evaluating claims and weighing evidence.
; (load "./evidence.scm")
; (import (math evidence))
(library (math evidence (1 0 0))
  (export get-posterior-probabilities)
  (import (rnrs (6)) (math matrix ((>= 1))))

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
  ;
  ; In Maxima, this function could be written as:
  ; ph (peh) :=
  ;   block ([xs],
  ;     xs: exp (log (peh) . columnvector ([1, 1, 1, 1])),
  ;     xs / ([1, 1, 1, 1] . xs))$
  (define (get-posterior-probabilities x)
    (let*
      ([n (vector-length x)]
       ; Returns a vector where the i-th element represents the
       ; probability that the i-th hypothesis is true and that we would
       ; see all of the pieces of evidence.
       [phes (vector-map exp
               (*-matrix-vector
                 (matrix-map log x)
                 (make-vector n 1)))]
       ; the probability of seeing all of the pieces of evidence.
       [pe (vector-* (make-vector n 1) phes)])
      (vector-map (lambda (phe) (/ phe pe)) phes)))

  (assert (equal?
    (get-posterior-probabilities
      '#(
        #(0.64 0.05 0.95 0.95)
        #(0.16 1.0  0.5  0.5)
        #(0.16 0.05 0.5  0.2)
        #(0.04 0.05 0.2 0.2)))
    '#(0.4139908256880735   0.5733944954128439
       0.011467889908256887 0.0011467889908256884)))
)
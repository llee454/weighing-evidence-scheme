(import (rnrs (6)))
(import (math evidence))

; The probabilities of seeing the hypotheses and the pieces of evidence
(define probabilities
  '#(
    #(0.64 0.05 0.95 0.95)
    #(0.16 1.0  0.5  0.5)
    #(0.16 0.05 0.5  0.2)
    #(0.04 0.05 0.2 0.2)))
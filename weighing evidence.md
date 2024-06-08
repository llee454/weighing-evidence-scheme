<center><h1>Weighing Evidence</h1></center>

<center>Larry Darryl Lee Jr.</center>

<center>June 6, 2024</center>

> Abstract: In this article, I present Bayesian Inference as it applies to weighing evidence in the real-world. I then describe a set of tools and equations that I have developed to assist with real-world decision making. In particular, I describe the evidence color wheel, which is a nomograph that people can use to quickly assess the likelihood of claims based on a single piece of new evidence. I then proceed to discuss the mathematics involved in assessing multiple hypotheses using multiple pieces of independent evidence.

# Introduction

# Bayes Rule

## Introduction

## Graphical Representation

# The Evidence Color Wheel

# Combining Multiple Pieces of Evidence

## Introduction

In the previous sections, I introduced Bayes' Rule and the Evidence Color Wheel. The Evidence Color Wheel is effective when you have a single hypothesis and want to evaluate that hypothesis in light of a single new piece of evidence. We can stretch the Evidence Color Wheel to include multiple pieces of evidence by applying it iteratively. However, doing so rapidly accumulates approximation errors and the color wheel cannot, naturally, be extended to handle instances in which you have multiple hypotheses.

In this section, we return to Bayes' Rule and consider the general case where we have multiple hypotheses and pieces of evidence. We present and explain the mathematical formulas that can be used in this case, show computer code that can be used to solve it, and introduce the worksheet that I have created to help work through these scenarios in the real-world. 

## The Formula

Perhaps, the most intuitive way to understand the equations that describe the probability that a given hypothesis is true, given a set of observations, is to use the relative area concept that we described when we introduced Bayes' rule. So, let's return back to that idea.

Draw a square, and let's assume that every point in that square represents some possible state of the world. For example, in the diagram below, we have drawn a square, and marked off a random point which represents some possible world state.

Next let us consider $n$ disjoint hypotheses $n = |\{H_i\}|$. We assume that the truth must lie within one of these hypotheses. Thus, these $n$ hypotheses completely divide up the world state space and $1 = \sum_{i = 0}^n H_i$.


We can represent the set of possible states of the world as points in space. 

$$
\begin{align*}
p(H_0|E_0 \wedge E_1) = \frac{p(E_0 \wedge E_1 \wedge H_0)}{\sum_{i = 0}^n p(E_0 \wedge E_1 \wedge H_i)}
\end{align*}
$$

The following Maxima script defines a function that accepts the prior and conditional probabilities for a set of hypotheses and pieces of evidence and returns the posterior probabilities for the given hypotheses. 

```maxima
load ("eigen.mac")$

/*
  Represents an example probabilities matrix. The i-th row
  represents the probabilities associated with a hypothesis Hi.
  The first column lists the prior probabilities for the
  hypotheses. The j+1 st column represents the conditional
  probabilities associated with a piece of evidence Ej. Thus,
  element (i,j+1) gives the conditional probability of
  observing evidence j given that hypothesis i is true.   

  P(H0) | P(E0|H0) P(E1|H0) ...
  P(H1) | P(E0|H1) P(H2|H1) ...
  ...
*/
PEH: matrix (
  [0.64, 0.05, 0.95, 0.95],
  [0.16, 1.0, 0.5, 0.5],
  [0.16, 0.05, 0.5, 0.2],
  [0.04, 0.05, 0.2, 0.2])$

/*
  Accepts a probabilities matrix and returns a vector giving the
  probability of each hypothesis given that we have observed the
  given pieces of evidence.
*/
ph (peh) :=
  block ([xs],
    xs: exp (log (peh) . columnvector ([1, 1, 1, 1])),
    xs / ([1, 1, 1, 1] . xs))$
```



## The Worksheet

## Worked Example

# Conclusion

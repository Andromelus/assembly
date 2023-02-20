- [Introduction](#introduction)
- [Original golf question](#original-golf-question)
  - [Input](#input)
  - [Output](#output)
  - [Example](#example)

# Introduction

This code is an answer to the code golf question described below. It is used as a context for me to learn NASM.

Original post here: https://codegolf.stackexchange.com/q/133109/108818

Answer (reduced to a strict minimum for the contest) proposed here: 

# Original golf question

I'm honestly surprised that this hasn't been done already. If you can find an existing thread, by all means mark this as a duplicate or let me know.

## Input

Your input is in the form of any positive integer greater than or equal to 1.

## Output

You must output the sum of all integers between and including 1 and the number input.

## Example

     In: 5
         1+2+3+4+5 = 15
    Out: 15

[OEIS A000217 — Triangular numbers: a(n) = binomial(n+1,2) = n(n+1)/2 = 0 + 1 + 2 + ... + n.](http://oeis.org/A000217)
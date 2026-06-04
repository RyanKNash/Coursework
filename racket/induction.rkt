#lang racket
(require rackunit)
(require rackunit/text-ui)
#|
CS 270

Professor B. Char, M. Boady,  J. Johnson, S. Earth, and G. Long
Complete each of the below functions.

Tests given are not designed to be comprehensive.
They will give you an idea if your code is right, but they do not test all possible cases.
Think about your design. 
The number of tests passed is NOT your final score for the problem.
A grader will review your functions and may add or remove points from the autograder.


Important Rules:
0. Run your code before submitting it.
   If it crashes or goes into an infinite loop,
   A ZERO MAY BE GIVEN FOR THE ASSIGNMENT.

1. You may not use any loop constructs; if used, your answer will get a zero.

2. Unless stated otherwise, all these functions must be implemented recursively.

3. You may not use any Racket commands not discussed in class. If used, your answer may get a zero.
   See Blackboard Learn for a summary of acceptable commands.

4. Do not try to hard code if statements just to pass each test.
   Think about which are special cases and need to be hard coded and which can be handled by recursion.

5. The graders will always obey the input contracts. We will not test inputs that would break the input contract.

6. While you are encouraged to create your own comments, NEVER delete any provided comments.

7. Block comments are only used here and not in the code to help you debug.
   Only line comments will be used below.
|#



; IMPORTANT:
; Each of the below questions (except Q1) has two parts.
; First, you will be asked to write a Racket function to solve a problem.
; Secondly, you will be asked to prove by induction that your
; Racket code has some property.

;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
; Question 1
; Put your name here.
; Input contract:  No inputs. This function always returns the same thing.
; Output contract: (your-name) is the name of the student who did this assignment.
(define (your-name)
  "Ryan Nash" ; Put your name as a string like "Ted Bundy"
)

;Test Bed
(display "Question 1 your-name (2 points)\n")
(define-test-suite test_q1
  (test-equal? "" (string? (your-name) ) #t)
  (test-equal? "" (> (string-length (your-name) ) 0) #t)
)
(define q1_score (- 2 (run-tests test_q1 'verbose)))

;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;Question 2a (10 points)
; Write a recursive function to compute
; the sum( 6*x^2 , x = 1..n) for a given n
; You must write a recursive function.
; If you use any iterative commands (for/loop/sum/etc you will receive a 0)

; Computes sum( 6*x^2 , x = 1..n)
; Input contract:  n an integer >= 1
; Output contract: an integer, the result of the summation
(define (spec_sum n)
  (if (= n 1)
  6(+ (* 6 (* n n)) (spec_sum (- n 1)))))

;Test Bed
(display "Question 2a spec_sum (8 points)\n")
(define-test-suite test_spec_sum
  (check-equal? (spec_sum 1) 6)
  (check-equal? (spec_sum 2) 30)
  (check-equal? (spec_sum 4) 180)
  (check-equal? (spec_sum 5) 330)
  (check-equal? (spec_sum 7) 840)
  (check-equal? (spec_sum 8) 1224)
  (check-equal? (spec_sum 9) 1710)
  (check-equal? (spec_sum 10) 2310)
)
(define q2a_score (- 8 (run-tests test_spec_sum 'verbose)))

;Question 2 (10 points)
;Prove by induction that
;For all integers n >= 1 -> (spec_sum n) = 2n^3+3n^2+n

;You may provide your proof below in the comments
; or submit a PDF to gradescope along with this file
; containing the proof.

; Prove by induction that
; For all integers n >= 1
; (spec_sum n) = 2n^3 + 3n^2 + n

; Function:
; Computes sum(6*x^2, x = 1..n)
;(define (spec_sum n)
;  (if (= n 1)
;      6
;      (+ (* 6 (* n n)) (spec_sum (- n 1)))))

;Proof by Induction
;
;Claim:
;For all integers n >= 1, (spec_sum n) = 2n^3 + 3n^2 + n
;
;Base Case
;We anchor at n = 1
;
;LHS
;
;Expression                                        Justification
;(spec_sum 1)                                      Premise of LHS
;(if (= 1 1) 6 (+ (* 6 (* 1 1)) (spec_sum ...)))   Apply definition of spec_sum with n=1
;(if #t 6 (+ (* 6 (* 1 1)) (spec_sum (- 1 1))))    Evaluate =
;6                                                 Evaluate if
;
;RHS
;
;Expression                 Justification
;2(1^3) + 3(1^2) + 1        Premise of RHS
;2(1) + 3(1) + 1            Math
;2 + 3 + 1                  Math
;6                          Math
;
;Since LHS = RHS (both 6), the base case is established.
;
;Leap Case
;
;Inductive Hypothesis:
;Assume that for some integer k >= 1,
;(spec_sum k) = 2k^3 + 3k^2 + k
;
;We must show:
;(spec_sum (+ k 1)) = 2(k+1)^3 + 3(k+1)^2 + (k+1)
;
;LHS
;
;Expression                                                     Justification
;(spec_sum (+ k 1))                                             Premise of Leap Case LHS
;(if (= (+ k 1) 1)                                              Apply definition of spec_sum with n=(k+1)
;    6
;    (+ (* 6 (* (+ k 1) (+ k 1))) (spec_sum (- (+ k 1) 1))))
;(if #f
;    6
;    (+ (* 6 (* (+ k 1) (+ k 1))) (spec_sum (- (+ k 1) 1))))    Evaluate =   (since k>=1, k+1 != 1)
;(+ (* 6 (* (+ k 1) (+ k 1))) (spec_sum (- (+ k 1) 1)))         Evaluate if
;(+ (* 6 (* (+ k 1) (+ k 1))) (spec_sum k))                     Math
;(+ (* 6 (k+1)^2) (spec_sum k))                                 Math
;(+ (* 6 (k+1)^2) (2k^3 + 3k^2 + k))                            Invoke IH
;(+ (* 6 (k^2 + 2k + 1)) (2k^3 + 3k^2 + k))                     Expand square
;(+ (6k^2 + 12k + 6) (2k^3 + 3k^2 + k))                         Distribute 6
;2k^3 + 9k^2 + 13k + 6                                          Combine like terms
;
;RHS
;
;Expression                                      Justification
;2(k+1)^3 + 3(k+1)^2 + (k+1)                    Premise of Leap Case RHS
;2(k^3 + 3k^2 + 3k + 1) + 3(k^2 + 2k + 1) + k+1 Expand powers
;(2k^3 + 6k^2 + 6k + 2) + (3k^2 + 6k + 3) + k+1 Distribute
;2k^3 + 9k^2 + 13k + 6                           Combine like terms
;
;Since LHS = RHS (both evaluate to 2k^3 + 9k^2 + 13k + 6),
;the leap case is established.
;
;Conclusion
;
;Both the base case and leap case have been demonstrated, thus by POMI,
;for all integers n >= 1,
;
;(spec_sum n) = 2n^3 + 3n^2 + n
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;Question 3 (10 points)
; Write a function in Racket (define (veryNested n x) ...)
; that takes two integers, n and x, as input.

; veryNested will return a new list with value x nested
; into 2n parenthesis.

; For example, (veryNested 3 9) will return '((((((9)))))).
; The value 9 has been nested into 2*3=6 parenthesis
; (i.e. six left parentheses, the integer 9, then followed by six right parentheses).

; Your code must be recursive. You may NOT use high order functions (no map, foldr, etc.)
; --- you must implement the recursion yourself.
; No helper functions are allowed.
 

; Create a very nested list
; input-contract: n is a nonnegative integer, and x is a positive integer
; output-contract: (veryNested n x) is an x surrounded by 2*n parentheses 
(define (veryNested n x)
  (if (= n 0)
      x
      (list (list (veryNested (- n 1) x)))
  )
)

;Test Bed
(display "Question 3a veryNested Tests (10 points)\n")
(define-test-suite test_very_nested
  (check-equal? (veryNested 3 9) '((((((9)))))) )
  (check-equal? (veryNested 5 7) '((((((((((7)))))))))) )
  (check-equal? (veryNested 11 2) '((((((((((((((((((((((2)))))))))))))))))))))) )
  (check-equal? (veryNested 1 1) '((1)) )
  (check-equal? (veryNested 1 3) '((3)) )
  (check-equal? (veryNested 2 4) '((((4)))) )
  (check-equal? (veryNested 4 2) '((((((((2)))))))) )
  (check-equal? (veryNested 5 5) '((((((((((5)))))))))) )
  (check-equal? (veryNested 7 4) '((((((((((((((4)))))))))))))) )
  (check-equal? (veryNested 10 8) '((((((((((((((((((((8)))))))))))))))))))) )
)
(define q3a_score (- 10 (run-tests test_very_nested 'verbose)))

;Question 3b (10 points)
;Prove by induction

;You will use the function depth in this proof.
;You do not need to know it's implementation,
;just the follow properties.

;There is a function (depth X) that counts the levels of nesting in a list.
;The implementation is not relevant.
;You may use the following two lemmas about the depth function.

;Lemma 0: (depth a) = 0 for any integer a
;Lemma 1: (depth (cons L null)) = (+ 1 (depth L)) for any list L

;Prove that (depth (veryNested n x)) = 2*n
;for all non-negative integers n and for all integers x.
;Hint: You may treat x as a constant.

; You may provide your proof below in the comments
; or submit a PDF to gradescope along with this file
; containing the proof.
; Prove by induction:
; For all non-negative integers n, and for all integers x,
; (depth (veryNested n x)) = 2*n

; Function:
;(define (veryNested n x)
;  (if (= n 0)
;      x
;      (list (list (veryNested (- n 1) x)))))
;
; Lemma 0: (depth a) = 0 for any integer a
; Lemma 1: (depth (cons L null)) = (+ 1 (depth L)) for any list L
;
;Proof by Induction
;
;Claim:
;For all non-negative integers n, and for all integers x,
;(depth (veryNested n x)) = 2*n
;
;Base Case
;We anchor at n = 0
;
;LHS
;
;Expression                                                Justification
;(depth (veryNested 0 x))                                 Premise of LHS
;(depth (if (= 0 0) x (list (list (veryNested ... x)))))  Apply definition of veryNested with n=0
;(depth (if #t x (list (list (veryNested (- 0 1) x)))))   Evaluate =
;(depth x)                                                Evaluate if
;0                                                         Lemma 0, since x is an integer
;
;RHS
;
;Expression             Justification
;2*0                    Premise of RHS
;0                      Math
;
;Since LHS = RHS (both 0), the base case is established.
;
;Leap Case
;
;Inductive Hypothesis:
;Assume that for some k >= 0, and for integer x,
;(depth (veryNested k x)) = 2*k
;
;We must show:
;(depth (veryNested (+ k 1) x)) = 2*(k+1)
;
;LHS
;
;Expression                                                                 Justification
;(depth (veryNested (+ k 1) x))                                             Premise of Leap Case LHS
;(depth (if (= (+ k 1) 0)                                                   Apply definition of veryNested with n=(k+1)
;           x
;           (list (list (veryNested (- (+ k 1) 1) x)))))
;(depth (if #f                                                              Evaluate =, since k+1 > 0
;           x
;           (list (list (veryNested (- (+ k 1) 1) x)))))
;(depth (list (list (veryNested (- (+ k 1) 1) x))))                         Evaluate if
;(depth (cons (list (veryNested (- (+ k 1) 1) x)) null))                    Rewrite list as cons
;(+ 1 (depth (list (veryNested (- (+ k 1) 1) x))))                          Lemma 1
;(+ 1 (depth (cons (veryNested (- (+ k 1) 1) x) null)))                     Rewrite list as cons
;(+ 1 (+ 1 (depth (veryNested (- (+ k 1) 1) x))))                           Lemma 1
;(+ 1 (+ 1 (depth (veryNested k x))))                                       Math
;(+ 1 (+ 1 (2*k)))                                                          Invoke IH
;(+ 2 (2*k))                                                                Math
;2*k + 2                                                                    Math
;
;RHS
;
;Expression          Justification
;2*(k+1)             Premise of Leap Case RHS
;2k + 2              Math (distribute)
;
;Since LHS = RHS (both evaluate to 2k + 2), the leap case is established.
;
;Conclusion:
;Both the base case and leap case have been demonstrated, thus by POMI,
;for all non-negative integers n, and for all integers x,
;
;(depth (veryNested n x)) = 2*n
;
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
; Q4a (10 Points)
; Write a recursive function duplicate that takes every element in a list
; and makes a second copy of the item.
; For example if we started with (1 2 3)
; then the duplicated list would be (1 1 2 2 3 3)

; Duplicates Elements in a list
; Input contract:  X a list
; Output contract: A new list with two copies of even value in X
(define (duplicate X)
  (if (null? X)
      null
      (cons (first X)
            (cons (first X)
                  (duplicate (rest X)))))
)

(display "Question 4a duplicate Tests (10 points)\n")
(define-test-suite test_duplicate
  (check-equal? (duplicate '()) '())
  (check-equal? (duplicate '(1)) '(1 1))
  (check-equal? (duplicate '(1 2)) '(1 1 2 2))
  (check-equal? (duplicate '(4 6)) '(4 4 6 6))
  (check-equal? (duplicate '((1) (2 3))) '((1) (1) (2 3) (2 3)))
  (check-equal? (duplicate '(4 5 6)) '(4 4 5 5 6 6))
  (check-equal? (duplicate '(7 8 9 10)) '(7 7 8 8 9 9 10 10))
  (check-equal? (duplicate '(1 2 3 4 5)) '(1 1 2 2 3 3 4 4 5 5))
  (check-equal? (duplicate '(9 9 9)) '(9 9 9 9 9 9))
  (check-equal? (duplicate '(1 4 5 6 4 3 4 5))
                '(1 1 4 4 5 5 6 6 4 4 3 3 4 4 5 5))
)
(define q4a_score (- 10 (run-tests test_duplicate 'verbose)))

;4b (10 Points)
; Supposed x is the number of elements in L
; Prove By Induction
; For all lists we have (length (duplicate L)) = 2x

; You may use the following properties of length
; Length Lemma 1: (length '()) = 0 
; Length Lemma 2: If a is an object and B is a list
; (length (cons a B)) = (+ 1 (length B))
; You may Justify lines by saying [By Length Lemma 1]

;You may provide your proof below in the comments
; or submit a PDF to gradescope along with this file
; containing the proof.
; Suppose x is the number of elements in L
; Prove by induction:
; For all lists L, (length (duplicate L)) = 2x

; Function:
;(define (duplicate X)
;  (if (null? X)
;      null
;      (cons (first X)
;            (cons (first X)
;                  (duplicate (rest X))))))
;
; Length Lemma 1: (length '()) = 0
; Length Lemma 2: If a is an object and B is a list
;                 (length (cons a B)) = (+ 1 (length B))
;
;Proof by Induction on lists
;
;Claim:
;For all lists L, if x is the number of elements in L, then
;
;(length (duplicate L)) = 2x
;
;Base Case:
;Let L = '()
;Then x = 0
;
;LHS
;
;Expression                                  Justification
;(length (duplicate '()))                    Premise of LHS
;(length (if (null? '())                     Apply definition of duplicate
;            null
;            (cons (first '())
;                  (cons (first '())
;                        (duplicate (rest '()))))))
;(length null)                               Evaluate if
;0                                           By Length Lemma 1
;
;RHS
;
;Expression                                  Justification
;2x                                          Premise of RHS
;2(0)                                        Since x = 0
;0                                           Math
;
;Since LHS = RHS, the base case is established.
;
;Leap Case:
;Assume the claim holds for an arbitrary list T.
;
;Inductive Hypothesis:
;If t is the number of elements in T, then
;
;(length (duplicate T)) = 2t
;
;We must show the claim holds for any larger list of the form (cons a T).
;
;Let L = (cons a T)
;If T has t elements, then L has x = t + 1 elements.
;
;We must show:
;
;(length (duplicate (cons a T))) = 2x
;
;LHS
;
;Expression                                              Justification
;(length (duplicate (cons a T)))                         Premise of LHS
;(length (if (null? (cons a T))                          Apply definition of duplicate
;            null
;            (cons (first (cons a T))
;                  (cons (first (cons a T))
;                        (duplicate (rest (cons a T)))))))
;(length (cons (first (cons a T))                        Evaluate if
;              (cons (first (cons a T))
;                    (duplicate (rest (cons a T))))))
;(length (cons a                                          Evaluate first/rest
;              (cons a
;                    (duplicate T))))
;(+ 1 (length (cons a (duplicate T))))                  By Length Lemma 2
;(+ 1 (+ 1 (length (duplicate T))))                     By Length Lemma 2
;(+ 1 (+ 1 (2t)))                                       By IH
;2t + 2                                                 Math
;
;RHS
;
;Expression                                              Justification
;2x                                                      Premise of RHS
;2(t + 1)                                                Since x = t + 1
;2t + 2                                                  Math
;
;Since LHS = RHS, the leap case is established.
;
;Conclusion:
;Both the base case and leap case have been shown.
;Therefore, by induction on lists, for all lists L,
;if x is the number of elements in L, then
;
;(length (duplicate L)) = 2x
;
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;Question 5a (10pts)
; Write a recursive function (cut_end L) that removes the last element from the list

; Removes the last element in a list
; Input contract:  X non-empty a list
; Output contract: A new list with the last element removed
(define (cut_end L)
  (if (null? (rest L))
      null
      (cons (first L)
            (cut_end (rest L)))))

(display "Question 5a cut_end Tests (10 points)\n")
(define-test-suite test_cut_end
  (check-equal? (cut_end '(1)) '())
  (check-equal? (cut_end '(1 2)) '(1))
  (check-equal? (cut_end '(3 4 5)) '(3 4))
  (check-equal? (cut_end '( (1) (2) (3) )) '( (1) (2) ))
  (check-equal? (cut_end '((1 2 3 4))) '())
  (check-equal? (cut_end '((1 2) (3 4))) '((1 2)))
  (check-equal? (cut_end '(9 9 8)) '(9 9))
  (check-equal? (cut_end '(AND A B)) '(AND A))
  (check-equal? (cut_end '(NOT X)) '(NOT))
)
(define q5a_score (- 10 (run-tests test_cut_end 'verbose)))

;Question 5b
; Supposed x represents the number of elements in L
; Prove by Induction that
; For all lists with length >= 1 we have (length (cut_end L)) = x-1
; You may use the properties of length from Question 4.

;You may provide your proof below in the comments
; or submit a PDF to gradescope along with this file
; containing the proof.
; Suppose x represents the number of elements in L
; Prove by induction that
; For all lists with length >= 1, (length (cut_end L)) = x-1

; Function:
;(define (cut_end L)
;  (if (null? (rest L))
;      null
;      (cons (first L)
;            (cut_end (rest L)))))
;
; Length Lemma 1: (length '()) = 0
; Length Lemma 2: If a is an object and B is a list
;                 (length (cons a B)) = (+ 1 (length B))
;
;Proof by Induction on lists
;
;Claim:
;For all lists L with length >= 1, if x is the number of elements in L, then
;
;(length (cut_end L)) = x - 1
;
;Base Case:
;Let L be a list with exactly one element.
;
;Let L = (cons a '())
;Then x = 1
;
;LHS
;
;Expression                                  Justification
;(length (cut_end (cons a '())))             Premise of LHS
;(length (if (null? (rest (cons a '())))     Apply definition of cut_end
;            null
;            (cons (first (cons a '()))
;                  (cut_end (rest (cons a '()))))))
;(length (if (null? '())                     Evaluate rest
;            null
;            (cons (first (cons a '()))
;                  (cut_end (rest (cons a '()))))))
;(length (if #t                              Evaluate null?
;            null
;            (cons (first (cons a '()))
;                  (cut_end (rest (cons a '()))))))
;(length null)                               Evaluate if
;0                                           By Length Lemma 1
;
;RHS
;
;Expression                                  Justification
;x - 1                                       Premise of RHS
;1 - 1                                       Since x = 1
;0                                           Math
;
;Since LHS = RHS, the base case is established.
;
;Leap Case:
;Assume the claim holds for an arbitrary non-empty list T.
;
;Inductive Hypothesis:
;If T has t elements, then
;
;(length (cut_end T)) = t - 1
;
;We must show the claim holds for a larger list of the form (cons a T).
;
;Let L = (cons a T)
;Since T is non-empty, L has x = t + 1 elements.
;
;We must show:
;
;(length (cut_end (cons a T))) = x - 1
;
;LHS
;
;Expression                                              Justification
;(length (cut_end (cons a T)))                           Premise of LHS
;(length (if (null? (rest (cons a T)))                  Apply definition of cut_end
;            null
;            (cons (first (cons a T))
;                  (cut_end (rest (cons a T))))))
;(length (if (null? T)                                  Evaluate rest
;            null
;            (cons (first (cons a T))
;                  (cut_end (rest (cons a T))))))
;(length (cons (first (cons a T))                       Since T is non-empty, (null? T) = #f
;              (cut_end (rest (cons a T)))))
;(length (cons a (cut_end T)))                          Evaluate first and rest
;(+ 1 (length (cut_end T)))                            By Length Lemma 2
;(+ 1 (t - 1))                                         By IH
;t                                                     Math
;
;RHS
;
;Expression                                             Justification
;x - 1                                                  Premise of RHS
;(t + 1) - 1                                            Since x = t + 1
;t                                                      Math
;
;Since LHS = RHS, the leap case is established.
;
;Conclusion:
;Both the base case and leap case have been shown.
;Therefore, by induction on lists, for all lists L with length >= 1,
;if x is the number of elements in L, then
;
;(length (cut_end L)) = x - 1


;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
; Question 6a (10pts)
; Write a recursive function (add_pairs L)
; that adds pairs of numbers.
; You may assume the length of L will always be even.

; Adds pairs of numbers
; Input contract:  L a list (the list must have even length)
; Output contract: A new list with pairs of elements added together.
(define (add_pairs L)
  (if (null? L)
      null
      (cons (+ (first L) (first (rest L)))
            (add_pairs (rest (rest L))))))

(display "Question 6a add_pairs Tests (10 points)\n")
(define-test-suite test_add_pairs
  (check-equal? (add_pairs '()) '())
  (check-equal? (add_pairs '(1 2)) '(3))
  (check-equal? (add_pairs '(1 2 3 4)) '(3 7))
  (check-equal? (add_pairs '(2 2 2 2)) '(4 4))
  (check-equal? (add_pairs '(0 -1 -2 3)) '(-1 1))
  (check-equal? (add_pairs '(1 1 1 1)) '(2 2))
  (check-equal? (add_pairs '(1 2 3 4 5 6 7 8)) '(3 7 11 15))
  (check-equal? (add_pairs '(9 9 9 9 9 9)) '(18 18 18))
  (check-equal? (add_pairs '(7 3 4 6 5 5)) '(10 10 10))
  (check-equal? (add_pairs '(-9 9 -8 8)) '(0 0))
)
(define q6a_score (- 10 (run-tests test_add_pairs 'verbose)))

;Question 6b
; Suppose n represents the number of elements in L
; Prove by induction that
; for all lists of even length it is true that (length (add_pairs L)) = n/2
; You may use the properties of length from previous questions.

;You may provide your proof below in the comments
; or submit a PDF to gradescope along with this file
; containing the proof.

; Suppose n represents the number of elements in L
; Prove by induction that
; for all lists of even length it is true that
; (length (add_pairs L)) = n/2

; Function:
;(define (add_pairs L)
;  (if (null? L)
;      null
;      (cons (+ (first L) (first (rest L)))
;            (add_pairs (rest (rest L))))))
;
; Length Lemma 1: (length '()) = 0
; Length Lemma 2: If a is an object and B is a list
;                 (length (cons a B)) = (+ 1 (length B))
;
;Proof by Induction on even-length lists
;
;Claim:
;For all lists L of even length, if n is the number of elements in L, then
;
;(length (add_pairs L)) = n/2
;
;Base Case:
;Let L = '()
;Then n = 0
;
;LHS
;
;Expression                                  Justification
;(length (add_pairs '()))                    Premise of LHS
;(length (if (null? '())                     Apply definition of add_pairs
;            null
;            (cons (+ (first '())
;                     (first (rest '())))
;                  (add_pairs (rest (rest '()))))))
;(length null)                               Evaluate if
;0                                           By Length Lemma 1
;
;RHS
;
;Expression                                  Justification
;n/2                                         Premise of RHS
;0/2                                         Since n = 0
;0                                           Math
;
;Since LHS = RHS, the base case is established.
;
;Leap Case:
;Assume the claim holds for an arbitrary even-length list T.
;
;Inductive Hypothesis:
;If T has t elements, then
;
;(length (add_pairs T)) = t/2
;
;We must show the claim holds for a larger even-length list of the form
;(cons a (cons b T))
;
;Let L = (cons a (cons b T))
;
;Since T has t elements, L has n = t + 2 elements.
;Also, since L is even-length, T is even-length.
;
;We must show:
;
;(length (add_pairs (cons a (cons b T)))) = n/2
;
;LHS
;
;Expression                                                     Justification
;(length (add_pairs (cons a (cons b T))))                       Premise of LHS
;(length (if (null? (cons a (cons b T)))                        Apply definition of add_pairs
;            null
;            (cons (+ (first (cons a (cons b T)))
;                     (first (rest (cons a (cons b T)))))
;                  (add_pairs (rest (rest (cons a (cons b T))))))))
;(length (cons (+ (first (cons a (cons b T)))
;                 (first (rest (cons a (cons b T)))))
;              (add_pairs (rest (rest (cons a (cons b T)))))))  Evaluate if
;(length (cons (+ a (first (rest (cons a (cons b T)))))
;              (add_pairs (rest (rest (cons a (cons b T)))))))  Evaluate first
;(length (cons (+ a (first (cons b T)))
;              (add_pairs (rest (rest (cons a (cons b T)))))))  Evaluate rest
;(length (cons (+ a b)
;              (add_pairs (rest (rest (cons a (cons b T)))))))  Evaluate first
;(length (cons (+ a b)
;              (add_pairs (rest (cons b T)))))                  Evaluate rest
;(length (cons (+ a b)
;              (add_pairs T)))                                  Evaluate rest
;(+ 1 (length (add_pairs T)))                                   By Length Lemma 2
;(+ 1 (t/2))                                                    By IH
;(t/2) + 1                                                      Math
;
;RHS
;
;Expression                                                     Justification
;n/2                                                            Premise of RHS
;(t + 2)/2                                                      Since n = t + 2
;t/2 + 2/2                                                      Split fraction
;t/2 + 1                                                        Math
;
;Since LHS = RHS, the leap case is established.
;
;Conclusion:
;Both the base case and leap case have been shown.
;Therefore, by induction on even-length lists, for all lists L of even length,
;if n is the number of elements in L, then
;
;(length (add_pairs L)) = n/2
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;;;;;;;;;;;;;;Grade Summary;;;;;;;;;;;;;;;;;;;;;;;
(display "------Test Summary------\n")
(display "Q1 Scored: ")
(display q1_score)
(display "/2\n")
(display "Q2 Scored: ")
(display q2a_score)
(display "/8\n")
(display "Q3 Scored: ")
(display q3a_score)
(display "/10\n")
(display "Q4 Scored: ")
(display q4a_score)
(display "/10\n")
(display "Q5 Scored: ")
(display q5a_score)
(display "/10\n")
(display "Q6 Scored: ")
(display q6a_score)
(display "/10\n")


(define grand_total (+ q1_score q2a_score q3a_score q4a_score q5a_score q6a_score))
(display "\n")
(display "Total: ")
(display grand_total)
(display "/50\n")
(display "\nNOTE: last 50 points are manually graded.\n")
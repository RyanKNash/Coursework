#lang racket

;The following two lines are required to test the code.
(require rackunit)
(require rackunit/text-ui)

#|
CS 270

Created By Professors Bruce Char, Mark Boady, Jeremy Johnson, Galen Long, and Steve Earth

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


;------------ Start of Questions ---------------------

;-----------------------------------------------------------
;----------------- PART 1 ----------------------------------
;-----------------------------------------------------------

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

;Question 2
; We can think of a polynomial as a list.
; For example, you have the polynomial
; 5 + 2x^2 - 3x^3
; The largest exponent here is x^3.
; We can describe this as just 4 coefficents
; (5 0 2 -3)
; The first coefficient 5 goes with 5*x^0=5
; The second coefficient 0 goes with 0*x^1 = 0
; The third coefficient 2 goes with 2*x^2 = 2x^2
; The fourth coefficient -3 goes with -3*x^3 = -3x^3
; If we add them together we get 5 + 2x^2 - 3x^3

; The coefficient list will never have empty spaces.
; The first position is always the coefficient of x^0 then x^1 etc.

; Given a polynomial as a list of coefficients
; evaluate it at a point.
; (evaluate '(5 0 2 -3) 2)
; will compute:
; 5 + 0*2 + 2*2^2 + -3*(2^3) = -11

; Create a recursive function to evaluate polynomials
; Input contract:
;          First input is a polynomial described as a list of coefficients
;          Second input is value of x to evaluate at
; Output contract: An integer, the result of evaluating the polynomial at point x
; Note: when done efficiently, there is no need for the expt function
; This function **MUST** be implemented recursively (or using a recursive helper function).
(define (evaluate poly point)
  (cond
    [(null? poly) 0]
    [else
     (+ (first poly)
        (* point (evaluate (rest poly) point)))]))

;Tests
(define-test-suite test_q2
  (check-equal? (evaluate '(5 0 2 -3) 2) -11)
  (check-equal? (evaluate '(5 0 2 -3) 10) -2795)
  (check-equal? (evaluate '(0 0 0 0 7) 2) 112)
  (check-equal? (evaluate '(9 8 7 6 5 4 3 2 1) 9) 54481005)
  (check-equal? (evaluate '(0 1 0 2 0 3 0 4) 20) 5129616020)
  (check-equal? (evaluate '(-1 1 -1 1) -12) -1885)
  (check-equal? (evaluate '(1 2 3 4 5 6 7 8 9 10) 1) 55) 
  (check-equal? (evaluate '(7 7 1 0 0 0 9) 1) 24)  
)
(display "Question 2 evaluate (8 points)")
(newline)
(define q2_score (- 8 (run-tests test_q2 'verbose)))

; Question 3
; Given two polynomials, we can add them by adding the coefficients
; For example,
;  Let A = 5 + x^1 + 3x^3 (represented as (5 1 0 3)
;  Let B = 9 + x^1 + 6x^2 + 5x^4 (represented as (9 1 6 0 5)
;  When we add A+B we get:
;  (5+9) + (1+1)x^1 + (6+0)x^2 + (3+0)x^3 + 5x^4
;  14 + 2x^1 + 6x^2 + 3x^3 + 5x^4
; represented as (14 2 6 3 5)

; Write a function to add to polynomials
; Input contract: A and B are polynomials represented as
;                lists of coefficients
; Output Contract: A+B as a list of coefficents
; This function **MUST** be implemented recursively.
(define (addPoly A B)
  (cond
    [(and (null? A) (null? B)) '()]
    [(null? A) B]
    [(null? B) A]
    [else
     (cons (+ (first A) (first B))
           (addPoly (rest A) (rest B)))]))
;Tests
(define-test-suite test_q3
  (check-equal?
    (addPoly '(5 1 0 3) '(9 1 6 0 5))
    '(14 2 6 3 5)
  )
  (check-equal?
   (addPoly '(0 0 5) '(7))
   '(7 0 5)
  )
  (check-equal?
   (addPoly '(12) '(8 9 10))
   '(20 9 10)
  )
  (check-equal?
   (addPoly '(-1 1 -1 1) '(1 -1 1 -1))
   '(0 0 0 0)
  )
  (check-equal?
   (addPoly '(9 12 15 7) '(11 8 5 13))
   '(20 20 20 20)
  )
  (check-equal?
   (addPoly '(1 2 3 4 5 6 7 8 9 10 11 12) '(12 11 10 9 8 7 6 5 4 3 2 1))
   '(13 13 13 13 13 13 13 13 13 13 13 13)
  )
  (check-equal?
   (addPoly '(0 0 0 1) '(1 0 0 0))
   '(1 0 0 1)
  )
  (check-equal?
   (addPoly '() '(1 2 3 4))
   '(1 2 3 4)
  )
  (check-equal?
   (addPoly '(1 2 3 4) '())
   '(1 2 3 4)
  )
  (check-equal?
   (addPoly '(7) '(3))
   '(10)
  )
)
(display "Question 3 addPloy (10 points)")
(newline)
(define q3_score (- 10 (run-tests test_q3 'verbose)))


;Question 4
; We can multiply a polynomial by a constant.
; For example:
; We have a polynomial
; 7x+9x^3 represented as (0 7 0 9)
; We want to multiply the entire polynomial by 2
; 2*(7x+9x^3) = 14x+18x^3
; represented as (0 14 0 18)

; Implement a function to multiply a polynomial by a constant
; Input contract: an integer and a polynomial represented as
;    a list of coefficients
; Output contract: a polynomial represented as a list of coefficients
; Requirement: to get practice using some of the higher order functions we don't
; ordinarily use (map/foldr/foldl/lambda),implement this function WITHOUT recursion or any helpers.
(define (multCoeff val poly)
  (map (lambda (c) (* val c)) poly))

;Tests
(define-test-suite test_q4
  (check-equal?
    (multCoeff 2 '(0 7 0 9))
    '(0 14 0 18)
  )
  (check-equal?
   (multCoeff 10 '(1 2 3 4 5 6 7 8 9 10))
   '(10 20 30 40 50 60 70 80 90 100)
  )
  (check-equal?
   (multCoeff -1 '(12 5 9 -2 -3 -5))
   '(-12 -5 -9 2 3 5)
  )
  (check-equal?
   (multCoeff (/ 3 2) '(4 6 9 5 11))
   '(6 9 27/2 15/2 33/2)
  )
  (check-equal?
   (multCoeff 0 '(1 2 3 0 0 9))
   '(0 0 0 0 0 0)
  )
)
(display "Question 4 multCoeff (5 points)")
(newline)
(define q4_score (- 5 (run-tests test_q4 'verbose)))


;Question 5
; We can also multiply a polynomial by x
; This increases all the exponents by 1
; For Example,
; We have the polynomial x+2x^2+3^3
; represented as '(0 1 2 3)
; We want to compute
; x*(x+2x^2+3x^3)
; = x^2+2x^3+3x^3
; Represented as the list
; '(0 0 1 2 3)

; Write a function that multiplies the polynomial by x
; Input contract: a polynomial as a list of coefficients
; Output contract: a polynomial as a list of coefficients
; Note: Recursion is not needed for this question.
(define (multByX poly)
  (cons 0 poly))

;Tests
(define-test-suite testmultbyx
  (check-equal?
    (multByX '(0 1 2 3))
    '(0 0 1 2 3)
  )
  (check-equal?
   (multByX '(1 1 1 1))
   '(0 1 1 1 1)
   )
  (check-equal?
   (multByX '(2))
   '(0 2)
  )
  (check-equal?
   (multByX '(100 200 599 -7 -12 -100))
   '(0 100 200 599 -7 -12 -100)
  )
  (check-equal?
   (multByX '(10 9 8 7 6))
   '(0 10 9 8 7 6)
  )
)
(display "Question 5 multByX (5 points)")
(newline)
(define q5_score (- 5 (run-tests testmultbyx 'verbose)))


;Question 6
; We can multiply two polynomials
; A= 2 + x - 2x^2 (2 1 -2)
; B= 9x + 3x^2 (0 9 3)
; We want to compute A*B = C
; C = 18x + 15x^2 -15x^3 -6x^4
; as a list this is (0 18 15 -15 -6)


; Write a function to multiply two polynomials
; Input contract: P and Q are racket representations of the polynomials p(x) and q(x)
; Output contract: (multPoly P Q) is the racket representation of the polynomial p(x)*q(x)
; HINT: functions you wrote earlier in this HW will be helpful
; This function **MUST** be implemented recursively.
(define (multPoly P Q)
  (cond
    [(or (null? P) (null? Q)) '()]
    [else
     (addPoly
      (multCoeff (first P) Q)
      (multByX (multPoly (rest P) Q)))]))

;Tests
(define-test-suite testmultpoly
  (check-equal?
    (multPoly '(2 1 -2) '(0 9 3))
    '(0 18 15 -15 -6)
    )
  (check-equal?
   (multPoly '(7) '(2))
   '(14)
   )
  (check-equal?
   (multPoly '(1 1) '(2 2))
   '(2 4 2)
  )
  (check-equal?
   (multPoly '(-1 1) '(1 -1))
   '(-1 2 -1)
  )
  (check-equal?
   (multPoly '(-1 1) '(-1 -1))
   '(1 0 -1)
  )
  (check-equal?
   (multPoly '(5 9 7 3 1) '(0 2))
   '(0 10 18 14 6 2)
  )
  (check-equal?
   (multPoly '(0 0 1) '(9 11 14 -3 7 15))
   '(0 0 9 11 14 -3 7 15)
  )
  (check-equal?
   (multPoly '(2) '(3 5 7 9))
   '(6 10 14 18)
  )
  (check-equal?
   (multPoly '(3 5 7 9) '(2))
   '(6 10 14 18)
  )
  (check-equal?
   (multPoly '(1 1 1 1 1 1 1) '(1 -1 1 -1 1 -1 1 -1 1 -1))
   '(1 0 1 0 1 0 1 -1 1 -1 0 -1 0 -1 0 -1)
  )
)

(display "Question 6 multPoly (10 points)")
(newline)
(define q6_score (- 10 (run-tests testmultpoly 'verbose)))


;-----------------------------------------------------------
;----------------- PART 2 ----------------------------------
;-----------------------------------------------------------

;Question 7
; Write a recursive function all_q to check if a list of symbols
; contains all q symbols.
; Don't forget the base case and the necessary recursion.
; You may use any previously written function.

; Hint: You can use equal? on symbols
; (equal? 'q 'b) returns #f
; (equal? 'b 'b) returns #t

; Check if a list contains all q characters
; Input contract:  L is any list.
; Output contract: a boolean value which is true when there
;          does not exist any non-q elements in the list.
; This function **MUST** be implemented recursively.
(define (all_q L)
  (cond
    [(null? L) #t]
    [(equal? (first L) 'q)
     (all_q (rest L))]
    [else #f]))

(define-test-suite test_all_q
  (check-equal? (all_q '(q x)) #f)
  (check-equal? (all_q '(q)) #t)
  (check-equal? (all_q '(b)) #f)
  (check-equal? (all_q '(b c)) #f)
  (check-equal? (all_q '(c q)) #f)
  (check-equal? (all_q '(q q)) #t)
  (check-equal? (all_q '(q x q)) #f)
  (check-equal? (all_q '(q q q)) #t)
  (check-equal? (all_q '(q q q q q q q q)) #t)
  (check-equal? (all_q '(q q q q w q q q)) #f)
)

(display "Question 7 all_q (10 points)")
(newline)
(define q7_score (- 10 (run-tests test_all_q 'verbose)))


;Question 8
; Solve all_q again. This time you may not write a recursive function.
; Solve the problem using map/foldr/foldl/lambda instead of recursion.
; Do not write helper functions for this question. Use Lambda instead.

; Check if a list contains all q characters
; Input contract:  L is a list.
; Output contract: a boolean value which is true when there
;          does not exist any non-q elements in the list.
(define (all_q_v2 L)
  (foldr
   (lambda (x acc)
     (and (equal? x 'q) acc))
   #t
   L))

(define-test-suite test_all_q_v2
  (check-equal? (all_q_v2 '()) #t)
  (check-equal? (all_q_v2 '(q)) #t)
  (check-equal? (all_q_v2 '(b)) #f)
  (check-equal? (all_q_v2 '(b c)) #f)
  (check-equal? (all_q_v2 '(c q)) #f)
  (check-equal? (all_q_v2 '(q q)) #t)
  (check-equal? (all_q_v2 '(q x q)) #f)
  (check-equal? (all_q_v2 '(q q q)) #t)
  (check-equal? (all_q_v2 '(q q q q q q q q)) #t)
  (check-equal? (all_q_v2 '(q q q q w q q q)) #f)
)

(display "Question 8 all_q_v2 (10 points)")
(newline)
(define q8_score (- 10 (run-tests test_all_q_v2 'verbose)))


;Question 9
; Write a recursive function at_least_one_q to check if a list of symbols
; contains at least one q symbol.
; Don't forget the base case and the necessary recursion. 
; You may use any previously written function.

; Check if a list contains at least one q
; Input contract:  L is a list.
; Output contract: a boolean value which is true when at least one of the elements
;          in L is equal to q and false otherwise.
; This function **MUST** be implemented recursively.
(define (at_least_one_q L)
  (cond
    [(null? L) #f]
    [(equal? (first L) 'q) #t]
    [else
     (at_least_one_q (rest L))]))

(define-test-suite test_at_least_one_q
  (check-equal? (at_least_one_q '(q)) #t)
  (check-equal? (at_least_one_q '(b)) #f)
  (check-equal? (at_least_one_q '(x y)) #f)
  (check-equal? (at_least_one_q '(v q)) #t)
  (check-equal? (at_least_one_q '(q q)) #t)
  (check-equal? (at_least_one_q '(x x d)) #f)
  (check-equal? (at_least_one_q '(c t q)) #t)
  (check-equal? (at_least_one_q '(q q q)) #t)
  (check-equal? (at_least_one_q '(q w q q)) #t)
  (check-equal? (at_least_one_q '(x y d w)) #f)
)

(display "Question 9 at_least_one_q (10 points)")
(newline)
(define q9_score (- 10 (run-tests test_at_least_one_q 'verbose)))


;Question 10
; Solve at_least_one_q again. This time you may not write a recursive function.
; Solve the problem using map/foldr/foldl/lambda instead of recursion.
; Do not write helper functions for this question. Use Lambda instead.

; Check if a list contains at least one q
; Input contract:  L is a list.
; Output contract: a boolean value which is true when at least one of the elements
;          in L is equal to q and false otherwise.
(define (at_least_one_q_v2 L)
  (foldr
   (lambda (x acc)
     (or (equal? x 'q) acc))
   #f
   L))

(define-test-suite test_at_least_one_q_v2
  (check-equal? (at_least_one_q_v2 '(q)) #t)
  (check-equal? (at_least_one_q_v2 '(b)) #f)
  (check-equal? (at_least_one_q_v2 '(x y)) #f)
  (check-equal? (at_least_one_q_v2 '(v q)) #t)
  (check-equal? (at_least_one_q_v2 '(q q)) #t)
  (check-equal? (at_least_one_q_v2 '(x x d)) #f)
  (check-equal? (at_least_one_q_v2 '(c t q)) #t)
  (check-equal? (at_least_one_q_v2 '(q q q)) #t)
  (check-equal? (at_least_one_q_v2 '(q w q q)) #t)
  (check-equal? (at_least_one_q_v2 '(x y d w)) #f)
)

(display "Question 10 at_least_one_q_v2 (10 points)")
(newline)
(define q10_score (- 10 (run-tests test_at_least_one_q_v2 'verbose)))


;Question 11
; Write a recursive function exactly_one_q to check if a list of symbols
; contains exactly one q symbol.
; Don't forget the base case and the necessary recursion.

; Check if a list contains exactly one q
; Input contract:  L is a list.
; Output contract: a boolean value which is true when exactly one of the elements
;          in L is equal to q and false otherwise.
; This function **MUST** be implemented recursively.
; Hint: You may want to use a previously defined function as a helper.
; Requirement: DO NOT count the number of q
(define (exactly_one_q L)
  (cond
    [(null? L) #f]
    [(equal? (first L) 'q)
     (not (at_least_one_q (rest L)))]
    [else
     (exactly_one_q (rest L))]))

(define-test-suite test_exactly_one_q
  (check-equal? (exactly_one_q '(q)) #t)
  (check-equal? (exactly_one_q '(x)) #f)
  (check-equal? (exactly_one_q '(z r)) #f)
  (check-equal? (exactly_one_q '(q d)) #t)
  (check-equal? (exactly_one_q '(q q)) #f)
  (check-equal? (exactly_one_q '(d e p)) #f)
  (check-equal? (exactly_one_q '(q b q)) #f)
  (check-equal? (exactly_one_q '(q q q)) #f)
  (check-equal? (exactly_one_q '(q n q q)) #f)
  (check-equal? (exactly_one_q '(m n m q)) #t)
)

(display "Question 11 exactly_one_q (10 points)")
(newline)
(define q11_score (- 10 (run-tests test_exactly_one_q 'verbose)))


;Question 12
; Solve exactly_one_q again. This time you may not write a recursive function.
; Solve the problem using map/foldr/foldl/lambda instead of recursion.
; Do not write helper functions for this question. Use Lambda instead.

; Check if a list contains exactly one q
; Input contract:  L is a list.
; Output contract: a boolean value which is true when exactly one of the elements
;          in L is equal to q and false otherwise.
; Hint: If one of the high order functions can count that is fine, as long as you don't write a count.
(define (exactly_one_q_v2 L)
  (= 1
     (foldr
      (lambda (x acc)
        (cond
          [(and (equal? x 'q) (equal? acc 0)) 1]
          [(and (equal? x 'q) (> acc 0)) 2]
          [else acc]))
      0
      L)))

(define-test-suite test_exactly_one_q_v2
  (check-equal? (exactly_one_q_v2 '(q)) #t)
  (check-equal? (exactly_one_q_v2 '(x)) #f)
  (check-equal? (exactly_one_q_v2 '(z r)) #f)
  (check-equal? (exactly_one_q_v2 '(q d)) #t)
  (check-equal? (exactly_one_q_v2 '(q q)) #f)
  (check-equal? (exactly_one_q_v2 '(d e p)) #f)
  (check-equal? (exactly_one_q_v2 '(q b q)) #f)
  (check-equal? (exactly_one_q_v2 '(q q q)) #f)
  (check-equal? (exactly_one_q_v2 '(q n q q)) #f)
  (check-equal? (exactly_one_q_v2 '(m n m q)) #t)
)

(display "Question 12 exactly_one_q_v2 (10 points)")
(newline)
(define q12_score (- 10 (run-tests test_exactly_one_q_v2 'verbose)))


;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
(display "------Test Summary------\n")
(display "Q1 Scored: ")
(display q1_score)
(display "/2\n")
(display "Q2 Scored: ")
(display q2_score)
(display "/8\n")
(display "Q3 Scored: ")
(display q3_score)
(display "/10\n")
(display "Q4 Scored: ")
(display q4_score)
(display "/5\n")
(display "Q5 Scored: ")
(display q5_score)
(display "/5\n")
(display "Q6 Scored: ")
(display q6_score)
(display "/10\n")
(display "Q6 Scored: ")
(display q7_score)
(display "/10\n")
(display "Q8 Scored: ")
(display q8_score)
(display "/10\n")
(display "Q9 Scored: ")
(display q9_score)
(display "/10\n")
(display "Q10 Scored: ")
(display q10_score)
(display "/10\n")
(display "Q11 Scored: ")
(display q11_score)
(display "/10\n")
(display "Q12 Scored: ")
(display q12_score)
(display "/10\n")

(define grand_total (+ q1_score q2_score q3_score q4_score q5_score q6_score q7_score q8_score q9_score q10_score q11_score q12_score))
(display "\n")
(display "Total: ")
(display grand_total)
(display "/100\n")
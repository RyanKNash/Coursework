#lang racket

#|
CS 270 Math Foundations of CS

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

(require racket/contract)
(require rackunit)
(require rackunit/text-ui)

#|

Peano arithmetic

    In words:  A number is either zero, or, recursively, the the symbol s cons-ed 
    to a number.

    Formally:  Number := null | (cons s [Number])

|#

; The zero element is the null list
; returns true if the list represents the number zero
; input-contract: (list? N)
; output-contract: (boolean? (zero? N))
(define (zero? N)
  (null? N))

; Checks if the input is a list representing a peano number
; input-contract: (list? N)
; output-contract: (boolean? (nat? N))
(define (nat? N)
  (cond
    [(zero? N) #t]
    [(cons? N) (and (equal? (first N) 's) (nat? (rest N)))]
    [else #f]))

; Increment a peano number by adding 1
; input-contract: (nat? N)
; output-contract: (nat? (succ N))
(define (succ N)
  (cons 's N))

; Decrement a peano number by subtracting 1
; input-contract: (nat? N)
; output-contract: (nat? (pred N))
(define (pred N)
  (if (zero? N) null (rest N)))

;Define a collection of common numbers
(define zero null)
(define one (succ zero))
(define two (succ one))
(define three (succ two))
(define four (succ three))
(define five (succ four))
(define six (succ five))
(define seven (succ six))
(define eight (succ seven))
(define nine (succ eight))
(define ten (succ nine))

; Addition of Peano numbers
; input-contract: (and (nat? M) (nat? N))
; output-contract: (nat? (plus M N))
(define (plus M N)
  (if (zero? M)
      N
      (succ (plus (pred M) N))))

; Multiplication of Peano numbers
; input-contract: (and (nat? M) (nat? N))
; output-contract: (nat? (mult M N))
(define (mult M N)
  (if (zero? M)
      M
      (plus N (mult (pred M) N))))

; Comparison of Peano numbers
; input-contract: (and (nat? M) (nat? N))
; output-contract: (boolean? (ltnat? M N)) and true when m < n
(define (ltnat? M N)
  (cond
    [(zero? N) #f]
    [(zero? M) #t]
    [else (ltnat? (pred M) (pred N))]))


;--------- Questions Start Here---------

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

;--------------- Question 2.  Implement subtraction of Peano numbers. --------------
; See specification below.

; Subtraction of Peano numbers
; input-contract: (and (nat? M) (nat? N))
; output-contract: (nat? (sub M N))
; result is the value of m-n if m >= n.
; otherwise return zero
;||RULES|| You may not convert to or from traditional integers.
;||RULES|| You may not compute the length of a list for any reason.
;||RULES|| Your function must be recursive.
(define (sub M N)
	(cond
	[(zero? N) M ]
	[(zero? M) zero ]
	[else (sub (pred M) (pred N))]))

;Test Bed
(display "Question 2 - Subtraction (8 points)\n")
(define-test-suite peano-subtract
  (check-equal? (sub ten ten) zero)
  (check-equal? (sub ten two) eight)
  (check-equal? (sub nine nine) zero)
  (check-equal? (sub nine one) eight)
  (check-equal? (sub eight six) two)
  (check-equal? (sub eight five) three)
  (check-equal? (sub six six) zero)
  (check-equal? (sub six two) four)
)
(define q2_score (- 8 (run-tests peano-subtract 'verbose)))

;--------------- Question 3.  Implement Quotient of Peano numbers. --------------

; Division of Peano numbers
; input-contract: (and (nat? M) (nat? N) (not (zero? N)))
; output-contract: (nat? (ltnat? M N))
; Returns a Peano number whose value q is the quotient of m divided by n.
; Remember if x/y then quotient q and remainder r meet the following requirement:
; x = q*y + r with 0 <= r < x.
;Return floor(m/n) otherwise
;||RULES|| You may not convert to or from traditional integers.
;||RULES|| You may not compute the length of a list for any reason.
;||RULES|| Your function must be recursive.
(define (div M N)
(if (ltnat? M N) zero (succ (div (sub M N) N))))

;Test Bed
(display "Question 3 - Division (10 points)\n")
(define-test-suite peano-div
  (check-equal? (div ten ten) one)
  (check-equal? (div ten two) five)
  (check-equal? (div nine three) three)
  (check-equal? (div nine one) nine)
  (check-equal? (div eight six) one)
  (check-equal? (div eight four) two)
  (check-equal? (div one seven) zero)
  (check-equal? (div seven five) one)
  (check-equal? (div six six) one)
  (check-equal? (div six two) three)
)
(define q3_score  (- 10 (run-tests peano-div 'verbose)))


;--------------- Question 4.  Implement Remainder of Peano numbers. --------------
; Remainder of Peano numbers
; input-contract: (and (nat? M) (nat? N) (not (zero? N)))
; output-contract: (nat? (rem M N))
; Returns a Peano number whose value r is the remainder of m divided by n.
; Remember if x/y then quotient q and remainder r meet the following requirement:
; x = q*y + r with 0 <= r < x.
;Return m%n otherwise
;||RULES|| You may not convert to or from traditional integers.
;||RULES|| You may not compute the length of a list for any reason.
;||RULES|| Your function must be recursive.
(define (rem M N)
  (if (ltnat? M N) M (rem (sub M N) N))) 


;Test Bed
(display "Question 4 - Remainder (10 points)\n")
(define-test-suite peano-rem
  (check-equal? (rem ten three) one)
  (check-equal? (rem ten two) zero)
  (check-equal? (rem nine three) zero)
  (check-equal? (rem nine one) zero)
  (check-equal? (rem eight five) three)
  (check-equal? (rem eight four) zero)
  (check-equal? (rem one seven) one)
  (check-equal? (rem seven five) two)
  (check-equal? (rem six six) zero)
  (check-equal? (rem six two) zero)
)
(define q4_score  (- 10 (run-tests peano-rem 'verbose)))

;--------------- Question 5.  Implement Not Equal of Peano numbers. --------------
; Not Equal of Peano numbers
; input-contract: (and (nat? M) (nat? N))
; output-contract: (boolean? (neq M N))
; Returns true when the numbers are not equal
;and false when they are equal
;||RULES|| You may not convert to or from traditional integers.
;||RULES|| You may not compute the length of a list for any reason.
;||RULES|| Your function must be recursive.
(define (neq M N)
  (cond
    [(and (zero? M) (zero? N)) #f]
    [(or (zero? M) (zero? N)) #t]
    [else (neq (pred M) (pred N))]))

;Test Bed
(display "Question 5 - Not Equal (10 points)\n")
(define-test-suite peano-neq
  (check-equal? (neq ten ten) #f)
  (check-equal? (neq six six) #f)
  (check-equal? (neq five five) #f)
  (check-equal? (neq four four) #f)
  (check-equal? (neq three three) #f)
  (check-equal? (neq two two) #f)
  (check-equal? (neq one one) #f)
  (check-equal? (neq seven five) #t)
  (check-equal? (neq six nine) #t)
  (check-equal? (neq six two) #t)
)
(define q5_score  (- 10 (run-tests peano-neq 'verbose)))

;--------------- Question 6.  Implement GCD of Peano numbers. --------------
#|
             Implement a function to compute the greatest common divisor
             of the Peano numbers m and n.  g = gcd(m,n) satisfies
             1)  g is a common divisor of m and n.
                 g divides m and g divides n.  I.E. the remainder when
                 dividing m and n by g is 0.
             2)  g is the greatest common divisor.
                 If e divides m and e divides n then e must divide g.

             The gcd(m,n) can be computed recursively.
             1)  gcd(m,0) = m
             2)  gcd(m,n) = gcd(n,remainder of m divided by n).
|#

; Greatest common divisor of Peano numbers
; input-contract: (and (nat? M) (nat? N)))
; output-contract: (nat? (gcd M N))
; return a Peano number equal to gcd(M,N).
; Note:  See algorithm in comments above
;||RULES|| You may not convert to or from traditional integers.
;||RULES|| You may not compute the length of a list for any reason.
;||RULES|| Your function must be recursive.
(define (gcd M N)
  (cond
    [(zero? N) M]
    [else (gcd N (rem M N))]))

(display "Question 6 - GCD (20 points)\n")
(define-test-suite peano-gcd
  (check-equal? (gcd two ten) two)
  (check-equal? (gcd two four) two)
  (check-equal? (gcd three zero) three)
  (check-equal? (gcd three two) one)
  (check-equal? (gcd three three) three)
  (check-equal? (gcd three five) one)
  (check-equal? (gcd three six) three)
  (check-equal? (gcd three nine) three)
  (check-equal? (gcd three ten) one)
  (check-equal? (gcd four two) two)
  (check-equal? (gcd five ten) five)
  (check-equal? (gcd six one) one)
  (check-equal? (gcd six seven) one)
  (check-equal? (gcd seven six) one)
  (check-equal? (gcd eight two) two)
  (check-equal? (gcd eight four) four)
  (check-equal? (gcd eight eight) eight)
  (check-equal? (gcd nine one) one)
  (check-equal? (gcd nine ten) one)
  (check-equal? (gcd ten three) one)

)
(define q6_score  (- 20 (run-tests peano-gcd 'verbose)))

;--------------- Question 7.  Implement Mod Power of Peano numbers. --------------
#|
            The mod power is commonly used in cryptography.
            We want to compute (m^n) % b
            When we compute exponents, the number normally get very large.
            If we only need the remainder, we can take it at each stage
            This keeps our numbers smaller

            The algorithm is described below
            (m^n)%b = 1 if n==0
            (m^n)%b = (* m (m^(n-1)) %b otherwise
|#

; Mod Power of Peano numbers
; input-contract: (and (nat? M) (nat? N)))
; output-contract: (nat? (modpow M N B))
; return a Peano number equal to (m^n)%B.
; Note:  See algorithm in comments above
;||RULES|| You may not convert to or from traditional integers.
;||RULES|| You may not compute the length of a list for any reason.
;||RULES|| Your function must be recursive.
(define (modpow M N B)
  (if (zero? N) one (rem (mult M (modpow M (pred N) B))B)))

(display "Question 7 - Mod Power (20 points)\n")
(define-test-suite peano-modpow
  (check-equal? (modpow two zero three) one)
  (check-equal? (modpow two one three) two)
  (check-equal? (modpow two two three) one)
  (check-equal? (modpow two three three) two)
  (check-equal? (modpow three zero four) one)
  (check-equal? (modpow three one four) three)
  (check-equal? (modpow three two four) one)
  (check-equal? (modpow three three four) three)
  (check-equal? (modpow two zero four) one)
  (check-equal? (modpow two one four) two)
  (check-equal? (modpow two two four) zero)
  (check-equal? (modpow two three four) zero)
  (check-equal? (modpow three zero five) one)
  (check-equal? (modpow three one five) three)
  (check-equal? (modpow three two five) four)
  (check-equal? (modpow three three five) two)
  (check-equal? (modpow three four five) one)
  (check-equal? (modpow three five five) three)
  (check-equal? (modpow three four two) one)
  (check-equal? (modpow three five two) one)
)
(define q7_score  (- 20 (run-tests peano-modpow 'verbose)))

;--------------- Question 8.  Inductive Proof --------------

;This question will be manually graded by the course assistants

;Prove the following claim:
;For any Peano Number M we have
;(nat? (succ M)) = #t

;Provide a Proof by Induction on M.
;This question is worth 20 points
;Anchor Identified: 2 points
;Base Case LHS: 4 points
;Base Case RHS: 1 points
;Inductive Hypothesis: 2 points
;Leap Case LHS: 10 points
;Leap Case RHS: 1 points

;You may provide the proof below in the comments
;OR submit a PDF with the typed proof along with this file.
; 
; input-contract: (nat? N)
; output-contract: (nat? (succ N))
;
;(define (succ N)
;  (cons 's N))
;
;Anchor case: N = zero = null
;
;LHS
;(nat? (succ zero))	                                                Premise Base Case LHS
;(nat? (succ null))	                                                zero = null
;(nat? (cons 's null))	                                                Apply definition of succ
;(and (equal? (first (cons 's null)) 's) (nat? (rest (cons 's null))))	Apply definition of nat? (cons case)
;(and (equal? 's 's) (nat? null))	                                Evaluate first and rest
;(and #t (nat? null))	                                                Evaluate equal?
;(and #t #t)	                                                        Apply definition of nat? (null case)
;#t	                                                                Evaluate and
;
;RHS
;#t                                                                     premise
;
;LHS = #t = RHS: the base case holds
;
;Inductive Hypothesis:
;(nat? (succ k))=#t
;
;LHS
;(nat? (succ (succ k)))	                                                        Premise Leap Case LHS
;(nat? (cons 's (succ k)))	                                                Apply definition of succ
;(and (equal? (first (cons 's (succ k))) 's) (nat? (rest (cons 's (succ k)))))	Apply definition of nat? (cons case)
;(and (equal? 's 's) (nat? (succ k)))                           	        Evaluate first and rest
;(and #t (nat? (succ k)))	                                                Evaluate equal?
;(and #t #t)	                                                                Invoke IH: (nat? (succ k)) = #t
;#t	                                                                        Evaluate and
;
;RHS
;#t                                                                             Premise RHS Leap Case
;
;LHS = #t = RHS, the leap case is established
;
;Both the base case and leap case have been demonstrated, thus by POMi, for any Peano number M: (nat? (succ M)) = #t
;
;
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;;;;;;;;;;;;;;Grade Summary;;;;;;;;;;;;;;;;;;;;;;;
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
(display "/10\n")
(display "Q5 Scored: ")
(display q5_score)
(display "/10\n")
(display "Q6 Scored: ")
(display q6_score)
(display "/20\n")
(display "Q7 Scored: ")
(display q7_score)
(display "/20\n")


(define grand_total (+ q1_score q2_score q3_score q4_score q5_score q6_score q7_score))
(display "\n")
(display "Total: ")
(display grand_total)
(display "/80\n")
(display "\nNOTE: last 20 points are manually graded.\n")

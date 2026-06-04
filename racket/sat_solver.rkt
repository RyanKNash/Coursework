#lang racket

(require rackunit)
(require rackunit/text-ui)

#|
CS 270 Math Foundations of CS
Create By Professor Bruce Char, Professor Mark Boady, and Professor Jeremy Johnson
Drexel University

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

; In this exercise, we will directly relate integers and boolean values.
; We will use this ability to generate partial truth tables.
; Specifically, we will generate the inputs to the function.
; Next week, we will create the truth table outputs.
; Afterwards, will will combine these parts to solve a problems.

;--------- Questions Start Here---------

; ----------Question 1----------
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


; ----------Question 2----------
; Convert an Integer to a List of true/false values.
; If we want to convert the integer 9 to a list of t/f values
; we start by finding out its remainder and quotient when divided by 2.
; (remainder 9 2) = 1
; (quotient 9 2) = 4
; This tells us the least significant bit is a 1
; We will represent 1 as #t, so the list is currently (#t)
; Next, we repeat the proccess with the quotient 4
; (remainder 4 2) = 0
; (quotient 4 2) = 2
; Zero is false, so we add this to the list (#f #t)
; Repeat with the quotient 2
; (remainder 2 2) = 0
; (quotient 2 2) = 1
; Zero is false, the list becomes (#f #f #t)
; (remainder 1 2) = 1
; (quotient 1 2) = 0
; One is true, the list because (#t #f #f #t)
; The quotient was zero meaning we can stop.

; Implement the following function
; Since we want to line up with standard binary 2^0 being the last value,
; It is easiest to make L a parameter and use a helper function.
; Note: 0 is not supported by this function.
; We will deal with it in the next part.
; Input contract: an integer such that n > 0
; Output contract: The number in binary as a list.
(define (int_to_bool n)
  (if (= n 0)
      '()
      (int_to_bool_h n '())))
; Requirement: You MAY NOT use reverse to solve this problem.
; Input Contract: an integer such that n > 0 and a list to store the values in
; Output Contract: the update list with the number in binary.
(define (int_to_bool_h n L)
  (let ((bit (if (= (remainder n 2) 1) #t #f)))
    (if (= (quotient n 2) 0)
        (cons bit L)
        (int_to_bool_h (quotient n 2) (cons bit L)))))

;Test to see if you function works correctly
(define-test-suite test_int_to_bool
  (check-equal? (int_to_bool 0) '())
  (check-equal? (int_to_bool 1) '(#t))
  (check-equal? (int_to_bool 2) '(#t #f))
  (check-equal? (int_to_bool 3) '(#t #t))
  (check-equal? (int_to_bool 4) '(#t #f #f))
  (check-equal? (int_to_bool 5) '(#t #f #t))
  (check-equal? (int_to_bool 6) '(#t #t #f))
  (check-equal? (int_to_bool 7) '(#t #t #t))
  (check-equal? (int_to_bool 8) '(#t #f #f #f))
  (check-equal? (int_to_bool 9) '(#t #f #f #t))
  (check-equal? (int_to_bool 10) '(#t #f #t #f))
  (check-equal? (int_to_bool 11) '(#t #f #t #t))
  (check-equal? (int_to_bool 12) '(#t #t #f #f))
  (check-equal? (int_to_bool 13) '(#t #t #f #t))
  (check-equal? (int_to_bool 14) '(#t #t #t #f))
  (check-equal? (int_to_bool 15) '(#t #t #t #t))
)
(display "Question 2.) int_to_bool Results (8 points)\n")
(define q2_score (* (/ 1.0 2.0) (- 16 (run-tests test_int_to_bool 'verbose))))


; ----------Question 3----------
; Only significant binary digits are stored by the above function.
; In reality, we would want every number to have the same bit length.
; Write a function to pad #f onto the front of the list.
; Input Contract: a list containing a binary number and a positive integer
; Output Contract: a list with the binary number padded to num_bits elements
(define (pad num_bits bit_list)
  (if (>= (length bit_list) num_bits)
      bit_list
      (pad num_bits (cons #f bit_list))))

;Check your function with the below tests
(define-test-suite test_pad
  (check-equal? (pad 5 (int_to_bool 0))  '(#f #f #f #f #f))
  (check-equal? (pad 5 (int_to_bool 1))  '(#f #f #f #f #t))
  (check-equal? (pad 5 (int_to_bool 2))  '(#f #f #f #t #f))
  (check-equal? (pad 5 (int_to_bool 3))  '(#f #f #f #t #t))
  (check-equal? (pad 5 (int_to_bool 4))  '(#f #f #t #f #f))
  (check-equal? (pad 5 (int_to_bool 5))  '(#f #f #t #f #t))
  (check-equal? (pad 5 (int_to_bool 6))  '(#f #f #t #t #f))
  (check-equal? (pad 5 (int_to_bool 7))  '(#f #f #t #t #t))
  (check-equal? (pad 5 (int_to_bool 8))  '(#f #t #f #f #f))
  (check-equal? (pad 5 (int_to_bool 9))  '(#f #t #f #f #t))
  (check-equal? (pad 5 (int_to_bool 10)) '(#f #t #f #t #f))
  (check-equal? (pad 5 (int_to_bool 11)) '(#f #t #f #t #t))
  (check-equal? (pad 5 (int_to_bool 12)) '(#f #t #t #f #f))
  (check-equal? (pad 5 (int_to_bool 13)) '(#f #t #t #f #t))
  (check-equal? (pad 5 (int_to_bool 14)) '(#f #t #t #t #f))
  (check-equal? (pad 5 (int_to_bool 15)) '(#f #t #t #t #t))
)
(display "Question 3.) pad Results (8 points)\n")
(define q3_score (* (/ 1.0 2.0) (- 16 (run-tests test_pad 'verbose))))

; ----------Question 4----------
; Generate a Truth Table
; Given a number of variables n
; generate a truth table will all variable settings.
; The truth table should have rows with values starting at
; 2^n-1 and ending at 0.
; For example, the truth tables for n=2 is
; ( (#t #t) (#t #f) (#f #t) (#f #f) )
; Notice: A "Table" is a list of lists
; As integers this is (3 2 1 0)
; The number of bits is n.

; Define the below function
; Input Contract: an non-negative integer n
; Output Contract: a truth table inputs for an n variable boolean function
(define (tt_inputs n)
  (tt_inputs_h n (- (expt 2 n) 1))
)
; Input Contract: the number of bits needed for n variables
;                 and the current row's integer value
; Output Contract:  a truth table inputs for an "bits" variable boolean function
(define (tt_inputs_h bits row_val)
  (cond
    [(< row_val 0) '()]
    [(and (= bits 0) (= row_val 0))
     (cons '() '())]
    [(= row_val 0)
     (cons (pad bits '(#f))
           (tt_inputs_h bits (- row_val 1)))]
    [else
     (cons (pad bits (int_to_bool row_val))
           (tt_inputs_h bits (- row_val 1)))]))
;Check your function with the following tests
(define-test-suite test_tt
  (check-equal? (tt_inputs 0)
                '(())
  )
  (check-equal? (tt_inputs 1)
                '( (#t) (#f) )
  )
  (check-equal? (tt_inputs 2)
                '( (#t #t)
                   (#t #f)
                   (#f #t)
                   (#f #f))
  )
  (check-equal? (tt_inputs 3)
                '( (#t #t #t)
                   (#t #t #f)
                   (#t #f #t)
                   (#t #f #f)
                   (#f #t #t)
                   (#f #t #f)
                   (#f #f #t)
                   (#f #f #f)
                   )
   )
   (check-equal? (tt_inputs 4)
                '(
                   (#t #t #t #t)
                   (#t #t #t #f)
                   (#t #t #f #t)
                   (#t #t #f #f)
                   (#t #f #t #t)
                   (#t #f #t #f)
                   (#t #f #f #t)
                   (#t #f #f #f)
                   (#f #t #t #t)
                   (#f #t #t #f)
                   (#f #t #f #t)
                   (#f #t #f #f)
                   (#f #f #t #t)
                   (#f #f #t #f)
                   (#f #f #f #t)
                   (#f #f #f #f)
                   )
   )
)
(display "Question 4.) tt_inputs Results (10 points)\n")
(define q4_score (- 10 (* 2 (run-tests test_tt 'verbose))))

; ----------Question 5----------
; The inputs we made above have the format '(#t #f #f #t).
; We need boolean expressions that work with this format.
; We will make function that take a list as input
; This function implements (A->B)
; Input Contract: a list with two true/false values
; Ouput Contract: the result of A -> B using given values
(define (implies_example boolean_vars)
  (let (;Start of name list
        (a (list-ref boolean_vars 0));Pairs (name value)
        (b (list-ref boolean_vars 1))
      );End of name list
    (or (not a) b)
 );end of let
)

;Test Implies Def
(define-test-suite test_implies
  (check-equal? (implies_example '(#t #t)) #t)
  (check-equal? (implies_example '(#t #f)) #f)
  (check-equal? (implies_example '(#f #t)) #t)
  (check-equal? (implies_example '(#f #f)) #t)
)
(display "Example.) Results of Implies Example\n")
(run-tests test_implies)


; Write the following three simple boolean expressions as functions. 
; Question 5a
; a.) Example Function 1
; implement ~(~a v (b v ~a) )
; Input Contract: a list with exaclty two true/false values
; Ouput Contract: the result of ~(~a v (b v ~a) ) using inputs
(define (example_expr1 bool_vars)
  (let (
        (a (list-ref bool_vars 0))
        (b (list-ref bool_vars 1))
       )
    (not (or (not a) (or b (not a))))
  )
)

;Test Implies Def
(define-test-suite test_ex1
  (check-equal? (example_expr1 '(#t #t)) #f)
  (check-equal? (example_expr1 '(#t #f)) #t)
  (check-equal? (example_expr1 '(#f #t)) #f)
  (check-equal? (example_expr1 '(#f #f)) #f)
)
(display "5a.) Results of Example Function 1 (8 points)\n")
(define q5a_score (- 8 (* 2 (run-tests test_ex1 'verbose))))

; Question 5b
; b.) Example Function 2
; implement (a and b) or (~a and ~b)
; Input Contract: a list with exaclty two true/false values
; Ouput Contract: the result of (a and b) or (~a and ~b) using inputs
(define (example_expr2 bool_vars)
  (let (
        (a (list-ref bool_vars 0))
        (b (list-ref bool_vars 1))
       )
    (or (and a b)
        (and (not a) (not b)))
  )
)

;Test Implies Def
(define-test-suite test_ex2
  (check-equal? (example_expr2 '(#t #t)) #t)
  (check-equal? (example_expr2 '(#t #f)) #f)
  (check-equal? (example_expr2 '(#f #t)) #f)
  (check-equal? (example_expr2 '(#f #f)) #t)
)
(display "5b.) Results of Example Function 2 (8 points)\n")
(define q5b_score (- 8 (* 2 (run-tests test_ex2 'verbose))))

; Question 5c
; c.) Example Function 3
; implement (a and (not b) and c)
; Input Contract: a list with exaclty three true/false values
; Ouput Contract: the result of (a and (not b) and c) using inputs
(define (example_expr3 bool_vars)
  (let (
        (a (list-ref bool_vars 0))
        (b (list-ref bool_vars 1))
        (c (list-ref bool_vars 2))
       )
    (and a (not b) c)
  )
)

;Test Implies Def
(define-test-suite test_ex3
  (check-equal? (example_expr3 '(#t #t #t)) #f)
  (check-equal? (example_expr3 '(#t #t #f)) #f)
  (check-equal? (example_expr3 '(#t #f #t)) #t)
  (check-equal? (example_expr3 '(#t #f #f)) #f)
  (check-equal? (example_expr3 '(#f #t #t)) #f)
  (check-equal? (example_expr3 '(#f #t #f)) #f)
  (check-equal? (example_expr3 '(#f #f #t)) #f)
  (check-equal? (example_expr3 '(#f #f #f)) #f)
)
(display "5c.) Results of Example Function 3 (16 points)\n")
(define q5c_score (- 16 (* 2 (run-tests test_ex3 'verbose))))

; ----------Question 6----------
; Write a function that takes
; fun - a function that takes a list of boolean values and returns a boolean
; tt - a truth table (list of lists of T/F values)
; And returns a list of T/F values with results
; For example if fun computes (not a)
; and tt = ( (#t) (#f) )
; Then the return of
; (evaluate_tt fun tt) should be (#f #t)
; Input Contract: a function and truth table that both have same number of inputs
; Output Contract: the result of runing the function on all inputs in the truth table
(define (evaluate_tt fun tt)
  (if (empty? tt)
      '()
      (cons (fun (first tt))
            (evaluate_tt fun (rest tt)))))

;Test your function
(define-test-suite test_eval_tt
  (check-equal?
   (evaluate_tt implies_example '( (#t #t) (#t #f) (#f #t) (#f #f)))
   '(#t #f #t #t)
  )
  (check-equal?
   (evaluate_tt example_expr1 '( (#t #t) (#t #f) (#f #t) (#f #f)))
   '(#f #t #f #f)
  )
  (check-equal?
   (evaluate_tt example_expr2 '( (#t #t) (#t #f) (#f #t) (#f #f)))
   '(#t #f #f #t)
  )
  (check-equal?
   (evaluate_tt example_expr3 '( (#t #t #t)
                   (#t #t #f)
                   (#t #f #t)
                   (#t #f #f)
                   (#f #t #t)
                   (#f #t #f)
                   (#f #f #t)
                   (#f #f #f)
                   ))
   '(#f #f #t #f #f #f #f #f)
  )
)
(display "6.) Results of Evaluate on Truth Table (12 points)\n")
(define q6_score (- 12 (* 3 (run-tests test_eval_tt 'verbose))))

; ----------Question 7----------
; Write a function that converts a list of T/F values
; back to an integer
; This function is the inverse of Q1
; The list is reversed for you in this function
; Input Contract: a list of true/false values representing a binary number
; Output Contract: the integer represented in binary
(define (bool_to_int values)
  (bool_to_int_h (reverse values) 0)
)
; Implement this helper function
; values - the list of #t/#f false
; exp - the current power of 2 you are on
; Input Contract: a list of true/false values representing a binary number
;             and the current power of 2 position in the list
; Output Contract: the integer represented in binary
(define (bool_to_int_h values exp)
  (if (empty? values)
      0
      (+ (if (first values) (expt 2 exp) 0)
         (bool_to_int_h (rest values) (+ exp 1)))))

;Test your function
(define-test-suite test_b2i
  (check-equal? (bool_to_int '(#f #f #f #f)) 0)
  (check-equal? (bool_to_int '(#f #f #f #t)) 1)
  (check-equal? (bool_to_int '(#f #f #t #f)) 2)
  (check-equal? (bool_to_int '(#f #f #t #t)) 3)
  (check-equal? (bool_to_int '(#f #t #f #f)) 4)
  (check-equal? (bool_to_int '(#f #t #f #t)) 5)
  (check-equal? (bool_to_int '(#f #t #t #f)) 6)
  (check-equal? (bool_to_int '(#f #t #t #t)) 7)
  (check-equal? (bool_to_int '(#t #f #f #f)) 8)
  (check-equal? (bool_to_int '()) 0)
  (check-equal? (bool_to_int '(#t)) 1)
  (check-equal? (bool_to_int '(#t #f)) 2)
  (check-equal? (bool_to_int '(#t #t)) 3)
  (check-equal? (bool_to_int '(#t #f #f)) 4)
  (check-equal? (bool_to_int '(#t #f #t)) 5)
  (check-equal? (bool_to_int '(#t #t #f)) 6)
)
(display "7.) Results of Bool to Int (16 points)\n")
(define q7_score (- 16 (run-tests test_b2i 'verbose)))

; ----------Question 8----------
; Write a function that takes a function and the number of variables it has
; and determines which inputs make the function return true
; Display the inputs that make the function return true as integers
; For example (or a b) is true when '(#t #t) '(#t #f) '(#f #t)
; so the answer would be '(3 2 1) it is true for any of those integers
; in binary
; Hint: Look up the filter command in the Racket documentation
; Input Contract: a function and the count of boolean inputs it takes
; Output Contract: a list of integers telling the binary inputs
;                 that cause the function to return true.
; Hint: Everything you did above was to help with this function!
(define (sat_solve func n)
  (map bool_to_int
       (filter func (tt_inputs n))))

;Test your function
(define-test-suite test_sat_solve
  (check-equal? (sat_solve implies_example 2) '(3 1 0))
  (check-equal? (sat_solve example_expr1 2) '(2))
  (check-equal? (sat_solve example_expr2 2) '(3 0))
  (check-equal? (sat_solve example_expr3 3) '(5))
  (check-equal? (sat_solve (lambda (X) (and (first X) (second X))) 2) '(3))
  (check-equal? (sat_solve (lambda (X) (or (first X) (second X))) 2) '(3 2 1))
)
(display "8.) Results of SAT Solver Question (12 points)\n")
(define q8_score (- 12 (* 2 (run-tests test_sat_solve 'verbose))))


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
(display "/8\n")
(display "Q4 Scored: ")
(display q4_score)
(display "/10\n")
(display "Q5 Scored: ")
(display (+ q5a_score q5b_score q5c_score))
(display "/32\n")
(display "Q6 Scored: ")
(display q6_score)
(display "/12\n")
(display "Q7 Scored: ")
(display q7_score)
(display "/16\n")
(display "Q8 Scored: ")
(display q8_score)
(display "/12\n")

(define grand_total (+ q1_score q2_score q3_score q4_score q5a_score q5b_score q5c_score q6_score q7_score q8_score))
(display "\n")
(display "Total: ")
(display grand_total)
(display "/100\n")
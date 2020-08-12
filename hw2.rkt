#lang typed/racket

(require "cs151-core.rkt")
(require/typed/provide
 2htdp/image)

(require typed/test-engine/racket-tests)


;;problem 2
(: number->digits : Integer -> (Listof Integer))
(define (number->digits num)
  (map (lambda((i : Integer))(- i 48))
       (map char->integer
            (string->list
             (number->string num)))))

(: contain-digit? : Integer Integer -> Boolean)
(define (contain-digit? num digit)
  (if(<= 0 digit 9)
     (not(not(member digit (number->digits num))))
     (error "contains-digit?: digit must be in the range 0-9")
     ))


(: all-digit>=? : Integer Integer -> Boolean)
(define (all-digit>=? num digit)
  (foldr (lambda((d : Integer) (l : Boolean))
           (and (>= d digit) l))
         #t
         (number->digits num)))

(: at-least-k-occurrences? (Integer Integer Integer -> Boolean))
(define (at-least-k-occurrences? num digit k)
  (>= (foldr (lambda((d : Integer) (l : Integer))
               (if(= d digit)
                  (+ l 1)
                  l))
             0
             (number->digits num))
      k))

(check-expect (at-least-k-occurrences? 243534346444 4 7) false)
(check-expect (at-least-k-occurrences? 243534346444 4 3) true)


;;problem 3
(define-struct Activity
  ((min-standing : Integer)
   (cals-burned : Integer)
   (min-elev-hr : Integer)))

(: fat-burned : (Activity -> Exact-Rational))
(define (fat-burned activity)
  (/ (Activity-cals-burned activity) 3500))

(check-expect (fat-burned (Activity 30 3500 30)) 1)

(: cals-per-min (Activity -> Exact-Rational))
(define (cals-per-min acti)
  (/ (Activity-cals-burned acti)
     (Activity-min-elev-hr acti)))
(check-expect (cals-per-min (Activity 30 300 30)) 10)

(: add-activities : (Activity Activity -> Activity))
(define (add-activities act1 act2)
  (Activity
   (+ (Activity-min-standing act1) (Activity-min-standing act2))
   (+ (Activity-cals-burned act1) (Activity-cals-burned act2))
   (+ (Activity-min-elev-hr act1) (Activity-min-elev-hr act2))))

(check-expect (add-activities (Activity 1 1 1) (Activity 1 1 1))
              (Activity 2 2 2))

(: as-good? : (Activity Activity -> Boolean))
(define (as-good? act1 act2)
  (and(= (Activity-min-standing act1) (Activity-min-standing act2))
      (= (Activity-cals-burned act1) (Activity-cals-burned act2))
      (= (Activity-min-elev-hr act1) (Activity-min-elev-hr act2))))

(check-expect (as-good? (Activity 1 1 1) (Activity 1 1 1))
              #t)



(test)


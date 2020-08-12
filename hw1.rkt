#lang typed/racket

(require "cs151-core.rkt")
(require typed/test-engine/racket-tests)


;;problem 1
(: f->c : Exact-Rational -> Exact-Rational)
(define (f->c i)
  i)

(: eval-quadratic : Real Real Real Real -> Real)
(define (eval-quadratic a b c x)
  (+ (* a (square x)) (* b x) c))


(: square : Real -> Real)
(define (square x)
  (* x x))

(: distance : Real Real Real Real -> Real)
(define (distance x1 y1 x2 y2)
  (sqrt (+ (square (- x1 x2))
           (square (- y1 y2)))
           )
  )

(: low-battery? : Real -> Boolean)
(define (low-battery? percentage)
  (if (>= percentage 0.3)
      #f
      #t))

(: chicago-zip? : Integer -> Boolean)
(define (chicago-zip? zip-code)
  (if(< 60599 zip-code 60700)
     #t
     #f))

(: vector-add-x (Real Real Real Real -> Real))
(define (vector-add-x x y z h)
  (+ x y z h))

;;problem 4
(: lemons (Integer Integer -> Integer))
(define (lemons adults children)
  (exact-ceiling (+ (/ adults 3) (/ children 4))))

(: lemons-in-bags (Integer Integer -> Integer))
(define (lemons-in-bags adults children)
  (exact-ceiling (/ (lemons adults children) 5)))

;;problem 5


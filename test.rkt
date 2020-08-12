#lang typed/racket

(require "cs151-core.rkt")
(: sq (-> Number Number))
(define (sq x)
  (* x x))

;;(:print-type expression)

(: f : Boolean Number Number -> Number)
;; test program
;;
(define (f flg a b)
  (cond [flg (sq a b)]
        [else 1]))
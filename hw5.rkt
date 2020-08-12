#lang typed/racket
(require "cs151-core.rkt")


(require typed/test-engine/racket-tests)

(define-struct (Pr A B)
  ([a : A]
   [b : B]))

(define-struct (Some A)
  ([value : A]))

(define-type (Optional A)
  (U 'None (Some A)))

(define-type (Compare A)
  (A A -> Boolean))

(define-type (BSTree A)
  (U 'E (Nd A)))

(define-struct (Nd A)
  ([root    : A]
   [count   : Integer]
   [lesser  : (BSTree A)]
   [greater : (BSTree A)]))

(define-struct (BST A)
  ([less-than : (Compare A)]
   [tree-data : (BSTree A)]))
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


(: make-empty : All (A) (Compare A) -> (BST A))
(define (make-empty f)
  (BST f 'E))

(: singleton : All(A)(Compare A) A -> (BST A))
(define (singleton f a)
  (BST f (Nd a 1 'E 'E)))


(: insertNode : All(A) (BSTree A) (Compare A) A -> (BSTree A))
(define (insertNode tree f a)
  (match tree
    ['E (Nd a 1 'E 'E)]
    [(Nd t count left right)
     #:when(f a t)
     (Nd t  count (insertNode left f a) right)]
    [(Nd (== a) count left right) ;;匹配是字面量
     (Nd a (+ count 1) left right)]
    [(Nd t count left right)
     #:when(not(f a t)) 
     (Nd t  count left (insertNode right f a))]
    ))

(: insert : All(A) A (BST A) -> (BST A))
(define (insert a abst)
  (match abst
    [(BST f 'E)
     (BST f (Nd a 1 'E 'E))]
    [(BST f nd)
     (BST f (insertNode nd f a))]))


(: contains-t? : All(A) A (BSTree A) (Compare A) -> Boolean)
(define (contains-t? a btree f)
  (match btree
    ['E #f]
    [(Nd (== a) count left right)
     #t]
    [(Nd t _ left right)
     (if(f a t)
        (contains-t? a left f)
        (contains-t? a right f))]))
     



(: contains? : All(A) A (BST A) -> Boolean)
(define (contains? a abst)
  (contains-t? a (BST-tree-data abst) (BST-less-than abst)))




(define testTree
  (singleton (lambda((a : Integer)(t : Integer))
               (< a t))
             1))


(insert 1 testTree)
(insert 2 testTree)
(insert 3 testTree)
(insert 5 testTree)

(contains? 1 testTree)
(contains? 2 testTree)

(define strTree
  (singleton (lambda((a : String)(t : String))
               (string<? a t))
             "aa"))


(insert "a" strTree)
(insert "eer" strTree)
(insert "3aa" strTree)
(insert "aa" strTree)

(contains? "aa" strTree)
(contains? "a" strTree)


(define-type Piece (U 'Black 'Red))

(define-type Square (Optional Piece))

(define-type Board (Listof Square))

(define-struct Loc
  ([row : Integer]
   [col : Integer]))

(define-struct PiecePos
  ([pos   : Loc]
   [piece : Piece]))

(define-type SparseBoard (Listof PiecePos))

(: board-ref2 : SparseBoard Loc -> Square)
(define (board-ref2 b l)
  (match* (b l)
    [('() _) 'None]
    [((cons (PiecePos (Loc br bc) bp) tl) (Loc lr lc))
      (if (and (= br lr) (= bc lc)) (Some bp)
        (board-ref2 tl l))]))

(define-type Matrix (Listof (Listof Integer)))

(: dot-product : (Listof Integer) (Listof Integer) -> Integer)
(define (dot-product x y)
  (match* (x y)
    [('() '()) 0]
    [((cons xh xt) (cons yh yt))
      (+ (* xh yh) (dot-product xt yt))]
    [(_ _) (error "dimension mismatch")]))

(: do-row : (Listof Integer) Matrix -> (Listof Integer))
(define (do-row row m2)
  (match m2
    ['() '()]
    [(cons col tl)
      (cons (dot-product row col) (do-row row tl))]))

(: matrix* : Matrix Matrix -> Matrix)
(define (matrix* m1 m2)
  (match m1
    ['() '()]
    [(cons row rst)
      (cons (do-row row m2)
        (matrix* rst m2))]))
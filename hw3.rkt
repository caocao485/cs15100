#lang typed/racket

(require "cs151-core.rkt")


(require typed/test-engine/racket-tests)




(define-type CardBrand
  (U 'AmEx 'WorkPermit 'DisasterCard 'Coverup))

(define-struct CreditCard
  ((type : CardBrand)
   (num : Integer)))


(: brand-digit (CardBrand -> Integer))
(define (brand-digit cb)
  (match cb
    ['AmEx 3]
    ['WorkPermit 4]
    ['DisasterCard 5]
    ['Coverup 6]))

(: brand-valid? (CreditCard -> Boolean))
(define (brand-valid? cc)
  (= (brand-digit (CreditCard-type cc))
     (CreditCard-num cc)))

;;problem 2
(: number->digits : Integer -> (Listof Integer))
(define (number->digits num)
  (map (lambda((i : Integer))(- i 48))
       (map char->integer
            (string->list
             (number->string num)))))

(: number->CreditCard (Integer -> CardBrand))
(define (number->CreditCard num)
  (match num
    [ 3 'AmEx]
    [ 4 'WorkPermit]
    [ 5 'DisasterCard]
    [ 6 'Coverup ]
    [ _ (error "card number does not correspond to any recognized brand")]))

(: build-card (Integer -> CreditCard))
(define (build-card num)
  (CreditCard
   (number->CreditCard (first (number->digits num)))
   num))


;;problem 2

(define-type IntTree (U IntNode 'IEmpty))

(define-struct IntNode
  ([val   : Integer]
   [left  : IntTree]
   [right : IntTree]))

(define-type StringTree (U StringNode 'SEmpty))

(define-struct StringNode
  ([val   : String]
   [left  : StringTree]
   [right : StringTree]))

(: mirror : (IntTree -> IntTree))
(define (mirror it)
  (match it
    ['IEmpty 'IEmpty]
    [(IntNode val left right)
     (IntNode val (mirror right) (mirror left))]))

(: int-tree->string-tree (IntTree -> StringTree))
(define (int-tree->string-tree it)
    (match it
    ['IEmpty 'SEmpty]
    [(IntNode val left right)
     (StringNode (number->string val)
              (int-tree->string-tree left)
              (int-tree->string-tree right))]))

(int-tree->string-tree (IntNode 1 (IntNode 5 'IEmpty 'IEmpty)
                                (IntNode 4 'IEmpty 'IEmpty)))

(: right-edge : (StringTree -> String))
(define (right-edge st)
  (match st
    ['SEmpty ""]
    [(StringNode val left right)
    (string-append val
                   (right-edge right))]))


;;problem 3
(define-type 3Tree (U 3Node '3Empty))

(define-struct 3Node
  ([root : Integer]
   [lsub : 3Tree]
   [msub : 3Tree]
   [rsub : 3Tree]))

(define tree (3Node 1
       (3Node 2
              (3Node 3 '3Empty '3Empty '3Empty)
              (3Node 4 '3Empty '3Empty '3Empty)
              '3Empty)
       (3Node 8
              '3Empty
              (3Node 7
                     (3Node 5 '3Empty '3Empty '3Empty)
                     '3Empty
                     (3Node 6 '3Empty '3Empty '3Empty))
              '3Empty)
       (3Node 9
              '3Empty
              '3Empty
              (3Node 0 '3Empty '3Empty '3Empty))))

(: num-nodes : 3Tree -> Integer)
(define (num-nodes tt)
  (match tt
    ['3Empty 0]
    [(3Node root lsub msub rsub)
     (+ 1
        (num-nodes lsub)
        (num-nodes msub)
        (num-nodes rsub))]))

(: sum-nodes : 3Tree -> Integer)
(define (sum-nodes tt)
  (match tt
    ['3Empty 0]
    [(3Node root lsub msub rsub)
     (+ root
        (sum-nodes lsub)
        (sum-nodes msub)
        (sum-nodes rsub))]))

(: height : 3Tree ->  Integer)
(define (height tt)
  (match tt
    ['3Empty 0]
    [(3Node root lsub msub rsub)
     (+ 1
        (max
         (height lsub)
         (height msub)
         (height rsub)))]))

(: contains? : 3Tree Integer -> Boolean)
(define (contains? tt num)
  (match tt
    ['3Empty false]
    [(3Node root lsub msub rsub)
     (or (= root num)
         (contains? lsub num)
         (contains? msub num)
         (contains? rsub num))]))

(: leftmost : 3Tree -> (U Integer 'None))
(define(leftmost tt)
  (match tt
    ['3Empty 'None]
    [(3Node root '3Empty _  _)
     root]
    [(3Node root lsub msub rsub)
     (leftmost lsub)]))

(define-type IVN (U IV 'None))

(define-struct IV
  ((acc : Integer)
   (value : Integer)))

(: farthest-item : 3Tree -> (U Integer 'None))
(define (farthest-item tt)
  (local {(: iter : 3Tree Integer -> IVN)
            (define (iter rt count)
             (match rt
               ['3Empty 'None]
               [(3Node root '3Empty '3Empty  '3Empty)
                (IV count root)]
               [(3Node root lsub msub rsub)
                (foldr
                 (lambda((l : IVN)(r : IVN))
                   (match r
                     ['None l]
                     [(IV acc value)
                      (match l
                        ['None r]
                        [(IV l-acc _)
                         (if(> acc l-acc)
                            r
                            l)])]))
                 'None
                 (map (lambda((little-tree : 3Tree))
                        (iter little-tree (+ count 1)))
                      (list lsub msub rsub)))]))}
    (match (iter tt 0)
      ['3Empty 'None]
      [(IV acc value)
       value])))

(farthest-item tree)
        
(: increment : 3Tree -> 3Tree)
(define (increment tt)
  (match tt
    ['3Empty '3Empty]
    [(3Node root lsub msub rsub)
     (3Node (+ root 1)
            (increment lsub)
            (increment msub)
            (increment rsub))]))
                
(increment tree)


;;problem 4
(define-type Category (U 'Book 'Food 'Electronics))
(define-struct Product
  ((name : String)
   (cat : Category)
   (price : Integer)))

(define-type Products (U 'NoProducts ProductCons))
(define-struct ProductCons
  ([p    : Product]
   [rest : Products]))



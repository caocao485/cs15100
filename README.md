[CMSC 15100 Style guide](http://people.cs.uchicago.edu/~adamshaw/cmsc15100-2017/typed-racket-guide/style-guide.html)

1. 类型签名：**(: name : type) （:print-type expression）**

   1. 匿名函数的标识和struct的标识与一般的不同

   ```jsx
   (lambda ([param-1 : ty-1] ... [param-n : ty-n]) expr)
   ```

2. 基本类型：

   1. Natural
   2. Integer
   3. Exact-Rational
   4. Real
   5. Number
   6. Boolean
   7. String
   8. Symbol
   9. 

3. 作用：减少错误、性能优化、利于阅读

4. 词法作用域：静态作用域

5. union type： (: U T_1 T_2 ... T_k)

6. single type：**枚举类型**

   ```jsx
   (: R : 'red)
   (define R 'red)
   
   This kind of type is called a singleton type, since it is a type that has 
   exactly one value. By combining multiple singleton types in a union, 
   we can describe enumeration types. For example, our color type is 
   the union of 'red, 'green, and 'blue. Two other useful singleton 
   types are #t and #f (as one might guess, Boolean is the union of #t and #f).
   
   (: color-to-string : (U 'red 'green 'blue) -> String)
   ;; convert a color to a string
   (define (color-to-string c)
     (cond
       [(symbol=? c 'red) "red"]
       [(symbol=? c 'blue) "blue"]
       [else "green"]))
   ```

7. Type definitions：

   ```jsx
   ;; A color is one of 'red, 'blue, or 'green.
   we can give an explicit definition using the define-type construct
   
   (define-type Color (U 'red 'blue 'green))
   ```

8. Subtyping

   ```jsx
   使用U
   ```

9. Pattern-matching gotchas：

   [Patterns and pattern matching](http://people.cs.uchicago.edu/~adamshaw/cmsc15100-2017/typed-racket-guide/part-06.html)

10. 递归类型

11. 多态函数和多态类型

    ```jsx
    (All (A B) (Two-Things A B) -> (Two-Things B A))
    is called universal quantification and it means 
    "for all types A and B a function from (Two-Things A B) to (Two-Things B A)". 
    If we apply swap to a value of type (Two-Things Integer Boolean)
    ```

12. 高阶函数

13. Listof和Vectorof

14. 命令式：

    (void)：

15. ctrl + i 格式化代码

16. optional，要么空，要么有值。maybe，maybe monad

17. 将现存类型命名成新类型

18. match*：模式匹配多个值

19. match：== **相等扩展**

https://blog.csdn.net/yeswenqian/article/details/22291675

boxOf

cast
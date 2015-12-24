(in-package #:cl-kafka-test)
(ok "hi")

(defun nlet-fact (n)
  (nlet fact ((n n))
    (if (zerop n)
      1
      (* n (fact (- n 1))))))


(defmacro nif (expr pos zero neg)
  (let ((g (gensym)))
    `(let ((,g ,expr))
       (cond ((plusp ,g) ,pos)
             ((zerop ,g) ,zero)
             (t ,neg)))))



(macroexpand '(nif 1 :positive :zero :negative))

(macroexpand '(eq '#:x '#:x))






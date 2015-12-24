(in-package #:cl-kafka)

(defmacro nlet (n letargs &rest body)
  `(labels ((,n ,(mapcar #'car letargs) ,@body))
     (,n ,@(mapcar #'cadr letargs))))


(defun g!-symbol-p (s)
  (and (symbolp s)
       (> (length (symbol-name s)) 2)
       (string= (symbol-name s) "G!" :start1 0 :end1 2)))

(defun flatten (structure)
  (cond ((null structure) nil)
        ((atom structure) (list structure))
        (t (mapcan #'flatten structure))))

(defmacro defmacro/g!  (name args &rest body)
  (let ((syms (remove-duplicates (remove-if-not #'g!-symbol-p (flatten body)))))
    `(defmacro ,name ,args
       (let ,(mapcar (lambda (s) `(,s (gensym))) syms)
         ,@body))))



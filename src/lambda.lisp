(in-package #:cl-kafka)

(defmacro nlet (n letargs &rest body)
  `(labels ((,n ,(mapcar #'car letargs) ,@body))
     (,n ,@(mapcar #'cadr letargs))))

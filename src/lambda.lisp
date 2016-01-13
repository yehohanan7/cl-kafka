(in-package #:cl-kafka)

(defun flatten (structure)
  (cond ((null structure) nil)
        ((atom structure) (list structure))
        (t (mapcan #'flatten structure))))


(defun equalp* (first &rest rest)
  (every #'(lambda (x) (equalp first x)) rest))



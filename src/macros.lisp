(in-package #:cl-kafka)

(defmacro defmacro/g!  (name args &rest body)
  (let ((syms (remove-duplicates (remove-if-not #'g!-symbol-p (flatten body)))))
    `(defmacro ,name ,args
       (let ,(mapcar (lambda (s) `(,s (gensym))) syms)
         ,@body))))

(defmacro nlet (n letargs &rest body)
  `(labels ((,n ,(mapcar #'car letargs) ,@body))
     (,n ,@(mapcar #'cadr letargs))))

(defun g!-symbol-p (s)
  (and (symbolp s)
       (> (length (symbol-name s)) 2)
       (string= (symbol-name s) "G!" :start1 0 :end1 2)))

;; message macros
(defun encoder (field)
  (case (cadr field)
    (:int16 #'encode-int16)
    (:int32 #'encode-int32)
    (:string #'encode-string)
    (:array #'encode-array)))

(defun clos-slot (field)
  (destructuring-bind (name type &optional default-value) field
    (let ((slot `(,name :accessor ,name :initarg ,(intern (symbol-name name) :keyword))))
      (if default-value
          (append slot `(:initform ,default-value))
          slot))))

(defun clos-slots (fields)
  (mapcar #'clos-slot fields))

(defmacro define-message (name superclasses fields)
  `(progn
     (defclass ,name ,superclasses
       ,(clos-slots fields))
     
     (defmethod encode ((message ,name) stream)
       (let ((encoded-message))
         (dolist (field ',fields)
           (let* ((encoder (encoder field))
                  (encoded-value (funcall encoder (slot-value message (car field)))))
             (setf encoded-message (concatenate 'vector encoded-message encoded-value))))
         (write-sequence (concatenate 'vector (encode-int32 (length encoded-message)) encoded-message) stream)
         (force-output stream)))))




(in-package #:cl-kafka)

(defun g!-symbol-p (s)
  (and (symbolp s)
       (> (length (symbol-name s)) 2)
       (string= (symbol-name s) "G!" :start1 0 :end1 2)))

(defmacro defmacro/g!  (name args &rest body)
  (let ((syms (remove-duplicates (remove-if-not #'g!-symbol-p (flatten body)))))
    `(defmacro ,name ,args
       (let ,(mapcar (lambda (s) `(,s (gensym))) syms)
         ,@body))))

;; message macros
(defun clos-slot (field)
  (destructuring-bind (name &optional default-value) field
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
       (let ((ims (flexi-streams:make-in-memory-output-stream)))
         (dolist (field ',fields)
           (encode (slot-value message (car field)) ims))
         (let ((ims-sequence (flexi-streams:get-output-stream-sequence ims)))
           (encode (int32 (length ims-sequence)) stream)
           (write-sequence ims-sequence stream)
           (force-output stream))))

     (defmethod decode ((message ,name) stream)
       (let ((response (make-instance ',name)))
         ,@(mapcar #'(lambda (field) `(setf (,(car field) response) (decode (,(car field) response) stream))) fields)
         response))

     (defun ,name ()
       (make-instance ',name))))


(defun decode-response (name stream)
  (let* ((size (read-bytes 32 stream)))
    (decode (make-instance name) stream)))

(defun encode-request (name stream &key (correlation-id 123))
  (encode (make-instance name :correlation-id (int32 correlation-id)) stream))



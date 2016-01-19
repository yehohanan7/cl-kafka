(in-package #:cl-kafka)

(defun to-slot (field)
  (destructuring-bind (name &optional value) field
    `(,name :accessor ,name :initarg ,(intern (symbol-name name) :keyword) :initform ,value)))

(defmacro define-message (name superclasses fields)
  `(progn
     
     (defclass ,name ,superclasses
       ,(mapcar #'(lambda (field) (to-slot field)) fields))
     
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
         (dolist (field ',fields)
           (let ((field-name (car field)))
             (setf (slot-value response field-name)
                 (decode (slot-value response field-name) stream))))
         response))

     (defun ,name ()
       (make-instance ',name))))

(defun decode-response (name stream)
  (let* ((size (read-bytes 32 stream)))
    (decode (make-instance name) stream)))

(defun encode-request (name stream &key (correlation-id 123))
  (encode (make-instance name :correlation-id (int32 correlation-id)) stream))



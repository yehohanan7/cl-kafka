(defpackage #:cl-kafka-response
  (:use #:cl #:cl-kafka-decoder #:cl-kafka-lambda))

(in-package #:cl-kafka-response)

(defun write-bytes (value n stream)
  (loop for i from (/ n 8) downto 1
        do  (write-byte (ldb (byte 8 (* (1- i) 8)) value) stream)))

(defmacro/g! bytes (n value)
  `(let* ((g!ims (flexi-streams:make-in-memory-output-stream))
          (g!stream (flexi-streams:make-flexi-stream g!ims)))
     (write-bytes ,value ,n g!stream)
     (force-output g!stream)
     (flexi-streams:get-output-stream-sequence g!ims)))

(defun encode-int16 (value)
  (bytes 16 value))

(defun encode-int32 (value)
  (bytes 32 value))

(defun encode-string (value)
  (concatenate 'vector (encode-int16 (length value)) (flexi-streams:string-to-octets value)))

(defun encode-array (value)
  "fix me"
  (encode-int32 (length value)))

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
     
     (defmethod encode ((message ,name))
       (let ((encoded-message))
         (dolist (field ',fields)
           (let* ((encoder (encoder field))
                  (encoded-value (funcall encoder (slot-value message (car field)))))
             (setf encoded-message (concatenate 'vector encoded-message encoded-value))))
         (concatenate 'vector (encode-int32 (length encoded-message)) encoded-message)))))


(define-message get-meta-data ()
  ((api-key :int16 3)
   (api-version :int16 0)
   (correlation-id :int32)
   (client-id :string "cl-kafka")
   (topics :array '())))


(encode (make-instance 'get-meta-data :correlation-id 123))

(get-meta-data "localhost" 9092)

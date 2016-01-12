(in-package #:cl-kafka)

(defmacro define-type (name)
  `(progn
     (defclass ,name ()
       ((value :accessor value :initarg :value)))

     (defun ,name (&optional value)
       (make-instance ',name :value value))))

(define-type int16)
(define-type int32)


(defclass barray ()
  ((element-type :accessor element-type :initarg :element-type)
   (elements :accessor elements :initarg :elements)))

(defun barray (element-type &optional elements)
  (make-instance 'barray :element-type element-type :elements elements))

;; encoders
(defun write-bytes (value n stream)
  (loop for i from (/ n 8) downto 1
        do  (write-byte (ldb (byte 8 (* (1- i) 8)) value) stream)))

(defmethod encode ((element int16) stream)
  (write-bytes (value element) 16 stream))

(defmethod encode ((element int32) stream)
  (write-bytes (value element) 32 stream))

(defmethod encode ((value string) stream)
  (encode (int16 (length value)) stream)
  (write-sequence (flexi-streams:string-to-octets value) stream))

(defmethod encode ((barray barray) stream)
  (let ((size (length (elements barray))))
    (encode (int32 size) stream)
    (dolist (x (elements barray))
      (encode x stream))))

;; decoders
(defun read-bytes (n stream)
  (let ((value 0) (byte-size (/ n 8)))
    (dotimes (i byte-size)
      (setf value (+ (* value #x100) (read-byte stream))))
    value))

(defmethod decode ((element int16) stream)
  (int16 (read-bytes 16 stream)))

(defmethod decode ((element int32) stream)
  (int32 (read-bytes 32 stream)))

(defmethod decode ((element string) stream)
  (let* ((size (read-bytes 16 stream))
         (bytes (make-array size :fill-pointer 0)))
    (dotimes (i size)
      (vector-push (read-byte stream) bytes))
    (flexi-streams:octets-to-string bytes)))

(defmethod decode ((barray barray) stream)
  (let* ((size (read-bytes 32 stream))
         (elements (make-array size :fill-pointer 0))
         (element-type (element-type barray))
         (element (make-instance element-type)))
    (dotimes (i size)
      (vector-push (decode element stream) elements))
    (make-instance 'barray :element-type element-type :elements elements)))



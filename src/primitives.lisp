(in-package #:cl-kafka)

(defmacro define-type (name)
  `(progn
     (defclass ,name ()
       ((value :accessor value :initarg :value)))

     (defun ,name (&optional value)
       (make-instance ',name :value value))))

(define-type int16)
(define-type int32)


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

(defun encode-array (elements stream)
  (encode (int32 (length elements)) stream)
  (dolist (x elements)
    (encode x stream)))

(defmethod encode ((elements null) stream)
  (encode-array elements stream))

(defmethod encode ((elements cons) stream)
  (encode-array elements stream))

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

(defmethod decode ((elements cons) stream)
  (let* ((size (read-bytes 32 stream))
         (element (car elements))
         (result '()))
    (dotimes (i size)
      (setf result (cons (decode element stream) result)))
    result))

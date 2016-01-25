(in-package #:cl-kafka)

(defun write-bytes (value n stream)
  (loop for i from (/ n 8) downto 1
        do  (write-byte (ldb (byte 8 (* (1- i) 8)) value) stream)))

(defun read-bytes (n stream)
  (let ((value 0) (byte-size (/ n 8)))
    (dotimes (i byte-size)
      (setf value (+ (* value #x100) (read-byte stream))))
    value))

(defun encode-int16 (value stream)
  (write-bytes value 16 stream))

(defun encode-int32 (value stream)
  (write-bytes value 32 stream))

(defun encode-int64 (value stream)
  (write-bytes value 64 stream))

(defun encode-array (elements stream)
  (encode-int32 (length elements) stream)
  (dolist (x elements)
    (encode x stream)))

(defun encode-string (value stream)
  (encode-int16 (length value) stream)
  (write-sequence (flexi-streams:string-to-octets value) stream))

(defun decode-int16 (stream)
  (read-bytes 16 stream))

(defun decode-int32 (stream)
  (read-bytes 32 stream))

(defun decode-int64 (stream)
  (read-bytes 64 stream))

(defun decode-string (stream)
  (let* ((size (decode-int16 stream))
         (bytes (make-array size :fill-pointer 0)))
    (dotimes (i size)
      (vector-push (read-byte stream) bytes))
    (flexi-streams:octets-to-string bytes)))

(defun decode-array (element-type stream)
  (let* ((size (decode-int32 stream))
         (element (make-instance element-type))
         (result '()))
    (dotimes (i size)
      (setf result (cons (decode element stream) result)))
    result))

(defclass int16 ()
  ((value)))

(defclass int32 ()
  ((value)))

(defclass int64 ()
  ((value)))

(defmethod decode ((value int16) stream)
  (decode-int16 stream))

(defmethod decode ((value int32) stream)
  (decode-int32 stream))

(defmethod decode ((value int64) stream)
  (decode-int64 stream))

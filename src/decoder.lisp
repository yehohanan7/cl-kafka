(defpackage #:cl-kafka-decoder
  (:use #:cl)
  (:export :read-int16 :read-int32 :read-string :read-array))
(in-package #:cl-kafka-decoder)

(defun read-bytes (n stream)
  (let ((value 0) (byte-size (/ n 8)))
    (dotimes (i byte-size)
      (setf value (+ (* value #x100) (read-byte stream))))
    value))

(defun read-int16 (stream)
  (read-bytes 16 stream))

(defun read-int32 (stream)
  (read-bytes 32 stream))

(defun read-string (stream)
  (let* ((size (read-int16 stream))
         (bytes (make-array size :fill-pointer 0)))
    (dotimes (i size)
      (vector-push (read-byte stream) bytes))
    (flexi-streams:octets-to-string bytes)))

(defun read-array (stream parser)
  (let* ((size (read-int32 stream))
         (array (make-array size :fill-pointer 0)))
    (dotimes (i size)
      (vector-push (funcall parser stream) array))
    array))


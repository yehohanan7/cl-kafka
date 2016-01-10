(in-package #:cl-kafka)

(defun read-bytes (n stream)
  (let ((value 0) (byte-size (/ n 8)))
    (dotimes (i byte-size)
      (setf value (+ (* value #x100) (read-byte stream))))
    value))

(defgeneric decode (value _ &optional processor))

(defmethod decode (stream (_ (eql :int16)) &optional fn)
  (read-bytes 16 stream))

(defmethod decode (stream (_ (eql :int32)) &optional fn)
  (read-bytes 32 stream))

(defmethod decode (stream (_ (eql :string)) &optional fn)
  (let* ((size (decode stream :int16))
         (bytes (make-array size :fill-pointer 0)))
    (dotimes (i size)
      (vector-push (read-byte stream) bytes))
    (flexi-streams:octets-to-string bytes)))

(defmethod decode (stream (_ (eql :array)) &optional (processor #'identity))
  (let* ((size (decode stream :int32))
         (array (make-array size :fill-pointer 0)))
    (dotimes (i size)
      (vector-push (funcall processor stream) array))
    array))



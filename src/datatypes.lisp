(in-package #:cl-kafka)

(defclass int16 ()
  ((value :accessor value :initarg :value)))

(defclass int32 ()
  ((value :accessor value :initarg :value)))

(defclass bstring ()
  ((value :accessor value :initarg :value)))

(defclass barray ()
  ((value :accessor value :initarg :value)))

(defun write-bytes (value n stream)
  (loop for i from (/ n 8) downto 1
        do  (write-byte (ldb (byte 8 (* (1- i) 8)) value) stream)))

(defmethod encode ((element int16) stream)
  (write-bytes (value element) 16 stream))

(defmethod encode ((element int32) stream)
  (write-bytes (value element) 32 stream))

(defmethod encode ((element bstring) stream)
  (let ((value (value element)))
    (encode (int16 (length value)) stream)
    (write-sequence (flexi-streams:string-to-octets value) stream)))

(defmethod encode ((element barray) stream)
  (let ((size (length (value element))))
    (encode (int32 size) stream)
    (dolist (x (value element))
      (encode x stream))))

(defun int16 (value)
  (make-instance 'int16 :value value))

(defun int32 (value)
  (make-instance 'int32 :value value))

(defun bstring (value)
  (make-instance 'bstring :value value))

(defun barray (value)
  (make-instance 'barray :value value))

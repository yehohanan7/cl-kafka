(defpackage #:cl-kafka-encoder
  (:use #:cl #:cl-kafka-lambda)
  (:export :encode))
(in-package #:cl-kafka-encoder)

(defun write-bytes (value n stream)
  (loop for i from (/ n 8) downto 1
        do  (write-byte (ldb (byte 8 (* (1- i) 8)) value) stream)))

(defmacro/g! bytes (n value)
  `(let* ((g!ims (flexi-streams:make-in-memory-output-stream))
          (g!stream (flexi-streams:make-flexi-stream g!ims)))
     (write-bytes ,value ,n g!stream)
     (force-output g!stream)
     (flexi-streams:get-output-stream-sequence g!ims)))

(defgeneric encode (value _))

(defmethod encode (value (_ (eql :int16)))
  (bytes 16 value))

(defmethod encode (value (_ (eql :int32)))
  (bytes 32 value))

(defmethod encode (value (_ (eql :string)))
  (concatenate 'vector (encode (length value) :int16) (flexi-streams:string-to-octets value)))

(defmethod encode (value (_ (eql :array)))
  "fix me"
  (encode (length value) :int32))




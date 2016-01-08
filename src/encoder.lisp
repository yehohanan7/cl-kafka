(defpackage #:cl-kafka-encoder
  (:use #:cl #:cl-kafka-lambda)
  (:export :int16 :int32 :astring :anarray))
(in-package #:cl-kafka-encoder)

(defmacro/g! bytes (n value)
  `(let* ((g!ims (flexi-streams:make-in-memory-output-stream))
          (g!stream (flexi-streams:make-flexi-stream g!ims)))
     (write-bytes ,value ,n g!stream)
     (force-output g!stream)
     (flexi-streams:get-output-stream-sequence g!ims)))

(defun write-bytes (value n stream)
  (loop for i from (/ n 8) downto 1
        do  (write-byte (ldb (byte 8 (* (1- i) 8)) value) stream)))

(defun int16 (value)
  (bytes 16 value))

(defun int32 (value)
  (bytes 32 value))

(defun astring (value)
  (concatenate 'vector (int16 (length value)) (flexi-streams:string-to-octets value)))

(defun anarray (xs)
  ;;fix me
  (int32 (length xs)))

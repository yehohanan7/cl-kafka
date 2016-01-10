(in-package #:cl-kafka)

(defun write-bytes (value n stream)
  (loop for i from (/ n 8) downto 1
        do  (write-byte (ldb (byte 8 (* (1- i) 8)) value) stream)))

(defun encode-int16 (value stream)
  (write-bytes value 16 stream))

(defun encode-int32 (value stream)
  (write-bytes value 32 stream))

(defun encode-string (value stream)
  (encode-int16 (length value) stream)
  (write-sequence (flexi-streams:string-to-octets value) stream))

(defun encode-array (value stream)
  "fix me"
  (encode-int32 (length value) stream))




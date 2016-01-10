(in-package #:cl-kafka)

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




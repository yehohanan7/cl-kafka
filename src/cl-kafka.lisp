(in-package #:cl-kafka)

(defun write-bytes (value n stream)
  (loop for i from (/ n 8) downto 1
        do  (write-byte (ldb (byte 8 (* (1- i) 8)) value) stream)))

(defun read-bytes (n stream)
  (let ((value 0) (byte-size (/ n 8)))
    (dotimes (i byte-size)
      (setf value (+ (* value #x100) (read-byte stream))))
    value))

(defmacro/g! bytes (n value)
  `(let* ((g!ims (flexi-streams:make-in-memory-output-stream))
          (g!stream (flexi-streams:make-flexi-stream g!ims)))
     (write-bytes ,value ,n g!stream)
     (force-output g!stream)
     (flexi-streams:get-output-stream-sequence g!ims)))

(defun int16 (value)
  (bytes 16 value))

(defun int32 (value)
  (bytes 32 value))

(defun astring (value)
  (concatenate 'vector (int16 (length value)) (flexi-streams:string-to-octets value)))

(defun anarray (xs)
  (int32 (length xs)))

(defun read-int16 (stream)
  (read-bytes 16 stream))

(defun read-int32 (stream)
  (read-bytes 32 stream))

(defun meta-data (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket))
         (api-key (int16 3))
         (api-version (int16 0))
         (correlation-id (int32 121))
         (client-id (astring "cl-kafka"))
         (topics (anarray '()))
         (message (concatenate 'vector api-key api-version correlation-id client-id topics)))
    (format t "Fetching metadata..")
    (write-sequence (concatenate 'vector (int32 (length message)) message) socket-stream)
    (force-output socket-stream)
    (let ((size (read-int32 socket-stream))
          (correlation-id (read-int32 socket-stream))) 
      (format t "size: ~A" size)
      (format t "correlation-id : ~A" correlation-id))))

(meta-data "localhost" 9092)

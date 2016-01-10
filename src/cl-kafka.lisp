(in-package #:cl-kafka)

(defun get-meta-data (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket))
         (message (encode (make-instance 'meta-data-request :correlation-id 123))))
    (format t "Fetching metadata..")
    (write-sequence message socket-stream)
    (force-output socket-stream)
    (format t "length")
    (to-meta-data socket-stream)))

(get-meta-data "localhost" 9092)






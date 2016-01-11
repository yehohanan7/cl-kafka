(in-package #:cl-kafka)

(defun get-meta-data (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket)))
    (encode (make-instance 'meta-data-request :correlation-id (int32 123)) socket-stream)
    (decode (make-instance 'meta-data-response) socket-stream)))

(get-meta-data "localhost" 9092)






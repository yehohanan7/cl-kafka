(in-package #:cl-kafka)

(defun get-meta-data (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket)))
    (encode-request 'meta-data-request socket-stream :correlation-id 123)
    (decode-response 'meta-data-response socket-stream)))


(multiple-value-bind (correlation-id response) (get-meta-data "localhost" 9092)
  (mapcar #'(lambda (broker) (value (id broker))) (brokers response)))












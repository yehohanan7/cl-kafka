(in-package #:cl-kafka)

(defun connect (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket)))
    (make-instance 'connection :socket-stream socket-stream)))

(let ((connection (connect "localhost" 9092)))
  '(get-partitions connection "__consumer_offsets")
  '(get-topic-names connection)
  '(get-brokers connection))

(defvar *conn* (connect "localhost" 9092))

(get-topic-names *conn*)







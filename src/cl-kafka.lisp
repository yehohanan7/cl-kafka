(in-package #:cl-kafka)

(defun connect (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket)))
    (make-instance 'connection :socket-stream socket-stream)))





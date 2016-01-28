(in-package #:cl-kafka)

(defun connect (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket)))
    (make-instance 'connection :socket-stream socket-stream)))


(defvar *con* (connect "localhost" 9092))

(meta-data *con*)

(send-message *con* "hi" :topic "test" :correlation-id 12345)







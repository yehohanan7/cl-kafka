(in-package #:cl-kafka)

(defun connect (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket)))
    (make-instance 'connection :socket-stream socket-stream)))

(defvar *con* (connect "localhost" 9092))

(let* ((topic-response (car (topic-responses (send-message *con* "hi" :topic "test"))))
       (partition-response (car (partition-responses topic-response))))
  (error-code partition-response))





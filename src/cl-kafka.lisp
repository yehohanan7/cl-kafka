(defpackage #:cl-kafka
  (:use #:cl #:cl-kafka-encoder #:cl-kafka-decoder #:cl-kafka-meta-data)
  (:export :meta-data))
(in-package #:cl-kafka)


(defun get-meta-data (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket))
         (api-key (encode 3 :int16))
         (api-version (encode 0 :int16))
         (correlation-id (encode 121 :int32))
         (client-id (encode "cl-kafka" :string))
         (topics (encode '() :array))
         (message (concatenate 'vector api-key api-version correlation-id client-id topics)))
    (format t "Fetching metadata..")
    (write-sequence (concatenate 'vector (encode (length message) :int32) message) socket-stream)
    (force-output socket-stream)
    (format t "length")
    (to-meta-data socket-stream)))


(get-meta-data "localhost" 9092)

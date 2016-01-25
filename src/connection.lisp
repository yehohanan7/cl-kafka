(in-package #:cl-kafka)

(defclass connection ()
  ((socket-stream :accessor socket-stream :initarg :socket-stream)))

(defmethod meta-data ((connection connection))
  (with-slots (socket-stream) connection
    (encode-request 'meta-data-request socket-stream :correlation-id 123)
    (decode-response 'meta-data-response socket-stream)))

(defmethod brokers ((connection connection))
  (mapcar #'id (brokers (meta-data connection))))

(defmethod topics ((connection connection))
  (topics (meta-data connection)))

(defmethod topic-names ((connection connection))
  (mapcar #'name (topics connection)))

(defmethod topic ((connection connection) topic-name)
  (car (remove-if-not #'(lambda (topic) (string= (name topic) topic-name)) (topics connection))))

'(defmethod partitions ((connection connection) topic-name)
  (length (partitions (topic connection topic-name))))


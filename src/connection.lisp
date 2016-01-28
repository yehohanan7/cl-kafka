(in-package #:cl-kafka)

(defclass connection ()
  ((socket-stream :accessor socket-stream :initarg :socket-stream)))

(defmethod brokers ((connection connection))
  (mapcar #'id (brokers (meta-data connection))))

(defmethod topics ((connection connection))
  (topics (meta-data connection)))

(defmethod topic-names ((connection connection))
  (mapcar #'name (topics connection)))

(defmethod topic ((connection connection) topic-name)
  (car (remove-if-not #'(lambda (topic) (string= (name topic) topic-name)) (topics connection))))

(defmethod partition-count ((connection connection) topic-name)
  (length (partitions (topic connection topic-name))))

(defmethod meta-data ((connection connection) &key (correlation-id 123))
  (with-slots (socket-stream) connection
    (encode-request 'meta-data-request socket-stream :correlation-id correlation-id)
    (decode-response 'meta-data-response socket-stream)))

(defmethod send-message ((connection connection) content &key topic (partition 0) correlation-id)
  (with-slots (socket-stream) connection
    (let* ((message-set (make-instance 'message-set :message (make-instance 'message :value content)))
           (partition-payload (make-instance 'partition-payload :partition partition :message-set message-set))
           (topic-payload (make-instance 'topic-payload :topic-name topic :partition-payloads (list partition-payload)))
           (request (make-instance 'produce-request :topic-payloads (list topic-payload))))
      (encode-request 'produce-request socket-stream :correlation-id correlation-id))))


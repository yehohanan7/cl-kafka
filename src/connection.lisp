(in-package #:cl-kafka)

(defun send-request (request stream)
  (let ((ims (flexi-streams:make-in-memory-output-stream)))
    (encode request ims)
    (let ((ims-sequence (flexi-streams:get-output-stream-sequence ims)))
      (encode-int32 (length ims-sequence) stream)
      (write-sequence ims-sequence stream)
      (force-output stream))))

(defun receive-response (name stream)
  (let* ((size (decode-int32 stream)))
    (decode (make-instance name) stream)))

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

(defmethod meta-data ((connection connection))
  (with-slots (socket-stream) connection
    (send-request (make-instance 'meta-data-request) socket-stream)
    (receive-response 'meta-data-response socket-stream)))

(defmethod send-message ((connection connection) content &key topic (partition 0))
  (with-slots (socket-stream) connection
    (let* ((message (make-instance 'message :value content))
           (message-set (make-instance 'message-set :message message))
           (partition-payload (make-instance 'partition-payload :partition partition :message-set message-set))
           (topic-payload (make-instance 'topic-payload :topic-name topic :partition-payloads (list partition-payload))))
      (send-request (make-instance 'produce-request :topic-payloads (list topic-payload)) socket-stream))))

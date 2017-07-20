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


(defun create-produce-request (correlation-id topic-name partition key value)
  (let* ((message (make-instance 'message :value value :key key))
         (message-set (make-instance 'message-set :message message))
         (partition-group (make-instance 'partition-group :partition partition :message-set message-set))
         (topic-group (make-instance 'topic-group :topic-name topic :partition-groups (list partition-group))))
    (make-instance 'produce-request :correlation-id correlation-id :topic-groups (list topic-group))))

(defclass connection ()
  ((socket-stream :accessor socket-stream :initarg :socket-stream)))

(defmethod brokers ((connection connection))
  (mapcar #'id (brokers (meta-data connection))))

(defmethod topics ((connection connection))
  (topics (meta-data connection)))

(defmethod topic ((connection connection) topic-name)
  (car (remove-if-not #'(lambda (topic) (string= (name topic) topic-name)) (topics connection))))

(defmethod partition-count ((connection connection) topic-name)
  (length (partitions (topic connection topic-name))))

(defmethod meta-data ((connection connection))
  (with-slots (socket-stream) connection
    (send-request (make-instance 'meta-data-request) socket-stream)
    (receive-response 'meta-data-response socket-stream)))

(defmethod send-message ((connection connection) content &key topic (partition 0) (correlation-id 1))
  (with-slots (socket-stream) connection
    (send-request (create-produce-request correlation-id topic partition "key" connect) socket-stream)
    (let* ((topic-response (car (topic-responses (receive-response 'produce-response socket-stream))))
             (partition-response (car (partition-responses topic-response))))
        (if (= 0 (error-code partition-response)) "success" "error"))))

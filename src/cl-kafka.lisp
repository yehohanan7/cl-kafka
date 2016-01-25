(in-package #:cl-kafka)

(defclass connection ()
  ((socket-stream :accessor socket-stream :initarg :socket-stream)))

(defmethod get-meta-data ((connection connection))
  (with-slots (socket-stream) connection
    (encode-request 'meta-data-request socket-stream :correlation-id 123)
    (decode-response 'meta-data-response socket-stream)))

(defun connect (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (socket-stream (usocket:socket-stream socket)))
    (make-instance 'connection :socket-stream socket-stream)))

(defmethod get-brokers ((connection connection))
  (let ((meta-data (get-meta-data connection)))
    (mapcar #'id (brokers meta-data))))

(defmethod get-topics ((connection connection))
  (topics (get-meta-data connection)))

(defmethod get-topic-names ((connection connection))
  (mapcar #'name (get-topics connection)))

(defmethod get-topic ((connection connection) topic-name)
  (car (remove-if-not #'(lambda (topic) (string= (name topic) topic-name)) (get-topics connection))))

(defmethod get-partitions ((connection connection) topic-name)
  (let ((topic (get-topic connection topic-name)))
    (if topic (length (partitions topic)))))

(let ((connection (connect "localhost" 9092)))
  '(get-partitions connection "__consumer_offsets")
  '(get-topic-names connection)
  '(get-brokers connection))

(defvar *conn* (connect "localhost" 9092))

(mapcar #'id (brokers (get-meta-data *conn*)))



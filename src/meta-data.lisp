(in-package #:cl-kafka)

(defclass broker ()
  ((id :accessor id :initarg :id)
   (host :accessor host :initarg :host)
   (port :accessor port :initarg :port)))

(defmethod print-object ((obj broker) out)
  (format out "id: ~s, host: ~s, port: ~s" (id obj) (host obj) (port obj)))

(defclass topic ()
  ((err :accessor err :initarg :err)
   (name :accessor name :initarg :name)
   (partitions :accessor partitions :initarg :partitions)))

(defmethod print-object ((obj topic) out)
  (format out "err: ~s, name: ~s, partitions: ~A" (err obj) (name obj) (partitions obj)))

(defclass partition ()
  ((err :accessor err :initarg :err)
   (id :accessor id :initarg :id)
   (leader :accessor leader :initarg :leader)
   (replicas :accessor replicas :initarg :replicas)
   (isr :accessor isr :initarg :isr)))

(defmethod print-object ((obj partition) out)
  (format out "err: ~s, id: ~s, leader: ~A" (err obj) (id obj) (leader obj)))

(defclass meta-data ()
  ((brokers :accessor brokers :initarg :brokers)
   (topics :accessor topics :initarg :topics)))

(defmethod print-object ((obj meta-data) out)
  (format out "brokers: ~A, topics: ~A" (brokers obj) (topics obj)))

(defun to-replica (stream)
  (decode stream :int32))

(defun to-isr (stream)
  (decode stream :int32))

(defun to-partition (stream)
  (let* ((err (decode stream :int16))
         (id (decode stream :int32))
         (leader (decode stream :int32))
         (replicas (decode stream :array #'to-replica))
         (isr (decode stream :array #'to-isr)))
    (make-instance 'partition :err err :id id :leader leader :replicas replicas :isr isr)))

(defun to-broker (stream)
  (let* ((id (decode stream :int32))
         (host (decode stream :string))
         (port (decode stream :int32)))
    (make-instance 'broker :id id :host host :port port)))

(defun to-topic (stream)
  (let* ((err (decode stream :int16))
         (name (decode stream :string))
         (partitions (decode stream :array #'to-partition)))
    (make-instance 'topic :err err :name name :partitions partitions)))

(defun to-meta-data (stream)
  (let* ((size (decode stream :int32))
         (correlation-id (decode stream :int32))
         (brokers (decode stream :array #'to-broker))
         (topics (decode stream :array #'to-topic)))
    (make-instance 'meta-data :brokers brokers :topics topics)))

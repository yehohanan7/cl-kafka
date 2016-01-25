(in-package #:cl-kafka)

(defclass meta-data-request ()
  ((api-key :accessor api-key :initarg :api-key :initform 3)
   (api-version :accessor api-version :initarg :api-version :initform 0)
   (correlation-id :accessor correlation-id :initarg :correlation-id)
   (client-id :accessor client-id :initarg :client-id :initform "cl-kafka")
   (topics :accessor topics :initarg :topics :initform '())))

(defclass meta-data-response ()
  ((correlation-id :accessor correlation-id :initarg :correlation-id)
   (brokers :accessor brokers :initarg :brokers)
   (topics :accessor topics :initarg :topics)))

(defclass broker ()
  ((id :accessor id :initarg :id)
   (host :accessor host :initarg :host)
   (port :accessor port :initarg port)))

(defclass topic ()
  ((error-code :accessor error-code :initarg :error-code)
   (name :accessor name :initarg :name)
   (partitions :accessor partitions :initarg :partitions :initform '())))

(defclass partition ()
  ((error-code :accessor error-code :initarg :error-code)
   (id :accessor id :initarg :id)
   (leader :accessor leader :initarg :leader)
   (replicas :accessor replicas :initarg :replicas :initform '())
   (isr :accessor isr :initarg :isr :initform '())))


'(define-message message-content ()
  ((message-crc (int32))
   (message-magic-byte (int8))
   (message-attributes (int8 0))
   (message-key "")
   (message-value "")))

'(define-message messageset-content ()
  ((messageset-offset (int64))
   (messageset-content-size (int32))
   (messageset-content (message-content))))

'(define-message messageset ()
  ((message-set-content (vector (messageset-content)))))

'(define-message partition-payload ()
  ((partition-id (int32))
   (partition-message-set-size (int32))
   (partition-message-set (messageset))))

'(define-message topic-payload ()
  ((topic-name "")
   (partition-payloads (list (partition-payload)))))

'(define-message produce-request ()
  ((required-aks (int16 1))
   (request-timeout (int32))
   (topic-payloads (list (topic-payload)))))


(in-package #:cl-kafka)


(defclass meta-data-request ()
  ((api-key :accessor api-key :initarg :api-key :initform 3)
   (api-version :accessor api-version :initarg :api-version :initform 0)
   (correlation-id :accessor correlation-id :initarg :correlation-id :initform 3)
   (client-id :accessor client-id :initarg :client-id :initform "cl-kafka")
   (topics :accessor topics :initarg :topics :initform '())))

(defclass meta-data-response ()
  ((correlation-id :accessor correlation-id :initarg :correlation-id)
   (brokers :accessor brokers :initarg :brokers)
   (topics :accessor topics :initarg :topics)))

(defclass broker ()
  ((id :accessor id :initarg :id)
   (host :accessor host :initarg :host)
   (port :accessor port :initarg :port)))

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

(defclass message ()
  ((magic-byte :accessor magic-byte :initarg :magic-byte :initform 0)
   (attributes :accessor attributes :initarg :attributes :initform 0)
   (key :accessor key :initarg :key :initform "")
   (value :accessor value :initarg :value)))

(defclass message-set ()
  ((offset :accessor offset :initarg :offset :initform 0)
   (message :accessor message :initarg :message)))

(defclass partition-payload ()
  ((partition :accessor partition :initarg :partition)
  (message-set :accessor message-set :initarg :message-set)))

(defclass topic-payload ()
  ((topic-name :accessor topic-name :initarg :topic-name)
   (partition-payloads :accessor partition-payloads :initarg :partition-payloads)))

(defclass produce-request ()
  ((api-key :accessor api-key :initarg :api-key :initform 0)
   (api-version :accessor api-version :initarg :api-version :initform 0)
   (correlation-id :accessor correlation-id :initarg :correlation-id :initform 0)
   (client-id :accessor client-id :initarg :client-id :initform "cl-kafka")
   (required-acks :accessor required-acks :initform 1)
   (timeout :accessor timeout :initarg :timeout :initform 5000)
   (topic-payloads :accessor topic-payloads :initarg :topic-payloads :initform '())))

(defclass partition-response ()
  ((partition :accessor partition :initarg :partition)
   (error-code :accessor error-code :initarg :error-code)
   (offset :accessor offset :initarg :offset)))

(defclass topic-response ()
  ((topic-name :accessor topic-name :initarg :topic-name)
   (partition-responses :accessor partition-responses :initarg :partition-responses)))

(defclass produce-response ()
  ((correlation-id :accessor correlation-id :initarg :correlation-id)
   (topics-responses :accessor topic-responses :initarg :topic-responses)))

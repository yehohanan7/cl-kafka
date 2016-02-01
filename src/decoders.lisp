(in-package #:cl-kafka)

(defmethod decode ((message meta-data-response) stream)
  (make-instance 'meta-data-response
                 :correlation-id (decode-int32 stream)
                 :brokers (decode-array 'broker stream)
                 :topics (decode-array 'topic stream)))

(defmethod decode ((message broker) stream)
  (make-instance 'broker
                 :id (decode-int32 stream)
                 :host (decode-string stream)
                 :port (decode-int32 stream)))

(defmethod decode ((message topic) stream)
  (make-instance 'topic
                 :error-code (decode-int16 stream)
                 :name (decode-string stream)
                 :partitions (decode-array 'partition stream)))

(defmethod decode ((message partition) stream)
  (make-instance 'partition
                 :error-code (decode-int16 stream)
                 :id (decode-int32 stream)
                 :leader (decode-int32 stream)
                 :replicas (decode-array 'int32 stream)
                 :isr (decode-array 'int32 stream)))

(defmethod decode ((message partition-response) stream)
  (make-instance 'partition-response
                 :partition (decode-int32 stream)
                 :error-code (decode-int16 stream)
                 :offset (decode-int64 stream)))

(defmethod decode ((message topic-response) stream)
  (make-instance 'topic-response
                 :topic-name (decode-string stream)
                 :partition-responses (decode-array 'partition-response stream)))

(defmethod decode ((message produce-response) stream)
  (make-instance 'produce-response
                 :correlation-id (decode-int32 stream)
                 :topic-responses (decode-array 'topic-response stream)))

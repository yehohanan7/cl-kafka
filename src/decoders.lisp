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


(defun decode-response (name stream)
  (let* ((size (decode-int32 stream)))
    (decode (make-instance name) stream)))


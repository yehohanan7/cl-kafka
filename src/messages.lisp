(in-package #:cl-kafka)

(define-message meta-data-request ()
  ((api-key (int16 3))
   (api-version (int16 0))
   (correlation-id (int32))
   (client-id "cl-kafka")
   (topics '())))

(define-message partition ()
  ((error-code (int16))
   (id (int32))
   (leader (int32))
   (replicas (list (int32)))
   (isr (list (int32)))))

(define-message topic ()
  ((error-code (int16))
   (name "")
   (partitions (list (partition)))))

(define-message broker ()
  ((id (int32))
   (host "")
   (port (int32))))

(define-message meta-data-response ()
  ((brokers (list (broker)))
   (topics (list (topic)))))


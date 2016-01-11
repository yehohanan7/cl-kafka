(in-package #:cl-kafka)

(define-message meta-data-request ()
  ((api-key (int16 3))
   (api-version (int16 0))
   (correlation-id (int32))
   (client-id (bstring "cl-kafka"))
   (topics (barray 'string nil))))

(define-message partition ()
  ((error-code (int16))
   (id (int32))
   (leader (int32))
   (replicas (barray 'int32))
   (isr (barray 'int32))))

(define-message topic ()
  ((error-code (int16))
   (name (bstring))
   (partitions (barray 'partition))))

(define-message broker ()
  ((id (int32))
   (host (bstring))
   (port (int32))))

(define-message meta-data-response ()
  ((brokers (barray 'broker nil))
   (topics (barray 'topic nil))))




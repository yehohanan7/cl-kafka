(in-package #:cl-kafka)

(define-message meta-data-request ()
  ((api-key (int16 3))
   (api-version (int16 0))
   (correlation-id (int32))
   (client-id (bstring "cl-kafka"))
   (topics (barray '()))))




(in-package #:cl-kafka)

(define-message meta-data-request ()
  ((api-key :int16 3)
   (api-version :int16 0)
   (correlation-id :int32)
   (client-id :string "cl-kafka")
   (topics :array '())))

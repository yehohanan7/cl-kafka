(in-package #:cl-kafka-test)

(define-message sample-request ()
  ((correlation-id (int32 123))
   (name "sample-request")
   (xs (list (int32 1) (int32 2)))))

(define-message sample-response ()
  ((correlation-id (int32))
   (name "")
   (xs (list (int32)))))

(let ((stream (flexi-streams:make-in-memory-output-stream)))
  (encode-request 'sample-request stream :correlation-id 123)
  (let* ((binary-array (flexi-streams:get-output-stream-sequence stream)))
    (let ((response (decode-response 'sample-response (flexi-streams:make-in-memory-input-stream binary-array))))
      (is (name response) "sample-request")
      (is (length (xs response)) 2))))




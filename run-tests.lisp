(in-package #:cl-user)
(ql:quickload :prove)
(ql:quickload :cl-kafka)
(setf prove:*enable-colors* t)
(prove:run :cl-kafka-test)
(quit)

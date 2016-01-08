(in-package #:cl-user)

(require :sb-cover)
(declaim (optimize sb-cover:store-coverage-data))

(asdf:test-system :cl-kafka)

(progn
  (sb-cover:report "./coverage/")
  (declaim (optimize (sb-cover:store-coverage-data 0))))

(defpackage #:cl-kafka
  (:use #:cl #:cl-json)
  (:export :connect
           :meta-data
           :brokers
           :topic
           :topics
           :partitions
           :partition-count
           :send-message))


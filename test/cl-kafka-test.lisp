(in-package #:cl-kafka-test)

(let ((connection (connect "localhost" 9092)))
  (is (length (topics connection)) 4)
  (is (length (partitions (topic connection "test"))) 2))





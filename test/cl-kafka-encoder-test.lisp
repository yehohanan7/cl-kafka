(in-package #:cl-kafka-test)

(is (int32 1) #(0 0 0 1) :test #'equalp)

(is (int16 1) #(0 1) :test #'equalp)

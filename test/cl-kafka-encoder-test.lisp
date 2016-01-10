(in-package #:cl-kafka-test)

(is (encode-int32 1) #(0 0 0 1) :test #'equalp)

(is (encode-int16 1) #(0 1) :test #'equalp)

(is (encode-string "foobar") #(0 6 102 111 111 98 97 114) :test #'equalp)

(is (encode-array #(1 2)) #(0 0 0 2) :test #'equalp)

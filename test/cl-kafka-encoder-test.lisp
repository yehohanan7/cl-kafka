(in-package #:cl-kafka-test)

(is (encode 1 :int32) #(0 0 0 1) :test #'equalp)

(is (encode 1 :int16) #(0 1) :test #'equalp)

(is (encode "foobar" :string) #(0 6 102 111 111 98 97 114) :test #'equalp)

(is (encode #(1 2) :array) #(0 0 0 2) :test #'equalp)

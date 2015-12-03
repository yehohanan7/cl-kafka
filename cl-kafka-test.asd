(asdf:defsystem #:cl-kafka-test
  :description "Tests"
  :author "yehohanan7@gmail.com"
  :serial t
  :depends-on (#:prove #:cl-kafka)
  :components ((:file "cl-kafka-test")))

(prove:run #P"cl-kafka-test.lisp" :reporter :list)

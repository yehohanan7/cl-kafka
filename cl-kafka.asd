(asdf:defsystem #:cl-kafka
  :description "Describe cl-kafka here"
  :author "yehohanan7@gmail.com"
  :serial t
  :depends-on (#:dexador)
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "cl-kafka")))))

(asdf:defsystem #:cl-kafka-test
  :description "Tests"
  :author "yehohanan7@gmail.com"
  :serial t
  :depends-on (#:prove #:cl-kafka)
  :components ((:module "test"
                :components
                ((:file "package")
                 (:file "cl-kafka-test")
                 (:file "run-tests")))))


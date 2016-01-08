(asdf:defsystem #:cl-kafka
  :description "Describe cl-kafka here"
  :author "yehohanan7@gmail.com"
  :serial t
  :depends-on (#:dexador
               #:uuid
               #:usocket
               #:bordeaux-threads)
  :components ((:module "src"
                :components
                ((:file "lambda")
                 (:file "encoder")
                 (:file "decoder")
                 (:file "cl-kafka")))))

(asdf:defsystem #:cl-kafka-test
  :description "Tests"
  :author "yehohanan7@gmail.com"
  :serial t
  :depends-on (#:prove #:cl-kafka)
  :components ((:module "test"
                :components
                ((:file "package")
                 (:file "cl-kafka-encoder-test")
                 (:file "cl-kafka-test")
                 (:file "run-tests")))))


;;;; cl-kafka.asd

(asdf:defsystem #:cl-kafka
  :description "Describe cl-kafka here"
  :author "yehohanan7@gmail.com"
  :license "Specify license here"
  :serial t
  :depends-on (#:prove)
  :components ((:file "package")
               (:file "cl-kafka")))


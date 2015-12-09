;;;; cl-echo-client-server.asd

(asdf:defsystem #:cl-echo-client-server
  :description "Describe cl-echo-client-server here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:usocket
               #:bordeaux-threads)
  :serial t
  :components ((:file "package")
               (:file "cl-echo-client-server")
               (:file "cl-echo-server")))


;;;; cl-echo-client-server.lisp

(in-package #:cl-echo-client-server)

;;; "cl-echo-client-server" goes here. Hacks and glory await!

;; starts the echo server
(defparameter *stop-echo-server* (echo-server 8080)
  "A lexical closure/function that can be used (via funcall) to cleanly shutdown the echo server.")

;; starts the echo client
(echo-client 8080)

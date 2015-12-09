;;;; cl-echo-client.lisp

(in-package #:cl-echo-client-server)

(defun echo-client (port &key (hostname "127.0.0.1"))
  "A simple echo client. Can be shutdown by typing 'exit'."
  (with-client-socket (active-socket stream hostname port)
    (do ((input-text (read-line) (read-line)))
        ((string= input-text "exit"))
      (format stream "~A~%" input-text)
      (force-output stream)
      (format t "~A~%" (read-line stream)))))

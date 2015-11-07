;;;; cl-echo-client-server.lisp

(in-package #:cl-echo-client-server)

;;; "cl-echo-client-server" goes here. Hacks and glory await!

(defun echo-server (port &key (hostname "127.0.0.1"))
  "A simple echo server."
  (with-socket-listener (listener hostname port :reuse-address t)
    (loop ; loops forever
       (with-connected-socket (socket (socket-accept listener)) ; this part blocks
         (let ((stream (socket-stream socket)))
           (do ((echo-text (read-line stream nil) (read-line stream nil)))
               ((or (equal echo-text (concatenate 'string "exit" (string #\Return)))
                    (equal echo-text "exit")
                    (equal echo-text nil)))
             (format stream "echo: ~A~%" echo-text)
             (force-output stream)))))))

(defun start-echo-server (port &key (hostname "127.0.0.1"))
  "Starts an echo server on a new thread, returns a closure 
that can be used to shutdown the server."
  (let ((echo-server-thread (make-thread #'(lambda ()
                                             (echo-server port :hostname hostname))
                                         :name "echo-server")))
    (lambda ()
      (destroy-thread echo-server-thread))))

(defun echo-client (port &key (hostname "127.0.0.1"))
  "A simple echo client."
  (with-client-socket (socket stream hostname port)
    (let ((echo-text (read-line)))
      (format stream "~A~%" echo-text)
      (force-output stream)
      (read-line stream))))

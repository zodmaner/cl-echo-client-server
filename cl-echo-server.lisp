;;;; cl-echo-server.lisp

(in-package #:cl-echo-client-server)

(defun echo-server (port &key (hostname "127.0.0.1"))
  "A simple echo server."
  (let* ((passive-socket (socket-listen hostname port :reuse-address t))
         (server-thread (make-thread
                         #'(lambda ()
                             (loop
                                (accept-and-handle passive-socket)))
                         :name "server-thread")))
    #'(lambda ()
        (socket-close passive-socket)
        (destroy-thread server-thread))))

(defun accept-and-handle (passive-socket)
  "Accepts and handles a connection."
  (let* ((active-socket (socket-accept passive-socket))
         (stream (socket-stream active-socket)))
    (make-thread
     #'(lambda ()
         (handle stream)
         (close stream)
         (socket-close active-socket)))))

(defun handle (stream)
  "Reads, processes, and writes data back to the client."
  (do ((echo-text (read-line stream nil) (read-line stream nil)))
      ((null echo-text))
    (format stream "echo: ~A~%" echo-text)
    (force-output stream)))

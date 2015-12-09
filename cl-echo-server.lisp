;;;; cl-echo-server.lisp

(in-package #:cl-echo-client-server)

(defun echo-server (port &key (hostname "127.0.0.1"))
  "A simple multi-threaded echo server."
  (let* ((passive-socket (socket-listen hostname port :reuse-address t))
         (server-thread (make-thread
                         #'(lambda ()
                             (loop
                                (accept-and-handle passive-socket)))
                         :name "echo-server-thread")))
    #'(lambda ()
        (socket-close passive-socket)
        (destroy-thread server-thread))))

(defun accept-and-handle (passive-socket)
  "Accepts and creates a new thread to handle a connection."
  (let ((active-socket (socket-accept passive-socket)))
    (make-thread
     #'(lambda ()
         (with-open-stream (stream (socket-stream active-socket))
           (handle stream))
         (socket-close active-socket))
     :name "handler-thread")))

(defun handle (stream)
  "Reads, processes, and writes data back to the client.
This function will run until a client disconnects."
  (do ((echo-text (read-line stream nil) (read-line stream nil)))
      ((null echo-text)) ; loops until the client disconnects
    (format stream "echo: ~A~%" echo-text)
    (force-output stream)))

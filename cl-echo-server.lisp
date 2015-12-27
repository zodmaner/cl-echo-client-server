;;;; cl-echo-server.lisp

(in-package #:cl-echo-client-server)

(defvar *echo-server-running* nil
  "Represents a running state of the echo server thread and is used to
control the thread itself.")

(defun echo-server (port &key (hostname "127.0.0.1"))
  "Starts a simple multi-threaded echo server and returns a lexical
closure/function that can be used to cleanly shutdown the server."
  (setf *echo-server-running* t)
  (let* ((passive-socket (socket-listen hostname port :reuse-address t))
         (echo-server-thread (start-echo-server-thread passive-socket)))
    #'(lambda ()
        (socket-close passive-socket)
        (setf *echo-server-running* nil)
        (join-thread echo-server-thread))))

(defun start-echo-server-thread (passive-socket)
  "Starts and returns the main echo server thread.

The thread checks the *echo-server-running* special variable every
5 seconds and terminates if the variable's value is NIL."
  (make-thread
   #'(lambda ()
       (loop :while *echo-server-running* :do
          (when (not (null (wait-for-input passive-socket
                                           :timeout 5
                                           :ready-only t)))
            (accept-and-handle passive-socket))))
   :name "echo-server-thread"))

(defun accept-and-handle (passive-socket)
  "Accepts and creates a new thread to handle each incoming connection.

This enables our echo server to handle many connections at once."
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

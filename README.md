# cl-echo-client-server
A simple echo client and server in Common Lisp.

I implements this in order to learn socket programming using Common Lisp.

#### Usage
###### Server
Call the `echo-server` function from the REPL.

An example, which also shows how to define a lexical closure:
```lisp
(defparameter *stop-echo-server* (echo-server 8080))
```

The closure can be used to cleanly shutdown the server:
```lisp
(funcall *stop-echo-server*)
```

###### Client
The client can be started by calling the function `echo-client`:
```lisp
(echo-client 8080)
```

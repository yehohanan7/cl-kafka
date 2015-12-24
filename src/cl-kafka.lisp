(in-package #:cl-kafka)

(defun write-bytes (value n stream)
  (let ((value (ldb (byte n 0) value)))
    (loop for i from (/ n 8) downto 1
          do
             (write-byte (ldb (byte 8 (* (1- i) 8)) value) stream))))

(defun zk-connect (host port)
  (let* ((socket (usocket:socket-connect host port :element-type '(unsigned-byte 8)))
         (stream (usocket:socket-stream socket))
         (protocol-version 0)
         (last-zxid 0)
         (timeout 10000)
         (session-id 0)
         (password (flexi-streams:string-to-octets (make-string 16 :initial-element (code-char 0)))))
    (write-bytes protocol-version 32 stream)
    (write-bytes last-zxid 64 stream)
    (write-bytes timeout 32 stream)
    (write-bytes session-id 64 stream)
    (write-sequence password stream)
    (force-output stream)
    (read-byte stream)))

(zk-connect "localhost" 2181)


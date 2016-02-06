A kafka client in common lisp.

it has the functions to query metadata and send messages, will be extended to consume messages.

```common-lisp
(let ((connection (connect "localhost" 9092)))
  (topic-names connection)
  (partition-count connection "partition-name")
  
  (send-message *con* "message-content" :topic "topic-name"))

```


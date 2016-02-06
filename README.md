A kafka client in common lisp.

it has the functions to query metadata and send messages, will be extended to consume messages.

```common-lisp
(let ((connection (connect "localhost" 9092)))
  ;; Get all topic names
  (topic-names connection)
  
  ;; get number of partitions of a topic
  (partition-count connection "topic-name")
  
  ;; send message to a topic
  (send-message *con* "message-content" :topic "topic-name"))

```


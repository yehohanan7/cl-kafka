#Start swank repl
docker run -i -t -v $(pwd):/root/quicklisp/local-projects/cl-kafka -p 4005:4005 clisp swank


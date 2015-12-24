for x in kafka clisp
do
    docker stop $x && docker rm $x
done
docker run -d -p 2181:2181 -p 9092:9092 --name kafka -h kafka hub.int.klarna.net/kafka:0.9.0.0
docker run -i -t --name clisp --link kafka:kafka -v $(pwd):/root/quicklisp/local-projects/cl-kafka -p 4005:4005 clisp swank

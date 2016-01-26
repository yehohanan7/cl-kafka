#!/bin/bash

case "$1" in
    run)
        sbcl --load run-tests.lisp
        ;;
    *)
        docker stop kafka && docker rm kafka
        docker run -d -p 2181:2181 -p 9092:9092 --name kafka kafka9
        sleep 10
        sbcl --load run-tests.lisp
esac


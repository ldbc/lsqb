#!/bin/bash

if [[ ! -f woj/fuseki-leapfrog.jar  ]]; then
    wget https://github.com/GQgH5wFgzT/benchmark-leapfrog/blob/gh-pages/benchmark/jena/jars/fuseki-leapfrog.jar?raw=true -O ./woj/fuseki-leapfrog.jar
fi

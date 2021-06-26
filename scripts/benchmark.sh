#!/bin/bash

# script to run benchmarks on the systems passed as its argument

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

#SFS="0.1 0.3 1 3 10"
SFS="example"
# SYSTEMS="ddb umb pos neo red"
SYSTEMS="ddb red"

export SF
for SF in ${SFS}; do
    echo Running benchmark on scale factor ${SF}
    for SYSTEM in ${SYSTEMS}; do
        echo Benchmarking system ${SYSTEM}
        cd ${SYSTEM}
        ./init-and-load.sh && ./run.sh && ./stop.sh
        cd ..
    done
done

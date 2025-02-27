#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ../.venv/bin/activate

SFS="1 3 10"
RUNS=1
NUM_THREADS=${1:-`nproc`}

export SF
for SF in ${SFS}; do
    echo Running benchmark on scale factor ${SF}
    for RUN in $(seq 1 ${RUNS}); do
      echo "Run ${RUN} of ${RUNS}"
      python load.py ${SF} ${THREADS}
      python client.py ${SF} ${THREADS}
    done
done
deactivate

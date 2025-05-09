#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh

NUM_THREADS=${1:-`nproc`}

cd duckpgq
python client.py ${SF} ${NUM_THREADS}

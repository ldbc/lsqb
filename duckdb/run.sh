#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. duckdb/vars.sh
. scripts/import-vars.sh

NUM_THREADS=${1:-`nproc`}

python3 duckdb/client.py ${SF} ${NUM_THREADS}

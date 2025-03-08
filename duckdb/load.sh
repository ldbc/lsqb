#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. duckdb/vars.sh
. scripts/import-vars.sh

rm -rf ${DUCKDB_DIR}/ldbc.duckdb*

python3 duckdb/load.py

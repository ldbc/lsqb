#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/ddb-vars.sh

pip3 install --user duckdb==${DUCKDB_VERSION}
pip3 install --user neo4j
pip3 install --user redisgraph redisgraph-bulk-loader

scripts/download-ddb.sh

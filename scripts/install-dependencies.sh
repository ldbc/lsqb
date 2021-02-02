#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/ddb-vars.sh

pip3 install -U duckdb==${DUCKDB_VERSION}
pip3 install -U neo4j
pip3 install -U redisgraph redisgraph-bulk-loader

scripts/download-ddb.sh

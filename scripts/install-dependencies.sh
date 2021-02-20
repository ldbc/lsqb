#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. ddb/vars.sh

# clients
pip3 install --user duckdb==${DUCKDB_VERSION}
pip3 install --user neo4j
pip3 install --user redisgraph redisgraph-bulk-loader
pip3 install --user psycopg2-binary

# DuckDB binary
ddb/get.sh

# misc
pip3 install --user matplotlib pandas seaborn

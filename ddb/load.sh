#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. ddb/vars.sh
. scripts/import-vars.sh

rm -rf ${DUCKDB_DIR}/ldbc.duckdb*

echo -n "Loading data to DuckDB... "
cat sql/schema.sql | ${DUCKDB_BINARY} ${DUCKDB_DIR}/ldbc.duckdb
sed "s|PATHVAR|${IMPORT_DATA_DIR_MERGED_FK}|" sql/snb-load.sql
echo Done

echo -n "Initializing views and indexes... "
cat sql/views.sql | ${DUCKDB_BINARY} ${DUCKDB_DIR}/ldbc.duckdb
echo Done

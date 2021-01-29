#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

set -e

IMPORT_DATA_DIR=`pwd`/data/social_network_preprocessed
DUCKDB_DIR=`pwd`/ddb-scratch
DUCKDB_BINARY=`pwd`/ddb-scratch/duckdb

rm ${DUCKDB_DIR}/ldbc.duckdb*
cat ddb/schema.sql | ${DUCKDB_BINARY} ${DUCKDB_DIR}/ldbc.duckdb
sed "s|PATHVAR|${IMPORT_DATA_DIR}|" ddb/snb-load.sql | ${DUCKDB_BINARY} ${DUCKDB_DIR}/ldbc.duckdb

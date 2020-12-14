#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

IMPORT_DATA_DIR=`pwd`/data/social_network_preprocessed
DUCKDB_DIR=`pwd`/duc-scratch
DUCKDB_BINARY=`pwd`/duc-scratch/duckdb

rm ${DUCKDB_DIR}/ldbc.duckdb*
cat duc/schema.sql | ${DUCKDB_BINARY} ${DUCKDB_DIR}/ldbc.duckdb
sed "s|PATHVAR|${IMPORT_DATA_DIR}|" duc/snb-load.sql | ${DUCKDB_BINARY} ${DUCKDB_DIR}/ldbc.duckdb

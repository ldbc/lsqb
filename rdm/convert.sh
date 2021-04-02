#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

ddb/load.sh
echo Converting the graph to '.graph' format...
cat rdm/conv.sql | sed "s/SCALE_FACTOR/${SF}/g" | ddb/scratch/duckdb ddb/scratch/ldbc.duckdb
echo Done

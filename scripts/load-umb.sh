#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

IMPORT_DATA_DIR=`pwd`/data/social-network-preprocessed

. scripts/umb-vars.sh

cp ddb/schema.sql umb-scratch/schema.sql
sed "s|PATHVAR|${IMPORT_DATA_DIR}|" ddb/snb-load.sql > umb-scratch/snb-load.sql

cd umb-scratch
./bin/sql --createdb ldbc.db schema.sql snb-load.sql

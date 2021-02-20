#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. umb/vars.sh
. scripts/import-vars.sh

sed "s|PATHVAR|${IMPORT_DATA_DIR}|" sql/snb-load.sql > umb/scratch/snb-load.sql

cd umb/scratch
rm -rf ldbc.db*
LD_LIBRARY_PATH=./lib \
    ./bin/sql \
    --createdb ldbc.db \
    ../create-role.sql \
    ../../sql/schema.sql \
    ../../sql/schema-constraints.sql \
    snb-load.sql

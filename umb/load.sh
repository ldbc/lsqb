#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

IMPORT_DATA_DIR=`pwd`/data/social-network-preprocessed

. umb/vars.sh

cp sql/schema.sql umb-scratch/schema.sql
sed "s|PATHVAR|${IMPORT_DATA_DIR}|" sql/snb-load.sql > umb-scratch/snb-load.sql

cd umb-scratch
rm ldbc.db*
./bin/sql --createdb ldbc.db schema.sql snb-load.sql

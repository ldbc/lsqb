#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. vars.sh

cp create-role.sql scratch/
cp ../sql/schema.sql scratch/
cp ../sql/views.sql scratch/
sed "s|PATHVAR|/data|" ../sql/snb-load.sql > scratch/snb-load.sql

docker exec \
    --interactive \
    ${UMBRA_CONTAINER_NAME} \
    /umbra/bin/sql \
    --createdb /scratch/ldbc.db \
    /scratch/create-role.sql \
    /scratch/schema.sql \
    /scratch/views.sql \
    /scratch/snb-load.sql

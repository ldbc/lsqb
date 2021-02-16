#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. docker-vars.sh

sed "s|PATHVAR|/data|" ../sql/snb-load.sql > scratch/snb-load.sql
cp ../sql/schema.sql scratch/
cp ../sql/schema-constraints.sql scratch/

docker exec -i ${UMBRA_CONTAINER_NAME} /umbra/bin/sql --createdb ldbc.db /scratch/schema.sql /scratch/schema-constraints.sql /scratch/snb-load.sql

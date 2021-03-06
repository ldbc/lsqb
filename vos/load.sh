#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh

# TODO

cat sql/drop.sql | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U vostgres

echo Loading data to Virtuoso...
cat sql/schema.sql | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U vostgres
sed "s|PATHVAR|/data|" sql/snb-load.sql | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U vostgres
echo Done

echo Initializing views and indexes...
cat sql/schema-constraints.sql | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U vostgres
echo Done

# Refer to the script at https://github.com/ldbc/ldbc_snb_implementations/blob/fe82499dcc86f7e016475de17c55bd4776f8c2af/interactive/virtuoso/scripts/ld.sql

#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. postgres/vars.sh

cat "${POSTGRES_SCHEMA_DIR}/drop.sql" | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U postgres

echo Loading data to Postgres...
cat "${POSTGRES_SCHEMA_DIR}/schema.sql" | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U postgres
sed "s|PATHVAR|/data|" "${POSTGRES_SCHEMA_DIR}/snb-load.sql" | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U postgres
echo Done

echo Initializing views and indexes...
cat "${POSTGRES_SCHEMA_DIR}/views.sql" | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U postgres
echo Done

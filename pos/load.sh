#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. pos/vars.sh

cat sql/drop.sql | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U postgres
cat sql/schema.sql | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U postgres
sed "s|PATHVAR|/data|" sql/snb-load.sql | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U postgres

#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. hyp/vars.sh

cat sql/drop.sql | docker exec -i ${HYPER_CONTAINER_NAME} psql -U lsqbuser -p 7484 -h localhost ${HYPER_DATABASE_NAME}

echo Loading data to HyPer...
cat sql/schema.sql | docker exec -i ${HYPER_CONTAINER_NAME} psql -U lsqbuser -p 7484 -h localhost ${HYPER_DATABASE_NAME}
sed "s|PATHVAR|/data|" sql/snb-load.sql | docker exec -i ${HYPER_CONTAINER_NAME} psql -U lsqbuser -p 7484 -h localhost ${HYPER_DATABASE_NAME}
echo Done

echo Initializing views and indexes...
cat sql/views.sql | docker exec -i ${HYPER_CONTAINER_NAME} psql -U lsqbuser -p 7484 -h localhost ${HYPER_DATABASE_NAME}
echo Done

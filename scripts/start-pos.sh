#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/pos-vars.sh

scripts/stop-pos.sh

docker run --rm \
    --publish=5432:5432 \
    --name ${POSTGRES_CONTAINER_NAME} \
    --env POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    --volume=${POSTGRES_DATA_DIR}:/data \
    --detach \
    postgres:${POSTGRES_VERSION}

echo "Waiting for the database to start..."
sleep 5
echo "Database started"

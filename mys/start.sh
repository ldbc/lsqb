#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mys/vars.sh
. scripts/import-vars.sh

docker run --rm \
    --publish 3306:3306 \
    --name ${MYSQL_CONTAINER_NAME} \
    --env MYSQL_ALLOW_EMPTY_PASSWORD=1 \
    --env MYSQL_DATABASE=${MYSQL_DATABASE} \
    --volume=${IMPORT_DATA_DIR_MERGED_FK}:/data:z \
    --detach \
    --shm-size=${MYSQL_SHARED_MEMORY} \
    mysql:${MYSQL_VERSION}

echo "Waiting for the database to start..."
sleep 60
echo "Database started"

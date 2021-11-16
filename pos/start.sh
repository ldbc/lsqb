#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. pos/vars.sh
. scripts/import-vars.sh

docker run \
    --rm \
    --publish=5432:5432 \
    --name ${POSTGRES_CONTAINER_NAME} \
    --env ${POSTGRES_PASSWORD_POLICY} \
    --volume=${IMPORT_DATA_DIR_MERGED_FK}:/data:z \
    --volume=${POSTGRES_HOME}:/var/lib/postgresql/data:z \
    --detach \
    --shm-size=${POSTGRES_SHARED_MEMORY} \
    postgres:${POSTGRES_VERSION}

echo -n "Waiting for the database to start ."
until python3 pos/test-db-connection.py > /dev/null 2>&1; do
    echo -n " ."
    sleep 1
done
echo
echo "Database started"

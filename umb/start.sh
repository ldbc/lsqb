#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. vars.sh

python3 -c 'import psycopg2' || (echo "psycopg2 Python package is missing or broken" && exit 1)

echo -n "Starting the database . "
docker run \
    --name ${UMBRA_CONTAINER_NAME} \
    --detach \
    --volume=${UMBRA_DATABASE_DIR}:/var/db/:z \
    --publish=5432:5432 \
    --env USEDIRECTIO=1 \
    ${UMBRA_DOCKER_BUFFERSIZE_ENV_VAR} \
    ${UMBRA_DOCKER_IMAGE} \
    umbra_server \
        --address 0.0.0.0 \
        /var/db/ldbc.db \
    >/dev/null

until python3 ../pos/test-db-connection.py > /dev/null 2>&1; do
    echo -n ". "
    sleep 1
done
echo "Database started."

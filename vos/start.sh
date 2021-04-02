#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh
. scripts/import-vars.sh

#    --interactive \
#    --tty \


docker run \
    -t -d \
    --rm \
    --name ${VIRTUOSO_CONTAINER_NAME} \
    --env ${VIRTUOSO_ENV} \
    --publish 1111:1111 \
    --publish 8890:8890 \
    --volume=${VIRTUOSO_DATABASE_DIR}:/database:z \
    --volume=${VIRTUOSO_SETTINGS_DIR}:/settings \
    --volume=${IMPORT_DATA_DIR_NTRIPLES}:/tmp/import:z \
    --volume=${VIRTUOSO_QUERY_DIR}:/tmp/queries:z \
    openlink/virtuoso-opensource-7:${VIRTUOSO_VERSION}


error_code=0
docker exec -i ${VIRTUOSO_CONTAINER_NAME} isql 1111 -U ${VIRTUOSO_USER} -P ${VIRTUOSO_PWD} exec="SELECT 1;" >/dev/null 2>&1 || error_code=$?

if [ "${error_code}" -ne 0 ]; then
    echo -n 'wait'
fi
while [ "${error_code}" -ne 0 ]; do
    error_code=0
    docker exec -i ${VIRTUOSO_CONTAINER_NAME} isql 1111 -U ${VIRTUOSO_USER} -P ${VIRTUOSO_PWD} exec="SELECT 1;" >/dev/null 2>&1 || error_code=$?
    echo -n ' .'
    sleep 5
done

echo ' ready'

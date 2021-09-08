#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. clh/vars.sh
. scripts/import-vars.sh

docker run \
    --rm \
    --publish 18123:8123\
    --publish 19000:9000 \
    --name ${CLICKHOUSE_CONTAINER_NAME} \
    --ulimit nofile=262144:262144 \
    --volume=${IMPORT_DATA_DIR_MERGED_FK}:/data:z \
   --detach \
    yandex/clickhouse-server:${CLICKHOUSE_VERSION}

# echo -n "Waiting for the database to start ."
# until python3 clh/test-db-connection.py > /dev/null 2>&1; do
#     echo -n " ."
#     sleep 1
# done
# echo
# echo "Database started"

sleep 10

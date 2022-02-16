#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. hyp/vars.sh
. scripts/import-vars.sh

docker run \
    --rm \
    --publish=7484:7484 \
    --name ${HYPER_CONTAINER_NAME} \
    --volume=${IMPORT_DATA_DIR_MERGED_FK}:/data:z \
    --detach \
    --shm-size=${HYPER_SHARED_MEMORY} \
    ${HYPER_DOCKER_IMAGE}:latest

echo "Waiting for the container to start..."
sleep 10
echo "Container started"

docker exec \
    --detach ${HYPER_CONTAINER_NAME} \
    /hyper/hyperd --database /data/mydb --log-dir /hyper/ --config /hyper/config --skip-license --init-user lsqbuser --no-ssl --listen-connection tab.tcp://localhost:7484,tab.domain:///tmp/LD/domain/.s.PGSQL.7484 --no-password start

echo "Waiting for HyPer to start..."
sleep 10
echo "HyPer started"

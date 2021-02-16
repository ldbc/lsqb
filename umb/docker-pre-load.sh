#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. docker-vars.sh

docker stop ${UMBRA_CONTAINER_NAME} || echo "No container ${UMBRA_CONTAINER_NAME} found"
docker rm ${UMBRA_CONTAINER_NAME} || echo "No container ${UMBRA_CONTAINER_NAME} found"

docker run -it \
    --volume=${UMBRA_DATA_DIR}:/data \
    --volume=${UMBRA_SCRATCH_DIR}:/scratch \
    --name ${UMBRA_CONTAINER_NAME} \
    --detach \
    ${UMBRA_DOCKER_IMAGE}:latest \
    /bin/bash

#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. docker-vars.sh

docker run \
    --publish=5432:5432 \
    --volume=${UMBRA_DATA_DIR}:/data \
    --volume=${UMBRA_SCRATCH_DIR}:/scratch \
    --name ${UMBRA_CONTAINER_NAME} \
    --detach \
    ${UMBRA_DOCKER_IMAGE}:latest

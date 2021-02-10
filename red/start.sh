#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/red-vars.sh

docker run \
    --rm \
    --detach \
    --publish=6379:6379 \
    --volume=${REDISGRAPH_DATA_DIR}:/data \
    --name ${REDISGRAPH_CONTAINER_NAME} \
    redislabs/redisgraph
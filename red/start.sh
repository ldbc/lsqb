#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. red/vars.sh

docker run \
    --rm \
    --detach \
    --publish=6379:6379 \
    --volume=${REDISGRAPH_SCRATCH_DIR}:/data:z \
    --name ${REDISGRAPH_CONTAINER_NAME} \
    redislabs/redisgraph:${REDISGRAPH_VERSION}

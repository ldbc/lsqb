#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. umb/vars.sh
. scripts/import-vars.sh

# Add --cpuset-cpus=0 to force single-threaded execution
docker run \
    --rm \
    --publish=5432:5432 \
    --volume=${IMPORT_DATA_DIR_MERGED_FK}:/data:z \
    --volume=${UMBRA_SCRATCH_DIR}:/scratch:z \
    --name ${UMBRA_CONTAINER_NAME} \
    --detach \
    ${UMBRA_DOCKER_IMAGE}:latest

#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh
. xgt/vars.sh

docker run \
    --rm \
    --detach \
    --publish=4367:4367 \
    --volume=${IMPORT_DATA_DIR_PROJECTED_FK}:/data \
    --volume=${XGT_LOG_DIR}:/var/log/xgtd \
    --name ${XGT_CONTAINER_NAME} \
    trovares/xgt:${XGT_VERSION}

sleep 1

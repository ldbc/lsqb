#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. vars.sh

docker exec \
    --detach ${UMBRA_CONTAINER_NAME} \
    /umbra/bin/server -address 0.0.0.0 /scratch/ldbc.db
sleep 5

#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mat/vars.sh
. scripts/import-vars.sh

docker run \
    --rm \
    --publish 6875:6875 \
    --name ${MATERIALIZE_CONTAINER_NAME} \
    --volume=${IMPORT_DATA_DIR_MERGED_FK}:/data:z \
    --detach \
    materialize/materialized:v${MATERIALIZE_VERSION} \
    --workers 1

echo "Waiting for Materialize to start..."
sleep 1
echo "Materialize started"

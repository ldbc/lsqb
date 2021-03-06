#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh
. scripts/import-vars.sh

docker run \
    --rm \
    --name ${VIRTUOSO_CONTAINER_NAME} \
    --interactive \
    --tty \
    --env ${VIRTUOSO_ENV} \
    --publish 1111:1111 \
    --publish 8890:8890 \
    --volume=${VIRTUOSO_DATABASE_DIR}:/database:z \
    openlink/virtuoso-opensource-7:${VIRTUOSO_VERSION}

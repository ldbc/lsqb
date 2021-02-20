#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. vars.sh

docker stop ${UMBRA_CONTAINER_NAME} || echo "No container ${UMBRA_CONTAINER_NAME} found"
docker rm ${UMBRA_CONTAINER_NAME} || echo "No container ${UMBRA_CONTAINER_NAME} found"

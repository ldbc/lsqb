#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. red/vars.sh

docker stop ${REDISGRAPH_CONTAINER_NAME} || echo "No container ${REDISGRAPH_CONTAINER_NAME} found"

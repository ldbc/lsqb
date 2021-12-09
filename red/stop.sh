#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. red/vars.sh

docker rm -f ${REDISGRAPH_CONTAINER_NAME} || echo "No container ${REDISGRAPH_CONTAINER_NAME} found"

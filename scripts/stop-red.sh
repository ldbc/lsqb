#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

set -e

. scripts/red-vars.sh

docker stop ${REDISGRAPH_CONTAINER_NAME} || echo "No container ${REDISGRAPH_CONTAINER_NAME} found"

#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/pos-vars.sh

docker stop ${POSTGRES_CONTAINER_NAME} || echo "No container ${POSTGRES_CONTAINER_NAME} found"

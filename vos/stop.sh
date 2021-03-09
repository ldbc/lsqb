#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh

docker stop ${VIRTUOSO_CONTAINER_NAME} || echo "No container ${VIRTUOSO_CONTAINER_NAME} found"

#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh

docker rm -f ${VIRTUOSO_CONTAINER_NAME} || echo "No container ${VIRTUOSO_CONTAINER_NAME} found"

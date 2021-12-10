#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mys/vars.sh

docker rm -f ${MYSQL_CONTAINER_NAME} || echo "No container ${MYSQL_CONTAINER_NAME} found"

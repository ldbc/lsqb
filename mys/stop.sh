#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mys/vars.sh

docker stop ${MYSQL_CONTAINER_NAME} || echo "No container ${MYSQL_CONTAINER_NAME} found"

#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. arcadedb/vars.sh

docker stop ${ARCADEDB_CONTAINER_NAME} || echo "No container ${ARCADEDB_CONTAINER_NAME} found"

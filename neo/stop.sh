#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. neo/vars.sh

docker rm -f ${NEO4J_CONTAINER_NAME} || echo "No container ${NEO4J_CONTAINER_NAME} found"

#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. hyp/vars.sh

docker stop ${HYPER_CONTAINER_NAME} || echo "No container ${HYPER_CONTAINER_NAME} found"
sleep 10

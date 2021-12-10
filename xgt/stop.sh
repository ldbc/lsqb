#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. xgt/vars.sh

docker rm -f ${XGT_CONTAINER_NAME} || echo "No container ${XGT_CONTAINER_NAME} found"

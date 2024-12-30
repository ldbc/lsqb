#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mem/vars.sh

docker rm -f ${MEMGRAPH_CONTAINER} || echo "No container ${MEMGRAPH_CONTAINER} found"

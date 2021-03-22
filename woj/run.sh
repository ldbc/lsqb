#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. woj/vars.sh
. scripts/import-vars.sh

[ ! "$(docker ps -a | grep ${JENA_CONTAINER_NAME})" ] && echo "container is not running!" && exit 1

python3 woj/client.py ${SF}



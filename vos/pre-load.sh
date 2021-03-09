#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..



. vos/vars.sh

vos/stop.sh
vos/start.sh


docker cp vos/load.isql  ${VIRTUOSO_CONTAINER_NAME}:/tmp
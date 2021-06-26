#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh
. scripts/import-vars.sh

if [ ! -f ${LSQB_NT_FILE} ]; then
    echo "Input file ${LSQB_NT_FILE} does not exist"
    exit 1
fi

docker exec -it ${VIRTUOSO_CONTAINER_NAME} isql -U ${VIRTUOSO_USER} -P ${VIRTUOSO_PWD} exec="LOAD /tmp/load.isql ;"

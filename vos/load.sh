#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh
. scripts/import-vars.sh

if [ ! -f ${IMPORT_DATA_DIR_PROJECTED_FK}/ldbc.nt ]; then
    echo "Input file ${IMPORT_DATA_DIR_PROJECTED_FK}/ldbc.nt does not exist"
    exit 1
fi

docker exec -it ${VIRTUOSO_CONTAINER_NAME} isql -U ${VIRTUOSO_USER} -P ${VIRTUOSO_PWD} exec="LOAD /tmp/load.isql ;"

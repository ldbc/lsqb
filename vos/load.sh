#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh

docker exec -it  ${VIRTUOSO_CONTAINER_NAME} isql-U ${VIRTUOSO_USER} -P ${VIRTUOSO_PWD} exec="LOAD /tmp/load.isql ;"


# TODO
# Refer to the script at https://github.com/ldbc/ldbc_snb_implementations/blob/fe82499dcc86f7e016475de17c55bd4776f8c2af/interactive/virtuoso/scripts/ld.sql

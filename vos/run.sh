#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh
. scripts/import-vars.sh

for qfile in `ls -1 ./sparql/*.sparql`
do
    #docker cp $qfile  ${VIRTUOSO_CONTAINER_NAME}:/tmp
    qname="$(basename -- $qfile)"
    docker exec -it  ${VIRTUOSO_CONTAINER_NAME} isql -U ${VIRTUOSO_USER} -P ${VIRTUOSO_PWD} exec="SPARQL $(cat $qfile) ;"

done

#python3 pos/client.py ${SF}

#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. vos/vars.sh
. scripts/import-vars.sh

for qfile in `ls -1 ./sparql/q*.sparql`
do
    #docker cp $qfile  ${VIRTUOSO_CONTAINER_NAME}:/tmp
    echo ======================== $qfile ========================
    qname="$(basename -- $qfile)"
    docker exec -it  ${VIRTUOSO_CONTAINER_NAME} isql -U ${VIRTUOSO_USER} -P ${VIRTUOSO_PWD} exec="SPARQL $(cat $qfile) ;" | grep -E '^[0-9][^ ]'

done

#python3 pos/client.py ${SF}

#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh
. woj/vars.sh


error_code=0
#    --env "${JENA_ENV2}" \

docker run \
    -t -d \
    --rm \
    --name ${JENA_CONTAINER_NAME} \
    --env "${JENA_ENV1}" \
    --env TDB=2 \
    --publish 8890:3030 \
    --volume=${JENA_DATABASE_DIR}:/fuseki:z \
    --volume=${IMPORT_DATA_DIR_NTRIPLES}:/staging:z \
    --volume=${JENA_DIR}/fuseki-leapfrog.jar:/jena-fuseki/fuseki-server.jar \
    --entrypoint java \
    stain/jena-fuseki:${JENA_VERSION} \
    -Xmx4g -jar /jena-fuseki/fuseki-server.jar --loc=/fuseki/databases/ldbc --timeout=300000 /ldbc

# Maybe needed?
#while [[ $(curl -I http://localhost:8890/ldbc 2>/dev/null | head -n 1 | cut -d$' ' -f2) != '200' ]]; do
#  sleep 1s
#done


echo ' ready'

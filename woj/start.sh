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

#while [[ $(curl -I http://localhost:8890/ldbc 2>/dev/null | head -n 1 | cut -d$' ' -f2) != '200' ]]; do
#  sleep 1s
#done

#docker run -d --name jena \
#       -p 5820:3030 -e ADMIN_PASSWORD=admin -e JVM_ARGS='-Xmx64g -Xms12g -XX:MaxDirectMemorySize=2g' \
#       -v`pwd`/jena:/fuseki \
#       -v`pwd`/data:/staging \
#       stain/jena-fuseki \
#       ./fuseki-server --port=3030



#apache-jena-3.9.0/bin/tdbloader2 --loc=db/leapfrog ../wikidata-filtered.nt






#curl 'http://localhost:8890/$/datasets' -H "Authorization: Basic $(echo -n admin: ${JENA_PWD} | base64)" \
#    -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' --data "dbName=${JENA_DBNAME}&dbType=tdb2"

#if [ "${error_code}" -ne 0 ]; then
#    echo -n 'wait'
#fi
#while [ "${error_code}" -ne 0 ]; do
#    error_code=0
#    docker exec -i ${VIRTUOSO_CONTAINER_NAME} isql 1111 -U ${VIRTUOSO_USER} -P ${VIRTUOSO_PWD} exec="SELECT 1;" >/dev/null 2>&1 || error_code=$?
#    echo -n ' .'
#    sleep 5
#done

echo ' ready'

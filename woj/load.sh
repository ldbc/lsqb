#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. woj/vars.sh
. scripts/import-vars.sh

if [ ! -f ${TSMB_NT_FILE} ]; then
    echo "Input file ${TSMB_NT_FILE} does not exist"
    exit 1
fi

TSMB_NT_FILE_NAME="$(basename -- $TSMB_NT_FILE)"

docker run \
    -it \
    --rm \
    --name ${JENA_CONTAINER_NAME} \
    --env "${JENA_ENV1}" \
    --env "${JENA_ENV2}" \
    --publish 5820:8890 \
    --volume=${JENA_DATABASE_DIR}:/fuseki:z \
    --volume=${IMPORT_DATA_DIR_NTRIPLES}:/staging:z \
    --volume=${JENA_DIR}/tdbloader2index:/jena/bin/tdbloader2index \
    --volume=${JENA_DIR}/log4j.properties:/jena/bin/log4j.properties \
    --entrypoint /jena/bin/tdbloader2 \
    stain/jena:${JENA_VERSION} \
    --loc=/fuseki/databases/ldbc /staging/${TSMB_NT_FILE_NAME}



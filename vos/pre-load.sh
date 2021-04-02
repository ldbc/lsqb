#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh
. vos/vars.sh

vos/stop.sh


# take ownership of the mounted data in the scratch directory and clean it up
docker run -it --rm \
    --volume=${VIRTUOSO_DATABASE_DIR}:/database:z \
    --volume=${VIRTUOSO_SETTINGS_DIR}:/settings \
    --volume=${IMPORT_DATA_DIR_NTRIPLES}:/tmp/import:z \
    --volume=${VIRTUOSO_QUERY_DIR}:/tmp/queries:z \
    openlink/virtuoso-opensource-7:${VIRTUOSO_VERSION} /bin/chown -R $(stat -c '%u' .):$(stat -c '%g' .) /database /settings


#sudo chown -R $USER:$USER vos/scratch/
rm -rf vos/scratch/*

mkdir -p ${VIRTUOSO_DATABASE_DIR}
#cp vos/virtuoso.ini ${VIRTUOSO_DATABASE_DIR}

vos/start.sh

docker cp vos/load.isql ${VIRTUOSO_CONTAINER_NAME}:/tmp

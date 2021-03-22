#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh
. woj/vars.sh

woj/stop.sh


# take ownership of the mounted data in the scratch directory and clean it up
docker run -it --rm \
    --volume=${JENA_DATABASE_DIR}:/fuseki:z \
    --volume=${IMPORT_DATA_DIR_NTRIPLES}:/staging:z \
    --entrypoint /bin/chown \
    stain/jena-fuseki:${JENA_VERSION} -R $(stat -c '%u' .):$(stat -c '%g' .) /fuseki /staging

rm -rf woj/scratch/*
mkdir -p woj/scratch/databases

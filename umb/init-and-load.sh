#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh
. umb/vars.sh

echo "==============================================================================="
echo "Loading the Umbra database"
echo "-------------------------------------------------------------------------------"
echo "UMBRA_CONTAINER_NAME: ${UMBRA_CONTAINER_NAME}"
echo "UMBRA_DATABASE_DIR: ${UMBRA_DATABASE_DIR}"
echo "UMBRA_DOCKER_IMAGE: ${UMBRA_DOCKER_IMAGE}"
echo "UMBRA_SQL_DIR: ${UMBRA_SQL_DIR}"
echo "IMPORT_DATA_DIR_MERGED_FK: ${IMPORT_DATA_DIR_MERGED_FK}"
echo "COMMON_SQL_DIR: ${COMMON_SQL_DIR}"
echo "==============================================================================="

umb/pre-load.sh
umb/load.sh
umb/post-load.sh

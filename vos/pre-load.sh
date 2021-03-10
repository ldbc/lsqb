#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh
. vos/vars.sh

vos/stop.sh

# take ownership of the mounted data in the scratch directory and clean it up
sudo chown -R $USER:$USER vos/scratch/
rm -rf vos/scratch/*

vos/start.sh

docker cp vos/load.isql ${VIRTUOSO_CONTAINER_NAME}:/tmp

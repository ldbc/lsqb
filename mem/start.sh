#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mem/vars.sh
. scripts/import-vars.sh

# port changed from 7687 to 27687
# to debug, remove the --detach flag and add the following:
# --also-log-to-stderr 
# --log-level TRACE

docker run \
    --rm \
    --detach \
    --publish 27687:7687 \
    --volume mg_lib:/var/lib/memgraph:z \
    --volume mg_log:/var/log/memgraph:z \
    --volume mg_etc:/etc/memgraph:z \
    --volume ${IMPORT_DATA_DIR_PROJECTED_FK}:/import:z \
    --name ${MEMGRAPH_CONTAINER} \
    memgraph/memgraph:${MEMGRAPH_VERSION} \
    --telemetry-enabled=False

sleep 5

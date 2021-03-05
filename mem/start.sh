#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mem/vars.sh

# grab and load docker image if needed
if docker image inspect memgraph:${MEMGRAPH_VERSION}-community > /dev/null; then
    echo Docker image found
else
    echo Docker image not found, downloading it...
    curl https://download.memgraph.com/memgraph/v${MEMGRAPH_VERSION}/docker/memgraph-${MEMGRAPH_VERSION}-community-docker.tar.gz | docker load
fi

docker stop ${MEMGRAPH_CONTAINER} || echo "No container ${MEMGRAPH_CONTAINER} found"

# port changed from 7687 to 27687
docker run \
    --rm \
    --detach \
    --publish 27687:7687 \
    --volume mg_lib:/var/lib/memgraph:z \
    --volume mg_log:/var/log/memgraph:z \
    --volume mg_etc:/etc/memgraph:z \
    --name ${MEMGRAPH_CONTAINER} \
    memgraph

sleep 5

#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/mem-vars.sh

# port changed from 7687 to 27687
docker run \
  --publish 27687:7687 \
  --volume=${MEMGRAPH_DIR}/lib:/var/lib/memgraph \
  --volume=${MEMGRAPH_DIR}/log:/var/log/memgraph \
  --volume=${MEMGRAPH_DIR}/etc:/etc/memgraph \
  memgraph

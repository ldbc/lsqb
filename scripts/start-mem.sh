#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

set -e

. scripts/mem-vars.sh

docker kill mem
docker rm mem

# port changed from 7687 to 27687
docker run \
  --publish 27687:7687 \
  --volume mg_lib:/var/lib/memgraph \
  --volume mg_log:/var/log/memgraph \
  --volume mg_etc:/etc/memgraph \
  --name mem \
  memgraph

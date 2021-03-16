#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mem/vars.sh

echo "Download Memgraph Docker image"
cd mem/scratch
wget -q https://download.memgraph.com/memgraph/v${MEMGRAPH_VERSION}/docker/memgraph-${MEMGRAPH_VERSION}-community-docker.tar.gz
docker load -i memgraph-${MEMGRAPH_VERSION}-community-docker.tar.gz
rm memgraph-${MEMGRAPH_VERSION}-community-docker.tar.gz

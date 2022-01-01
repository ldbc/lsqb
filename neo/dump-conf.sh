#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. neo/vars.sh

mkdir -p ${NEO4J_HOME}/conf

docker run --rm \
    --user="$(id -u):$(id -g)" \
    --volume=${NEO4J_HOME}/conf:/conf:z \
    neo4j:${NEO4J_VERSION}

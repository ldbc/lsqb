#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. neo/vars.sh

if [ ! -d ${NEO4J_DATA_DIR} ]; then
    echo "Neo4j data is not loaded"
    exit 1
fi

docker run \
    --rm \
    --publish=7474:7474 \
    --publish=7687:7687 \
    --detach \
    --ulimit nofile=40000:40000 \
    ${NEO4J_ENV_VARS} \
    --volume=${NEO4J_DATA_DIR}:/data:z \
    --volume=${NEO4J_HOME}/logs:/logs:z \
    --volume=${NEO4J_HOME}/import:/var/lib/neo4j/import:z \
    --volume=${NEO4J_HOME}/metrics:/var/lib/neo4j/metrics:z \
    --volume=${NEO4J_HOME}/plugins:/plugins:z \
    --env NEO4J_AUTH=none \
    --name ${NEO4J_CONTAINER_NAME} \
    neo4j:${NEO4J_VERSION}

echo "Waiting for Neo4j to start..."
until docker exec --interactive --tty ${NEO4J_CONTAINER_NAME} cypher-shell "RETURN 'Neo4j started' AS message" > /dev/null 2>&1; do
    sleep 1
done

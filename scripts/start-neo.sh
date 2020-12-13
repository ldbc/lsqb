#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/neo-vars.sh

docker run --rm \
    --user="$(id -u):$(id -g)" \
    --publish=17474:7474 \
    --publish=17687:7687 \
    ${NEO4J_CONTAINER_DETACH} \
    --volume=${NEO4J_DATA_DIR}:/data \
    --volume=${NEO4J_DATA_DIR}:/data \
    --volume=${NEO4J_HOME}/logs:/logs \
    --volume=${NEO4J_HOME}/import:/var/lib/neo4j/import \
    --volume=${NEO4J_HOME}/plugins:/plugins \
    --env NEO4J_AUTH=none \
    neo4j:${NEO4J_VERSION}

#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/neo-vars.sh

if [ ! -d ${NEO4J_DATA_DIR} ]; then
    echo "Neo4j data is not loaded"
    exit 1
fi

docker run --rm \
    --user="$(id -u):$(id -g)" \
    --publish=17474:7474 \
    --publish=17687:7687 \
    --detach \
    ${NEO4J_ENV_VARS} \
    --volume=${NEO4J_DATA_DIR}:/data \
    --volume=${NEO4J_HOME}/logs:/logs \
    --volume=${NEO4J_HOME}/import:/var/lib/neo4j/import \
    --volume=${NEO4J_HOME}/plugins:/plugins \
    --env NEO4J_AUTH=none \
    --name neo \
    neo4j:${NEO4J_VERSION} \

echo "Waiting for the database to start"
until docker exec -it neo cypher-shell 'RETURN 42'; do
    echo -n .
    sleep 1
done

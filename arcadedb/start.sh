#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. arcadedb/vars.sh

mkdir -p ${ARCADEDB_DATA_DIR}

docker run \
    --rm \
    --publish=127.0.0.1:${ARCADEDB_HTTP_PORT}:2480 \
    --detach \
    --ulimit nofile=40000:40000 \
    --env JAVA_OPTS="-Darcadedb.server.rootPassword=${ARCADEDB_ROOT_PASSWORD} -Darcadedb.server.httpBodyContentMaxSize=-1" \
    --env ARCADEDB_OPTS_MEMORY="-Xms${ARCADEDB_HEAP} -Xmx${ARCADEDB_HEAP}" \
    --volume=${ARCADEDB_DATA_DIR}:/home/arcadedb/databases:z \
    --name ${ARCADEDB_CONTAINER_NAME} \
    arcadedata/arcadedb:${ARCADEDB_VERSION}

echo "Waiting for ArcadeDB to start..."
# /api/v1/ready answers before the root user exists, so probe an authenticated endpoint
until curl -sf -u root:${ARCADEDB_ROOT_PASSWORD} http://localhost:${ARCADEDB_HTTP_PORT}/api/v1/server >/dev/null; do
    sleep 1
done
echo "ArcadeDB started"

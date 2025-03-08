#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. hyper/vars.sh

hyper/stop.sh
hyper/start.sh

echo "CREATE DATABASE ${HYPER_DATABASE_NAME};" | docker exec -i ${HYPER_CONTAINER_NAME} psql -U lsqbuser -p 7484 -h localhost


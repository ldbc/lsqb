#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. arcadedb/vars.sh

arcadedb/stop.sh

# start with a fresh database directory (the server runs as a non-root user in the container)
rm -rf ${ARCADEDB_DATA_DIR}
mkdir -p ${ARCADEDB_DATA_DIR}
chmod 777 ${ARCADEDB_DATA_DIR}

arcadedb/start.sh

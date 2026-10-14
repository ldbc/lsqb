#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. arcadedb-embedded/vars.sh
. scripts/import-vars.sh

# defines the Graph Analytical View (CSR) that accelerates traversals; it is persisted with the database
${ARCADEDB_JAVA} -Xms${ARCADEDB_HEAP} -Xmx${ARCADEDB_HEAP} --add-modules jdk.incubator.vector ${ARCADEDB_JVM_FLAGS} \
    -cp "${ARCADEDB_EMBEDDED_HOME}/classes:${ARCADEDB_LIB}/*" LsqbArcadeDB post-load ${SF} ${ARCADEDB_EMBEDDED_DB} ${IMPORT_DATA_DIR_MERGED_FK}

#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. arcadedb-embedded/vars.sh
. scripts/import-vars.sh

# optional argument: number of warm repetitions (one warm-up call, then the median of N timed runs); default 0 = single cold run
${ARCADEDB_JAVA} -Xms${ARCADEDB_HEAP} -Xmx${ARCADEDB_HEAP} --add-modules jdk.incubator.vector ${ARCADEDB_JVM_FLAGS} \
    -cp "${ARCADEDB_EMBEDDED_HOME}/classes:${ARCADEDB_LIB}/*" LsqbArcadeDB run ${SF} ${ARCADEDB_EMBEDDED_DB} ${IMPORT_DATA_DIR_MERGED_FK} ${1:-0}

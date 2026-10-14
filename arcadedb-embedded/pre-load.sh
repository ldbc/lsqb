#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. arcadedb-embedded/vars.sh

mkdir -p ${ARCADEDB_EMBEDDED_HOME}

# download the ArcadeDB release (engine and dependencies) from Maven Central, once
if [ ! -d ${ARCADEDB_LIB} ]; then
    curl -fL https://repo1.maven.org/maven2/com/arcadedb/arcadedb-package/${ARCADEDB_VERSION}/arcadedb-package-${ARCADEDB_VERSION}.tar.gz \
        | tar xz -C ${ARCADEDB_EMBEDDED_HOME}
fi

mkdir -p ${ARCADEDB_EMBEDDED_HOME}/classes
${ARCADEDB_JAVAC} -cp "${ARCADEDB_LIB}/*" -d ${ARCADEDB_EMBEDDED_HOME}/classes arcadedb-embedded/LsqbArcadeDB.java

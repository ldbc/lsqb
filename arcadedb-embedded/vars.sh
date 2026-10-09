export ARCADEDB_VERSION=${ARCADEDB_VERSION:-26.10.1}
export ARCADEDB_EMBEDDED_HOME=`pwd`/arcadedb-embedded/scratch
export ARCADEDB_EMBEDDED_DB=`pwd`/arcadedb-embedded/scratch/lsqb-database
# directory with the ArcadeDB jars; pre-load.sh downloads the release into the default location, set it to use a local build
export ARCADEDB_LIB=${ARCADEDB_LIB:-${ARCADEDB_EMBEDDED_HOME}/arcadedb-${ARCADEDB_VERSION}/lib}
# set to 1 to not use the Graph Analytical View (post-load.sh then does nothing and the queries run on the stored graph)
export ARCADEDB_NO_GAV=${ARCADEDB_NO_GAV:-0}
export ARCADEDB_HEAP=${ARCADEDB_HEAP:-4G}
# JDK 21 or newer; set ARCADEDB_JAVA_HOME to pick one, e.g. a Temurin 25
export ARCADEDB_JAVA=${ARCADEDB_JAVA_HOME:+${ARCADEDB_JAVA_HOME}/bin/}java
export ARCADEDB_JAVAC=${ARCADEDB_JAVA_HOME:+${ARCADEDB_JAVA_HOME}/bin/}javac
# extra JVM flags, e.g. "-XX:+UseCompactObjectHeaders" (JDK 25)
export ARCADEDB_JVM_FLAGS=${ARCADEDB_JVM_FLAGS:-}

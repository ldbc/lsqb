export ARCADEDB_HOME=`pwd`/arcadedb/scratch
export ARCADEDB_DATA_DIR=`pwd`/arcadedb/scratch/databases
export ARCADEDB_VERSION=${ARCADEDB_VERSION:-26.10.1}
export ARCADEDB_CONTAINER_NAME=lsqb-arcadedb
export ARCADEDB_ROOT_PASSWORD=lsqbbenchmark
# not 2480, so that it does not clash with an ArcadeDB already running on the machine
export ARCADEDB_HTTP_PORT=${ARCADEDB_HTTP_PORT:-22480}
export ARCADEDB_HEAP=${ARCADEDB_HEAP:-4G}

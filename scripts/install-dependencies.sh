#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. ddb/vars.sh

if [[ ! -z $(which dnf) ]]; then
    sudo dnf install -y python3-pip zstd unzip unixODBC-devel
elif [[ ! -z $(which apt) ]]; then
    sudo apt install -y python3-pip zstd unzip unixodbc-dev
fi

# DuckDB binary
ddb/get.sh

# clients
pip3 install --user duckdb==${DUCKDB_VERSION}
pip3 install --user neo4j
pip3 install --user redisgraph redisgraph-bulk-loader
pip3 install --user psycopg2-binary
pip3 install --user mysql-connector-python
pip3 install --user pyodbc virtuoso

# visualization
pip3 install --user matplotlib pandas seaborn natsort

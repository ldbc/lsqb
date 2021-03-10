#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. ddb/vars.sh

if [[ ! -z $(which dnf) ]]; then
    sudo dnf install -y python3-pip zstd unzip unixODBC-devel
elif [[ ! -z $(which apt) ]]; then
    sudo apt update
    sudo apt install -y python3-pip zstd unzip unixodbc-dev
fi

# DuckDB binary
ddb/get.sh

# clients
pip3 install --user --progress-bar off duckdb==${DUCKDB_VERSION}
pip3 install --user --progress-bar off neo4j
pip3 install --user --progress-bar off wheel
pip3 install --user --progress-bar off redisgraph redisgraph-bulk-loader
pip3 install --user --progress-bar off psycopg2-binary
pip3 install --user --progress-bar off mysql-connector-python
#pip3 install --user --progress-bar off pyodbc virtuoso

# visualization
pip3 install --user matplotlib pandas seaborn natsort

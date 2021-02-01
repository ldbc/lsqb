#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

if [[ ! -z $(which dnf) ]]; then
    sudo dnf install -y pv
elif [[ ! -z $(which apt) ]]; then
    sudo apt install -y pv
fi

pip3 install duckdb==${DUCKDB_VERSION}
pip3 install neo4j
pip3 install redisgraph redisgraph-bulk-loader

./download-ddb.sh

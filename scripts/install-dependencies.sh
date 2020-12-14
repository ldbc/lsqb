#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

if [[ ! -z $(which dnf) ]]; then
    sudo dnf install -y pv
elif [[ ! -z $(which apt) ]]; then
    sudo apt install -y pv
fi

DUCKDB_VERSION=v0.2.3

cd duc-scratch
wget https://github.com/cwida/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-amd64.zip
unzip duckdb_cli-linux-amd64.zip
rm duckdb_cli-linux-amd64.zip

pip3 install duckdb==${DUCKDB_VERSION}

pip3 install neo4j
pip3 install redisgraph redisgraph-bulk-loader

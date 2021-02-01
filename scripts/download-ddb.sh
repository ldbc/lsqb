#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

DUCKDB_VERSION=v0.2.3

cd ddb-scratch
wget https://github.com/cwida/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-amd64.zip
unzip duckdb_cli-linux-amd64.zip
rm duckdb_cli-linux-amd64.zip

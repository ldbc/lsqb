#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. ddb/vars.sh

cd ddb/scratch
wget -q https://github.com/cwida/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-amd64.zip -O duckdb_cli-linux-amd64.zip
unzip -o duckdb_cli-linux-amd64.zip
rm duckdb_cli-linux-amd64.zip

#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. postgres/vars.sh
. scripts/import-vars.sh

python3 postgres/client.py --sf "${SF}" --system PostgreSQL --variant "${VARIANT,,}" --queries-path "${POSTGRES_SCHEMA_DIR}"

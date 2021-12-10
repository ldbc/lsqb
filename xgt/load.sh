#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. xgt/vars.sh
. scripts/import-vars.sh

# make sure directories exist
mkdir -p ${XGT_LOG_DIR}

python3 xgt/load.py

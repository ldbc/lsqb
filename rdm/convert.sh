#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/import-vars.sh

ddb/load.sh
echo Converting the graph to '.graph' format...
python3 rdm/convert.py
echo Done

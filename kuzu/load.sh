#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. kuzu/vars.sh
. scripts/import-vars.sh

kuzu/convert.sh
python3 kuzu/load.py ${SF} $@

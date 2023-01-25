#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. kuz/vars.sh
. scripts/import-vars.sh

kuz/convert.sh
python3 kuz/load.py ${SF} $@

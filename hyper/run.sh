#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. hyper/vars.sh
. scripts/import-vars.sh

python3 hyper/client.py ${SF}

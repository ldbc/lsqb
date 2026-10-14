#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. arcadedb/vars.sh

# build the Graph Analytical View (CSR) that accelerates traversals
python3 arcadedb/post_load.py

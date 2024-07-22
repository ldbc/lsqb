#!/usr/bin/env bash

# script to validate results of two systems

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

python3 scripts/validate.py $@

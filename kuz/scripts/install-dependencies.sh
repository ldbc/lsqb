#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd ../scratch/

virtualenv .kuzu-venv

source .kuzu-venv/bin/activate

pip install kuzu

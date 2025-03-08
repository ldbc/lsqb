#!/usr/bin/env bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd ..
. vars.sh

cd scratch/

virtualenv .kuzu-venv

source .kuzu-venv/bin/activate

pip install kuzu==${KUZU_VERSION}

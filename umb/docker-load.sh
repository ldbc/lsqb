#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. umb/vars.sh

curl -s ${UMBRA_URL_PREFIX}${UMBRA_VERSION}.tar.gz | docker load

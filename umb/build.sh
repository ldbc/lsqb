#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. vars.sh

cd umbra-binaries
docker build . --tag ${UMBRA_DOCKER_IMAGE}

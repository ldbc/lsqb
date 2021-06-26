#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. vars.sh

cd hyper-binaries
docker build . --tag ${HYPER_DOCKER_IMAGE}

#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mem/vars.sh

mem/stop.sh

# cleanup Memgraph volumes
docker volume rm mg_lib mg_etc mg_log || echo "No existing Memgraph volumes found"

mem/start.sh

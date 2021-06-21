#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mem/vars.sh

mem/stop.sh

# initialize and cleanup Memgraph dirs
mkdir -p ${MEMGRAPH_DIR}/{lib,etc,log}
rm -rf ${MEMGRAPH_DIR}/{lib,etc,log}/*

mem/start.sh

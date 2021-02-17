#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

cd umb/scratch

# start DB server
cp bin/server bin/umbra-server
LD_LIBRARY_PATH=./lib ./bin/umbra-server ldbc.db >/dev/null &
sleep 1

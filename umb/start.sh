#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

cd umb/scratch

# start DB server
LD_LIBRARY_PATH=./lib ./bin/server ldbc.db >& /dev/null &
echo $! > umbra_server_pid
sleep 1

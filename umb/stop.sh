#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

cd umb/scratch

pkill -f umbra-server || echo "No process named 'umbra-server' found"

#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

cd umb/scratch

if [ -f "umbra_server_pid" ]; then
    PID=$(cat umbra_server_pid )
    # Replace script with kill command. This will prevent going
    # further in the script. 
    rm -f umbra_server_pid
    exec kill $PID || "No process with PID ${PID} found"
fi

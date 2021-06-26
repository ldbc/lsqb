#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. ddb/vars.sh

if [[ ! -z $(which yum) ]]; then
    sudo yum install -y tmux vim htop nmon curl wget postgresql the_silver_searcher
elif [[ ! -z $(which apt) ]]; then
    sudo apt update
    sudo apt install -y tmux vim htop nmon curl wget postgresql-client silversearcher-ag
fi

#!/bin/bash

set -eu
set -o pipefail

# install dependencies
if [[ ! -z $(which dnf) ]]; then
    sudo dnf install -y git cmake make gcc gcc-c++ openssl-devel python3-devel
elif [[ ! -z $(which apt) ]]; then
    sudo apt install -y git cmake make gcc g++ libssl-dev python3-dev
fi

rm -rf mgclient pymgclient
git clone https://github.com/memgraph/mgclient/
git clone https://github.com/memgraph/pymgclient/

cd mgclient
mkdir build
cd build
cmake ..
make

sudo make install
sudo ldconfig

cd ../..
cd pymgclient
python3 setup.py build
python3 setup.py install --user

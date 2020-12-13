#!/bin/bash

# install dependencies
if [[ ! -z $(which dnf) ]]; then
    sudo dnf install -y git cmake make gcc gcc-c++ openssl-devel
elif [[ ! -z $(which apt) ]]; then
    sudo apt install -y git cmake make gcc g++ libssl-dev
fi

git clone --branch v1.0.0 https://github.com/memgraph/mgclient/

cd mgclient
mkdir build
cd build
cmake ..
make

sudo make install
sudo ldconfig

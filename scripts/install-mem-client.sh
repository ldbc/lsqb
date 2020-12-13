#!/bin/bash

# install dependencies
if [[ ! -z $YUM_CMD ]]; then
    sudo yum install -y git cmake make gcc gcc-c++ openssl-devel
elif [[ ! -z $APT_GET_CMD ]]; then
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

#!/bin/bash

# install dependencies
sudo apt-get install -y git cmake make gcc g++ libssl-dev
sudo yum install -y git cmake make gcc gcc-c++ openssl-devel

git clone --branch v1.0.0 https://github.com/memgraph/mgclient/

cd mgclient
mkdir build
cd build
cmake ..
make

sudo make install
sudo ldconfig

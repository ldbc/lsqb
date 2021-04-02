#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd scratch

git clone --branch homomorphic-matching https://github.com/szarnyasg/RapidMatch RapidMatch-homomorphic
git clone --branch isomorphic-matching  https://github.com/szarnyasg/RapidMatch RapidMatch-isomorphic

cd RapidMatch-homomorphic; mkdir build; cd build; cmake ..; make -j2; cd ../..
cd RapidMatch-isomorphic ; mkdir build; cd build; cmake ..; make -j2; cd ../..

cd ..

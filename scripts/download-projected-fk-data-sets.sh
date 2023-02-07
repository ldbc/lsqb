#!/bin/bash

# download data sets with the projected FK layout

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ../data

for SF in 0.1 0.3; do
    echo "Downloading scale factor ${SF}"
    curl --silent --fail https://repository.surfsara.nl/datasets/cwi/lsqb/files/lsqb-projected/social-network-sf${SF}-projected-fk.tar.zst | tar -x --use-compress-program=unzstd
done

for SF in 1 3 10 30 100 300 1000; do
    if [ "${SF}" -gt "${MAX_SF}" ]; then
        break
    fi
    echo "Downloading scale factor ${SF}"
    curl --silent --fail https://repository.surfsara.nl/datasets/cwi/lsqb/files/lsqb-projected/social-network-sf${SF}-projected-fk.tar.zst | tar -x --use-compress-program=unzstd
done

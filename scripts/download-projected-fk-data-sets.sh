#!/bin/bash

# download data sets with the projected FK layouts

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ../data

for SF in 0.1 0.3 1 3 10 30 100 300 1000; do
    curl --silent --fail https://repository.surfsara.nl/datasets/cwi/lsqb/files/lsqb-merged/social-network-sf${SF}-projected-fk.tar.zst | tar -xv --use-compress-program=unzstd
done

#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. kuz/vars.sh
. scripts/import-vars.sh

cd data/social-network-sf${SF}-projected-fk

if [ ! -f Person_knows_Person_bidirectional.csv ]; then
    echo "Creating CSV file with backwards 'knows' edges"
    cat Person_knows_Person.csv <(cat Person_knows_Person.csv | awk -F"|"  -v OFS="|" '{print($2, $1)}'| tail -n +2) > Person_knows_Person_bidirectional.csv
fi

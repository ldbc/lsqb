#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. memgraph/vars.sh
. scripts/import-vars.sh

for FILE in ${IMPORT_DATA_DIR_PROJECTED_FK}/*.csv; do
    tail -n +2 ${FILE} > ${FILE}-headerless
done

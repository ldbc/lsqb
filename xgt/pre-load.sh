#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. xgt/vars.sh
. scripts/import-vars.sh

xgt/stop.sh

awk -F'|' '{ print $2 "|" $1}' ${IMPORT_DATA_DIR_PROJECTED_FK}/Person_knows_Person.csv > ${IMPORT_DATA_DIR_PROJECTED_FK}/Person_knows_Person-reverse.csv

xgt/start.sh

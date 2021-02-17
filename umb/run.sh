#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. umb/vars.sh

cd umb/scratch

for i in $(seq 1 6); do
  echo ============ Q${i} ============
  LD_LIBRARY_PATH=./lib ./bin/sql ./ldbc.db ../../sql/q${i}.sql
done

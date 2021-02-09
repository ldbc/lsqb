#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/umb-vars.sh

cd umb-scratch
for i in $(seq 1 6); do
  ./bin/sql ldbc.db ../sql/q${i}.sql
done

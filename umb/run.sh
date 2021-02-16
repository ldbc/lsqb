#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. umb/vars.sh

for i in $(seq 1 6); do
  echo ============ Q${i} ============
  umb/scratch/bin/sql umb/scratch/ldbc.db sql/q${i}.sql
done

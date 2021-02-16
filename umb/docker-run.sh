#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. docker-vars.sh

for i in $(seq 1 6); do
  echo ============ Q${i} ============
  cp ../sql/q${i}.sql scratch/
  docker exec -i ${UMBRA_CONTAINER_NAME} /umbra/bin/sql /scratch/ldbc.db /scratch/q${i}.sql
done

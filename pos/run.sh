#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. pos/vars.sh

for i in $(seq 1 6); do
  echo ============ Q${i} ============
  time bash -c "cat sql/q${i}.sql | docker exec -i ${POSTGRES_CONTAINER_NAME} psql -U postgres"
done

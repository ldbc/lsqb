#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. vars.sh

for q in `seq 1 9`; do
    echo "# Q${q}"
    echo "\`\`\`"
    echo "EXPLAIN" | cat - ../sql/q${q}.sql > scratch/explain-q${q}.sql
    docker exec ${UMBRA_CONTAINER_NAME} /umbra/bin/sql /scratch/ldbc.db /scratch/explain-q${q}.sql
    echo "\`\`\`"
    echo
done

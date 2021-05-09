#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mat/vars.sh
#. pos/vars.sh

echo Loading data to Materialize...
#sed "s|PATHVAR|/data|" mat/load.sql | docker exec -i ${MATERIALIZE_CONTAINER_NAME} psql -U materialize
# using a local PostgreSQL installation
sed "s|PATHVAR|/data|" mat/load.sql | psql -U materialize -h localhost -p 6875 materialize
echo Done

#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mys/vars.sh

cat sql/drop.sql | docker exec -i ${MYSQL_CONTAINER_NAME} mysql -uroot ${MYSQL_DATABASE_NAME}

echo Loading data to MySQL...
cat sql/schema.sql | docker exec -i ${MYSQL_CONTAINER_NAME} mysql -uroot ${MYSQL_DATABASE_NAME}
sed "s|PATHVAR|/data|" mys/snb-load.sql | docker exec -i ${MYSQL_CONTAINER_NAME} mysql --local-infile=1 -uroot ${MYSQL_DATABASE_NAME}
echo Done

echo Initializing views and indexes...
cat sql/views.sql | docker exec -i ${MYSQL_CONTAINER_NAME} mysql -uroot ${MYSQL_DATABASE_NAME}
echo Done

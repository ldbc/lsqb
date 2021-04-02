#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mys/vars.sh

mys/stop.sh
mys/start.sh

echo "SET GLOBAL local_infile=1" | docker exec -i ${MYSQL_CONTAINER_NAME} mysql -uroot ${MYSQL_DATABASE_NAME}
echo "GRANT FILE ON *.* TO 'root'@'localhost'" | docker exec -i ${MYSQL_CONTAINER_NAME} mysql -uroot ${MYSQL_DATABASE_NAME}

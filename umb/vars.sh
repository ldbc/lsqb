pushd . > /dev/null
cd "$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%x}}" )" >/dev/null 2>&1 && pwd )"

export UMBRA_DATABASE_DIR=`pwd`/scratch/db/
export COMMON_SQL_DIR=`pwd`/../sql
export UMBRA_SQL_DIR=`pwd`/sql/
export UMBRA_SQL_SCRATCH_DIR=`pwd`/scratch/sql
export UMBRA_CONTAINER_NAME=lsqb-umb
export UMBRA_VERSION=e7415d13f
export UMBRA_DOCKER_IMAGE=umbra-release:${UMBRA_VERSION}

popd > /dev/null

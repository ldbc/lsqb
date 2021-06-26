export VIRTUOSO_VERSION=7.2-alpine
export VIRTUOSO_CONTAINER_NAME=lsqb-vos
export VIRTUOSO_USER="dba"
export VIRTUOSO_PWD="mysecret"
export VIRTUOSO_ENV="DBA_PASSWORD=${VIRTUOSO_PWD}"
export VIRTUOSO_DATABASE_DIR=`pwd`/vos/scratch/database
export VIRTUOSO_SETTINGS_DIR=`pwd`/vos/scratch/settings
export VIRTUOSO_QUERY_DIR=`pwd`/sparql

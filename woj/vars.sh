export JENA_VERSION='latest'
export JENA_CONTAINER_NAME=tsmb-woj
export JENA_USER="admin"
export JENA_PWD="mysecret"
export JENA_ENV1="ADMIN_PASSWORD=${JENA_PWD}"
export JENA_ENV2="JVM_ARGS='-Xmx64g -Xms12g -XX:MaxDirectMemorySize=2g'"
export JENA_DIR=`pwd`/woj
export JENA_DATABASE_DIR=`pwd`/woj/scratch
export JENA_QUERY_DIR=`pwd`/sparql



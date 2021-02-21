#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mem/vars.sh
. scripts/import-vars.sh

# initialize and cleanup Memgraph dirs
mkdir -p ${MEMGRAPH_DIR}/{lib,etc,log}
rm -rf ${MEMGRAPH_DIR}/{lib,etc,log}/*

# grab and load docker image if needed
docker image inspect memgraph:${MEMGRAPH_VERSION}-community > /dev/null
if [ $? -ne 0 ]; then
    curl https://download.memgraph.com/memgraph/v${MEMGRAPH_VERSION}/docker/memgraph-${MEMGRAPH_VERSION}-community-docker.tar.gz | docker load
fi

# copy CSVs to Docker volume
# remove leftover helpers
docker rm mg_import_helper
docker container create --name mg_import_helper --volume mg_import:/import-data busybox
for f in ${IMPORT_DIR}/*.csv; do
  docker cp $f mg_import_helper:/import-data
done
docker rm mg_import_helper

docker run \
  --volume mg_lib:/var/lib/memgraph \
  --volume mg_etc:/etc/memgraph \
  --volume mg_import:/import-data \
  --entrypoint=mg_import_csv \
  memgraph \
  --nodes=Forum=/import-data/Forum.csv \
  --nodes=Message=/import-data/message.csv \
  --nodes=Person=/import-data/Person.csv \
  --nodes=Tag=/import-data/Tag.csv \
  --relationships=FORUM_HAS_TAG=/import-data/Forum_hasTag_Tag.csv \
  --relationships=HAS_INTEREST=/import-data/Person_hasInterest_Tag.csv \
  --relationships=HAS_MEMBER=/import-data/Forum_hasMember_Person.csv \
  --relationships=KNOWS=/import-data/Person_knows_Person.csv \
  --relationships=LIKES=/import-data/Person_likes_message.csv \
  --relationships=MESSAGE_HAS_TAG=/import-data/message_hasTag_Tag.csv \
  --delimiter '|'

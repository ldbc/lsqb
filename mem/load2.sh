#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. mem/vars.sh
. scripts/import-vars.sh

# initialize and cleanup Memgraph dirs
mkdir -p ${MEMGRAPH_DIR}/{lib,etc,log}
rm -rf ${MEMGRAPH_DIR}/{lib,etc,log}/*

# copy CSVs to Docker volume
# remove leftover helpers
docker rm mg_import_helper || true
docker container create \
    --name mg_import_helper \
    --volume mg_import:/import-data:z \
    busybox

for f in ${IMPORT_DATA_DIR_PROJECTED_FK}/*.csv; do
  docker cp $f mg_import_helper:/import-data
done
docker rm mg_import_helper

docker run \
    --rm \
    --volume mg_lib:/var/lib/memgraph:z \
    --volume mg_etc:/etc/memgraph:z \
    --volume mg_import:/import-data:z \
    --entrypoint=mg_import_csv \
    memgraph/memgraph:${MEMGRAPH_VERSION} \
    --nodes=Continent="/import-data/Continent.csv" \
    --nodes=Country="/import-data/Country.csv" \
    --nodes=City="/import-data/City.csv" \
    --nodes=University="/import-data/University.csv" \
    --nodes=Company="/import-data/Company.csv" \
    --nodes=TagClass="/import-data/TagClass.csv" \
    --nodes=Tag="/import-data/Tag.csv" \
    --nodes=Forum="/import-data/Forum.csv" \
    --nodes=Person="/import-data/Person.csv" \
    --nodes=Message:Comment="/import-data/Comment.csv" \
    --nodes=Message:Post="/import-data/Post.csv" \
    --relationships=IS_PART_OF="/import-data/Country_isPartOf_Continent.csv" \
    --relationships=IS_PART_OF="/import-data/City_isPartOf_Country.csv" \
    --relationships=IS_SUBCLASS_OF="/import-data/TagClass_isSubclassOf_TagClass.csv" \
    --relationships=IS_LOCATED_IN="/import-data/University_isLocatedIn_City.csv" \
    --relationships=IS_LOCATED_IN="/import-data/Company_isLocatedIn_Country.csv" \
    --relationships=HAS_TYPE="/import-data/Tag_hasType_TagClass.csv" \
    --relationships=HAS_CREATOR="/import-data/Comment_hasCreator_Person.csv" \
    --relationships=IS_LOCATED_IN="/import-data/Comment_isLocatedIn_Country.csv" \
    --relationships=REPLY_OF="/import-data/Comment_replyOf_Comment.csv" \
    --relationships=REPLY_OF="/import-data/Comment_replyOf_Post.csv" \
    --relationships=CONTAINER_OF="/import-data/Forum_containerOf_Post.csv" \
    --relationships=HAS_MEMBER="/import-data/Forum_hasMember_Person.csv" \
    --relationships=HAS_MODERATOR="/import-data/Forum_hasModerator_Person.csv" \
    --relationships=HAS_TAG="/import-data/Forum_hasTag_Tag.csv" \
    --relationships=HAS_INTEREST="/import-data/Person_hasInterest_Tag.csv" \
    --relationships=IS_LOCATED_IN="/import-data/Person_isLocatedIn_City.csv" \
    --relationships=KNOWS="/import-data/Person_knows_Person.csv" \
    --relationships=LIKES="/import-data/Person_likes_Comment.csv" \
    --relationships=LIKES="/import-data/Person_likes_Post.csv" \
    --relationships=HAS_CREATOR="/import-data/Post_hasCreator_Person.csv" \
    --relationships=HAS_TAG="/import-data/Comment_hasTag_Tag.csv" \
    --relationships=HAS_TAG="/import-data/Post_hasTag_Tag.csv" \
    --relationships=IS_LOCATED_IN="/import-data/Post_isLocatedIn_Country.csv" \
    --relationships=STUDY_AT="/import-data/Person_studyAt_University.csv" \
    --relationships=WORK_AT="/import-data/Person_workAt_Company.csv" \
    --delimiter '|'

#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. neo/vars.sh
. scripts/import-vars.sh

# make sure directories exist
mkdir -p ${NEO4J_HOME}/{logs,import,plugins,metrics}

# start with a fresh data dir (required by the CSV importer)
mkdir -p ${NEO4J_DATA_DIR}
rm -rf ${NEO4J_DATA_DIR}/*

docker run \
    --rm \
    --publish=7474:7474 \
    --publish=7687:7687 \
    --volume=${NEO4J_DATA_DIR}:/data:z \
    --volume=${NEO4J_HOME}/logs:/logs:z \
    --volume=${IMPORT_DATA_DIR_PROJECTED_FK}:/import:z \
    ${NEO4J_ENV_VARS} \
    neo4j:${NEO4J_VERSION} \
    neo4j-admin database import full \
    --id-type=INTEGER \
    --nodes=Continent="/import/Continent.csv" \
    --nodes=Country="/import/Country.csv" \
    --nodes=City="/import/City.csv" \
    --nodes=University="/import/University.csv" \
    --nodes=Company="/import/Company.csv" \
    --nodes=TagClass="/import/TagClass.csv" \
    --nodes=Tag="/import/Tag.csv" \
    --nodes=Forum="/import/Forum.csv" \
    --nodes=Person="/import/Person.csv" \
    --nodes=Message:Comment="/import/Comment.csv" \
    --nodes=Message:Post="/import/Post.csv" \
    --relationships=IS_PART_OF="/import/Country_isPartOf_Continent.csv" \
    --relationships=IS_PART_OF="/import/City_isPartOf_Country.csv" \
    --relationships=IS_SUBCLASS_OF="/import/TagClass_isSubclassOf_TagClass.csv" \
    --relationships=IS_LOCATED_IN="/import/University_isLocatedIn_City.csv" \
    --relationships=IS_LOCATED_IN="/import/Company_isLocatedIn_Country.csv" \
    --relationships=HAS_TYPE="/import/Tag_hasType_TagClass.csv" \
    --relationships=HAS_CREATOR="/import/Comment_hasCreator_Person.csv" \
    --relationships=IS_LOCATED_IN="/import/Comment_isLocatedIn_Country.csv" \
    --relationships=REPLY_OF="/import/Comment_replyOf_Comment.csv" \
    --relationships=REPLY_OF="/import/Comment_replyOf_Post.csv" \
    --relationships=CONTAINER_OF="/import/Forum_containerOf_Post.csv" \
    --relationships=HAS_MEMBER="/import/Forum_hasMember_Person.csv" \
    --relationships=HAS_MODERATOR="/import/Forum_hasModerator_Person.csv" \
    --relationships=HAS_TAG="/import/Forum_hasTag_Tag.csv" \
    --relationships=HAS_INTEREST="/import/Person_hasInterest_Tag.csv" \
    --relationships=IS_LOCATED_IN="/import/Person_isLocatedIn_City.csv" \
    --relationships=KNOWS="/import/Person_knows_Person.csv" \
    --relationships=LIKES="/import/Person_likes_Comment.csv" \
    --relationships=LIKES="/import/Person_likes_Post.csv" \
    --relationships=HAS_CREATOR="/import/Post_hasCreator_Person.csv" \
    --relationships=HAS_TAG="/import/Comment_hasTag_Tag.csv" \
    --relationships=HAS_TAG="/import/Post_hasTag_Tag.csv" \
    --relationships=IS_LOCATED_IN="/import/Post_isLocatedIn_Country.csv" \
    --relationships=STUDY_AT="/import/Person_studyAt_University.csv" \
    --relationships=WORK_AT="/import/Person_workAt_Company.csv" \
    --delimiter '|'

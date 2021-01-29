#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

set -e

. scripts/neo-vars.sh
. scripts/import-vars.sh

# make sure Neo4j is stopped
scripts/stop-neo.sh

# make sure directories exist
mkdir -p ${NEO4J_HOME}/{logs,import,plugins}

# start with a fresh data dir (required by the CSV importer)
mkdir -p ${NEO4J_DATA_DIR}
rm -rf ${NEO4J_DATA_DIR}/*

docker run --rm \
    --user="$(id -u):$(id -g)" \
    --publish=17474:7474 \
    --publish=17687:7687 \
    --volume=${NEO4J_DATA_DIR}:/data \
    --volume=${IMPORT_DIR}:/import \
    ${NEO4J_ENV_VARS} \
    neo4j:${NEO4J_VERSION} \
    neo4j-admin import \
    --nodes=Place="/import/place.csv" \
    --nodes=Organisation="/import/organisation.csv" \
    --nodes=TagClass="/import/tagclass.csv" \
    --nodes=Tag="/import/tag.csv" \
    --nodes=Forum="/import/forum.csv" \
    --nodes=Person="/import/person.csv" \
    --nodes=Message:Comment="/import/comment.csv" \
    --nodes=Message:Post="/import/post.csv" \
    --relationships=IS_PART_OF="/import/place_isPartOf_place.csv" \
    --relationships=IS_SUBCLASS_OF="/import/tagclass_isSubclassOf_tagclass.csv" \
    --relationships=IS_LOCATED_IN="/import/organisation_isLocatedIn_place.csv" \
    --relationships=HAS_TYPE="/import/tag_hasType_tagclass.csv" \
    --relationships=HAS_CREATOR="/import/comment_hasCreator_person.csv" \
    --relationships=IS_LOCATED_IN="/import/comment_isLocatedIn_place.csv" \
    --relationships=REPLY_OF="/import/comment_replyOf_comment.csv" \
    --relationships=REPLY_OF="/import/comment_replyOf_post.csv" \
    --relationships=CONTAINER_OF="/import/forum_containerOf_post.csv" \
    --relationships=HAS_MEMBER="/import/forum_hasMember_person.csv" \
    --relationships=HAS_MODERATOR="/import/forum_hasModerator_person.csv" \
    --relationships=HAS_TAG="/import/forum_hasTag_tag.csv" \
    --relationships=HAS_INTEREST="/import/person_hasInterest_tag.csv" \
    --relationships=IS_LOCATED_IN="/import/person_isLocatedIn_place.csv" \
    --relationships=KNOWS="/import/person_knows_person.csv" \
    --relationships=LIKES="/import/person_likes_comment.csv" \
    --relationships=LIKES="/import/person_likes_post.csv" \
    --relationships=HAS_CREATOR="/import/post_hasCreator_person.csv" \
    --relationships=HAS_TAG="/import/comment_hasTag_tag.csv" \
    --relationships=HAS_TAG="/import/post_hasTag_tag.csv" \
    --relationships=IS_LOCATED_IN="/import/post_isLocatedIn_place.csv" \
    --relationships=STUDY_AT="/import/person_studyAt_organisation.csv" \
    --relationships=WORK_AT="/import/person_workAt_organisation.csv" \
    --delimiter '|'

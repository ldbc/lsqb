#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. red/vars.sh
. scripts/import-vars.sh

redisgraph-bulk-insert \
    SocialGraph \
    --enforce-schema \
    --nodes-with-label Continent "${IMPORT_DATA_DIR_PROJECTED_FK}/Continent.csv" \
    --nodes-with-label Country "${IMPORT_DATA_DIR_PROJECTED_FK}/Country.csv" \
    --nodes-with-label City "${IMPORT_DATA_DIR_PROJECTED_FK}/City.csv" \
    --nodes-with-label University "${IMPORT_DATA_DIR_PROJECTED_FK}/University.csv" \
    --nodes-with-label Company "${IMPORT_DATA_DIR_PROJECTED_FK}/Company.csv" \
    --nodes-with-label TagClass "${IMPORT_DATA_DIR_PROJECTED_FK}/TagClass.csv" \
    --nodes-with-label Tag "${IMPORT_DATA_DIR_PROJECTED_FK}/Tag.csv" \
    --nodes-with-label Forum "${IMPORT_DATA_DIR_PROJECTED_FK}/Forum.csv" \
    --nodes-with-label Person "${IMPORT_DATA_DIR_PROJECTED_FK}/Person.csv" \
    --nodes-with-label Comment "${IMPORT_DATA_DIR_PROJECTED_FK}/Comment.csv" \
    --nodes-with-label Post "${IMPORT_DATA_DIR_PROJECTED_FK}/Post.csv" \
    --relations-with-type IS_PART_OF "${IMPORT_DATA_DIR_PROJECTED_FK}/Country_isPartOf_Continent.csv" \
    --relations-with-type IS_PART_OF "${IMPORT_DATA_DIR_PROJECTED_FK}/City_isPartOf_Country.csv" \
    --relations-with-type IS_LOCATED_IN "${IMPORT_DATA_DIR_PROJECTED_FK}/Company_isLocatedIn_Country.csv" \
    --relations-with-type IS_LOCATED_IN "${IMPORT_DATA_DIR_PROJECTED_FK}/University_isLocatedIn_City.csv" \
    --relations-with-type IS_SUBCLASS_OF "${IMPORT_DATA_DIR_PROJECTED_FK}/TagClass_isSubclassOf_TagClass.csv" \
    --relations-with-type HAS_TYPE "${IMPORT_DATA_DIR_PROJECTED_FK}/Tag_hasType_TagClass.csv" \
    --relations-with-type HAS_CREATOR "${IMPORT_DATA_DIR_PROJECTED_FK}/Comment_hasCreator_Person.csv" \
    --relations-with-type IS_LOCATED_IN "${IMPORT_DATA_DIR_PROJECTED_FK}/Comment_isLocatedIn_Country.csv" \
    --relations-with-type REPLY_OF "${IMPORT_DATA_DIR_PROJECTED_FK}/Comment_replyOf_Comment.csv" \
    --relations-with-type REPLY_OF "${IMPORT_DATA_DIR_PROJECTED_FK}/Comment_replyOf_Post.csv" \
    --relations-with-type CONTAINER_OF "${IMPORT_DATA_DIR_PROJECTED_FK}/Forum_containerOf_Post.csv" \
    --relations-with-type HAS_MEMBER "${IMPORT_DATA_DIR_PROJECTED_FK}/Forum_hasMember_Person.csv" \
    --relations-with-type HAS_MODERATOR "${IMPORT_DATA_DIR_PROJECTED_FK}/Forum_hasModerator_Person.csv" \
    --relations-with-type HAS_TAG "${IMPORT_DATA_DIR_PROJECTED_FK}/Forum_hasTag_Tag.csv" \
    --relations-with-type HAS_INTEREST "${IMPORT_DATA_DIR_PROJECTED_FK}/Person_hasInterest_Tag.csv" \
    --relations-with-type IS_LOCATED_IN "${IMPORT_DATA_DIR_PROJECTED_FK}/Person_isLocatedIn_City.csv" \
    --relations-with-type KNOWS "${IMPORT_DATA_DIR_PROJECTED_FK}/Person_knows_Person.csv" \
    --relations-with-type LIKES "${IMPORT_DATA_DIR_PROJECTED_FK}/Person_likes_Comment.csv" \
    --relations-with-type LIKES "${IMPORT_DATA_DIR_PROJECTED_FK}/Person_likes_Post.csv" \
    --relations-with-type HAS_CREATOR "${IMPORT_DATA_DIR_PROJECTED_FK}/Post_hasCreator_Person.csv" \
    --relations-with-type HAS_TAG "${IMPORT_DATA_DIR_PROJECTED_FK}/Comment_hasTag_Tag.csv" \
    --relations-with-type HAS_TAG "${IMPORT_DATA_DIR_PROJECTED_FK}/Post_hasTag_Tag.csv" \
    --relations-with-type IS_LOCATED_IN "${IMPORT_DATA_DIR_PROJECTED_FK}/Post_isLocatedIn_Country.csv" \
    --relations-with-type STUDY_AT "${IMPORT_DATA_DIR_PROJECTED_FK}/Person_studyAt_University.csv" \
    --relations-with-type WORK_AT "${IMPORT_DATA_DIR_PROJECTED_FK}/Person_workAt_Company.csv" \
    --separator '|'

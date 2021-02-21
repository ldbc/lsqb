#!/bin/bash

set -e
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. red/vars.sh
. scripts/import-vars.sh

redisgraph-bulk-loader \
    SocialGraph \
    --enforce-schema \
    --nodes-with-label Continent "data/social-network-${SF}-preprocessed/Continent.csv" \
    --nodes-with-label Country "data/social-network-${SF}-preprocessed/Country.csv" \
    --nodes-with-label City "data/social-network-${SF}-preprocessed/City.csv" \
    --nodes-with-label University "data/social-network-${SF}-preprocessed/University.csv" \
    --nodes-with-label Company "data/social-network-${SF}-preprocessed/Company.csv" \
    --nodes-with-label TagClass "data/social-network-${SF}-preprocessed/TagClass.csv" \
    --nodes-with-label Tag "data/social-network-${SF}-preprocessed/Tag.csv" \
    --nodes-with-label Forum "data/social-network-${SF}-preprocessed/Forum.csv" \
    --nodes-with-label Person "data/social-network-${SF}-preprocessed/Person.csv" \
    --nodes-with-label Comment "data/social-network-${SF}-preprocessed/Comment.csv" \
    --nodes-with-label Post "data/social-network-${SF}-preprocessed/Post.csv" \
    --relations-with-type IS_PART_OF "data/social-network-${SF}-preprocessed/Country_isPartOf_Continent.csv" \
    --relations-with-type IS_PART_OF "data/social-network-${SF}-preprocessed/City_isPartOf_Country.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-preprocessed/Company_isLocatedIn_Country.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-preprocessed/University_isLocatedIn_City.csv" \
    --relations-with-type IS_SUBCLASS_OF "data/social-network-${SF}-preprocessed/TagClass_isSubclassOf_TagClass.csv" \
    --relations-with-type HAS_TYPE "data/social-network-${SF}-preprocessed/Tag_hasType_TagClass.csv" \
    --relations-with-type HAS_CREATOR "data/social-network-${SF}-preprocessed/Comment_hasCreator_Person.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-preprocessed/Comment_isLocatedIn_Place.csv" \
    --relations-with-type REPLY_OF "data/social-network-${SF}-preprocessed/Comment_replyOf_Comment.csv" \
    --relations-with-type REPLY_OF "data/social-network-${SF}-preprocessed/Comment_replyOf_Post.csv" \
    --relations-with-type CONTAINER_OF "data/social-network-${SF}-preprocessed/Forum_containerOf_Post.csv" \
    --relations-with-type HAS_MEMBER "data/social-network-${SF}-preprocessed/Forum_hasMember_Person.csv" \
    --relations-with-type HAS_MODERATOR "data/social-network-${SF}-preprocessed/Forum_hasModerator_Person.csv" \
    --relations-with-type HAS_TAG "data/social-network-${SF}-preprocessed/Forum_hasTag_Tag.csv" \
    --relations-with-type HAS_INTEREST "data/social-network-${SF}-preprocessed/Person_hasInterest_Tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-preprocessed/Person_isLocatedIn_Place.csv" \
    --relations-with-type KNOWS "data/social-network-${SF}-preprocessed/Person_knows_Person.csv" \
    --relations-with-type LIKES "data/social-network-${SF}-preprocessed/Person_likes_Comment.csv" \
    --relations-with-type LIKES "data/social-network-${SF}-preprocessed/Person_likes_Post.csv" \
    --relations-with-type HAS_CREATOR "data/social-network-${SF}-preprocessed/Post_hasCreator_Person.csv" \
    --relations-with-type HAS_TAG "data/social-network-${SF}-preprocessed/Comment_hasTag_Tag.csv" \
    --relations-with-type HAS_TAG "data/social-network-${SF}-preprocessed/Post_hasTag_Tag.csv" \
    --relations-with-type IS_LOCATED_IN "data/social-network-${SF}-preprocessed/Post_isLocatedIn_Place.csv" \
    --relations-with-type STUDY_AT "data/social-network-${SF}-preprocessed/Person_studyAt_University.csv" \
    --relations-with-type WORK_AT "data/social-network-${SF}-preprocessed/Person_workAt_Company.csv" \
    --separator '|'

